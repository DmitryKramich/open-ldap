#!/bin/bash

sudo yum install -y openldap-clients nss-pam-ldapd
sudo authconfig --enableldap --enableldapauth --ldapserver=${ldap_ip} --ldapbasedn="dc=devopsldab,dc=com" --enablemkhomedir --update
sudo sed -i 's/127.0.0.1/'${ldap_ip}'/' /etc/nslcd.conf

sudo cat > /opt/ssh_ldap.sh <<EOF
#!/bin/bash
set -eou pipefail
IFS=$'\n\t'
result=\$(ldapsearch -x '(&(objectClass=posixAccount)(uid='"\$1"'))' 'sshPublicKey')
attrLine=\$(echo "\$result" | sed -n '/^ /{H;d};/sshPublicKey:/x;\$g;s/\n *//g;/sshPublicKey:/p')
if [[ "\$attrLine" == sshPublicKey::* ]]; then
  echo "\$attrLine" | sed 's/sshPublicKey:: //' | base64 -d
elif [[ "\$attrLine" == sshPublicKey:* ]]; then
  echo "\$attrLine" | sed 's/sshPublicKey: //'
else
  exit 1
fi
EOF

chmod +x /opt/ssh_ldap.sh

echo "AuthorizedKeysCommand /opt/ssh_ldap.sh" >> /etc/ssh/ssh_config
echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/ssh_config
sed -i '/PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd


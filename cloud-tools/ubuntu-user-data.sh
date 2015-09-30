#!/bin/bash
#
# Setup an Ubuntu VM with the OpenStack Cloud Tools

apt-get update -y
clients='nova
neutron
glance
heat
cinder
swift
monasca
designate
openstack
keystone'

for n in ${clients}
do
 apt-get install python-${n}client  -y
done

echo "`ip addr show eth0 | awk '/ inet / {print $2}' | cut -d\/ -f1`  `hostname`" >> /etc/hosts

user=`ls /home | head -1`
cat > /home/$user/openrc.sh <<EOF
#!/bin/bash
export OS_AUTH_URL=http://10.1.64.17:5000/v2.0
export OS_TENANT_NAME=class
export OS_PROJECT_NAME=\${OS_TENANT_NAME}
echo "Please enter your OpenStack Username: "
read -r OS_USER_INPUT
export OS_USERNAME=\$OS_USER_INPUT
echo "You set your User Name to: \${OS_USERNAME}"
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=\$OS_PASSWORD_INPUT
export PS1='[\u@\h \W(os_class)]\$ '
EOF
chown $user.$user openrc.sh
chmod +x openrc.sh

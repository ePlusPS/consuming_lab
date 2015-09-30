#!/bin/bash
#
# Setup an Ubuntu VM with the OpenStack Cloud Tools
# http://50.250.253.88:8080/v1/AUTH_e71d06beb59a40d1a9e29df6b014444e/osbootcamp/ubuntu-user-data.sh

#apt-get update -y
yum update -y

yum install python-setuptools python-devel -y
yum groupinstall "@Development tools" -y
yum install libffi-devel openssl-devel -y

easy_install pip

clients='nova
neutron
glance
heat
swift
monasca
designate
openstack
keystone'

for n in ${clients}
do
 pip install python-${n}client
done

easy_install --upgrade requests[security]


echo "`ip addr show eth0 | awk '/ inet / {print $2}' | cut -d\/ -f1`  `hostname`" >> /etc/hosts
user=`ls /home | head -1`
cat > /home/$user/openrc.sh <<EOF
#!/bin/bash

export OS_AUTH_URL=https://10.1.64.17:5000/v2.0
export OS_TENANT_NAME=class
export OS_PROJECT_NAME=\${OS_TENANT_NAME}
echo "Please enter your OpenStack Username: "
read -r OS_USER_INPUT
export OS_USERNAME=\$OS_USER_INPUT
echo "You set your User Name to: \${OS_USERNAME}"
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=\$OS_PASSWORD_INPUT

# If your configuration has multiple regions, we set that information here.
# OS_REGION_NAME is optional and only valid in certain environments.
export OS_REGION_NAME="RegionOne"
echo "Your region is set to \${OS_REGION_NAME}"

export PS1='[\u@\h \W(os_class)]\$ '
EOF
chown $user.$user openrc.sh
chmod +x openrc.sh

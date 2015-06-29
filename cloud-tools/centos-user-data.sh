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

pip install python-cinderclient==1.1.1
easy_install --upgrade requests[security]


echo "`ip addr show eth0 | awk '/ inet / {print $2}' | cut -d\/ -f1`  `hostname`" >> /etc/hosts
user=`ls /home | head -1`
cat > /home/$user/openrc_first.sh <<EOF
#!/bin/bash

# To use an OpenStack cloud you need to authenticate against the Identity
# service named keystone, which returns a **Token** and **Service Catalog**.
# The catalog contains the endpoints for all services the user/tenant has
# access to - such as Compute, Image Service, Identity, Object Storage, Block
# Storage, and Networking (code-named nova, glance, keystone, swift,
# cinder, and neutron).
#
# *NOTE*: Using the 2.0 *Identity API* does not necessarily mean any other
# OpenStack API is version 2.0. For example, your cloud provider may implement
# Image API v1.1, Block Storage API v2, and Compute API v2.0. OS_AUTH_URL is
# only for the Identity API served through keystone.
export OS_AUTH_URL=https://chrcnc-api.os.cloud.twc.net:5000/v2.0

# With the addition of Keystone we have standardized on the term **tenant**
# as the entity that owns the resources.  We really only need the Tenant Name
# export OS_TENANT_ID=88d8c5d66153476d9d96ca98df9b0894
echo "Please enter your OpenStack Tenant Name: "
read -r OS_TENANT_INPUT
export OS_TENANT_NAME=\$OS_TENANT_INPUT
echo "You set your Tenant Name to: \${OS_TENANT_NAME}"
export OS_PROJECT_NAME=\$OS_TENANT_INPUT

export OS_PROJECT_NAME=\${OS_TENANT_NAME}

# In addition to the owning entity (tenant), OpenStack stores the entity
# performing the action as the **user**.
echo "Please enter your OpenStack Username: "
read -r OS_USER_INPUT
export OS_USERNAME=\$OS_USER_INPUT
echo "You set your User Name to: \${OS_USERNAME}"

# With Keystone you pass the keystone password.
echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=\$OS_PASSWORD_INPUT

# If your configuration has multiple regions, we set that information here.
# OS_REGION_NAME is optional and only valid in certain environments.
export OS_REGION_NAME="NCE"
echo "Your region is set to \${OS_REGION_NAME}"

export PS1='[\u@\h \W(nce)]\$ '
cat > /home/$user/openrc.sh <<EOD
#!/bin/bash
export OS_AUTH_URL=https://chrcnc-api.os.cloud.twc.net:5000/v2.0
export OS_TENANT_NAME="\${OS_TENANT_NAME}"
export OS_PROJECT_NAME="\${OS_TENANT_NAME}"
export OS_USERNAME="\${OS_USERNAME}"
export OS_REGION_NAME="NCE"

echo "Please enter your OpenStack Password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=\\\$OS_PASSWORD_INPUT
export PS1='[\u@\h \W(nce)]\$ '
EOD

cat <<EOE
Now you can source the openrc.sh script as in:

  source ~/openrc.sh

At the begining of your sessions, and the system will prompt you for your password.

You can then run commands like:

  nova list

EOE

EOF

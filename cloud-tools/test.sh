#!/bin/bash
set -ex 

vmname=${1:-admin}
keyname=${2:-class2}
netname=${3:-private}
cat > data.txt <<EOD
#!/bin/bash
passwd ubuntu <<EOF
ubuntu
ubuntu
EOF

cat > test.htm <<EOF
done
EOF

python -m SimpleHTTPServer 80
EOD

floatingip=`nova floating-ip-create sixtyfour | awk '/sixtyfour/ {print $2}'`
net_id=`neutron net-list | grep ${netname} | awk '/ | / {print $2}'`
nova boot ${vmname} --image trusty --flavor m1.small --key-name ${keyname} --nic net-id=${net_id} --config-drive True --user-data ./data.txt

until [[ `nova list | grep ${vmname}` =~ ACTIVE ]]; do
 echo 'waiting for ACTIVE'
 sleep 5
done

nova floating-ip-associate ${vmname} ${floatingip}

until [[ $(wget -t 5 -T 5 -qO - http://${floatingip}/test.htm) =~ done ]]
 do echo not done
 sleep 5
done

echo "Test is $(wget -t 5 -T 5 -qO - http://${floatingip}/test.htm)"

nova delete ${vmname}
nova floating-ip-delete ${floatingip}

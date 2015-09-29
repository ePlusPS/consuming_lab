#!/bin/bash

vmname=${1:-admin}
keyname=${2:-class2}
floatingip=${3:-10.1.64.32}

cat > data.txt <<EOF
#!/bin/bash
passwd ubuntu <<EOF
ubuntu
ubuntu
EOF

cat > test.htm <<EOF
done
EOF

python -m SimpleHTTPServer 80
EOF

nova boot ${vmname} --image trusty --flavor m1.small --key-name ${keyname} --nic net-id=47ea0f46-5728-4a22-bab7-1417a21539fd --config-drive True --user-data ./data.txt
nova floating-ip-associate admin ${floatingip}

test=''
until [[ $(wget -qO - http://${floatingip}/test.htm) =~ done ]]
 do echo not done
 sleep 5
done

echo "Test is $(wget -qO - http://${floatingip}/test.htm)"

nova delete ${vmname}

#!/bin/bash
#swift_temp.sh

cat >> class_test_file.txt <<EOF
This is a simple test file for Swift to validate
that ${OS_USERNAME} was able to grab a document
from a temporary URL.
EOF

swift upload lab_container class_test_file.txt  --header X-Delete-After:60
swift post -m "Temp-URL-Key:my_own_secret"
temp_url=`swift tempurl GET 100 /v1/KEY_${OS_TENANT_ID}/lab_container/class_test_file.txt my_own_secret`
wget -O - "https://chrcnc-api.os.cloud.twc.net${temp_url}"
rm class_test_file.txt
echo ""
echo "sleeping for 45 seconds"
sleep 45
echo "first test"
swift list lab_container
wget -O - "https://chrcnc-api.os.cloud.twc.net${temp_url}"
echo "sleeping for another 45 seconds, container should be empty"
sleep 45
swift list lab_container
wget -O - "https://chrcnc-api.os.cloud.twc.net${temp_url}"

exit 0

#!/bin/bash
if [ "${OS_REGION_NAME}" != "NCE" ]; then
	echo "this script expect to pull from NCE and write to NCW"
	exit 1
fi
for n in `nova keypair-list | grep -v Fingerprint | awk '/ \| / {print $2}' `; do
	nova keypair-show ${n} | grep Public | sed -e 's/Public key: //' > ${n}.pub
	if [ `nova --os-region-name NCW keypair-show ${n} >& /dev/null; echo $?` -eq 0 ]; then
		nova --os-region-name NCW keypair-delete ${n}
		nova --os-region-name NCW keypair-add --pub-key ${n}.pub ${n}
	else
		nova --os-region-name NCW keypair-add --pub-key ${n}.pub ${n}
	fi
	rm ${n}.pub
done

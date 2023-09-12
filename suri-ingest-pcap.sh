#!/usr/bin/env bash

SESSION_USER=$(logname)
LOG_PATH=/tmp/suricata/
PCAPFILE=$1

if [ -z $PCAPFILE ] || [ ! -f $PCAPFILE ]; then
    echo "File ${PCAPFILE} doesnt seem to be there - please supply a pcap file."
    exit 1;
fi

# make sure log path exists
mkdir -p $LOG_PATH

# clean up suri logs
rm -rf $LOG_PATH/*

## process pcap
suricata -c /etc/suricata/suricata.yaml -k none -r $1 -l $LOG_PATH -s "/home/pslearner/custom.rules"

#print out alerts
echo -e "\n[*] Alerts:\n"
grep '"event_type":"alert"' /tmp/suricata/eve.json  |jq '"\(.timestamp) | \(.alert.gid):\(.alert.signature_id):\(.alert.rev) | \(.alert.signature) | \(.alert.category) | \(.src_ip):\(.src_port) -> \(.dest_ip):\(.dest_port)"'
echo -e "\n[*] Temporary logs can be found at $LOG_PATH"

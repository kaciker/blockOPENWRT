#!/bin/sh

IPSET_NAME="permitidas"

ipset flush $IPSET_NAME
for ip in $(uci show ipset_allowlist | grep ".ip=" | cut -d"'" -f2); do
    ipset add $IPSET_NAME $ip
done

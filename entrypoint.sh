#!/bin/bash

# get SNORT_INTERFACE from environment or assign default
if [ -z "$SNORT_INTERFACE" ]; then
    SNORT_INTERFACE=eth0
fi

/usr/local/snort/bin/snort -D -c /etc/snort/snort.lua --daq-dir /usr/local/lib/daq_s3/lib/daq -i $SNORT_INTERFACE -A Full -l /var/log/snort
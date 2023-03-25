#!/bin/bash

# This utility gets information from the F9P GNSS device until the number of satellites
# becomes satisfaying (first parameter i.e. autobase.sh 29 for 29 satellites).
# Then, it grabs the portable GNSS base WGS84 coordinates and launches the RTK base services.

echo "############# Setting local GNSS RTK base location ################"
echo "############# Setting local GNSS RTK base location ################" >> /home/basegnss/rtkbase/autobase.log

echo ""
echo "" >> /home/basegnss/rtkbase/autobase.log

date
date >> /home/basegnss/rtkbase/autobase.log

# Stops the RTKlib services to free up the serial device

echo "Stopping RTKLIB services..."
echo "Stopping RTKLIB services..." >> /home/basegnss/rtkbase/autobase.log

echo ""
echo "" >> /home/basegnss/rtkbase/autobase.log

sudo systemctl stop str2str_tcp.service

sudo systemctl stop str2str_rtcm_svr.service

sudo systemctl stop str2str_local_ntrip_caster.service

cd /home/basegnss/rtkbase

NBSAT=0

echo "Searching for GNSS satellites..."
echo "Searching for GNSS satellites..." >> /home/basegnss/rtkbase/autobase.log

while [ $NBSAT -lt $1 ]; do

    sleep 1
    ./tools/ubxtool -f /dev/ttyACM0 | grep numSV | awk 'NR > 1 { exit }; 1' > ubxpos.txt
    NBSAT=$(awk '{print $2}' ubxpos.txt) 
    echo "Found:" $NBSAT
    echo "Found:" $NBSAT >> /home/basegnss/rtkbase/autobase.log

done

echo "Number of satellites is OK !"
echo "Number of satellites is OK !" >> /home/basegnss/rtkbase/autobase.log

echo ""
echo "" >> /home/basegnss/rtkbase/autobase.log

LON=$(awk '{print $4}' ubxpos.txt)
LON=$(echo "scale=6; $LON/10000000" | bc) 

LAT=$(awk '{print $6}' ubxpos.txt) 
LAT=$(echo "scale=6; $LAT/10000000" | bc) 

ALT=$(awk '{print $8}' ubxpos.txt) 
ALT=$(echo "scale=3; $ALT/1000" | bc)


echo "Got RTK base location :"
echo "Got RTK base location :" >> /home/basegnss/rtkbase/autobase.log

echo LAT: $LAT  LON: $LON  ALT: $ALT m
echo LAT: $LAT  LON: $LON  ALT: $ALT m >> /home/basegnss/rtkbase/autobase.log

sed -i "/position=/c\position='$LAT $LON $ALT'" settings.conf

echo ""
echo "" >> /home/basegnss/rtkbase/autobase.log

echo "Launches RTKLIB services with new base location..."
echo "Launches RTKLIB services with new base location..." >> /home/basegnss/rtkbase/autobase.log

echo ""
echo "" >> /home/basegnss/rtkbase/autobase.log

sudo systemctl restart str2str_tcp.service

sudo systemctl restart str2str_rtcm_svr.service

sudo systemctl restart str2str_local_ntrip_caster.service


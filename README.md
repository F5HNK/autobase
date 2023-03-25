# autobase
An automatic location setting script for a portable GNSS RTK base
- SSH to the Raspberry using user : basegnss and passwd : basegnss!
- Copy the file named "autobase.sh" to /home/basegnss/rtkbase
  - You can try out the script by cd /home/basegnss/rtkbase then  ./autobase.sh 25   (for 25 sats before fix)
- In order to get the script launched at startup, copy the file named "autobase" to  /etc/init.d/   (use sudo)
- Change file properties with  sudo chmod +x autobase
- Activate the new service by  sudo update-rc.d autobase defaults
- Then you can reboot the BaseGNSS Raspberry
- After a couple of minutes, check the base status  with  tail -f /home/basegnss/rtkbase/autobase.log
- The number of satellites is defaulted to 28 in the /etc/init.d/autobase script, this can be editted
- Only 3 services are activated in the Centipede Raspberry :
  - Main service           (takes in charge the F9P GNSS device)
  - Ntrip Caster service   ( which is you own NTRIP service)
  - Rtcm tcp service       (which is the RTCM stream over TCP)
- Neither Ntrip A service or Ntrip B service should be activated as the portable GNSS base should not be broadcasted
- Your local RTK application should connect to your own NTRIP or RTCM TCP server

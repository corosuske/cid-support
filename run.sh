#!/bin/bash

VERSION=1.8.0
NOW=$(TZ="Europe/Brussels" date +"%d-%m-%y %T")
/opt/java/bin/java -classpath pi-${VERSION}.jar be.uitpas.pi.FileSystemCheckClient > /tmp/cid.log 2>&1   &

/opt/java/bin/java -Dcom.sun.management.jmxremote.port=1234 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dsun.security.smartcardio.library=/usr/lib/arm-linux-gnueabihf/libpcsclite.so.1 -jar pi-${VERSION}.jar > /tmp/cid.log 2>&1  &


# clean the screen
clear

#inform the user
echo " "
echo "         starting the CID APP"
echo "            Please wait"
echo "            een ogenblik geduld AUB"
echo -n "            Version: "
echo ${VERSION}
echo -n "                Cable IP:"
ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'

if ifconfig -a  | grep -iq wlan0
then
  echo "                   wifi found"
  ESSID=$(iwconfig wlan0 | head -n1 | cut -d " " -f 9)
  if iwconfig wlan0 | grep -iq off
  then
    echo -n "                     " 
    echo ${ESSID}
  else
    echo "                     WIFI NOT CONNECTED"
  fi
else
 echo "no wifi card"
fi



if [ -f /dev/wlan0 ];
        then
                echo -n"    wifi IP:"
                ifconfig wlan0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'
        fi
echo -n "                TIME:"
echo ${NOW}


sleep 60



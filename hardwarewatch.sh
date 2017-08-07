#!/bin/bash
source /home/pi/cid.config


status=$(lsusb | grep 072f:2200 | wc -l)
upseconds=$(cat /proc/uptime | grep -o '^[0-9]\+')
dmesgwatch=$(dmesg | grep disconnect | wc -l)
DATE="`date +%s`000"
NAME=$(hostname)
LOGSPACE=$(df -k /tmp/  |grep tmpfs|  awk -v col=4 '{print $col}')
READERDETECT=$(dmesg | grep "New USB device found, idVendor=072f, idProduct=2200" | wc -l)
PREVREADER=$(cat /tmp/READERDETECT)
JAVASTATUS=$(jps -l | wc -l)
KEYBOARDDETECT=$(lsusb -v | grep -i key |wc -l)

uptime=$(</proc/uptime)
uptime=${uptime%%.*}

seconds=$(( uptime%60 ))
minutes=$(( uptime/60%60 ))
hours=$(( uptime/60/60%24 ))
days=$(( uptime/60/60/24 ))


## tell the monitoring server how long we've been up 
curl -X POST -d "cid=${key}&host=${name}&level=FINER&type=LOG&date=${DATE}&message=uptime is ${days} days, ${hours} hours, ${minutes} minutes, ${seconds} seconds" "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
 
echo $key
echo $secret


#curl -X POST -d "cid=${key}&host=${name}&level=INFO&type=LOG&date=${DATE}&message=hardware looks OK" "http://cidmonitor.lodgon.com/pimonitor/rest/m$
##make sure this script does not run before the hardware has a chance to settle
if [ $upseconds -le 60 ]
        then
                echo "up for less than 1 min"
                exit 0
fi



#check if the cardreader is present 
if [ $status -ne 1 ]
        then
                echo "no usb reader detected"
                curl -X POST -d "cid=${key}&host=${name}&level=SEVERE&type=LOG&date=${DATE}&message=NO NFC reader connected" "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
        fi


##detect disconnections of the Usb reader
if (($READERDETECT > $PREVREADER))
       then
                echo "usb cardreader detected multiple times "
                echo $READERDETECT > /tmp/READERDETECT
                curl -X POST -d "cid=${key}&host=${name}&level=SEVERE&type=LOG&date=${DATE}&message=NFC reader disconnected and reconnected" "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
fi



##empty the logfile if the space on the tmp partitie is growing small
if [ $LOGSPACE -le 1028 ]
        then
                echo > /tmp/cid.log
        fi


## check if the java app is running
if [ $JAVASTATUS -le 1 ]
        then
                if [ $KEYBOARDDETECT -ge 2 ]
                        then
                                curl -X POST -d "cid=${key}&host=${name}&level=SEVERE&type=LOG&date=${DATE}&message=java app not STARTED, keyboard detected" "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
                        else
                                curl -X POST -d "cid=${key}&host=${name}&level=SEVERE&type=LOG&date=${DATE}&message=JAVA app not running, trying to restart" "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
                                echo "trying to restart only java apps" | wall
                                killall java
                                sleep 5
                                /home/pi/run.sh
                fi
        fi


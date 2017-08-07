##############################################################################################
##this script  runs at starup of the CID's 
## it tries it's best to configure an internet connection and get the SIXXS tunnel started
## the sixxs tunnel is also checked every 30 minutes (via cron) 
##  priority is givven to a internet connection via cable
## if no cable is plugged in it should try and get the wifi configured 
## in order to change the wifi setting you should change the file /etc/network/interfaces
## there should be 2 examples there .. one wpa and one WEP  
## obviously it will also start the checkin aplication 
##############################################################################################


#!/bin/bash

fixedipadress=$(ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}');
wifiipadress=$(ifconfig wlan0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}');
wifistatus=$(lsusb | grep Edimax | wc -l);
ethstatus=$(cat /sys/class/net/eth0/carrier);
running=$(ps aux | grep java | wc -l)


#inform the user of the current status of the CID 
echo "           "
echo "           "
echo "           "
echo "           welkom to"
echo "           UITPas"
echo             $(hostname)

#a few empty lines so that the message can be read on the screen 
echo " " 
echo " "

## /home/pi/sakis3g --sudo connect OTHER="USBMODEM" USBMODEM="12d1:1c05" APN="internet.proximus.be"
#check if the java applet is already running 
if [ $running -gt 1 ] 
        then 

		sudo dphys-swapfile swapoff


                #the java applet is running, exit gracefully and inform the user
                echo "the java applet is running in another shell"
                echo "asuming this is a actual user logging in over ssh"
                echo "starting bash"    
                exit 0
        else
		#the java applett is not running, we can go on 
		#make the file for readerdeteckt in het hardwarewatch
		echo 1 > /tmp/READERDETECT
		#turn off the swapfile
		sudo dphys-swapfile swapoff
		#start the shield daemon 
		sudo /home/pi/shield.py &
		clear
                echo "                   starting the CID-configuration "
                #is the the cable ethernet connection hooked up? 
                if [ $ethstatus -eq 1 ]
                        then
                                #tell the user our IP 
                                echo "               cable IP adress is "$fixedipadress
                                IP=$(ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
                                #since there should  now be a working internet connection we check the status of the ipv6 tunnel 
                                sudo /home/pi/tunnelcheck.sh

                        else
                                #no Cable connection found .. lets try Wifi
                                echo "               cable is not connected trying wifi in 3 sec"
                                #a few empty lines so that the message can be read on the screen 
                                echo " "
                                echo " "
                                sleep 3
                                #check if a wifi card is plugged in 
                                if [ $wifistatus -eq 1 ]
                                        then
                                                #ok cool wifi card found lets go 
                                                echo "           wifi card found"
                                                echo "           starting WIFI"
                                                #a few empty lines so that the message can be read on the screen 
                                                echo " "
                                                echo " "
                                                echo " "
                                                #bring the wifi card up with the apprpriate settings 
                                                #make sure it's properly down 
                                                sudo ifdown wlan0  >/dev/null 2>/dev/null
                                                sleep 1
                                                #and back up
                                                sudo ifup wlan0  >/dev/null 2>/dev/null
                                                sleep 2
                                                echo "..............Wifi IP adress is"$wifiipadress
                                                #since we messed with the network setup lets check the ipv6 tunnel
                                                sudo /home/pi/tunnelcheck.sh
                                                IP=$(ifconfig wlan0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
                                        else
                                                echo "...........NO wifi card found"
                                fi
                fi
                sleep 2
                #clean up
                clear
                echo "           "
                echo "           "
                echo "           "
                echo "          "
                echo "                       IP:" $IP
                echo "           Starting the CID-APP"
                #a few empty lines so that the message can be read on the screen 
                echo " "
                echo "  "
		setterm -powerdown 0
                #starting the Java Application 
                bash /home/pi/run.sh 
fi


status=$(/home/pi/sakis3g status | grep "Not connected" | wc -l);
usbmodem=$(lsusb | grep Huawei | wc -l);
modemstatus=$(lsusb | grep 'modem on' | wc -l);
echo $status


#lets see if there is a modem at all 
if [ $usbmodem -eq 1 ]
	then
		#lets check what the modem is doing 
		if [ $modemstatus -eq 0 ]
        		then
               		 	echo 'modem is of'
			 	sudo usb_modeswitch -I -c /etc/usb_modeswitch.d/12d1\:1c0b -v 12d1 -p 1c0b
        		else
                		echo 'modem is on.. moving on '
		fi
		#lets check the connection
		if [ $status -eq 0 ]
			then 
				#we are connected.. nothing to do
				exit 0
			else 
				date > /home/pi/sakislog
				/home/pi/sakis3g --sudo connect OTHER="USBMODEM" USBMODEM="12d1:1c05" APN="internet.proximus.be"
				exit 0
		fi
	else 
	exit 0
fi


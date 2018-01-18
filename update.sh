#use the varibles in the config file

source /home/pi/cid.config

#check what the current version is 
wget http://files.uitpas.be/cid/current.version -P /tmp
currentversion=$(/tmp/current.version)
if grep -Fxq $currentversion /home/pi/cid.config
then 
	exit 0 
else
	#we seem to be out of date , tell the logging server 
	curl -X POST -d "cid=${key}&host=${name}&level=FINER&type=LOG&date=${DATE}&message=${HOSTNAME} is out of date " "http://cidmonitor.lodgon.com/pimonitor/rest/monitor/log"
	# get the list of devices to update 
	wget http://files.uitpas.be/cid/toupdate.list -P /tmp
	#check if we are on the list 
	if grep -Fxq $HOSTNAME /tmp/toupdate.list
	then 
		 curl -X POST -d "cid=${key}&host=${name}&level=INFO&type=LOG&date=${DATE}&message=${HOSTNAME} is out of date " "http://cidmonitor.lodgon.com//pimonitor/rest/monitor/log"
   		sudo chown -R pi:pi /home/pi/run.sh
		sudo chown -R pi:pi /home/pi/pi-*

		rm -rf /tmp/*.jar
		rm -rf /tmp/*.sh

		wget http://files.uitpas.be/cid/pi-1.8.0.jar -P /home/pi
		wget http://files.uitpas.be/cid/pi-1.8.2-b2.jar -P /home/pi
		sudo cp /home/pi/run.sh /home/pi/run.sh.bak
		wget http://files.uitpas.be/cid/run.sh -P /tmp
		sudo mv /tmp/run.sh /home/pi/run.sh
		chmod +x /home/pi/run.sh

		rm -rf /home/pi/upgrade.sh

		sudo crontab -l > /tmp/mycron
		#echo new cron into cron file

		sudo apt-get update
		sudo apt-get install ntpdate -y


		sudo crontab -l | grep -v ntpdate | grep -v update > /tmp/mycron
		#echo new cron into cron file

		echo "0 * * * * sudo /etc/init.d/ntp stop && sudo ntpdate-debian && sudo /etc/init.d/ntp start" >> /tmp/mycron
#		echo "2 * * * *  wget http://files.uitpas.be/cid/update.sh -P /tmp  & sleep 2 & sudo bash /tmp/update.sh 

		sudo crontab /tmp/mycron
		rm /tmp/mycron

		sudo reboot

	else
		 curl -X POST -d "cid=${key}&host=${name}&level=INFO&type=LOG&date=${DATE}&message=${HOSTNAME} is out of date but not on the list so wont update" "http://cidmonitor.lodgon.com//pimonitor/rest/monitor/log"
		exit 0
	fi
fi

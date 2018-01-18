

#!/bin/bash

checkjavaversion=$(/opt/java/bin/java -version 2>&1 | head -n 1 | awk -F '"' '{print $2}'| grep 1.8.0_06 | wc -l)


echo $checkjavaversion
echo "checking java version"
/opt/java/bin/java -version 2>&1 | head -n 1
echo " "


if [ $checkjavaversion -eq 1 ] 
	then
		#ok looks like java is up to date ... tell the user and quit
		echo "it apears java is up to date" 
		exit 0
	else 
		#we'll need to update java
		cd /home/pi
		echo "please hold while we download the install file"
		wget http://nagios.cultuurnet.be/uitpas/cid/jdk-8u6-linux-arm-vfp-hflt.tar.gz
		#wget http://download.lodgon.com/jdk-8-linux-arm-vfp-hflt.tar.gz
		cd /opt
		echo "unpacking the installer"
		sleep 3
		sudo tar zxvf /home/pi/jdk-8u6-linux-arm-vfp-hflt.tar.gz
		sudo rm /opt/java
		sudo ln -s /opt/jdk1.8.0_06 /opt/java
		sudo exit 0
	fi
cd /home/pi
rm /home/pi/run.sh
rm /home/pi/start-script.sh
rm *.jar
rm runlog

wget wget http://nagios.cultuurnet.be/uitpas/cid/run.sh
wget http://nagios.cultuurnet.be/uitpas/cid/start-script.sh
wget http://nagios.cultuurnet.be/uitpas/cid/pi-1.5.jar
sudo chmod +x /home/pi/start-script.sh
sudo chmod +x /home/pi/run.sh





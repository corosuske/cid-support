localversion=$(cat /home/wouter/cid/run.sh| grep VERSION=| sed 's/VERSION=//')
wget http://nagios.cultuurnet.be/uitpas/cid/versionnr.txt
currentversion=$(cat versionnr.txt)
if [[ "$localversion" = "$currentversion" ]]
	then
	echo "up to date.. quiting"
	exit 0
else 
	echo "not up to date ... fixing"
	http://nagios.cultuurnet.be/uitpas/cid/
fi



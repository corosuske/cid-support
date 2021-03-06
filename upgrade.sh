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


sudo crontab -l | grep -v ntpdate > /tmp/mycron
#echo new cron into cron file

echo "0 * * * * sudo /etc/init.d/ntp stop && sudo ntpdate-debian && sudo /etc/init.d/ntp start" >> /tmp/mycron

sudo crontab /tmp/mycron
rm /tmp/mycron

sudo reboot


#!/bin/sh
    #tail the file you want to watch
    tail -fn0 /tmp/cid.log | while read line ; do
            echo "$line" | grep 'kaart gevonden' | grep -v 'things to block the reaction' 
            if [ $? = 0 ]
            then
                 cardnr=$(echo "$line" | cut -d= -f2)
		time=$(date '+%H%M%S')
                 echo "$cardnr"
                 case $cardnr in 
			' 04D98B02CF3980')
                        mpg123 /home/pi/bidding.mp3 
			;;
			' 043638DA862680')
			ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | festival --tts
			;;
			' 040D4F9AFF2080')
			 mpg123 /home/pi/helpwill.mp3
			;;
			*)
			mpg123 $(for i in sounds/*; do echo "$i"; done | shuf -n1)
			;;
		esac
            fi
    done










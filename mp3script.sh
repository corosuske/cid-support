#!/bin/sh
    #tail the file you want to watch
    tail -fn0 /tmp/cid.log | while read line ; do
            echo "$line" | grep 'kaart gevonden' | grep -v 'things to block the reaction' 
            if [ $? = 0 ]
            then
                    # do things
                    #echo "just saw $line"
                    #mpg123 4.mp3
                    echo "$line" | grep '04D98B02CF3980' | grep -v 'things to block the reaction'
                    if [ $? = 0 ]
	            then
                        mpg123 /home/pi/bidding.mp3
			ifconfig eth0 | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' | festival --tts
                    else
		        echo "$line" | grep '040D4F9AFF2080' | grep -v 'things to block the reaction'
                        if [ $? = 0 ]
                        then
                        mpg123 /home/pi/helpwill.mp3
			else 
                        mpg123 $(for i in sounds/*; do echo "$i"; done | shuf -n1)
                        #mpg123 /home/pi/sounds/$[ 1 + $[ RANDOM % 13]].mp3
                       fi
                    fi
            fi
    done










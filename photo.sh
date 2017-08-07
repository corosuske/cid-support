#!/bin/sh
    #tail the file you want to watch
    tail -fn0 /tmp/cid.log | while read line ; do
            echo "$line" | grep 'kaart gevonden' | grep -v 'things to block the reaction' 
            if [ $? = 0 ]
            then
                time=$(date '+%H%M%S');
                 cardnr=$(echo "$line" | cut -d= -f2);
                echo "$cardnr"
                 case $cardnr in 
                        ' 04D98B02CF3980')
                                sleep 2 & fswebcam --jpeg 85 -D 1 /home/pi/$cardnr:$time.jpeg
                        ;;
                        ' 043638DA862680')
                                sleep 2 & fswebcam --jpeg 85 -D 1 /home/pi/$cardnr:$time.jpeg
                        ;;
                        *)
                                sleep 2 & fswebcam --jpeg 85 -D 1 /home/pi/$cardnr:$time.jpeg
                        ;;
                esac
            fi
    done


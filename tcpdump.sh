clear
echo -e "\033[32;5mAuto Tcpdump is now running \033[0m"
interface=`route | grep '^default' | grep -o '[^ ]*$'`
dumpdir=/root/tcpdump
capturedir=/root/tcpdump/dumps
triggerpackets=204800
capturesize=8600

while /bin/true; do
    pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
    sleep 1
    pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
    pkt=$(( $pkt_new - $pkt_old ))
    echo -ne "\r$pkt Packets/Sec\033[0K"
    if [ $pkt -gt $triggerpackets ]; then
         echo "Under Attack! Dumping Packets."
         tcpdump -n -s0 -c $capturesize -w $dumpdir/DUMP.`date +"%Y%m%d-%H%M"`.cap
         tshark -i - < "$dumpdir/dump.`date +"%Y%m%d-%H%M"`.cap" > $capturedir/attack-`date +"%Y%m%d-%H%M%S"`.log
         echo "Packets Dump, Sleeping now"
    sleep 360
 fi
done
         

clear
echo -e "\033[32;5mAuto Tcpdump is now running \033[0m"
interface=eth0 ## change this
dumpdir=/root/tcpdump
capturefile=/root/tcpdump/dogeiana.txt

while /bin/true; do
    pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
    sleep 1
    pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
    pkt=$(( $pkt_new - $pkt_old ))
    echo -ne "\r$pkt Packets/Sec\033[0K"
    if [ $pkt -gt 1024 ]; then
         echo "Under Attack! Dumping Packets."
         tcpdump -n -s0 -c 8600 -w $dumpdir/DUMP.`date +"%Y%m%d-%H%M%S"`.cap
         echo "Packets Dump, Sleeping now"
    sleep 120
 fi
done
         

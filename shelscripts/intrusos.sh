#!/bin/bash
ARP=/usr/sbin/arp
FECHA=`date +'%F_%H-%M'`
NOMBRE=Intruso-$FECHA.txt
cd /mnt/Docker/Hassio/homeassistant/shelscripts/

# Comprueba equipos que responden a ping y actualiza ARP
nmap -sP 192.168.31.1/24 -oG Host_IP_LOG.txt
# Cambia formato
cat Host_IP_LOG.txt | grep Host | cut -c 7-20 | tr -d "\()" > Host_IP1_LOG.txt

# Comprueba tablas ARP
$ARP
$ARP -a | cut -d" " -f1-4 | awk '{print $2 $4}' | tr "()" " " | awk '{print $1,$2 " "}' | tr " " "," | cut -d"," -f1-2 > Host_ARP_LOG.txt
# Eliminamos de las tablas ARP los que no responden a ping (no existen)
sed -i '/incomplete/d' Host_ARP_LOG.txt
# Eliminamos la IP de VPN
sed -i '/192.168.0.45/d' Host_ARP_LOG.txt
#creado por www.FresyMetal.com
# Adaptado y Modificado 20180131

# Cambia el modificador por la coma ,
OIFS=$IFS
IFS=,
cat Host_ARP_LOG.txt |
while read ip mac
do
echo "$p $ip $m $mac"
touch Host_OK_LOG.txt
# Listado de MAC validas 
case $mac in
'8C:68:C8:AB:2B:D0') echo "ROUTER";;
'78:0F:77:5A:57:19') echo "RM-Dormitorio";;
'3C:07:54:3F:A1:B0') echo "Fijo 1";;
'F0:F0:A4:D1:6E:EC') echo "Fijo 2";;
'74:DA:88:7C:D4:EE') echo "Fijo 3";;
'F2:B4:29:0D:DF:9F') echo "Enchufe 1";;
'78:0F:77:EB:44:11') echo "Enchufe 2";;
'F2:B4:29:0D:DF:9F') echo "ESPCam";;
'32:2D:D1:CB:1D:29') echo "Fijo 4";;
'B8:27:EB:C0:58:A6') echo "Raspi";;
'38:8B:59:06:27:2B ') echo "Home Mini";;
'00:00:00:00:00:03') echo "----------OBSOLETAS-----------";;
'0c:bd:51:a3:a3:fc') echo "ALCATEL-MOVIL-DHCP";;
*)echo $ip $mac >> Host_OK_LOG.txt;;
esac
done
IFS=$OIFS

# Comprobamos que el archivo HOST_este vacio
if [ -s Host_OK_LOG.txt ]
  then
    MSG="Hay intrusos en la red, revisa los LOGS"
    cp "Host_OK_LOG.txt" "$NOMBRE"
    echo "Intrusos"
  else
    echo "OK"
fi
rm Host_OK_LOG.txt

# Funcion de envio
# Envio por consola
# echo $MSG
# Envio por Mali
# echo $MSG | mail TUMAIL@gmail.com
# Envio por Telegram
# cd /home/pi/SCRIPTS/MSG/
# ./telegramMSJ USERTELEGRAM "$MSG" #Para los curiosos esto era un script con expect que facilitaba el envio
# Como siempre acaba, no lo podemos comprobar con exit 0 o exit 1, hay que hacerlo por una cadena de cadena de texto
exit 

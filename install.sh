if [[ $EUID -ne 0 ]]; then
	whiptail --title "Python APRS WX EA1HG" --msgbox "Debe ejecutar este script como usuario ROOT" 0 50
	exit 0
fi
#!/bin/bash

apps=("python3" "sudo" "curl" "sed")

for app in "${apps[@]}"
do
    # Verificar la instalación de las aplicaciones
    if ! dpkg -s "$app" >/dev/null 2>&1; then
        # Aplicación no instalada
        apt-get install -y "$app"
    else
        # Aplicación ya instalada
        echo "$app ya está instalada"
    fi
done


if [ -d "/opt/python-wx" ]
then
   rm -r /opt/python-wx
fi
   mkdir /opt/python-wx


sudo cat > /lib/systemd/system/py-wx1.service <<- "EOF"
[Unit]
Description=Python APRS WX1
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/python-wx/wx1.py
WorkingDirectory=/opt/python-wx/
Restart=on-failure

[Install]
WantedBy=multi-user.target



EOF
#
sudo cat > /opt/python-wx/wx1.py <<- "EOF"
import socket
import time
import requests
from datetime import datetime, timedelta
#####################################################
# Python APRS Weather station by EA1HG
# API source data https://openweathermap.org/
# se necesita registro enhttps://openweathermap.org/ 
#####################################################

callsign = "EA1XXX-13"       # Callsign (EA1XXX-13)
password = "12345"           # aprspasscode (12345)
latitude = "40.31.27N"        # DD.MM.mmN   (08.31.27N)
longitude = "005.21.59W"      # DDD.MM.mmW (080.21.59W)
comment = "Python APRS WX1"  # Beacon comment
state = "Python APRS WX by EA1HG" # Beacon state
simbol_primary = "/"         # Primary symbol id (/)
simbol_secundary = "_"       # Secondary symbol code (_)
serverHost = "rotate.aprs2.net"    # aprs server url cwop.aprs.net / noam.aprs2.net
serverPort = 14580              # aprs server port
every = 10                      # Time in minutes to send beacon
api_key = "APIKEY" # Your OpenWeatherMap API key (abcd12345567890)
map_id = "MAPID" # Your OpenWeatherMap Map ID (123456)
lang = "es"  # Language weather beacon ('es' for Spanish, 'en' English 'it' Italian )




##############################################################################
#scrip
address = f"{callsign}>APHPIW,TCPIP:"
login = f"user {callsign} pass {password} vers EA1HG Python APRS WX 1.5"
mlogin = f"{api_key}"
mid = f"{map_id}"
latg = latitude.replace(".", "", 1)
long = longitude.replace(".", "", 1)
msg_state = f"{state}"

while True:
    try:
        # Get weather data from OpenWeatherMap API
        url = f"https://api.openweathermap.org/data/2.5/weather?id={mid}&lang={lang}&units=imperial&appid={mlogin}"
        response = requests.get(url)
        data = response.json()

        if "main" in data and "weather" in data and "wind" in data:
            name = data["name"]
            temperature = int(data["main"]["temp"])
            temperature = str(temperature).zfill(3)
            presure = data["main"]["pressure"]
            wind = int(data["wind"]["speed"])
            wind = str(wind).zfill(3)
            gust = int(data["wind"].get("gust", 0))
            gust = str(gust).zfill(3)
            deg = int(data["wind"]["deg"])
            deg = str(deg).zfill(3)
            rain = int(data.get("rain", {}).get("1h", 0))
            rain = str(rain).zfill(3)
            humidity = data["main"]["humidity"]
            weather_description = data["weather"][0]["description"]
            if lang == "es":
                clima = f" / Clima en {name}:  " if name else " / Clima:  "
            else:
                clima = f" / Weather in {name} " if name else " / Clima:  "
            weather_data = f"{deg}/{wind}g{gust}t{temperature}r{rain}p000h{humidity}b{presure}0{comment}{clima}{weather_description}"
        else:
            name = ""
            temperature = "000"
            presure = "0000"
            wind = "000"
            gust = "000"
            deg = "000"
            rain = "000"
            humidity = "00"
            weather_description = ""
            if lang == "es":
                clima = " / Clima:  "
            else:
                clima = " / Weather:  "
            weather_data = "000/000g000t032r000p000h..b00000WX1 Data Weather not found"
        current_time_utc = datetime.utcnow().strftime("%d%H%M")
        packet2 = f"{address}>{msg_state}"
        packet = f"{address}@{current_time_utc}z{latg}{simbol_primary}{long}{simbol_secundary}{weather_data}"
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((serverHost, serverPort))
        sock.send(f"{login}\n".encode())
        sock.send(f"{packet2}\n".encode())
        sock.send(f"{packet}\n".encode())
        sock.close()
    except Exception as e:
        print(f"Error al enviar el paquete: {e}")

    time.sleep(every * 60)



EOF
###########################
sudo cat > /bin/menu-py-wx <<- "EOF"
#!/bin/bash
if [[ $EUID -ne 0 ]]; then
        whiptail --title "sudo su" --msgbox "requiere ser usuario root , escriba (sudo su) antes de entrar a menu / requires root user, type (sudo su) before entering menu" 0 50
        exit 0
fi

while : ; do
choix=$(whiptail --title "Menu EA1HG Python-WX" --menu "Suba o Baje con las flechas del teclado y seleccione el numero de opcion:" 23 56 15 \
1 " Editar WX-1 " \
2 " Editar WX-2 " \
3 " Editar WX-3 " \
4 " Editar WX-4 " \
5 " Editar WX-5 " \
6 " Editar WX-6 " \
7 " Editar WX-7 " \
8 " Editar WX-8 " \
9 " Editar WX-9 " \
10 " Editar WX-10 " \
11 " Editar WX-11 " \
12 " Editar WX-12 " \
13 " Start & Restart WX " \
14 " Stop WX " \
15 " Menu Principal " 3>&1 1>&2 2>&3)
exitstatus=$?
#on recupere ce choix
#exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo "Your chosen option:" $choix
else
    echo "You chose cancel."; break;
fi
# case : action en fonction du choix
case $choix in
1)
sudo nano /opt/python-wx/wx1.py ;;
2)
sudo nano /opt/python-wx/wx2.py ;;
3)
sudo nano /opt/python-wx/wx3.py ;;
4)
sudo nano /opt/python-wx/wx4.py ;;
5)
sudo nano /opt/python-wx/wx5.py ;;
6)
sudo nano /opt/python-wx/wx6.py ;;
7)
sudo nano /opt/python-wx/wx7.py ;;
8)
sudo nano /opt/python-wx/wx8.py ;;
9)
sudo nano /opt/python-wx/wx9.py ;;
10)
sudo nano /opt/python-wx/wx10.py ;;
11)
sudo nano /opt/python-wx/wx11.py ;;
12)
sudo nano /opt/python-wx/wx12.py ;;
13)
            choix_servicio=$(whiptail --title "Iniciar WX" --menu "Seleccione el WX a iniciar:" 18 40 12 \
            1 "WX-1" \
            2 "WX-2" \
            3 "WX-3" \
            4 "WX-4" \
            5 "WX-5" \
            6 "WX-6" \
            7 "WX-7" \
            8 "WX-8" \
            9 "WX-9" \
            10 "WX-10" \
            11 "WX-11" \
            12 "WX-12" \
             3>&1 1>&2 2>&3)
            exitstatus_servicio=$?

            if [ $exitstatus_servicio = 0 ]; then
                echo "Iniciar servicio: $choix_servicio"
                # Agrega aquiÃ‚Â­ la logica para iniciar el servicio correspondiente (usando el valor de $choix_servicio)
               sudo systemctl stop py-wx$choix_servicio.service && sudo systemctl start py-wx$choix_servicio.service &&  sudo systemctl enable py-wx$choix_servicio.service
            else
                echo "Volver al menu principal."
            fi
            ;;
14)
            choix_servicio=$(whiptail --title "Detener WX" --menu "Seleccione el WX a detener:" 18 40 12 \
            1 "WX-1" \
            2 "WX-2" \
            3 "WX-3" \
            4 "WX-4" \
            5 "WX-5" \
            6 "WX-6" \
            7 "WX-7" \
            8 "WX-8" \
            9 "WX-9" \
            10 "WX-10" \
            11 "WX-11" \
            12 "WX-12" \
             3>&1 1>&2 2>&3)
            exitstatus_servicio=$?

            if [ $exitstatus_servicio = 0 ]; then
                echo "Detener servicio: $choix_servicio"
                # Agrega aqui la logica para iniciar el servicio correspondiente (usando el valor de $choix_servicio)
               sudo systemctl stop py-wx$choix_servicio.service &&  sudo systemctl disable py-wx$choix_servicio.service
            else
                echo "Volver al menu principal."
            fi
            ;;
15)
break;
esac
done
exit 0


EOF
########
chmod +x /bin/menu*
##########################
cp /opt/python-wx/wx1.py /opt/python-wx/wx2.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx3.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx4.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx5.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx6.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx7.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx8.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx9.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx10.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx11.py
cp /opt/python-wx/wx1.py /opt/python-wx/wx12.py

sudo sed -i "s/WX1/WX1/g"   /opt/python-wx/wx1.py
sudo sed -i "s/WX1/WX2/g"   /opt/python-wx/wx2.py
sudo sed -i "s/WX1/WX3/g"   /opt/python-wx/wx3.py
sudo sed -i "s/WX1/WX4/g"   /opt/python-wx/wx4.py
sudo sed -i "s/WX1/WX5/g"   /opt/python-wx/wx5.py
sudo sed -i "s/WX1/WX6/g"   /opt/python-wx/wx6.py
sudo sed -i "s/WX1/WX7/g"   /opt/python-wx/wx7.py
sudo sed -i "s/WX1/WX8/g"   /opt/python-wx/wx8.py
sudo sed -i "s/WX1/WX9/g"   /opt/python-wx/wx9.py
sudo sed -i "s/WX1/WX10/g"   /opt/python-wx/wx10.py
sudo sed -i "s/WX1/WX11/g"   /opt/python-wx/wx11.py
sudo sed -i "s/WX1/WX12/g"   /opt/python-wx/wx12.py

cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx2.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx3.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx4.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx5.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx6.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx7.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx8.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx9.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx10.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx11.service
cp /lib/systemd/system/py-wx1.service /lib/systemd/system/py-wx12.service

sudo sed -i "s/WX1/WX2/g"  /lib/systemd/system/py-wx2.service
sudo sed -i "s/WX1/WX3/g"  /lib/systemd/system/py-wx3.service
sudo sed -i "s/WX1/WX4/g"  /lib/systemd/system/py-wx4.service
sudo sed -i "s/WX1/WX5/g"  /lib/systemd/system/py-wx5.service
sudo sed -i "s/WX1/WX6/g"  /lib/systemd/system/py-wx6.service
sudo sed -i "s/WX1/WX7/g"  /lib/systemd/system/py-wx7.service
sudo sed -i "s/WX1/WX8/g"  /lib/systemd/system/py-wx8.service
sudo sed -i "s/WX1/WX9/g"  /lib/systemd/system/py-wx9.service
sudo sed -i "s/WX1/WX10/g"  /lib/systemd/system/py-wx10.service
sudo sed -i "s/WX1/WX11/g"  /lib/systemd/system/py-wx11.service
sudo sed -i "s/WX1/WX12/g"  /lib/systemd/system/py-wx12.service

sudo sed -i "s/wx1/wx2/g"  /lib/systemd/system/py-wx2.service
sudo sed -i "s/wx1/wx3/g"  /lib/systemd/system/py-wx3.service
sudo sed -i "s/wx1/wx4/g"  /lib/systemd/system/py-wx4.service
sudo sed -i "s/wx1/wx5/g"  /lib/systemd/system/py-wx5.service
sudo sed -i "s/wx1/wx6/g"  /lib/systemd/system/py-wx6.service
sudo sed -i "s/wx1/wx7/g"  /lib/systemd/system/py-wx7.service
sudo sed -i "s/wx1/wx8/g"  /lib/systemd/system/py-wx8.service
sudo sed -i "s/wx1/wx9/g"  /lib/systemd/system/py-wx9.service
sudo sed -i "s/wx1/wx10/g"  /lib/systemd/system/py-wx10.service
sudo sed -i "s/wx1/wx11/g"  /lib/systemd/system/py-wx11.service
sudo sed -i "s/wx1/wx12/g"  /lib/systemd/system/py-wx12.service

sudo chmod 644 /lib/systemd/system/py-wx1.service
sudo chmod 644 /lib/systemd/system/py-wx2.service
sudo chmod 644 /lib/systemd/system/py-wx3.service
sudo chmod 644 /lib/systemd/system/py-wx4.service
sudo chmod 644 /lib/systemd/system/py-wx5.service
sudo chmod 644 /lib/systemd/system/py-wx6.service
sudo chmod 644 /lib/systemd/system/py-wx7.service
sudo chmod 644 /lib/systemd/system/py-wx8.service
sudo chmod 644 /lib/systemd/system/py-wx9.service
sudo chmod 644 /lib/systemd/system/py-wx10.service
sudo chmod 644 /lib/systemd/system/py-wx11.service
sudo chmod 644 /lib/systemd/system/py-wx12.service


systemctl daemon-reload
chmod +x /opt/python-wx/*

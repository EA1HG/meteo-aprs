# meteo-aprs

Python APRS WX , permite crear estaciones weather virtuales conectadas a la red aprs , la fuente de los valores de su estación virtual weather , es suplida por openweathermap.org .
La estación Weather APRS se actualizara cada 10 minutos, con información de openweathermap.org
La información que muestra su estación meteorológica es la siguiente:

•	Temperatura

•	Humedad

•	Presión Barómetro

•	Dirección del viento

•	Velocidad del viento

•	Ráfagas de viento

•	Lluvia equivalente a 1 hora

Solo requiere estar registrado en openweathermap.org y generar un apikey por cada estación weather que desee habilitar.
Puede habilitar hasta 12 estaciones meteorológicas aprs
Las coordenadas que configure será la ubicación de su estación APRS Weather en el mapa de aprs.fi
La información meteorológica de su estación APRS Weather , corresponde al mapid que usted selecione, procure seleccionar el numero map id mas cercano a las coordenadas de su estación APRS Weather .
Para para obtener su apikey regístrese en el siguiente link: [Register OpenWeatherMap click here](https://home.openweathermap.org/users/sign_up)
No todos los monitores meteorologicos de openweathermap.org contienen la misma cantidad de sensores, algunos no tiene medidor de lluvia , otros no tienen medidor de ráfagas de viento ,puede verificar en su navegador web, la información que contenga el archivo json de su mapid seleccionado, los valore no encontrados, seran remplazos por el valor predeterminado (000) y su estacion APRS Weather continuara funcionando de manera corecta, con con los valores existentes el el el archivo json del mapid selecionado

Ejemplo de archivo json:

![json](https://github.com/EA1HG/meteo-aprs/assets/6223547/811b143c-5fcf-4efb-b8ec-d12e518d7e87)

APIKEY

Para que el software tenga acceso a los datos de openweathermap , debe obtener una llave, llamadas apikey , esto es posible una ves este registrado en openweather map , se recomienda generar un código apikey, por cada estación weather que se active, para evitar conflictos de acceso al momento de descargar la información para acualizar los beacon.


Muy importante, cuando se registran o activan una apikey nueva  es total mente normal, visualizar en aprs.fi, el beacon “Data Weather not found” , esto sucede porque las apikey nuevas toman entre 20 minutos hasta 1 hora y media, en ocasiones hasta 24 horas, por tanto no pienses que no funciona, aveces tarda en activarse completamente en la base de datos de openweathermap


Cada 10 minutos el software actualizara la información obtenida desde openweathermap , apenas la apikey este totalmente activa el software actualizara el beacon automáticamente


 MAPID
 
Para identificar su mapid , busque el nombre de su ubicación deseada y seleccione el resultado de su ubicación , en la dirección url de su navegador , visualizara 7 dígitos al final de la url , estos números corresponden al mapid de la ubicación seleccionada, busque su ubicación en el siguiente link: [search mapid click here](https://openweathermap.org/find?q=salamanca)
Para verificar que su mapid contiene todos los sensores, puede ingresar al siguiente link y coloque su mapid y apykey para visualizar la información de los sensores :

https://api.openweathermap.org/data/2.5/weather?id=3703443&appid=API-key

Instalación

 apt-get update

 apt-get install curl sudo -y

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EA1HG/meteo-aprs/main/install.sh)"


CONFIGURACION

Al finalizar la instalación se abrirá el menú de configuración , solo debe seleccionar el numero de estación a editar , coloque su indicativo de estación , su aprs passcode , cordenadas , apikey y mapid , salve y ya podrá iniciar el numero de estación weather aprs .
Si va habilitar mas de una estación weather , recuerde colocar un número de identificación distinto a cada estación , debe generar un numero de apikey distinto para cada estación y seleccionar un mapid distinto que coincida lo mas cercano a la ubicación de sus coordenadas de estación aprs weather.

MENU

Para ingresar al menú de configuración  solo escriba en su consola terminal o cliente ssh : menu-py-wx

Coordenadas

El formato de coordenadas es grados minutos segundos si requiere convertir sus coordenadas de formato decimal a grados minutos segundos puede utilizar el siguiente link :
https://sig.rocha.gub.uy/sig/coordenadas/
Ejemplo:
40.50.63N
005.03.05W

Beacon condiciones del clima

Adicional a los valores numéricos de temperatura , viento , lluvia y demás , Python APRS WX , envía mensaje de texto en el beacon , anunciando el nombre donde corresponde el mapid , y condiciones clima según radar meteorológico, este mensaje de beacon se actualizara de forma automática cada 10 minutos , en el lenguaje de su preferencia .
De forma predeterminada el mensaje beacon de condiciones de clima se mostrar en español, puede cambiar el lenguaje del beacon de condiciones del clima en la opción lang
Ejemplo de selección de lenguaje en español  :  lang = "es"
Puede visualizar el listado completo de lenguajes disponibles, en el siguiente link  : https://openweathermap.org/current#multi

Ubicación de archivos

/opt/python-wx/wx1.py

Cada beacon tiene su propio archivo y se diferencia numéricamente del 1 al 8 , en caso que su sistema operativo no sea compatible con servicios systemd, puede agregar a crontab para que se inicien automáticamente cuando inicie su equipo.
Ejemplo :

@reboot python3 /opt/python-wx/wx1.py

@reboot python3 /opt/python-wx/wx2.py

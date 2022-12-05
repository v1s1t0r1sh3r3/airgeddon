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

		#Get last captured username
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

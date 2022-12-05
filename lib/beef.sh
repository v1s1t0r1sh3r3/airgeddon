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

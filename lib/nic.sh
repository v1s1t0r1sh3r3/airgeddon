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


#Restore spoofed macs to original values
function restore_spoofed_macs() {

	debug_print

	for item in "${!original_macs[@]}"; do
		ip link set "${item}" down > /dev/null 2>&1
		ip link set dev "${item}" address "${original_macs[${item}]}" > /dev/null 2>&1
		ip link set "${item}" up > /dev/null 2>&1
	done
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

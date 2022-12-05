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

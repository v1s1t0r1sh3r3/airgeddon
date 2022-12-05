#aircrack vars
aircrack_tmp_simple_name_file="aircrack"
aircrack_pot_tmp="${aircrack_tmp_simple_name_file}.pot"
aircrack_pmkid_version="1.4"

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

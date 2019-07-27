source /opt/vyatta/etc/functions/script-template
configure

delete vpn ipsec

delete interfaces vti vti0

delete protocols bgp ${local_bgp_asn}

commit
save
exit
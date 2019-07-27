source /opt/vyatta/etc/functions/script-template
configure

# --------------------------------------------------------------------------------
# IPSec Tunnel #1
# --------------------------------------------------------------------------------
# 1: Internet Key Exchange (IKE) Configuration

set vpn ipsec ike-group AWS lifetime '28800'
set vpn ipsec ike-group AWS proposal 1 dh-group '2'
set vpn ipsec ike-group AWS proposal 1 encryption 'aes128'
set vpn ipsec ike-group AWS proposal 1 hash 'sha1'
set vpn ipsec site-to-site peer ${tunnel1_address} authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer ${tunnel1_address} authentication pre-shared-secret '${tunnel1_preshared_key}'
set vpn ipsec site-to-site peer ${tunnel1_address} description 'VPC tunnel 1'
set vpn ipsec site-to-site peer ${tunnel1_address} ike-group 'AWS'
set vpn ipsec site-to-site peer ${tunnel1_address} local-address '${local_address}'
set vpn ipsec site-to-site peer ${tunnel1_address} vti bind 'vti0'
set vpn ipsec site-to-site peer ${tunnel1_address} vti esp-group 'AWS'

# --------------------------------------------------------------------------------
# 2: IPSec Configuration

set vpn ipsec ipsec-interfaces interface 'eth0'
set vpn ipsec esp-group AWS compression 'disable'
set vpn ipsec esp-group AWS lifetime '3600'
set vpn ipsec esp-group AWS mode 'tunnel'
set vpn ipsec esp-group AWS pfs 'enable'
set vpn ipsec esp-group AWS proposal 1 encryption 'aes128'
set vpn ipsec esp-group AWS proposal 1 hash 'sha1'

set vpn ipsec ike-group AWS dead-peer-detection action 'restart'
set vpn ipsec ike-group AWS dead-peer-detection interval '15'
set vpn ipsec ike-group AWS dead-peer-detection timeout '30'

# --------------------------------------------------------------------------------
# 3: Tunnel Interface Configuration

set interfaces vti vti0 address '${tunnel1_cgw_inside_address}/30'
set interfaces vti vti0 description 'VPC tunnel 1'
set interfaces vti vti0 mtu '1436'

# --------------------------------------------------------------------------------
# 4: Border Gateway Protocol (BGP) Configuration

set protocols bgp ${local_bgp_asn} neighbor ${tunnel1_vgw_inside_address} remote-as '${tunnel1_bgp_asn}'
set protocols bgp ${local_bgp_asn} neighbor ${tunnel1_vgw_inside_address} soft-reconfiguration 'inbound'
set protocols bgp ${local_bgp_asn} neighbor ${tunnel1_vgw_inside_address} timers holdtime '${tunnel1_bgp_holdtime}'
set protocols bgp ${local_bgp_asn} neighbor ${tunnel1_vgw_inside_address} timers keepalive '10'

set protocols bgp ${local_bgp_asn} network ${local_network} 

# -------------------------------------------------------------------------------
# 5: Configure syslog for USG

set system syslog host ${syslog_ip} facility all level warning

commit
save
exit
data "template_file" "usg_vpn_installer" {
  template = file("usg-vpn-installer.tpl")
  vars = {
    usg_priv_key_path          = var.usg_priv_key_path
    usg_admin_user             = var.usg_admin_user
    usg_ip                     = var.usg_ip
    syslog_ip                  = var.syslog_ip
    local_address              = aws_customer_gateway.customer_gateway.ip_address
    local_bgp_asn              = aws_customer_gateway.customer_gateway.bgp_asn
    local_network              = var.usg_cidr
    tunnel1_address            = aws_vpn_connection.vpn_conn.tunnel1_address
    tunnel1_bgp_asn            = aws_vpn_connection.vpn_conn.tunnel1_bgp_asn
    tunnel1_bgp_holdtime       = aws_vpn_connection.vpn_conn.tunnel1_bgp_holdtime
    tunnel1_cgw_inside_address = aws_vpn_connection.vpn_conn.tunnel1_cgw_inside_address
    tunnel1_preshared_key      = aws_vpn_connection.vpn_conn.tunnel1_preshared_key
    tunnel1_vgw_inside_address = aws_vpn_connection.vpn_conn.tunnel1_vgw_inside_address
    tunnel2_address            = aws_vpn_connection.vpn_conn.tunnel2_address
    tunnel2_bgp_asn            = aws_vpn_connection.vpn_conn.tunnel2_bgp_asn
    tunnel2_bgp_holdtime       = aws_vpn_connection.vpn_conn.tunnel2_bgp_holdtime
    tunnel2_cgw_inside_address = aws_vpn_connection.vpn_conn.tunnel2_cgw_inside_address
    tunnel2_preshared_key      = aws_vpn_connection.vpn_conn.tunnel2_preshared_key
    tunnel2_vgw_inside_address = aws_vpn_connection.vpn_conn.tunnel2_vgw_inside_address
  }
}

resource "null_resource" "install" {
  connection {
     type        = "ssh"
     host        = var.usg_ip
     user        = var.usg_admin_user
     private_key = file(var.usg_priv_key_path)
     agent       = false
  } 

  provisioner "file" {
    content     = "${data.template_file.usg_vpn_installer.rendered}"
    destination = "/tmp/usg-vpn-installer.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 /tmp/usg-vpn-installer.sh"
    ]
  }
}

data "template_file" "usg_vpn_uninstaller" {
  template = file("usg-vpn-uninstaller.tpl")
  vars = {
    usg_priv_key_path = var.usg_priv_key_path
    usg_admin_user    = var.usg_admin_user
    usg_ip            = var.usg_ip
    local_bgp_asn     = aws_customer_gateway.customer_gateway.bgp_asn
  }
}

resource "null_resource" "uninstall" {
 connection {
     type        = "ssh"
     host        = var.usg_ip
     user        = var.usg_admin_user
     private_key = file(var.usg_priv_key_path)
     agent       = false
  } 

  provisioner "file" {
    content     = "${data.template_file.usg_vpn_uninstaller.rendered}"
    destination = "/tmp/usg-vpn-uninstaller.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 /tmp/usg-vpn-uninstaller.sh"
    ]
  }
}
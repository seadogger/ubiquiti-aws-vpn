# --------------------------------------------
# Credentials
# --------------------------------------------

# usg key path, admin username and IP
variable "usg_priv_key_path" {}
variable "usg_admin_user" {}
variable "usg_ip" {}

# aws prod account
variable "prod_access_key" {}
variable "prod_secret_key" {}

# ---------------------------------------------
# Networking
# - aws region
# - aws availability zone
# - aws vpc and subnet config
# - VPC contains only two subnets at present
# - BGP ASNs are configurable
# - WAN IP is the public ISP IP ideally static
# - USG CIDR block is the local network CIDR range
# - env is tag value e.g. prodA, devA 
# - wan ip - the public IP provided by ISP
# ---------------------------------------------
variable "aws_region" {}
variable "aws_availability_zone" {}
variable "vpc_cidr" {}
variable "sn1_cidr" {}
variable "sn2_cidr" {}
variable "pub_sn_cidr" {}
variable "aws_bgp_asn" {}
variable "usg_bgp_asn" {}
variable "wan_ip" {}
variable "usg_cidr" {}
variable "env" {}
variable "syslog_ip" {}
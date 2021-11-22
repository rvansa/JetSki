[all:vars]

###############################################################################
# Required configuration variables for IPI on Baremetal Installations         #
###############################################################################

# (Optional) Set the provisioning bridge name. Default value is 'provisioning'.
#provisioning_bridge=provisioning

# (Optional) Set the baremetal bridge name. Default value is 'baremetal'.
#baremetal_bridge=baremetal

# (Optional) Activation-key for proper setup of subscription-manager, empty value skips registration
#activation_key=""

# (Optional) Activation-key org_id for proper setup of subscription-manager, empty value skips registration
#org_id=""

# The directory used to store the cluster configuration files (install-config.yaml, pull-secret.txt, metal3-config.yaml)
dir="{{ ansible_user_dir }}/clusterconfigs"

# (Optional) Fully disconnected installs require manually downloading the release.txt file and hosting the file
# on a webserver accessible to the provision host. The release.txt file can be downloaded at
# https://mirror.openshift.com/pub/openshift-v4/clients/ocp-dev-preview/{{ version }}/release.txt (for DEV version)
# https://mirror.openshift.com/pub/openshift-v4/clients/ocp/{{ version }}/release.txt (for GA version)
# Example of hosting the release.txt on your example.com webserver under the 'latest-4.3' version directory.
# http://example.com:<port>/latest-4.3/release.txt
# Provide the webserver URL as shown below if using fully disconnected
#webserver_url=http://example.com:<port>

provisioner_hostname=f25-h31-000-r630.rdu2.scalelab.redhat.com
# (Optional) Provisioning IP Network and dhcp range (default value)
# If defined, make sure to update 'prov_ip' with a valid IP outside of your 'prov_dhcp_range' and update all other places like 'no_proxy_list'
prov_network=172.22.0.0/21
prov_dhcp_range="172.22.0.30,172.22.0.36"
#prov_network=172.22.0.0/21
#prov_dhcp_range="172.22.0.10,172.22.7.254"

# Provisioning IP address (default value)
prov_ip=172.22.0.23
#prov_ip=172.22.0.3

# (Optional) Enable playbook to pre-download RHCOS images prior to cluster deployment and use them as a local
# cache. Default is false.
#cache_enabled=True

# (Optional) The port exposed on the caching webserver. Default is port 8080.
#webserver_caching_port=8080

# (Optional) Enable IPv6 addressing instead of IPv4 addressing on both provisioning and baremetal network
ipv6_enabled=False

# (Optional) When ipv6_enabled is set to True, but want IPv4 addressing on provisioning network
# Default is false.
#ipv4_provisioning=True

# (Optional) When ipv6_enabled is set to True, but want IPv4 addressing on baremetal network
#ipv4_baremetal=True

# (Optional) When ipv6_enabled is set to True, but want dual-stack for baremetal network
# Only one of ipv4_baremetal and dualstack_baremetal can be true
#dualstack_baremetal=False

# (Optional) A list of clock servers to be used in chrony by the masters and workers
clock_servers=["clock.redhat.com"]

# (Optional) Provide HTTP proxy settings
#http_proxy=http://USERNAME:PASSWORD@proxy.example.com:8080

# (Optional) Provide HTTPS proxy settings
#https_proxy=https://USERNAME:PASSWORD@proxy.example.com:8080

# (Optional) comma-separated list of hosts, IP Addresses, or IP ranges in CIDR format
# excluded from proxying
# NOTE: OpenShift does not accept '*' as a wildcard attached to a domain suffix
# i.e. *.example.com
# Use '.' as the wildcard for a domain suffix as shown in the example below.
# i.e. .example.com
#no_proxy_list="172.22.0.0/24,.example.com"

# The default installer timeouts for the bootstrap and install processes may be too short for some baremetal
# deployments. The variables below can be used to extend those timeouts.

# (Optional) Increase bootstrap process timeout by N iterations.
increase_bootstrap_timeout=2

# (Optional) Increase install process timeout by N iterations.
increase_install_timeout=2

# (Optional) Disable RedFish inspection to intelligently choose between IPMI or RedFish protocol.
# By default this feature is enabled and set to true. Uncomment below to disable and use IPMI.
redfish_inspection=false

# (Optional) Modify files on the node filesystems, you can augment the "fake" roots for the 
# control plane and worker nodes.
# If defined, playbook will look for files in control plane and worker subdirectories.
# Otherwise, it will look in {{ role_path }}/files/customize_filesystem (default)
# For more information on modifying node filesystems visit: https://bit.ly/36tD30f
#customize_node_filesystems="/path/to/customized/filesystems"

# (Optional) Modify the path to add external manifests to the deployed nodes.
# There are two folders manifests/ and openshift/
# If defined, the playbook will copy manifests from the user provided directory.
# Otherwise, files will be copied from the default location 'roles/installer/files/manifests/*'
#customize_extramanifests_path="/path/to/extra/manifests"
#customize_extramanifestsopenshift_path="/path/to/extra/openshift"

# (Optional) Enable OVN hybirdOverlayConfig, it configures an additional overlay network for peers that are not using OVN.
# This variable is valid only if network_type=OVNKubernetes
# By default this is disabled and set to false. Set ovn_hybird_plugin to true to use BigIP ingress in a cluster.
ovn_hybird_plugin=true

# (Optional) Enable local gateway mode with OVN
ovn_local_gateway=true

# (Optional) Enable SCTP in the cluster
sctp=false

######################################
# Vars regarding install-config.yaml #
######################################

# Base domain, i.e. example.com
domain="scalelab"
# Name of the cluster, i.e. openshift
cluster="cluster-b"
# Note: Under some conditions, it may be useful to randomize the cluster name. For instance,
# when redeploying an existing environment this can help avoid VRID conflicts. You can
# set the cluster_random boolean below to true to append a random number to you cluster name.
cluster_random=false
# The public CIDR address, i.e. 10.1.1.0/21
extcidrnet="192.168.216.0/21"
#extcidrnet="192.168.216.0/21"
# The public CIDR address for IPv6 only and Dual-Stack deploys
#extcidrnet6="fd01:1102::/64"
extcidrnet6="fd01:1101::/64"

extcidrnet_offset=20

# NOTE: For the RH shared labs, the VIPs below are automated w/ variables
#       based on the extcidrnet above.

# An IP reserved on the baremetal network. 
dnsvip="{{ extcidrnet | next_nth_usable(extcidrnet_offset + 2) }}"
# An IP reserved on the baremetal network for the API endpoint. 
# (Optional) If not set, a DNS lookup verifies that api.<clustername>.<domain> provides an IP
apivip="{{ extcidrnet | next_nth_usable(extcidrnet_offset + 3) }}"
# An IP reserved on the baremetal network for the Ingress endpoint.
# (Optional) If not set, a DNS lookup verifies that *.apps.<clustername>.<domain> provides an IP
ingressvip="{{ extcidrnet | next_nth_usable(extcidrnet_offset + 4) }}"
# The master hosts provisioning nic
# (Optional) If not set, the prov_nic will be used
#masters_prov_nic=""
# Network Type (OpenShiftSDN or OVNKubernetes). Playbook defaults to OVNKubernetes.
# Uncomment below for OpenShiftSDN
network_type="OpenShiftSDN"
# (Optional) A URL to override the default operating system image for the bootstrap node.
# The URL must contain a sha256 hash of the image.
# See https://github.com/openshift/installer/blob/master/docs/user/metal/customization_ipi.md
#   Example https://mirror.example.com/images/qemu.qcow2.gz?sha256=a07bd...
#bootstraposimage=""
# (Optional) A URL to override the default operating system image for the cluster nodes.
# The URL must contain a sha256 hash of the image.
# See https://github.com/openshift/installer/blob/master/docs/user/metal/customization_ipi.md
# Example https://mirror.example.com/images/metal.qcow2.gz?sha256=3b5a8...
#clusterosimage=""

# (Optional) Disable BMC Certification Validation. When using self-signed certificates for your BMC, ensure to set to True.
# Default value is False.
disable_bmc_certificate_verification=True

# (Optional) Enable RedFish VirtualMedia/iDRAC VirtualMedia
#enable_virtualmedia=True

# (Required when enable_virtualmedia is set to True) Set an available IP address from the baremetal net for these two variables
#provisioningHostIP=<baremetal_net_IP1>
#bootstrapProvisioningIP=<baremetal_net_IP2>

# (Optional) Change the boot mode of the OpenShift cluster nodes to legacy mode (BIOS). Default is UEFI. 
bootmode=legacy

# (Optional) OpenShift 4.6+, Set Root Device Hints to choose the proper device to install operating system on OpenShift nodes.
# root device hint options include: ['deviceName','hctl','model','vendor','serialNumber','minSizeGigabytes','wwn','rotational']
# Root Device Hint values are case sensitive. If incorrect case given, entry omitted from install-config.yaml
# root_device_hint="deviceName"
# root_device_hint_value="/dev/sda"

# Registry Host
#   Define a host here to create or use a local copy of the installation registry
#   Used for disconnected installation
# [registry_host]
# registry.example.com

# [registry_host:vars]
# The following cert_* variables are needed to create the certificates
#   when creating a disconnected registry. They are not needed to use
#   an existing disconnected registry.
# cert_country=US  # two letters country
# cert_state=MyState
# cert_locality=MyCity
# cert_organization=MyCompany
# cert_organizational_unit=MyDepartment

# The port exposed on the disconnected registry host can be changed from
# the default 5000 to something else by changing the following variable.
# registry_port=5000

# The directory the mirrored registry files are written to can be modified from teh default /opt/registry by changing the following variable.
# registry_dir="/opt/registry"

# The following two variables must be set to use an existing disconnected registry.
#
# Specify a file that contains extra auth tokens to include in the
#   pull-secret if they are not already there.
# disconnected_registry_auths_file=/path/to/registry-auths.json

# Specify a file that contains the addition trust bundle and image
#   content sources for the local registry. The contents of this file
#   will be appended to the install-config.yml file.
# disconnected_registry_mirrors_file=/path/to/install-config-appends.json

node_inv_offset=7

[orchestration]
localhost ansible_connection=local ansible_python_interpreter="{{ ansible_playbook_python }}"


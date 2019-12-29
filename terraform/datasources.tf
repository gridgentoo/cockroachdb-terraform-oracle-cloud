# Get a list of Availability Domains
data "oci_identity_availability_domains" "ad" {
  compartment_id = "${var.tenancy_ocid}"
}

data "template_file" "ad_names" {
  count    = "${length(data.oci_identity_availability_domains.ad.availability_domains)}"
  template = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")}"
}

data "oci_core_vnic_attachments" "TFInstance_vnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[0],"name")}"
  instance_id         = "${oci_core_instance.TFInstance.*.id[0]}"
}

data "oci_core_vnic" "TFInstance_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.TFInstance_vnics.vnic_attachments[0], "vnic_id")}"
}

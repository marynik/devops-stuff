# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "id" {
  value = module.cluster.id
}

output "host" {
  value     = module.cluster.host
  sensitive = true
}

output "nameservers" {
  value = module.dns.dns_ns_names
}

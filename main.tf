
terraform {
  required_version = ">= 0.12.6"
  required_providers {
    dyn = ">= 1.0.0"
  }
}

locals {
  # The Dyn provider works in terms of records rather than recordsets, so
  # we'll need to flatten first.
  records = flatten([
    for rs in var.recordsets : [
      for r in rs.records : {
        name = rs.name
        type = rs.type
        ttl  = rs.ttl
        data = r
      }
    ]
  ])
}

resource "dyn_record" "this" {
  for_each = {
    for r in local.records : "${r.name} ${r.type} ${r.data}" => r
  }

  zone = var.zone_name

  name  = coalesce(each.value.name, "@")
  type  = each.value.type
  ttl   = each.value.ttl
  value = each.value.data
}

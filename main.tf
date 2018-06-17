
terraform {
  required_version = ">= 0.12.0"
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
  count = length(local.records)

  zone = var.zone_name

  name  = coalesce(local.records[count.index].name, "@")
  type  = local.records[count.index].type
  ttl   = local.records[count.index].ttl
  value = local.records[count.index].data
}

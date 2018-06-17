# Dyn DNS Recordsets Module

This module manages DNS recordsets in a given DNS zone hosted by Dyn. It
is part of [the `terraformdns` project](https://terraformdns.github.io/).

## Example Usage

```hcl
locals {
  dyn_zone_name = "example.com"
}

module "dns_records" {
  source = "terraformdns/dns-recordsets/dyn"

  zone_name = local.dyn_zone_name
  recordsets = [
    {
      name    = "www"
      type    = "A"
      ttl     = 3600
      records = [
        "192.0.2.56",
      ]
    },
    {
      name    = ""
      type    = "MX"
      ttl     = 3600
      records = [
        "1 mail1",
        "5 mail2",
        "5 mail3",
      ]
    },
    {
      name    = ""
      type    = "TXT"
      ttl     = 3600
      records = [
        "\"v=spf1 ip4:192.0.2.3 include:backoff.${local.dyn_zone_name} -all\"",
      ]
    },
  ]
}
```

## Compatibility

When using this module, always use a version constraint that constraints to at
least a single major version. Future major versions may have new or different
required arguments, and may use a different internal structure that could
cause recordsets to be removed and replaced by the next plan.

## Arguments

- `zone_name` is the name of the Dyn-hosted zone to add the records to.
- `recordsets` is a list of DNS recordsets in the standard `terraformdns`
  recordset format.

This module requires the `dyn` provider.

Due to current limitations of the Terraform language, recordsets in Dyn
are correlated to `recordsets` elements using the index into the
`recordsets` list. Adding or removing records from the list will therefore
cause this module to also update all records with indices greater than where
the addition or removal was made.

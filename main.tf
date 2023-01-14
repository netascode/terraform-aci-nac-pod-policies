locals {
  modules      = try(var.model.modules, {})
  pod_policies = try(var.model.apic.pod_policies, {})
}

module "aci_pod_setup" {
  source  = "netascode/pod-setup/aci"
  version = "0.1.0"

  for_each = { for pod in try(local.pod_policies.pods, []) : pod.id => pod if try(local.modules.aci_pod_setup, true) }
  pod_id   = each.value.id
  tep_pool = try(each.value.tep_pool, null)
}

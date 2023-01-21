locals {
  modules      = try(var.model.modules, {})
  pod_policies = try(var.model.apic.pod_policies, {})
}

resource "null_resource" "dependencies" {
  triggers = {
    dependencies = join(",", var.dependencies)
  }
}

module "aci_pod_setup" {
  source  = "netascode/pod-setup/aci"
  version = "0.1.0"

  for_each = { for pod in try(local.pod_policies.pods, []) : pod.id => pod if try(local.modules.aci_pod_setup, true) }
  pod_id   = each.value.id
  tep_pool = try(each.value.tep_pool, null)

  depends_on = [
    null_resource.dependencies,
  ]
}

resource "null_resource" "critical_resources_done" {
  triggers = {
  }
}

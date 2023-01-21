terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  model = {
    apic = {
      pod_policies = {
        pods = [{
          id       = 13
          tep_pool = "148.126.0.0/16"
        }]
      }
    }
  }
}

data "aci_rest_managed" "fabricSetupP" {
  dn = "uni/controller/setuppol/setupp-13"

  depends_on = [module.main]
}

resource "test_assertions" "fabricSetupP" {
  component = "fabricSetupP"

  equal "podId" {
    description = "podId"
    got         = data.aci_rest_managed.fabricSetupP.content.podId
    want        = "13"
  }

  equal "tepPool" {
    description = "tepPool"
    got         = data.aci_rest_managed.fabricSetupP.content.tepPool
    want        = "148.126.0.0/16"
  }
}

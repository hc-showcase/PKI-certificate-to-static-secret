provider "vault" {
}

resource "vault_pki_secret_backend_cert" "app1" {
  backend = "pki_int"
  name = "example-dot-com"

  common_name = "app1.example.com"
}

resource "vault_kv_secret_v2" "secret" {
  mount                      = "kv"
  name                       = "app1-certificate"
  cas                        = 1
  delete_all_versions        = true
  data_json                  = jsonencode(
  {
    certificate      = vault_pki_secret_backend_cert.app1.certificate,
    private_key      = vault_pki_secret_backend_cert.app1.private_key
  }
  )
  custom_metadata {
    max_versions = 5
    data = {
      owner = "Marc",
      usage = "App 1",
      planned_lifetime = "1d"
    }
  }
}

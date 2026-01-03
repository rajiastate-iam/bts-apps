terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.37.0"
    }
  }
}

resource "auth0_client" "app" {
  name        = var.display_name
  description = "Org: ${var.org_name} | SNOW: ${var.servicenow_req}"

  app_type            = var.app_type
  grant_types         = var.grant_types
  callbacks           = var.callbacks
  web_origins         = var.allowed_origins
  allowed_logout_urls = var.logout_urls

  client_metadata = merge(
    {
      org_name       = var.org_name
      servicenow_req = var.servicenow_req
    },
    var.client_metadata
  )

  jwt_configuration {
    lifetime_in_seconds = var.jwt_lifetime_in_seconds
  }

  is_first_party = true
}

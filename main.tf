locals {
  # All YAML files under apps/, e.g. apps/BTS/orders-spa-prod.yaml
  app_files = fileset("${path.module}/apps", "**/*.yaml")

  # Map of path -> decoded YAML
  app_objects = {
    for f in local.app_files :
    f => yamldecode(file("${path.module}/apps/${f}"))
  }

  # Normalized map with a friendly key: ORG-app-env
  apps = {
    for _, v in local.app_objects :
    format("%s-%s-%s", v.orgname, v.app, v.env) => v
  }
}

module "auth0_app" {
  source = "./modules/auth0-app"

  for_each = local.apps

  display_name             = each.value.displayname
  app_type                 = each.value.apptype
  callbacks                = each.value.callbacks
  logout_urls              = try(each.value.logouturls, [])
  allowed_origins          = try(each.value.allowedorigins, [])
  grant_types              = each.value.granttypes
  client_metadata          = try(each.value.clientmetadata, {})
  jwt_lifetime_in_seconds = try(tonumber(each.value.jwtlifetimeinseconds), 3600)

  org_name       = each.value.orgname
  servicenow_req = each.value.servicenow_req
}

################################################################################
### Application Registration ###
################################################################################
resource "azuread_application_registration" "this" {
  description                            = var.description
  display_name                           = var.display_name
  group_membership_claims                = var.group_membership_claims
  homepage_url                           = var.homepage_url
  implicit_access_token_issuance_enabled = var.implicit_access_token_issuance_enabled
  implicit_id_token_issuance_enabled     = var.implicit_id_token_issuance_enabled
  logout_url                             = var.logout_url
  marketing_url                          = var.marketing_url
  notes                                  = var.notes
  privacy_statement_url                  = var.privacy_statement_url
  requested_access_token_version         = var.requested_access_token_version
  service_management_reference           = var.service_management_reference
  sign_in_audience                       = var.sign_in_audience
  support_url                            = var.support_url
  terms_of_service_url                   = var.terms_of_service_url
}

################################################################################
### Application Owners ###
################################################################################
resource "azuread_application_owner" "this" {
  for_each = toset(var.owners)

  application_id  = azuread_application_registration.this.id
  owner_object_id = each.value
}

################################################################################
### Application Public Client Flows ###
################################################################################
resource "azuread_application_fallback_public_client" "this" {
  count = var.fallback_public_client != null ? 1 : 0

  application_id = azuread_application_registration.this.id
  enabled        = var.fallback_public_client
}

################################################################################
### Application Identifier URIs ###
################################################################################
resource "azuread_application_identifier_uri" "default" {
  count = length(var.permission_scopes) > 0 ? 1 : 0

  application_id = azuread_application_registration.this.id
  identifier_uri = "api://${azuread_application_registration.this.client_id}"
}

resource "azuread_application_identifier_uri" "this" {
  for_each = toset(var.identifier_uris)

  application_id = azuread_application_registration.this.id
  identifier_uri = each.value
}

################################################################################
### Application Redirect URIs ###
################################################################################
resource "azuread_application_redirect_uris" "public_client" {
  count = length(var.redirect_uris_public_client) > 0 ? 1 : 0

  application_id = azuread_application_registration.this.id
  redirect_uris  = var.redirect_uris_public_client
  type           = "PublicClient"
}

resource "azuread_application_redirect_uris" "spa" {
  count = length(var.redirect_uris_spa) > 0 ? 1 : 0

  application_id = azuread_application_registration.this.id
  redirect_uris  = var.redirect_uris_spa
  type           = "SPA"
}

resource "azuread_application_redirect_uris" "web" {
  count = length(var.redirect_uris_web) > 0 ? 1 : 0

  application_id = azuread_application_registration.this.id
  redirect_uris  = var.redirect_uris_web
  type           = "Web"
}

################################################################################
### Application Token Optional Claims ###
################################################################################
resource "azuread_application_optional_claims" "this" {
  count = var.optional_claims != null ? 1 : 0

  application_id = azuread_application_registration.this.id

  dynamic "access_token" {
    for_each = var.optional_claims.access_token[*]
    content {
      additional_properties = access_token.value.additional_properties
      essential             = access_token.value.essential
      name                  = access_token.value.name
      source                = access_token.value.source
    }
  }

  dynamic "id_token" {
    for_each = var.optional_claims.id_token[*]
    content {
      additional_properties = id_token.value.additional_properties
      essential             = id_token.value.essential
      name                  = id_token.value.name
      source                = id_token.value.source
    }
  }

  dynamic "saml2_token" {
    for_each = var.optional_claims.saml2_token[*]
    content {
      additional_properties = saml2_token.value.additional_properties
      essential             = saml2_token.value.essential
      name                  = saml2_token.value.name
      source                = saml2_token.value.source
    }
  }
}

################################################################################
### Application API Permissions ###
################################################################################
resource "azuread_application_api_access" "this" {
  for_each = var.required_api_access

  application_id = azuread_application_registration.this.id
  api_client_id  = each.value.api_client_id
  role_ids       = each.value.role_ids
  scope_ids      = each.value.scope_ids
}

### Retrieve the service principal for the required API access ###
data "azuread_service_principal" "required_access" {
  for_each = var.required_api_access

  client_id = each.value.api_client_id
}

### Grant admin consent on the requested application permissions ###
resource "azuread_app_role_assignment" "this" {
  for_each = transpose({ for k, v in var.required_api_access : k => v.role_ids if length(v.role_ids) > 0 && var.grant_admin_consent_application_permissions })

  app_role_id         = each.key
  principal_object_id = azuread_service_principal.this.object_id
  resource_object_id  = data.azuread_service_principal.required_access[one(each.value)].object_id
}

### Grant admin consent on the requested delegated permissions ###
resource "azuread_service_principal_delegated_permission_grant" "this" {
  for_each = { for k, v in var.required_api_access : k => v.scope_ids if length(v.scope_ids) > 0 && var.grant_admin_consent_delegated_permissions }

  claim_values                         = [for id in each.value : local.inverted_oauth2_permission_scope_ids[each.key][id]]
  resource_service_principal_object_id = data.azuread_service_principal.required_access[each.key].object_id
  service_principal_object_id          = azuread_service_principal.this.object_id
}

################################################################################
### Application Exposed API Scopes ###
################################################################################
resource "random_uuid" "scope" {
  for_each = { for k, v in var.permission_scopes : k => v if v.id == null }
}

resource "azuread_application_permission_scope" "this" {
  for_each = var.permission_scopes

  application_id             = azuread_application_registration.this.id
  admin_consent_description  = each.value.admin_consent_description
  admin_consent_display_name = each.value.admin_consent_display_name
  scope_id                   = coalesce(each.value.id, random_uuid.scope[each.key].result)
  type                       = each.value.type
  user_consent_description   = each.value.user_consent_description
  user_consent_display_name  = each.value.user_consent_display_name
  value                      = coalesce(each.value.value, each.key)
}

################################################################################
### Application Roles ###
################################################################################
resource "random_uuid" "role" {
  for_each = { for k, v in var.roles : k => v if v.id == null }
}

resource "azuread_application_app_role" "this" {
  for_each = var.roles

  application_id       = azuread_application_registration.this.id
  allowed_member_types = each.value.allowed_member_types
  description          = coalesce(each.value.description, each.key)
  display_name         = coalesce(each.value.display_name, each.key)
  role_id              = coalesce(each.value.id, random_uuid.role[each.key].result)
  value                = coalesce(each.value.value, each.key)
}

################################################################################
### Application Federated Identity Credentials ###
################################################################################
resource "azuread_application_federated_identity_credential" "this" {
  for_each = var.federated_identity_credentials

  application_id = azuread_application_registration.this.id
  audiences      = each.value.audiences
  description    = each.value.description
  display_name   = each.value.display_name
  issuer         = each.value.issuer
  subject        = each.value.subject
}

################################################################################
### Application Password ###
################################################################################
resource "time_rotating" "this" {
  count = var.generate_password && var.password_rotation_days > 0 ? 1 : 0

  rotation_days = var.password_rotation_days
}

resource "azuread_application_password" "this" {
  count = var.generate_password ? 1 : 0

  application_id = azuread_application_registration.this.id
  display_name   = "Managed by Terraform"

  rotate_when_changed = {
    rotation = var.password_rotation_days > 0 ? time_rotating.this[0].id : null
  }
}

################################################################################
### Application Service Principal ###
################################################################################
resource "azuread_service_principal" "this" {
  client_id                    = azuread_application_registration.this.client_id
  app_role_assignment_required = var.app_role_assignment_required
  tags                         = var.tags
}

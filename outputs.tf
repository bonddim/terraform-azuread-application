output "client_id" {
  description = "Application client ID."
  value       = azuread_application_registration.this.client_id
}

output "id" {
  description = "Application resource ID."
  value       = azuread_application_registration.this.id
}

output "oauth2_permission_scope_ids" {
  description = "Exposed OAuth2 permission scopes mapping."
  value       = { for k, v in azuread_application_permission_scope.this : v.value => v.scope_id }
}

output "object_id" {
  description = "Application object ID."
  value       = azuread_application_registration.this.object_id
}

output "password" {
  description = "Application password value. Only available if 'generate_password' is true."
  value       = var.generate_password ? azuread_application_password.this[0].value : null
}

output "role_ids" {
  description = "Application roles mapping."
  value       = { for k, v in azuread_application_app_role.this : v.value => v.role_id }
}

output "scope_uris" {
  description = "Exposed OAuth2 permission scope URIs."
  value       = { for k, v in azuread_application_permission_scope.this : v.value => "${azuread_application_identifier_uri.default[0].identifier_uri}/${v.value}" }
}

output "spn_object_id" {
  description = "Service principal object ID for the application."
  value       = azuread_service_principal.this.object_id
}

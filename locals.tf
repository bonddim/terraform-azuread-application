locals {
  inverted_oauth2_permission_scope_ids = {
    for k, v in data.azuread_service_principal.required_access : k => zipmap(
      values(v.oauth2_permission_scope_ids),
      keys(v.oauth2_permission_scope_ids)
    )
  }
}

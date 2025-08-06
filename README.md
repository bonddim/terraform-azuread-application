# Terraform Microsoft Entra ID (Azure AD) Application Module

This Terraform module simplifies the creation and management of Microsoft Entra ID applications and service principals. It supports advanced configuration options such as app roles, permission scopes, federated identity credentials, optional claims, and password rotation. The module is designed to automate and standardize Microsoft Entra ID application registration for a variety of use cases, including web apps, APIs, and automation scenarios.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.12)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 3.4)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

- <a name="requirement_time"></a> [time](#requirement\_time) (~> 0.13)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 3.4)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.5)

- <a name="provider_time"></a> [time](#provider\_time) (~> 0.13)

## Resources

The following resources are used by this module:

- [azuread_app_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) (resource)
- [azuread_application_api_access.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_api_access) (resource)
- [azuread_application_app_role.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_app_role) (resource)
- [azuread_application_fallback_public_client.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_fallback_public_client) (resource)
- [azuread_application_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) (resource)
- [azuread_application_identifier_uri.default](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) (resource)
- [azuread_application_identifier_uri.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri) (resource)
- [azuread_application_optional_claims.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_optional_claims) (resource)
- [azuread_application_owner.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_owner) (resource)
- [azuread_application_password.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) (resource)
- [azuread_application_permission_scope.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_permission_scope) (resource)
- [azuread_application_redirect_uris.public_client](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_redirect_uris) (resource)
- [azuread_application_redirect_uris.spa](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_redirect_uris) (resource)
- [azuread_application_redirect_uris.web](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_redirect_uris) (resource)
- [azuread_application_registration.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_registration) (resource)
- [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) (resource)
- [azuread_service_principal_delegated_permission_grant.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) (resource)
- [random_uuid.role](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [random_uuid.scope](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) (resource)
- [azuread_service_principal.required_access](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_display_name"></a> [display\_name](#input\_display\_name)

Description: The display name for the application.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_app_role_assignment_required"></a> [app\_role\_assignment\_required](#input\_app\_role\_assignment\_required)

Description: Whether this service principal requires an app role assignment to a user or group before Azure AD will issue a user or access token to the application.

Type: `bool`

Default: `false`

### <a name="input_description"></a> [description](#input\_description)

Description: (Optional) A description of the application, as shown to end users.

Type: `string`

Default: `null`

### <a name="input_fallback_public_client"></a> [fallback\_public\_client](#input\_fallback\_public\_client)

Description: (Optional) Specifies explicitly whether the application is a public client. Appropriate for apps using token grant flows that don't use a redirect URI.

Type: `bool`

Default: `null`

### <a name="input_federated_identity_credentials"></a> [federated\_identity\_credentials](#input\_federated\_identity\_credentials)

Description: (Optional) A collection of federated identity credentials for this application.

Type:

```hcl
map(object({
    audiences    = optional(list(string), ["api://AzureADTokenExchange"])
    description  = optional(string)
    display_name = string
    issuer       = string
    subject      = string
  }))
```

Default: `{}`

### <a name="input_generate_password"></a> [generate\_password](#input\_generate\_password)

Description: Whether to generate a password for the application.

Type: `bool`

Default: `false`

### <a name="input_grant_admin_consent_application_permissions"></a> [grant\_admin\_consent\_application\_permissions](#input\_grant\_admin\_consent\_application\_permissions)

Description: Whether to grant admin consent on the application permissions.

Type: `bool`

Default: `false`

### <a name="input_grant_admin_consent_delegated_permissions"></a> [grant\_admin\_consent\_delegated\_permissions](#input\_grant\_admin\_consent\_delegated\_permissions)

Description: Whether to grant admin consent on the delegated permissions.

Type: `bool`

Default: `false`

### <a name="input_group_membership_claims"></a> [group\_membership\_claims](#input\_group\_membership\_claims)

Description: (Optional) Configures the groups claim issued in a user or OAuth access token that the app expects. Possible values are `None`, `SecurityGroup`, `DirectoryRole`, `ApplicationGroup` or `All`.

Type: `list(string)`

Default: `null`

### <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url)

Description: (Optional) Home page or landing page of the application.

Type: `string`

Default: `null`

### <a name="input_identifier_uris"></a> [identifier\_uris](#input\_identifier\_uris)

Description: (Optional) A list of the user-defined URI or URI-like string that uniquely identifies an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant.

Type: `list(string)`

Default: `[]`

### <a name="input_implicit_access_token_issuance_enabled"></a> [implicit\_access\_token\_issuance\_enabled](#input\_implicit\_access\_token\_issuance\_enabled)

Description: (Optional) Whether this application can request an access token using OAuth implicit flow.

Type: `bool`

Default: `null`

### <a name="input_implicit_id_token_issuance_enabled"></a> [implicit\_id\_token\_issuance\_enabled](#input\_implicit\_id\_token\_issuance\_enabled)

Description: (Optional) Whether this web application can request an ID token using OAuth implicit flow.

Type: `bool`

Default: `null`

### <a name="input_logout_url"></a> [logout\_url](#input\_logout\_url)

Description: (Optional) The URL that will be used by Microsoft's authorization service to sign out a user using front-channel, back-channel or SAML logout protocols.

Type: `string`

Default: `null`

### <a name="input_marketing_url"></a> [marketing\_url](#input\_marketing\_url)

Description: (Optional) URL of the marketing page for the application.

Type: `string`

Default: `null`

### <a name="input_notes"></a> [notes](#input\_notes)

Description: (Optional) User-specified notes relevant for the management of the application.

Type: `string`

Default: `null`

### <a name="input_optional_claims"></a> [optional\_claims](#input\_optional\_claims)

Description: (Optional) A collection of optional claims to be included in the access token, ID token, and SAML2 token.

Type:

```hcl
object({
    access_token = optional(list(object({
      additional_properties = optional(list(string))
      essential             = optional(bool)
      name                  = string
      source                = optional(string)
    })), [])
    id_token = optional(list(object({
      additional_properties = optional(list(string))
      essential             = optional(bool)
      name                  = string
      source                = optional(string)
    })), [])
    saml2_token = optional(list(object({
      additional_properties = optional(list(string))
      essential             = optional(bool)
      name                  = optional(string)
      source                = optional(string)
    })), [])
  })
```

Default: `null`

### <a name="input_owners"></a> [owners](#input\_owners)

Description: (Optional) A list of object IDs of the principals that will be granted ownership of the application.

Type: `list(string)`

Default: `[]`

### <a name="input_password_rotation_days"></a> [password\_rotation\_days](#input\_password\_rotation\_days)

Description: Number of days before the password is rotated. If set to 0, the password will not be rotated.

Type: `number`

Default: `180`

### <a name="input_permission_scopes"></a> [permission\_scopes](#input\_permission\_scopes)

Description: (Optional) A collection of exposed permission scopes by the application.

Type:

```hcl
map(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    id                         = optional(string)
    type                       = optional(string)
    user_consent_description   = optional(string)
    user_consent_display_name  = optional(string)
    value                      = optional(string)
  }))
```

Default: `{}`

### <a name="input_privacy_statement_url"></a> [privacy\_statement\_url](#input\_privacy\_statement\_url)

Description: (Optional) URL of the privacy statement for the application.

Type: `string`

Default: `null`

### <a name="input_redirect_uris_public_client"></a> [redirect\_uris\_public\_client](#input\_redirect\_uris\_public\_client)

Description: (Optional) A list of redirect URIs for public client applications (e.g., mobile or desktop apps).

Type: `list(string)`

Default: `[]`

### <a name="input_redirect_uris_spa"></a> [redirect\_uris\_spa](#input\_redirect\_uris\_spa)

Description: (Optional) A list of redirect URIs for single-page applications (SPAs). These are typically used in web applications that run entirely in the browser.

Type: `list(string)`

Default: `[]`

### <a name="input_redirect_uris_web"></a> [redirect\_uris\_web](#input\_redirect\_uris\_web)

Description: (Optional) A list of redirect URIs for web applications. These are typically used in server-side web applications.

Type: `list(string)`

Default: `[]`

### <a name="input_requested_access_token_version"></a> [requested\_access\_token\_version](#input\_requested\_access\_token\_version)

Description: (Optional) The access token version expected by this resource. Must be one of 1 or 2, and must be 2 when sign\_in\_audience is either AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount Defaults to 2.

Type: `number`

Default: `2`

### <a name="input_required_api_access"></a> [required\_api\_access](#input\_required\_api\_access)

Description: (Optional) A collection of required API access by this application.

Type:

```hcl
map(object({
    api_client_id = string
    scope_ids     = optional(list(string), [])
    role_ids      = optional(list(string), [])
  }))
```

Default: `{}`

### <a name="input_roles"></a> [roles](#input\_roles)

Description: (Optional) A collection of roles for this application.

Type:

```hcl
map(object({
    allowed_member_types = optional(list(string), ["User"])
    description          = optional(string)
    display_name         = optional(string)
    id                   = optional(string)
    value                = optional(string)
  }))
```

Default: `{}`

### <a name="input_service_management_reference"></a> [service\_management\_reference](#input\_service\_management\_reference)

Description: (Optional) References application context information from a Service or Asset Management database.

Type: `string`

Default: `null`

### <a name="input_sign_in_audience"></a> [sign\_in\_audience](#input\_sign\_in\_audience)

Description: (Optional) The Microsoft account types that are supported for the current application. Must be one of `AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount` or `PersonalMicrosoftAccount`. Defaults to `AzureADMyOrg`.

Type: `string`

Default: `"AzureADMyOrg"`

### <a name="input_support_url"></a> [support\_url](#input\_support\_url)

Description: (Optional) URL of the support page for the application.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: A set of tags to apply to the service principal.

Type: `list(string)`

Default:

```json
[
  "WindowsAzureActiveDirectoryIntegratedApp"
]
```

### <a name="input_terms_of_service_url"></a> [terms\_of\_service\_url](#input\_terms\_of\_service\_url)

Description: (Optional) URL of the terms of service statement for the application.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_client_id"></a> [client\_id](#output\_client\_id)

Description: Application client ID.

### <a name="output_id"></a> [id](#output\_id)

Description: Application resource ID.

### <a name="output_oauth2_permission_scope_ids"></a> [oauth2\_permission\_scope\_ids](#output\_oauth2\_permission\_scope\_ids)

Description: Exposed OAuth2 permission scopes mapping.

### <a name="output_object_id"></a> [object\_id](#output\_object\_id)

Description: Application object ID.

### <a name="output_password"></a> [password](#output\_password)

Description: Application password value. Only available if 'generate\_password' is true.

### <a name="output_role_ids"></a> [role\_ids](#output\_role\_ids)

Description: Application roles mapping.

### <a name="output_scope_uris"></a> [scope\_uris](#output\_scope\_uris)

Description: Exposed OAuth2 permission scope URIs.

### <a name="output_spn_object_id"></a> [spn\_object\_id](#output\_spn\_object\_id)

Description: Service principal object ID for the application.
<!-- END_TF_DOCS -->

variable "description" {
  type        = string
  default     = null
  description = "(Optional) A description of the application, as shown to end users."
}

variable "display_name" {
  type        = string
  description = "The display name for the application."
}

variable "group_membership_claims" {
  type        = list(string)
  default     = null
  description = "(Optional) Configures the groups claim issued in a user or OAuth access token that the app expects. Possible values are `None`, `SecurityGroup`, `DirectoryRole`, `ApplicationGroup` or `All`."

  validation {
    condition     = var.group_membership_claims == null || alltrue([for v in var.group_membership_claims : contains(["None", "SecurityGroup", "DirectoryRole", "ApplicationGroup", "All"], v)])
    error_message = "Valid values for group_membership_claims are None, SecurityGroup, DirectoryRole, ApplicationGroup or All."
  }
}

variable "homepage_url" {
  type        = string
  default     = null
  description = "(Optional) Home page or landing page of the application."
}

variable "implicit_access_token_issuance_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether this application can request an access token using OAuth implicit flow."
}

variable "implicit_id_token_issuance_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Whether this web application can request an ID token using OAuth implicit flow."
}

variable "logout_url" {
  type        = string
  default     = null
  description = "(Optional) The URL that will be used by Microsoft's authorization service to sign out a user using front-channel, back-channel or SAML logout protocols."
}

variable "marketing_url" {
  type        = string
  default     = null
  description = "(Optional) URL of the marketing page for the application."
}

variable "notes" {
  type        = string
  default     = null
  description = "(Optional) User-specified notes relevant for the management of the application."
}

variable "privacy_statement_url" {
  type        = string
  default     = null
  description = "(Optional) URL of the privacy statement for the application."
}

variable "requested_access_token_version" {
  type        = number
  default     = 2
  description = "(Optional) The access token version expected by this resource. Must be one of 1 or 2, and must be 2 when sign_in_audience is either AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount Defaults to 2."
}

variable "service_management_reference" {
  type        = string
  default     = null
  description = "(Optional) References application context information from a Service or Asset Management database."
}

variable "sign_in_audience" {
  type        = string
  default     = "AzureADMyOrg"
  description = "(Optional) The Microsoft account types that are supported for the current application. Must be one of `AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount` or `PersonalMicrosoftAccount`. Defaults to `AzureADMyOrg`."

  validation {
    condition     = contains(["AzureADMyOrg", "AzureADMultipleOrgs", "AzureADandPersonalMicrosoftAccount", "PersonalMicrosoftAccount"], var.sign_in_audience)
    error_message = "Valid value is one of the following: AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount or PersonalMicrosoftAccount."
  }
}

variable "support_url" {
  type        = string
  default     = null
  description = "(Optional) URL of the support page for the application."
}

variable "terms_of_service_url" {
  type        = string
  default     = null
  description = "(Optional) URL of the terms of service statement for the application."
}

variable "owners" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of object IDs of the principals that will be granted ownership of the application."
  nullable    = false
}

variable "fallback_public_client" {
  type        = bool
  default     = null
  description = "(Optional) Specifies explicitly whether the application is a public client. Appropriate for apps using token grant flows that don't use a redirect URI."
}

variable "identifier_uris" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of the user-defined URI or URI-like string that uniquely identifies an application within its Azure AD tenant, or within a verified custom domain if the application is multi-tenant."
  nullable    = false
}

variable "redirect_uris_public_client" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of redirect URIs for public client applications (e.g., mobile or desktop apps)."
  nullable    = false
}

variable "redirect_uris_spa" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of redirect URIs for single-page applications (SPAs). These are typically used in web applications that run entirely in the browser."
}

variable "redirect_uris_web" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of redirect URIs for web applications. These are typically used in server-side web applications."
  nullable    = false
}

variable "optional_claims" {
  type = object({
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
  default     = null
  description = "(Optional) A collection of optional claims to be included in the access token, ID token, and SAML2 token."
}

variable "required_api_access" {
  type = map(object({
    api_client_id = string
    scope_ids     = optional(list(string), [])
    role_ids      = optional(list(string), [])
  }))
  default     = {}
  description = "(Optional) A collection of required API access by this application."
  nullable    = false
}

variable "grant_admin_consent_application_permissions" {
  type        = bool
  default     = false
  description = "Whether to grant admin consent on the application permissions."
}

variable "grant_admin_consent_delegated_permissions" {
  type        = bool
  default     = false
  description = "Whether to grant admin consent on the delegated permissions."
}

variable "permission_scopes" {
  type = map(object({
    admin_consent_description  = string
    admin_consent_display_name = string
    id                         = optional(string)
    type                       = optional(string)
    user_consent_description   = optional(string)
    user_consent_display_name  = optional(string)
    value                      = optional(string)
  }))
  default     = {}
  description = "(Optional) A collection of exposed permission scopes by the application."
}

variable "pre_authorized_clients" {
  type = map(object({
    authorized_client_id = string
    permission_scopes    = optional(list(string), [])
  }))
  default     = {}
  description = <<-EOF
    (Optional) A collection of pre-authorized client applications for this application's exposed permission scopes.
    If `permission_scopes` is not provided, the client application will be pre-authorized for all of the application's exposed permission scopes.
    If defined, `permission_scopes` should match keys in the `permission_scopes` variable of this application.
  EOF
}

variable "roles" {
  type = map(object({
    allowed_member_types = optional(list(string), ["User"])
    description          = optional(string)
    display_name         = optional(string)
    id                   = optional(string)
    value                = optional(string)
  }))
  default     = {}
  description = "(Optional) A collection of roles for this application."
}

variable "federated_identity_credentials" {
  type = map(object({
    audiences    = optional(list(string), ["api://AzureADTokenExchange"])
    description  = optional(string)
    display_name = string
    issuer       = string
    subject      = string
  }))
  default     = {}
  description = "(Optional) A collection of federated identity credentials for this application."
}

variable "generate_password" {
  type        = bool
  default     = false
  description = "Whether to generate a password for the application."
}

variable "password_rotation_days" {
  type        = number
  default     = 180
  description = "Number of days before the password is rotated. If set to 0, the password will not be rotated."
}

variable "tags" {
  type        = list(string)
  default     = ["WindowsAzureActiveDirectoryIntegratedApp"]
  description = "A set of tags to apply to the service principal."
}

variable "app_role_assignment_required" {
  type        = bool
  default     = false
  description = "Whether this service principal requires an app role assignment to a user or group before Azure AD will issue a user or access token to the application."
}

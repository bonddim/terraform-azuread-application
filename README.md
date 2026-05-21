# Terraform Module for Microsoft Entra ID Application

![Terraform Module Downloads](https://img.shields.io/terraform/module/dt/bonddim/application/azuread?style=for-the-badge&logo=terraform)
![GitHub last commit](https://img.shields.io/github/last-commit/bonddim/terraform-azuread-application?style=for-the-badge&logo=github)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/bonddim/terraform-azuread-application/ci.yml?branch=main&style=for-the-badge&logo=github&label=CI)

This Terraform module simplifies the creation and management of Microsoft Entra ID applications and service principals.

The module is designed to automate and standardize Microsoft Entra ID application registration for a variety of use cases, including web apps, APIs, and automation scenarios.
It supports advanced configuration options such as application roles, permission scopes, federated identity credentials, optional claims, password rotation, and more.

Full input, output, provider, and resource documentation is available on the [Terraform Registry](https://registry.terraform.io/modules/bonddim/application/azuread/latest).

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
- [Examples](#examples)
- [Security and permissions](#security-and-permissions)
- [License](#license)

## Features

- Creates a Microsoft Entra ID application registration and service principal.
- Assigns application owners and service principal tags.
- Configures web, SPA, and public client redirect URIs.
- Manages identifier URIs, exposed API permission scopes, application roles, and pre-authorized clients.
- Requests API access to other applications, including delegated scopes and application roles.
- Optionally grants admin consent for requested delegated and application permissions.
- Configures federated identity credentials for workload identity federation.
- Configures optional claims for access tokens, ID tokens, and SAML2 tokens.
- Optionally creates and rotates an application password.

## Requirements

- Terraform `~> 1.12`
- AzureAD provider `~> 3.4`
- Permissions in Microsoft Entra ID to create and manage application registrations and service principals.

## Usage

```hcl
module "application" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name = "example-application"
}
```

For the complete variable and output reference, see the [module page on the Terraform Registry](https://registry.terraform.io/modules/bonddim/application/azuread/latest).

## Examples

### Basic application registration

```hcl
module "application" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name = "my-application"
}
```

### Web application redirect URIs

```hcl
module "web_application" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name      = "my-web-application"
  homepage_url      = "https://app.example.com"
  logout_url        = "https://app.example.com/logout"
  redirect_uris_web = ["https://app.example.com/auth/callback"]
}
```

### Exposed API scopes and roles

```hcl
module "api_application" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name = "my-api"

  permission_scopes = {
    access = {
      admin_consent_description  = "Allow the application to access my-api."
      admin_consent_display_name = "Access my-api"
      value                      = "user_impersonation"
    }
  }

  roles = {
    admin = {
      allowed_member_types = ["User", "Application"]
      description          = "Administrator access to my-api."
      display_name         = "Administrator"
      value                = "Admin"
    }
  }
}
```

### Federated identity credential for CI/OIDC

```hcl
module "ci_application" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name = "github-actions-ci"

  federated_identity_credentials = {
    main = {
      display_name = "github-main"
      issuer       = "https://token.actions.githubusercontent.com"
      subject      = "repo:example-org/example-repo:ref:refs/heads/main"
    }
  }
}
```

### Generated password with rotation

```hcl
module "application_with_password" {
  source  = "bonddim/application/azuread"
  version = "~> 1.0"

  display_name           = "automation-client"
  generate_password      = true
  password_rotation_days = 90
}
```

## Security and permissions

Granting admin consent changes tenant-wide application access.
Use `grant_admin_consent_application_permissions`
and `grant_admin_consent_delegated_permissions` only from a pipeline
or identity that is intentionally allowed to approve those permissions.

When `generate_password` is enabled, the generated secret is returned through
the `password` output and stored in Terraform state.
Keep state encrypted, restrict access to it, and prefer federated identity
credentials for CI/CD workloads when possible.

## License

This module is released under the license in [LICENSE](LICENSE).

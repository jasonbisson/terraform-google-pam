# terraform-google-pam

### Detailed
This module will showcase our new privilege access management product with examples of deployments at the organization, folder, and project levels. This new capability is critical for customers who want to improve their security posture for human access to their Google Cloud environment. The capability can expand to robot accounts, but this demo will focus on human access.

The resources/services/activations/deletions that this module will create/trigger are:

- Create PAM Entitlement for either organization, folder, and project.

## Demo Architecture
![Reference Architecture](diagram/pam.png)

## Documentation
- [PAM Overview](https://cloud.google.com/iam/docs/pam-overview)

## Cost
- No cost during public preview

## Usage
1. Clone repo
```
git clone https://github.com/jasonbisson/terraform-google-pam.git

```

2. Rename and update required variables in terraform.tvfars.template
```
Change directory to modules and select the level (organization, folder, and project)  to deploy.
mv terraform.tfvars.template terraform.tfvars
#Update required variables
```
3. Execute Terraform commands with existing identity (human or service account) to build Vertex Workbench Infrastructure 

```
terraform init
terraform plan
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_email\_recipients | List of Admin emails to be notified | `string` | n/a | yes |
| approver\_email\_recipients | List of approver emails to be notified | `string` | n/a | yes |
| approvers | Google group email that containers all the approvers. The group value is hard coded to enforce best practices | `string` | n/a | yes |
| entitlements | Entitlements for each project | <pre>list(object({<br>    project            = string<br>    entitlement_prefix = string<br>    role               = string<br>    expression         = string<br>    members            = list(string)<br>  }))</pre> | n/a | yes |
| requester\_email\_recipients | List of requestor emails to be notified | `string` | n/a | yes |
| require\_approver\_justification | Require justification for approver | `string` | `"true"` | no |
| session\_duration | Entitlement Session Duration | `string` | `"3600s"` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Deployment Account

A service account or human user with the following roles must be used to provision
the resources of this module:

- Privelege Access Management Admin: `roles/privilegedaccessmanager.admin`

### APIs

A project level deployment with the following APIs enabled must be used to host the
resources of this module:

- Privelege Access Management API: `privilegedaccessmanager.googleapis.com`


## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).
# terraform-google-pam

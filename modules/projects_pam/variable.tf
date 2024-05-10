variable "environment" {
  description = "Environment tag to help identify the entire deployment"
  type        = string
}

variable "project_id" {
description = "The project_id of the entitlement being deployed"
type = string
}

variable "session_duration" {
  description = "Entitlement Session Duration"
  type        = string
  default     = "3600s"
}

variable "iam_role" {
  description = "IAM role for Entitlement"
  type        = string
}

variable "requestor" {
description = "Google Group that will be entitled to submit requests for just in time access"
type        = string
}

variable admin_email_recipients {
    description = "List of Admin emails to be notified"
    type        = string
}

variable  requester_email_recipients {
    description = "List of requestor emails to be notified"
    type        = string
}

variable approver_email_recipients {
    description = "List of approver emails to be notified"
    type        = string
}

variable approvers {
    description = "Google group email that containers all the approvers. The group value is hard coded to enforce best practices"
    type = string
}

variable require_approver_justification {
    description = "Require justification for approver"
    type = string
    default = "true"

}

variable "conditional_bindings" {
  description = "List of maps of role and respective conditions, and the members to add the IAM policies/bindings"
  type        = string
  default = ""
}

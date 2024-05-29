/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "entitlements" {
  description = "Entitlements for each project"
  type = list(object({
    organization           = string
    entitlement_prefix = string
    role               = string
    expression         = string
    eligible_users     = list(string)
    approvers          = list(string)
  }))
}

variable "session_duration" {
  description = "Entitlement Session Duration"
  type        = string
  default     = "3600s"
}

variable "admin_email_recipients" {
  description = "List of Admin emails to be notified"
  type        = string
}

variable "requester_email_recipients" {
  description = "List of requestor emails to be notified"
  type        = string
}

variable "approver_email_recipients" {
  description = "List of approver emails to be notified"
  type        = string
}

variable "require_approver_justification" {
  description = "Require justification for approver"
  type        = string
  default     = "true"

}

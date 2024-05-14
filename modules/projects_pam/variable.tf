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

variable "environment" {
  description = "Environment tag to help identify the entire deployment"
  type        = string
}

variable "project_ids" {
  type = list(string)
  # description = "Add a list of project-ids "project1", "project2""

}

variable "requestors" {
  type = map(string)
  # default = {
  #   "project1" = "group-requestors-1"
  #   "project2" = "group-requestors-2"
  # }
}

variable "iam_roles" {
  type        = map(string)
  description = "A map of project IDs to their corresponding IAM roles."
  # default = {
  #   "project1" = "roles/viewer"
  #   "project2" = "roles/editor"
  # }
}

variable "conditional_bindings" {
  type        = map(string)
  description = "A map of project IDs to their IAM condition objects."
  # default = {
  #   "project1" = "iam condition expresssion"
  #   "project2" = "iam condition expresssion"
  # }
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

variable "approvers" {
  description = "Google group email that containers all the approvers. The group value is hard coded to enforce best practices"
  type        = string
}

variable "require_approver_justification" {
  description = "Require justification for approver"
  type        = string
  default     = "true"

}


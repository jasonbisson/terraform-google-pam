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

# resource "google_project_service" "cloudresourcemanager" {
#   project            = var.project_id
#   disable_on_destroy = false
#   service            = "cloudresourcemanager.googleapis.com"
# }

# resource "google_project_service" "privilegedaccessmanager" {
#   project            = var.project_id
#   disable_on_destroy = false
#   service            = "privilegedaccessmanager.googleapis.com"
# }

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_privileged_access_manager_entitlement" "entitlement" {
  provider = google-beta
  for_each = {
    for project in var.project_ids :
    project => {
      requestor          = var.requestors[project]
      role               = var.iam_roles[project]
      condition_bindings = var.conditional_bindings[project]
    }
  }
  entitlement_id       = "${var.environment}-${random_string.suffix.result}-${each.key}"
  location             = "global"
  max_request_duration = var.session_duration
  parent               = "projects/${each.key}"
  requester_justification_config {
    unstructured {}
  }
  eligible_users {
    principals = ["group:${each.value.requestor}"]
  }
  privileged_access {
    gcp_iam_access {
      role_bindings {
        role                 = each.value.role
        condition_expression = each.value.condition_bindings
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${each.key}"
      resource_type = "cloudresourcemanager.googleapis.com/Project"
    }
  }
  additional_notification_targets {
    admin_email_recipients     = [var.admin_email_recipients]
    requester_email_recipients = [var.requester_email_recipients]
  }
  approval_workflow {
    manual_approvals {
      require_approver_justification = var.require_approver_justification
      steps {
        approvals_needed          = 1
        approver_email_recipients = [var.approver_email_recipients]
        approvers {
          principals = ["group:${var.approvers}"]
        }
      }
    }
  }
}

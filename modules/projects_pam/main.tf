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



resource "google_project_service" "cloudresourcemanager" {
  for_each           = { for idx, entitlement in var.entitlements : idx => entitlement }
  project            = each.value.project
  disable_on_destroy = false
  service            = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "privilegedaccessmanager" {
  for_each           = { for idx, entitlement in var.entitlements : idx => entitlement }
  project            = each.value.project
  disable_on_destroy = false
  service            = "privilegedaccessmanager.googleapis.com"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_privileged_access_manager_entitlement" "entitlement" {
  provider             = google-beta
  for_each             = { for idx, entitlement in var.entitlements : idx => entitlement } # <-- Loop through entitlements
  entitlement_id       = "${each.value.entitlement_prefix}-${random_string.suffix.result}" # Use prefix from entitlement
  location             = "global"
  max_request_duration = var.session_duration
  parent               = "projects/${each.value.project}"
  requester_justification_config {
    unstructured {}
  }
  eligible_users {
    principals = [for member in each.value.members : member]
  }
  privileged_access {
    gcp_iam_access {
      role_bindings {
        role                 = each.value.role
        condition_expression = each.value.expression
      }
      resource      = "//cloudresourcemanager.googleapis.com/projects/${each.value.project}"
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
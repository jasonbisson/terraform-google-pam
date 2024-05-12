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

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_privileged_access_manager_entitlement" "entitlement" {
    provider =  google-beta
    entitlement_id = "${var.environment}-${random_string.suffix.result}"
    location = "global"
    max_request_duration = var.session_duration
    parent = "organizations/${var.organization_number}"
    requester_justification_config {    
        unstructured{}
    }
    eligible_users {
        principals = ["group:${var.requestor}"]
    }
    privileged_access{
        gcp_iam_access{
            role_bindings{
                role = var.iam_role
                condition_expression = var.conditional_bindings
            }
            resource = "//cloudresourcemanager.googleapis.com/organizations/${var.organization_number}"
            resource_type = "cloudresourcemanager.googleapis.com/Organization"
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
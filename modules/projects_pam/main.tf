resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  disable_on_destroy = false
  service            = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloudresourcemanager" {
  project            = var.project_id
  disable_on_destroy = false
  service            = "privilegedaccessmanager.googleapis.com"
}

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
    parent = "projects/${var.project_id}"
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
            resource = "//cloudresourcemanager.googleapis.com/projects/${var.project_id}"
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

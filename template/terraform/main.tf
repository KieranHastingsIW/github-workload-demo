terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
  required_version = ">= 1.0"
}

# Using HashiCorp's HTTP provider to make test requests

data "http" "test_endpoint" {
  url = "https://httpbin.org/json"

  request_headers = {
    Accept = "application/json"
    User-Agent = "terraform-test-workload"
  }
}

# Create a time resource for testing state management
resource "time_static" "deployment_time" {
  triggers = {
    deployment_id = var.deployment_id
  }
}

# Output the response for verification
output "test_response" {
  description = "Response from test HTTP endpoint"
  value = {
    status_code = data.http.test_endpoint.status_code
    response_body = jsondecode(data.http.test_endpoint.response_body)
  }
}

output "deployment_timestamp" {
  description = "Timestamp of deployment"
  value = time_static.deployment_time.unix
}

# Variable for customization
variable "deployment_id" {
  description = "Unique identifier for this deployment"
  type        = string
  default     = "test-workload"
}
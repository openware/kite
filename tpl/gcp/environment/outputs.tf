output service_account_b64 {
  description = "GCloud service account key"
  value       = "${base64encode(file("${var.credentials}"))}"
  sensitive   = true
}

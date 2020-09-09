output "public_key_pem" {
  sensitive   = true
  value       = tls_private_key.encryption.public_key_pem
  description = "Public Key used to encrypt values for Renovate Repo Level Config"
}

locals {
  auth_credentials = var.git_type == "bitbucket" && var.app_username != "" ? {
    RENOVATE_USERNAME = var.app_username
    RENOVATE_PASSWORD = var.app_password
  } : {
    RENOVATE_TOKEN = var.git_token
  }
}

resource "tls_private_key" "encryption" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubernetes_secret" "private_key" {
  metadata {
    name      = format("%s-key", var.name)
    namespace = var.k8s_namespace
  }

  data = {
    "decrypt.key" = tls_private_key.encryption.private_key_pem
  }
}

resource "kubernetes_secret" "renovate_secrets" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  data = local.auth_credentials
}

resource "kubernetes_config_map" "renovate_config" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  data = {
    "config.json" = jsonencode({
      gitAuthor      = "Renovate Bot <apps+renovate@goci.io>"
      platform       = var.git_type
      endpoint       = var.git_endpoint
      repositories   = var.repositories
      privateKeyPath = "/usr/src/app/decrypt.key"
      trustLevel     = "low"
    })
  }
}

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

  data = {
    RENOVATE_TOKEN = var.git_token
  }
}

resource "kubernetes_config_map" "renovate_config" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  data = {
    "config.json" = templatefile("${path.module}/templates/config.json", {
      git_type     = var.git_type
      git_endpoint = var.git_endpoint
      repositories = jsonencode(var.repositories)
    })
  }
}

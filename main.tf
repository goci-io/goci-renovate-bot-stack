resource "kubernetes_config_map" "renovate_config" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  data = {
    "config.json" = templatefile("${path.module}/templates/config.json", {
      git_type            = var.git_type
      git_endpoint        = var.git_endpoint
      git_encrypted_token = var.git_encrypted_token
      repositories        = jsonencode(var.repositories)
    })
  }
}

resource "kubernetes_cron_job" "renovate" {
  metadata {
    name      = var.name
    namespace = var.k8s_namespace
  }

  spec {
    failed_jobs_history_limit     = 3
    successful_jobs_history_limit = 1
    starting_deadline_seconds     = 300
    suspend                       = false
    schedule                      = var.schedule
    concurrency_policy            = "Replace"

    job_template {
      metadata {
        labels = {
          app     = "renovatebot"
          release = var.name
        }
      }

      spec {
        backoff_limit              = 3
        ttl_seconds_after_finished = 1800

        template {
          metadata {}

          spec {
            restart_policy = "OnFailure"

            volume {
              name = "config"

              config_map {
                name = kubernetes_config_map.renovate_config.metadata.0.name
              }
            }

            volume {
              name = "private-key"

              secret {
                default_mode = "0400"
                secret_name  = "${var.name}-key"
              }
            }

            container {
              name  = "renovate"
              image = "renovate/renovate:${var.renovate_version}"

              security_context {
                run_as_user                = 1000
                run_as_non_root            = true
                allow_privilege_escalation = false
              }

              resources {
                requests {
                  cpu    = "300m"
                  memory = "128Mi"
                }

                limits {
                  cpu    = "300m"
                  memory = "128Mi"
                }
              }

              volume_mount {
                read_only  = true
                name       = "config"
                sub_path   = "config.json"
                mount_path = "/usr/src/app/config.json"
              }

              volume_mount {
                read_only  = true
                name       = "private-key"
                sub_path   = "decrypt.key"
                mount_path = "/usr/src/app/decrypt.key"
              }
            }
          }
        }
      }
    }
  }
}

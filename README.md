# goci-renovate-bot-stack

**Maintained by [@goci-io/prp-terraform](https://github.com/orgs/goci-io/teams/prp-terraform)**

![terraform](https://github.com/goci-io/goci-renovate-bot-stack/workflows/terraform/badge.svg?branch=master&event=push)

[Install Stack on goci.io](https://goci.io/dashboard/providers/renovatebot/wizard)

### Contains:
- [Renovate Bot](https://github.com/renovatebot/renovate) as CronJob
- Renovate Self-Hosted Configuration

Requires a Secret (`<name>-key` in same `k8s_namespace` with a key of `decrypt.key`) to be present. This Secret must contain the Private Key used to encrypt config values.

**Note:** This Module is intended to be used as "root module".

_This repository was created via [github-repository](https://github.com/goci-io/github-repository)._

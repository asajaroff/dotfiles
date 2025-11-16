# Containerized Workflow

## Vision

Move development tools to containerized execution to ensure consistent environments across systems.

## Current Examples

See `alias` for working implementations:

- **hadolint**: Dockerfile linter via container
- **helm**: Kubernetes package manager with volume mounts for configs
- **helm2**: Legacy version in isolated container

## Future Candidates

Tools to containerize:

- **terraform / terragrunt **: Infrastructure as code
- **ansible**: Configuration management
- **aws-cli**: Cloud provider CLI
- **gcloud**: Google Cloud CLI
- **kubectl**: Already widely available as container
- **node/npm**: JavaScript runtime and package manager
- **python/pip**: Python interpreter and packages
- **go**: Go compiler and toolchain

## Implement my own containers for:
- [ ] Terragrunt and Tofu tooling
- [ ] Makefiles
- [ ] git-hooks

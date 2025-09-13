# Agent Guidelines for docker-miktex-with-git

This document outlines the conventions and commands for agents operating within this repository.

## 1. Build/Lint/Test Commands

*   **Build:** `docker build .`
*   **Lint (Dockerfile):** `hadolint Dockerfile` (recommendation, not explicitly in project)
*   **Test:** No explicit unit or integration tests are defined. Verification steps are embedded in the `Dockerfile` for MiKTeX package updates and in GitHub Actions for base image changes.

## 2. Code Style Guidelines

### Dockerfile
*   Combine `apt-get update` and `apt-get install` with `rm -rf /var/lib/apt/lists/*` in a single `RUN` layer.
*   Use `&& \` for multi-line `RUN` commands.
*   Utilize `LABEL` for image metadata.
*   Employ `retry` for robust commands (e.g., package updates).
*   Set environment variables using `ENV`.

### GitHub Actions (YAML)
*   Use official GitHub Actions (e.g., `actions/checkout`, `docker/login-action`).
*   Implement conditional job execution where appropriate.
*   Pass variables between steps using `GITHUB_OUTPUT`.
*   Automated commits should use `github-actions[bot]` for user.name and user.email.

# go-starter

This is a template codebase for creating go projects, with a Makefile driven
development workflow.

### Configuration Variables

These variables can be overridden using an `.env` file or passed as environment variables when invoking `make`.

| Variable          | Description                                                                |
| ----------------- | -------------------------------------------------------------------------- |
| `REGISTRY`        | Docker image registry (default: `localhost:5000`)                          |
| `VERSION`         | Project version derived from Git (default: `0.0.0` if no `.git` directory) |
| `GOOS`            | Target operating system for Go builds                                      |
| `GOARCH`          | Target architecture for Go builds                                          |
| `OS`              | Internal value based on `GOOS` or current OS                               |
| `ARCH`            | Internal value based on `GOARCH` or current architecture                   |
| `IMAGE_NAME`      | Docker image name (must be defined externally or in `.env`)                |
| `IMAGE_TAG`       | Docker image tag using version, OS, and ARCH                               |
| `GO_VERSION`      | Go version used in container builds (`1.23`)                               |
| `CONTAINER_IMAGE` | Docker base image for builds (`golang:1.23-alpine`)                        |


## Targets

### `make all`

> Builds the Docker image using the `Dockerfile`.

### `make run`

> Runs the application using Docker Compose, passing necessary env vars.

### `make release`

> Builds and publishes a new release using GoReleaser. Requires `GITHUB_TOKEN`.

### `make snapshot`

> Runs a **dry-run** of GoReleaser (no actual publishing).

### `make test`

> Runs all Go tests inside the project (`go test ./...`).

### `make lint`

> Runs linting scripts located in `./build/scripts/lint.sh`.

### `make clean`

> Cleans up Docker Compose services and deletes release artifacts (e.g., `dist/`).

### `make help`

> Displays available targets with descriptions (targets marked with `@HELP`).

### `make help-config`

> Lists configurable variables in the `Makefile` with file references.

### `make version`

> Prints the current version resolved from Git.

## Notes

- **.env file**: It's recommended to define `IMAGE_NAME` and optionally `REGISTRY`, `GOOS`, `GOARCH` in a `.env` file.
- **GoReleaser**: For release and snapshot targets, ensure `goreleaser` is installed and your project is correctly configured with a `.goreleaser.yml`.
- **Docker**: Ensure Docker and Docker Compose are installed and configured.
- **Git**: Tags are used for versioning; ensure your repo is initialized and tagged if you want meaningful `VERSION` values.


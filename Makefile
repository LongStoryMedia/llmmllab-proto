# Proto repository Makefile
# Manages Protocol Buffer compilation for llmmllab services

.PHONY: all generate clean check help

all: generate


# generate proto models
models:
	@echo "Generating proto models..."
	@for f in llmmllab-schemas/*.yaml; do schema2code -o $$(basename $${f%.yaml}).proto -l proto --package models --go-package models $$f; done;
	@echo "Proto models generated"

# Generate gRPC code for all services (includes stubs)
generate: generate-composer generate-runner generate-pyproject

# =============================================================================
# Composer Service
# =============================================================================

generate-composer:
	@echo "Generating composer gRPC code..."
	@mkdir -p gen/python
	@rm -rf gen/python/*
	@python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=gen/python \
		--grpc_python_out=gen/python \
		--pyi_out=gen/python \
		composer/v1/composer.proto \
		runner/v1/runner.proto \
		common/timestamp.proto \
		common/version.proto
	@echo "Composer gRPC code generated"

# =============================================================================
# Runner Service
# =============================================================================

generate-runner:
	@echo "Generating runner gRPC code..."
	@mkdir -p gen/python
	@rm -rf gen/python/*
	@python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=gen/python \
		--grpc_python_out=gen/python \
		--pyi_out=gen/python \
		runner/v1/runner.proto \
		composer/v1/composer.proto \
		common/timestamp.proto \
		common/version.proto
	@echo "Runner gRPC code generated"

# Generate pyproject.toml for generated code
generate-pyproject:
	@echo "Generating pyproject.toml..."
	@mkdir -p gen/python
	@echo '[build-system]' > gen/python/pyproject.toml
	@echo 'requires = ["setuptools>=61.0"]' >> gen/python/pyproject.toml
	@echo 'build-backend = "setuptools.build_meta"' >> gen/python/pyproject.toml
	@echo '' >> gen/python/pyproject.toml
	@echo '[project]' >> gen/python/pyproject.toml
	@echo 'name = "runner-grpc"' >> gen/python/pyproject.toml
	@echo 'version = "0.1.0"' >> gen/python/pyproject.toml
	@echo 'description = "gRPC code for the llmmllab runner service"' >> gen/python/pyproject.toml
	@echo 'readme = "README.md"' >> gen/python/pyproject.toml
	@echo 'license = {text = "MIT"}' >> gen/python/pyproject.toml
	@echo 'authors = [{name = "llmmllab Team"}]' >> gen/python/pyproject.toml
	@echo 'requires-python = ">=3.10"' >> gen/python/pyproject.toml
	@echo 'dependencies = [' >> gen/python/pyproject.toml
	@echo '    "grpcio>=1.78.0",' >> gen/python/pyproject.toml
	@echo '    "grpcio-tools>=1.78.0",' >> gen/python/pyproject.toml
	@echo '    "protobuf>=4.25.0",' >> gen/python/pyproject.toml
	@echo ']' >> gen/python/pyproject.toml
	@echo '' >> gen/python/pyproject.toml
	@echo '[tool.setuptools]' >> gen/python/pyproject.toml
	@echo 'packages = [' >> gen/python/pyproject.toml
	@echo '    "runner",' >> gen/python/pyproject.toml
	@echo '    "runner.v1",' >> gen/python/pyproject.toml
	@echo '    "server",' >> gen/python/pyproject.toml
	@echo '    "server.v1",' >> gen/python/pyproject.toml
	@echo '    "composer",' >> gen/python/pyproject.toml
	@echo '    "composer.v1",' >> gen/python/pyproject.toml
	@echo '    "common",' >> gen/python/pyproject.toml
	@echo ']' >> gen/python/pyproject.toml
	@echo '' >> gen/python/pyproject.toml
	@echo '[tool.setuptools.package-data]' >> gen/python/pyproject.toml
	@echo '"runner" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"runner.v1" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"server" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"server.v1" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"composer" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"composer.v1" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo '"common" = ["py.typed"]' >> gen/python/pyproject.toml
	@echo "pyproject.toml generated"

# =============================================================================
# Validation
# =============================================================================

check:
	@echo "Checking proto files..."
	@for proto in $$(find . -name "*.proto"); do \
		echo "  Checking $$proto..."; \
		protoc --proto_path=. --cpp_out=/tmp "$$proto" 2>&1 || exit 1; \
	done
	@echo "All proto files are valid"

# =============================================================================
# Help
# =============================================================================

help:
	@echo "Proto Repository Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  models				   - Generate proto models from YAML schemas"
	@echo "  generate              - Generate gRPC code for all services"
	@echo ""
	@echo "  generate-composer     - Generate composer gRPC code"
	@echo "  generate-runner       - Generate runner gRPC code"
	@echo ""
	@echo "  check                 - Validate proto files"
	@echo "  help                  - Show this help message"
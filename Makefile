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
	@mkdir -p ../composer/gen/python
	@rm -rf ../composer/gen/python/*
	python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=../composer/gen/python \
		--grpc_python_out=../composer/gen/python \
		--pyi_out=../composer/gen/python \
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
	@mkdir -p ../runner/gen/python
	@rm -rf ../runner/gen/python/*
	python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=../runner/gen/python \
		--grpc_python_out=../runner/gen/python \
		--pyi_out=../runner/gen/python \
		runner/v1/runner.proto \
		composer/v1/composer.proto \
		common/timestamp.proto \
		common/version.proto
	@echo "Runner gRPC code generated"

# Generate pyproject.toml for generated code
generate-pyproject:
	@echo "Generating pyproject.toml..."
	@mkdir -p ../runner/gen/python
	@echo '[build-system]' > ../runner/gen/python/pyproject.toml
	@echo 'requires = ["setuptools>=61.0"]' >> ../runner/gen/python/pyproject.toml
	@echo 'build-backend = "setuptools.build_meta"' >> ../runner/gen/python/pyproject.toml
	@echo '' >> ../runner/gen/python/pyproject.toml
	@echo '[project]' >> ../runner/gen/python/pyproject.toml
	@echo 'name = "runner-grpc"' >> ../runner/gen/python/pyproject.toml
	@echo 'version = "0.1.0"' >> ../runner/gen/python/pyproject.toml
	@echo 'description = "gRPC code for the llmmllab runner service"' >> ../runner/gen/python/pyproject.toml
	@echo 'readme = "README.md"' >> ../runner/gen/python/pyproject.toml
	@echo 'license = {text = "MIT"}' >> ../runner/gen/python/pyproject.toml
	@echo 'authors = [{name = "llmmllab Team"}]' >> ../runner/gen/python/pyproject.toml
	@echo 'requires-python = ">=3.10"' >> ../runner/gen/python/pyproject.toml
	@echo 'dependencies = [' >> ../runner/gen/python/pyproject.toml
	@echo '    "grpcio>=1.78.0",' >> ../runner/gen/python/pyproject.toml
	@echo '    "grpcio-tools>=1.78.0",' >> ../runner/gen/python/pyproject.toml
	@echo '    "protobuf>=4.25.0",' >> ../runner/gen/python/pyproject.toml
	@echo ']' >> ../runner/gen/python/pyproject.toml
	@echo '' >> ../runner/gen/python/pyproject.toml
	@echo '[tool.setuptools]' >> ../runner/gen/python/pyproject.toml
	@echo 'packages = [' >> ../runner/gen/python/pyproject.toml
	@echo '    "runner",' >> ../runner/gen/python/pyproject.toml
	@echo '    "runner.v1",' >> ../runner/gen/python/pyproject.toml
	@echo '    "server",' >> ../runner/gen/python/pyproject.toml
	@echo '    "server.v1",' >> ../runner/gen/python/pyproject.toml
	@echo '    "composer",' >> ../runner/gen/python/pyproject.toml
	@echo '    "composer.v1",' >> ../runner/gen/python/pyproject.toml
	@echo '    "common",' >> ../runner/gen/python/pyproject.toml
	@echo ']' >> ../runner/gen/python/pyproject.toml
	@echo '' >> ../runner/gen/python/pyproject.toml
	@echo '[tool.setuptools.package-data]' >> ../runner/gen/python/pyproject.toml
	@echo '"runner" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"runner.v1" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"server" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"server.v1" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"composer" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"composer.v1" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
	@echo '"common" = ["py.typed"]' >> ../runner/gen/python/pyproject.toml
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
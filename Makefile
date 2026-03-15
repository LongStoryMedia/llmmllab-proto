# Proto repository Makefile
# Manages Protocol Buffer compilation for llmmllab services

.PHONY: all generate clean check help

all: generate

# generate proto models
models:
	@echo "Generating proto models..."
	@for f in llmmllab-schemas/*.yaml; do schema2code -o $$(basename $${f%.yaml}).proto -l proto --package models --go-package models $$f; done;
	@echo "Proto models generated"

# Generate gRPC code for all services
generate: enerate-composer generate-runner

# =============================================================================
# Composer Service
# =============================================================================

generate-composer:
	@echo "Generating composer gRPC code..."
	@mkdir -p ../composer/gen/python
	python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=../composer/gen/python \
		--grpc_python_out=../composer/gen/python \
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
	python -m grpc_tools.protoc \
		-I. \
		-I/home/lsm/Nextcloud/llmmllab/server/.venv/lib/python3.12/site-packages \
		--python_out=../runner/gen/python \
		--grpc_python_out=../runner/gen/python \
		runner/v1/runner.proto \
		composer/v1/composer.proto \
		common/timestamp.proto \
		common/version.proto
	@echo "Runner gRPC code generated"\

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
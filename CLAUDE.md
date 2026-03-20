# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in the llmmllab-proto repository.

## Overview

The llmmllab-proto repository contains Protocol Buffer definitions for gRPC communication between services (server, composer, runner). It uses llmmllab-schemas as a git submodule to generate proto messages from YAML schema definitions.

## Submodules

- **llmmllab-schemas** - YAML schema definitions used to generate proto messages

## Commands

### Code Generation

```bash
# Generate proto messages from llmmllab-schemas
make messages
```

## Architecture

### Structure

```
proto/
├── llmmllab-schemas/    # Git submodule - YAML schema definitions
├── proto/               # Protocol Buffer definitions
│   └── v1/              # Versioned proto files
│       ├── *.proto      # Proto service and message definitions
├── gen/                 # Generated proto messages (auto-generated from schemas)
│   └── python/          # Python protobuf code
└── Makefile
```

### Key Principles

**Schema-Driven Proto Generation**: All proto messages are generated from YAML schemas in llmmllab-schemas. **Never edit proto messages directly** — edit the YAML schema and regenerate.

**Service Definitions**: Proto service definitions (*.proto files with service blocks) are manually maintained and define the gRPC API contracts between services.

## Local Development

### Makefile Paths

The `Makefile` has `PYTHON_PATH` hardcoded to `/home/lsm/Nextcloud/llmmllab/server/.venv/bin/python`. Override on the command line:

```bash
make generate-runner PYTHON_PATH=/path/to/venv/bin/python
```

### Submodule Setup

The `llmmllab-schemas` submodule must be initialized before generating:

```bash
git submodule update --init --recursive
```

### Proto Package Mismatch

The runner's `gen/python/runner/v1/` contains two generated files with different package names:
- `composer_runner_pb2.py` — old package `composer_runner.v1`
- `runner_pb2.py` — current package `runner.v1`

The canonical proto is `runner/v1/runner.proto` with `package runner.v1`. When regenerating, ensure the runner uses `runner_pb2` (not `composer_runner_pb2`) so the service is registered as `runner.v1.RunnerService` — which is what the composer client calls.

### Dependencies for Generation

The Python environment used for `grpc_tools.protoc` needs:
- `grpcio-tools`
- `googleapis-common-protos` (for `google.api` imports in proto files)

## Dependencies

This repository is a git submodule of:
- **llmmllab-server** - FastAPI inference service
- **llmmllab-composer** - Workflow orchestration service
- **llmmllab-runner** - Model execution service

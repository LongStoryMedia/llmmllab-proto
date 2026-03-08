# llmmllab Proto

This repository contains the Protocol Buffer definitions for the llmmllab microservices architecture.

## Overview

The proto repository defines gRPC service interfaces for communication between:

- **Server**: FastAPI inference service with HTTP endpoints
- **Composer**: LangGraph agent orchestration system
- **Runner**: Model execution pipeline system

## Directory Structure

```
proto/
├── common/           # Common protobuf types (timestamp, etc.)
├── server/           # Server service definitions
├── composer/         # Composer service definitions
├── runner/           # Runner service definitions
└── *.proto           # Standalone data model definitions
```

## Services

### ServerService
- HTTP endpoint orchestration
- Authentication and authorization
- Database operations
- Model management

### ComposerService
- Workflow composition
- Workflow execution with streaming
- Agent orchestration
- Tool calling

### RunnerService
- Pipeline creation and management
- Model execution
- Embedding generation
- Cache management

## Usage

### Prerequisites

Install gRPC Python tools:
```bash
pip install grpcio grpcio-tools
```

### Generating Code

```bash
# Generate all gRPC code
make generate

# Generate for specific service
make generate-server      # Generate server gRPC code
make generate-composer    # Generate composer gRPC code
make generate-runner      # Generate runner gRPC code

# Generate Python code only
make generate-python

# Generate TypeScript code only
make generate-typescript
```

### Adding New Services

1. Create a new `.proto` file in the appropriate directory
2. Define your service and messages
3. Generate code for each consumer service
4. Update this README with the new service documentation

## Versioning

Protos use semantic versioning:
- `v1/` - Stable API
- `v1alpha/` - Alpha (experimental)
- `v1beta/` - Beta (stabilizing)

## Related Repositories

- **llmmllab-schemas** - YAML schema definitions (source of truth)
- **llmmllab-server** - REST API server
- **llmmllab-composer** - Agent orchestration
- **llmmllab-runner** - Model execution service
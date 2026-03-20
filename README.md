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
├── llmmllab-schemas/ # Git submodule - YAML schema definitions
├── proto/            # Protocol Buffer definitions
│   └── v1/           # Versioned proto files
│       └── *.proto   # Proto service and message definitions
├── gen/              # Generated proto messages (auto-generated from schemas)
│   └── python/       # Python protobuf code
└── Makefile
```

## Submodules

- **llmmllab-schemas** - Git submodule containing YAML schema definitions used to generate proto messages

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
# Generate proto messages from llmmllab-schemas
make messages
```

### Submodule Management

```bash
# Update llmmllab-schemas submodule to latest
git submodule update --init --recursive --remote
```

### Adding New Services

1. Create a new `.proto` file in the `proto/v1/` directory
2. Define your service and messages
3. Commit and push to main
4. Update submodules in consumer repos and run `make proto`

### Schema-Driven Message Generation

All proto messages are generated from YAML schemas in `llmmllab-schemas`. **Never edit proto message definitions manually** — update the YAML schema and regenerate.

#### Model Update Workflow

**To update a proto message, follow this exact sequence:**

1. **Update the YAML schema** in the llmmllab-schemas repo
   - Edit the appropriate YAML file in the schemas repository
   - Commit and push to main branch

2. **Regenerate proto messages** in this proto repo
   ```bash
   cd <proto-repo>
   git submodule update --init --recursive --remote  # Update llmmllab-schemas submodule
   make messages                                      # Generate proto messages
   git add gen/
   git commit -m "Update proto messages from schemas"
   git push origin main
   ```

3. **Update consumer applications** (server, composer, runner)
   ```bash
   # For each application
   cd <app-repo>
   git submodule update --init --recursive --remote  # Update llmmllab-proto submodule
   make proto                                         # Regenerate gRPC code
   git add gen/
   git commit -m "Update gRPC code from proto"
   git push origin main
   ```

#### Important Rules

- **Never edit generated proto messages directly**: `gen/**/*.proto`
- **Always update schemas first**: Message changes must originate in llmmllab-schemas
- **Push to main between steps**: Consumer repos depend on this being on main
- **Service definitions are manual**: `service` blocks in `.proto` files are maintained manually

## Versioning

Protos use semantic versioning:
- `v1/` - Stable API
- `v1alpha/` - Alpha (experimental)
- `v1beta/` - Beta (stabilizing)

## Consumer Repositories

- **llmmllab-server** - REST API server (uses this as submodule)
- **llmmllab-composer** - Agent orchestration (uses this as submodule)
- **llmmllab-runner** - Model execution service (uses this as submodule)

## Upstream Dependency

- **llmmllab-schemas** - YAML schema definitions (source of truth for messages)
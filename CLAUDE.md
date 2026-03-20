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

## Dependencies

This repository is a git submodule of:
- **llmmllab-server** - FastAPI inference service
- **llmmllab-composer** - Workflow orchestration service
- **llmmllab-runner** - Model execution service

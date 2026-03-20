#!/bin/bash
#
# Build script for llmmllab
# Generates code from schemas and proto files
#

set -e

SCHEMAS_DIR="./llmmllab-schemas/"
PROTO_DIR="./"

# Create log file
LOG_FILE="build.log"
echo "Starting build at $(date)" > "$LOG_FILE"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Generate proto files from schemas
generate_proto_from_schemas() {
    log_info "Generating Protocol Buffer files from schemas..."
    
    for proto_file in "$PROTO_DIR"/*.proto; do
        proto_filename=$(basename "$proto_file")
        schema_name="${proto_filename%.proto}"
        schema_file="$SCHEMAS_DIR/${schema_name}.yaml"
        
        if [ -f "$schema_file" ]; then
            log_info "Generating $schema_name.proto from $schema_name.yaml"
            schema2code "$schema_file" -l proto -o "$proto_file" \
            --package "messages" --go-package "github.com/LongStoryMedia/llmmllab-proto"
        else
            log_warn "Schema file not found: $schema_file"
        fi
    done
}

generate_proto_from_schemas
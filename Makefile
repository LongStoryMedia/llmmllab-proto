# Proto repository Makefile
# Manages Protocol Buffer compilation for llmmllab services

.PHONY: all generate clean check help

all: generate

PYTHON_PATH=python

messages:
	@echo "Generating gRPC code for all services..."
	./generate-messages.sh
	@echo "All gRPC code generated"

# =============================================================================
# Composer Service
# =============================================================================

generate-composer:
	@echo "Generating composer gRPC code..."
	@rm -rf ../gen/python
	@mkdir -p ../gen/python/runner/v1
	@mkdir -p ../gen/python/composer/v1
	@mkdir -p ../gen/python/common
	@mkdir -p ../gen/python/messages
	$(PYTHON_PATH) -m grpc_tools.protoc \
		-I. \
		-I../.venv/lib/python3.12/site-packages \
		-Illmmllab-schemas \
		--python_out=../gen/python \
		--grpc_python_out=../gen/python \
		--pyi_out=../gen/python \
		composer/v1/composer.proto \
		runner/v1/runner.proto \
		common/timestamp.proto \
		common/version.proto
	$(PYTHON_PATH) -m grpc_tools.protoc \
		-I. \
		-I../.venv/lib/python3.12/site-packages \
		-Illmmllab-schemas \
		--python_out=../gen/python/messages \
		--grpc_python_out=../gen/python/messages \
		--pyi_out=../gen/python/messages \
		messages/model_profile.proto \
		messages/model_parameters.proto \
		messages/model_profile_image_settings.proto \
		messages/model_profile_type.proto \
		messages/model_provider.proto \
		messages/model_task.proto \
		messages/circuit_breaker_config.proto \
		messages/gpu_config.proto \
		messages/parameter_optimization_config.proto \
		messages/crash_prevention.proto \
		messages/performance_parameter.proto \
		messages/parameter_tuning_strategy.proto \
		messages/message.proto \
		messages/message_content.proto \
		messages/message_role.proto \
		messages/document.proto \
		messages/intent_analysis.proto \
		messages/thought.proto \
		messages/tool_call.proto \
		messages/dynamic_tool.proto \
		messages/user_config.proto \
		messages/analysis_depth.proto \
		messages/api_key.proto \
		messages/api_key_request.proto \
		messages/api_key_response.proto \
		messages/auth_config.proto \
		messages/capability_profile_mapping.proto \
		messages/chat_req.proto \
		messages/chat_response.proto \
		messages/complexity_estimate.proto \
		messages/complexity_level.proto \
		messages/computational_requirement.proto \
		messages/config.proto \
		messages/conversation_ctx.proto \
		messages/conversation.proto \
		messages/database_config.proto \
		messages/dev_stats.proto \
		messages/document_source.proto \
		messages/embedding_req.proto \
		messages/embedding_response.proto \
		messages/event_stream_config.proto \
		messages/execution_state.proto \
		messages/generate_req.proto \
		messages/generate_response.proto \
		messages/generation_state.proto \
		messages/image_generation_config.proto \
		messages/image_generation_request.proto \
		messages/image_generation_response.proto \
		messages/image_metadata.proto \
		messages/inference_service.proto \
		messages/inference_service_config.proto \
		messages/intent.proto \
		messages/internal_config.proto \
		messages/lora_weight.proto \
		messages/memory.proto \
		messages/memory_config.proto \
		messages/memory_fragment.proto \
		messages/memory_source.proto \
		messages/message_type.proto \
		messages/model.proto \
		messages/model_configuration_data.proto \
		messages/model_details.proto \
		messages/model_profile_config.proto \
		messages/node_metadata.proto \
		messages/oom_recovery_attempt_data.proto \
		messages/optimal_parameters.proto \
		messages/pagination.proto \
		messages/prediction_features.proto \
		messages/recovery_strategy.proto \
		messages/redis_config.proto \
		messages/required_capability.proto \
		messages/research_question.proto \
		messages/research_question_result.proto \
		messages/research_subtask.proto \
		messages/research_task.proto \
		messages/research_task_status.proto \
		messages/resource_usage.proto \
		messages/response_format.proto \
		messages/response_section.proto \
		messages/search_result.proto \
		messages/search_result_content.proto \
		messages/search_topic_synthesis.proto \
		messages/server_config.proto \
		messages/socket_connection_type.proto \
		messages/socket_message.proto \
		messages/socket_session.proto \
		messages/socket_stage_type.proto \
		messages/socket_status_update.proto \
		messages/summarization_config.proto \
		messages/summary.proto \
		messages/summary_style.proto \
		messages/summary_type.proto \
		messages/system_gpu_stats.proto \
		messages/todo_item.proto \
		messages/tool.proto \
		messages/tool_analysis_request.proto \
		messages/user.proto \
		messages/web_socket_connection.proto \
		messages/workflow_config.proto \
		messages/workflow_type.proto \
		messages/technical_domain.proto \
		messages/message_content_type.proto \
		messages/lang_graph_node_state.proto \
		messages/lang_graph_state.proto \
		messages/learned_limits.proto \
		messages/pipeline_metrics.proto \
		messages/pipeline_priority.proto \
		messages/pipeline_state.proto \
		messages/pipeline_execution_context.proto \
		messages/pipeline_execution_state.proto \
		messages/ml_model_performance.proto \
		messages/preferences_config.proto \
		messages/rabbitmq_config.proto \
		messages/tool_config.proto \
		messages/tool_needs.proto
	@touch ../gen/python/messages/__init__.py
	@touch ../gen/python/composer/__init__.py
	@touch ../gen/python/composer/v1/__init__.py
	@touch ../gen/python/runner/__init__.py
	@touch ../gen/python/runner/v1/__init__.py
	@touch ../gen/python/common/__init__.py
	# Skip fix_imports.py - new structure generates correct imports
	$(MAKE) generate-pyproject
	@echo "Composer gRPC code generated"

# =============================================================================
# Runner Service
# =============================================================================

generate-runner:
	@echo "Generating runner gRPC code..."
	@rm -rf ../gen/python
	@mkdir -p ../gen/python/runner/v1
	@mkdir -p ../gen/python/composer/v1
	@mkdir -p ../gen/python/common
	@mkdir -p ../gen/python/messages
	$(PYTHON_PATH) -m grpc_tools.protoc \
		-I. \
		-I../.venv/lib/python3.12/site-packages \
		-Illmmllab-schemas \
		--python_out=../gen/python \
		--grpc_python_out=../gen/python \
		--pyi_out=../gen/python \
		runner/v1/runner.proto \
		composer/v1/composer.proto \
		common/timestamp.proto \
		common/version.proto
	$(PYTHON_PATH) -m grpc_tools.protoc \
		-I. \
		-I../.venv/lib/python3.12/site-packages \
		-Illmmllab-schemas \
		--python_out=../gen/python/messages \
		--grpc_python_out=../gen/python/messages \
		--pyi_out=../gen/python/messages \
		messages/model_profile.proto \
		messages/model_parameters.proto \
		messages/model_profile_image_settings.proto \
		messages/model_profile_type.proto \
		messages/model_provider.proto \
		messages/model_task.proto \
		messages/circuit_breaker_config.proto \
		messages/gpu_config.proto \
		messages/parameter_optimization_config.proto \
		messages/crash_prevention.proto \
		messages/performance_parameter.proto \
		messages/parameter_tuning_strategy.proto \
		messages/message.proto \
		messages/message_content.proto \
		messages/message_role.proto \
		messages/document.proto \
		messages/intent_analysis.proto \
		messages/thought.proto \
		messages/tool_call.proto \
		messages/dynamic_tool.proto \
		messages/user_config.proto \
		messages/analysis_depth.proto \
		messages/api_key.proto \
		messages/api_key_request.proto \
		messages/api_key_response.proto \
		messages/auth_config.proto \
		messages/capability_profile_mapping.proto \
		messages/chat_req.proto \
		messages/chat_response.proto \
		messages/complexity_estimate.proto \
		messages/complexity_level.proto \
		messages/computational_requirement.proto \
		messages/config.proto \
		messages/conversation_ctx.proto \
		messages/conversation.proto \
		messages/database_config.proto \
		messages/dev_stats.proto \
		messages/document_source.proto \
		messages/embedding_req.proto \
		messages/embedding_response.proto \
		messages/event_stream_config.proto \
		messages/execution_state.proto \
		messages/generate_req.proto \
		messages/generate_response.proto \
		messages/generation_state.proto \
		messages/image_generation_config.proto \
		messages/image_generation_request.proto \
		messages/image_generation_response.proto \
		messages/image_metadata.proto \
		messages/inference_service.proto \
		messages/inference_service_config.proto \
		messages/intent.proto \
		messages/internal_config.proto \
		messages/lora_weight.proto \
		messages/memory.proto \
		messages/memory_config.proto \
		messages/memory_fragment.proto \
		messages/memory_source.proto \
		messages/message_type.proto \
		messages/model.proto \
		messages/model_configuration_data.proto \
		messages/model_details.proto \
		messages/model_profile_config.proto \
		messages/node_metadata.proto \
		messages/oom_recovery_attempt_data.proto \
		messages/optimal_parameters.proto \
		messages/pagination.proto \
		messages/prediction_features.proto \
		messages/recovery_strategy.proto \
		messages/redis_config.proto \
		messages/required_capability.proto \
		messages/research_question.proto \
		messages/research_question_result.proto \
		messages/research_subtask.proto \
		messages/research_task.proto \
		messages/research_task_status.proto \
		messages/resource_usage.proto \
		messages/response_format.proto \
		messages/response_section.proto \
		messages/search_result.proto \
		messages/search_result_content.proto \
		messages/search_topic_synthesis.proto \
		messages/server_config.proto \
		messages/socket_connection_type.proto \
		messages/socket_message.proto \
		messages/socket_session.proto \
		messages/socket_stage_type.proto \
		messages/socket_status_update.proto \
		messages/summarization_config.proto \
		messages/summary.proto \
		messages/summary_style.proto \
		messages/summary_type.proto \
		messages/system_gpu_stats.proto \
		messages/todo_item.proto \
		messages/tool.proto \
		messages/tool_analysis_request.proto \
		messages/user.proto \
		messages/web_socket_connection.proto \
		messages/workflow_config.proto \
		messages/workflow_type.proto \
		messages/technical_domain.proto \
		messages/message_content_type.proto \
		messages/lang_graph_node_state.proto \
		messages/lang_graph_state.proto \
		messages/learned_limits.proto \
		messages/pipeline_metrics.proto \
		messages/pipeline_priority.proto \
		messages/pipeline_state.proto \
		messages/pipeline_execution_context.proto \
		messages/pipeline_execution_state.proto \
		messages/ml_model_performance.proto \
		messages/preferences_config.proto \
		messages/rabbitmq_config.proto \
		messages/tool_config.proto \
		messages/tool_needs.proto
	@touch ../gen/python/messages/__init__.py
	@touch ../gen/python/composer/__init__.py
	@touch ../gen/python/composer/v1/__init__.py
	@touch ../gen/python/runner/__init__.py
	@touch ../gen/python/runner/v1/__init__.py
	@touch ../gen/python/common/__init__.py
	$(PYTHON_PATH) scripts/fix_imports.py ../gen/python
	$(MAKE) generate-pyproject
	@echo "Runner gRPC code generated"

# Generate pyproject.toml for generated code
generate-pyproject:
	@echo "Generating pyproject.toml..."
	@mkdir -p ../gen/python
	@echo '[build-system]' > ../gen/python/pyproject.toml
	@echo 'requires = ["setuptools>=61.0"]' >> ../gen/python/pyproject.toml
	@echo 'build-backend = "setuptools.build_meta"' >> ../gen/python/pyproject.toml
	@echo '' >> ../gen/python/pyproject.toml
	@echo '[project]' >> ../gen/python/pyproject.toml
	@echo 'name = "runner-grpc"' >> ../gen/python/pyproject.toml
	@echo 'version = "0.1.0"' >> ../gen/python/pyproject.toml
	@echo 'description = "gRPC code for the llmmllab runner service"' >> ../gen/python/pyproject.toml
	@echo 'readme = "README.md"' >> ../gen/python/pyproject.toml
	@echo 'license = {text = "MIT"}' >> ../gen/python/pyproject.toml
	@echo 'authors = [{name = "llmmllab Team"}]' >> ../gen/python/pyproject.toml
	@echo 'requires-python = ">=3.10"' >> ../gen/python/pyproject.toml
	@echo 'dependencies = [' >> ../gen/python/pyproject.toml
	@echo '    "grpcio>=1.78.0",' >> ../gen/python/pyproject.toml
	@echo '    "grpcio-tools>=1.78.0",' >> ../gen/python/pyproject.toml
	@echo '    "protobuf>=4.25.0",' >> ../gen/python/pyproject.toml
	@echo ']' >> ../gen/python/pyproject.toml
	@echo '' >> ../gen/python/pyproject.toml
	@echo '[tool.setuptools]' >> ../gen/python/pyproject.toml
	@echo 'packages = [' >> ../gen/python/pyproject.toml
	@echo '    "runner",' >> ../gen/python/pyproject.toml
	@echo '    "runner.v1",' >> ../gen/python/pyproject.toml
	@echo '    "server",' >> ../gen/python/pyproject.toml
	@echo '    "server.v1",' >> ../gen/python/pyproject.toml
	@echo '    "composer",' >> ../gen/python/pyproject.toml
	@echo '    "composer.v1",' >> ../gen/python/pyproject.toml
	@echo '    "common",' >> ../gen/python/pyproject.toml
	@echo '    "messages",' >> ../gen/python/pyproject.toml
	@echo ']' >> ../gen/python/pyproject.toml
	@echo '' >> ../gen/python/pyproject.toml
	@echo '[tool.setuptools.package-data]' >> ../gen/python/pyproject.toml
	@echo '"runner" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"runner.v1" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"server" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"server.v1" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"composer" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"composer.v1" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"common" = ["py.typed"]' >> ../gen/python/pyproject.toml
	@echo '"messages" = ["py.typed"]' >> ../gen/python/pyproject.toml
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
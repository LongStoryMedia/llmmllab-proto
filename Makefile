# Proto repository Makefile
# Manages Protocol Buffer compilation for llmmllab services

.PHONY: all generate clean check help

all: generate

PYTHON_PATH=/home/lsm/Nextcloud/llmmllab/server/.venv/bin/python

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
	@mkdir -p ../gen/python/models
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
		--python_out=../gen/python/models \
		--grpc_python_out=../gen/python/models \
		--pyi_out=../gen/python/models \
		model_profile.proto \
		model_parameters.proto \
		model_profile_image_settings.proto \
		model_profile_type.proto \
		model_provider.proto \
		model_task.proto \
		circuit_breaker_config.proto \
		gpu_config.proto \
		parameter_optimization_config.proto \
		crash_prevention.proto \
		performance_parameter.proto \
		parameter_tuning_strategy.proto \
		message.proto \
		message_content.proto \
		message_role.proto \
		document.proto \
		intent_analysis.proto \
		thought.proto \
		tool_call.proto \
		dynamic_tool.proto \
		user_config.proto \
		analysis_depth.proto \
		api_key.proto \
		api_key_request.proto \
		api_key_response.proto \
		auth_config.proto \
		capability_profile_mapping.proto \
		chat_req.proto \
		chat_response.proto \
		complexity_estimate.proto \
		complexity_level.proto \
		computational_requirement.proto \
		config.proto \
		conversation_ctx.proto \
		conversation.proto \
		database_config.proto \
		dev_stats.proto \
		document_source.proto \
		embedding_req.proto \
		embedding_response.proto \
		event_stream_config.proto \
		execution_state.proto \
		generate_req.proto \
		generate_response.proto \
		generation_state.proto \
		image_generation_config.proto \
		image_generation_request.proto \
		image_generation_response.proto \
		image_metadata.proto \
		inference_service.proto \
		inference_service_config.proto \
		intent.proto \
		internal_config.proto \
		lora_weight.proto \
		memory.proto \
		memory_config.proto \
		memory_fragment.proto \
		memory_source.proto \
		message_type.proto \
		model.proto \
		model_configuration_data.proto \
		model_details.proto \
		model_profile_config.proto \
		node_metadata.proto \
		oom_recovery_attempt_data.proto \
		optimal_parameters.proto \
		pagination.proto \
		prediction_features.proto \
		recovery_strategy.proto \
		redis_config.proto \
		required_capability.proto \
		research_question.proto \
		research_question_result.proto \
		research_subtask.proto \
		research_task.proto \
		research_task_status.proto \
		resource_usage.proto \
		response_format.proto \
		response_section.proto \
		search_result.proto \
		search_result_content.proto \
		search_topic_synthesis.proto \
		server_config.proto \
		socket_connection_type.proto \
		socket_message.proto \
		socket_session.proto \
		socket_stage_type.proto \
		socket_status_update.proto \
		summarization_config.proto \
		summary.proto \
		summary_style.proto \
		summary_type.proto \
		system_gpu_stats.proto \
		todo_item.proto \
		tool.proto \
		tool_analysis_request.proto \
		user.proto \
		web_socket_connection.proto \
		workflow_config.proto \
		workflow_type.proto \
		technical_domain.proto \
		message_content_type.proto \
		lang_graph_node_state.proto \
		lang_graph_state.proto \
		learned_limits.proto \
		pipeline_metrics.proto \
		pipeline_priority.proto \
		pipeline_state.proto \
		pipeline_execution_context.proto \
		pipeline_execution_state.proto \
		ml_model_performance.proto \
		preferences_config.proto \
		rabbitmq_config.proto \
		tool_config.proto \
		tool_needs.proto
	@touch ../gen/python/models/__init__.py
	@touch ../gen/python/composer/__init__.py
	@touch ../gen/python/composer/v1/__init__.py
	@touch ../gen/python/runner/__init__.py
	@touch ../gen/python/runner/v1/__init__.py
	@touch ../gen/python/common/__init__.py
	$(PYTHON_PATH) scripts/fix_imports.py ../gen/python
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
	@mkdir -p ../gen/python/models
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
		--python_out=../gen/python/models \
		--grpc_python_out=../gen/python/models \
		--pyi_out=../gen/python/models \
		model_profile.proto \
		model_parameters.proto \
		model_profile_image_settings.proto \
		model_profile_type.proto \
		model_provider.proto \
		model_task.proto \
		circuit_breaker_config.proto \
		gpu_config.proto \
		parameter_optimization_config.proto \
		crash_prevention.proto \
		performance_parameter.proto \
		parameter_tuning_strategy.proto \
		message.proto \
		message_content.proto \
		message_role.proto \
		document.proto \
		intent_analysis.proto \
		thought.proto \
		tool_call.proto \
		dynamic_tool.proto \
		user_config.proto \
		analysis_depth.proto \
		api_key.proto \
		api_key_request.proto \
		api_key_response.proto \
		auth_config.proto \
		capability_profile_mapping.proto \
		chat_req.proto \
		chat_response.proto \
		complexity_estimate.proto \
		complexity_level.proto \
		computational_requirement.proto \
		config.proto \
		conversation_ctx.proto \
		conversation.proto \
		database_config.proto \
		dev_stats.proto \
		document_source.proto \
		embedding_req.proto \
		embedding_response.proto \
		event_stream_config.proto \
		execution_state.proto \
		generate_req.proto \
		generate_response.proto \
		generation_state.proto \
		image_generation_config.proto \
		image_generation_request.proto \
		image_generation_response.proto \
		image_metadata.proto \
		inference_service.proto \
		inference_service_config.proto \
		intent.proto \
		internal_config.proto \
		lora_weight.proto \
		memory.proto \
		memory_config.proto \
		memory_fragment.proto \
		memory_source.proto \
		message_type.proto \
		model.proto \
		model_configuration_data.proto \
		model_details.proto \
		model_profile_config.proto \
		node_metadata.proto \
		oom_recovery_attempt_data.proto \
		optimal_parameters.proto \
		pagination.proto \
		prediction_features.proto \
		recovery_strategy.proto \
		redis_config.proto \
		required_capability.proto \
		research_question.proto \
		research_question_result.proto \
		research_subtask.proto \
		research_task.proto \
		research_task_status.proto \
		resource_usage.proto \
		response_format.proto \
		response_section.proto \
		search_result.proto \
		search_result_content.proto \
		search_topic_synthesis.proto \
		server_config.proto \
		socket_connection_type.proto \
		socket_message.proto \
		socket_session.proto \
		socket_stage_type.proto \
		socket_status_update.proto \
		summarization_config.proto \
		summary.proto \
		summary_style.proto \
		summary_type.proto \
		system_gpu_stats.proto \
		todo_item.proto \
		tool.proto \
		tool_analysis_request.proto \
		user.proto \
		web_socket_connection.proto \
		workflow_config.proto \
		workflow_type.proto \
		technical_domain.proto \
		message_content_type.proto \
		lang_graph_node_state.proto \
		lang_graph_state.proto \
		learned_limits.proto \
		pipeline_metrics.proto \
		pipeline_priority.proto \
		pipeline_state.proto \
		pipeline_execution_context.proto \
		pipeline_execution_state.proto \
		ml_model_performance.proto \
		preferences_config.proto \
		rabbitmq_config.proto \
		tool_config.proto \
		tool_needs.proto
	@touch ../gen/python/models/__init__.py
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
	@echo '    "models",' >> ../gen/python/pyproject.toml
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
	@echo '"models" = ["py.typed"]' >> ../gen/python/pyproject.toml
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
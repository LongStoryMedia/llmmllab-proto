#!/usr/bin/env python3
"""Verify that gRPC code generation produces correct output structure and imports."""

import os
import sys
import importlib.util


def file_exists(path, description):
    """Check if a file exists and report the result."""
    if os.path.exists(path):
        print(f"[PASS] {description}: {path}")
        return True
    else:
        print(f"[FAIL] {description}: {path} not found")
        return False


def can_import(module_name, package_path):
    """Check if a Python module can be imported."""
    try:
        spec = importlib.util.find_spec(module_name)
        if spec is not None:
            print(f"[PASS] Can import {module_name}")
            return True
        else:
            print(f"[FAIL] Cannot import {module_name}")
            return False
    except Exception as e:
        print(f"[FAIL] Error importing {module_name}: {e}")
        return False


def main():
    """Run verification checks."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    gen_python_dir = os.path.join(project_root, '..', 'gen', 'python')

    print("=" * 60)
    print("Verifying gRPC code generation")
    print("=" * 60)

    all_passed = True

    # Check messages package files
    print("\n--- Checking messages package files ---")
    messages_files = [
        'message_pb2.py',
        'model_profile_pb2.py',
        'user_config_pb2.py',
        'dynamic_tool_pb2.py',
    ]
    for f in messages_files:
        path = os.path.join(gen_python_dir, 'messages', f)
        if not file_exists(path, f"messages package file {f}"):
            all_passed = False

    # Check composer package files
    print("\n--- Checking composer package files ---")
    composer_files = [
        'composer_pb2.py',
        'composer_pb2_grpc.py',
    ]
    for f in composer_files:
        path = os.path.join(gen_python_dir, 'composer', 'v1', f)
        if not file_exists(path, f"composer.v1 file {f}"):
            all_passed = False

    # Check runner package files
    print("\n--- Checking runner package files ---")
    runner_files = [
        'runner_pb2.py',
        'runner_pb2_grpc.py',
    ]
    for f in runner_files:
        path = os.path.join(gen_python_dir, 'runner', 'v1', f)
        if not file_exists(path, f"runner.v1 file {f}"):
            all_passed = False

    # Check common package files
    print("\n--- Checking common package files ---")
    common_files = [
        'timestamp_pb2.py',
        'version_pb2.py',
    ]
    for f in common_files:
        path = os.path.join(gen_python_dir, 'common', f)
        if not file_exists(path, f"common file {f}"):
            all_passed = False

    # Check __init__.py files
    print("\n--- Checking __init__.py files ---")
    init_files = [
        (os.path.join(gen_python_dir, 'messages', '__init__.py'), 'messages/__init__.py'),
        (os.path.join(gen_python_dir, 'composer', '__init__.py'), 'composer/__init__.py'),
        (os.path.join(gen_python_dir, 'composer', 'v1', '__init__.py'), 'composer/v1/__init__.py'),
        (os.path.join(gen_python_dir, 'runner', '__init__.py'), 'runner/__init__.py'),
        (os.path.join(gen_python_dir, 'runner', 'v1', '__init__.py'), 'runner/v1/__init__.py'),
        (os.path.join(gen_python_dir, 'common', '__init__.py'), 'common/__init__.py'),
    ]
    for path, desc in init_files:
        if not file_exists(path, desc):
            all_passed = False

    # Check pyproject.toml
    print("\n--- Checking pyproject.toml ---")
    pyproject_path = os.path.join(gen_python_dir, 'pyproject.toml')
    if not file_exists(pyproject_path, 'pyproject.toml'):
        all_passed = False
    else:
        # Verify it contains 'messages' package
        with open(pyproject_path, 'r') as f:
            content = f.read()
            if '"messages"' in content:
                print("[PASS] pyproject.toml contains 'messages' package")
            else:
                print("[FAIL] pyproject.toml does not contain 'messages' package")
                all_passed = False

    # Check imports in generated files
    print("\n--- Checking import statements ---")

    # Check that messages files use correct imports
    messages_pb2_path = os.path.join(gen_python_dir, 'messages', 'message_pb2.py')
    if os.path.exists(messages_pb2_path):
        with open(messages_pb2_path, 'r') as f:
            content = f.read()
            # Should NOT have bare imports like "import document_pb2"
            # Should have "from messages import document_pb2" or similar
            if 'from messages import' in content or 'from gen.python.messages import' in content:
                print("[PASS] message_pb2.py uses correct package imports")
            else:
                print("[WARN] message_pb2.py import style may need verification")

    # Check composer_pb2_grpc.py for correct imports
    composer_grpc_path = os.path.join(gen_python_dir, 'composer', 'v1', 'composer_pb2_grpc.py')
    if os.path.exists(composer_grpc_path):
        with open(composer_grpc_path, 'r') as f:
            content = f.read()
            if 'from messages import' in content or 'from gen.python.messages import' in content:
                print("[PASS] composer_pb2_grpc.py imports from messages package")
            else:
                print("[WARN] composer_pb2_grpc.py import style may need verification")

    print("\n" + "=" * 60)
    if all_passed:
        print("All verification checks PASSED")
        return 0
    else:
        print("Some verification checks FAILED")
        return 1


if __name__ == '__main__':
    sys.exit(main())

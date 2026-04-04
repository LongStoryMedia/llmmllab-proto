#!/usr/bin/env python3
"""Fix import statements in generated gRPC code for models package.

The proto generator creates imports like:
    import model_profile_pb2 as model__profile__pb2
    import circuit_breaker_config_pb2 as circuit__breaker__config__pb2

But model files are in the models/ subdirectory, so we need:
    from models import model_profile_pb2 as model__profile__pb2
    from models import circuit_breaker_config_pb2 as circuit__breaker__config__pb2

This script handles both the old `import` format and the `from models import` format.
"""

import os
import re
import sys
import glob


def get_model_proto_names(proto_dir):
    """Get all model proto names dynamically from the proto directory.

    This function gets the list of proto files from the proto directory and
    extracts their names (without the .proto extension).
    """
    # Get all .proto files in the proto directory
    pattern = os.path.join(proto_dir, '*.proto')
    files = glob.glob(pattern)

    names = []
    for f in files:
        basename = os.path.basename(f)
        # Skip the proto files in subdirectories (composer, runner, server)
        if '/' in basename or '\\' in basename:
            continue
        # Remove the .proto extension
        name = os.path.splitext(basename)[0]
        names.append(name)

    return names


def fix_imports_in_file(filepath, model_proto_names):
    """Fix import statements in a generated Python file."""
    with open(filepath, 'r') as f:
        content = f.read()

    # Build pattern for model imports - handles both `import` and `from models import` formats
    # Pattern matches:
    #   import model_profile_pb2 as model__profile__pb2
    #   from models import model_profile_pb2 as model__profile__pb2
    #   import model_profile_pb2
    #   from models import model_profile_pb2
    # Use gen_python.models to avoid conflict with local models/ directory
    name_pattern = '|'.join(re.escape(n) for n in model_proto_names)
    model_pattern = re.compile(
        r'^(?:import |from models import )((?:' + name_pattern + r')_pb2)(?: as (\w+))?$',
        re.MULTILINE
    )

    def replace_model_import(match):
        module_name = match.group(1)
        alias = match.group(2)
        if alias:
            return f'from gen.python.models import {module_name} as {alias}'
        else:
            return f'from gen.python.models import {module_name}'

    new_content = model_pattern.sub(replace_model_import, content)

    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return True
    return False


def fix_grpc_imports_in_file(filepath):
    """Fix import statements in generated gRPC files (runner_pb2_grpc.py, composer_pb2_grpc.py).

    These files import the _pb2 files with a pattern like:
        from runner.v1 import runner_pb2 as runner__pb2
    We keep this pattern since runner_pb2.py is in the same runner.v1 package.

    The proto generator already correctly produces:
        from common import version_pb2 as common_dot_version__pb2
    So we don't need to modify this.
    """
    with open(filepath, 'r') as f:
        content = f.read()

    # The proto generator already produces correct imports for common files
    # We only need to handle imports from runner.v1 or composer.v1
    # For composer_pb2, we need to import from composer.v1 not runner.v1
    # For runner_pb2, we keep runner.v1
    runner_pattern = re.compile(
        r'^from (runner\.v1|composer\.v1) import (runner_pb2|composer_pb2)(?: as (\w+))?$',
        re.MULTILINE
    )

    def replace_runner_import(match):
        package = match.group(1)
        module_name = match.group(2)
        alias = match.group(3)
        # composer_pb2 should be imported from composer.v1, not runner.v1
        if module_name == 'composer_pb2' and package == 'runner.v1':
            package = 'composer.v1'
        if alias:
            return f'from {package} import {module_name} as {alias}'
        else:
            return f'from {package} import {module_name}'

    new_content = runner_pattern.sub(replace_runner_import, content)

    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return True
    return False


def fix_common_imports_in_file(filepath):
    """Fix import statements for common package files (timestamp, version).

    The proto generator incorrectly creates:
        from common import common_dot_version_pb2 as common_dot_version__pb2
    But the correct format is:
        from common import version_pb2 as common_dot_version__pb2
    The module name should be `version_pb2` not `common_dot_version_pb2`.
    """
    with open(filepath, 'r') as f:
        content = f.read()

    # Pattern matches `from common import common_dot_timestamp_pb2 as ...`
    # or `from common import common_dot_version_pb2 as ...`
    # Change to `from common import timestamp_pb2 as ...`
    common_pattern = re.compile(
        r'^from common import (common_dot_(timestamp|version)_pb2)(?: as (\w+))?$',
        re.MULTILINE
    )

    def replace_common_import(match):
        module_name = match.group(2) + '_pb2'
        alias = match.group(3)
        if alias:
            return f'from common import {module_name} as {alias}'
        else:
            return f'from common import {module_name}'

    new_content = common_pattern.sub(replace_common_import, content)

    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return True
    return False


def fix_file(filepath, model_proto_names):
    """Fix a single file and return whether it was modified."""
    if filepath.endswith('_pb2_grpc.py'):
        return fix_grpc_imports_in_file(filepath) or fix_common_imports_in_file(filepath)
    elif filepath.endswith('_pb2.py'):
        return fix_imports_in_file(filepath, model_proto_names) or fix_common_imports_in_file(filepath)
    return False


def main(gen_python_dir):
    """Fix imports in all generated files under gen_python_dir."""
    modified_count = 0

    # Get model proto names dynamically from the proto directory
    # gen_python_dir is like "gen/python" under the app directory
    # The proto directory is at "llmmllab-proto" relative to the app root
    app_root = os.path.dirname(os.path.dirname(gen_python_dir))
    # Handle both cases: when gen_python_dir is relative or absolute
    if app_root == '':
        app_root = '.'
    proto_dir = os.path.join(app_root, 'llmmllab-proto')
    model_proto_names = get_model_proto_names(proto_dir)

    for root, _, files in os.walk(gen_python_dir):
        for filename in files:
            if filename.endswith('_pb2.py') or filename.endswith('_pb2_grpc.py'):
                filepath = os.path.join(root, filename)
                if fix_file(filepath, model_proto_names):
                    print(f"Fixed: {filepath}")
                    modified_count += 1

    print(f"\nTotal files modified: {modified_count}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: fix_imports.py <gen_python_dir>")
        print("Example: fix_imports.py /home/lsm/Nextcloud/llmmllab/gen/python")
        sys.exit(1)

    gen_python_dir = sys.argv[1]
    sys.exit(main(gen_python_dir))
#!/usr/bin/env python3
"""
Script to help fix parameter ordering issues in Flutter files.
This script identifies patterns and helps fix the 'always_put_required_named_parameters_first' lint rule.
"""

import os
import re
import sys

def fix_constructor_parameters(file_path):
    """Fix parameter ordering in constructors."""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Pattern to match constructor parameters
    # This is a simplified version - manual review is still needed
    constructor_pattern = r'const\s+(\w+)\s*\(\s*\{([^}]+)\}\s*\)'
    
    def fix_parameters(match):
        class_name = match.group(1)
        params = match.group(2)
        
        # Split parameters by comma and clean up
        param_lines = [p.strip() for p in params.split(',') if p.strip()]
        
        required_params = []
        optional_params = []
        key_param = None
        
        for param in param_lines:
            if param.startswith('required '):
                required_params.append(param)
            elif 'Key?' in param or 'super.key' in param:
                key_param = param
            elif param.strip():
                optional_params.append(param)
        
        # Reorder: required first, then optional, then key
        ordered_params = required_params + optional_params
        if key_param:
            ordered_params.append(key_param)
        
        # Reconstruct the constructor
        formatted_params = ',\n    '.join(ordered_params)
        return f'const {class_name}({{\n    {formatted_params},\n  }})'
    
    # Apply the fix
    new_content = re.sub(constructor_pattern, fix_parameters, content, flags=re.DOTALL)
    
    # Only write if content changed
    if new_content != content:
        with open(file_path, 'w') as f:
            f.write(new_content)
        print(f"Fixed: {file_path}")
        return True
    return False

def main():
    """Main function to process files."""
    if len(sys.argv) < 2:
        print("Usage: python fix_parameters.py <file_path>")
        sys.exit(1)
    
    file_path = sys.argv[1]
    if os.path.exists(file_path):
        fix_constructor_parameters(file_path)
    else:
        print(f"File not found: {file_path}")

if __name__ == "__main__":
    main() 
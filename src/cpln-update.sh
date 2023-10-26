#!/bin/bash

# Exit script on error
set -e

# File Paths
script_dir=$(dirname "$(realpath "$0")")
template_file_path="$script_dir/../templates/cpln-template.txt"
cpln_formula_file_path="$script_dir/../Formula/cpln-test.rb"

# List of environment variables to check
env_vars=("ARTIFACTS" "TAG" "SHA_MACOS" "SHA_LINUX" "VERSION")

# Check each environment variable and add it to the replacements associative array
for env_var in "${env_vars[@]}"; do
    if [[ -z "${!env_var}" ]]; then
        echo "$env_var environment variable is not set"
        exit 1
    fi
done

# Define the keys and values arrays
keys=()
values=()

# Populate the keys and values arrays based on env_vars
for env_var in "${env_vars[@]}"; do
    keys+=("{$env_var}")
    values+=("${!env_var}")
done

# Read the content of the template file
template_file_content=$(<"$template_file_path")

# Iterate over the arrays and replace occurrences in the file content
for index in "${!keys[@]}"; do
    key="${keys[index]}"
    value="${values[index]}"

    # Using sed here as it can handle complex replacement patterns more reliably
    template_file_content=$(echo "$template_file_content" | sed "s#$key#$value#g")
done

# Write the modified content to the Formula cpln file specified by cpln_formula_file_path
echo "$template_file_content" > "$cpln_formula_file_path"

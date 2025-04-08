#!/bin/bash

# Exit on error
set -e

# Check if tag name is provided
if [ -z "$1" ]; then
    echo "Error: Tag name is required"
    echo "Usage: $0 <tag_name>"
    exit 1
fi

# Function to extract version from tag
extract_version() {
    local tag=$1
    # Remove 'v' prefix and any suffix after '-'
    echo "$tag" | sed -E 's/^v//' | sed -E 's/-.*$//'
}

# Function to check if tag is alpha
is_alpha() {
    local tag=$1
    [[ "$tag" == *"-alpha" ]]
}

TAG_NAME=$1

# Extract version
VERSION=$(extract_version "$TAG_NAME")

# Initialize tags array
TAGS=()

# Add appropriate tags based on tag type
if is_alpha "$TAG_NAME"; then
    # For alpha releases
    TAGS+=("$VERSION-alpha")
    TAGS+=("alpha")
else
    # For regular releases
    TAGS+=("$VERSION")
    TAGS+=("latest")
fi

# Convert array to comma-separated string
TAGS_STRING=$(IFS=,; echo "${TAGS[*]}")

# Export the tags as environment variable
echo "DOCKER_TAGS=$TAGS_STRING" >> $GITHUB_ENV

# Print for debugging
echo "Extracted tags: $TAGS_STRING" 
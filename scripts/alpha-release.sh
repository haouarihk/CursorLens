#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.0"
    exit 1
fi

VERSION=$1

# Validate version format (semantic versioning)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must follow semantic versioning (e.g., 1.0.0)"
    exit 1
fi

# Create and push the tag
git tag -a "v$VERSION-alpha" -m "Alpha release v$VERSION"
git push origin "v$VERSION-alpha"

echo "Created and pushed alpha release tag v$VERSION-alpha" 
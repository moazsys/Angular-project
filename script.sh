#!/bin/bash

NEXUS_URL="http://4.216.187.218:8081"
REPOSITORY="angular"
VERSION="1.0.0"
DIRECTORY_PATH="nexus"  # Adjust to your target directory
USERNAME="admin"
PASSWORD="Moaz@2003"

# Create a tarball of the directory
TARBALL_NAME="${DIRECTORY_PATH}.tar.gz"
tar -czf "$TARBALL_NAME" "$DIRECTORY_PATH"

# Check if the tarball was created successfully and is not empty
if [ ! -f "$TARBALL_NAME" ] || [ ! -s "$TARBALL_NAME" ]; then
    echo "Failed to create a valid tarball!"
    exit 1
fi

# Publish to Nexus
curl -v -u "$USERNAME:$PASSWORD" --upload-file "$TARBALL_NAME" \
    "$NEXUS_URL/repository/$REPOSITORY/$VERSION/$TARBALL_NAME"

if [ $? -eq 0 ]; then
    echo "Directory published successfully to Nexus!"
else
    echo "Failed to publish directory to Nexus."
fi

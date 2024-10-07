#!/bin/bash

# Variables
NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="$(pwd)"  # Assuming the script is run from the app directory

# Create .npmrc file for authentication
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

# Ensure package.json exists
if [ ! -f "${APP_DIR}/package.json" ]; then
    echo "package.json not found. Make sure you're in the correct directory."
    exit 1
fi

# Publish to Nexus
npm publish --registry $NEXUS_URL

# Check for success
if [[ $? -eq 0 ]]; then
    echo "Application published successfully to Nexus!"
else
    echo "Failed to publish application to Nexus."
    exit 1
fi

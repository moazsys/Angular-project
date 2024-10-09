#!/bin/bash

NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus11"
ZIP_FILE="angular.zip" 
APP_NAME="Angular"       
VERSION="1.2.0"  # Update this as needed

cd "${APP_DIR}" || { echo "Application directory not found"; exit 1; }

# Create a ZIP file
zip -r "${ZIP_FILE}" ./* || { echo "Failed to create ZIP file"; exit 1; }

# Configure npm to use Nexus
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

# Explicitly log in to Nexus
npm login --registry=$NEXUS_URL --scope=@your-scope --always-auth
# You can also try without --scope if you don't need it
# The credentials will be pulled from the .npmrc file

# Create package.json
cat <<EOF > ${APP_DIR}/package.json
{
  "name": "${APP_NAME}",
  "version": "${VERSION}",
  "main": "${ZIP_FILE}",
  "files": [
    "${ZIP_FILE}"
  ],
  "scripts": {
    "start": "unzip ${ZIP_FILE}"
  },
  "engines": {
    "node": ">=14.0.0"
  }
}
EOF

# Publish to Nexus
npm publish --registry $NEXUS_URL

# Check for success
if [[ $? -eq 0 ]]; then
    echo "Application published successfully to Nexus!"
else
    echo "Failed to publish application to Nexus."
    exit 1
fi


# Fetch existing versions from Nexus
version_check_url="${NEXUS_URL}service/rest/v1/search?repository=angular&name=${APP_NAME}"
echo "Fetching existing versions from: ${version_check_url}"
response=$(curl -s -u ${USERNAME}:${PASSWORD} "${version_check_url}")

# Check if the response is valid JSON
if echo "${response}" | jq . >/dev/null 2>&1; then
    existing_versions=$(echo "${response}" | jq -r '.items[].version' | sort -r)
    echo "Existing versions: ${existing_versions}"
else
    echo "Failed to fetch existing versions: Invalid response from Nexus"
    echo "Response: ${response}"
    exit 1
fi
i

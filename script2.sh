NEXUS_URL="http://4.216.187.218:8081/service/rest/v1/components?repository=angular"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus11"
ZIP_FILE="angular.zip" 
APP_NAME="Angular"       
VERSION="1.1.0"  # Update this to the actual version

cd "${APP_DIR}" || { echo "Application directory not found"; exit 1; }

# Create a ZIP file
zip -r "${ZIP_FILE}" ./* || { echo "Failed to create ZIP file"; exit 1; }

# Configure npm to use Nexus
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

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

# Fetch existing versions
echo "Fetching existing versions for ${APP_NAME}..."
response=$(curl -s -u "${USERNAME}:${PASSWORD}" "${NEXUS_URL}")

# Print the raw response for debugging
echo "Response from Nexus:"
echo "${response}"

# Check if the response is valid JSON before parsing
if echo "${response}" | jq . >/dev/null 2>&1; then
    echo "${response}" | jq -r '.items[].version' | sort -V
else
    echo "Failed to parse response as JSON."
    exit 1
fi

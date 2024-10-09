#!/bin/bash

NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus11"
ZIP_FILE="angular.zip" 
APP_NAME="Angular"       

cd "${APP_DIR}" || { echo "Application directory not found"; exit 1; }

zip -r "${ZIP_FILE}" ./* || { echo "Failed to create ZIP file"; exit 1; }

echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

npm login --registry=$NEXUS_URL --scope=@your-scope --always-auth



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





NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus11"
ZIP_FILE="angular.zip"  # Zip file name
APP_NAME="Angular"       # Change this to your desired app name
VERSION="1.0.0"          # Version of your package

# Change to the application directory
cd "${APP_DIR}" || { echo "Application directory not found"; exit 1; }

# Create a zip of the application directory
zip -r "${ZIP_FILE}" ./*

# Create .npmrc file for authentication
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

# Create a package.json file
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
fi

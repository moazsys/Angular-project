
NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus"
APP_NAME="my-python-app"  # Change this to your desired app name
VERSION="1.1.6"           # Version of your package

# Create .npmrc file for authentication
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

# Create a package.json file
cat <<EOF > ${APP_DIR}/package.json
{
  "name": "${APP_NAME}",
  "version": "${VERSION}",
  "main": "app.py",
  "files": [
    "app.py"
  ],
  "scripts": {
    "start": "python app.py"
  },
  "engines": {
    "node": ">=14.0.0"
  }
}
EOF

# Change to the application directory
cd "${APP_DIR}" || { echo "Application directory not found"; exit 1; }

# Publish to Nexus
npm publish --registry $NEXUS_URL

# Check for success
if [[ $? -eq 0 ]]; then
    echo "Application published successfully to Nexus!"
else
    echo "Failed to publish application to Nexus."
fi

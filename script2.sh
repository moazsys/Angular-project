#!/bin/bash

# Variables
GIT_REPO="https://github.com/your_username/nexus11.git"  # Replace with your GitHub repo
NEXUS_URL="http://4.216.187.218:8081/repository/angular/"
USERNAME="admin"
PASSWORD="Moaz@2003"
APP_DIR="/var/jenkins_home/workspace/nexus11"
APP_NAME="nexus11-app"  # Change this to your desired app name
VERSION="1.0.0"         # Version of your package

# Clone the GitHub repository
git clone $GIT_REPO $APP_DIR

# Check if clone was successful
if [[ $? -ne 0 ]]; then
    echo "Failed to clone repository."
    exit 1
fi

# Create a zip file of the cloned directory
cd /var/jenkins_home/workspace || { echo "Workspace directory not found"; exit 1; }
zip -r nexus11.zip nexus11

# Create .npmrc file for authentication
echo "//4.216.187.218:8081/repository/angular/:username=${USERNAME}" > ${APP_DIR}/.npmrc
echo "//4.216.187.218:8081/repository/angular/:_password=$(echo -n ${PASSWORD} | base64)" >> ${APP_DIR}/.npmrc

# Create a package.json file
cat <<EOF > ${APP_DIR}/package.json
{
  "name": "${APP_NAME}",
  "version": "${VERSION}",
  "main": "nexus11.zip",
  "files": [
    "nexus11.zip"
  ],
  "scripts": {
    "start": "unzip nexus11.zip && cd nexus11 && npm start"
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

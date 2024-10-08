
# Variables
NEXUS_URL="http://4.216.187.218:8081/repository/angular/"  # Corrected URL format
REPOSITORY="angular"
VERSION="1.0.0"
FILE_PATH="/var/jenkins_home/workspace/publish/publish.zip"           # Added leading '/'
USERNAME="admin"
PASSWORD="Moaz@2003"

# Publish to Nexus
curl -v -u "$USERNAME:$PASSWORD" --upload-file "$FILE_PATH" \
    "$NEXUS_URL/repository/$REPOSITORY/$VERSION/publish.zip"  # Include version in the path

if [ $? -eq 0 ]; then
    echo "File published successfully to Nexus!"
else
    echo "Failed to publish file to Nexus."
fi

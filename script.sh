NEXUS_URL="http://4.216.187.218:8081"
REPOSITORY="angular"
VERSION="1.0.0"
FILE_PATH="app.tar" 
USERNAME="admin"
PASSWORD="Moaz@2003"

curl -v -u "$USERNAME:$PASSWORD" --upload-file "$FILE_PATH" \
    "$NEXUS_URL/repository/$REPOSITORY/$VERSION/$FILE_PATH"

if [ $? -eq 0 ]; then
    echo "File published successfully to Nexus!"
else
    echo "Failed to publish file to Nexus."
fi

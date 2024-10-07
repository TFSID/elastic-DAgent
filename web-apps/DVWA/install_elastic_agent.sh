#!/bin/bash

# Define variables
VERSION="8.15.1"  # Change this to the desired version
DOWNLOAD_URL="https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-$VERSION-linux-x86_64.tar.gz"
INSTALL_DIR="/opt/Elastic/Agent"
CONFIG_FILE="$INSTALL_DIR/elastic-agent.yml"

# Update package index
echo "Updating package index..."
apt-get update

# Install required dependencies
echo "Installing dependencies..."
apt-get install -y curl tar

# Download Elastic Agent
echo "Downloading Elastic Agent version $VERSION..."
curl -L -O $DOWNLOAD_URL

# Extract the downloaded tarball
echo "Extracting Elastic Agent..."
tar xzvf "elastic-agent-$VERSION-linux-x86_64.tar.gz"

# Move to installation directory
echo "Moving files to $INSTALL_DIR..."
mkdir -p $INSTALL_DIR
mv "elastic-agent-$VERSION-linux-x86_64/"* $INSTALL_DIR

# Remove the downloaded tarball
rm "elastic-agent-$VERSION-linux-x86_64.tar.gz"

# Create a default configuration file if it doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating default configuration file..."
    cp "$INSTALL_DIR/elastic-agent.yml" "$CONFIG_FILE"
fi

# Install Elastic Agent as a service
echo "Installing Elastic Agent..."
$INSTALL_DIR/elastic-agent install \
    --url=https://<fleet-server-url>:8220 \
    --enrollment-token=<your-enrollment-token> \
    --insecure  # Remove --insecure if you have valid certificates

# Check the status of the Elastic Agent service
echo "Checking Elastic Agent status..."
systemctl status elastic-agent

echo "Elastic Agent installation completed."
#!/bin/bash
set -e

echo "Updating apt..."
apt-get update

echo "Installing dependencies..."
apt-get install -y curl git libadwaita-1-dev libgtk-4-dev clang libsqlite3-dev wget libssl-dev unzip

echo "Checking for Swift..."
if command -v swift &> /dev/null; then
    echo "Swift is already installed."
    swift --version
    exit 0
fi

# Verified URL
SWIFT_URL="https://download.swift.org/swift-5.10.1-release/ubuntu2204/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04.tar.gz"

echo "Downloading Swift from $SWIFT_URL..."
curl -L "$SWIFT_URL" -o swift.tar.gz

echo "Checking file size..."
ls -lh swift.tar.gz

echo "Extracting Swift..."
tar -xzf swift.tar.gz
mv swift-5.10.1-RELEASE-ubuntu22.04 /usr/share/swift
rm swift.tar.gz

echo "Configuring PATH..."
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' >> /etc/profile
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' >> ~/.bashrc

echo "Done! Swift installed."
/usr/share/swift/usr/bin/swift --version

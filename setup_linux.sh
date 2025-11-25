#!/bin/bash
# setup_linux.sh
# This script automates the setup of the Linux development environment for MedTracker.
# It is designed to run on Ubuntu (specifically tested on 24.04 via WSL).

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Updating apt..."
# Update the package list to ensure we get the latest versions of dependencies.
apt-get update

echo "Installing dependencies..."
# Install required system libraries:
# - curl, wget: For downloading files.
# - git: For version control (and fetching submodules).
# - libadwaita-1-dev: The development headers for the Adwaita UI library (GNOME).
# - libgtk-4-dev: The underlying GTK4 toolkit headers.
# - clang: The C/C++ compiler required by Swift.
# - libsqlite3-dev: SQLite database support (often used by CoreData/SwiftData/Foundation).
# - libssl-dev: OpenSSL support for networking.
# - unzip: Utility to unzip files (if needed).
apt-get install -y curl git libadwaita-1-dev libgtk-4-dev clang libsqlite3-dev wget libssl-dev unzip

echo "Checking for Swift..."
# Check if 'swift' is already in the PATH.
if command -v swift &> /dev/null; then
    echo "Swift is already installed."
    swift --version
    exit 0
fi

# Verified URL for Swift 5.10.1 (Ubuntu 22.04 build).
# Note: We use the Ubuntu 22.04 build even on 24.04 because a specific 24.04 build
# was not available/stable at the time of writing. Swift binaries are often forward-compatible.
SWIFT_URL="https://download.swift.org/swift-5.10.1-release/ubuntu2204/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04.tar.gz"

echo "Downloading Swift from $SWIFT_URL..."
# Download the tarball. -L follows redirects.
curl -L "$SWIFT_URL" -o swift.tar.gz

echo "Checking file size..."
ls -lh swift.tar.gz

echo "Extracting Swift..."
# Extract the tarball.
# -x: extract
# -z: use gzip
# -f: file
tar -xzf swift.tar.gz

# Move the extracted directory to a standard location (/usr/share/swift).
mv swift-5.10.1-RELEASE-ubuntu22.04 /usr/share/swift
rm swift.tar.gz

echo "Configuring PATH..."
# Add the Swift binary directory to the PATH environment variable.
# We add it to both /etc/profile (for login shells) and ~/.bashrc (for interactive shells).
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' >> /etc/profile
echo 'export PATH=/usr/share/swift/usr/bin:$PATH' >> ~/.bashrc

echo "Done! Swift installed."
# Verify the installation by printing the version.
/usr/share/swift/usr/bin/swift --version

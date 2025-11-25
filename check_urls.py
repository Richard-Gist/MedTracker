import urllib.request
import sys

# check_urls.py
# Helper script to verify which Swift download URL is valid.
# This was used because the exact URL structure for Swift downloads can vary
# and we needed to find the correct one for the specific Ubuntu version.

urls = [
    # Candidate URLs for Swift 5.10.1 on Ubuntu 22.04 and 24.04
    "https://download.swift.org/swift-5.10.1-release/ubuntu2204/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04.tar.gz",
    "https://download.swift.org/swift-5.10-release/ubuntu2204/swift-5.10-RELEASE/swift-5.10-RELEASE-ubuntu22.04.tar.gz",
    "https://download.swift.org/swift-5.10.1-release/ubuntu2404/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu24.04.tar.gz",
    "https://download.swift.org/swift-5.10-release/ubuntu2404/swift-5.10-RELEASE/swift-5.10-RELEASE-ubuntu24.04.tar.gz",
    "https://download.swift.org/swift-6.0-release/ubuntu2404/swift-6.0-RELEASE/swift-6.0-RELEASE-ubuntu24.04.tar.gz"
]

for url in urls:
    try:
        print(f"Checking {url}...")
        # Send a HEAD request to check if the file exists without downloading it.
        # This is much faster than a GET request.
        req = urllib.request.Request(url, method='HEAD')
        with urllib.request.urlopen(req) as response:
            if response.status == 200:
                print(f"FOUND: {url}")
                # Exit with success (0) if a valid URL is found.
                sys.exit(0)
    except Exception as e:
        print(f"Failed: {e}")

print("No valid URL found.")
# Exit with failure (1) if no URLs worked.
sys.exit(1)

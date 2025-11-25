import urllib.request
import sys

urls = [
    "https://download.swift.org/swift-5.10.1-release/ubuntu2204/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu22.04.tar.gz",
    "https://download.swift.org/swift-5.10-release/ubuntu2204/swift-5.10-RELEASE/swift-5.10-RELEASE-ubuntu22.04.tar.gz",
    "https://download.swift.org/swift-5.10.1-release/ubuntu2404/swift-5.10.1-RELEASE/swift-5.10.1-RELEASE-ubuntu24.04.tar.gz",
    "https://download.swift.org/swift-5.10-release/ubuntu2404/swift-5.10-RELEASE/swift-5.10-RELEASE-ubuntu24.04.tar.gz",
    "https://download.swift.org/swift-6.0-release/ubuntu2404/swift-6.0-RELEASE/swift-6.0-RELEASE-ubuntu24.04.tar.gz"
]

for url in urls:
    try:
        print(f"Checking {url}...")
        req = urllib.request.Request(url, method='HEAD')
        with urllib.request.urlopen(req) as response:
            if response.status == 200:
                print(f"FOUND: {url}")
                sys.exit(0)
    except Exception as e:
        print(f"Failed: {e}")

print("No valid URL found.")
sys.exit(1)

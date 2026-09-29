#!/bin/bash
set -e

echo "=== Starting Flutter Web Build on Vercel ==="

# Install Flutter SDK in /tmp if not already cached
if [ ! -d "/tmp/flutter" ]; then
  echo "Downloading Flutter SDK (stable)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
fi

export PATH="/tmp/flutter/bin:$PATH"

echo "Flutter version:"
flutter --version

echo "Getting dependencies..."
flutter pub get

echo "Compiling Flutter Web release..."
flutter build web --release --base-href "/"

echo "=== Build finished successfully! ==="

#!/bin/bash
set -e

echo "=== Starting Flutter Web Build on Vercel ==="

# Install Flutter SDK in /tmp if not already cached
if [ ! -d "/tmp/flutter" ]; then
  echo "Downloading Flutter SDK (stable)..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1 /tmp/flutter
fi

export PATH="/tmp/flutter/bin:$PATH"
git config --global --add safe.directory /tmp/flutter 2>/dev/null || true

echo "Flutter version:"
flutter --version

flutter config --no-analytics

echo "Getting dependencies..."
flutter pub get

echo "Compiling Flutter Web release..."
flutter build web --release --base-href "/"

echo "=== Build finished successfully! ==="

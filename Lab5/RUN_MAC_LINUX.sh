#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! command -v flutter >/dev/null 2>&1; then
  echo 'Flutter is not in PATH. Install the Flutter SDK first.' >&2
  exit 1
fi
flutter create --project-name lab5 --platforms=android,ios --no-pub .
flutter pub get
flutter run

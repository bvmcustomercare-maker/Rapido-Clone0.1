#!/usr/bin/env bash
# Gradle wrapper script for Unix-like environments
DIR="$(cd "$(dirname "$0")" && pwd)"
exec java -jar "$DIR/gradle/wrapper/gradle-wrapper.jar" "$@"

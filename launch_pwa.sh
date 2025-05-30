#!/bin/bash

# Default values
SCALE=""
PROFILE="Default"
APP_ID=""
NAME="PWA"

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --scale) SCALE="$2"; shift ;;
        --profile) PROFILE="$2"; shift ;;
        --app-id) APP_ID="$2"; shift ;;
        --name) NAME="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Apply default scale only if not explicitly set
if [ -z "$SCALE" ]; then
    if [ "$PROFILE" == "Profile 3" ]; then
        SCALE="1.25"
    else
        SCALE="1.00"
    fi
fi

if [ -z "$APP_ID" ]; then
    echo "Error: --app-id is required"
    exit 1
fi

# Step 1: Launch hidden dummy window to lock DPI context
google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland \
  --force-device-scale-factor=$SCALE --profile-directory="$PROFILE" --no-startup-window &

# Step 2: Wait to let Chrome commit Wayland surface
sleep 1

# Step 3: Launch the actual PWA
google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland \
  --force-device-scale-factor=$SCALE --profile-directory="$PROFILE" --app-id="$APP_ID"

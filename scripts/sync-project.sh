#!/bin/bash
#
# This is the single source of truth for synchronizing your Xcode project.
# It safely regenerates the project from your source files and project.yml.
#
# Run this script from the project root after adding, renaming, or removing files.
#

set -e # Exit immediately if a command fails

# Navigate to the project root
cd "$(dirname "$0")/.."
echo "Working from project root: $(pwd)"

PROJECT_DIR="ios"
XCODEPROJ_PATH="$PROJECT_DIR/Tymely.xcodeproj"

# --- Automatic Xcode Closing (Optional but Recommended) ---
# This checks if Xcode is running and offers to close it.
if pgrep -x "Xcode" > /dev/null; then
    echo "🚨 Xcode is currently running."
    # Using osascript for a native-looking dialog
    osascript -e 'display dialog "To prevent project corruption, it'\''s best to close Xcode before syncing. Shall I close it for you?" buttons {"Cancel", "Close Xcode"} default button "Close Xcode"'
    if [ $? -eq 0 ]; then # If "Close Xcode" was pressed
        echo "Closing Xcode..."
        osascript -e 'quit app "Xcode"'
        sleep 2 # Give Xcode a moment to close gracefully
    else # If "Cancel" was pressed
        echo "Sync cancelled by user."
        exit 1
    fi
fi

echo "---"
echo "🔄 Synchronizing Xcode project..."

# 1. Delete the existing .xcodeproj file to ensure a clean slate
if [ -d "$XCODEPROJ_PATH" ]; then
    echo "🗑️  Deleting old project file for a clean sync..."
    rm -rf "$XCODEPROJ_PATH"
fi

# 2. Run xcodegen from within the iOS directory
echo "⚙️  Running xcodegen to generate a fresh project..."
(cd "$PROJECT_DIR" && xcodegen generate)

echo "---"
echo "✅ Project synchronized successfully!"

# 3. Automatically open the new project in Xcode
echo "🚀 Opening the new project in Xcode..."
open "$XCODEPROJ_PATH" 
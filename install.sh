#!/bin/bash

# Variables
SCRIPT_NAME="yhyts.sh"
INSTALL_DIR="/usr/local/bin"

# Function to check for root permissions
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root or use sudo."
        exit 1
    fi
}

# Function to check dependencies
check_dependencies() {
    dependencies=("bash" "yt-dlp" "mpv" "awk"  ) # Add other dependencies as needed
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: $dep is not installed."
            exit 1
        fi
    done
}

# Install the script
install_script() {
    echo "Installing $SCRIPT_NAME to $INSTALL_DIR..."
    cp "$SCRIPT_NAME" "$INSTALL_DIR/yhyts"  # Rename to 'thing'
    chmod +x "$INSTALL_DIR/yhyts"
    echo "Installation complete! Run it using 'yhyts'."
}


# Main
check_root
check_dependencies
install_script

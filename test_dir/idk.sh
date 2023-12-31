#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file or directory>"
    exit 1
fi

# Check if the provided path exists
if [ -e "$1" ]; then
    size=$(du -sb "$1" | awk '{print $1}')

    # Check if it's a file
    if [ -f "$1" ]; then
        type="File"
    # Check if it's a directory
    elif [ -d "$1" ]; then
        type="Directory"
    else
        echo "Error: $1 is neither a file nor a directory."
        exit 1
    fi
else
    echo "Error: $1 does not exist."
    exit 1
fi

# Define a function to convert bytes to human-readable format
human_readable_size() {
    local size=$1

    if [ $size -ge 1000000000 ]; then
        echo "$(printf "%.1f" $(echo "scale=2; $size / 1000000000" | bc))G"
    elif [ $size -ge 1000000 ]; then
        echo "$(printf "%.1f" $(echo "scale=2; $size / 1000000" | bc))M"
    elif [ $size -ge 1000 ]; then
        echo "$(printf "%.1f" $(echo "scale=2; $size / 1000" | bc))K"
    else
        echo "${size}B"
    fi
}

# Output the human-readable size and type
echo "$(human_readable_size $size) for $1 ($type)"


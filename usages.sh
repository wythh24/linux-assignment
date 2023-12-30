#!/bin/bash

if [ "$#" -lt 2 ]; then

    case "$1" in
        "u")
            echo "Usage : $0 u <username>"
            exit 1
            ;;
        "user")
            echo "Usage : $0 user <username>"
            exit 1
            ;;

        "h")
            echo "Usage : $0 h <hostname>"
            exit 1
            ;;
        "host")
            echo "Usage : $0 host <hostname>"
            exit 1
            ;;
        "p")
            echo "Usage : $0 p <pathname>"
            exit 1
            ;;
        "path")
            echo "Usage : $0 path <pathname>"
            exit 1
            ;;
    esac
fi

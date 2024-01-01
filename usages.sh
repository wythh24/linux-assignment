#!/bin/bash

usage(){
    command=$1
    echo Usage: $command "[OPTION]"... OBJECT...
}

user_cmd(){
    echo "Example: $0 u <username>"
    echo "Options: u | U | user | USER"
}

if [ "$#" -lt 2 ]; then

    case "$1" in
        u | U | user | USER)
            user_cmd $1
            exit 1
            ;;
        h | H | host | HOST)
            echo "Usage : $0 h <hostname>"
            exit 1
            ;;
        p | P | path | PATH)
            echo "Usage : $0 p <pathname>"
            exit 1
            ;;
    esac
fi

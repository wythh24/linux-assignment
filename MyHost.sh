# Function to display help message
function show_help {
    echo "Usage: $0 [I | IP | H | HOST] <hostname | ip>"
    echo "Example: $0 h one.one.one.one"
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 2 ]; then
    show_help
fi

# Parse command line arguments
case "$1" in
    I | IP | i | ip)
        MODE="ip"
        ;;
    H | HOST | h | host)
        MODE="host"
        ;;
    *)
        show_help
        ;;
esac

TARGET="$2"

# Function to get IP address and hostname information
function get_info {
    IP=$(getent ahostsv4 "$1" | awk '{print $1}' | head -n 1)
    HOST=$(getent ahostsv4 "$1" | awk '{print $3}' | head -n 1)

    if [ -z "$IP" ]; then
        echo "Invalid hostname or IP address."
        exit 1
    fi

    echo "     IP Address: $IP"
    echo "       Hostname: $HOST"

    # Check reachability
    if ping -c 1 -W 1 "$IP" &> /dev/null; then
        echo "    Reachable? Yes"
    else
        echo "    Reachable? No"
    fi

    # Get route/gateway information
    ROUTE=$(ip route get "$IP" | awk '{print $3}')
    DEV=$(ip route get "$IP" | awk '{print $5}')
    echo "Route/Gateway: $ROUTE dev $DEV"

    # Get organization and country information using ipinfo.io API
    INFO=$(curl -sS "https://ipinfo.io/$IP/json")

    # Extract only the organization name and remove unwanted parts
    ORGANIZATION=$(echo "$INFO" | jq -r '.org' | awk '{gsub(/AS[0-9]+/, "", $0); print $0}' | sed 's/, Inc.$//')
    COUNTRY=$(echo "$INFO" | jq -r '.country')

    echo " Organization: $ORGANIZATION"
    echo "       Country: $COUNTRY"
}

# Main script logic
case "$MODE" in
    ip)
        get_info "$TARGET"
        ;;
    host)
        get_info "$TARGET"
        ;;
esac

exit 0
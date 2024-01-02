# !/bin/bash

source usages.sh

# User infor
user_info(){
	
    username=$2

    echo username : $username
    
    # Use getent command to get full name and home directory
    user_info=$(getent passwd $username)
    full_name=$(echo $user_info | cut -d':' -f5 | cut -d',' -f1)
    home_dir=$(echo $user_info | cut -d':' -f6)

    echo "Full Name: $full_name"

    # Use id command to get UID and GID
    id_info=$(id -u $username)
    uid=$(echo $id_info | cut -d' ' -f1)
    gid=$(echo $id_info | cut -d' ' -f2)

    echo "UID, GID: $uid, $gid"

    echo "Home Dir: $home_dir"

    # Use last command to get last login information

    last_log=$(last -n 1 -w $username | awk 'NR==1 {print $3, $4, $5, $6, $7, $8}')

    echo "Last Login: $last_log"
}

is_reachable(){
    local target="$1"
    if ping -c 1 -W 1 "$1" &> /dev/null; then
        echo "yes"
    else
        echo "no"
    fi
}

num_host(){

    target_ip="$2"
    # Get the routing information using ip route command
    route_info=$(ip route get $target_ip)

    # Extract the gateway and route from the output
    gateway=$(echo "$route_info" | awk '/via/ {print $3}')
    interface=$(echo "$route_info" | awk '/dev/ {print $5}')
    dev=$(echo "$route_info" | awk  '{print $4}')

    # Get the organization and country information using whois
    whois_result=$(whois $target_ip)

    api_curl="https://ipinfo.io/$get_last/json"

    info=$(curl -s $api_curl)

    org=$(echo $info | jq -r '.org' | awk '{gsub(/AS[0-9]+/, "", $0); print $0}' | sed 's/, Inc.$//')
    country=$(echo $info | jq -r '.country')

    resolved_value=$(getent hosts $target_ip | awk '{print $2}')

    echo Ip address : $2
    echo   Hostname : $resolved_value
    echo  Reachable : $(is_reachable $2) 

    echo Route/Gateway: $gateway $dev $interface
    echo Organization : $org
    echo Country : $country
}

string_host() {
    target_host=$2
    ip_address=$(getent ahostsv4 "$target_host" | awk '/STREAM/ {print $1}')
    get_last=$(echo $ip_address | awk ' {print $1}')

    api_curl="https://ipinfo.io/$get_last/json"

    info=$(curl -s $api_curl)

    org=$(echo $info | jq -r '.org' | awk '{gsub(/AS[0-9]+/, "", $0); print $0}' | sed 's/, Inc.$//')
    country=$(echo $info | jq -r '.country')

    route_info=$(ip route get $get_last)

    # Extract the gateway and route from the output
    gateway=$(echo "$route_info" | awk '/via/ {print $3}')
    interface=$(echo "$route_info" | awk '/dev/ {print $5}')
    dev=$(echo "$route_info" | awk  '{print $4}')


    echo Ip address: $get_last
    echo Hostname: $target_host
    echo Reachable: $(is_reachable $get_last)

    echo Route/Gateway: $gateway $dev $interface
    echo Organization: $org
    echo Country: $country

}

# host info
host_info(){

    if [[ "$2" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        num_host $1 $2 
    else
        string_host $1 $2 
    fi
}

readable_size(){
   size=$1

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

path_info(){
    
    file_path=$2    

    user=$(stat -c "%U" "$file_path")
    group=$(stat -c "%G" "$file_path")
    permissions=$(stat -c "%A" "$file_path")
    last_modified=$(date -r "$file_path" | awk 'NR==1 {print $2, $3, $6}')
    
    if [ -e "$file_path" ]; then
	if [ -f "$file_path" ]; then
	   type="File"
        elif [ -d "$file_path" ]; then
           type="Folder"
        else 
	   echo "Error: $file_path is neither a file or dir"
           exit 1
        fi
    fi

    #Output file size
    size_bytes=$(stat -c %s "$file_path")


    echo "full pathname : $file_path"
    echo Owner : User=$user, Group=$group
    echo File or Folder : $type
    echo "Permissions : user=${permissions:1:3}, group=${permissions:4:3}, other=${permissions:7:3}"
    echo "Last modified : $last_modified"
    echo "Size : $(readable_size $size_bytes)"
}

# Navigate to method 

case "$1" in 
    u | U | user | USER)
        user_info $1 $2
        exit 1
        ;;
    h | H | host | HOST)
        host_info $1 $2
        exit 1
        ;;
    p | P | path | PATH)
        path_info $1 $2
        exit 1
        ;;
esac

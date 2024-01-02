# **Bash Script Assignment Overview**

The Bash script is designed to gather and display information about users, hosts, and file paths on a Unix-like system. It uses various commands and utilities to extract relevant details and presents them in a readable format.

## **Script Structure**

The script is divided into several functions, each focusing on a specific aspect of information retrieval. The main functionalities include:

1. **User Information**
- Obtains details about a specified user.
- Utilizes the **`getent`**, **`id`**, and **`last`** commands to gather information such as full name, home directory, UID, GID, and last login.
    
```bash
./MyInfo.sh u <username>
 ```
    

2. **Host Information**
- Determines information about a specified IP address or hostname.
- Uses the **`ping`**, **`ip route`**, **`whois`**, **`curl`**, and **`getent`** commands to retrieve data like organization, country, reachability, and routing details.

```bash
./MyInfo.sh h <hostname or IP>
```

3. **Path Information**
- Displays details about a specified file or directory.
- Utilizes **`stat`** command to get information such as owner, group, permissions, type, last modified timestamp, and size (in a readable format).

```bash
./MyInfo.sh p <file or dir_path>
```
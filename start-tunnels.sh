#!/bin/sh
echo "Starting AutoSSH tunnel creation..."

setup_tunnel() {
    echo "Setting up tunnel with the following parameters:"
    echo "Tunnel User: $1"
    echo "Tunnel Host: $2"
    echo "Tunnel Port: $3"
    echo "Local Port: $4"
    echo "Remote Port: $5"
    echo "SSH Key: $SSHKEY"

    [ -z "$1" ] && echo "Error: Tunnel User is missing" && return
    [ -z "$2" ] && echo "Error: Tunnel Host is missing" && return
    [ -z "$3" ] && echo "Error: Tunnel Port is missing" && return
    [ -z "$4" ] && echo "Error: Local Port is missing" && return
    [ -z "$5" ] && echo "Error: Remote Port is missing" && return

    autossh -NT -M 0 -i "/root/.ssh/${SSHKEY}" -o "ServerAliveInterval=60" -o "ServerAliveCountMax=2" -o "StrictHostKeyChecking=no" -o "ExitOnForwardFailure=yes" \
            -L "*:${4}:localhost:${5}" \
            -p "${3}" "${1}@${2}" &
			
    echo "Tunnel setup complete."
}

# Loop through a predefined number of tunnels
for i in $(seq 1 15); do
    tunnel_user=""
    tunnel_host=""
    tunnel_port=""
    local_port=""
    remote_host=""
    remote_port=""

    while IFS=': ' read -r key value; do
        value=$(echo $value | xargs) # Trim leading and trailing whitespaces

        case $key in
            "tunnel${i}_tunnel_user")
                tunnel_user=$value
                ;;
            "tunnel${i}_tunnel_host")
                tunnel_host=$value
                ;;
            "tunnel${i}_tunnel_port")
                tunnel_port=$value
                ;;
            "tunnel${i}_local_port")
                local_port=$value
                ;;
            "tunnel${i}_remote_port")
                remote_port=$value
                ;;
        esac
    done < /config.yaml

    if [ ! -z "$tunnel_user" ]; then
        setup_tunnel "$tunnel_user" "$tunnel_host" "$tunnel_port" "$local_port" "$remote_port"
    fi
done

wait

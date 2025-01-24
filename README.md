Fork of https://github.com/davidhfrankelcodes/portsshare. Focused on Local SSH Tunnels

# portSSHare

## Overview

This project provides a Dockerized solution for setting up to 15 SSH local tunnels using AutoSSH.
It is designed to forward ports (remote_port) from remote machines (tunnel_host) on remote networks (eg VPS) to a target local machine (machine running the portsshare docker container). To enable access to the remote port via the local address e.g. 192.168.1.10:10001 

The setup is controlled through a simple configuration file and is executed within a Docker container for ease of use and portability.

## Prerequisites

- Docker and Docker Compose installed on your system.
- SSH key configured for passwordless login, uses same key for all connections.
- SSH key placed in folder referenced in mapping below in `compose.yml` file
- Set the ports to the desired range and volume. Keeping the number to a minimum can help container performance and prevent impact to docker apps like Portainer, Dockge that seemingly run through the ports when opening a host detail page

## Example Docker Compose

```yaml
services:
  portsshare:
    container_name: portsshare-tunnels
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      # Create a .env file to contain the SSH key name value.
      - SSHKEY=portsshare-id_ed25519
    stdin_open: true # docker run -i
    tty: true # docker run -t
      #
    volumes:
      # Bind the config file so it can be edited without rebuilding the image
      - ~/config.yaml:/config.yaml
      # Bind an SSH key that is authorised to connect to the desired target machines
      - ./keys:/root/.ssh
    restart: unless-stopped
    networks: 
      - portsshare
    ports:
      # set the number of ports required. Keeping the number to a minimum can help container performance and prevent impact to docker apps like Portainer
	  - 10001-10015:10001-10015 
   
networks:
  portsshare:
    driver: bridge
    name: portsshare
```


## Configuration

### Config File Format

The configuration is defined in a YAML file (`config.yaml`). Each tunnel is specified with the following parameters:

- `tunnel_user`: The SSH username for the remote server.
- `tunnel_host`: Hostname or IP address of the remote server.
- `tunnel_port`: The SSH port of the remote server.
- `local_port`: The port on the tunnel host to be forwarded to.
- `remote_port`: The port on the remote server to be forwarded to the local port.

- The SSH key used to authenticate again the remote tunnel hosts. The key should be able to be used to authenticate to all tunnel hosts specified in the config.yaml file.
- The SSH key folder should be mapped into the docker container.

### Example Configuration

```yaml
## Server 1 - 123.123.123.123

# Dozzle - Server 1
tunnel1_local_port: 10002
tunnel1_tunnel_user: ssh_username
tunnel1_tunnel_host: 123.123.123.123
tunnel1_tunnel_port: 22
tunnel1_remote_port: 9999
# Filebrowser - Server 1
tunnel2_local_port: 10003
tunnel2_tunnel_user: ssh_username
tunnel2_tunnel_host: 123.123.123.123
tunnel2_tunnel_port: 22
tunnel2_remote_port: 8086
# dockge - Server 1
tunnel3_tunnel_port: 22
tunnel3_local_port: 10001
tunnel3_tunnel_user: ssh_username
tunnel3_tunnel_host: 123.123.123.123
tunnel3_remote_port: 9998

## Server 2 - 123.123.123.124

# dockge - Server 2
tunnel4_tunnel_port: 22
tunnel4_local_port: 10004
tunnel4_tunnel_user: ssh_username
tunnel4_tunnel_host: 123.123.123.124
tunnel4_remote_port: 9998
# Dozzle - Server 2
tunnel5_local_port: 10005
tunnel5_tunnel_user: ssh_username
tunnel5_tunnel_host: 123.123.123.124
tunnel5_tunnel_port: 22
tunnel5_remote_port: 9999
# Filebrowser - Server 2
tunnel6_local_port: 10006
tunnel6_tunnel_user: ssh_username
tunnel6_tunnel_host: 123.123.123.124
tunnel6_tunnel_port: 22
tunnel6_remote_port: 8086

## Server 3 - 123.123.123.125

# Portainer - Server 3
tunnel7_tunnel_port: 22
tunnel7_local_port: 10007
tunnel7_tunnel_user: ssh_username
tunnel7_tunnel_host: 123.123.123.125
tunnel7_remote_port: 9443
# Excalidraw - Server 3
tunnel8_local_port: 10008
tunnel8_tunnel_user: ssh_username
tunnel8_tunnel_host: 123.123.123.125
tunnel8_tunnel_port: 22
tunnel8_remote_port: 9980
# Bytestash - Server 3
tunnel9_local_port: 10009
tunnel9_tunnel_user: ssh_username
tunnel9_tunnel_host: 123.123.123.125
tunnel9_tunnel_port: 22
tunnel9_remote_port: 5000
# Sterling-PDF - Server 3
tunnel9_local_port: 10010
tunnel9_tunnel_user: ssh_username
tunnel9_tunnel_host: 123.123.123.125
tunnel9_tunnel_port: 22
tunnel9_remote_port: 8080
```

## Usage

1. **Prepare Configuration**: Copy the `config.yaml.example` file into a new file in the same location named `config.yaml` to define your SSH tunneling setup.

2. **Run the Docker Container**:

    ```bash
    docker-compose up -d
    ```

3. **Check Tunnels**: Verify that the tunnels are established.

   ```bash
    docker-compose logs
    ```

4. **Stopping the Container**:

    ```bash
    docker-compose down
    ```

## Additional Information

- The setup script (`start-tunnels.sh`) is designed to parse the `config.yaml` file and set up the SSH tunnels as specified.
- The Docker container uses Alpine Linux for a minimal footprint.
- The AutoSSH tool is used for establishing persistent SSH tunnels.

## Troubleshooting

- Ensure SSH keys are correctly set up for passwordless authentication.
- Check that the specified ports are open and not blocked by firewalls.
- For any connection issues, review the logs of the Docker container.
- Check the sshd config at for example `/etc/ssh/sshd_config` and try again with the settings below.
  ```bash
    $ egrep "AllowTcpForwarding|GatewayPorts" /etc/ssh/sshd_config
    AllowTcpForwarding yes
    GatewayPorts yes
  ```

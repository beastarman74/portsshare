# portSSHare

## Overview

This project provides a Dockerized solution for setting up to 15 SSH local tunnels using AutoSSH.
It is designed to forward ports (remote port) from a remote machine (tunnel host) on a remote network (eg a VPS) to a target local machine (machine running the docker container). 

The setup is controlled through a simple configuration file and is executed within a Docker container for ease of use and portability.

## Prerequisites

- Docker and Docker Compose installed on your system.
- SSH keys configured for passwordless login.
- 

## Configuration

### Config File Format

The configuration is defined in a YAML file (`config.yaml`). Each tunnel is specified with the following parameters:

- `tunnel_user`: The SSH username for the source server.
- `tunnel_host`: Hostname or IP address of the docker host server.
- `tunnel_port`: The SSH port of the docker host server.
- `local_port`: The port on the docker host server to be forwarded to.
- `remote_port`: The port on the tunnel host to be forwarded to the local port.

- The SSH key used to authenticate again the remote tunnel hosts. The key should be able to be used to authenticate to all tunnel hosts specified in the config.yaml file.
- The SSH key folder should be mapped into the docker container.

### Example Configuration

```yaml
tunnel1_source_ssh_user: username
tunnel1_source_host: source-server.example.com
tunnel1_source_host_ssh_port: 22
tunnel1_source_port: 8080
tunnel1_target_ssh_user: username
tunnel1_target_host: target-server.example.com
tunnel1_target_host_ssh_port: 22
tunnel1_target_port: 9000

tunnel2_source_ssh_user: username
tunnel2_source_host: another-source-server.example.com
tunnel2_source_host_ssh_port: 22
tunnel2_source_port: 8000
tunnel2_target_ssh_user: username
tunnel2_target_host: target-server.example.com
tunnel2_target_host_ssh_port: 22
tunnel2_target_port: 9001
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

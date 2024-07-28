# Use Alpine Linux as the base image
FROM alpine:latest

# Install autossh
RUN apk add --no-cache autossh tzdata openssl libssl3 libcrypto3
RUN rm -rf /var/cache/apk/*;

# Copy the script and configuration file (to be created in the next steps)
COPY start-tunnels.sh /start-tunnels.sh
COPY config.yaml.example /config.yaml

ENV \
    AUTOSSH_PIDFILE=/autossh.pid \
    AUTOSSH_LOGFILE=/dev/stdout  \
    AUTOSSH_GATETIME=30           \
    AUTOSSH_POLL=120             \
    AUTOSSH_FIRST_POLL=60        \
    AUTOSSH_LOGLEVEL=7           \
    TZ=Etc/UTC

# Set execute permissions on the script
RUN chmod +x /start-tunnels.sh

# Expose the ports that can be used for the local tunnels
EXPOSE 10001-10015

# Set the default command to execute the script
CMD ["/start-tunnels.sh"]

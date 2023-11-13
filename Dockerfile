
# Use an official Ubuntu runtime as a parent image
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install required tools
RUN apt-get update -y && \
    apt-get install -y wget curl && \
    if [ ! -f cloudflared ]; then \
        wget -q -nc https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared; \
        chmod +x cloudflared; \
    fi && \
    curl -fsSL https://code-server.dev/install.sh | sh

# Set environment variable for the port
ENV PORT=10000

# Start VSCode
CMD code-server --port $PORT --disable-telemetry --auth none & \
    sleep 10 && \
    ./cloudflared tunnel --url http://127.0.0.1:$PORT --metrics localhost:45678

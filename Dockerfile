# Dockerfile for Ubuntu Lab Server
# Cloud Technology Exam - Khid Pagna - PPUA

FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Phnom_Penh

# Set the working directory
WORKDIR /app

# Update package lists and install required packages
RUN apt-get update && \
    apt-get install -y \
    vim \
    openssh-server \
    nginx \
    sudo \
    curl \
    wget \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create ubuntu user with sudo privileges
RUN useradd -m -s /bin/bash ubuntu && \
    usermod -aG sudo ubuntu && \
    echo 'ubuntu:ubuntu123' | chpasswd

# Configure SSH
RUN mkdir -p /home/ubuntu/.ssh && \
    chown ubuntu:ubuntu /home/ubuntu/.ssh && \
    chmod 700 /home/ubuntu/.ssh && \
    mkdir /var/run/sshd

# Configure SSH settings
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create website directory and copy website files
RUN mkdir -p /var/www/html
COPY website/index.html /var/www/html/

# Set proper permissions for the website
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Copy and set up the startup script
COPY scripts/startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh

# Expose ports
EXPOSE 22 80 443

# Create startup script that will run when container starts
RUN echo '#!/bin/bash\n\
service ssh start\n\
service nginx start\n\
echo "Services started successfully!"\n\
echo "SSH: Available on port 22"\n\
echo "Web: Available on port 80"\n\
echo "Ubuntu user password: ubuntu123"\n\
while true; do\n\
    service ssh status || service ssh start\n\
    service nginx status || service nginx start\n\
    sleep 30\n\
done' > /app/startup.sh && chmod +x /app/startup.sh

# Start services when container runs
CMD ["/app/startup.sh"]

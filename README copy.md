# Docker Lab - Cloud Technology Exam

## Environment-Based Configuration

This Docker Compose setup creates a configurable Ubuntu server container with all required components for the lab assignment.

## Quick Setup

1. **First-time setup:**
   ```bash
   cd docker
   ./lab-manager.sh setup    # Creates .env from template
   # Edit .env file with your details
   ./lab-manager.sh start    # Start the lab
   ```

2. **Or manual setup:**
   ```bash
   cp .env.example .env
   # Edit .env with your information
   docker-compose up -d
   ```

## Configuration

All settings are now configurable via the `.env` file:

- **Student Information:** Name, ID, Institution
- **Container Settings:** Name, hostname, image tag
- **Port Mappings:** SSH, HTTP, HTTPS ports
- **Credentials:** Username and password
- **Docker Hub:** Your Docker Hub username

### Environment Variables

Key variables you should customize in `.env`:

```bash
# Student Information
STUDENT_NAME="Your Full Name"
STUDENT_ID="Your Student ID"
DOCKER_HUB_USERNAME="your-dockerhub-username"

# Port Configuration (change if conflicts)
SSH_PORT=2222
HTTP_PORT=8080
HTTPS_PORT=8443

# Container Name (make it unique)
CONTAINER_NAME="your-name-ubuntu-server"
```

## What's Included

- **Ubuntu 20.04 LTS** base image
- **SSH server** for remote access
- **Nginx web server** for hosting the website
- **Vim editor** for text editing
- Pre-configured user: `ubuntu` with password: `ubuntu123`

## Directory Structure

```
docker/
├── docker-compose.yml          # Main Docker Compose configuration
├── scripts/
│   └── setup.sh               # Container setup script
├── website/
│   └── index.html             # HTML website content
├── ssh-keys/                  # SSH keys directory (initially empty)
└── README.md                  # This file
```

## Quick Start

1. **Start the container:**
   ```bash
   cd docker
   docker-compose up -d
   ```

2. **Check if container is running:**
   ```bash
   docker-compose ps
   ```

3. **View the website:**
   Open your browser and go to: http://localhost:8080

## Lab Tasks

### 1. Create Container (Ubuntu Linux Server)
- ✅ Container name: `khid-pagna-ubuntu-server`
- ✅ Updates system packages
- ✅ Installs vim, SSH, nginx

### 2. Remote Access via SSH
- **SSH Port:** 2222 (mapped from container port 22)
- **Username:** ubuntu
- **Password:** ubuntu123

Connect using:
```bash
ssh ubuntu@localhost -p 2222
```

### 3. HTML Website
- **URL:** http://localhost:8080
- ✅ Contains required content with your details
- ✅ Styled with CSS for better presentation

### 4. Push to Docker Hub

After testing, commit the container and push to Docker Hub:

```bash
# Stop the container
docker-compose down

# Commit the container as an image
docker commit khid-pagna-ubuntu-server khidpagna/ubuntu-lab-server:latest

# Login to Docker Hub
docker login

# Push to Docker Hub
docker push khidpagna/ubuntu-lab-server:latest
```

## Useful Commands

### Container Management
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# Access container shell
docker-compose exec ubuntu-server bash
```

### SSH Key Setup (Optional)
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ./ssh-keys/id_rsa

# Copy public key to container (after it's running)
docker-compose exec ubuntu-server bash -c "mkdir -p /home/ubuntu/.ssh && cat /ssh-keys/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys && chmod 600 /home/ubuntu/.ssh/authorized_keys"
```

### Troubleshooting
```bash
# Check container status
docker-compose ps

# View container logs
docker-compose logs ubuntu-server

# Restart services
docker-compose restart

# Access container directly
docker exec -it khid-pagna-ubuntu-server bash
```

## Port Mappings

- **SSH:** Host port 2222 → Container port 22
- **HTTP:** Host port 8080 → Container port 80
- **HTTPS:** Host port 8443 → Container port 443

## Network Configuration

- **Network:** lab-network (172.20.0.0/16)
- **Container IP:** Automatically assigned by Docker

## Notes

- The container is configured to restart automatically unless stopped manually
- All services (SSH and Nginx) start automatically when the container boots
- Website content is mounted as a volume for easy editing
- SSH keys can be added to the ssh-keys directory for key-based authentication

## Student Information

- **Name:** Khid Pagna
- **Student ID:** [Update in website/index.html]
- **Course:** Cloud Technology
- **Institution:** PPUA

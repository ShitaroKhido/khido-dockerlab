# Setup Guide for Other Students

## Prerequisites

- Docker and Docker Compose installed
- Git (optional, for cloning)
- Text editor for editing configuration files

## Quick Start for New Students

### Step 1: Get the Lab Files

**Option A: Download/Copy the files**
- Copy all files from the `docker/` directory to your computer

**Option B: Clone from repository (if available)**
```bash
git clone <repository-url>
cd docker-lab
```

### Step 2: Configure Your Environment

1. **Create your environment configuration:**
   ```bash
   cd docker
   ./lab-manager.sh setup
   ```
   
   This creates a `.env` file from the template.

2. **Edit the `.env` file** with your information:
   ```bash
   vim .env    # or use your preferred editor
   ```
   
   **Required changes:**
   ```bash
   # Update these with YOUR information
   STUDENT_NAME="Your Full Name"
   STUDENT_ID="Your Student ID"
   DOCKER_HUB_USERNAME="your-dockerhub-username"
   
   # Make container name unique (use your name)
   CONTAINER_NAME="your-name-ubuntu-server"
   
   # Change ports if they conflict on your system
   SSH_PORT=2222      # Change if 2222 is already used
   HTTP_PORT=8080     # Change if 8080 is already used
   ```

### Step 3: Start Your Lab

```bash
# Start the lab environment
./lab-manager.sh start

# Check status
./lab-manager.sh status

# View your configuration
./lab-manager.sh env
```

### Step 4: Access Your Lab

- **Website:** http://localhost:8080 (or your HTTP_PORT)
- **SSH:** `ssh ubuntu@localhost -p 2222` (password: ubuntu123)

## Available Commands

```bash
./lab-manager.sh help           # Show all available commands
./lab-manager.sh setup          # First-time environment setup
./lab-manager.sh start          # Start the lab
./lab-manager.sh stop           # Stop the lab
./lab-manager.sh status         # Show status and configuration
./lab-manager.sh ssh            # Connect via SSH
./lab-manager.sh website        # Open website in browser
./lab-manager.sh commit         # Prepare image for Docker Hub
./lab-manager.sh push           # Push to Docker Hub
```

## Customization Options

### Port Conflicts

If the default ports are already used on your system:

```bash
# Edit .env file and change:
SSH_PORT=3333      # Instead of 2222
HTTP_PORT=9090     # Instead of 8080
HTTPS_PORT=9443    # Instead of 8443
```

### Container Naming

Make your container unique:

```bash
# Use your name in the container name
CONTAINER_NAME="john-doe-ubuntu-server"
HOSTNAME="john-doe-lab-server"
```

### Docker Hub Configuration

Update with your Docker Hub credentials:

```bash
DOCKER_HUB_USERNAME="your-dockerhub-username"
# Your image will be: your-dockerhub-username/ubuntu-lab-server
```

## File Structure You'll Have

```
docker/
├── .env                        # Your configuration (create from template)
├── .env.example               # Configuration template
├── .gitignore                 # Git ignore file
├── docker-compose.yml         # Main Docker Compose file
├── Dockerfile                 # Container definition
├── lab-manager.sh            # Management script
├── README.md                 # Main documentation
├── LAB-INSTRUCTIONS.md       # Detailed lab steps
├── SETUP-GUIDE.md           # This file
├── scripts/
│   └── setup.sh             # Container setup script
├── website/
│   └── index.html           # Static website template
└── ssh-keys/                # SSH keys directory (initially empty)
```

## Common Issues and Solutions

### Port Already in Use
```bash
# Error: Port 2222 already in use
# Solution: Change SSH_PORT in .env file
SSH_PORT=3333
```

### Container Name Conflicts
```bash
# Error: Container name already exists
# Solution: Change CONTAINER_NAME in .env file
CONTAINER_NAME="your-unique-name-ubuntu-server"
```

### Docker Hub Push Fails
```bash
# Make sure you're logged in
docker login

# Check your username in .env
DOCKER_HUB_USERNAME="your-actual-username"
```

### Website Shows Template Values
```bash
# Make sure you updated .env with your information
# Restart the container after updating .env
./lab-manager.sh restart
```

## Lab Submission Checklist

- [ ] Updated `.env` with your personal information
- [ ] Container starts successfully
- [ ] Website shows YOUR name and student ID
- [ ] SSH access works
- [ ] Screenshots taken:
  - [ ] `docker ps` showing running container
  - [ ] SSH connection to container
  - [ ] Website with your information
  - [ ] Docker Hub repository page
- [ ] Image pushed to Docker Hub
- [ ] Lab report completed

## Getting Help

1. **Check container status:**
   ```bash
   ./lab-manager.sh status
   ```

2. **View container logs:**
   ```bash
   ./lab-manager.sh logs
   ```

3. **Verify configuration:**
   ```bash
   ./lab-manager.sh env
   ```

4. **Reset everything:**
   ```bash
   ./lab-manager.sh cleanup
   ./lab-manager.sh setup
   # Re-edit .env file
   ./lab-manager.sh start
   ```

## Tips for Success

1. **Always update .env first** before starting the container
2. **Use unique names** to avoid conflicts with other students
3. **Check ports** - change if they're already in use on your system
4. **Take screenshots** at each step for your lab report
5. **Test SSH and website** before submitting
6. **Push to Docker Hub** with your own username

Good luck with your lab!

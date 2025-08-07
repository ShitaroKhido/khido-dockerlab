# Lab Instructions - Cloud Technology Exam
## Student: Khid Pagna - PPUA

### Overview
This lab demonstrates Docker containerization skills by creating an Ubuntu server with web and SSH services.

## Pre-requisites
- Docker and Docker Compose installed
- Terminal access
- Web browser

## Lab Steps

### Step 1: Create and Run the Container

**Option A: Using Docker Compose (Recommended)**
```bash
cd docker
docker compose up -d
```

**Option B: Using Dockerfile Build**
```bash
cd docker
docker compose -f docker-compose-build.yml up -d --build
```

**Option C: Using Lab Manager Script**
```bash
cd docker
./lab-manager.sh start
```

### Step 2: Verify Container Creation
```bash
# Check container status
docker compose ps

# View container details
docker inspect khid-pagna-ubuntu-server

# Take screenshot of running container
docker ps
```

### Step 3: Test SSH Access
```bash
# Connect to container via SSH
ssh ubuntu@localhost -p 2222
# Password: ubuntu123

# Inside the container, verify installations:
vim --version
nginx -v
ssh -V
```

**For SSH Key Authentication (Optional):**
```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ./ssh-keys/id_rsa

# Copy public key to container
cat ./ssh-keys/id_rsa.pub | docker exec -i khid-pagna-ubuntu-server bash -c "cat >> /home/ubuntu/.ssh/authorized_keys"

# Connect using key
ssh -i ./ssh-keys/id_rsa ubuntu@localhost -p 2222
```

### Step 4: Verify Website
1. Open browser and navigate to: http://localhost:8080
2. Verify the website displays your information correctly
3. Take screenshot of the website

### Step 5: Update Website Content (If Needed)
```bash
# Edit the website directly in the container
docker exec -it khid-pagna-ubuntu-server bash
vim /var/www/html/index.html

# Or edit the local file and rebuild (if using Dockerfile)
vim website/index.html
docker compose -f docker-compose-build.yml up -d --build
```

### Step 6: Prepare for Docker Hub Push

1. **Stop the container:**
```bash
docker compose down
```

2. **Commit the container:**
```bash
docker commit khid-pagna-ubuntu-server khidpagna/ubuntu-lab-server:khid-pagna
```

3. **Login to Docker Hub:**
```bash
docker login
```

4. **Push to Docker Hub:**
```bash
docker push khidpagna/ubuntu-lab-server:khid-pagna
```

**Or use the lab manager script:**
```bash
./lab-manager.sh commit
./lab-manager.sh push
```

## Testing Checklist

- [ ] Container created successfully with Ubuntu 20.04
- [ ] System updated and packages installed (vim, ssh, nginx)
- [ ] SSH access working on port 2222
- [ ] Website accessible on port 8080
- [ ] Website displays correct personal information
- [ ] Container can be committed and tagged
- [ ] Image can be pushed to Docker Hub

## Screenshots to Take

1. **Container Creation:** `docker ps` output showing running container
2. **SSH Access:** Terminal showing successful SSH connection
3. **Website:** Browser showing the HTML website with your information
4. **Docker Hub:** Docker Hub repository page showing pushed image

## Troubleshooting

### Container Won't Start
```bash
# Check logs
docker compose logs

# Remove and recreate
docker compose down
docker compose up -d
```

### SSH Connection Refused
```bash
# Check if SSH service is running
docker exec khid-pagna-ubuntu-server service ssh status

# Restart SSH service
docker exec khid-pagna-ubuntu-server service ssh restart
```

### Website Not Loading
```bash
# Check if Nginx is running
docker exec khid-pagna-ubuntu-server service nginx status

# Check website files
docker exec khid-pagna-ubuntu-server ls -la /var/www/html
```

### Port Conflicts
If ports 2222 or 8080 are already in use, modify the docker-compose.yml file:
```yaml
ports:
  - "3333:22"    # Change SSH port
  - "9090:80"    # Change HTTP port
```

## File Structure Created
```
docker/
├── docker-compose.yml           # Main compose file
├── docker-compose-build.yml     # Alternative with Dockerfile
├── Dockerfile                   # Container definition
├── lab-manager.sh              # Management script
├── README.md                   # Documentation
├── LAB-INSTRUCTIONS.md         # This file
├── scripts/
│   └── setup.sh               # Container setup script
├── website/
│   └── index.html             # Website content
└── ssh-keys/                  # SSH keys directory
```

## Submission Requirements

For your lab submission, include:

1. Screenshots of:
   - Running container (`docker ps`)
   - SSH connection to container
   - Website in browser
   - Docker Hub repository

2. Docker Hub repository link:
   - `https://hub.docker.com/r/[your-username]/ubuntu-lab-server`

3. Brief description of:
   - What you learned
   - Any challenges faced
   - How this relates to cloud technology

## Additional Notes

- Container name: `khid-pagna-ubuntu-server`
- SSH credentials: ubuntu/ubuntu123
- Container will auto-restart unless manually stopped
- All services start automatically when container boots
- Website content can be modified without rebuilding container

Good luck with your lab!

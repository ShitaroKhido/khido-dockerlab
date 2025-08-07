#!/bin/bash

# Environment Validation Script
# Checks if the lab environment is properly configured

echo "=== Docker Lab Environment Validation ==="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

VALIDATION_PASSED=true

# Function to check if a command exists
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is not installed"
        VALIDATION_PASSED=false
        return 1
    fi
}

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is missing"
        VALIDATION_PASSED=false
        return 1
    fi
}

# Function to check directory exists
check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 directory exists"
        return 0
    else
        echo -e "${RED}✗${NC} $1 directory is missing"
        VALIDATION_PASSED=false
        return 1
    fi
}

# Function to validate environment variable
check_env_var() {
    local var_name="$1"
    local default_value="$2"
    local current_value="${!var_name}"
    
    if [ -n "$current_value" ] && [ "$current_value" != "$default_value" ]; then
        echo -e "${GREEN}✓${NC} $var_name is configured: $current_value"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $var_name needs customization (currently: ${current_value:-not set})"
        return 1
    fi
}

echo "Checking prerequisites..."

# Check required commands
check_command "docker"
check_command "docker" && docker compose version >/dev/null 2>&1 && echo -e "${GREEN}✓${NC} docker compose is available" || (echo -e "${RED}✗${NC} docker compose is not available" && VALIDATION_PASSED=false)

echo ""
echo "Checking file structure..."

# Check required files
check_file ".env"
check_file ".env.example"
check_file "docker-compose.yml"
check_file "lab-manager.sh"
check_file "scripts/setup.sh"
check_file "website/index.html"

# Check directories
check_directory "scripts"
check_directory "website"
check_directory "ssh-keys"

echo ""
echo "Checking environment configuration..."

# Load environment variables if .env exists
if [ -f .env ]; then
    set -a
    source .env
    set +a
    
    # Check critical environment variables
    echo "Validating environment variables..."
    check_env_var "STUDENT_NAME" "Khid Pagna"
    check_env_var "STUDENT_ID" "Your Student ID Here"
    check_env_var "DOCKER_HUB_USERNAME" "khidpagna"
    check_env_var "CONTAINER_NAME" "khid-pagna-ubuntu-server"
    
    # Check if ports are available
    echo ""
    echo "Checking port availability..."
    
    if ! netstat -tuln 2>/dev/null | grep -q ":${SSH_PORT:-2222} "; then
        echo -e "${GREEN}✓${NC} SSH port ${SSH_PORT:-2222} is available"
    else
        echo -e "${YELLOW}⚠${NC} SSH port ${SSH_PORT:-2222} is already in use"
    fi
    
    if ! netstat -tuln 2>/dev/null | grep -q ":${HTTP_PORT:-8080} "; then
        echo -e "${GREEN}✓${NC} HTTP port ${HTTP_PORT:-8080} is available"
    else
        echo -e "${YELLOW}⚠${NC} HTTP port ${HTTP_PORT:-8080} is already in use"
    fi
else
    echo -e "${RED}✗${NC} .env file not found. Run: ./lab-manager.sh setup"
    VALIDATION_PASSED=false
fi

echo ""
echo "Checking Docker status..."

# Check if Docker daemon is running
if docker info >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Docker daemon is running"
    
    # Check if any containers with the same name exist
    if [ -n "$CONTAINER_NAME" ]; then
        if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
            echo -e "${YELLOW}⚠${NC} Container $CONTAINER_NAME already exists"
            echo "    Use './lab-manager.sh cleanup' to remove it"
        else
            echo -e "${GREEN}✓${NC} Container name $CONTAINER_NAME is available"
        fi
    fi
else
    echo -e "${RED}✗${NC} Docker daemon is not running"
    VALIDATION_PASSED=false
fi

echo ""
echo "=== Validation Summary ==="

if [ "$VALIDATION_PASSED" = true ]; then
    echo -e "${GREEN}✓ All checks passed! Your environment is ready.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Start your lab: ./lab-manager.sh start"
    echo "2. Check status: ./lab-manager.sh status"
    echo "3. Access website: http://localhost:${HTTP_PORT:-8080}"
    echo "4. SSH access: ssh ${UBUNTU_USERNAME:-ubuntu}@localhost -p ${SSH_PORT:-2222}"
else
    echo -e "${RED}✗ Some issues need to be resolved before starting the lab.${NC}"
    echo ""
    echo "Common fixes:"
    echo "• Install Docker and Docker Compose"
    echo "• Run: ./lab-manager.sh setup (to create .env file)"
    echo "• Edit .env file with your information"
    echo "• Change ports in .env if they're already in use"
fi

echo ""

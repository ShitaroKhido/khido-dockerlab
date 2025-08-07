#!/bin/bash

# Lab Management Script for Docker Lab
# Cloud Technology Exam - PPUA

set -e

# Load environment variables from .env file
if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    set -a  # automatically export all variables
    source .env
    set +a
else
    echo "Warning: .env file not found. Using default values."
    echo "Please copy .env.example to .env and configure it."
fi

# Set default values if not provided in .env
CONTAINER_NAME="${CONTAINER_NAME:-khid-pagna-ubuntu-server}"
DOCKER_HUB_USERNAME="${DOCKER_HUB_USERNAME:-khidpagna}"
IMAGE_NAME="${IMAGE_NAME:-ubuntu-lab-server}"
STUDENT_NAME="${STUDENT_NAME:-Student Name}"
SSH_PORT="${SSH_PORT:-2222}"
HTTP_PORT="${HTTP_PORT:-8080}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

echo "=== Docker Lab Management Script ==="
echo "Student: ${STUDENT_NAME}"
echo "Course: Cloud Technology - PPUA"
echo "Container: ${CONTAINER_NAME}"
echo "=================================="

function show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  setup       Create .env file from template (first-time setup)"
    echo "  validate    Validate environment configuration and prerequisites"
    echo "  start       Start the lab environment"
    echo "  stop        Stop the lab environment"
    echo "  restart     Restart the lab environment"
    echo "  status      Show container status and configuration"
    echo "  logs        Show container logs"
    echo "  ssh         Connect to container via SSH"
    echo "  shell       Open shell in container"
    echo "  website     Open website in browser"
    echo "  commit      Commit container to image"
    echo "  push        Push image to Docker Hub"
    echo "  cleanup     Remove all containers and images"
    echo "  env         Show current environment configuration"
    echo "  help        Show this help message"
    echo ""
    echo "Environment Variables:"
    echo "  Configuration is loaded from .env file"
    echo "  Copy .env.example to .env and customize as needed"
}

function setup_env() {
    if [ -f .env ]; then
        echo "Warning: .env file already exists!"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Setup cancelled."
            return
        fi
    fi
    
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "Created .env file from template."
        echo "Please edit .env file to customize your configuration:"
        echo "  - Update STUDENT_NAME with your full name"
        echo "  - Update STUDENT_ID with your student ID"
        echo "  - Update DOCKER_HUB_USERNAME with your Docker Hub username"
        echo "  - Adjust ports if needed (SSH_PORT, HTTP_PORT)"
        echo ""
        echo "After editing .env, run: $0 start"
    else
        echo "Error: .env.example file not found!"
        exit 1
    fi
}

function validate_env() {
    echo "Running environment validation..."
    if [ -f "./validate.sh" ]; then
        ./validate.sh
    else
        echo "Validation script not found. Basic checks:"
        echo "✓ .env file exists: $([ -f .env ] && echo "Yes" || echo "No")"
        echo "✓ Docker available: $(command -v docker >/dev/null && echo "Yes" || echo "No")"
        echo "✓ Docker Compose available: $(command -v docker-compose >/dev/null && echo "Yes" || echo "No")"
    fi
}

function show_env() {
    echo "Current Environment Configuration:"
    echo "=================================="
    echo "Student Information:"
    echo "  Name: ${STUDENT_NAME}"
    echo "  ID: ${STUDENT_ID}"
    echo "  Institution: ${INSTITUTION}"
    echo ""
    echo "Container Configuration:"
    echo "  Name: ${CONTAINER_NAME}"
    echo "  Hostname: ${HOSTNAME}"
    echo "  Image: ${IMAGE_NAME}:${IMAGE_TAG}"
    echo ""
    echo "Network Configuration:"
    echo "  SSH Port: ${SSH_PORT}"
    echo "  HTTP Port: ${HTTP_PORT}"
    echo "  HTTPS Port: ${HTTPS_PORT}"
    echo ""
    echo "Docker Hub:"
    echo "  Username: ${DOCKER_HUB_USERNAME}"
    echo "  Repository: ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}"
    echo ""
    echo "Credentials:"
    echo "  Ubuntu Username: ${UBUNTU_USERNAME}"
    echo "  Ubuntu Password: ${UBUNTU_PASSWORD}"
}

function start_lab() {
    echo "Starting lab environment..."
    docker-compose up -d
    echo "Lab started successfully!"
    echo "SSH: ssh ${UBUNTU_USERNAME:-ubuntu}@localhost -p ${SSH_PORT} (password: ${UBUNTU_PASSWORD:-ubuntu123})"
    echo "Website: http://localhost:${HTTP_PORT}"
}

function stop_lab() {
    echo "Stopping lab environment..."
    docker-compose down
    echo "Lab stopped successfully!"
}

function restart_lab() {
    echo "Restarting lab environment..."
    docker-compose restart
    echo "Lab restarted successfully!"
}

function show_status() {
    echo "Container status:"
    docker-compose ps
    echo ""
    echo "Port mappings:"
    docker port $CONTAINER_NAME 2>/dev/null || echo "Container not running"
    echo ""
    echo "Environment configuration:"
    echo "  Student: ${STUDENT_NAME}"
    echo "  Container: ${CONTAINER_NAME}"
    echo "  SSH Port: ${SSH_PORT}"
    echo "  HTTP Port: ${HTTP_PORT}"
    echo "  Docker Hub: ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}"
}

function show_logs() {
    echo "Container logs:"
    docker-compose logs --tail=50 ubuntu-server
}

function connect_ssh() {
    echo "Connecting to container via SSH..."
    echo "Username: ${UBUNTU_USERNAME:-ubuntu}"
    echo "Password: ${UBUNTU_PASSWORD:-ubuntu123}"
    ssh ${UBUNTU_USERNAME:-ubuntu}@localhost -p ${SSH_PORT}
}

function open_shell() {
    echo "Opening shell in container..."
    docker-compose exec ubuntu-server bash
}

function open_website() {
    echo "Opening website..."
    local website_url="http://localhost:${HTTP_PORT}"
    if command -v xdg-open > /dev/null; then
        xdg-open "$website_url"
    elif command -v open > /dev/null; then
        open "$website_url"
    else
        echo "Please open $website_url in your browser"
    fi
}

function commit_container() {
    echo "Committing container to image..."
    if docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        local full_image_name="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
        docker commit $CONTAINER_NAME "$full_image_name"
        echo "Container committed as $full_image_name"
        
        # Also tag with student name for easy identification
        local student_tag="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${STUDENT_NAME// /-}-${IMAGE_TAG}"
        docker tag "$full_image_name" "$student_tag"
        echo "Also tagged as: $student_tag"
    else
        echo "Error: Container $CONTAINER_NAME is not running"
        exit 1
    fi
}

function push_image() {
    echo "Pushing image to Docker Hub..."
    echo "Make sure you're logged in to Docker Hub: docker login"
    
    local full_image_name="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    local student_tag="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${STUDENT_NAME// /-}-${IMAGE_TAG}"
    
    # Check if image exists
    if docker images -q "$full_image_name" | grep -q .; then
        echo "Pushing main image: $full_image_name"
        docker push "$full_image_name"
        
        if docker images -q "$student_tag" | grep -q .; then
            echo "Pushing student tagged image: $student_tag"
            docker push "$student_tag"
        fi
        
        echo "Image(s) pushed successfully to Docker Hub!"
        echo "Repository: https://hub.docker.com/r/${DOCKER_HUB_USERNAME}/${IMAGE_NAME}"
    else
        echo "Error: Image $full_image_name not found"
        echo "Run '$0 commit' first to create the image"
        exit 1
    fi
}

function cleanup() {
    echo "Cleaning up lab environment..."
    echo "This will remove all containers and images created for this lab."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose down -v
        
        # Remove images with different tags
        docker rmi "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}" 2>/dev/null || true
        docker rmi "${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${STUDENT_NAME// /-}-${IMAGE_TAG}" 2>/dev/null || true
        docker rmi ubuntu:20.04 2>/dev/null || true
        
        echo "Cleanup completed!"
    else
        echo "Cleanup cancelled."
    fi
}

# Main script logic
case "${1:-help}" in
    setup)
        setup_env
        ;;
    validate)
        validate_env
        ;;
    start)
        start_lab
        ;;
    stop)
        stop_lab
        ;;
    restart)
        restart_lab
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    ssh)
        connect_ssh
        ;;
    shell)
        open_shell
        ;;
    website)
        open_website
        ;;
    commit)
        commit_container
        ;;
    push)
        push_image
        ;;
    cleanup)
        cleanup
        ;;
    env)
        show_env
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Unknown option: $1"
        echo "Use '$0 help' for available options"
        exit 1
        ;;
esac

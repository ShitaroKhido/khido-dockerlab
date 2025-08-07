#!/bin/bash
set -e

echo "Starting Ubuntu Server Setup..."
echo "Student: ${STUDENT_NAME:-Unknown Student}"
echo "Institution: ${INSTITUTION:-PPUA}"

# Update package lists
apt-get update

# Install required packages
echo "Installing vim, openssh-server, nginx, and other utilities..."
apt-get install -y vim openssh-server nginx sudo curl wget

# Create ubuntu user with sudo privileges
UBUNTU_USER="${UBUNTU_USERNAME:-ubuntu}"
UBUNTU_PASS="${UBUNTU_PASSWORD:-ubuntu123}"

echo "Creating user: $UBUNTU_USER..."
useradd -m -s /bin/bash "$UBUNTU_USER"
usermod -aG sudo "$UBUNTU_USER"
echo "$UBUNTU_USER:$UBUNTU_PASS" | chpasswd

# Configure SSH
echo "Configuring SSH..."
mkdir -p "/home/$UBUNTU_USER/.ssh"
chown "$UBUNTU_USER:$UBUNTU_USER" "/home/$UBUNTU_USER/.ssh"
chmod 700 "/home/$UBUNTU_USER/.ssh"

# Copy SSH keys from host if available
if [ -d "/home/$UBUNTU_USER/.ssh-host" ] && [ "$(ls -A /home/$UBUNTU_USER/.ssh-host 2>/dev/null)" ]; then
    echo "Copying SSH keys from host..."
    cp /home/$UBUNTU_USER/.ssh-host/* /home/$UBUNTU_USER/.ssh/ 2>/dev/null || true
    chown -R "$UBUNTU_USER:$UBUNTU_USER" "/home/$UBUNTU_USER/.ssh"
    chmod 600 "/home/$UBUNTU_USER/.ssh/"* 2>/dev/null || true
fi

# Enable SSH service
service ssh start

# Configure SSH settings
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Restart SSH service
service ssh restart

# Start Nginx
echo "Starting Nginx..."
service nginx start

# Create dynamic website content using environment variables
echo "Creating website content..."
mkdir -p /var/www/html

# Generate HTML with environment variables
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${WEBSITE_TITLE:-Cloud Technology Exam - Docker Lab}</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #333;
            text-align: center;
            border-bottom: 2px solid #007acc;
            padding-bottom: 10px;
        }
        .content {
            line-height: 1.6;
            color: #555;
        }
        .details {
            background-color: #f8f9fa;
            padding: 15px;
            border-left: 4px solid #007acc;
            margin: 20px 0;
        }
        .signature {
            margin-top: 30px;
            text-align: right;
            font-style: italic;
        }
        .lab-info {
            background-color: #e8f5e8;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .env-info {
            background-color: #fff3cd;
            padding: 10px;
            border-radius: 5px;
            font-size: 0.9em;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>${WEBSITE_TITLE:-Cloud Technology Exam - Docker Lab}</h1>
        <div class="content">
            <p>Dear AUB cloud team,</p>
            <p>My full name is <strong>${STUDENT_NAME:-Student Name}</strong>, this is cloud technology exam (${EXAM_TYPE:-midterm}), after taking this course, we will be able to take AWS Cloud Practitioner certified exam which recognized worldwide.</p>
            
            <div class="details">
                <h3>Here is my detail at ${INSTITUTION:-PPUA}:</h3>
                <ul>
                    <li><strong>Full Name:</strong> ${STUDENT_NAME:-Student Name}</li>
                    <li><strong>Student ID:</strong> ${STUDENT_ID:-Please update in .env file}</li>
                    <li><strong>Course:</strong> ${COURSE_NAME:-Cloud Technology}</li>
                    <li><strong>Institution:</strong> ${INSTITUTION:-PPUA}</li>
                </ul>
            </div>
            
            <div class="lab-info">
                <h3>Lab Environment Information:</h3>
                <p>This website is running on:</p>
                <ul>
                    <li>🐧 Ubuntu 20.04 LTS Container</li>
                    <li>🌐 Nginx Web Server</li>
                    <li>🐳 Docker & Docker Compose</li>
                    <li>🔧 SSH Server (accessible via port ${SSH_PORT:-2222})</li>
                    <li>📝 Vim Editor installed</li>
                    <li>⚙️ Environment Variables Configured</li>
                </ul>
            </div>
            
            <div class="env-info">
                <h4>Container Configuration:</h4>
                <ul>
                    <li>Container Name: ${CONTAINER_NAME:-khid-pagna-ubuntu-server}</li>
                    <li>Hostname: ${HOSTNAME:-ubuntu-lab-server}</li>
                    <li>SSH Port: ${SSH_PORT:-2222}</li>
                    <li>HTTP Port: ${HTTP_PORT:-8080}</li>
                    <li>Timezone: ${TZ:-Asia/Phnom_Penh}</li>
                </ul>
            </div>
            
            <div class="details">
                <h3>Lab Tasks Completed:</h3>
                <ol>
                    <li>✅ Created Ubuntu Linux server container</li>
                    <li>✅ Updated system packages</li>
                    <li>✅ Installed vim, SSH, and nginx</li>
                    <li>✅ Configured SSH for remote access</li>
                    <li>✅ Created dynamic HTML website with environment variables</li>
                    <li>✅ Configured environment-based setup</li>
                    <li>🔄 Ready to push to Docker Hub</li>
                </ol>
            </div>
        </div>
        
        <div class="signature">
            <p>Best regards,<br>
            <strong>${STUDENT_NAME:-Student Name}</strong></p>
            <p><em>Generated on: $(date)</em></p>
        </div>
    </div>
</body>
</html>
EOF

# Copy website files from volume mount if available (for custom content)
if [ -d "/website" ] && [ -f "/website/index.html" ]; then
    echo "Found custom website content, using mounted files..."
    cp -f /website/index.html /var/www/html/index.html
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Setup completed successfully!"
echo "Container Configuration:"
echo "  Student: ${STUDENT_NAME:-Unknown}"
echo "  Container: ${CONTAINER_NAME:-khid-pagna-ubuntu-server}"
echo "  SSH: Available on port 22 (mapped to host port ${SSH_PORT:-2222})"
echo "  Web: Available on port 80 (mapped to host port ${HTTP_PORT:-8080})"
echo "  User: ${UBUNTU_USERNAME:-ubuntu} / Password: ${UBUNTU_PASSWORD:-ubuntu123}"
echo "  Institution: ${INSTITUTION:-PPUA}"

# Keep services running
while true; do
    service ssh status || service ssh start
    service nginx status || service nginx start
    sleep 30
done

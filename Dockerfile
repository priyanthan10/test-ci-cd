# Use the AlmaLinux base image
FROM almalinux:8

# Set environment variables
ENV NODE_VERSION=16 \
    PATH="/usr/local/bin:$PATH"

# Install necessary tools and Node.js
RUN dnf install -y gcc-c++ make curl && \
    curl -fsSL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    dnf install -y nodejs && \
    dnf clean all

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]

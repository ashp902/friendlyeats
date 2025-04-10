FROM --platform=linux/amd64 node:18-slim

# Install Firebase CLI and necessary dependencies
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g firebase-tools@latest && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package.json ./
COPY package-lock.json* ./

# Install app dependencies
RUN npm install

# Copy app source
COPY . .

# Create a simple server to serve static files
RUN npm install -g serve

# Expose port 8080
EXPOSE 8080

# Create a startup script
RUN echo '#!/bin/bash\n\
PORT="${PORT:-8080}"\n\
echo "Starting server on port $PORT"\n\
serve -s . -l $PORT' > /start-server.sh && \
    chmod +x /start-server.sh

CMD ["/start-server.sh"]

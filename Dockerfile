# Use an official Node runtime as a parent image
FROM node:20-slim

# Install Python and build-essential (make, g++) required for native Node bindings
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    bash \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# COPY package files FIRST to leverage Docker layer caching
# This prevents re-downloading all packages every time you change a single line of code
COPY package*.json ./

# Install npm dependencies, explicitly telling npm to include optional native bindings
RUN npm install --include=optional

# Copy Python requirements and install them
COPY backend/requirements.txt backend/
RUN pip3 install --no-cache-dir -r backend/requirements.txt --break-system-packages

# Now copy the rest of your application code
COPY . .

# Build the React application
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the app
CMD ["npm", "run", "preview", "--", "--port", "3000", "--host", "0.0.0.0"]
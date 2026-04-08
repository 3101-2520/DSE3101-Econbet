# Use an official Node runtime as a parent image
FROM node:18-slim

# Install Python and other necessary tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r backend/requirements.txt --break-system-packages

# Install Node.js dependencies
RUN npm install

# Build the React application
# Note: This uses the existing CSVs in public/ if they exist.
# If you want to generate fresh data during build, you'd need the FRED_API_KEY here.
RUN npm run build

# Expose the port the app runs on
EXPOSE 3000

# Define the command to run the app
# We use 'npm run preview' to serve the built files
CMD ["npm", "run", "preview", "--", "--port", "3000", "--host", "0.0.0.0"]

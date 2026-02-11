#!/bin/bash
# Script to load Docker images for offline deployment

echo "Loading Docker images..."

# Load Trac image
if [ -f "docker-images/trac-image.tar" ]; then
    echo "Loading Trac image..."
    docker load -i docker-images/trac-image.tar
    echo "✓ Trac image loaded"
else
    echo "✗ trac-image.tar not found"
fi

# Load PostgreSQL image  
if [ -f "docker-images/postgres-image.tar" ]; then
    echo "Loading PostgreSQL image..."
    docker load -i docker-images/postgres-image.tar
    echo "✓ PostgreSQL image loaded"
else
    echo "✗ postgres-image.tar not found"
fi

echo ""
echo "Images loaded successfully!"
echo "You can now run: docker-compose up -d"

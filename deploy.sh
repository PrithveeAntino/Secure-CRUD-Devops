#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Starting deployment..."

# 1. Check Prerequisites
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    # In newer versions, it's 'docker compose', let's check that too
    if ! docker compose version &> /dev/null; then
        echo -e "${RED}Error: Docker Compose is not installed.${NC}"
        exit 1
    fi
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
fi

echo "Prerequisites checked."

# 2. Clean State
echo "Cleaning up old containers and volumes..."
$DOCKER_COMPOSE_CMD down -v --remove-orphans

# 3. Build & Launch
echo "Building and launching containers..."
$DOCKER_COMPOSE_CMD up --build -d

# 4. Health Check
echo "Waiting for services to be healthy..."
RETRIES=30
COUNT=0
SUCCESS=0

while [ $COUNT -lt $RETRIES ]; do
    if curl -s http://localhost/health > /dev/null; then
        SUCCESS=1
        break
    fi
    echo -n "."
    sleep 2
    COUNT=$((COUNT+1))
done

echo ""

if [ $SUCCESS -eq 1 ]; then
    echo -e "${GREEN}[SUCCESS] Application is live at http://localhost${NC}"
else
    echo -e "${RED}[FAILURE] Application failed to start within the timeout period.${NC}"
    echo "Checking logs..."
    $DOCKER_COMPOSE_CMD logs app
    exit 1
fi

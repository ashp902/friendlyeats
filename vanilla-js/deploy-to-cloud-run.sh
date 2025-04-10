#!/bin/bash
set -e

# Enable Docker BuildKit for better cross-platform support
export DOCKER_BUILDKIT=1

# Configuration
PROJECT_ID=$(gcloud config get-value project)
IMAGE_NAME="friendlyeats-vanilla-js"
REGION="us-central1"  # Change this to your preferred region
SERVICE_NAME="friendlyeats-vanilla-js"

# Check if PROJECT_ID is set
if [ -z "$PROJECT_ID" ]; then
  echo "Error: No Google Cloud project selected. Run 'gcloud config set project YOUR_PROJECT_ID' first."
  exit 1
fi

# Create Artifact Registry repository if it doesn't exist
echo "Setting up Artifact Registry repository..."
gcloud artifacts repositories create friendlyeats-repo \
  --repository-format=docker \
  --location=$REGION \
  --description="Repository for FriendlyEats app" \
  --quiet || true

# Configure Docker to use Artifact Registry
echo "Configuring Docker for Artifact Registry..."
gcloud auth configure-docker $REGION-docker.pkg.dev --quiet

# Build the Docker image with platform specified for Cloud Run compatibility
echo "Building Docker image for linux/amd64 platform..."
IMAGE_URL="$REGION-docker.pkg.dev/$PROJECT_ID/friendlyeats-repo/$IMAGE_NAME"
docker build --platform linux/amd64 -t $IMAGE_URL .

# Push the image to Artifact Registry
echo "Pushing image to Artifact Registry..."
docker push $IMAGE_URL

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
  --image $IMAGE_URL \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --port 8080 \
  --timeout 300s

echo "Deployment complete! Your app is now running on Cloud Run."
echo "You can view your service at: https://console.cloud.google.com/run/detail/$REGION/$SERVICE_NAME"

#!/bin/bash
set -e

# Configuration
PROJECT_ID=$(gcloud config get-value project)
IMAGE_NAME="friendlyeats-web"
REGION="us-central1"  # Change this to your preferred region
SERVICE_NAME="friendlyeats-web"

# Check if PROJECT_ID is set
if [ -z "$PROJECT_ID" ]; then
  echo "Error: No Google Cloud project selected. Run 'gcloud config set project YOUR_PROJECT_ID' first."
  exit 1
fi

# Build the Docker image
echo "Building Docker image..."
docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME .

# Push the image to Google Container Registry
echo "Pushing image to Google Container Registry..."
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME

# Deploy to Cloud Run
echo "Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$IMAGE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated

echo "Deployment complete! Your app is now running on Cloud Run."
echo "You can view your service at: https://console.cloud.google.com/run/detail/$REGION/$SERVICE_NAME"

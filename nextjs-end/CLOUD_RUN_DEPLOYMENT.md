# Deploying FriendlyEats to Google Cloud Run

This guide will help you deploy the FriendlyEats Next.js application to Google Cloud Run.

## Prerequisites

1. [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured
2. [Docker](https://docs.docker.com/get-docker/) installed
3. A Google Cloud project with billing enabled
4. Firebase project configured (follow the main README.md setup instructions)

## Deployment Steps

### 1. Set up Google Cloud CLI

Make sure you're authenticated and have selected your project:

```bash
# Login to Google Cloud
gcloud auth login

# Set your project ID
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

### 2. Configure Docker for Google Container Registry

```bash
# Configure Docker to use gcloud as a credential helper
gcloud auth configure-docker
```

### 3. Deploy to Cloud Run

Run the deployment script from the nextjs-end directory:

```bash
cd nextjs-end
./deploy-to-cloud-run.sh
```

This script will:
- Build a Docker image of your application
- Push the image to Google Container Registry
- Deploy the image to Cloud Run
- Configure the service to be publicly accessible

### 4. Environment Variables

If your application requires environment variables (like Firebase configuration), you can add them to the deployment command in the script:

```bash
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$IMAGE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-env-vars "FIREBASE_API_KEY=your_api_key,FIREBASE_AUTH_DOMAIN=your_domain"
```

For sensitive information, use Cloud Run secrets:

```bash
# Create a secret
gcloud secrets create my-secret --replication-policy="automatic"
echo -n "my-secret-value" | gcloud secrets versions add my-secret --data-file=-

# Use the secret in your deployment
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$IMAGE_NAME \
  --platform managed \
  --region $REGION \
  --allow-unauthenticated \
  --set-secrets="/secrets/my-secret=my-secret:latest"
```

## Troubleshooting

- If you encounter permission issues, make sure your account has the necessary IAM roles:
  - Cloud Run Admin
  - Cloud Build Editor
  - Storage Admin

- Check the Cloud Run logs in the Google Cloud Console for debugging information.

- If your application isn't working correctly, verify that all required environment variables are set.

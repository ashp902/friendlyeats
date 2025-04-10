# Deploying FriendlyEats (vanilla-js) to Google Cloud Run

This guide will help you deploy the vanilla JavaScript version of FriendlyEats to Google Cloud Run using the Firebase emulator for hosting.

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
gcloud services enable artifactregistry.googleapis.com
gcloud services enable run.googleapis.com
```

### 2. Deploy to Cloud Run

Run the deployment script from the vanilla-js directory:

```bash
cd vanilla-js
./deploy-to-cloud-run.sh
```

This script will:
- Create an Artifact Registry repository if it doesn't exist
- Configure Docker to use Artifact Registry
- Build a Docker image of your application
- Push the image to Artifact Registry
- Deploy the image to Cloud Run
- Configure the service to be publicly accessible

## How It Works

The deployment uses a Docker container that:

1. Installs the necessary dependencies
2. Copies your application code
3. Uses the `serve` package to serve your static files
4. Listens on port 8080 as required by Cloud Run

We've switched from using the Firebase emulator to using the `serve` package because it's more reliable in a containerized environment and ensures proper listening on the required port.

## Firebase Configuration

If your application requires Firebase configuration, you'll need to ensure your Firebase project is properly set up and the configuration in your application is correct.

The Firebase emulator will serve your static files, but any Firebase services (Firestore, Authentication, etc.) will still need to connect to your actual Firebase project unless you configure additional emulators.

## Troubleshooting

- If you encounter permission issues, make sure your account has the necessary IAM roles:
  - Cloud Run Admin
  - Cloud Build Editor
  - Storage Admin

- If you get an error about container manifest type or architecture compatibility, it's likely because you're building on a machine with a different architecture (like Apple Silicon M1/M2/M3). The deployment script has been updated to explicitly build for the linux/amd64 platform that Cloud Run requires.

- If you encounter an error about the container not listening on the port defined by the PORT environment variable, it means the application inside the container isn't properly binding to the port. We've updated the Dockerfile to use the `serve` package instead of the Firebase emulator to ensure reliable port binding.

- Check the Cloud Run logs in the Google Cloud Console for debugging information.

- If your application isn't connecting to Firebase services, verify that your Firebase configuration in the application is correct.

- If you need to use additional Firebase emulators (Firestore, Auth, etc.), modify the `start-emulator.sh` script to include those emulators.

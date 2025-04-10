#!/bin/bash

# Get the PORT environment variable from Cloud Run or default to 8080
PORT="${PORT:-8080}"

# Start Firebase emulator with hosting only
# The --host 0.0.0.0 makes it accessible from outside the container
# The --port $PORT makes it use the port provided by Cloud Run
firebase emulators:start --only hosting --host 0.0.0.0 --port $PORT

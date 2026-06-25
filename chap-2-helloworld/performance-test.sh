#!/bin/bash

# --- Configuration ---
URL="${APP_URL:-http://localhost:8000/hello}"
TOTAL_REQUESTS=100
SUM_RESPONSE_TIME="0" # Initialize to 0 to prevent awk errors on the first loop

echo "Starting performance test: $TOTAL_REQUESTS requests to $URL"
echo "--------------------------------------------------"

for ((i=1; i<=TOTAL_REQUESTS; i++))
do
    # curl grabs the time_total (in seconds) for the request
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$URL")

    # Accumulate the response times using awk
    SUM_RESPONSE_TIME=$(awk "BEGIN {printf \"%.6f\", $SUM_RESPONSE_TIME + $RESPONSE_TIME}")

    if (( i % 10 == 0 )); then
        echo "Completed $i/$TOTAL_REQUESTS requests..."
    fi
done

# --- Calculations & Verification ---
# Calculate the average response time per request
AVERAGE_TIME=$(awk "BEGIN {printf \"%.4f\", $SUM_RESPONSE_TIME / $TOTAL_REQUESTS}")

echo "--------------------------------------------------"
echo "Test Completed!"
echo "Total Cumulative Time: $SUM_RESPONSE_TIME seconds"
echo "Average Response Time: $AVERAGE_TIME seconds"
echo "--------------------------------------------------"

# Check if the AVERAGE time is less than 1.0 second
IS_UNDER_ONE_SEC=$(awk "BEGIN {print ($AVERAGE_TIME < 1.0) ? 1 : 0}")

if [ "$IS_UNDER_ONE_SEC" -eq 1 ]; then
    echo "PASS: Average response time is less than 1 second."
    exit 0
else
    echo "FAIL: Average response time exceeded 1 second."
    exit 1
fi
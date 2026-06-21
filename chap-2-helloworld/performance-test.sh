#!/bin/bash

# --- Configuration ---
URL="${APP_URL:-http://localhost:8000/hello}"
TOTAL_REQUESTS=100
TOTAL_TIME="0"

echo "Starting performance test: $TOTAL_REQUESTS requests to $URL"
echo "--------------------------------------------------"

for ((i=1; i<=TOTAL_REQUESTS; i++))
do
    # curl grabs the time_total (in seconds) for the request
    # -o /dev/null silences the actual response body
    # -s silences the curl progress bar
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$URL")

    # Track the cumulative time using awk (no bc dependency)
    TOTAL_TIME=$(awk "BEGIN {printf \"%.6f\", $TOTAL_TIME + $RESPONSE_TIME}")

    # Optional: Print progress every 10 requests so you know it's working
    if (( i % 10 == 0 )); then
        echo "Completed $i/$TOTAL_REQUESTS requests..."
    fi
done

# --- Calculations & Verification ---
# Calculate the average response time using awk for floating-point math
AVERAGE_TIME=$(awk "BEGIN {printf \"%.4f\", $TOTAL_TIME / $TOTAL_REQUESTS}")

echo "--------------------------------------------------"
echo "Test Completed!"
echo "Total Time:   $TOTAL_TIME seconds"
echo "Average Time: $AVERAGE_TIME seconds"
echo "--------------------------------------------------"

# Check if the average time is less than 1 second using awk
IS_UNDER_ONE_SEC=$(awk "BEGIN {print ($AVERAGE_TIME < 1.0) ? 1 : 0}")

if [ "$IS_UNDER_ONE_SEC" -eq 1 ]; then
    echo "✅ PASS: Average response time is less than 1 second."
    exit 0
else
    echo "❌ FAIL: Average response time exceeded 1 second."
    exit 1
fi

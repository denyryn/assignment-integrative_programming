#!/bin/bash

# --- Configuration ---
URL="http://localhost:8000/hello"
TOTAL_REQUESTS=100
TOTAL_TIME=0

echo "Starting performance test: 100 requests to $URL"
echo "--------------------------------------------------"

for ((i=1; i<=TOTAL_REQUESTS; i++))
do
    # curl grabs the time_total (in seconds) for the request
    # -o /dev/null silences the actual response body
    # -s silences the curl progress bar
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$URL")
    
    # Track the cumulative time
    TOTAL_TIME=$(echo "$TOTAL_TIME + $RESPONSE_TIME" | bc)
    
    # Optional: Print progress every 10 requests so you know it's working
    if (( i % 10 == 0 )); then
        echo "Completed $i/$TOTAL_REQUESTS requests..."
    fi
done

# --- Calculations & Verification ---
# Calculate the average response time using 'bc' for floating-point math
AVERAGE_TIME=$(echo "scale=4; $TOTAL_TIME / $TOTAL_REQUESTS" | bc)

echo "--------------------------------------------------"
echo "Test Completed!"
echo "Total Time:   $TOTAL_TIME seconds"
echo "Average Time: $AVERAGE_TIME seconds"
echo "--------------------------------------------------"

# Check if the average time is less than 1 second
# bc returns 1 if true, 0 if false
IS_UNDER_ONE_SEC=$(echo "$AVERAGE_TIME < 1.0" | bc)

if [ "$IS_UNDER_ONE_SEC" -eq 1 ]; then
    echo "✅ PASS: Average response time is less than 1 second."
    exit 0
else
    echo "❌ FAIL: Average response time exceeded 1 second."
    exit 1
fi
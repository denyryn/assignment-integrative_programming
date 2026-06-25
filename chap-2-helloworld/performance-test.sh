#!/bin/bash

# --- Configuration ---
URL="${APP_URL:-http://localhost:8000/hello}"
TOTAL_REQUESTS=100

echo "Starting performance test: $TOTAL_REQUESTS requests to $URL"
echo "--------------------------------------------------"

# Capture start time (seconds since epoch with nanoseconds)
START_TIME=$(date +%s.%N)

for ((i=1; i<=TOTAL_REQUESTS; i++))
do
    # -o /dev/null silences the actual response body, -s silences progress
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" "$URL")

    # Accumulate response times to calculate the average later
    SUM_RESPONSE_TIME=$(awk "BEGIN {printf \"%.6f\", $SUM_RESPONSE_TIME + $RESPONSE_TIME}")

    if (( i % 10 == 0 )); then
        echo "Completed $i/$TOTAL_REQUESTS requests..."
    fi
done

# Capture end time
END_TIME=$(date +%s.%N)

# --- Calculations & Verification ---

# Calculate actual total elapsed wall-clock time
TOTAL_ELAPSED=$(awk "BEGIN {printf \"%.4f\", $END_TIME - $START_TIME}")

# Calculate the average response time per request
AVERAGE_TIME=$(awk "BEGIN {printf \"%.4f\", $SUM_RESPONSE_TIME / $TOTAL_REQUESTS}")

echo "--------------------------------------------------"
echo "Test Completed!"
echo "Actual Elapsed Time:  $TOTAL_ELAPSED seconds"
echo "Average Request Time: $AVERAGE_TIME seconds"
echo "--------------------------------------------------"

# Check if the ACTUAL total elapsed time is less than 1 second
IS_UNDER_ONE_SEC=$(awk "BEGIN {print ($TOTAL_ELAPSED < 1.0) ? 1 : 0}")

if [ "$IS_UNDER_ONE_SEC" -eq 1 ]; then
    echo "✅ PASS: Total test execution took less than 1 second."
    exit 0
else
    echo "❌ FAIL: Total test execution exceeded 1 second."
    exit 1
fi
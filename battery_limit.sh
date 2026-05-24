#!/bin/bash

# Moto G5 Kernel-Direct Battery Monitor
# Reads raw values straight from the Power Supply Management IC (PMIC)

CAPACITY_FILE="/sys/class/power_supply/battery/capacity"
STATUS_FILE="/sys/class/power_supply/battery/status"
LOG_FILE="$HOME/battery_status.log"

# Fallback path checking if your specific kernel structure varies
if [ ! -f "$CAPACITY_FILE" ]; then
    CAPACITY_FILE="/sys/class/power_supply/battery0/capacity"
    STATUS_FILE="/sys/class/power_supply/battery0/status"
fi

# Ensure files exist before reading
if [ -f "$CAPACITY_FILE" ]; then
    BATT_LEVEL=$(cat "$CAPACITY_FILE")
    BATT_STATUS=$(cat "$STATUS_FILE")
    
    # Log the status with a clean timestamp
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Level: ${BATT_LEVEL}%, Status: ${BATT_STATUS}" >> "$LOG_FILE"
    
    # Simple alert trigger if battery drifts dangerously high for a 24/7 server
    if [ "$BATT_LEVEL" -gt 85 ] && [ "$BATT_STATUS" = "Charging" ]; then
        echo "[WARNING] Battery high (${BATT_LEVEL}%). Ensure hardware limiter or smart plug is active." >> "$LOG_FILE"
    fi
else
    echo "[ERROR] Kernel battery files could not be located." >> "$LOG_FILE"
fi

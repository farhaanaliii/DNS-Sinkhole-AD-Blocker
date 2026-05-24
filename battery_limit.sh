#!/bin/bash

CAPACITY_FILE="/sys/class/power_supply/bms/capacity"
STATUS_FILE="/sys/class/power_supply/battery/status"
TEMP_FILE="/sys/class/power_supply/battery/temp"
CONTROL_FILE="/sys/class/power_supply/battery/charging_enabled"

while true; do
    # Read raw data
    BATT_LEVEL=$(sudo cat "$CAPACITY_FILE")
    BATT_STATUS=$(sudo cat "$STATUS_FILE")
    RAW_TEMP=$(sudo cat "$TEMP_FILE")
    BATT_TEMP=$((RAW_TEMP / 10))
    
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    # Charging Control logic execution
    if [ -f "$CONTROL_FILE" ]; then
        if [ "$BATT_LEVEL" -ge 80 ] && [ "$BATT_STATUS" = "Charging" ]; then
            echo "0" | sudo tee "$CONTROL_FILE" > /dev/null
            ACTION=", Action: Cut Off Power"
        elif [ "$BATT_LEVEL" -le 40 ] && [ "$BATT_STATUS" = "Discharging" ]; then
            echo "1" | sudo tee "$CONTROL_FILE" > /dev/null
            ACTION=", Action: Enable Power"
        else
            ACTION=", Action: Monitoring"
        fi
    else
        ACTION=", Action: Static Node"
    fi

    # Append to the log file
    echo "[$TIMESTAMP] Level: ${BATT_LEVEL}%, Status: ${BATT_STATUS}, Temp: ${BATT_TEMP}°C$ACTION" 

    # Wait for 60 seconds before repeating the process
    sleep 600
done


#!/bin/bash
# Data for sending a message to Telegram
BOT_TOKEN="YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID" # To get, execute the request https://api.telegram.org/bot#BOT_TOKEN#/getUpdates
THREAD_ID="YOUR_THREAD_ID" # If chat uses threads

if [ "$PAM_TYPE" = "open_session" ]; then
    # Gathering data for connection message
    username=$(whoami)
    time=$(date +"%d.%m.%Y %H:%M")
    ip_address=$(echo $SSH_CONNECTION | sed 's/^\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\) .*/\1/')
    info=$(curl -s ipinfo.io/$ip_address)
    city=$(echo $info | jq -r '.city')
    provider=$(echo $info | jq -r '.org')

    # Forming the connection message
    MESSAGE="🔒🚪 User $username has connected to the server via SSH! 🔑
👤 Username: $username
🕒 Login Time: $time
📍 IP Address: $ip_address
🏙️ City: $city
🔌 Provider: $provider"

    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE" -d "message_thread_id=$THREAD_ID" > /dev/null

    # Saving the current time in Unix timestamp format to the session_date_start file
    date +"%s" > session_date_start
fi

if [ "$PAM_TYPE" = "close_session" ]; then
    # Getting the session start time from the session_date_start file
    session_start=$(cat session_date_start)

    # Getting the current time in Unix timestamp format
    session_end=$(date +"%s")

    # Calculating the time difference in seconds
    session_duration=$((session_end - session_start))

    # Calculating the number of hours, minutes, and seconds in the total session time
    hours=$((session_duration / 3600))
    minutes=$(( (session_duration % 3600) / 60 ))

    # Gathering data for disconnection message
    username=$(whoami)
    time=$(date +"%d.%m.%Y %H:%M")
    ip_address=$(echo $SSH_CONNECTION | sed 's/^\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\) .*/\1/')
    info=$(curl -s ipinfo.io/$ip_address)
    city=$(echo $info | jq -r '.city')
    provider=$(echo $info | jq -r '.org')

    # Forming the disconnection message with the total session time
    MESSAGE="🔒🚪 User $username has disconnected from the server via SSH.
👤 Username: $username
🕒 Disconnection Time: $time
⏱️ Total Session Time: $hours hr. $minutes min.
📍 IP Address: $ip_address
🏙️ City: $city
🔌 Provider: $provider"

    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" -d "chat_id=$CHAT_ID" -d "text=$MESSAGE" -d "message_thread_id=$THREAD_ID" > /dev/null

    # Clearing the session_date_start file after sending the message
    rm session_date_start
fi

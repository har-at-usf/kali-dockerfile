# Kali Dockerfile

Creates a Kali container in Docker. This configuration focuses more on application-security tools. The resulting container should run on all platforms, including macOS laptops with the M1 chip.

Much of this is taken from here: https://github.com/tsumarios/Kali-Linux-Dockerfile. Other components were pulled from Corey J. Ball's book, "Hacking APIs."

# Installation

Here's how I install it:

```
docker build [-t name] .
```

Where `name` is a custom name that you want to give the container.

# Usage

Here's how I run it:

```
docker run [--name instance-name] -it name
```

Where `name` is the same one you used during installation.

# AppSec

For application security specifically, note the following tools.

- kali-tools-top10
- exploitdb
- dirb
- nikto
- wpscan
- apktool
- dex2jar
- binwalk
- wfuzz
- arjun
- kiterunner
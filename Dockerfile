# Kali Linux latest with useful tools by tsumarios
# Modified by har-at-usf
FROM kalilinux/kali-rolling

# Set working directory to /root
WORKDIR /root

# Install tools
# =============
#
# Update and install applications. Do this in one massive command to 
# get a smaller image. Note: With this approach, each command must be
# terminated by a `&&` (or a `&& \` for newlines).
#
# Install Kali Packages (apt)
# ---------------------------
#
RUN apt -y update && \
	DEBIAN_FRONTEND=noninteractive apt -y dist-upgrade && \
	apt -y autoremove && \
	apt clean && \
#
# Install common and useful tools
    apt -y install curl wget vim git net-tools whois netcat-traditional pciutils usbutils && \
#
# Install useful languages
    apt -y install python3-pip golang nodejs npm && \
#
# Install Kali Linux "Top 10" metapackage and a few cybersecurity useful 
# tools.
# NOTE: ltrace not found in apt -- why?
    DEBIAN_FRONTEND=noninteractive apt -y install \
        kali-tools-top10 \
        netdiscover \
        exploitdb \
        man-db \
        dirb \
        nikto \
        wpscan \
        uniscan \
        lsof \
        apktool \
        dex2jar \
        strace \
        binwalk \
        wfuzz \
        iputils-ping \
        arp-scan \
        iputils-ping \
        testssl.sh \
        sslscan \
        && \
    #
    # These two libraries are required for Nikto to scan some SSL/HTTPS.
    apt -y install \
        libio-socket-ssl-perl \
        libcrypt-ssleay-perl \
        && \
#
#
# Build tools from Github
# -----------------------
    mkdir /build && \
#
# Build Kiterunner.
    cd /build && \
    git clone https://github.com/assetnote/kiterunner && \
    cd kiterunner && \
    make build && \
    ln -s $(pwd)/dist/kr /usr/local/bin/kr && \
    wget https://wordlists-cdn.assetnote.io/data/kiterunner/routes-large.kite.tar.gz && \
    tar -xzf routes-large.kite.tar.gz && \
    cp routes-large.kite /root/routes-large.kite && \
    rm -rf /build/* && \
#
# Build Arjun.
    cd /build && \
    git clone https://github.com/s0md3v/Arjun && \
    cd Arjun && \
    pip install -e . && \
    rm -rf /build/* && \
#
# Build the JWT Tool.
    cd /opt && \
    git clone https://github.com/ticarpi/jwt_tool && \
    pip3 install termcolor cprint pycryptodomex requests && \
    cd jwt_tool && \
    chmod +x jwt_tool.py && \
    ln -s $(pwd)/jwt_tool.py /usr/local/bin/jwt_tool && \
    rm -rf /build && \
#
#
# Install Tor and proxychains, then configure proxychains with Tor
    apt -y install tor proxychains && \
#
# Install ZSH shell with custom settings and set it as default shell
    apt -y install zsh && \
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#
# Done with tool installations.
# -----------------------------

#
# Cleanup
# =======
#
COPY config/.zshrc .
COPY config/proxychains.conf /etc/proxychains.conf

ENTRYPOINT ["/bin/zsh"]
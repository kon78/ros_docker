FROM ubuntu
VOLUME /tmp/.X11-unix
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y \ 
    wget gnupg xvfb x11-xserver-utils python3-pip
    # pulseaudio lxterminal \
RUN apt install python3-pyinotify -y
RUN echo "deb [arch=amd64] https://xpra.org/ focal main" > /etc/apt/sources.list.d/xpra.list
RUN wget -q https://xpra.org/gpg.asc -O- | apt-key add -
RUN apt install xpra -y
RUN apt install xterm -y
RUN mkdir -p /run/user/0/xpra
RUN apt install -y \
    netcat nano net-tools openssh-server iputils-ping
#ENTRYPOINT ["xpra", "start", "--bind-tcp=0.0.0.0:8080", \
#    "--mdns=no", "--webcam=no", "--no-daemon", \
## "--start-on-connect=lxterminal", \
#    "--start=xhost +"]

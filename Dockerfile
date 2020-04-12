FROM ubuntu:latest

ARG DARLING_DEB=https://github.com/darlinghq/darling/releases/download/v0.1.20200331/darling_0.1.20200331.testing_amd64.deb

ADD darling-dkms_1.0_all.deb /root
RUN dpkg -i /root/darling-dkms_1.0_all.deb && rm /root/darling-dkms_1.0_all.deb

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
	libcairo2 libcairo2:i386 \
	libgl1 libgl1:i386 \
	libtiff5 libtiff5:i386 \
	libfreetype6 libfreetype6:i386 \
	libegl1-mesa libegl1-mesa:i386 \
	libfontconfig1 libfontconfig1:i386 \
	libxrandr2 libxrandr2:i386 \
	libxcursor1 libxcursor1:i386 \
	libgif7 libgif7:i386 \
	libpulse0 libpulse0:i386 \
	libavformat57 libavformat57:i386 \
	libavcodec57 libavcodec57:i386 \
	libavresample3 libavresample3:i386 \
	libc6-i386 \
	fuse \
	wget && \
	wget -O darling.deb ${DARLING_DEB} && \
	dpkg -i darling.deb && rm -f darling .deb && apt-get remove -y wget && \
	apt-get clean -y

RUN mkdir -p /usr/libexec/darling/Users/macuser /home/macuser \
	/usr/libexec/darling/Users/Shared \
	/usr/libexec/darling/Volumes/SystemRoot \
	/usr/libexec/darling/var/tmp \
	/usr/libexec/darling/var/run
RUN cd /usr/libexec/darling/Users/macuser && ln -s /Volumes/SystemRoot/home/macuser LinuxHome

ENV HOME=/Users/macuser

ADD bootstrap /
ADD shell /usr/bin
RUN rm -rf /usr/libexec/darling/proc && cd /usr/libexec/darling && ln -s /Volumes/SystemRoot/proc

ENTRYPOINT ["/bootstrap"]

FROM ubuntu:20.04

ENV TZ=America/Santiago \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install build-essential \
    libtool \
    automake \
    gcc \
    flex \
    bison \
    libnet1 \
    libnet1-dev \
    libpcre3 \
    libpcre3-dev \
    autoconf \
    git  \
    pkg-config \
    cmake \
    net-tools \
    libssl-dev \
    wget 
    
# LIBDAQ DEPENDENCIES
RUN apt-get install -y libhwloc-dev liblzma-dev zlib1g-dev liblz4-dev liblz4-tool libluajit-5.1-dev libdumbnet-dev

WORKDIR /tmp

# LIBPCAP
RUN wget https://www.tcpdump.org/release/libpcap-1.8.1.tar.gz && \
    tar xvf libpcap-1.8.1.tar.gz && \
    cd libpcap-1.8.1 && \
    ./configure && \
    make && make install && \ 
    ldconfig

# LIBDAQ
RUN git clone https://github.com/snort3/libdaq.git && \
    cd libdaq && \
    ./bootstrap && \
    ./configure --prefix=/usr/local/lib/daq_s3 && \
    make install && \
    echo "/usr/local/lib/daq_s3/lib/" > /etc/ld.so.conf.d/libdaq3.conf && \
    ldconfig

# SNORT
RUN git clone https://github.com/snort3/snort3.git && \
    cd snort3 && \
    ./configure_cmake.sh --with-daq-includes=/usr/local/lib/daq_s3/include/ \
    --with-daq-libraries=/usr/local/lib/daq_s3/lib/ && \
    cd build && \
    make -j $(nproc) && \
    make install

# copy snort config
RUN mkdir /etc/snort/

RUN cp /tmp/snort3/lua/*.lua /etc/snort/
COPY ./snort.lua /etc/snort/
RUN mkdir /etc/snort/rules

WORKDIR /tmp
RUN wget https://www.snort.org/downloads/community/snort3-community-rules.tar.gz
RUN tar -xvzf snort3-community-rules.tar.gz && \
    cp snort3-community-rules/*.rules /etc/snort/rules/

COPY ./custom.rules /etc/snort/rules/

RUN rm -Rf /tmp/*
RUN mkdir /var/log/snort

COPY ./entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
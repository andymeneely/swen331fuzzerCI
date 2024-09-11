FROM andymeneely/swen331fuzzer

RUN echo "deb [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list && \
    echo "deb-src [trusted=yes] http://archive.debian.org/debian stretch main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb [trusted=yes] http://archive.debian.org/debian-security stretch/updates main non-free contrib" >> /etc/apt/sources.list

ENV PYTHON_VERSION=3.12.4
ENV PYTHON_SRC_DIR=/usr/src/python
ENV OPENSSL_VERSION=1.1.1w

RUN apt-get upgrade && apt-get update -y \
    && apt-get install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev \
        liblzma-dev \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install OpenSSL 1.1.1 from source
RUN wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz -O /tmp/openssl.tar.gz && \
    mkdir -p /usr/src/openssl && \
    tar -xzf /tmp/openssl.tar.gz -C /usr/src/openssl --strip-components=1 && \
    cd /usr/src/openssl && \
    ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl && \
    make -j$(nproc) && \
    make install && \
    rm -rf /usr/src/openssl /tmp/openssl.tar.gz

# Update the library path for OpenSSL
ENV LD_LIBRARY_PATH=/usr/local/openssl/lib
ENV PATH="/usr/local/openssl/bin:$PATH"

# Download and extract Python 3.12.4 source
RUN mkdir -p $PYTHON_SRC_DIR && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -O /tmp/Python.tgz && \
    tar -xzf /tmp/Python.tgz -C $PYTHON_SRC_DIR --strip-components=1

# Build and install Python 3.12.4 with OpenSSL 1.1.1 support
RUN cd $PYTHON_SRC_DIR && \
    ./configure --with-openssl=/usr/local/openssl --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall


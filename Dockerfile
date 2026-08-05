FROM ghcr.io/digininja/dvwa:latest

RUN apt-get -y update --fix-missing

# Update packages and install Python 3 + Pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
	python3-mechanicalsoup \
    && rm -rf /var/lib/apt/lists/*

# Set python3 as the default 'python' command
RUN ln -s /usr/bin/python3 /usr/bin/python

# Add in our sample files
COPY badchars.txt /
COPY vectors.txt /
COPY words.txt /
COPY sensitive.txt /
COPY extensions.txt /
RUN mkdir /var/www/html/fuzzer-tests
COPY fuzzer-tests /var/www/html/fuzzer-tests

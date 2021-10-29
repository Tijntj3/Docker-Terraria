FROM debian:bullseye-slim

# Create volume for external data
VOLUME ["/config"]

# Update and install utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install gosu screen unzip && \
    apt-get clean

# Environment variables
ENV UID=1000
ENV GID=1000

ENV BINARY=tModLoaderServer
ENV TMOD_VER=0.11.8.5
ENV TMOD_URL=https://github.com/tModLoader/tModLoader/releases/download/v$TMOD_VER/tModLoader.Linux.v$TMOD_VER.zip
ENV TMOD_ZIP=tModLoader.Linux.v$TMOD_VER

# Download and extract necessary files
ADD $TMOD_URL /tmp
RUN unzip /tmp/$TMOD_ZIP.zip -d /tmp/$TMOD_ZIP && \
    mkdir /server && \
    mv /tmp/$TMOD_ZIP/* /server && \
    chmod +x /server/$BINARY* && \
    rm -rf /tmp/$TMOD_ZIP*

# Copy and change permission of entrypoint
COPY run.sh /server
RUN chmod +x /server/run.sh

ENTRYPOINT ["/server/run.sh"]

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

ENV BINARY=TerrariaServer
ENV VANILLA_VER=1423
ENV VANILLA_URL=https://terraria.org/api/download/pc-dedicated-server/terraria-server-$VANILLA_VER.zip
ENV VANILLA_ZIP=terraria-server-$VANILLA_VER

# Download and extract necessary files
ADD $VANILLA_URL /tmp
RUN unzip /tmp/$VANILLA_ZIP.zip -d /tmp/$VANILLA_ZIP && \
    mkdir /server && \
    mv /tmp/$VANILLA_ZIP/$VANILLA_VER/Linux/* /server && \
    chmod +x /server/$BINARY* && \
    rm -rf /tmp/$VANILLA_ZIP*

# Copy and change permission of entrypoint
COPY run.sh /server
RUN chmod +x /server/run.sh

# Launch
ENTRYPOINT ["/server/run.sh"]

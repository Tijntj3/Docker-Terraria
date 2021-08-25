FROM debian:bullseye-slim

# Create volume for external data
VOLUME ["/config"]

# Update and install utils
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install screen unzip && \
    apt-get clean

# Environment variables
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

# Create needed directories and symlinks
RUN mkdir -p ~/.local/share && \
    ln -s /config ~/.local/share/Terraria

# Expose the default terraria server port 
EXPOSE 7777/tcp

# Copy and change permission of entrypoint
COPY run.sh /server
RUN chmod +x /server/run.sh

# Launch
ENTRYPOINT ["/server/run.sh"]
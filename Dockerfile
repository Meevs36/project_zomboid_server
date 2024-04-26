# Author -- meevs
# Creation Date -- 2023-03-04
# File Name -- Dockerfile
# Notes --

FROM steamcmd/steamcmd:debian

ARG INSTALL_DIR="/pz_server/"
ARG SERVER_NAME="default"
ARG CONFIG_PKG="./config_files/base_config.tar.bz"

ENV INSTALL_DIR="${INSTALL_DIR}"
ENV SERVER_NAME="${SERVER_NAME}"
ENV SERVER_ADMIN_PASSWORD="Default_Password_Needs_To_Be_Changed!"
ENV SERVER_ID="380870"

RUN apt-get update -y\
	&& apt-get install -y jq rename

# Copy init scripts
COPY ./init_scripts/ /usr/bin/
RUN chmod a+x /usr/bin/init_container.sh

# Construct directory hierachy and install server
RUN mkdir --parent "${INSTALL_DIR}"\
	&& steamcmd +force_install_dir "${INSTALL_DIR}" +login anonymous +app_update "${SERVER_ID}" +quit

RUN mkdir --parent "/${HOME}/steam/Zomboid/"

WORKDIR ${INSTALL_DIR}

# Copy configuration files
ADD "${CONFIG_PKG}" "${HOME}/Zomboid/Server/"

# Rename configuration files in accordance with server name
RUN rename "s/server/${SERVER_NAME}/" "${HOME}/Zomboid/Server/*"

EXPOSE 16261/udp
EXPOSE 16262/udp

CMD [ "/bin/sh", "-c" ]
ENTRYPOINT [ "init_container.sh" ]

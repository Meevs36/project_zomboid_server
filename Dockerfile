# Author -- meevs
# Creation Date -- 2023-03-04
# File Name -- Dockerfile
# Notes --

FROM mbox/steamcmd

ARG INSTALL_DIR="/pz_server/"
ARG SERVER_NAME="default"
ARG CONFIG_PKG="./config_files/base_config.tar.bz2"

ENV INSTALL_DIR="${INSTALL_DIR}"
ENV SERVER_NAME="${SERVER_NAME}"
ENV SERVER_ADMIN_PASSWORD="Default_Password_Needs_To_Be_Changed!"
ENV SERVER_ID="380870"
ENV ZOMBOID_SERVER_CFG_DIR="${HOME}/Zomboid/Server"

RUN apt-get update -y\
	&& apt-get install -y jq rename

# Copy init scripts
COPY ./scripts/ /usr/bin/

RUN chmod a+x /usr/bin/init_pz_server\
	&& chmod a+x /usr/bin/add_mods.awk

# Construct directory hierachy and install server
RUN mkdir --parent "${INSTALL_DIR}"\
	&& mkdir --parent "/${HOME}/Zomboid/"\
	&& steamcmd +force_install_dir "${INSTALL_DIR}" +login anonymous +app_update "${SERVER_ID}" +quit

WORKDIR ${INSTALL_DIR}

# Copy configuration files
ADD "${CONFIG_PKG}" "${HOME}/Zomboid/Server/"

RUN mv --verbose "${ZOMBOID_SERVER_CFG_DIR}/mod_list.json" "${INSTALL_DIR}/"\
	&& mv --verbose "${ZOMBOID_SERVER_CFG_DIR}/server.ini" "${ZOMBOID_SERVER_CFG_DIR}/${SERVER_NAME}.ini"\
	&& mv --verbose "${ZOMBOID_SERVER_CFG_DIR}/server_SandboxVars.lua" "${ZOMBOID_SERVER_CFG_DIR}/${SERVER_NAME}_SandboxVars.lua"\
	&& mv --verbose "${ZOMBOID_SERVER_CFG_DIR}/server_spawnpoints.lua" "${ZOMBOID_SERVER_CFG_DIR}/${SERVER_NAME}_spawnpoints.lua"\
	&& mv --verbose "${ZOMBOID_SERVER_CFG_DIR}/server_spawnregions.lua" "${ZOMBOID_SERVER_CFG_DIR}/${SERVER_NAME}_spawnregions.lua"
	

EXPOSE 16261/udp
EXPOSE 16262/udp

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "init_pz_server" ]]

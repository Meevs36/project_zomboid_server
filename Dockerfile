# Author -- meevs
# Creation Date -- 2023-03-04
# File Name -- Dockerfile
# Notes --
#     -- This Dockerfile is used to generate a Project Zomboid Dedicated Server image
#     -- This Dockerfile requires a mbox/steamcmd image

FROM steamcmd/steamcmd:debian

ARG INSTALL_DIR="/pz_server/"
ARG IMPORT_CONFIG_DIR="/home//.config/project_zomboid"
ARG CONFIG_DIR="./config_files/base"
ARG SERVER_NAME="default"

ENV SERVER_NAME="${SERVER_NAME}"
ENV SERVER_ADMIN_PASSWORD="Default_Password_Needs_To_Be_Changed!"

ENV SERVER_ID="380870"
ENV INSTALL_DIR="${INSTALL_DIR}"
ENV IMPORT_CONFIG_DIR="${IMPORT_CONFIG_DIR}"


# Copy init scripts
COPY ./init_scripts/ /usr/bin/
RUN chmod a+x /usr/bin/init_container.sh

# Construct directory hierachy and install server
RUN mkdir --parent "${INSTALL_DIR}"\
	&& steamcmd +force_install_dir "${INSTALL_DIR}" +login anonymous +app_update "${SERVER_ID}" +quit

RUN mkdir --parent /root/steam/Zomboid/\
	&& mkdir --parent "${IMPORT_CONFIG_DIR}"

WORKDIR ${INSTALL_DIR}

# Copy configuration files
#COPY "${CONFIG_DIR}/${SERVER_NAME}.ini" "${HOME}/Zomboid/Server/${SERVER_NAME}.ini"
#COPY "${CONFIG_DIR}/${SERVER_NAME}_SandboxVars.lua" "${HOME}/Zomboid/Server/${SERVER_NAME}_SanboxVars.lua"
#COPY "${CONFIG_DIR}/${SERVER_NAME}_spawnregions.lua" "${HOME}/Zomboid/Server/${SERVER_NAME}_spawnregions.lua"
#COPY "${CONFIG_DIR}/${SERVER_NAME}_spawnpoints.lua" "${HOME}/Zomboid/Server/${SERVER_NAME}_spawnpoints.lua"
COPY "${CONFIG_DIR}/" "${HOME}/Zomboid/Server/"

EXPOSE 16261/udp
EXPOSE 16262/udp

CMD [ "/bin/sh", "-c" ]
ENTRYPOINT [ "init_container.sh" ]

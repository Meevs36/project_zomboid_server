# Author -- meevs
# Creation Date -- 2023-03-04
# File Name -- Dockerfile
# Notes --

FROM steamcmd/steamcmd:debian

ARG INSTALL_DIR="/pz_server/"
ARG SERVER_NAME="default"

ENV INSTALL_DIR="${INSTALL_DIR}"
ENV SERVER_NAME="${SERVER_NAME}"
ENV SERVER_ADMIN_PASSWORD="Default_Password_Needs_To_Be_Changed!"
ENV SERVER_ID="380870"

# Copy init scripts
COPY ./init_scripts/ /usr/bin/
RUN chmod a+x /usr/bin/init_container.sh

# Construct directory hierachy and install server
RUN mkdir --parent "${INSTALL_DIR}"\
	&& steamcmd +force_install_dir "${INSTALL_DIR}" +login anonymous +app_update "${SERVER_ID}" +quit

RUN mkdir --parent "/${HOME}/steam/Zomboid/"

WORKDIR ${INSTALL_DIR}

# Copy configuration files
ADD "./config_files/${SERVER_NAME}.tar.bz" "${HOME}/Zomboid/Server/"

EXPOSE 16261/udp
EXPOSE 16262/udp

CMD [ "/bin/sh", "-c" ]
ENTRYPOINT [ "init_container.sh" ]

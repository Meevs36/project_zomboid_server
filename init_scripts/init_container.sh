#!/bin/sh
# Author -- meevs
# Creation Date -- 2023-07-09
# File Name -- entrypoint.sh
# Notes --

echo "<<INFO>> -- Starting server..."
"${INSTALL_DIR}/start-server.sh" -servername "${SERVER_NAME}" -adminpassword "${ADMIN_PASSWORD}"
echo "<<INFO>> -- Server has stopped."

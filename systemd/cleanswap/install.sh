#!/bin/bash

LOCATION="/etc/systemd/system/"
DIR="$( cd "$( dirname "$0" )" && pwd )"

git submodule init
git submodule update

cp "${DIR}/../systemd/cleanswap/auto-swap-cleaner/auto_swap_cleaner.sh" /opt/

chmod 755 /opt/auto_swap_cleaner.sh

cp "${DIR}/cleanswap.service" "${LOCATION}"

chmod 644 "${LOCATION}/cleanswap.service"

systemctl daemon-reload

systemctl start cleanswap

systemctl enable cleanswap

systemctl status cleanswap
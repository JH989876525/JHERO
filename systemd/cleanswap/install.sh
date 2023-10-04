#!/bin/bash

LOCATION="/etc/systemd/system/"

cp auto-swap-cleaner/auto_swap_cleaner.sh /opt/

chmod 755 /opt/auto_swap_cleaner.sh

cp cleanswap.service "${LOCATION}"

chmod 644 "${LOCATION}/cleanswap.service"

systemctl daemon-reload

systemctl start cleanswap

systemctl enable cleanswap

systemctl status cleanswap
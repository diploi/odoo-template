#!/bin/bash

# For some reason HOME is set to /root when logging in as odoo, 
# even if /etc/password is correct this is a dirty workaround and 
# should be investigated more, probably not the right way to do this
if [ "$(whoami)" = "odoo" ]; then
  export HOME="/home/odoo"
fi
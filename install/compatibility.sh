#!/bin/sh
. ./helper.sh;

info "Setting up Compatibility Tools..."

info "Installing wine: Windows API implementation."
info "Installing winetricks: Simple tool to work around common problems in Wine."

apt-get install -y --no-install-recommends \
  wine winetricks
info "Compatibility Configuration Complete!"

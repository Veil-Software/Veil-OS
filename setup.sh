#!/bin/sh
. ./helper.sh;
# VeilOS setup script
# Must be run as root on Debian minimal

set -e
set -u

SKIP_DEV=false

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-dev)
      SKIP_DEV=true
      shift
      ;;
    *)
      # Ignore or handle other unknown arguments
      shift
      ;;
  esac
done

# Check privileges
if [ "$(id -u)" -ne 0 ]; then
  info "The install script must be run as root."
  exit 1
fi

# Run modular install scripts
sh ./install/pre-install-config.sh
sh ./install/desktop-environment.sh
sh ./install/firmware.sh
sh ./install/media.sh
sh ./install/office.sh
sh ./install/security.sh
sh ./install/utilities.sh

if [ "$SKIP_DEV" = false ]; then
    sh ./install/devops.sh
else
    info "Skipping DevOps installation..."
fi

sh ./install/branding.sh
sh ./install/post-install-config.sh

REBOOT="N"
if [ -t 0 ]; then
    info "Install is complete. Reboot now? (y/N)"
    read -r REBOOT
fi

if [ "$REBOOT" = "y" ] || [ "$REBOOT" = "Y" ]; then
    reboot
fi

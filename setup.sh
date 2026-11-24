#!/bin/sh
. ./helper.sh
# VeilOS setup script
# Must be run as root on Debian minimal

set -e
set -u

# Configuration file to store state
CONFIG_DIR="/etc/veilos"
STATE_FILE="$CONFIG_DIR/install_prefs"
INSTALL_DEV=false
INSTALL_COMPAT=false

# 1. Load previous state if it exists
if [ -f "$STATE_FILE" ]; then
    . "$STATE_FILE"
fi

# 2. Parse arguments (Overrides previous state)
while [ "$#" -gt 0 ]; do
  case "$1" in
    --with-dev)
      INSTALL_DEV=true
      shift
      ;;
    --skip-dev)
      INSTALL_DEV=false
      shift
      ;;
    --with-compat)
      INSTALL_COMPAT=true
      shift
      ;;
    --skip-compat)
      INSTALL_COMPAT=false
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Check privileges
if [ "$(id -u)" -ne 0 ]; then
  info "The install script must be run as root."
  exit 1
fi

# 3. Ensure config directory exists and save state
mkdir -p "$CONFIG_DIR"
cat <<EOF > "$STATE_FILE"
INSTALL_DEV=$INSTALL_DEV
INSTALL_COMPAT=$INSTALL_COMPAT
EOF

# Run modular install scripts
sh ./install/pre-install-config.sh
sh ./install/desktop-environment.sh
sh ./install/firmware.sh
sh ./install/media.sh
sh ./install/office.sh
sh ./install/security.sh
sh ./install/utilities.sh

# 4. Conditional execution based on merged state
if [ "$INSTALL_DEV" = true ]; then
    sh ./install/devops.sh
else
    info "DevOps install skipped (default or disabled)."
fi

if [ "$INSTALL_COMPAT" = true ]; then
    sh ./install/compatibility.sh
else
    info "Compatibility install skipped (default or disabled)."
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

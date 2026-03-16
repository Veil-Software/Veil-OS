#!/bin/sh
. ./helper.sh;
# VeilOS setup script
# Must be run as root on Debian minimal

set -e
set -u

# Configuration file to store state
CONFIG_DIR="/etc/veilos"
STATE_FILE="$CONFIG_DIR/install_prefs"
SKIP_DEV=false

# 1. Load previous state if it exists
if [ -f "$STATE_FILE" ]; then
    . "$STATE_FILE"
fi

# 2. Parse arguments (Overrides previous state)
while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-dev)
      SKIP_DEV=true
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
echo "SKIP_DEV=$SKIP_DEV" > "$STATE_FILE"

# Run modular install scripts
sh ./install/pre-install-config.sh
# ... (middle scripts)
sh ./install/utilities.sh

# 4. Conditional execution based on merged state
if [ "$SKIP_DEV" = false ]; then
    sh ./install/devops.sh
else
    info "DevOps install skipped (per saved preference or flag)."
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

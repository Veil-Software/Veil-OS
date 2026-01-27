#!/bin/sh
. ./helper.sh;

info "Setting up Firmware..."

info "Installing firmware-linux-free: free firmware previously included in the Linux kernel"
info "Installing firmware-linux-nonfree: non-free firmware for kernel drivers"
info "Installing firmware-iwlwifi: Intel wireless card firmware"
info "Installing firmware-intel-sound: Intel DSP sound firmware"
info "Installing firmware-realtek: Realtek wired/wireless/Bluetooth firmware"
info "Installing intel-microcode: CPU firmware updates for Intel processors"
info "Installing amd64-microcode: CPU firmware updates for AMD processors"
info "Installing linux-headers-amd64: kernel headers for building modules"
info "Installing wpasupplicant: background process that talks to Wi-Fi"
info "Installing ntfs-3g: support for NTFS format"

info "Installing audio packages: PulseAudio, PipeWire, and WirePlumber"
info "pulseaudio: classic Linux sound server"
info "pulseaudio-utils: command-line tools for PulseAudio"
info "pipewire: modern audio/video server"
info "pipewire-pulse: PulseAudio compatibility layer for PipeWire"
info "wireplumber: PipeWire session manager"

apt-get install -y --no-install-recommends \
  firmware-linux-free firmware-linux-nonfree \
  firmware-iwlwifi firmware-intel-sound firmware-realtek \
  intel-microcode amd64-microcode linux-headers-amd64 wpasupplicant \
  ntfs-3g pulseaudio pulseaudio-utils pipewire pipewire-pulse wireplumber

info "Enabling NVIDIA DRM KMS for Wayland"
if lsmod | grep -q nvidia; then
    echo "options nvidia-drm modeset=1" | tee /etc/modprobe.d/nvidia-kms.conf > /dev/null
    update-initramfs -u
fi

info "Firmware Configuration Complete!"

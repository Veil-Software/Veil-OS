# VeilOS
Tools for building VeilOS

## Installation Instructions

### Warnings
* Do **not** run this on a working system.  
* This should only be run on a **clean installation of Debian**.

---

### Install Debian
1. Download and install from the net-install ISO:  
   https://www.debian.org/CD/netinst/
2. Suggested configuration:
   - Do not set a root password
   - Guided partitioning: use the entire disk
   - Do not install any extra packages

---

### Setup
Run the following commands on your fresh Debian system:

```sh
sudo apt update
sudo apt install -y git sudo
sudo git clone https://github.com/Veil-Software/Veil-OS.git /opt/VeilOS
cd /opt/VeilOS
sudo ./setup.sh
```
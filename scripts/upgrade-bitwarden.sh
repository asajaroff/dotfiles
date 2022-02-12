# Bitwarden update script
# 
# Install or updates the bitwarden desktop client for any Linux distribution. This is posible since Bitwarden is distributed as an AppImage
# This script also handles the creation of the GNOME shell desktop icon.

# Variables
INSTALL_DIR=/opt/bitwarden

killall bitwarden

[ -d ${INSTALL_DIR} ] || mkdir ${INSTALL_DIR}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

curl -L "https://vault.bitwarden.com/download/?app=desktop&platform=linux"  -o ${INSTALL_DIR}/bitwarden-latest

chmod +x ${INSTALL_DIR}/bitwarden-latest

cat << EOF > /usr/share/applications/bitwarden.desktop
[Desktop Entry]
Name=Bitwarden
GenericName=Password manager
Comment=Password manager
Exec=/opt/bitwarden/bitwarden-latest
Icon=/opt/bitwarden/icon.png
Type=Application
Terminal=false
EOF

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
curl -L "https://raw.githubusercontent.com/bitwarden/desktop/v1.31.3/resources/icons/128x128.png" -o ${INSTALL_DIR}/icon128.png
curl -L "https://raw.githubusercontent.com/bitwarden/desktop/v1.31.3/resources/icons/256x256.png" -o ${INSTALL_DIR}/icon256.png
curl -L "https://raw.githubusercontent.com/bitwarden/desktop/v1.31.3/resources/icons/512x512.png" -o ${INSTALL_DIR}/icon512.png

chmod +x ${INSTALL_DIR}/bitwarden-latest

cat << EOF > /usr/share/applications/bitwarden.desktop
[Desktop Entry]
Name=Bitwarden
GenericName=Password manager
Comment=Password manager
Exec=/opt/bitwarden/bitwarden-latest
Icon=/opt/bitwarden/icon128.png
Type=Application
Terminal=false
EOF

curl -L https://raw.githubusercontent.com/bitwarden/desktop/master/src/images/icon.png -o /opt/bitwarden/icon.png

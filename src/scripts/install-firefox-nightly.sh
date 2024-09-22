# Firefox nightly installation script
# 
# Variables
INSTALL_DIR=/opt/firefox-nightly

[ -d ${INSTALL_DIR} ] ||  mkdir ${INSTALL_DIR}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

curl -L "https://download.mozilla.org/?product=firefox-nightly-latest-l10n-ssl&os=linux64&lang=en-US"  -o ${INSTALL_DIR}/firefox-installer.tar.bz2

tar -xvf ${INSTALL_DIR}/firefox-installer.tar.bz2 -C ${INSTALL_DIR}/

cat << EOF > /usr/share/applications/firefox-nightly.desktop
[Desktop Entry]
Name=Firefox nightly
GenericName=Nightly web browser
Comment=Browse the web
Exec=${INSTALL_DIR}/firefox/firefox-bin %u
Icon=${INSTALL_DIR}/firefox/browser/chrome/icons/default/default128.png
Type=Application
Terminal=false
EOF

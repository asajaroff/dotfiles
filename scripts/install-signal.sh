

# Firefox nightly installation script
# 
# Variables
INSTALL_DIR=/opt/signalapp

[ -d ${INSTALL_DIR} ] ||  mkdir ${INSTALL_DIR}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo git clone https://github.com/signalapp/Signal-Desktop.git /opt/signalapp/Signal-Desktop
cd ${INSTALL_DIR}/Signal-Desktop
nvm use $(cat package.json | jq .engines.node -r)

dnf install -y git-lfs install # Setup Git LFS.
npm install --global yarn      # (only if you don’t already have `yarn`)
yarn install --frozen-lockfile # Install and build dependencies (this will take a while)
yarn generate                  # Generate final JS and CSS assets
yarn build:webpack             # Build parts of the app that use webpack (Sticker Creator)
yarn build

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

# Gnome

## Create application launcher (icon)
Located at `/usr/share/applications` for global, or `~/.local/share/applications` for local user.
Create a new 
```bash

```

```Icon Template
[Desktop Entry]
Encoding=UTF-8
Name=Bitwarden
Comment=An open source password manager
Exec=/opt/Bitwarden/Bitwarden-1.30.0-x86_64.AppImage
Icon=/opt/Bitwarden/icon.png
Type=Application
Categories=Development;
Terminal=false
```

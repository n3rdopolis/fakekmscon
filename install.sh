#! /bin/bash
SCRIPTFILEPATH=$(readlink -f "$0")
SCRIPTFOLDERPATH=$(dirname "$SCRIPTFILEPATH")

cp -r "$SCRIPTFOLDERPATH"/usr/* /usr
cp -r "$SCRIPTFOLDERPATH"/etc/* /etc
systemctl enable vtty-frontend@.service
chmod +x /usr/libexec/vtty-backend
chmod +x /usr/libexec/vtty-frontend
chmod +x /usr/libexec/vtty-login
chmod +x /usr/libexec/vtty-connect
chmod +x /usr/bin/vtty-toggle


ln -s /usr/lib/systemd/system/vtty-frontend@.service /etc/systemd/system/autovt@.service


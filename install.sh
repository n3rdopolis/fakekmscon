#! /bin/bash
SCRIPTFILEPATH=$(readlink -f "$0")
SCRIPTFOLDERPATH=$(dirname "$SCRIPTFILEPATH")

cp -r "$SCRIPTFOLDERPATH"/usr/* /usr
cp -r "$SCRIPTFOLDERPATH"/etc/* /etc
systemctl enable vtty-backend@.service
systemctl enable vtty-frontend@.service
chmod +x /usr/bin/vtty-backend
chmod +x /usr/bin/vtty-frontend


ln -s /usr/lib/systemd/system/vtty-frontend@.service /etc/systemd/system/autovt@.service

systemd-sysusers

which tmux &> /dev/null
if [[ $? != 0 ]]
then
  sudo apt-get update
  sudo apt-get install tmux
fi

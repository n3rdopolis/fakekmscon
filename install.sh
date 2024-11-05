#! /bin/bash
#    Copyright (c) 2020 - 2024 nerdopolis (or n3rdopolis) <bluescreen_avenger@verzion.net>
#
#    This file is part of fakekmscon
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

SCRIPTFILEPATH=$(readlink -f "$0")
SCRIPTFOLDERPATH=$(dirname "$SCRIPTFILEPATH")

mkdir -p /usr/bin                               --context=system_u:object_r:bin_t:s0
mkdir -p /usr/lib/dracut/modules.d              --context=system_u:object_r:bin_t:s0
mkdir -p /usr/lib/systemd/system                --context=system_u:object_r:systemd_unit_file_t:s0
mkdir -p /usr/lib/sysusers.d                    --context=system_u:object_r:lib_t:s0
mkdir -p /usr/lib/udev/rules.d                  --context=system_u:object_r:lib_t:s0
mkdir -p /usr/libexec/uvtty                     --context=system_u:object_r:shell_exec_t:s0
mkdir -p /usr/libexec/vtty                      --context=system_u:object_r:shell_exec_t:s0
mkdir -p /usr/share/bash-completion/completions --context=system_u:object_r:usr_t:s0
mkdir -p /usr/share/initramfs-tools             --context=system_u:object_r:bin_t:s0
mkdir -p /usr/share/wayland-sessions            --context=system_u:object_r:usr_t:s0
mkdir -p /etc                                   --context=system_u:object_r:etc_t:s0

cp -r "$SCRIPTFOLDERPATH"/usr/bin/*                                /usr/bin                               --context=system_u:object_r:bin_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/lib/dracut/modules.d/*               /usr/lib/dracut/modules.d              --context=system_u:object_r:bin_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/lib/systemd/system/*                 /usr/lib/systemd/system                --context=system_u:object_r:systemd_unit_file_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/lib/sysusers.d/*                     /usr/lib/sysusers.d                    --context=system_u:object_r:lib_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/lib/udev/rules.d/*                   /usr/lib/udev/rules.d                  --context=system_u:object_r:lib_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/libexec/uvtty/*                      /usr/libexec/uvtty                     --context=system_u:object_r:shell_exec_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/libexec/vtty/*                       /usr/libexec/vtty                      --context=system_u:object_r:shell_exec_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/share/bash-completion/completions/*  /usr/share/bash-completion/completions --context=system_u:object_r:usr_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/share/initramfs-tools/*              /usr/share/initramfs-tools             --context=system_u:object_r:bin_t:s0
cp -r "$SCRIPTFOLDERPATH"/usr/share/wayland-sessions/*             /usr/share/wayland-sessions            --context=system_u:object_r:usr_t:s0
cp -r "$SCRIPTFOLDERPATH"/etc/*                                    /etc                                   --context=system_u:object_r:etc_t:s0

systemctl enable vtty-frontend@.service

#Enable the recinit services for systemd's recovery shells
systemctl enable recinit-rescue.service
systemctl enable recinit-emergency.service

chmod +x /usr/libexec/vtty/vtty-backend
chmod +x /usr/libexec/vtty/vtty-frontend
chmod +x /usr/libexec/vtty/vtty-be-login
chmod +x /usr/libexec/vtty/vtty-fe-connect
chmod +x /usr/bin/vtty-toggle

chmod +x /usr/libexec/uvtty/uvtty-backend
chmod +x /usr/libexec/uvtty/uvtty-frontend
chmod +x /usr/libexec/uvtty/uvtty-be-run
chmod +x /usr/libexec/uvtty/uvtty-fe-connect
chmod +x /usr/libexec/uvtty/uvtty-session
chmod +x /usr/bin/uvtty-launch

touch /usr

#ln -s /usr/lib/systemd/system/vtty-frontend@.service /etc/systemd/system/autovt@.service

#! /bin/bash
#    Copyright (c) 2020 - 2022 nerdopolis (or n3rdopolis) <bluescreen_avenger@verzion.net>
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
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

SCRIPTFILEPATH=$(readlink -f "$0")
SCRIPTFOLDERPATH=$(dirname "$SCRIPTFILEPATH")

cp -r "$SCRIPTFOLDERPATH"/usr/* /usr
cp -r "$SCRIPTFOLDERPATH"/etc/* /etc
systemctl enable vtty-frontend@.service
chmod +x /usr/libexec/vtty-backend
chmod +x /usr/libexec/vtty-frontend
chmod +x /usr/libexec/vtty-be-login
chmod +x /usr/libexec/vtty-fe-connect
chmod +x /usr/bin/vtty-toggle


ln -s /usr/lib/systemd/system/vtty-frontend@.service /etc/systemd/system/autovt@.service


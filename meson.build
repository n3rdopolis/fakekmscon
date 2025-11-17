project('fakekmscon', [],
  version: '0.0.0',
  license: 'GPLv2+',
  default_options: [],
)

install_data(
  [
    'usr/bin/recinit',
    'usr/bin/uvtty-launch',
    'usr/bin/vtty-toggle',
  ],
  install_dir: get_option('prefix') / get_option('bindir')
)

install_data(
  [
    'usr/lib/dracut/modules.d/99zz_recinit/dracut-lib-recinit-shell.sh',
    'usr/lib/dracut/modules.d/99zz_recinit/module-setup.sh',
    'usr/lib/dracut/modules.d/99zz_recinit/recinit-dracut-emergency',
  ],
  install_dir: get_option('prefix') / get_option('libdir') / 'dracut/modules.d/99zz_recinit'
)

install_data(
  [
    'usr/lib/systemd/system/recinit-emergency.service',
    'usr/lib/systemd/system/recinit-rescue.service',
  ],
  install_dir: get_option('prefix') / get_option('libdir') / 'systemd/system'
)

install_data(
  [
    'usr/lib/systemd/system/vtty-backend-seat@.service',
    'usr/lib/systemd/system/vtty-backend@.service',
    'usr/lib/systemd/system/vtty-frontend-seat@.service',
    'usr/lib/systemd/system/vtty-frontend@.service',
    'usr/lib/systemd/system/vtty-seatmanager.service',
  ],
  install_dir: get_option('prefix') / get_option('libdir') / 'systemd/system'
)

install_data(
  [
    'usr/lib/sysusers.d/vtty.conf',
  ],
  install_dir: get_option('prefix') / get_option('libdir') / 'sysusers.d'
)

install_data(
  [
    'usr/lib/udev/rules.d/72-seat-vtty.rules',
  ],
  install_dir: get_option('prefix') / get_option('libdir') / 'udev/rules.d'
)

install_data(
  [
    'usr/libexec/uvtty/uvtty-backend',
    'usr/libexec/uvtty/uvtty-be-run',
    'usr/libexec/uvtty/uvtty-fe-connect',
    'usr/libexec/uvtty/uvtty-frontend',
    'usr/libexec/uvtty/uvtty-session',
  ],
  install_dir: get_option('prefix') / get_option('libexecdir') / 'uvtty'
)

install_data(
  [
    'usr/libexec/vtty/vtty-backend',
    'usr/libexec/vtty/vtty-be-login',
    'usr/libexec/vtty/vtty-fe-connect',
    'usr/libexec/vtty/vtty-frontend',
    'usr/libexec/vtty/vtty-seatmanager',
  ],
  install_dir: get_option('prefix') / get_option('libexecdir') / 'vtty'
)

install_data(
  [
    'usr/share/bash-completion/completions/uvtty-launch',
  ],
  install_dir: get_option('prefix') / get_option('datadir') / 'bash-completion/completions'
)

install_data(
  [
    'usr/share/initramfs-tools/hooks/recinit',
  ],
  install_dir: get_option('prefix') / get_option('datadir') / 'initramfs-tools/hooks'
)

install_data(
  [
    'usr/share/initramfs-tools/scripts/override/panic',
  ],
  install_dir: get_option('prefix') / get_option('datadir') / 'initramfs-tools/scripts/override'
)

install_data(
  [
    'usr/share/wayland-sessions/fullscreenterminal.desktop',
  ],
  install_dir: get_option('prefix') / get_option('datadir') / 'wayland-sessions'
)

install_data(
  [
    'etc/footkiosk.conf',
  ],
  install_dir: get_option('sysconfdir')
)

install_data(
  [
    'etc/pam.d/vtty'
  ],
  install_dir: get_option('sysconfdir') / 'pam.d'
)

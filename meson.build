project('fakekmscon', [],
  version: '0.0.0',
  license: 'GPLv2+',
  default_options: [],
)

conf_data = configuration_data()
conf_data.set('libexecdir', get_option('libexecdir'))

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

service_files = [
  'vtty-frontend@.service', 
  'vtty-backend-seat@.service', 
  'vtty-backend@.service', 
  'vtty-frontend-seat@.service',
  'vtty-seatmanager.service',
]

foreach service_file : service_files
  configure_file(
    input: 'usr/lib/systemd/system' / service_file + '.in',
    output: service_file,
    configuration: conf_data,
    install_dir: get_option('prefix') / get_option('libdir') / 'systemd/system'
  )
endforeach

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
    'usr/libexec/uvtty/uvtty-be-run',
    'usr/libexec/uvtty/uvtty-fe-connect',
  ],
  install_dir: get_option('prefix') / get_option('libexecdir') / 'uvtty'
)

install_data(
  [
    'usr/libexec/vtty/vtty-be-login',
    'usr/libexec/vtty/vtty-fe-connect',
    'usr/libexec/vtty/vtty-seatmanager',
  ],
  install_dir: get_option('prefix') / get_option('libexecdir') / 'vtty'
)

libexec_files = [
  'uvtty/uvtty-frontend',
  'uvtty/uvtty-session',
  'uvtty/uvtty-backend',
  'vtty/vtty-frontend',
  'vtty/vtty-backend',
]

foreach libexec_file : libexec_files
  configure_file(
    input: 'usr/libexec' / libexec_file + '.in',
    output: libexec_file,
    configuration: conf_data,
    install_dir: get_option('libexecdir') / libexec_file
  )
endforeach

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

configure_file(
  input: 'usr/share/wayland-sessions/fullscreenterminal.desktop.in',
  output: 'usr/share/wayland-sessions/fullscreenterminal.desktop',
  configuration: conf_data,
  install_dir: get_option('prefix') / get_option('libdir') / 'systemd/system'
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

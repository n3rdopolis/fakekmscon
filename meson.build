project('fakekmscon', [],
  version: '0.0.0',
  license: 'GPLv2+',
  default_options: ['prefix=/usr'],
)

# Just a crude check, neither necessary nor sufficient to ensure
# a good install
if get_option('prefix') != '/usr'
  warning(
    '\n    fakekmscon was designed to be installed to a prefix of /usr. Installing to',
    '\n    other prefixes may have undesired effects such as files not being present',
    '\n    where fakekmscon or other services look for them.'
  )
endif

systemdsystemunitdir = get_option('systemdsystemunitdir')
if systemdsystemunitdir == ''
  systemd_dep = dependency('systemd', required: true)
  systemdsystemunitdir = systemd_dep.get_variable(pkgconfig: 'systemdsystemunitdir',
                                                  pkgconfig_define: ['prefix', get_option('prefix')])
endif

sysusersdir = get_option('sysusersdir')
if sysusersdir == ''
  systemd_dep = dependency('systemd', required: true)
  sysusersdir = systemd_dep.get_variable(pkgconfig: 'sysusersdir',
                                         pkgconfig_define: ['prefix', get_option('prefix')])
endif

sysusersdir = get_option('sysusersdir')
if sysusersdir == ''
  systemd_dep = dependency('systemd', required: true)
  sysusersdir = systemd_dep.get_variable(pkgconfig: 'sysusersdir',
                                         pkgconfig_define: ['prefix', get_option('prefix')])
endif

udevrulesdir = get_option('udevrulesdir')
if udevrulesdir == ''
  # systemd doesn't appear to have a variable for this in its pkgconf file?
  # prefix seems to be fine here, as systemd appears to also support rules
  # in /usr/local:
  # https://github.com/systemd/systemd/blob/main/src/basic/constants.h#L37-L52
  udevrulesdir = get_option('prefix') / 'lib/udev/rules.d'
endif

conf_data = configuration_data()
conf_data.set('libexecdir', get_option('prefix') / get_option('libexecdir'))
conf_data.set('bindir', get_option('prefix') / get_option('bindir'))
conf_data.set('sysconfdir', get_option('sysconfdir'))

if get_option('prefix') == '/usr'
  initramfs_dir = '/usr/share/initramfs-tools'
else
  # And initramfs-tools doesn't look in /usr/local either
  initramfs_dir = '/etc/initramfs-tools'
endif

bin_files = [
  'recinit',
  'uvtty-launch',
  'vtty-toggle',
]

foreach bin_file : bin_files
  configure_file(
    input: 'usr/bin' / bin_file + '.in',
    output: bin_file,
    configuration: conf_data,
    install_dir: get_option('prefix') / get_option('bindir')
  )
endforeach

dracut_files = [
  'dracut-lib-recinit-shell.sh',
  'module-setup.sh',
  'recinit-dracut-emergency',
]

foreach dracut_file : dracut_files
  configure_file(
    input: 'usr/lib/dracut/modules.d/99zz_recinit' / dracut_file + '.in',
    output: dracut_file,
    configuration: conf_data,
    # Dracut won't look elsewhere for modules
    install_dir: '/usr/lib/dracut/modules.d/99zz_recinit'
  )
endforeach

install_data(
  [
    'usr/lib/systemd/system/recinit-emergency.service',
    'usr/lib/systemd/system/recinit-rescue.service',
  ],
  install_dir: systemdsystemunitdir,
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
    install_dir: systemdsystemunitdir,
  )
endforeach

install_data(
  [
    'usr/lib/sysusers.d/vtty.conf',
  ],
  install_dir: sysusersdir
)

install_data(
  [
    'usr/lib/udev/rules.d/72-seat-vtty.rules',
  ],
  install_dir: udevrulesdir
)

uvtty_files = [
  'uvtty-frontend',
  'uvtty-session',
  'uvtty-backend',
  'uvtty-fe-connect',
  'uvtty-be-run'
]

foreach uvtty_file : uvtty_files
  configure_file(
    input: 'usr/libexec/uvtty' / uvtty_file + '.in',
    output: uvtty_file,
    configuration: conf_data,
    install_dir: get_option('prefix') / get_option('libexecdir') / 'uvtty'
  )
endforeach

vtty_files = [
  'vtty-frontend',
  'vtty-backend',
  'vtty-be-login',
  'vtty-fe-connect',
  'vtty-seatmanager',
]

foreach vtty_file : vtty_files
  configure_file(
    input: 'usr/libexec/vtty' / vtty_file + '.in',
    output: vtty_file,
    configuration: conf_data,
    install_dir: get_option('prefix') / get_option('libexecdir') / 'vtty'
  )
endforeach

install_data(
  [
    'usr/share/bash-completion/completions/uvtty-launch',
  ],
  # It might be possible for bash completions to be elsewhere...
  install_dir: get_option('prefix') / get_option('datadir') / 'bash-completion/completions'
)

configure_file(
  input: 'usr/share/initramfs-tools/hooks/recinit-session.in',
  output: 'recinit-session',
  configuration: conf_data,
  install_dir: initramfs_dir / 'hooks'
)

configure_file(
  input: 'usr/share/initramfs-tools/scripts/override/panic.in',
  output: 'panic',
  configuration: conf_data,
  install_dir: initramfs_dir / 'scripts/override'
)

configure_file(
  input: 'usr/share/wayland-sessions/fullscreenterminal.desktop.in',
  output: 'fullscreenterminal.desktop',
  configuration: conf_data,
  # Don't know if there are other places these files can be
  install_dir: '/usr/share/wayland-sessions'
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
  # PAM doesn't look anywhere else
  install_dir: '/etc/pam.d'
)

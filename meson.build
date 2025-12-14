project(
  'fakekmscon',
  version: '0.0.0',
  meson_version: '>= 1.10.0',  # for build_subdir
  license: 'GPLv2+',
  license_files: 'COPYING.txt',
)

conf_data = configuration_data()
conf_data.set('bindir', get_option('prefix') / get_option('bindir'))
conf_data.set('libexecdir', get_option('prefix') / get_option('libexecdir'))
conf_data.set('sysconfdir', get_option('prefix') / get_option('sysconfdir'))

bashcompletiondir = get_option('bashcompletiondir')
if bashcompletiondir == ''
  bash_completion_dep = dependency(
    'bash-completion',
    required: false,
  )
  if bash_completion_dep.found()
    bashcompletiondir = bash_completion_dep.get_variable(
      pkgconfig: 'completionsdir',
      pkgconfig_define: ['prefix', get_option('prefix')],
    )
  else
    bashcompletiondir = get_option('prefix') / get_option('datadir') / 'bash-completion/completions'
  endif
endif
conf_data.set('bashcompletiondir', bashcompletiondir)

systemdsystemunitdir = get_option('systemdsystemunitdir')
if systemdsystemunitdir == ''
  systemd_dep = dependency(
    'systemd',
    required: true,
  )
  systemdsystemunitdir = systemd_dep.get_variable(
    pkgconfig: 'systemdsystemunitdir',
    pkgconfig_define: ['prefix', get_option('prefix')],
  )
endif
conf_data.set('systemdsystemunitdir', systemdsystemunitdir)

sysusersdir = get_option('sysusersdir')
if sysusersdir == ''
  systemd_dep = dependency(
    'systemd',
    required: true,
  )
  sysusersdir = systemd_dep.get_variable(
    pkgconfig: 'sysusersdir',
    pkgconfig_define: ['prefix', get_option('prefix')],
  )
endif
conf_data.set('sysusersdir', sysusersdir)

udevrulesdir = get_option('udevrulesdir')
if udevrulesdir == ''
  # systemd doesn't appear to have a variable for this in its pkgconf file?
  # prefix seems to be fine here, as systemd appears to also support rules
  # in /usr/local:
  # https://github.com/systemd/systemd/blob/main/src/basic/constants.h#L37-L52
  udevrulesdir = get_option('prefix') / 'lib/udev/rules.d'
endif
conf_data.set('udevrulesdir', udevrulesdir)

dracut = get_option('dracut')
# dependency() is fine here as dracut installs a pkgconf file
# Technically, we also don't need dracut itself to be installed to be able to
# install the modules, so don't make it a hard dependency.
dracut_dep = dependency(
  'dracut',
  required: false,
)
dracut = dracut.enable_auto_if(dracut_dep.found())

if dracut.enabled()
  dracutmodulesdir = get_option('dracutmodulesdir')
  if dracutmodulesdir == '' and dracut_dep.found()
    dracutmodulesdir = dracut_dep.get_variable(
      pkgconfig: 'dracutmodulesdir',
      pkgconfig_define: ['prefix', get_option('prefix')],
    )
  endif
  if dracutmodulesdir == ''
    # dracut does NOT appear to support /usr/local/lib/dracut, hence if the
    # modules directory is not overridden don't respect prefix.
    dracutmodulesdir = '/usr/lib/dracut/modules.d'
  endif
  conf_data.set('dracutmodulesdir', dracutmodulesdir)
endif

initramfs_tools = get_option('initramfs-tools')
# initramfs-tools, or at least the debian version of it, does not appear to
# generate or install a pkgconf file of any kind. Hence, look for a handful 
# of binaries characteristic to initramfs-tools as a best guess. 
#
# (Not perfectly reliable-- for instance, update_initramfs is also the name
# of an unrelated utility by CachyOS)
update_initramfs = find_program(
  'update-initramfs',
  required: false,
)
unmkinitramfs = find_program(
  'unmkinitramfs',
  required: false
)
lsinitramfs = find_program(
  'lsinitramfs',
  required: false
)
initramfs_tools = initramfs_tools.enable_auto_if(
  update_initramfs.found() and 
  unmkinitramfs.found() and 
  lsinitramfs.found()
)

if initramfs_tools.enabled()
  initramfstoolsdir = get_option('initramfstoolsdir')
  if initramfstoolsdir == ''
    if get_option('prefix') == '/usr'
      initramfstoolsdir = '/usr/share/initramfs-tools'
    else
      # And initramfs-tools doesn't look in /usr/local either.
      initramfstoolsdir = '/etc/initramfs-tools'
    endif
  endif
  conf_data.set('initramfstoolsdir', initramfstoolsdir)
endif

mkinitcpio = get_option('mkinitcpio')
# mkinitcpio does not appear to have any associated pkgconf entries either
# so look for the two associated binaries
mkinitcpio_prog = find_program(
  'mkinitcpio',
  required: false,
)
lsinitcpio = find_program(
  'lsinitcpio',
  required: false,
)
mkinitcpio = mkinitcpio.enable_auto_if(
  mkinitcpio_prog.found() and 
  lsinitcpio.found()
)

if mkinitcpio.enabled()
  mkinitcpiodir = get_option('mkinitcpiodir')
  if mkinitcpiodir == ''
    if get_option('prefix') == '/usr'
      mkinitcpiodir = '/usr/lib/initcpio'
    else
      # And initramfs-tools doesn't look in /usr/local either.
      mkinitcpiodir = '/etc/initcpio'
    endif
  endif
  conf_data.set('mkinitcpiodir', mkinitcpiodir)
endif

waylandsessionsdir = get_option('waylandsessionsdir')
if waylandsessionsdir == ''
  # gdm iterates through XDG_DATA_DIRS (which normally contains /usr/local in
  # its search path), and sddm explicitly checks /usr/local first. Hence, we
  # may as well just respect prefix here.
  waylandsessionsdir = get_option('prefix') / 'share/wayland-sessions'
endif
conf_data.set('waylandsessionsdir', waylandsessionsdir)

pam = get_option('pam')
if pam
  pamconfdir = get_option('pamconfdir')
  if pamconfdir == ''
    pamconfdir = get_option('prefix') / 'lib/pam.d'
  endif
endif
conf_data.set('pamconfdir', pamconfdir)

bin_files = ['recinit', 'uvtty-launch', 'vtty-toggle']

foreach bin_file : bin_files
  configure_file(
    input: 'usr/bin' / bin_file + '.in',
    output: bin_file,
    configuration: conf_data,
    build_subdir: 'usr_bin/',
    install_dir: get_option('prefix') / get_option('bindir'),
  )
endforeach

if dracut.enabled()
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
      build_subdir: 'usr_lib_dracut_modules.d_99zz_recinit/',
      # Dracut won't look elsewhere for modules
      install_dir: dracutmodulesdir / '99zz_recinit',
    )
  endforeach
endif

service_files = [
  'recinit-emergency.service',
  'recinit-rescue.service',
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
    build_subdir: 'usr_lib_systemd_system',
    install_dir: systemdsystemunitdir,
  )
endforeach


systemd_target_links = [
  {
    'target': 'emergency.target.wants',
    'services': [ 'recinit-emergency' ],
  },
  {
    'target': 'rescue.target.wants',
    'services': [ 'recinit-rescue' ],
  },
]

# From Plymouth's systemd-units/meson.build
#Install the emergency/rescue service .wants files
foreach entry : systemd_target_links
  foreach service : entry['services']
    install_symlink(
      service + '.service',
      install_dir: systemdsystemunitdir / entry['target'],
      pointing_to: '..' / service + '.service',
    )
  endforeach
endforeach

install_data(
  'usr/lib/sysusers.d/vtty.conf',
  install_dir: sysusersdir,
)

install_data(
  'usr/lib/udev/rules.d/72-seat-vtty.rules',
  install_dir: udevrulesdir,
)

uvtty_files = [
  'uvtty-frontend',
  'uvtty-session',
  'uvtty-backend',
  'uvtty-fe-connect',
  'uvtty-be-run',
]

foreach uvtty_file : uvtty_files
  configure_file(
    input: 'usr/libexec/uvtty' / uvtty_file + '.in',
    output: uvtty_file,
    configuration: conf_data,
    build_subdir: 'usr_libexec_uvtty/',
    install_dir: get_option('prefix') / get_option('libexecdir') / 'uvtty',
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
    build_subdir: 'usr_libexec_vtty/',
    install_dir: get_option('prefix') / get_option('libexecdir') / 'vtty',
  )
endforeach

install_data(
  'usr/share/bash-completion/completions/uvtty-launch',
  install_dir: bashcompletiondir,
)

if initramfs_tools.enabled()
  configure_file(
    input: 'usr/share/initramfs-tools/hooks/recinit.in',
    output: 'recinit',
    configuration: conf_data,
    build_subdir: 'usr_share_initramfs-tools_hooks',
    install_dir: initramfstoolsdir / 'hooks',
  )

  configure_file(
    input: 'usr/share/initramfs-tools/scripts/override/panic.in',
    output: 'panic',
    configuration: conf_data,
    build_subdir: 'usr/share/initramfs-tools/scripts/override/',
    install_dir: initramfstoolsdir / 'scripts/override',
  )
endif

if mkinitcpio.enabled()
  install_data(
    'usr/lib/initcpio/override/init_functions_override',
    install_dir: mkinitcpiodir / 'override',
  )

  configure_file(
    input: 'usr/lib/initcpio/install/recinit.in',
    output: 'recinit',
    configuration: conf_data,
    build_subdir: 'usr_lib_initcpio/install/',
    install_dir: mkinitcpiodir / 'install',
  )
endif

configure_file(
  input: 'usr/share/wayland-sessions/fullscreenterminal.desktop.in',
  output: 'fullscreenterminal.desktop',
  configuration: conf_data,
  build_subdir: 'usr_share_wayland-sessions/',
  install_dir: waylandsessionsdir,
)

install_data(
  'etc/footkiosk.conf',
  install_dir: get_option('sysconfdir'),
)

if pam
  install_data(
    'etc/pam.d/vtty',
    install_dir: pamconfdir,
  )
endif

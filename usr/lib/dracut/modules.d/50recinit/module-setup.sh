#!/usr/bin/bash

# called by dracut
check() {
    [[ "$mount_needs" ]] && return 1
    [[ $(pkglib_dir) ]] || return 1

    require_binaries cage foot || return 1

    return 0
}

# called by dracut
depends() {
    echo drm
}

# called by dracut
install() {
    inst_multiple cage foot recinit id
    instmods evdev

    inst_rules 60-input-id.rules

    #Workaround for older versions of Cage
    cp -aZ "/bin/true" "${initdir}/usr/bin/Xwayland"

    MonospaceFontPath=$(fc-match -f %{file} monospace)
    if [ -n $MonospaceFontPath ]
    then
      MonospaceFontFolder=$(dirname "$MonospaceFontPath")
      mkdir -p "${initdir}/$MonospaceFontFolder"
      cp -aZ "$MonospaceFontPath" "${initdir}/$MonospaceFontFolder"
    fi

    BoldMonospaceFontPath=$(fc-match -f %{file} monospace:weight=bold)
    if [ -n $BoldMonospaceFont ]
    then
        BoldMonospaceFontFolder=$(dirname "$BoldMonospaceFontPath")
        mkdir -p "${initdir}/$BoldMonospaceFontFolder"
        cp -aZ "$BoldMonospaceFontPath" "${initdir}/$BoldMonospaceFontFolder"
    fi

    if [ -e /usr/lib/locale/[cC].[uU][tT][fF]*8/ ]
    then
        CUTF8DIR=$(basename $(ls -d /usr/lib/locale/[cC].[uU][tT][fF]*8))
        mkdir -p "${initdir}/usr/lib/locale/$CUTF8DIR/"
        cp -aZ "/usr/lib/locale/$CUTF8DIR/"* "${initdir}/usr/lib/locale/$CUTF8DIR/"
    fi

    if [ -e /usr/share/libinput ]
    then
        mkdir -p "${initdir}/usr/share/libinput/"
        cp -a /usr/share/libinput/* "${initdir}/usr/share/libinput/"
    fi

    if [ -e /usr/share/X11/xkb ]
    then
        mkdir -p "${initdir}/usr/share/X11/xkb/"
        mkdir -p "${initdir}/usr/share/X11/xkb/compat/"

        mkdir -p "${initdir}/usr/share/X11/xkb/keycodes/"
        mkdir -p "${initdir}/usr/share/X11/xkb/rules/"
        mkdir -p "${initdir}/usr/share/X11/xkb/symbols/"
        mkdir -p "${initdir}/usr/share/X11/xkb/types/"
        cp -Z /usr/share/X11/xkb/compat/accessx ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/basic ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/caps ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/complete ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/iso9995 ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/ledcaps ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/lednum ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/ledscroll ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/level5 ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/misc ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/mousekeys ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/compat/xfree86 ${initdir}/usr/share/X11/xkb/compat/
        cp -Z /usr/share/X11/xkb/keycodes/aliases ${initdir}/usr/share/X11/xkb/keycodes/
        cp -Z /usr/share/X11/xkb/keycodes/evdev ${initdir}/usr/share/X11/xkb/keycodes/
        cp -Z /usr/share/X11/xkb/rules/evdev ${initdir}/usr/share/X11/xkb/rules/
        find /usr/share/X11/xkb/symbols -maxdepth 1 ! -type d | while read -r file
        do
            cp -Z $file ${initdir}/usr/share/X11/xkb/symbols/
        done
        cp -Z /usr/share/X11/xkb/types/basic ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/complete ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/extra ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/iso9995 ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/level5 ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/mousekeys ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/numpad ${initdir}/usr/share/X11/xkb/types/
        cp -Z /usr/share/X11/xkb/types/pc ${initdir}/usr/share/X11/xkb/types/
    fi

    if [ -e /usr/share/X11/locale ]
    then
        mkdir -p "${initdir}/usr/share/X11/locale/"
        # In the off chance the user uses their compose key in initrd
        if [ -f "/usr/share/X11/locale/compose.dir" ]
        then
            cp -Z /usr/share/X11/locale/compose.dir ${initdir}/usr/share/X11/locale/
            grep UTF-8/Compose: /usr/share/X11/locale/compose.dir | awk -F: '{ print $1 }' | sort -u | xargs dirname | while read -r DIR
            do
                mkdir -p ${initdir}/usr/share/X11/locale/$DIR
                find /usr/share/X11/locale/$DIR -maxdepth 1 ! -type d | while read -r file
                do
                    cp -Z $file ${initdir}/usr/share/X11/locale/$DIR
                done
            done
        fi
    fi

    if [ -e /etc/footkiosk.conf ]
    then
        mkdir -p "${initdir}/etc"
        cp -Z /etc/footkiosk.conf "${initdir}/etc"
    fi
}

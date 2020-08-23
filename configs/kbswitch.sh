#!/usr/bin/env bash

# A keyboard switcher which respects Emacs.
# In order for this to work, Emacs should run as server

set -x

IS_EMACS=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) WM_CLASS | grep -c emacs`
CURRENT_LAYOUT=`setxkbmap -query | grep layout | awk '{print $2}'`
CURRENT_EMACS_LAYOUT=`emacsclient -e "(prin1 current-input-method)"`

function do_switch {
    case $1 in
	ru)
	    LAYOUT=ru
	    E_LAYOUT=russian-computer
	    ;;
	pl)
	    LAYOUT=pl
	    E_LAYOUT=polish-slash
	    ;;
	us)
	    LAYOUT=us
	    E_LAYOUT=polish-slash
	    ;;
	*)
	    :
	    ;;
    esac

    if [[ $IS_EMACS -eq 1 ]]; then
        BUFFER_NAME=`xprop -id $(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2) _NET_WM_NAME | sed 's/^_NET_WM_NAME(UTF8_STRING) = //'`
        # The " are in xprop output already
        emacsclient -e "(with-current-buffer ${BUFFER_NAME} (toggle-input-method))"
    else
	setxkbmap ${LAYOUT}
    fi
}

if [[ ${CURRENT_LAYOUT} == 'ru' ]]; then
    do_switch us
else
    do_switch ru
fi

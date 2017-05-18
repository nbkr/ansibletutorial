# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
cat <<-EOF
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
        
EOF
    fi
    esac
fi
    
# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
    function command_not_found_handle {
            # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
           /usr/bin/python /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
           /usr/bin/python /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
        else
           printf "%s: command not found\n" "$1" >&2
           return 127
        fi
    }
fi  
            
# building bash colors
C00="\[\033[0m\]"       # default color or grey
C01="\[\033[0;30m\]"    # black
C02="\[\033[1;30m\]"    # dark grey (bold)
C03="\[\033[0;31m\]"    # dark red
C04="\[\033[1;31m\]"    # red (bold)
C05="\[\033[0;32m\]"    # dark green
C06="\[\033[1;32m\]"    # green (bold)
C07="\[\033[0;33m\]"    # gold yellow
C08="\[\033[1;33m\]"    # yellow (bold)
C09="\[\033[0;34m\]"    # dark blue
C10="\[\033[1;34m\]"    # blue (bold)
C11="\[\033[0;35m\]"    # dark purple
C12="\[\033[1;35m\]"    # purple (bold)
C13="\[\033[0;36m\]"    # dark seagrean
C14="\[\033[1;36m\]"    # seagreen (bold)
C15="\[\033[0;37m\]"    # grey or regular white
C16="\[\033[1;37m\]"    # white (bold)


hostcolor="${C10}"
hostname="$(echo $HOSTNAME | cut -d . -f 1,2)"

if [ "`id -u`" -eq 0 ]; then
    PS1="[\t] ${C03}\u ${hostcolor}${hostname}${C00}:${C00}\w${C00} # "
else
    PS1="[\t] ${C05}\u ${hostcolor}${hostname}${C00}:${C00}\w${C00} \$ "
fi

export EDITOR=/usr/bin/vim

if [ -f /etc/bashrc.local ]; then
    source /etc/bashrc.local 
fi

alias git='LANG=en_US git'
alias gpg='LANG=en_US gpg'

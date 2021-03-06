# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#source /opt/ros/kinetic/setup.bash

# pwdから上にたどってROSのワークスペースを探し最初に見つかったものに設定する
function change_ws() {
    CUR=$PWD
    while [[ $CUR != $HOME ]]; do
	if [ -f "$CUR"/install_isolated/setup.bash ]; then
	    export CATKIN_WORKSPACE=$CUR
	    export USER_PACKAGE_PATH=$CATKIN_WORKSPACE/install_isolated
	    source $USER_PACKAGE_PATH/setup.bash
	    echo "ROS workspace: $CUR"
	    break
	elif [ -f "$CUR"/devel/setup.bash ]; then
	    export CATKIN_WORKSPACE=$CUR
	    export USER_PACKAGE_PATH=$CATKIN_WORKSPACE/devel
	    source $USER_PACKAGE_PATH/setup.bash
	    echo "ROS workspace: $CUR"
	    break
	fi
	CUR=`readlink -f $CUR/..`
    done
}

# source /opt/ros/kinetic/setup.bash

# tmuxで起動されたときにROSのワークスペースを設定する
if [ -n "$TMUX" ]; then
    change_ws
fi

export PATH="/usr/local/cuda-9.2/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-9.2/lib64:$LD_LIBRARY_PATH"

if [ -e "~/torch/install/bin/torch-activate" ]; then
    . /home/tajima/torch/install/bin/torch-activate
fi

# added by Miniconda2 installer
#export PATH="/home/tajima/miniconda2/bin:$PATH"

# Change prompt color for SSH connection
if [ -n "$SSH_CLIENT" ]; then
    export PS1='\u@\[\e[1;36m\]\h\[\e[m\]:\w$ '
fi


# Change ssh for TORK ssh
function tork_ssh() {
    ssh -i ~/bin/tork_aws_oregon_keypair_createdviaconsole_ubuntu1204_server_20140209.pem ubuntu@ec2-54-187-152-198.us-west-2.compute.amazonaws.com
}

# Change ssh for Kashiwa GDX ssh
function kashiwa_ssh() {
    ssh tajima@10.0.0.7
}

function tork_scp() {
    if [ $# == 1 ]; then
	echo "Need file name more than one"
	return
    fi
    # echo ${@:1:($#-1)}
    scp -i ~/bin/tork_aws_oregon_keypair_createdviaconsole_ubuntu1204_server_20140209.pem ${@:1:($#-1)} ubuntu@ec2-54-187-152-198.us-west-2.compute.amazonaws.com:${@:$#}
}

# LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# PATH
export PATH=~/bin:/usr/local/cuda/bin:$PATH

# setting for nextage1
export OMNIORB_USEHOSTNAME=192.168.128.50

# setting EDITOR
export EDITOR="emacs -nw"

# load .bashrc
test -r ~/.bashrc && . ~/.bashrc

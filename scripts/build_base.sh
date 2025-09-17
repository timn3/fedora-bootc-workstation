#!/usr/bin/sh

set -ouex pipefail

dnf group install -y \
	base-graphical \
	container-management \
	core \
	firefox \
	fonts \
	gnome-desktop \
	guest-desktop-agents \
	hardware-support \
	multimedia \
	networkmanager-submodules \
	printing \
	virtualization \
	workstation-product \
    vlc \
    --exclude=rootfiles \
	; dnf -y clean all

dnf install -y --skip-unavailable \
	bash-completion \
	bcc-tools \
	gnome-tweaks \
	htop \
	neovim \
	strace \
	tmate \
	tmux \
	vgrep \
    git \
	; dnf -y clean all

dnf install -y --skip-unavailable \
    adobe-source-code-pro-fonts \
    alacritty \
    albert \
    bat \ 
    btop \
    code \ 
    cpu-x \
    dconf \
    deja-dup \ 
    dejavu-sans-fonts \ 
    fish \ 
    fzf \ 
    gimp \  
    htop \
    keepassxc \
    neofetch \
    neovim \ 
    #nvtop \ 
    open-sans-fonts \
    openconnect \
    pinta \
    podman \
    powertop \ 
    remmina \
    ripgrep \
    solaar \ 
    syncthing \
    thefuck \ 
    thinkfan \
    thunderbird \
    tlp \ 
    tmux \ 
    zellij \
    zerotier-one \
    zoxide \ 
    zsh \
	; dnf -y clean all

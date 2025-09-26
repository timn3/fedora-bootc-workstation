ARG FEDORA_MAJOR_VERSION="latest"
ARG SOURCE_IMAGE="fedora-bootc"
# ultramarine as base
# ghcr.io/ultramarine-linux/gnome-bootc:latest

FROM scratch as ctx
COPY /scripts /scripts

FROM quay.io/fedora/${SOURCE_IMAGE}:${FEDORA_MAJOR_VERSION}

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/scripts/build_base.sh && \
    ostree container commit

# Make sure that the rootfiles package can be installed
RUN mkdir -p /var/roothome

#install rpmfusion
RUN dnf install -y \
	https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# install ultramarine repos
# RUN dnf install -y \
	# https://repos.fyralabs.com/um$(rpm -E %fedora)/ultramarine-repos-0:$(rpm -E %fedora)-1.um$(rpm -E %fedora).noarch.rpm\
	# https://repos.fyralabs.com/terra$(rpm -E %fedora)/terra-release-extras-0:$(rpm -E %fedora)-4.noarch.rpm
# 	https://repos.fyralabs.com/terra$(rpm -E %fedora)-extras \
# 	https://repos.fyralabs.com/terra$(rpm -E %fedora)-nvidia \
# 	https://repos.fyralabs.com/um$(rpm -E %fedora) \

# install vs code
RUN rpm -y --import https://packages.microsoft.com/keys/microsoft.asc
RUN echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
RUN dnf install -y code

RUN systemctl set-default graphical.target

# See https://fedoraproject.org/wiki/Changes/UnprivilegedUpdatesAtomicDesktops:
#     Avoid annoying popups when logged in.
RUN dnf install -y fedora-release-ostree-desktop \
	; dnf -y clean all

# Resize windows on super+mouse-right-click
RUN gsettings set org.gnome.desktop.wm.preferences resize-with-right-button "true"

# Install all RPMs in ./additional_rpms
RUN --mount=type=bind,source=./additional_rpms,target=/additional_rpms,Z \
	dnf -y --disablerepo='*' install --skip-unavailable /additional_rpms/*.rpm \
	; dnf -y clean all

# Final lint step to prevent easy-to-catch issues at build time
RUN bootc container lint

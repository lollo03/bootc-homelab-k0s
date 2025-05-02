FROM quay.io/fedora/fedora-bootc:42

ARG K0S_VERSION=v1.32.4+k0s.0
ARG NFS_UTILS_VERSION=2.8.2
ARG TAILSCALE_VERSION=1.82.5
ARG QEMU_GUEST_AGENT_VERSION=9.2.3

ARG HOSTNAME=k0first
ARG SSH_AUTHORIZED_KEYS

ARG TARGETARCH

# Set hostname
RUN echo "$HOSTNAME" > /etc/hostname && \
		echo "127.0.0.1	$HOSTNAME" >> /etc/hosts && \
		echo "::1		$HOSTNAME" >> /etc/hosts

# Setup SSH
RUN set -eu; mkdir -p /usr/ssh && \
    echo 'AuthorizedKeysFile /usr/ssh/%u.keys .ssh/authorized_keys .ssh/authorized_keys2' >> /etc/ssh/sshd_config.d/30-auth-system.conf && \
	echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config.d/10-no-password-auth.conf
RUN [ -z "$SSH_AUTHORIZED_KEYS" ] || echo "$SSH_AUTHORIZED_KEYS" > /usr/ssh/root.keys

# Install qemu-guest-agent
RUN dnf install -y qemu-guest-agent-$QEMU_GUEST_AGENT_VERSION && \
		dnf clean all && \
		systemctl enable qemu-guest-agent

# Install tailscale
RUN curl "https://pkgs.tailscale.com/stable/fedora/tailscale.repo" -o "/etc/yum.repos.d/tailscale.repo" && \
    dnf install -y tailscale-$TAILSCALE_VERSION && \
    dnf clean all && \
    systemctl enable tailscaled

# Install nfs-utils
RUN dnf install -y nfs-utils-$NFS_UTILS_VERSION && \
		dnf clean all

# Install other tools
RUN dnf install -y fish htop jq plocate rsync screen tcpdump tmux tree vim yq && \
		dnf clean all

# Install INDISPENSABLE tools, that NEED to be on every server
RUN dnf install -y cowsay figlet lolcat && \
		dnf clean all

# Install k9s
RUN dnf install -y "https://github.com/derailed/k9s/releases/latest/download/k9s_linux_$TARGETARCH.rpm" && \
		dnf clean all

# Set fish as default shell
RUN usermod -s /usr/bin/fish root

# Install k0s
RUN curl -sSLf https://get.k0s.sh | K0S_VERSION=$K0S_VERSION sh

# Import default k0s configuration
COPY ./config/k0s.yaml /etc/k0s/k0s.yaml
RUN yq -i ".spec.api.sans = [\"$HOSTNAME\",\"$HOSTNAME.ts.lolloandr.com\",\"$HOSTNAME.lolloandr.com\"]" /etc/k0s/k0s.yaml

# Set global environment variables
RUN echo "KUBECONFIG=/var/lib/k0s/pki/admin.conf" >> /etc/environment && \
		echo "EDITOR=vim" >> /etc/environment

# Make some paths needed by k0s writable and create useful paths
RUN mkdir -p /var/opt/cni && ln -s /var/opt/cni /opt/cni && \
		mkdir -p /var/libexec/k0s && ln -s /var/libexec/k0s /usr/libexec/k0s && \
		mkdir -p /opt/local-path-provisioner && \
		mkdir -p /var/lib/kubelet/plugins && \
		mkdir -p /var/lib/kubelet/plugins_registry

# Set up firstboot service
COPY ./config/firstboot.service /usr/local/lib/systemd/system/firstboot.service
COPY ./config/firstboot.sh /usr/local/lib/bin/firstboot.sh
RUN mkdir /etc/firstboot.d && \
		systemctl enable firstboot

RUN bootc container lint

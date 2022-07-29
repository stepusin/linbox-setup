linbox-uninstall-k3s :
	-sh /usr/local/bin/k3s-uninstall.sh

linbox-install-k3s : linbox-uninstall-k3s
	curl -sfL https://get.k3s.io \
	| INSTALL_K3S_SKIP_START=true \
		K3S_KUBECONFIG_MODE="644" \
		INSTALL_K3S_EXEC="--kubelet-arg cgroup-driver=systemd" \
		sh -s - \
	&& sudo mkdir -p /var/lib/rancher/k3s/agent/etc/containerd/ \
	&& sudo wget \
		https://k3d.io/v4.4.8/usage/guides/cuda/config.toml.tmpl \
		-O /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl \
	&& sudo systemctl start k3s \
	&& sleep 20 \
	&& kubectl create \
		-f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.12.2/nvidia-device-plugin.yml

mac-update-kube-config :
	ssh \
		steps@linbox \
		'kubectl config view --raw' \
		| sed 's/127.0.0.1/linbox/g' \
		> ~/.kube/config-linbox \
	&& chmod 600 ~/.kube/config-linbox

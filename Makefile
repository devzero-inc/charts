.PHONY: install-cert-manager
install-cert-manager:
	@helm repo add jetstack https://charts.jetstack.io
	@helm repo update jetstack
	helm upgrade --install cert-manager jetstack/cert-manager --version v1.16.2 \
		--namespace cert-manager \
		--create-namespace \
		--atomic \
		--values values/cert-manager.yaml \
		--values values/cert-manager_overrides.yaml

.PHONY: install-ingress-nginx
install-ingress-nginx:
	@helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	@helm repo update ingress-nginx
	helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --version 4.11.3 \
		--namespace ingress-nginx \
		--create-namespace \
		--atomic \
		--values values/ingress-nginx.yaml \
		--values values/ingress-nginx_overrides.yaml

.PHONY: install-rook-ceph
install-rook-ceph:
	@helm repo add rook-release https://charts.rook.io/release
	@helm repo update rook-release
	helm upgrade --install rook-ceph rook-release/rook-ceph --version v1.14.9 \
		--namespace rook-ceph \
		--create-namespace \
		--atomic \
		--values values/rook-ceph.yaml \
		--values values/rook-ceph_overrides.yaml

.PHONY: install-control-plane-crds
install-control-plane-crds: install-cert-manager install-ingress-nginx

.PHONY: install-data-plane-crds
install-data-plane-crds: install-rook-ceph

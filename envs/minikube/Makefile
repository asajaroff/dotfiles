PROFILE := een-minikube

run:
	minikube start \
		--driver='kvm2' \
		--cni='auto' \
		--cpus='4' \
		--ha=false \
		--nodes=2 \
		--addons=ingress,metrics-server,default-storageclass \
		--disk-size='50000mb' \
		--network='' \
		--kvm-network='default' \
		--dns-domain='cluster.local' \
		--listen-address=0.0.0.0 \
		--container-runtime='' \
		--kubernetes-version='1.21.14' \
		--v=7 \
		-p $(PROFILE)


get-versions:
	curl -L \
		-H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${API_TOKEN}" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		"https://api.github.com/repos/kubernetes/kubernetes/releases?per_page=100&page=3" | jq -r '.[].tag_name' | grep '1.21'

delete:
	minikube delete -p $(PROFILE)

config:
	minikube config set driver kvm2

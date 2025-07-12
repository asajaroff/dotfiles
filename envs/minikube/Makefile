PROFILE := minikube-host-network

run:
	minikube start \
		--driver='kvm2' \
		--cni='auto' \
		--cpus='4' \
		--ha=false \
		--nodes=1 \
		--network='host' \
		--listen-address=0.0.0.0 \
		--container-runtime='' \
		--kubernetes-version='1.31.3' \
		--v=5 \
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
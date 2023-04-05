#!/usr/bin/env bash
#
# Installs Jenkins into a Kubernetes cluster
# based on https://www.jenkins.io/doc/book/installing/kubernetes/
#
# Assumes your node is called "docker-desktop" in volume.yaml
#

# check that we are on the docker-desktop kube context
if [ "$(kubectl config current-context)" != "docker-desktop" ]; then
  echo "You must be on the docker-desktop context to run this script"
  exit 1
fi

kubectl create namespace devops-tools
kubectl apply -f serviceAccount.yaml
kubectl apply -f volume.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml


pod_name=$(kubectl get pods --namespace devops-tools -o json | jq --raw-output ".items[0].metadata.name")
initial_password=$(kubectl exec -ti --namespace devops-tools $pod_name -- cat /var/jenkins_home/secrets/initialAdminPassword)

kubectl get nodes -o wide
echo "navigate to host:32000 and enter password $initial_password to continue the setup."

# Mock pipeline. Doesn't actually do a deployment! :^)
#
# properties([
#   parameters([
#     string(defaultValue: 'argocd-demo/hello-kubernetes', name: 'project'),
#     string(defaultValue: '1.0.0', name: 'release'),
#     choice(choices: ['demo'], name: 'environment')
#   ])
# ])

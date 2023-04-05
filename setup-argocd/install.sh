#!/usr/bin/env bash
#
# Installs ArgoCD into a Kubernetes cluster
# based on https://argo-cd.readthedocs.io/en/stable/getting_started/
#

# check that we are on the docker-desktop kube context
if [ "$(kubectl config current-context)" != "docker-desktop" ]; then
  echo "You must be on the docker-desktop context to run this script"
  exit 1
fi

kubectl create namespace demo
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f service.yaml
initial_password=$(kubectl get secret -n argocd argocd-initial-admin-secret -o yaml | yq ".data.password|@base64d")
kubectl get nodes -o wide
echo "navigate to host:32001 and enter username admin password $initial_password to continue the setup."

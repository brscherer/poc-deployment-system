#!/usr/bin/env bash
set -euo pipefail

# 1. Start Minikube
echo "Starting Minikube..."
minikube start --driver=docker

# 2. Setup kubeconfig
echo "Updating kubeconfig..."
minikube update-context

# 3. Create namespaces
echo "Creating namespaces..."
kubectl create namespace infra || true
kubectl create namespace apps || true

# 4. Add Helm repos
echo "Adding Helm repositories..."
helm repo add jenkins https://charts.jenkins.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# 5. Install Jenkins in infra
echo "Installing Jenkins..."
helm upgrade --install jenkins jenkins/jenkins \
  --namespace infra \
  --set controller.serviceType=NodePort \
  --set controller.nodePort=32000

# 6. Install Prometheus in infra
echo "Installing Prometheus..."
helm upgrade --install prometheus prometheus-community/prometheus \
  --namespace infra

# 7. Install Grafana in infra
echo "Installing Grafana..."
helm upgrade --install grafana grafana/grafana \
  --namespace infra \
  --set adminPassword=admin \
  --set service.type=NodePort \
  --set service.nodePort=32001

# 8. Wait for all pods to be ready
echo "Waiting for infra services to be ready..."
kubectl rollout status deployment/jenkins -n infra
kubectl rollout status deployment/prometheus-server -n infra
kubectl rollout status deployment/grafana -n infra

# 9. Output URLs
echo "Jenkins URL:    $(minikube service jenkins -n infra --url)"
echo "Grafana URL:    $(minikube service grafana -n infra --url)"
echo "Prometheus UI:  $(minikube service prometheus-server -n infra --url)"

echo "✅ All setup tasks completed!"

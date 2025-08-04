#!/usr/bin/env bash
set -euo pipefail

# 1. Start Minikube
echo "Starting Minikube..."
minikube start --driver=docker

# 2. Setup kubeconfig
echo "Updating kubeconfig..."
minikube update-context

echo "Grafana URL:    $(minikube service grafana -n infra --url)"
echo "Prometheus UI:  $(minikube service prometheus-server -n infra --url)"

echo "✅ All setup tasks completed!"
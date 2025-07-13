# POC - Deployment System

Steps to run locally:

```bash
❯ colima start --cpu 4 --memory 8 # Start Colima (Docker)
❯ minikube start --driver=docker # Start Minikube
❯ minikube service jenkins -n infra --url # Start Jenkins
❯ minikube service grafana -n infra --url # Start Grafana
❯ minikube service prometheus-server -n infra --url # Start Prometheus
```

## Terraform tests

Steps to run:

```bash
tofu init
tofu validate
tofu apply -auto-approve
tofu test
```

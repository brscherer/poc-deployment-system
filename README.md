# POC - Deployment System

This project demonstrates a complete deployment system with an API server, CI/CD pipeline, infrastructure as code, and monitoring stack.

## Jenkins configuration and jobs are persistent in `/home/$USER/jenkins_home`.

## Prerequisites

- WSL2 (Ubuntu recommended)
- Docker (with Linux containers)
- Minikube (for local Kubernetes cluster)
- Terraform (or OpenTofu)
- Java 11+ (for Jenkins)

---

## 1. Start Docker and Minikube

Start Docker Desktop and then run the following command to start minikube

```bash
minikube start --driver=docker
```

---

## 2. Run Jenkins Standalone (WSL2)

1. Install Java if not present:
   ```bash
   sudo apt update
   sudo apt install openjdk-17-jdk -y
   ```
2. Create a persistent Jenkins home directory:
   ```bash
   mkdir -p /home/$USER/jenkins_home
   ```
3. Download Jenkins:
   ```bash
   wget -O /home/$USER/jenkins.war https://get.jenkins.io/war-stable/latest/jenkins.war
   ```
4. Start Jenkins:
   ```bash
   export JENKINS_HOME=/home/$USER/jenkins_home
   java -jar /home/$USER/jenkins.war
   ```
5. Access Jenkins at: http://localhost:8080

---

## 3. Infrastructure as Code (Terraform/OpenTofu)

```bash
# Initialize
tofu init
# Validate
tofu validate
# Apply infrastructure
tofu apply -auto-approve
# Run tests
tofu test
```

---

## 4. Running the API Server (Docker)

```bash
docker run --rm -p 3000:3000 brunorphl/server:latest
```

---

## 5. Accessing Services (Minikube)

```bash
# Jenkins (if deployed in cluster)
minikube service jenkins -n infra --url
# Grafana
minikube service grafana -n infra --url
# Prometheus
minikube service prometheus-server -n infra --url
```

---

## 6. CI/CD Pipeline

- The pipeline is defined in `Jenkinsfile` and will:
  - Build & test the Node.js app
  - Build and push Docker images
  - Deploy to Kubernetes via Helm
  - Verify deployment

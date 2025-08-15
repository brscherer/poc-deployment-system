# POC Deployment System

This project demonstrates a deployment system using Kubernetes, Helm, Jenkins, Prometheus, and Grafana, managed with [OpenTofu](https://opentofu.org/) (Terraform alternative).

<img width="863" height="730" alt="image" src="https://github.com/user-attachments/assets/89f3809a-76d7-43d0-9973-23d60e3318e8" />


## Namespaces Created with Tofu

OpenTofu provisions the following Kubernetes namespaces:

- **infra**: Infrastructure components (Jenkins, Prometheus, Grafana, secrets)
- **apps**: Application workloads

## Credentials Needed

The following credentials are required and managed via Kubernetes secrets:

- **GitHub Container Registry (GHCR)**
  - `ghcr_username`: GitHub username (default: `brscherer`)
  - `ghcr_token`: GitHub token (sensitive)
- **Jenkins Admin**
  - `jenkins_admin_password`: Jenkins admin password (default: `admin`, sensitive)

These are set in `infra/iac/variables.tf` and referenced in `infra/iac/secrets.tf`.

## How to Run

1. **Install Dependencies**
   - [OpenTofu](https://opentofu.org/) (or Terraform)
   - [kubectl](https://kubernetes.io/docs/tasks/tools/)
   - [Helm](https://helm.sh/)
   - [Docker](https://docs.docker.com/get-docker/)

2. **Provision the Cluster**
   ```bash
   cd infra/iac
   tofu init
   tofu apply
   ```
   This will create a Kind cluster, namespaces, secrets, and deploy Jenkins, Prometheus, and Grafana.

3. **Access Services**
   - **Grafana**:
     ```bash
     kubectl port-forward -n infra svc/grafana 3000:80
     ```
     Access at [http://localhost:3000](http://localhost:3000)
   - **Jenkins**:
     ```bash
     kubectl port-forward -n infra svc/jenkins 8081:8081
     ```
     Access at [http://localhost:8081](http://localhost:8081)
   - **Factorial Server**:
     ```bash
     kubectl port-forward -n infra svc/server 3001:3000
     ```
     Access at [http://localhost:3001](http://localhost:3001)



## Outputs

After running `tofu apply`, outputs will include:
- Cluster name
- Kubeconfig path
- Port-forward commands for Grafana and Jenkins

## Project Structure

- `apps/server`: Node.js application and Helm chart
- `infra/iac`: OpenTofu (Terraform) code for infrastructure

## Notes
- Secrets are stored as Kubernetes secrets in the `infra` namespace.
- You can customize values in `infra/iac/values/grafana-values.yaml` and `jenkins-values.yaml`.
- For more details, see the respective files in `infra/iac`.

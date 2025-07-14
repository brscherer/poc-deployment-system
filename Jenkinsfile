pipeline {
  agent { label 'jenkins-agent' }
  environment {
    IMAGE = "brunorphl/server"
    TAG   = "${env.BUILD_NUMBER}"
    DOCKER_CREDENTIALS = 'dockerhub-creds'
    KUBE_NAMESPACE = "apps"
    HELM_CHART_DIR = "apps/server/chart"
    HELM_RELEASE = "server"
  }

  stages {
    stage('Checkout') { steps { git url: 'https://github.com/brscherer/poc-deployment-system.git', branch: 'main' } }

    stage('Infra: Apply IaC') {
      steps {
        dir('infra/iac') {
          sh '''
            # Install tofu as standalone binary without sudo
            TOFU_VERSION=$(curl -s https://api.github.com/repos/opentofu/opentofu/releases/latest \
                            | grep '"tag_name"' | head -n1 | awk -F '"' '{print $4}')
            OS="$(uname | tr '[:upper:]' '[:lower:]')"
            ARCH="$(uname -m | sed -e 's/aarch64/arm64/' -e 's/x86_64/amd64/')"
            
            wget "https://github.com/opentofu/opentofu/releases/download/${TOFU_VERSION}/tofu_${TOFU_VERSION}_${OS}_${ARCH}.zip"
            unzip tofu_${TOFU_VERSION}_${OS}_${ARCH}.zip
            chmod +x tofu
            mv tofu $WORKSPACE/infra/iac/tofu
            
            # Use local binary
            ./tofu version

            ./tofu init
            ./tofu validate
            ./tofu test
            ./tofu apply -auto-approve
          '''
        }
      }
    }

    stage('Docker build & test') {
      steps {
        dir('apps/server') {
          script {
            docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS) {
              def appImage = docker.build("${IMAGE}:${TAG}")
              appImage.push()
            }
          }
        }
      }
    }

    stage('Deploy via Helm') {
      steps {
        dir(HELM_CHART_DIR) {
          sh """
            helm upgrade --install ${HELM_RELEASE} . \
              --namespace ${KUBE_NAMESPACE} \
              --set image.repository=${IMAGE} \
              --set image.tag=${TAG} \
              --wait --timeout 5m
          """
        }
      }
    }

    stage('Verify Deployment') {
      steps {
        sh """
          kubectl rollout status deployment/${HELM_RELEASE} -n ${KUBE_NAMESPACE} --timeout=2m
          kubectl wait --for=condition=ready pod \
            -l app.kubernetes.io/instance=${HELM_RELEASE} \
            -n ${KUBE_NAMESPACE} --timeout=2m
        """
      }
    }
  }

  post {
    failure {
      echo "Deployment failed — rolling back"
      sh "helm rollback ${HELM_RELEASE} 0 --namespace ${KUBE_NAMESPACE} || echo 'Nothing to rollback'"
    }
  }
}

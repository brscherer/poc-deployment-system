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
    stage('Checkout') {
      steps { git url: 'https://github.com/your-org/poc-deployment-system.git', branch: 'main' }
    }

    stage('Infra: OpenTofu Test & Apply') {
      steps {
        dir('infra/iac') {
          sh 'tofu init'
          sh 'tofu validate'
          sh 'tofu test'
          sh 'tofu apply -auto-approve'
        }
      }
    }

    stage('Build & Test') {
      steps {
        dir('apps/server') {
          script {
            docker.image('node:20-alpine').inside {
              sh 'npm ci'
              sh 'npm test'
            }
          }
        }
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        dir('apps/server') {
          script {
            docker.withRegistry('https://registry.hub.docker.com', DOCKER_CREDENTIALS) {
              def app = docker.build("${IMAGE}:${TAG}")
              app.push()
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
      echo "Pipeline failed — rolling back Helm deployment"
      sh "helm rollback ${HELM_RELEASE} 0 --namespace ${KUBE_NAMESPACE} || echo 'No previous release to rollback to.'"
    }
  }
}
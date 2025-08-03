pipeline {
  agent any
  environment {
    IMAGE = "brunorphl/server"
    TAG = "${env.BUILD_NUMBER}"
    HELM_RELEASE = "server"
    KUBE_NAMESPACE = "apps"
    KUBECONFIG = "/var/lib/jenkins/.kube/config"
  }
  tools {
    nodejs 'nodejs'
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }
    stage('Build & Test') {
      steps {
        dir('apps/server') {
          sh 'npm ci'
          sh 'npm test'
        }
      }
    }
    stage('Build & Push Docker') {
      steps {
        script {
          docker.withRegistry('https://registry.hub.docker.com','dockerhub-creds') {
            docker.build("${IMAGE}:${TAG}", 'apps/server').push()
          }
        }
      }
    }

    stage('Infra: Apply IaC (OpenTofu)') {
      steps {
        dir('infra/iac') {
          sh 'tofu init'
          sh 'tofu validate'
          sh 'tofu test'
          sh 'tofu apply --auto-approve'
        }
      }
    }


    stage('Deploy via Helm') {
      steps {
        sh """
          echo "Helm connecting via config:"
          kubectl version
          helm version --short
          helm upgrade --install ${HELM_RELEASE} ${WORKSPACE}/apps/server/chart \
            --namespace ${KUBE_NAMESPACE} \
            --set image.repository=${IMAGE} \
            --set image.tag=${TAG} \
            --wait --timeout 5m
        """
      }
    }
    stage('Verify Deployment') {
      steps {
        sh """
          kubectl rollout status deployment/${HELM_RELEASE} -n ${KUBE_NAMESPACE} --timeout=2m
          kubectl wait --for=condition=available deployment/${HELM_RELEASE} -n ${KUBE_NAMESPACE} --timeout=2m
        """
      }
    }
  }
  post {
    failure {
      echo 'Failure detected. Rolling back...'
      sh "helm rollback ${HELM_RELEASE} 0 --namespace ${KUBE_NAMESPACE} || echo 'No previous release'"
    }
  }
}

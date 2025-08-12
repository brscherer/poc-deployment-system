pipeline {
  agent any
  environment {
    IMAGE = "ghcr.io/brscherer/server"
    TAG = "${env.BUILD_NUMBER}"
    HELM_RELEASE = "server"
    KUBE_NAMESPACE = "apps"
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
    
    stage('Login to GHCR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ghcr-creds', usernameVariable: 'GHCR_USER', passwordVariable: 'GHCR_TOKEN')]) {
          sh 'echo $GHCR_TOKEN | docker login ghcr.io -u $GHCR_USER --password-stdin'
        }
      }
    }

    stage('Docker build') {
      steps {
        dir("apps/server"){
          sh "docker build -t $IMAGE:$BUILD_NUMBER ."
        }
      }
    }

    stage('Docker push') {
      steps {
        dir("apps/server"){
          sh "docker push $IMAGE:$BUILD_NUMBER "
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

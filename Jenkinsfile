pipeline {
  agent any

  environment {
    HELM_EXPERIMENTAL_OCI = '1'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/brscherer/poc-deployment-system.git', branch: 'main'
      }
    }

    stage('Run Tests') {
      steps {
        sh 'chmod +x scripts/run-tests.sh && scripts/run-tests.sh'
      }
    }

    stage('Validate Infra (OpenTofu)') {
      steps {
        dir('infra') {
          sh 'tofu fmt -check && tofu validate'
        }
      }
    }

    stage('Test Infra') {
      steps {
        dir('infra/tests') {
          sh 'go test -v infra_test.go'
        }
      }
    }

    stage('Deploy Infra') {
      steps {
        dir('infra') {
          sh 'tofu apply -auto-approve'
        }
      }
    }

    stage('Deploy Application') {
      steps {
        sh 'chmod +x scripts/deploy.sh && scripts/deploy.sh'
      }
    }
  }

  post {
    failure {
      echo 'Pipeline failed. Check logs.'
    }
    success {
      echo 'Pipeline completed successfully.'
    }
  }
}
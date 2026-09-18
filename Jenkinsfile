pipeline {
  agent any

  tools { nodejs 'node16' }

  environment {
    SCANNER_HOME = tool 'sonar-scanner'
    IMAGE = 'srikanth4658/tetris'
    TAG = "${BUILD_NUMBER}"
  }

  stages {
    stage('Clean Workspace') {
      steps { cleanWs() }
    }

    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/srikanthgram-dotcom/devsecops-tetris.git'
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv('sonar-server') {
          sh '''$SCANNER_HOME/bin/sonar-scanner \
            -Dsonar.projectKey=tetris \
            -Dsonar.projectName=tetris \
            -Dsonar.sources=.'''
        }
      }
    }

    stage('Quality Gate') {
      steps {
        timeout(time: 10, unit: 'MINUTES') {
          waitForQualityGate abortPipeline: false
        }
      }
    }

    stage('NPM Install') {
      steps { sh 'npm install' }
    }

    stage('Trivy File Scan') {
      steps { sh 'trivy fs . > trivyfs.txt' }
    }

    stage('Docker Build & Push') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
          sh 'docker build -t $IMAGE:$TAG .'
          sh 'docker push $IMAGE:$TAG'
        }
      }
    }

    stage('Trivy Image Scan') {
      steps { sh 'trivy image $IMAGE:$TAG > trivyimage.txt' }
    }

    stage('Update GitOps Manifest') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'github',
                         usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
          sh '''
            rm -rf manifest
            git clone https://$GIT_USER:$GIT_TOKEN@github.com/srikanthgram-dotcom/devsecops-Tetris-manifest.git manifest
            cd manifest
            sed -i "s|image: srikanth4658/tetris:.*|image: srikanth4658/tetris:$TAG|" deployment-service.yml
            git config user.name "srikanthgram-dotcom"
            git config user.email "srikanthgram-dotcom@users.noreply.github.com"
            git add deployment-service.yml
            git commit -m "Update tetris image to $TAG"
            git push origin main
          '''
        }
      }
    }
  }

  post {
    always { archiveArtifacts artifacts: 'trivy*.txt', allowEmptyArchive: true }
  }
}

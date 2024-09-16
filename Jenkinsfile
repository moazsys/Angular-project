pipeline {
    agent any

    tools {
        nodejs 'NodeJS 18'  // Assuming you have configured NodeJS 18 in Jenkins
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install'  // Install npm dependencies
            }
        }
        stage('Build') {
            steps {
                sh 'ng build --configuration production'  // Build the Angular app
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully.'
        }
        failure {
            echo 'Build failed. Check the logs.'
        }
    }
}

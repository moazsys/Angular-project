pipeline {
    agent any

    stages {
        stage('Install Dependencies')
      {
            steps 
        {
                sh 'npm install'
            }
        }
        
        stage('Build') {
            steps {
                sh 'ng build --configuration production'
            }
        }
       stage('Deploy')
      {
            steps 
          {
                // Ensure you have the correct credential ID here
                sshagent(['da86818e-3969-4a3a-8f59-94c1241d6bc6']) 
              {
                    sh 'scp -r dist/angular-hello-world/* moaz@4.216.187.218:/home/moaz/dep'
              }
          }
      }
        
}

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed. Check the logs.'
        }
    }
}

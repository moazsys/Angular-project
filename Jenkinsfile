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
                
                sshagent(['da86818e-3969-4a3a-8f59-94c1241d6bc6']) 
              {sh ' scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dist/angular-hello-world/* moaz@4.216.187.218:/home/moaz/dep1'
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

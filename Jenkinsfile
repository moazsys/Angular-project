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
                sh 'sudo ng build --configuration production'
            }
        }
        stage('Deploy') 
        {
            steps
            {
                script
                {
                
            
                    def remoteHost = 'moaz@4.216.187.218'
                    def remoteDir = "/home/moaz/dep"
                    sh "scp -r dist/Angular-HelloWorld/* ${remoteHost}:${remoteDir}"
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

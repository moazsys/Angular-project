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
        
        stage('Build Production') 
       {
            steps 
           {
                sh 'ng build --configuration production'
            }
        }

        stage('Build Development') 
      {
            steps 
            {
                sh 'ng build --configuration development'
            }
        }

        stage('Run Application') 
      {
            steps
         {
                script
              {
                    echo 'Starting the Angular application...'
                    sh 'ng serve  &'
                }
            }
        }

        stage('Request Permission to Deploy')
      {
            steps 
        {
                script
          {
                    def userInput = input(
                        id: 'UserInput', 
                        message: 'Do you want to deploy the application?',
                        parameters: [
                            [$class: 'ChoiceParameterDefinition', name: 'Proceed with Deployment?', choices: ['Yes', 'No'], description: 'Select Yes to proceed with deployment.']
                        ]
                    )

                    if (userInput == 'No') {
                        error("Deployment cancelled by the user.")
                    }
                }
            }
        }

        stage('Deploy')
      {
            steps {
                sshagent(['da86818e-3969-4a3a-8f59-94c1241d6bc6']) {
                    sh 'scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null dist/angular-hello-world/* moaz@4.216.187.218:/home/moaz/dep1'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        
                mail to: 'sheikhmoaz03@gmail.com',
                subject: "SUCCESS",
                body: "The deployment was successful!"
            
        }
        failure {
            echo 'Deployment failed. Check the logs.'
            
                mail to: 'sheikhmoaz03@gmail.com',
                subject: "FAILURE",
                body: "The deployment has failed. Please check the logs."
            
        }
    }
}

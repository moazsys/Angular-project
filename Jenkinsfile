pipeline {
    agent any

    environment {
        VERSION = '2.0.0'
        NEXUS_URL = 'http://4.216.187.218:8081'
        REPOSITORY = 'angular'
        USERNAME = 'admin'
        PASSWORD = 'Moaz@2003'
        ARTIFACT_NAME = 'Angular'
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/moazsys/Angular-project.git'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Production') {
            steps {
                sh 'ng build --configuration production'
            }
        }

        stage('Build Development') {
            steps {
                sh 'ng build --configuration development'
            }
        }

        stage('Run Application') {
            steps {
                script {
                    echo 'Starting the Angular application...'
                    sh 'ng serve &'
                }
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    sh 'chmod +x script2.sh'
                    sh './script2.sh'
                }
            }
        }

        stage('List All Versions from Nexus') {
            steps {
                script {
                    def rawResponse = sh(script: """
                        curl -u ${USERNAME}:${PASSWORD} -X GET '${NEXUS_URL}/service/rest/v1/search?repository=${REPOSITORY}&name=${ARTIFACT_NAME}'
                    """, returnStdout: true).trim()
                    
                    echo "Raw Nexus JSON Response: ${rawResponse}"

                    def versions = sh(script: """
                        echo '${rawResponse}' | jq -r '.items[].version'
                    """, returnStdout: true).trim().split("\n")

                    if (versions) {
                        echo "Available Versions:\n${versions.join('\n')}"
                        env.AVAILABLE_VERSIONS = versions.join(",")
                    } else {
                        error "No versions found in Nexus repository."
                    }
                }
            }
        }

        stage('Request Version for Deployment') {
            steps {
                script {
                    def userInput = input(
                        id: 'UserInput',
                        message: 'Do you want to proceed with the version ${env.VERSION} or specify another?',
                        parameters: [
                            [$class: 'ChoiceParameterDefinition', 
                             name: 'Select Version', 
                             choices: env.AVAILABLE_VERSIONS.split(',').toList(), 
                             description: 'Choose the version to download'
                            ]
                        ]
                    )

                    env.SELECTED_VERSION = userInput
                    echo "Selected version for download: ${env.SELECTED_VERSION}"
                }
            }
        }

        stage('Download Selected Version') {
            steps {
                script {
                    sh "wget --user=${env.USERNAME} --password='${env.PASSWORD}' '${env.NEXUS_URL}/repository/${env.REPOSITORY}/${env.ARTIFACT_NAME}/-/Angular-${env.SELECTED_VERSION}.tgz'"
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['0de6bf58-362e-40e1-90b7-cd7ce2c4487a']) {
                    sh "scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null Angular-${env.SELECTED_VERSION}.tgz moaz@4.216.187.218:/home/moaz/dep1"
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

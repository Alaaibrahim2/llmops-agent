pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'LLMOPS'
        SONAR_SCANNER_HOME = tool 'Sonarqube'
        AWS_REGION = 'eu-north-1'
        ECR_REPO = 'myrepo'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clone GitHub Repo') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'main',
                    url: 'https://github.com/Alaaibrahim2/llmops-agent.git',
                    credentialsId: 'github-token'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('Sonarqube') {
                        sh '''
                        $SONAR_SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectKey=$SONAR_PROJECT_KEY \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://sonarqube:9000 \
                        -Dsonar.token=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }
         stage('Build and Push Docker Image to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-token']]) {
                    script {
                        def accountId = sh(script: "aws sts get-caller-identity --query Account --output text", returnStdout: true).trim()
                        def ecrUrl = "${accountId}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${env.ECR_REPO}"

                        sh """
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ecrUrl}
                        docker build -t ${env.ECR_REPO}:${IMAGE_TAG} .
                        docker tag ${env.ECR_REPO}:${IMAGE_TAG} ${ecrUrl}:${IMAGE_TAG}
                        docker push ${ecrUrl}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }
    }
}

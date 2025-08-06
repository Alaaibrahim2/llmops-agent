pipeline {
    agent any

    environment {
        SONAR_PROJECT_KEY = 'LLMOPS'
        SONAR_SCANNER_HOME = tool 'Sonarqube'
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
    }
}

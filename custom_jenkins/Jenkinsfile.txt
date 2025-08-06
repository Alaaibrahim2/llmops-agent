pipeline {
    agent any
    stages {
        stage('Clone GitHub Repo') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'main',
                    url: 'https://github.com/Alaaibrahim2/llmops-agent.git',
                    credentialsId: 'github-token'
            }
        }
    }
}

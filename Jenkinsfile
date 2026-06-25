pipeline {

    agent any

    environment {
        DOCKER_USER = credentials('DOCKER_USER')
        DOCKER_PASS = credentials('DOCKER_PASS')
        SONAR_TOKEN = credentials('SONAR_TOKEN')
    }

    parameters {
        booleanParam(
            name: 'DESTROY',
            defaultValue: false,
            description: 'Destroy Terraform resources'
        )
    }

    stages {

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('SonarQube Scan') {

    steps {

        sh '''
        /opt/sonar-scanner/bin/sonar-scanner \
        -Dsonar.projectKey=fintech-app \
        -Dsonar.sources=. \
        -Dsonar.host.url=http://host.docker.internal:9000 \
        -Dsonar.token=$SONAR_TOKEN
        '''

    }


}

        stage('Terraform Apply') {

            when {
                expression { !params.DESTROY }
            }

            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Frontend Build') {

            steps {

                sh '''
                cd fintech-app/frontend

                if [ -f package.json ]; then
                  npm install
                  npm run build
                fi
                '''

            }

        }

        stage('Backend Build') {

            steps {

                sh '''
                cd fintech-app/backend

                if [ -f package.json ]; then
                  npm install
                fi
                '''

            }

        }

        stage('Docker Build') {

            steps {

                sh '''
                cd fintech-app/frontend

                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin

                docker build -t muthuraja25/fintech-frontend:latest .

                docker push muthuraja25/fintech-frontend:latest
                '''

            }

        }

        stage('Deploy ECS Fargate') {

            steps {
                sh 'terraform apply -auto-approve'
            }

        }

        stage('Terraform Destroy') {

            when {
                expression { params.DESTROY }
            }

            steps {
                sh 'terraform destroy -auto-approve'
            }

        }

    }

}
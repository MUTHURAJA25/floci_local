pipeline {

agent any

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

docker build -t muthuraja25/fintech-frontend:latest .

docker push muthuraja25/fintech-frontend:latest
'''
}
}

}

stage('Deploy ECS Fargate') {

when {
expression { !params.DESTROY }
}

steps {

sh '''
terraform apply -auto-approve
'''

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


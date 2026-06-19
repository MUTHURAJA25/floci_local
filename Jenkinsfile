pipeline {

agent any

parameters {

booleanParam(
name: 'DESTROY',
defaultValue: true,
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

stage('Build') {

steps {

sh '''
cd fintech-app

if [ -d backend ]; then
echo "Backend Build"
fi

if [ -d frontend ]; then
echo "Frontend Build"
fi
'''

}

}

stage('Push') {

steps {

sh '''
echo "Push stage completed"
'''

}

}

stage('Deploy') {

steps {

sh '''
echo "Deploy stage completed"
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

}
pipeline {

agent any

stages {

stage('Terraform Init') {

steps {
sh 'terraform init'
}

}

stage('Terraform Apply') {

steps {
sh 'terraform apply -auto-approve'
}

}

stage('Terraform Destroy') {

when {
expression {
return params.DESTROY
}
}

steps {
sh 'terraform destroy -auto-approve'
}

}

}

parameters {

booleanParam(
name: 'DESTROY',
defaultValue: true,
description: 'Destroy Terraform resources'
)

}

}
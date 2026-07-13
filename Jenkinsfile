pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'open-tele-eks'
    }

    stages {
        stage('Configure Kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]) {
                    script {
                        sh '''
                            aws eks update-kubeconfig \
                                --region $AWS_REGION \
                                --name $CLUSTER_NAME
                        '''
                    }
                }
            }
        }

        stage('eks-deploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws']]){
                script {
                    echo "Deploying to EKS"
                    sh '''
                        cd ultimate-devops-project-demo/kubernetes/
                        kubectl apply -f complete-deploy.yaml
                    '''
                }
            }
            }
        }
    }
}

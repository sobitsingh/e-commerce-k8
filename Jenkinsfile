pipeline{
    agent any
    environment{
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'open-tele-eks'
    }
    stages{
        stage("Git checkout"){
            steps{
                script{
                    echo "Git checkout"
                    sh "git clone https://github.com/sobitsingh/e-commerce-k8.git"
                }
            }
        }
         stage('Configure Kubeconfig') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'aws-credentials-id']]) {
                    sh '''
                        aws eks update-kubeconfig \
                            --region $AWS_REGION \
                            --name $CLUSTER_NAME
                    '''
                }
            }
        stage('eks-deploy'){
            steps{
                script{
                    echo "Deploying to eks"
                    sh """
                        cd ultimate-devops-project-demo/kubernetes/
                        kubectl apply -f complete-deploy.yaml
                    """
                }
            }
        }
    }
}
}

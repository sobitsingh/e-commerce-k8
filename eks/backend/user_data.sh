# Description: This script is used to install docker and docker compose on EC2 instance
sudo apt-get update -y
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker ubuntu

docker --version
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.34.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version

# Install kubectl
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --short --client

# Install terraform
sudo apt-get install -y unzip
curl -o terraform.zip https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/
terraform --version

#Install Java
sudo apt-get install -y openjdk-21-jre-headless
export ENV JAVA_HOME=/opt/java/openjdk

# Install Pip
sudo apt-get install -y python3-full
sudo apt-get install -y cloud-guest-utils

# Install git
sudo apt-get install -y git
git clone https://github.com/sobitsingh/e-commerce-k8.git

# Install aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Running application
cd ultimate-devops-project-demo
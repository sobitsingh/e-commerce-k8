#!/bin/bash
# This script is to update the kube-config file for the EKS cluster and set up ingress AWS ALB controller

set -e  # Exit immediately if a command exits with a non-zero status

# Install helm and eksctl
sudo apt-get update -y
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install eksctl
export PLATFORM="amd64"
echo "Downloading eksctl for platform: $PLATFORM"
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${PLATFORM}.tar.gz"
tar -xzf eksctl_Linux_${PLATFORM}.tar.gz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
rm eksctl_Linux_${PLATFORM}.tar.gz
eksctl version

# Update kube-config
aws eks --region us-east-1 update-kubeconfig --name open-tele-eks

# Set up ingress AWS ALB controller
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.12.0/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=open-tele-eks --approve
eksctl create iamserviceaccount \
    --cluster=open-tele-eks \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
    --override-existing-serviceaccounts \
    --region us-east-1 \
    --approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=open-tele-eks \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-0b19d5ddcc044cdd5

kubectl get deployment -n kube-system aws-load-balancer-controller
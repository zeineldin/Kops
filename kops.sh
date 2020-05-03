#!/bin/bash
set -x
echo "Please enter your AWS bucket name. ex: k8s-kops-berlin-zeineldin"
read KOPS_STATE_STORE

echo "Please enter your k8s cluster name. ex: cluster.k8s.local"
read KOPS_CLUSTER_NAME

# 1.install kubectl  -> https://kubernetes.io/docs/tasks/tools/install-kubectl/

## curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

##s udo chmod +x ./kubectl
## sudo mv ./kubectl /usr/local/bin/kubectl

# 2.install Kops -> https://kubernetes.io/docs/setup/production-environment/tools/kops/

## curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64

## sudo chmod +x ./kops

## sudo mv ./kops /usr/local/bin/

# 3. install AWS CLI -> https://docs.aws.amazon.com/cli/latest/userguide/install-linux-al2017.html

## apt-get update

## install -y awscli

## Then do as the following  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

# 4. configure the awscli using your AWS account "you could create free account"

##aws configure

##   Note : the AWS user must have adminstration permission

## 5. create new S3 bucket to save your KOPS state  "it has to be at the same KOPS region"

## A. make sure that it works "ex: bucket name k8s-kops-berlin-zeineldin"

##	 aws s3 mb s3://k8s-kops-berlin-zeineldin
aws s3 mb s3://${KOPS_STATE_STORE}

#B. Enable bucker versioning

aws s3api put-bucket-versioning --bucket ${KOPS_STATE_STORE} --versioning-configuration Status=Enabled

#C. Expose ENV  "to save the state of the Cluster"

#	export KOPS_STATE_STORE=s3://k8s-kops-berlin-zeineldin
export KOPS_STATE_STORE="s3://$KOPS_STATE_STORE"

sleep 10

# 6. Create DNS Configurations

# kubernetes uses DNS for discovery inside the cluster so that you can reach out kubernetes API server from clients.
# create a hosted zone on Route53, say, k8s.devops.vpc. The API server endpoint will then be ex:berlin.k8s.local as (Gossip DNS)

# 7. Create ssh public and private keys

##ssh-keygen

# it will be created in the default location which is ~/.ssh/id_rsa.pub

#8. export cluster and bucket name

export KOPS_CLUSTER_NAME=$KOPS_CLUSTER_NAME

#9. create KOPS Cluster

##kops create cluster --name=${KOPS_CLUSTER_NAME} --ssh-public-key="~/.ssh/id_rsa.pub" --state=${KOPS_STATE_STORE} --zones=eu-west-1a --master-size=t2.micro --node-count=2 --node-size=t2.micro --yes


#Note : if you don't have DNS configuration you could just use gossip based DNS   "ie: zein.cluster.k8s.local""

kops create cluster --name=${KOPS_CLUSTER_NAME} --ssh-public-key="~/.ssh/id_rsa.pub" --state=${KOPS_STATE_STORE} --zones=eu-west-1a --master-size=t2.micro --node-count=2 --node-size=t2.micro  --topology=private --networking=calico --yes

sleep 10
# 10. You could edit in the cluster "optional"

## kops edit cluster --name ${KOPS_CLUSTER_NAME}

# 11. Run the Cluster

## kops update cluster --name ${KOPS_CLUSTER_NAME} --yes

# 12. Make Sure that every thing works

## kops validate cluster

# 13. login to the master server and check the cluster

## ssh -i ~/.ssh/id_rsa admin@<Mater_Node_IP>

# 14. Create the 1st deployment

## kubectl run webserver --image=nginx --port= 80 -- replicas=2

# 15. Export the deployment

## kubectl expose deployment webserver --name web-service --type=LoadBalancer --port=80

# 16. check the service

## kubectl get service

# check the port

# 17. Open the port in the KOPS Cluster Security group

# 18. SEE THE SERVICE FROM THE URL:PORT

# 19. delete the culster if you want :)

## kops delete cluster --name ${CLUSTER_NAME} --yes

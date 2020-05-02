## Install and confiure KOPS on Ubunut 18 

1. install kubectl 
https://kubernetes.io/docs/tasks/tools/install-kubectl/

	```curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl```
	
	
	```curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl```
	```chmod +x ./kubectl```

	```sudo apt-get update```

	```sudo apt-get install -y kubectl```


2. install Kops
https://github.com/kubernetes/kops/
https://github.com/kubernetes/kops/releases

	```curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-darwin-amd64
```

	```chmod +x kops-linux-amd64```

	```mv kops-linux-amd64 /usr/local/bin/kops```


3. install AWS CLI

	```apt-get install -y awscli``` 

4. configure the awscli using your AWS account "you could create free account"

	``` aws configure```

   Note : the AWS user must have adminstration permission 

5. create new S3 bucket to save your KOPS state  "it has to be at the same KOPS region"

make sure that it works "ex: bucket name clusters.k8s.devops.vpc"
	
	    aws s3 mb s3://k8s-kops-berlin-zeineldin
	   
Enable bucker versioning 

	aws s3api put-bucket-versioning --bucket clusters.k8s.devops.vpc --versioning-configuration Status=Enabled

Expose ENV  "to save the state of the Cluster"

	    export KOPS_STATE_STORE=s3://k8s-kops-berlin-zeineldin


6. Create DNS Configurations

kubernetes uses DNS for discovery inside the cluster so that you can reach out kubernetes API server from clients.
create a hosted zone on Route53, say, k8s.devops.vpc. The API server endpoint will then be ex:berlin.k8s.local as (Gossip DNS)

7. Create ssh public and private keys

	```ssh-keyget```

it will be created in the default location which is ~/.ssh/id_rsa.pub

8. export cluster and bucket name 

```export KOPS_CLUSTER_NAME=berlin.k8s.local ```

9. create KOPS Cluster 

	 ```kops create cluster --name=${KOPS_CLUSTER_NAME} --ssh-public-key="~/.ssh/id_rsa.pub" --state=s3://k8s-kops-berlin-zeineldin --zones=eu-west-1a --master-size=t2.micro --node-count=2 --node-size=t2.micro```


Note : if you don't have DNS configuration you could just use gossip based DNS   "ie: zein.cluster.k8s.local""

	kops create cluster --name=${KOPS_CLUSTER_NAME} --ssh-public-key="~/.ssh/id_rsa.pub" --state=s3://k8s-kops-berlin-zeineldin --zones=eu-west-1a --master-size=t2.micro --node-count=2 --node-size=t2.micro  --topology=private --networking=calico
	

10. You could edit in the cluster 

	```kops edit cluster --name ${KOPS_CLUSTER_NAME}```

11. Run the Cluster

	``` kops update cluster --name ${KOPS_CLUSTER_NAME} --yes```

12. Make Sure that every thing works 

	```kops validate cluster```

13. login to the master server and check the cluster 

	```ssh -i ~/.ssh/id_rsa admin@<Mater_Node_IP>```

14. Create the 1st deployment

	```kubectl run webserver --image=nginx --port= 80 -- replicas=2```

15. Export the deployment

	```kubectl expose deployment webserver --name web-service --type=LoadBalancer --port=80```


16. check the service

	```kubectl get service```  

check the port 


17. Open the port in the KOPS Cluster Security group


18. SEE THE SERVICE FROM THE URL:PORT


19. delete the culster if you want :) 

	```kops delete cluster --name ${CLUSTER_NAME} --yes```

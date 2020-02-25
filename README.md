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

	```wget https://github.com/kubernetes/kops/releases/download/1.11.0/kops-linux-amd64```

	```chmod +x kops-linux-amd64```

	```mv kops-linux-amd64 /usr/local/bin/kops```

3. install python-pip

	``` apt-get install pyhon-pip```

4. install AWS CLI

	```pip install -y awscli``` 

5. configure the awscli using your AWS account "you could create free account"

	``` aws configure```

   Note : the AWS user must have adminstration permission 

6. create new S3 bucket to save your KOPS state  "it has to be at the same KOPS region"

make sure that it works "ex: bucket name clusters.k8s.devops.vpc"
	
	    aws s3 mb s3://clusters.k8s.devops.vpc
	   
Enable bucker versioning 

	aws s3api put-bucket-versioning --bucket clusters.k8s.devops.vpc --versioning-configuration Status=Enabled

Expose ENV  "to save the state of the Cluster"

	    export KOPS_STATE_STORE=s3://clusters.k8s.devops.vpc


7. Create DNS Configurations

kubernetes uses DNS for discovery inside the cluster so that you can reach out kubernetes API server from clients.
create a hosted zone on Route53, say, k8s.devops.vpc. The API server endpoint will then be ex:api.k8s.devops.vpc

8. Create ssh public and private keys

	```ssh-keyget```

it will be created in the default location which is ~/.ssh/id_rsa.pub

9. create KOPS Cluster 

	 ```kops create cluster --name=zein.k8s.local --ssh-public-key="~/.ssh/id_rsa.pub" --state=s3://zain.k8s.devops.vpc --zones=eu-west-1a --master-size=t2.micro --node-count=2 --node-size=t2.micro --dns-zone=zain.k8s.devops.vpc```


Note : if you don't have DNS configuration you could just use gossip based DNS   "ie: zein.cluster.k8s.local""

	kops create cluster --zones=eu-west-1a,eu-west-1b,eu-west-1c --name=zein.cluster.k8s.local --ssh-public-key="~/.ssh/id_rsa.pub" --state=s3://zein.cluster.k8s.local  --master-count=3 --master-size=t2.micro --node-count=3 --node-size=t2.micro eu-west-1c --topology=private --networking=calico
	

10. You could edit in the cluster 

	```kops edit cluster ${Cluster_NAME}```

11. Run the Cluster

	``` kops update cluster test-kops --yes --state=s3://clusters.k8s.devops.vpc```

12. Make Sure that every thing works 

	```kops validate cluster```

13. login to the master server and check the cluster 

	```ssh -i ~/.ssh/id_rsa admin@api.zein.cluster.k8s.local```

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

## Install and confiure KOPS on Ubunut 18 

1. install kubectl 
https://kubernetes.io/docs/tasks/tools/install-kubectl/

	```sudo apt-get update && sudo apt-get install -y apt-transport-https```
	
	```curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -```
	
	```echo “deb https://apt.kubernetes.io/ kubernetes-xenial main” | sudo tee -a /etc/apt/sources.list.d/kubernetes.list```
	
	```sudo apt-get update```

	```sudo apt-get install -y kubectl```


2. install Kops
https://github.com/kubernetes/kops/
https://github.com/kubernetes/kops/releases

	```wget https://github.com/kubernetes/kops/releases/download/1.11.0/kops-linux-amd64````

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

7. create KOPS Cluster 

``` kops create cluster --zones=eu-west-1a,eu-west-1b,eu-west-1c --topology=private --networking=calico --master-size=t2.micro --master-count=3 --node-size=t2.micro --name ${KOPS_CLUSTER_NAME}```

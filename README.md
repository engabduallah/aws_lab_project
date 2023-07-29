
# Tradition Asia AWS Devops Assignment 

This is a gaudiness file to show you how to run the Terraform module along with all the tools used. 


## Authors

- Abduallah Damash - github: [@engabduallah](https://github.com/engabduallah)


## Deployment

To deploy this project run the following commands: 

NOTE: the OS used is ubuntu with bash console.

Open the terminal and run the aws configure command to configure default credentials.
```bash
aws configure
```
With this, we have successfully set up our environment to begin working with Terraform and AWS.

### Installation of TFlint (optional):
TFlint is a static analysis and linting tool for Terraform configurations, helping developers identify issues and enforce best practices in their infrastructure-as-code projects.

```bash
# Install the 'unzip' package, which is required for extracting files from zip archives.
sudo apt install unzip

# Download and install TFlint for Linux using its installation script.
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```
### Installation of Terrascan (optional):
Terrascan is a security-focused scanner that evaluates Terraform code, pinpointing security vulnerabilities and compliance violations to enhance the overall security of cloud infrastructure deployments.

```bash
# Download the latest release of Terrascan for Linux.
curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz

# Extract the downloaded archive and remove the compressed file.
tar -xf terrascan.tar.gz terrascan && rm terrascan.tar.gz

# Install Terrascan by moving the binary to /usr/local/bin/ and remove the downloaded binary.
sudo install terrascan /usr/local/bin && rm terrascan
```
### Full Script Deployment:
```bash
# (Only Once) Automatically format the Terraform configuration files (*.tf) in the current directory.
terraform fmt 

# (Only Once) Initialize a new or existing Terraform configuration.
terraform init -var-file=variables-test.tfvars

# (Only Once) Download any modules referenced in the Terraform configuration.
terraform get

# Check the configuration files for syntax errors and other issues.
terraform validate

# (optional) Lint the Terraform configurations for best practices, errors, and style issues.
tflint --var-file=variables-test.tfvars

# (optional) Run a security-focused scan on the Terraform code in the current directory.
terrascan scan -t aws -i terraform

# Create an execution plan for the changes in the Terraform configuration.
terraform plan -var-file=variables-test.tfvars

# Apply the changes defined in the Terraform configuration to the infrastructure.
terraform apply -var-file=variables-test.tfvars
```
After you finish deployment, you can destroy all resource using the following:
```bash
terraform destroy -var-file=variables-test.tfvars
```
## Appendix

Please find the scripts used for:

1-Apache HTTP Server.

2-Nginx container.


### Apache HTTP Server

Apache HTTP Server, often simply referred to as Apache, is a popular open-source web server software that is widely used to serve web content over the internet. It is known for its reliability, performance, and flexibility, making it one of the most commonly used web servers worldwide.

In the same directory with `.tf` files, `userdata.sh` is the cloud-init script that installs Apache on the instances.

```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "Hello from Terraform" > /var/www/html/index.html
```
### Installation of Nginx container
First you need to run the following command to retrieve the access credentials for your cluster and configure kubectl.
```bash
aws eks --region $(terraform output -raw region) update-kubeconfig \
--name $(terraform output -raw cluster_name)
```
You can now use `kubectl` to manage your cluster and deploy Kubernetes configurations to it.
Verify your cluster configuration.

First, get information about the cluster and verify that all three worker nodes are part of the cluster.
```bash
kubectl cluster-info

kubectl get nodes
```

Now, To deploy Nginx container to the cluster using `kubectl`. Run:

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

This will create a deployment and a service for Nginx. After a while, the URL of the service with can be given by running:

```bash
kubectl get service nginx
```
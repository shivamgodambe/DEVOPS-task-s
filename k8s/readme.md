# MINIKUBE INSTALLATION

Minikube is a tool that lets you run Kubernetes locally on your machine. It creates a single-node Kubernetes cluster, ideal for development and testing purposes.

## Prerequisites
Virtualization: Ensure your system supports virtualization. You can verify this by running:


        grep -E --color 'vmx|svm' /proc/cpuinfo
If the command returns results, your system supports virtualization.

Install Docker: You can either use Docker, KVM, VirtualBox, or Hyperkit as the driver for Minikube. Below are the installation steps for Docker (as it's the most common driver):


        sudo apt update
        sudo apt install docker.io -y
        sudo usermod -aG docker $USER
After this, log out and log back in for the changes to take effect.

Step-by-Step Installation
1. Install Minikube
For Linux:
Run the following commands to install Minikube:


        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
2. Start Minikube
To start a Kubernetes cluster, you can specify the driver (Docker in this case):


        minikube start --driver=docker
This command will download and start a local Kubernetes cluster using the Docker driver.

3. Verify Installation
To verify that Minikube is running:


        minikube status
It should show that host, kubelet, and apiserver are running.

4. Install kubectl
kubectl is the command-line tool that interacts with your Minikube cluster. Install it using the following command:


        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
Check the installation:


        kubectl version --client
5. Deploy a Sample Application
Now that Minikube is running, you can deploy a sample application to test the setup.

Create a deployment using NGINX:


        kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.4
Expose the deployment as a service:


        kubectl expose deployment hello-minikube --type=NodePort --port=8080
6. Access the Application
To access the service:


        minikube service hello-minikube


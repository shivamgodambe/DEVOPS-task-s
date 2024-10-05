#  STUDENT APP USING DOCKER

Steps:

1. Create an EC2 Instance

2. Login to the instance using SSH:

        ssh -i keyname username@public_ip

4. Clone the GitHub repository with the project:

       git clone https://github.com/rajatpzade/CDECB39-Demo.git

6. Start Docker

7. Activate Docker by running the docker.sh file:
          
          chmod o+x docker.sh
          ./docker.sh
8. Database Setup:

Navigate to the DB directory and give execution permission to the Dockerfile.
Build and run the database container:

      docker build -t students-db .
      docker run -d -p 3306:3306 --name students-db students-db
9. Backend Setup:

Navigate to the BE (backend) directory, and do the same steps as for the database.
Build and run the backend container, linking it to the database:

      docker build -t students-backend .
      docker run -d -p 8080:8080 --name students-backend --link students-db students-backend
10. Frontend Setup:

Navigate to the FE (frontend) directory, modify index.html to include the public IP.
Build and run the frontend container:
  
      docker build -t students-frontend .
      docker run -d -p 80:80 --name students-frontend students-frontend
Access the Application:

Access the application by hitting the public IP on a web browser to interact with the student app and add data.

# ANGULER JAVA PROJECT USING DOCKER
This project demonstrates how to set up an Angular frontend and Java backend using Docker. It also involves setting up a MariaDB database and connecting the application to an RDS instance.

## Prerequisites
1.An AWS EC2 instance (Ubuntu)
2.SSH access to the instance
3.Docker installed on the EC2 instance
4.An RDS instance for the database
5.Git installed on the EC2 instance

Steps to Set Up the Project
1. Create an EC2 Instance and SSH into it
Log in to your EC2 instance using SSH:

           ssh -i key.pem username@<public-ip>
2. Clone the Project Repository
Clone the repository from GitHub:
        
        git clone https://github.com/rajatpzade/anguler-java.git
4. Install MariaDB
Install MariaDB on your EC2 instance:

        sudo apt update
        sudo apt install mariadb-server -y
4. Connect to the RDS Instance
Log into your RDS database using the provided endpoint and credentials:

        mysql -h <database-endpoint> -u <username> -p<password>
5. Create the Database
Once logged in, create a database and set privileges:

       CREATE DATABASE springbackend;
       GRANT ALL PRIVILEGES ON springbackend.* TO '<username>'@'%' IDENTIFIED BY '<password>';
       FLUSH PRIVILEGES;

                                                                        
6. Populate the Database
Load the provided data into the database:

       mysql -h <database-endpoint> -u <username> -p<password> springbackend < path/to/data.sql
7. Install Docker
Install Docker on your EC2 instance:

       sudo apt install docker.io -y
       sudo systemctl start docker
       sudo systemctl enable docker

8. Configure and Run the Spring Backend
Edit the application.properties file to point to your RDS instance:

       cd anguler-java/spring-backend/src/main/resources
       nano application.properties  # Replace localhost with your RDS endpoint and set the correct credentials
Build and run the Spring backend:

     cd ../../
     docker build -t spring:backend .
     docker run -d -p 8080:8080 spring:backend

9. Configure and Run the Angular Frontend
Edit the worker.service.ts file to point to the correct public IP:

       cd ../anguler-frontend/src/app/services/
       nano worker.service.ts  # Replace localhost with your EC2 public IP
Build and run the Angular frontend:

       cd ../../
       docker build -t anguler:frontend .
       docker run -d -p 80:80 anguler:frontend
10. Check Running Containers
Verify the containers are running:

        docker ps
11. Access the Application
Visit your application using the EC2 public IP:

       Frontend: http://<public-ip>
Backend: http://<public-ip>:8080

12. Add Data to the Database
You can now interact with the application and add data to the worker table.

# Kubeadm Installation Guide
This guide provides step-by-step instructions for setting up Kubernetes using kubeadm on both Master and Worker nodes. The setup includes the installation of kubeadm, kubelet, kubectl, and the CRI-O runtime.

## Prerequisites
Two instances (Master Node & Worker Node) launched with t2.large.
SSH access to both instances.
Internet connection on both instances.
1. Set Hostnames for Both Nodes
Master Node:
sudo hostnamectl set-hostname Master

Worker Node:
sudo hostnamectl set-hostname Worker

2. Install kubectl on Both Nodes
Run the following commands to install kubectl:

        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
        echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
3. Verify the installation:


        kubectl version --client
        Disable Swap

        sudo swapoff -a
4. Configure Kernel Parameters

        cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
        overlay
        br_netfilter
        EOF

        sudo modprobe overlay
        sudo modprobe br_netfilter

        cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
        net.bridge.bridge-nf-call-iptables  = 1
        net.bridge.bridge-nf-call-ip6tables = 1
        net.ipv4.ip_forward                 = 1
                EOF

        sudo sysctl --system
5. Install CRI-O Runtime

                        sudo apt-get update -y
        sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg
        sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
        echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list
        sudo apt-get update -y
        sudo apt-get install -y cri-o
        sudo systemctl daemon-reload
        sudo systemctl enable crio --now
        sudo systemctl start crio.service
6. Install Kubernetes Packages

        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

        sudo apt-get update -y
        sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
        sudo systemctl enable --now kubelet
        Master Node Configuration
7. Initialize the Control Plane:

        sudo kubeadm config images pull
        sudo kubeadm init
8. Set up kubeconfig for kubectl:


        mkdir -p "$HOME"/.kube
        sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
        sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
9. Install Calico Network Plugin

        kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
10. Generate Token for Worker Node

        kubeadm token create --print-join-command
11. Worker Node Configuration
Run the following on the worker node after receiving the join token from the master:


        sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash <CERT_HASH> --v=5
12. Verify Cluster Setup
On the Master Node:
Check the nodes:


        kubectl get nodes
13. Install NGINX as a Test Deployment:

kubectl run nginx --image=nginx
kubectl get pods

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

# DEVOPS-task-s

## STUDENT APP USING DOCKER .......

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

# Kubeadm Installation Guide
This guide provides step-by-step instructions for setting up Kubernetes using kubeadm on both Master and Worker nodes. The setup includes the installation of kubeadm, kubelet, kubectl, and the CRI-O runtime.

## Prerequisites
Two instances (Master Node & Worker Node) launched with t2.large.
SSH access to both instances.
Internet connection on both instances.
Set Hostnames for Both Nodes
 Master Node:

    sudo hostnamectl set-hostname Master
Worker Node:

     sudo hostnamectl set-hostname Worker
 Install kubectl on Both Nodes
Run the following commands to install kubectl:

     curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
     sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
 Verify the installation:


    kubectl version --client
    Disable Swap

     sudo swapoff -a
 Configure Kernel Parameters

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
Install CRI-O Runtime

      sudo apt-get update -y
      sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg
     sudo curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list
    sudo apt-get update -y
    sudo apt-get install -y cri-o
    sudo systemctl daemon-reload
    sudo systemctl enable crio --now
    sudo systemctl start crio.service
Install Kubernetes Packages

    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
     echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update -y
    sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
    sudo systemctl enable --now kubelet
Master Node Configuration
Initialize the Control Plane:

     sudo kubeadm config images pull
     sudo kubeadm init
Set up kubeconfig for kubectl:


     mkdir -p "$HOME"/.kube
     sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
     sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
Install Calico Network Plugin

     kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
Generate Token for Worker Node

    kubeadm token create --print-join-command
Worker Node Configuration
Run the following on the worker node after receiving the join token from the master:


    sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash <CERT_HASH> --v=5
Verify Cluster Setup
On the Master Node:
Check the nodes:


    kubectl get nodes
Install NGINX as a Test Deployment:

    kubectl run nginx --image=nginx
    kubectl get pods

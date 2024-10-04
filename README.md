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
An AWS EC2 instance (Ubuntu)
SSH access to the instance
Docker installed on the EC2 instance
An RDS instance for the database
Git installed on the EC2 instance

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

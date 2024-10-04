# DEVOPS-task-s

...... STUDENT APP USING DOCKER .......

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

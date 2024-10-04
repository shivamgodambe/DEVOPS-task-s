# DEVOPS-task-s
all about devops

STUDENT APP USING DOCKER

Steps:
Create an EC2 Instance:

Login to the instance using SSH:
bash
Copy code
ssh -i keyname username@public_ip
Clone the Project Repository:

Clone the GitHub repository with the project:
bash
Copy code
git clone https://github.com/rajatpzade/CDECB39-Demo.git
Start Docker:

Activate Docker by running the docker.sh file:
bash
Copy code
chmod o+x docker.sh
./docker.sh
Database Setup:

Navigate to the DB directory and give execution permission to the Dockerfile.
Build and run the database container:
bash
Copy code
docker build -t students-db .
docker run -d -p 3306:3306 --name students-db students-db
Backend Setup:

Navigate to the BE (backend) directory, and do the same steps as for the database.
Build and run the backend container, linking it to the database:
bash
Copy code
docker build -t students-backend .
docker run -d -p 8080:8080 --name students-backend --link students-db students-backend
Frontend Setup:

Navigate to the FE (frontend) directory, modify index.html to include the public IP.
Build and run the frontend container:
bash
Copy code
docker build -t students-frontend .
docker run -d -p 80:80 --name students-frontend students-frontend
Access the Application:

Access the application by hitting the public IP on a web browser to interact with the student app and add data.

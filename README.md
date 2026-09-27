# DevOps ECS Fargate Challenge
This project is an AWS DevOps porfolio project build from scratch to demonstrate how I would design, automate, deploy, monitor, and scale a containerized application in AWS. 



## Business Problem

The company was experiencing higher traffic and increased use of digital services like online waitlists and pickup ordering. Because the applications supported multiple locations, increases in traffic could place more demand on the shared application infrastructure, especially during busy hours.



## Solution

We needed a scalable environment that could distribute traffic across multiple application containers, automatically add capacity when demand increased, preserve guest information across the backend services, and support reliable automated deployments.

The environment was built in AWS using Amazon ECS with Fargate. The application was separated into a frontend and backend service. Both applications ran as Docker Containers and were stored in the ECR. An Application Load Balancer routed the traffic to the correct service.

The backend used DynamoDB so multiple ECS tasks could access the same guest waitlist data. Terraform was used to provision the infrastructure, while Ansible configured the Jenkins server with Java, Docker, and Jenkins. Jenkins automated the CI/CD process by building Docker images, pushing them to ECR, and deploying the updated application to ECS.




## Expected Results

Users were able to access the application through the Application Load Balancer and add guest information to the waitlist. The frontend and backend ran as separate ECS Fargate services, while DynamoDB stored the shared guest data.

When traffic increased, ECS automatically added more tasks. When application changes were pushed to GitHub, Jenkins built new Docker images, pushed them to ECR, and deployed the updated application to ECS. The final environment demonstrated AWS infrastructure automation, containerization, CI/CD, monitoring, security, and application scaling.

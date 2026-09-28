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




## Networking

I provisioned a VPC and the networking resources required by the ECS environment. The Application Load Balancer was placed in public subnets so it could receive traffic from the internet. ECS Fargate tasks were connected to the VPC through their configured subnets and security groups. Route tables and an Internet Gateway were configured to provide the required network connectivity.




## Security Groups

I provisioned Security Groups like the Application Load Balancer Security Group which allowed incoming application traffic. The ECS Security Group restricted application traffic so that the containers received requests through the load balancer. The Jenkins Security Group was configured to allow the required administrative access and access to the Jenkins web interface.




## ECR

I provisioned two ECR repoaitories.They provided centralized storage for the Docker images created by the Jenkins pipeline. Each successfull pipeline build authenticated to ECR, built new frontend and backend Docker images, tagged them, and pushed the latest versions into their respective repositories.




## Docker

I containerized the frontend and backend applications independently using Docker. Each of the application contained its own Dockerfile so that Jenkins could build the services separately. This allowed the frontend and backend to be deployed and managed as independent ECS services. The images were then stored in Amazon ECR.




## ECS Fargate

I provisioned an ECS cluster and deployed the application using AWS Fargate (serverless)
I created separate ECS services for the backend and the frontend. Each service started with a desired count of one task. The ECS task definitions defined the container configuration, CPU, memory, networking, ECR image, and other settings required to run the applications.




## Application Load Balancer

I provisioned an Application Load Balancer as the public entry point into the application.  The ALB received incoming HTTP (80) traffic and used listeners, listener rules, and target groups to route requests to the appropriate ECS Fargate service. Validated that the target groups registered the Fargate tasks successfully and that the application could be accessed through the ALB DNS endpoint.




## Jenkins EC2 Server

I provisioned an Amazon Linux EC2 instance to operate as the Jenkins CI/CD server. I used Ansible to automate the installation and configuration of the required tools in the server. Jenkins server was configured with permissions required to communicate with AWS services used by the deployment pipeline.




## Ansible

I created an Ansible inventory containing the Jenkins EC2 server and verified connectivity using an Ansible ping. I then created a Jenkins Ansible playbook that configured the server and installed the required dependencies, including Jenkins, Docker, and the AWS CLI. Ansible also started the required services and configured the necessary user permissions. This allowed the Jenkins server configuration to be repeatable instead of relying entirely on manual setup.




## IAM Role

I provisioned an IAM role for the Jenkins EC2 instance. The role provided the permissions required for the pipeline to communicate with services such as Amazon ECR and Amazon ECS. Then I configured the IAM roles required by ECS tasks and Fargate.




## Jenkins CI/CD Pipeline

I created a Jenkinsfile to automate the application deployment process. The pipeline retrieved the application source code from GitHub and then performed the required CI/CD stages. The pipeline provided an automated path from source code to a running application on ECS Fargate.

The pipeline did the following:

- Checked out the source code from GitHub.
- Authenticated Docker with ECR.
- Built the frontend Docker image.
- Built the backend Docker image.
- Tagged the Docker images.
- Pushed both images to their ECR repositories.
- Triggered new deployments of the frontend and backend ECS services.
- Waited for the ECS services to return to a stable state.

After the deployment completed, Jenkins reported: 
Finished: SUCCESS




## Rolling Deployment

I configured ECS so application updates could be deployed through rolling deployments. After Jenkins pushed new images to ECR, the pipeline triggered ECS to deploy the updated containers. ECS started replacement tasks and used the Application Load Balancer health checks to verify that the new tasks were healthy before completing the deployment. This allowed application changes to be deployed without manually replacing the running containers.




## ECS Service Auto Scaling

I configured ECS Service Auto Scaling for the application. The service was configured with:

- Minimum capacity: 1 task
- Maximum capacity: 4 tasks
- Target CPU utilization: 50%

This allowed ECS to automatically increase the number of running Fargate tasks when application CPU utilization increased.




## Load Testing

I used hey (hey -z 10m -c 100 http://... ) to generate concurrent HTTP (80) traffic against the Application Load Balancer. The test generated sustained traffic against the application while I monitored ECS and CloudWatch.



## CloudWatch Monitoring

I used Amazon CloudWatch to monitor the ECS services during normal operation and load testing. I monitored CPU utilization and observed the increase in resource usage while traffic was being generated against the Application Load Balancer. CloudWatch metrics provided the utilization data used by ECS Service Auto Scaling to determine when additional tasks were required.




## Testing and Validation of Environment

The following was validated after deployment:

- Terraform infrastructure was successfully provisioned.
- Ansible successfully connected to the Jenkins EC2 instance.
- Jenkins, Docker, and AWS CLI were successfully configured.
- Jenkins successfully accessed AWS through the EC2 IAM role.
- Jenkins successfully retrieved the application source code from GitHub.
- Frontend and backend Docker images were successfully built.
- Both Docker images were successfully pushed to Amazon ECR.
- ECS successfully deployed the frontend and backend services.
- Both services reached their desired running task count.
- The Application Load Balancer successfully routed application traffic.
- ECS rolling deployments completed successfully.
- CloudWatch successfully reported ECS CPU utilization.
- Load testing successfully increased application workload.
- ECS Service Auto Scaling successfully increased the number of running tasks.
- Auto Scaling was configured for 1–4 tasks at 50% target CPU utilization.
- The complete Jenkins pipeline finished successfully.




## Project Results

I built an automated AWS container deployment environment from infrastructure provisioning through application deployment and scaling. Terraform provided repeatable infrastructure, Ansible automated the Jenkins server configuration, Docker containerized the frontend and backend applications, ECR provided centralized image storage, and Jenkins automated the CI/CD workflow. The application ran as separate frontend and backend ECS Fargate services behind an Application Load Balancer. CloudWatch provided monitoring, while ECS Service Auto Scaling automatically increased task capacity when CPU utilization increased during load testing.




## Repository Structure

DEVOPS-ECS-FARGATE-CHALLENGE/
|
|--> ansible/
|    |--> inventory.ini
|    `--> jenkins.yml
|
|--> backend/
|    |--> node_modules
|    |--> Dockerfile
|    |--> package.json
|    |--> package-lock.json
|    `--> server.js
|
|--> frontend/
|    |--> Dockerfile
|    |--> index.html
|    |--> nginx.conf
|
|
|--> terraform/
|    |--> alb.tf
|    |--> autoscaling.tf
|    |--> dynamodb.tf
|    |--> ecr.tf
|    |--> ecs.tf
|    |--> iam.tf
|    |--> jenkins.tf
|    |--> networking.tf
|    |--> outputs.tf
|    |--> security.tf
|    |--> terraform.tfvars
|    |--> variables.tf
|    `--> versions.tf
|
|
|--> .gitignore
|--> Jenkinsfile
`--> README.md
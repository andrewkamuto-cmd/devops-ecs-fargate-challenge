pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'
        AWS_ACCOUNT_ID = '581171874509'

        BACKEND_REPO = 'andrews-backend'
        FRONTEND_REPO = 'andrews-frontend'

        BACKEND_ECR = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${BACKEND_REPO}"
        FRONTEND_ECR = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${FRONTEND_REPO}"

        ECS_CLUSTER = 'andrews-cluster'
        BACKEND_SERVICE = 'andrews-backend-service'
        FRONTEND_SERVICE = 'andrews-frontend-service'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Tools') {
            steps {
                sh '''
                    docker --version
                    aws --version
                    aws sts get-caller-identity
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login \
                    --username AWS \
                    --password-stdin \
                    $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Build Images') {
            steps {
                sh '''
                    docker build --platform linux/amd64 \
                    -t $BACKEND_REPO:latest ./backend

                    docker build --platform linux/amd64 \
                    -t $FRONTEND_REPO:latest ./frontend
                '''
            }
        }

        stage('Tag Images') {
            steps {
                sh '''
                    docker tag $BACKEND_REPO:latest $BACKEND_ECR:latest
                    docker tag $FRONTEND_REPO:latest $FRONTEND_ECR:latest
                '''
            }
        }

        stage('Push Images') {
            steps {
                sh '''
                    docker push $BACKEND_ECR:latest
                    docker push $FRONTEND_ECR:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                      --cluster $ECS_CLUSTER \
                      --service $BACKEND_SERVICE \
                      --force-new-deployment \
                      --region $AWS_REGION

                    aws ecs update-service \
                      --cluster $ECS_CLUSTER \
                      --service $FRONTEND_SERVICE \
                      --force-new-deployment \
                      --region $AWS_REGION
                '''
            }
        }

        stage('Wait for ECS') {
            steps {
                sh '''
                    aws ecs wait services-stable \
                      --cluster $ECS_CLUSTER \
                      --services $BACKEND_SERVICE \
                      --region $AWS_REGION

                    aws ecs wait services-stable \
                      --cluster $ECS_CLUSTER \
                      --services $FRONTEND_SERVICE \
                      --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }

        failure {
            echo 'Deployment failed. Check the Jenkins console output.'
        }
    }
}
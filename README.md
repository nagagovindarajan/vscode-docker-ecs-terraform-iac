# Running VSCode Server Docker Image in ECS with HTTPS ALB

This guide will walk you through the process of running Visual Studio Code Server as a Docker container in Amazon ECS (Elastic Container Service) with an HTTPS Application Load Balancer (ALB) for secure access. Additionally, we will set up SSH access to private subnet instances and explore private subnet databases using Visual Studio Code.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- An AWS account with appropriate permissions
- AWS CLI installed and configured with your AWS credentials
- Terraform installed on your local machine (for infrastructure provisioning)

## Architecture Overview

The following components will be provisioned in this setup:

- ECS cluster and task definition for VSCode Server container
- Application Load Balancer (ALB) with HTTPS listener for secure access
- Visual Studio Code with necessary extensions for database exploration

## Getting Started

To get started with running VSCode Server in ECS follow these steps:

### Step 1: Clone the Repository

Clone this repository to your local machine:

### Step 2: Update Variables

Open the `vars.tf` file and update the variables as per your requirements. Adjust any other variables if needed.

### Step 3: Provision Infrastructure

Initialize Terraform in the repository directory:

terraform init

Review the planned infrastructure changes:

terraform plan

If the plan looks good, apply the changes:

terraform apply

### Step 4: Access VSCode Server

Terraform will create the necessary AWS resources, including the ECS cluster, task definition, ALB, security groups, route53 records, acm, cloudwatch, vpc, nat and IAM roles.

Once the Terraform apply is successful, you can access the VSCode Server by opening the ALB DNS name provided in the Terraform output. The URL should be in the format `https://<alb-dns-name>`. This will take you to the VSCode Server web interface.

### Step 5: SSH Access to Private Subnet Instances

To access private subnet instances, open terminal in vscode and use ssh commands.

### Step 6: Explore Private Subnet Databases

Install the necessary extensions in Visual Studio Code to explore databases running in private subnets. For example, you can use extensions for MySQL, PostgreSQL, or MongoDB depending on your database setup.

## Clean Up

To clean up and destroy the provisioned resources when you're done, run the following command:

terraform destroy

Confirm the destruction by typing "yes" when prompted.

## Conclusion

You have successfully set up Visual Studio Code Server as a Docker container in ECS with HTTPS ALB and SSH access to private subnet instances. You can now explore and edit code, access databases, and perform various development tasks securely from anywhere using Visual Studio Code.

Please note that this is a general guide, and you may need to adapt it to your specific requirements. Refer to the Terraform documentation, AWS documentation, and Visual Studio Code Server documentation for further details and customization options.

Happy coding with VSCode Server in AWS ECS!

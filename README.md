# Terraform & Ansible CI/CD Pipeline for AWS EC2

## Project Overview
This project provides a complete automated CI/CD pipeline using GitHub Actions to provision AWS infrastructure via **Terraform** and configure the server using **Ansible**. It deploys an EC2 instance, secures it, and installs Nginx using an Ansible role, utilizing highly secure ephemeral SSH keys via AWS EC2 Instance Connect.

## Project Architecture

```text
.
├── .github/                # GitHub Actions CI/CD Workflows
├── ansible/                # Configuration Management
│   ├── nginx/              # Nginx Ansible Role
│   │   ├── defaults/
│   │   ├── files/
│   │   │   └── index.html
│   │   ├── handlers/
│   │   ├── meta/
│   │   ├── tasks/
│   │   │   └── main.yml
│   │   ├── tests/
│   │   └── vars/
│   └── playbook.yaml       # Main Ansible Playbook
├── bootstrap/              # Run manually first to create remote backend
│   └── main.tf
├── terraform/              # Infrastructure as Code
│   ├── backend.tf
│   ├── ec2.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── security_group.tf
│   ├── variables.tf
│   └── vpc.tf
└── README.md


## Steps to Provision the Infrastructure

### 1. Bootstrap (Remote Backend)
The DynamoDB table and S3 bucket must be created before triggering the pipeline to securely store the Terraform state file.

```bash
cd bootstrap
terraform init
terraform apply

### 2. Prepare GitHub Secrets
Inside your GitHub repository, navigate to **Settings > Secrets and variables > Actions** and add the following repository secrets:

* **`AWS_ACCESS_KEY_ID`**: Your AWS access key.
* **`AWS_SECRET_ACCESS_KEY`**: Your AWS secret key.
* **`SNYK_TOKEN`**: Used by Snyk for infrastructure security and vulnerability scanning.
* **`MY_IP`** (or `Secret-IP`): Your personal public IP address to restrict SSH access in the AWS Security Group.

> **Security Note:** There is no need to store a static SSH Private Key in GitHub Secrets. The CI/CD pipeline automatically generates an ephemeral SSH keypair on the fly, pushes the public key via AWS EC2 Instance Connect (valid for only 60 seconds), and securely runs the Ansible playbook.

### 3. Pipeline Stages
Any push to the `main` branch, or a manual trigger (`workflow_dispatch`), will initiate the workflow. The pipeline executes the following stages:

#### Infrastructure Provisioning (Terraform)
* **fmt check:** Formats the Terraform code to ensure styling consistency.
* **Security check:** Scans the infrastructure code for vulnerabilities using Snyk.
* **init, validate, plan:** Prepares and plans the infrastructure changes.
* **apply:** Provisions the infrastructure (VPC, Subnets, Security Groups, and EC2 Instance).

#### Configuration Management (Ansible)
* Waits for the EC2 SSH port (22) to become available.
* Installs Ansible on the GitHub Runner.
* Generates an Ephemeral SSH Key and pushes it to the EC2 instance.
* Generates a dynamic `inventory.ini` file with the new EC2 Public IP.
* Runs the Ansible playbook (`ansible-playbook playbook.yaml`) to configure Nginx via the custom role.
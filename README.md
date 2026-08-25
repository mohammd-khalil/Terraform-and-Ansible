# Terraform + GitHub Actions — EC2 Pipeline

## Projetc Architecture

```
terraform-ec2-pipeline/
├── bootstrap/              # Run it manually to create S3 and Dynamodb first
│   └── main.tf
├── terraform/             
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── security_group.tf
│   ├── ec2.tf
│   └── outputs.tf
└── .github/workflows/terraform.yml
```

## Steps to Provision the infrastructure  

### 1) Bootstrap 
Dynamodb and S3 bucket must be excited before triggering the pipeline
```bash
cd bootstrap
terraform init
terraform apply
```
### 2) Prepare GitHub Secrets 

inside github repo add new secrets :

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `SNYK_TOKEN` -> To use snyk and check security of code 
- `Secret-IP` -> Your public ip to open ssh
- `EC2-private-key` -> The Private key , which is used to open ssh on the instance

### 3) Pipeline 
Any push on main branch , will trigger the workflow : 
`fmt check → Security check → init → validate → plan → apply` -> 




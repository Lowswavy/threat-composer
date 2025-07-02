# 🚀 AWS Threat Modelling App Deployment to AWS ECS with Terraform and Github Actions

This project deploys a containerised Node.js application to AWS ECS using **Terraform**, **GitHub Actions** and **Docker**, culminating in a secure, HTTPS-enabled deployment of a containerized app accessible via a custom subdomain.

---

## 🧱 Overview

The application runs in a Docker container hosted on ECS Fargate. Infrastructure is defined using Terraform and deployed through automated workflows in GitHub Actions. DNS is handled through Route 53 with HTTPS enabled via ACM.


---

> 📁 Repo Structure:
```
.
├── app/
│   └── Dockerfile
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── ecs/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── alb/
│   │   ├── acm/
│   │   └── route53/
│   └── environments/
│       └── dev/
│           ├── main.tf          
│           ├── variables.tf  
│           └── backend.tf       
├── .github/
│   └── workflows/
│       ├── plan.yml
│       ├── apply.yml
│       └── destroy.yml
└── README.md
```
---

## Key Components

- ### Docker
    - A `Dockerfile` in the app directory defines how the application is built into a container.

- ### Terraform
    - `ECS Fargate` for hosting the container.
    - `Application Load Balancer` for routing traffic.
    - `Route 53` for domain management.
    - `ACM` for SSL certificates.
    - `Security groups` to control access.
    - `VPC` with public subnets, internet gateway, and NAT gateway.

- ### CI/CD (GitHub Actions)

    - Building and scanning the Docker image.
    - Pushing the image to Amazon ECR.
    - Running Terraform plan and apply.
    - Destroying infrastructure if needed.

---

### Local App Setup 💻

```bash
yarn install
yarn build
yarn global add serve
serve -s build
```
Then visit:

```bash
http://localhost:3000/workspaces/default/dashboard
```

Or use:

```bash
yarn global add serve
serve -s build
```

---

## Deployment Workflow

- ### 1. Docker Build and Push

    - Builds the Docker image.
    - Pushes the image to Amazon ECR.

- ### 2. Terraform Plan

    - Runs `terraform init` and `terraform plan`.

- ### 3. Terraform Apply
    
    - Applies the Terraform configuration to provision or update resources.
    - Deploys the ECS service, ALB, Route 53 records, and ACM certificate.

- ### 4. Terraform Destroy

    - Destroys all Terraform-managed infrastructure when no longer needed.

---

## 🚢 Deployment & Validation

Once Terraform is applied:
- The ECS service launches the Docker container from ECR.
- ALB routes traffic to the container.
- HTTPS is enforced via valid ACM certificate.

✅ Live at: `https://tm.ahmedlabs.com`

---

## 🧾 Screenshots & Diagram

### 🔍 Live App

<img width="1440" alt="Image" src="https://github.com/user-attachments/assets/126a14e0-9271-4035-981d-7b18a3099a55" />


<img width="1057" alt="Image" src="https://github.com/user-attachments/assets/651bb2a9-7b05-47b5-9c27-d7c773eb74fd" />


<img width="1058" alt="Image" src="https://github.com/user-attachments/assets/b2b1d444-1a60-401e-9a9a-02eef485b726" />


<img width="1052" alt="Image" src="https://github.com/user-attachments/assets/46dd15b0-995d-47d6-b403-bd65fed853f5" />

---


## 🙋‍♂️ Author

Ahmed Osman – [https://tm.ahmedlabs.com](https://tm.ahmedlabs.com)

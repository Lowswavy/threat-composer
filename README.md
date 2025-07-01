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

## 🧾 7. Screenshots & Diagram

### 🔍 Live App

![Live App Screenshot](./screenshots/live-app.png)

### 🧱 Architecture Diagram

```
[ User ]
   ↓ HTTPS
[ Route53 DNS ]
   ↓
[ ALB (HTTPS Listener + ACM) ]
   ↓
[ ECS Fargate Service ]
   ↓
[ Docker App Container (from ECR) ]
```

---


## 🙋‍♂️ Author

Ahmed Osman – [https://tm.ahmedlabs.com](https://tm.ahmedlabs.com)

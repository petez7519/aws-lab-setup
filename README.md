🌐 AWS SAA‑C03 Study Lab
Terraform‑Built VPC • Bastion Host • Private EC2 • NAT Gateway
<p align="center">
<img src="https://img.shields.io/badge/AWS-SAA--C03-blue?style=for-the-badge&logo=amazonaws" />
<img src="https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?style=for-the-badge&logo=terraform" />
<img src="https://img.shields.io/badge/Cloud-Networking-orange?style=for-the-badge&logo=cloudflare" />
</p>

This repository contains a clean, exam‑aligned AWS networking lab built with Terraform, designed to help you master the core VPC concepts required for the AWS Solutions Architect Associate (SAA‑C03) certification.

It deploys a realistic, secure, production‑style architecture — perfect for hands‑on learning, interviews, and certification prep.

🧭 What You’ll Build
A fully functional AWS network environment featuring:

1 VPC (10.0.0.0/16)

Public Subnet with:

Bastion Host

NAT Gateway

Internet Gateway

Private Subnet with:

Private EC2 instance (no public IP)

Security Groups enforcing least‑privilege access

Route Tables for public + private routing

🏗️ Architecture Diagram
Code
                         ┌──────────────────────────────┐
                         │          Internet             │
                         └──────────────┬───────────────┘
                                        │
                              ┌─────────▼─────────┐
                              │  Internet Gateway  │
                              └─────────┬─────────┘
                                        │
                         ┌──────────────▼────────────────┐
                         │        Public Subnet           │
                         │        10.0.1.0/24             │
                         │                                │
                         │  ┌──────────────────────────┐  │
                         │  │      Bastion Host        │  │
                         │  │   (Public EC2 Instance)  │  │
                         │  └──────────────────────────┘  │
                         │                                │
                         │  ┌──────────────────────────┐  │
                         │  │       NAT Gateway        │  │
                         │  └──────────────────────────┘  │
                         └──────────────┬─────────────────┘
                                        │
                              ┌─────────▼─────────┐
                              │   Private Route    │
                              │   0.0.0.0/0 → NAT  │
                              └─────────┬─────────┘
                                        │
                         ┌──────────────▼────────────────┐
                         │        Private Subnet          │
                         │        10.0.2.0/24             │
                         │                                │
                         │  ┌──────────────────────────┐  │
                         │  │     Private EC2          │  │
                         │  │ (No Public IP Address)   │  │
                         │  └──────────────────────────┘  │
                         └────────────────────────────────┘
🎯 Why This Lab Matters (SAA‑C03 Focus)
This lab directly reinforces high‑value exam topics:

VPC design fundamentals

Public vs. private subnet isolation

NAT Gateway vs. Internet Gateway

Bastion host access patterns

Security group chaining

Route table behavior

Private instance internet access

SSH jump‑host patterns

These concepts appear repeatedly on the SAA‑C03 exam and in real AWS architectures.

🚀 Deployment Instructions
1. Initialize Terraform
bash
terraform init
2. Review the plan
bash
terraform plan
3. Apply
bash
terraform apply
Before deploying, update:
key_name → Your EC2 key pair name

Your IP address in the Bastion SG ingress rule

🔐 Access Pattern
This lab uses a secure, exam‑relevant SSH flow:

Your laptop → Bastion Host (public IP)

Bastion Host → Private EC2 (private IP)

Private EC2 → Internet via NAT Gateway

No inbound internet access to private subnet

This is the gold‑standard pattern for secure VPC access.

🧹 Cleanup
Destroy all resources:

bash
terraform destroy
📚 Perfect For
AWS SAA‑C03 exam prep

Hands‑on VPC networking practice

Understanding NAT vs. IGW

Practicing secure SSH access patterns

Building foundational AWS architecture skills

Demonstrating IaC proficiency in interviews

📝 Notes
This lab intentionally focuses on core VPC networking, which is heavily tested on the SAA‑C03 exam.
It avoids advanced services (ALB, ASG, RDS, TGW, etc.) to keep the learning focused and approachable.

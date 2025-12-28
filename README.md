AWS SAA‑C03 Study Lab — Terraform VPC, Bastion Host, Private EC2, and NAT Gateway
This repository contains a hands‑on AWS networking lab built with Terraform, designed to support preparation for the AWS Solutions Architect Associate (SAA‑C03) certification.
It deploys a realistic, exam‑aligned VPC architecture that demonstrates secure access patterns, subnet isolation, routing, and foundational AWS networking services.

📘 Purpose of This Lab
This lab is intentionally simple, modular, and aligned with the SAA‑C03 exam blueprint.
It helps you build intuition around:

Designing secure VPC architectures

Public vs. private subnet patterns

NAT Gateway vs. Internet Gateway

Bastion host access flows

Security group design and least privilege

Route table configuration

EC2 connectivity and SSH patterns

Private subnet internet access

These concepts appear repeatedly on the SAA‑C03 exam and in real‑world AWS architectures.

🏗️ Architecture Overview
Terraform provisions the following AWS infrastructure:

VPC
CIDR: 10.0.0.0/16

Provides isolated networking for the lab

Subnets
Public Subnet (10.0.1.0/24)

Auto‑assigns public IPs

Hosts the Bastion Host

Contains the NAT Gateway

Private Subnet (10.0.2.0/24)

No public IPs

Hosts the Private EC2 instance

Internet Gateway
Attached to the VPC

Enables outbound internet access for the public subnet

NAT Gateway
Lives in the public subnet

Allows private EC2 instances to reach the internet

Prevents inbound connections from the internet

Route Tables
Public Route Table

0.0.0.0/0 → Internet Gateway

Associated with the public subnet

Private Route Table

0.0.0.0/0 → NAT Gateway

Associated with the private subnet

Security Groups
Bastion SG

Allows SSH only from your IP

Outbound allowed to anywhere

Private EC2 SG

Allows SSH only from the Bastion SG

No inbound internet access

EC2 Instances
Bastion Host

Amazon Linux 2

Public subnet

Public IP

Used to SSH into private resources

Private EC2 Instance

Amazon Linux 2

Private subnet

No public IP

Only reachable through the Bastion Host

🔐 Access Pattern
This lab demonstrates a classic secure access pattern:

SSH from your laptop → Bastion Host (public IP)

SSH from Bastion Host → Private EC2 (private IP)

Private EC2 uses NAT Gateway for outbound internet

No inbound traffic reaches the private subnet

This pattern is heavily tested on the SAA‑C03 exam.

📦 Deployment Instructions
1. Initialize Terraform
bash
terraform init
2. Review the plan
bash
terraform plan
3. Deploy
bash
terraform apply
Before deploying, update:
key_name → Your EC2 key pair name

Your IP address in the Bastion SG ingress rule

🧹 Cleanup
To remove all AWS resources created by this lab:

bash
terraform destroy
📚 Ideal For
AWS SAA‑C03 exam preparation

Hands‑on VPC networking practice

Understanding NAT vs. IGW

Practicing secure SSH access patterns

Building foundational AWS architecture skills

📝 Notes
This lab intentionally focuses on core VPC networking, which is a major portion of the SAA‑C03 exam.
It avoids advanced services (ALB, ASG, RDS, TGW, etc.) to keep the learning focused and approachable.

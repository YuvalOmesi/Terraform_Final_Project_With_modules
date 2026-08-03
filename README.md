# Terraform_Final_Project_With_modules

Hello Dima. 

This is my Terraform AWS project. Just like the last project that was split into Network and Servers, this time I rebuilt it using modules:

1. Network Module (inside modules folder):
   * Provisions a VPC (10.0.0.0/16) with an Internet Gateway.
   * Creates 2 Public Subnets (Multi-AZ) with auto-assigned public IPs.
   * Creates 2 Private Subnets with 2 dedicated NAT Gateways for secure internet access out.
   * Creates 2 completely isolated Database Subnets.

2. Root Code (Servers):
   * Takes the VPC and public subnets directly from the network module outputs.
   * Creates a Security Group with Port 22 (SSH only).
   * Sets up a Launch Template using the latest Ubuntu 24.04 AMI.
   * Runs an Auto Scaling Group (ASG) across the public subnets.

Additional points:
* Remote Backend - Managed and saved the state files remotely inside an S3 Bucket.
* UserData Script - The instance runs a script on launch to install Apache for deployment check.

⚠️ Important Notes before running:
* S3 Bucket Name - Don't forget to change the S3 backend bucket name in `main.tf` to match your own bucket before running.
* AWS Tokens - Remember to export your AWS credentials/tokens (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, etc.) in your terminal before running `terraform init`.

<img width="1579" height="407" alt="צילום מסך 2026-08-03 164241" src="https://github.com/user-attachments/assets/42161f21-df6a-403c-92cf-8fedfef7bb3f" />

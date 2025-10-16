Minimal Terraform Stack: Functions + Autoscaling

A minimal, clean Terraform setup demonstrating built-in functions and a working AWS stack with a VPC, EC2, and an AutoScaling Group.

Directory Layout

```
.
├── functions/
│   └── main.tf
├── Autoscaling/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── ec2/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
├── terraform.tfvars
└── README.md
```

Usage

```bash
cd Autoscaling
terraform init
terraform apply -auto-approve
```

Cleanup

```bash
terraform destroy -auto-approve
```

Notes
- Region defaults to `ap-south-1` via variable.
- VPC includes one public and one private subnet, IGW, routes, and an SG for SSH/HTTP.
- EC2 uses Amazon Linux 2, writes a greeting with user_data, and is tagged by environment.
- AutoScaling Group uses the official community module.
# Terraform Functions & AWS Infrastructure Demo

This project demonstrates **all major Terraform built-in functions** and provides a **complete AWS infrastructure setup** using community modules.

## 📁 Project Structure

```
.
├── functions/
│   └── main.tf          # Comprehensive Terraform functions examples
├── vpc/
│   ├── main.tf          # AWS VPC, EC2, and AutoScaling setup
│   ├── variables.tf     # Variable definitions
│   └── outputs.tf       # Resource outputs
├── terraform.tfvars     # Default variable values
└── README.md           # This file
```

## 🧩 What's Included

### Functions Module (`functions/`)
Demonstrates **all major Terraform built-in function categories**:

- **String Functions**: `upper`, `lower`, `format`, `replace`, `trim`
- **Numeric Functions**: `min`, `max`, `abs`, `ceil`, `floor`
- **Collection Functions**: `length`, `join`, `merge`, `compact`, `contains`, `distinct`
- **Encoding Functions**: `jsonencode`, `jsondecode`, `base64encode`, `base64decode`
- **Date/Time Functions**: `timestamp`, `timeadd`, `formatdate`
- **Filesystem Functions**: `file`, `fileexists`, `dirname`, `basename`
- **Network Functions**: `cidrsubnet`, `cidrhost`, `cidrnetmask`
- **Type Conversion**: `tostring`, `tonumber`, `tolist`, `tomap`
- **Dynamic Evaluation**: `lookup`, `try`, `coalesce`, `element`, `index`, `keys`, `values`
- **Conditional Functions**: `condition`, ternary operator

### VPC Module (`vpc/`)
Creates a **complete AWS infrastructure** using community modules:

- **VPC** with public and private subnets
- **EC2 Instance** with web server
- **Auto Scaling Group** with launch template
- **Security Groups** for web access
- **Demonstrates Terraform functions** in real infrastructure code

## 🚀 Quick Start

### Prerequisites
- Terraform >= 1.0 installed
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review the Functions Examples
```bash
cd functions/
terraform init
terraform plan
```

### 3. Deploy AWS Infrastructure
```bash
cd ../vpc/
terraform init
terraform plan
terraform apply -auto-approve
```

### 4. Access Your Infrastructure
After deployment, you'll get outputs including:
- EC2 instance public IP and URL
- VPC and subnet information
- Auto Scaling Group details

Access your web server at: `http://<ec2_public_ip>`

## 🔧 Configuration

### Variables
Key variables in `terraform.tfvars`:

```hcl
region = "us-east-1"              # AWS region
vpc_cidr = "10.0.0.0/16"         # VPC CIDR block
instance_type = "t3.micro"        # EC2 instance type
min_size = 1                      # ASG minimum instances
max_size = 3                      # ASG maximum instances
desired_capacity = 2              # ASG desired instances
```

### Customization
- Modify `terraform.tfvars` to change default values
- Update `vpc/variables.tf` to add new variables
- Customize security groups in `vpc/main.tf`

## 🧪 Testing Functions

### Run Functions Module
```bash
cd functions/
terraform init
terraform plan
terraform apply
```

This will show **all function outputs** without creating any AWS resources.

### Key Function Examples
```hcl
# String manipulation
output "string_upper" { value = upper("hello world") }

# Network calculations
output "network_cidrsubnet" { value = cidrsubnet("10.0.0.0/16", 8, 1) }

# Conditional logic
output "conditional_ternary" { value = true ? "yes" : "no" }

# Collection operations
output "collection_merge" { value = merge({name = "John"}, {age = 30}) }
```

## 🏗️ Infrastructure Components

### Created Resources
- **VPC**: Custom VPC with public/private subnets
- **EC2 Instance**: Standalone instance with web server
- **Auto Scaling Group**: Auto-scaling group with launch template
- **Security Groups**: Web access and SSH access rules
- **Launch Template**: Template for Auto Scaling instances

### Community Modules Used
- `terraform-aws-modules/vpc/aws` - VPC management
- `terraform-aws-modules/ec2-instance/aws` - EC2 instances
- `terraform-aws-modules/autoscaling/aws` - Auto Scaling groups

## 🧹 Cleanup

### Destroy Infrastructure
```bash
cd vpc/
terraform destroy -auto-approve
```

### Destroy Functions (no resources created)
```bash
cd functions/
terraform destroy -auto-approve
```

## 📚 Learning Resources

This project demonstrates:
- **Terraform Functions**: Complete reference with examples
- **Community Modules**: Best practices for module usage
- **AWS Infrastructure**: Real-world VPC and EC2 setup
- **Code Organization**: Clean, minimal, and readable structure

## 🎯 Key Features

✅ **Complete Function Reference** - All major Terraform functions  
✅ **Real Infrastructure** - Working AWS VPC + EC2 + AutoScaling  
✅ **Community Modules** - Industry-standard module usage  
✅ **Clean Code** - Minimal, readable, and well-commented  
✅ **Production Ready** - Proper security groups and configurations  
✅ **Educational** - Great for learning Terraform concepts  

## 🔍 Troubleshooting

### Common Issues
1. **AWS Credentials**: Ensure AWS CLI is configured
2. **Region Availability**: Check if selected region supports all services
3. **Resource Limits**: Verify AWS account limits for EC2 instances

### Getting Help
- Check Terraform plan output for detailed resource creation
- Review AWS CloudFormation events in AWS Console
- Validate Terraform configuration with `terraform validate`

---

**Happy Terraforming! 🚀**

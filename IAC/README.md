# quest

## Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Usage](#usage)

## About <a name = "about"></a>

 quest IAC

## Getting Started <a name = "getting_started"></a>

These instructions deploy the quest project into ECS and put it behind a network load balancer. 

See [deployment](#deployment) for notes. 

### Prerequisites

An AWS account, initalized to run via the command line. You will also need your account number.  
Terraform.  
### Initalizing 

From this directory, run `terraform init` to initalize the state file. Then run `terraform plan -var="aws_account_number=#"` to observe what will be created. 
## Usage <a name = "usage"></a>

Once happy with the plan, utilize terraform to deply `terraform apply -var="aws_account_number=#""` 

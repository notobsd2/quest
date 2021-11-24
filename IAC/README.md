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

First, you'll need docker installed locally. This is due to the utilization of local-exec's docker build to create the first image for the initalize creation.

In the `aws.tf` file there is a variable that you need to change. It's the S3 bucket for the remote state file. 

You'll need to create your own bucket. You should ensure it has versioning. I did not do this automatically so as to ensure that this readme has been read.  

Additionally, you need to create a secret-key using the secrets manager that contains the o_auth token for your github user. 

The `secret_id` needs to be `github/token` with a type key/value pair. (This is the Secret Name in AWS's console)

The key for the [key/value] pair needs to be `github_token` the value will be your github token. 

From this directory, run `terraform init` to initalize the state file. Then run `terraform plan -var="aws_account_number=#"` to observe what will be created. 
## Usage <a name = "usage"></a>

Once happy with the plan, utilize terraform to deply `terraform apply -var="aws_account_number=#""` 
You'll only need to run this once though. After that, you can simply run `git push` to push to github and let the wonder of automation do the rest. 
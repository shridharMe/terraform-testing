#!/bin/bash

# Unset AWS STS session environment variables
function drop_aws_sts_session {
  unset AWS_ACCESS_KEY_ID
  unset AWS_DEFAULT_REGION
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
}

# Export AWS STS session environment variables
function export_aws_sts_session {
  drop_aws_sts_session
    seed=$(date +%s)
     role={$1}
    data=$(aws --profile devops sts assume-role --role-arn ${role} --role-session-name cpw${seed})
    if [ -z "${data}" ]; then
        echo "!!! Error getting a valid session. Please fix it."
        exit 1
    fi

    export AWS_ACCESS_KEY_ID=$(echo ${data} | sed 's/.*AccessKeyId": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SECRET_ACCESS_KEY=$(echo ${data} | sed 's/.*SecretAccessKey": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SESSION_TOKEN=$(echo ${data} | sed 's/.*SessionToken": "\([A-Za-z0-9\/+=]*\).*/\1/')
    export AWS_SECURITY_TOKEN=$(echo ${data} | sed 's/.*SessionToken": "\([A-Za-z0-9\/+=]*\).*/\1/')
     echo "AWS session set"
}

# Workaround for https://github.com/hashicorp/terraform/issues/17655
export TF_WARN_OUTPUT_ERRORS=1

export_aws_sts_session "us-east-1"

# Destroy any existing Terraform state in us-east-1
bundle exec kitchen destroy centos

# Initialize the Terraform working directory and select a new Terraform workspace
# to test CentOS in us-east-1
bundle exec kitchen create centos

# Apply the Terraform root module to the Terraform state using the Terraform
# fixture configuration
bundle exec kitchen converge centos

# Test the Terraform state using the InSpec controls
bundle exec kitchen verify centos

# Destroy the Terraform state using the Terraform fixture configuration
bundle exec kitchen destroy centos

#export_aws_sts_session "us-west-2"

# Perform the same steps for Ubuntu in us-west-2
#bundle exec kitchen test ubuntu

unset TF_WARN_OUTPUT_ERRORS
drop_aws_sts_session
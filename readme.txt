# Summary

This pattern automates the deployment of replication between a source and destination bucket using Infrastructure as Code (IaC) via Terraform and CloudFormation. It lists all the steps which are needed to deploy both the Terraform and CloudFormation template. Both buckets will be deployed with AES256 Server Side Encryption enabled.

## When to use Cross-Region Replication

S3 Cross-Region Replication (CRR) is used to copy objects across Amazon S3 buckets in different AWS Regions. CRR can help you do the following:
* Meet compliance requirements – Although Amazon S3 stores your data across multiple geographically distant Availability Zones by default, compliance requirements might dictate that you store data at even greater distances. To satisfy these requirements, use Cross-Region Replication to replicate data between distant AWS Regions.
* Minimize latency – If your customers are in two geographic locations, you can minimize latency in accessing objects by maintaining object copies in AWS Regions that are geographically closer to your users.
* Increase operational efficiency – If you have compute clusters in two different AWS Regions that analyze the same set of objects, you might choose to maintain object copies in those Regions.

## Replication requires the following:
* Both source and destination buckets must have versioning enabled. 
* If the source bucket has S3 Object Lock enabled, the destination buckets must also have S3 Object Lock enabled. 
* Proper IAM access when using Terraform, which we will cover as part of our setup in following sections.

**Note:**  Replicating data cross region has a cost associated with it. Please refer to below document for actual pricing.
* https://aws.amazon.com/s3/pricing/

# Prerequisites and limitations
## Prerequisites

When automating the build of S3 Cross Region Replication with Terraform (NOT CloudFormation) we will need to create an IAM User with AmazonS3FullAccess and IAMFullAccess permissions. Once the IAM User is created you will need to navigate to security credentials and select Create access key. While creating the Access Key, you will select Command Line Interface (CLI) as your use case. The use of tags are optional. You will select Create access key and when you arrive to the Retrieve access keys page you can select Download .csv file to access both your Access key and Secret access key which will be required for our Terraform deployment.

# Architecture
## Automation Steps - Terraform

1. Clone the following GitHub Repository - https://github.com/charlpro/aws-s3-cross-region-replication/tree/main
2. Find both your Access key and Secret access key from the prerequisites. Under the s3-crr folder we will need to make updates to main.tf and provider.tf.   
3. In both files main.tf and provider.tf replace enterAccessKeyHere with your Access key from the prerequisites and enterSecretKeyHere with your Secret access key from the prerequisites.
4. Next we will need to update the other main.tf file under the CRR1 folder. Here we will create the globally unique names for each of our S3 buckets. ENTER-RANDOM-NUMBER for both buckets is a place holder and will need to be replaced as capital letters are not allowed when creating the bucket name.
5. Once you have saved all files, open your terminal and navigate to the CRR1 directory. Once you have made CRR1 your working directory you’ll need to run the following terraform commands in order: 
    1. terraform init
    2. terraform plan
    3. terraform apply -auto-approve
6. It should take approximately one minute for terraform to deploy the resources in the AWS account. To make sure it deployed and is working correctly you can navigate to S3 and ensure both buckets you created exist.
7. To test replication you can add a file to your source S3 bucket and check the replica S3 bucket to ensure it replicated.
8. Lastly to check that Server Side Encryption has been enabled you can navigate to each S3 bucket select Properties and check that Default encryption is enabled under Encryption type.

## Automation Steps - CloudFormation

1. Clone the following GitHub Repository - https://github.com/charlpro/aws-s3-cross-region-replication/tree/main
2. Save the files on your local machine. In a moment we will navigate and access the files from the CloudFormation Console.
3. Navigate to CloudFormation in your AWS console. We must launch our Destination Bucket Stack us-west-2.yaml file first. Therefore we must make sure we are in the destination bucket region (us-west-2) Oregon and then select Create stack.
4. Creating the stack you will select Upload a template file and select the Destination Bucket Stack us-west-2.yaml file. Leave everything else the same and select next. 
5. Enter a Stack name this needs to be different from other stacks you may already have deployed. When entering the DestinationBucketName you’ll need to add additional characters to make the name globally unique. Select Next.
6. You can leave everything set to defaults on the Configure stack options page and select Next.
7. Select Submit to launch the stack. 
8. You will repeat steps 3 - 7 for the for the Source Bucket Stack us-east-1.yaml. However, you will need to change the region to (us-east-1) N. Virginia and enter the exact name you used for the destination bucket in the DestionationBucketName parameter. The SourceBucketName parameter will need to be a new globally unique name.
9. Wait until the stack is marked with CREATE_COMPLETE.
10. To make sure everything is working correctly you can navigate to S3 and ensure both buckets you created exist.
11. To test replication you can add a file to your source S3 bucket and check the replica S3 bucket to ensure it replicated.
12. Lastly to check that Server Side Encryption has been enabled you can navigate to each S3 bucket select Properties and check that Default encryption is enabled under Encryption type.


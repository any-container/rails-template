TODO - Infra
* Make changes to have dynamodb and S3 specified
* Perform the terraform apply with local backend.
* Once the storage container is created. Create backend configuration pointing it to the newly created storage container.
* Now perform terraform init. It will ask to migrate state. Say yes and go ahead. Now you have the state configured.
* Add Kamal bits from this - https://pabluc.medium.com/deploying-with-kamal-on-aws-ec2-ecr-and-cloudwatch-terraform-for-iasc-723ce666d661

TODO - Deployment
* Create dynamodb in AWS for terraform state
* Add terraform init workflow that makes a new terraform state file in the dynamodb
** Add AWS as terraform provider with secrets above
** Add terraform code for basic AWS infra https://pabluc.medium.com/deploying-with-kamal-on-aws-ec2-ecr-and-cloudwatch-terraform-for-iasc-723ce666d661
* Deploy with Kamal bits and pieces from above - going to take some practice

TODO - AWS
* Proper authentication of some kind from here https://docs.aws.amazon.com/STS/latest/APIReference/API_Operations.html

TODO - Maintenance
* Terraform updates
* Rails updates

What could this repo be?
Idea 1 - A template for doing engineering work of all kinds, and mapping one implementaiton into other tools/applications/languages.

Given:
- I choose a robust way to write tests that are agnostic to a given framework
- I implement behaviour in a Rails
- I hack together a MAKER flow https://www.cognizant.com/us/en/ai-lab/blog/maker
- I can use it to reimplement behaviour in another framework/language
This over simplifies things obviously, but I think is an interesting idea to explore and see where it fails and succeeds.

Idea 2 - context for engineering maintenance
Everyone needs to update rails gems. What if this repo has already done it in a variety of template Rails apps, and you can tap into the changes here with your own AI agent when making a change in your repo? The code here could become a go-to context. Context as a service. This means maintaining high quality, maintainable code is of the utmost importance.

TODO - Infra
* Make changes to have dynamodb and S3 specified
* Perform the terraform apply with local backend.
* Once the storage container is created. Create backend configuration pointing it to the newly created storage container.
* Now perform terraform init. It will ask to migrate state. Say yes and go ahead. Now you have the state configured.
* Add Kamal bits from this - https://pabluc.medium.com/deploying-with-kamal-on-aws-ec2-ecr-and-cloudwatch-terraform-for-iasc-723ce666d661

TODO - Maintenance
* Terraform updates
* Rails updates

What could this repo be?
Idea 1 - A template for doing engineering work of all kinds, and mapping one implementation into other tools/applications/languages.

Given:
- I choose a robust way to write tests that are agnostic to a given framework
- I implement behaviour in a Rails
- I hack together a MAKER flow https://www.cognizant.com/us/en/ai-lab/blog/maker
- I can use it to reimplement behaviour in another framework/language
This over simplifies things obviously, but I think is an interesting idea to explore and see where it fails and succeeds.

Idea 2 - context for engineering maintenance
Everyone needs to update rails gems. What if this repo has already done it in a variety of template Rails apps, and you can tap into the changes here with your own AI agent when making a change in your repo? The code here could become a go-to context. Context as a service. This means maintaining high quality, maintainable code is of the utmost importance.

Idea 3 - deploy a variety of federated web applications like Lemmy or BlueSky

Idea 4 - Private Minecraft and Roblox servers
Something that would make editing more easy, but still can connect from a switch. https://www.curseforge.com/minecraft-bedrock/scripts/worldedit-be-addon

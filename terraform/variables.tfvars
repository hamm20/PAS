region="us-east-2"
shared_credentials_file="../.aws/credentials"
aws_profile="default"
author="Ham_PAS"


-var 'aws_profile=default' -var 'source_ami=ami-06c8f2ec674c67112' -var 'instance_type=t2.micro' -var 'ssh_key=../pas-ami-id_rsa' template.json
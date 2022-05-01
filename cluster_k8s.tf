data "aws_ami" "aws_linux2_ami" {                                                                                                                                                        
  most_recent = true                                                                                                                                                                     
  owners      = ["amazon"]                                                                                                                                                               
  filter {                                                                                                                                                                               
    name   = "name"                                                                                                                                                                      
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]                                                                                                                                   
  }                                                                                                                                                                                      
}
module "nodos" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["node1", "node2"])

  name = "k8s-${each.key}"

  ami                    = data.aws_ami.aws_linux2_ami.id
  instance_type          = "t2.small"
  key_name               = "Yarel"
  monitoring             = true
  vpc_security_group_ids = [ aws_security_group.node.id ]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "master" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "k8s-Master"

  ami                    = data.aws_ami.aws_linux2_ami.id
  instance_type          = "t2.small"
  key_name               = "Yarel"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.master.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "k8s-Master"
  }
}

data "aws_region" "current" {}
resource "aws_subnet" "quest2a" {
  vpc_id     = aws_vpc.quest.id
  cidr_block = "10.0.2.0/24" 
  availability_zone = "${data.aws_region.current.name}a" 
  tags = {
    Name = "quest"
  }
}
resource "aws_subnet" "quest2b" {
  vpc_id     = aws_vpc.quest.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "${data.aws_region.current.name}b" 
  tags = {
    Name = "quest"
  }
}

resource "aws_vpc" "quest" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "quest" 
  }
  enable_dns_support = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.quest.id

  tags = {
    Name = "quest"
  }
}


resource "aws_security_group" "quest-security-group" {

  name = "quest-sec-group"
  vpc_id = aws_vpc.quest.id 
  description = "Security group for the Quest project"
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  } 
  
}
resource "aws_route_table" "quest-vpc-route-table" {
  vpc_id = aws_vpc.quest.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "quest"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.quest.id
  route_table_id = aws_route_table.quest-vpc-route-table.id
}


data "aws_network_interface" "cluster_interface" {
  filter {
  name =  "tag:aws:ecs:clusterName"
  values =  [aws_ecs_cluster.quest-cluster.name]
  }
  depends_on = [
   aws_ecs_service.quest-ecs-service,
   aws_ecs_cluster.quest-cluster
  ] 
}


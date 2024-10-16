resource "aws_vpc" "vnet" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = "vpc"
    }
  
}

resource "aws_subnet" "sub" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = var.aws_subnet [0]
    availability_zone = var.az [0]
    map_public_ip_on_launch = var.public_ip
    tags={
        Name = "subnetyyy"
    }
  
}

resource "aws_internet_gateway" "abcd" {
    vpc_id = aws_vpc.vnet.id
    tags = {
        Name = "gateway"
    }
  
}


resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.vnet.id
    tags = {
        Name = "rtable"
    }

      route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.abcd.id

    }
}

resource "aws_route_table_association" "rasso" {
    subnet_id = aws_subnet.sub.id
    route_table_id = aws_route_table.rt.id

}
  
resource "aws_security_group" "secure" {
    vpc_id = aws_vpc.vnet.id
    name = "vpc"



ingress {
    from_port = var.port_no [0]
    to_port = var.port_no [0]
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

 
}

  egress {
    from_port = var.port_no [1]
    to_port = var.port_no [1]
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "bcdef"

  }
}

resource "aws_instance" "eyee" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key
    subnet_id = aws_subnet.sub.id
    vpc_security_group_ids = [aws_security_group.secure.id]

    tags = {
      Name = "google"
    }
  
}


  

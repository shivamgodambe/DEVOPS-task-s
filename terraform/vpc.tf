resource "aws_vpc" "abcdefg"{
    cidr_block = "192.168.0.0/20"
    tags ={
        Name = "abcdefg"
    }
}

resource "aws_subnet" "rushi" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.abcdefg.id
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
  tags ={
    Name = "rushi"
  }
}

resource "aws_internet_gateway" "gaurav" {
    vpc_id = aws_vpc.abcdefg.id
    tags ={
        Name = "gg"
    }
  
}


resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.abcdefg.id

  route {
    cidr_block     = "0.0.0.0/0"  
    gateway_id     = aws_internet_gateway.gaurav.id  
  }

  tags = {
    Name = "MyRouteTable"
  }
}

  

  
resource "aws_security_group" "scoobydo" {
    vpc_id = aws_vpc.abcdefg.id
    tags = {
      Name = "bdbddh"
      
    }

     ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
     }

      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_instance" "web" {
    ami = "ami-06b21ccaeff8cd686"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.rushi.id
    vpc_security_group_ids = [aws_security_group.scoobydo.id]
    tags = {
        Name = "App-Server"
    }
}

variable "ingress_ports" {
  type = list(number)
  default = [25,80,443,3306,3389,8080]
}

variable "egress_ports" {
  type = list(number)
  default = [443,8443]
}

resource "aws_instance" "ec2" {
  ami             = "ami-0323c3dd2da7fb37d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_traffic.name]
  tags = {
    Name = "SG EC2"
  }
}
resource "aws_security_group" "web_traffic" {
  name = "Allow HTTPS"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egress_ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
output "expected" {
  value = [for i in var.ingress_ports : "PORT ${i} expected to be open"]
}
output "Confirmed" {
  value = [for i in var.ingress_ports : "PORT ${i} this ports are confirmed"]
}

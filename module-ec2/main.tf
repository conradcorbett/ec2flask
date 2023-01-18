terraform {
  required_version = ">= 0.12"
}

data "aws_subnet" "subnet-seesquared-public" {
  filter {
    name = "tag:Name"
    values = ["SeeSquared-us-west-2-subnet-public1-us-west-2a"]
  }
}

resource "aws_security_group" "sg-flask" {
  name = "sg_${var.name}"
  vpc_id = var.vpc_id
  tags = {
    Name = "sg-${var.name}"
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  ingress {
    description      = "flaskweb"
    from_port        = 5000
    to_port          = 5000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "instance" {
  instance_type               = "t2.small"
  ami                         = "ami-0ceecbb0f30a902a6"
  subnet_id                   = data.aws_subnet.subnet-seesquared-public.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [ aws_security_group.sg-flask.id ]
  key_name                    = var.public_key
  tags                        = var.tags
#  user_data                   = templatefile("${path.module}/configs/${var.name}.tpl", { vm_name = var.name })

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/keys/awskey.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo wget -O flask.sh https://raw.githubusercontent.com/conradcorbett/ec2flask/master/module-ec2/configs/flask/flask.sh",
      "sudo chmod +x /home/ec2-user/flask.sh",
      "sudo wget -O app.py https://raw.githubusercontent.com/conradcorbett/ec2flask/master/module-ec2/configs/flask/app.py",
      "sudo wget -O db.yaml https://raw.githubusercontent.com/conradcorbett/ec2flask/master/module-ec2/configs/flask/db.yaml",
      "sudo mkdir templates",
      "sudo wget -O templates/index.html https://raw.githubusercontent.com/conradcorbett/hcpdemo/master/flaskapp/templates/index.html",
      "sudo wget -O templates/users.html https://raw.githubusercontent.com/conradcorbett/hcpdemo/master/flaskapp/templates/users.html",
      "sudo ./flask.sh",
      "echo mysql_password: ${var.db_password} >> /home/ec2-user/db.yaml",
      #"sudo chmod +x /home/ubuntu/postgres.sh",
      #"sudo ./postgres.sh",
      #"sudo wget -O hello.sql https://raw.githubusercontent.com/conradcorbett/ec2postgres/master/module-ec2/configs/hello.sql",
      #"sudo chmod +x /home/ubuntu/hello.sql",
      #"/postgres/bin/psql -U postgres -f /home/ubuntu/hello.sql"
    ]
  }

}

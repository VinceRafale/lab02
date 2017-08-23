provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "webserver1" {
  count = "${var.instance_count}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${element(data.terraform_remote_state.vpc.subnet_ids, count.index)}"
  key_name               = "lab02keypair"
  vpc_security_group_ids = ["${aws_security_group.allowHttpSsh.id}"]
  user_data              = "${data.template_file.webserverInit.template}"

  tags {
    Name = "webserver1"
  }
}

resource "aws_security_group" "allowHttpSsh" {
  name        = "allow_http_ssh"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "webserverInit" {
  template = "${file("userdata.tpl")}"

  vars = {
    username = "vince"
  }
}

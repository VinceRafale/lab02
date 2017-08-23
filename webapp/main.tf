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

#resource "aws_instance" "webserver1" {
#  count                  = "${var.instance_count}"
#  ami                    = "${data.aws_ami.ubuntu.id}"
#  instance_type          = "${var.instance_type}"
#  subnet_id              = "${element(data.terraform_remote_state.vpc.subnet_ids, count.index)}"
#  key_name               = "lab02keypair"
#  vpc_security_group_ids = ["${aws_security_group.allowHttpSsh.id}"]
#  user_data              = "${data.template_file.webserverInit.rendered}"

#  tags {
#    Name = "webserver1"
#  }
#}

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
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elbhttp.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elbhttp" {
  name        = "elbhttp"
  description = "Allow http inbound traffic"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

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

resource "aws_elb" "pubElbProd" {
  name    = "public-elb-prod"
  subnets = ["${data.terraform_remote_state.vpc.subnet_ids}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 5
  }

# instances       = ["${aws_instance.webserver1.*.id}"]
  security_groups = ["${aws_security_group.elbhttp.id}"]

  tags {
    Name = "public-elb-prod"
  }
}

data "template_file" "webserverInit" {
  template = "${file("userdata.tpl")}"

  vars = {
    username = "vince"
  }
}

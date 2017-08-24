provider "aws" {
  region = "eu-west-1"
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
    DevelopedBy = "D2SI"
  }
}

data "template_file" "webserverInit" {
  template = "${file("userdata.tpl")}"

  vars = {
    username = "vince"
  }
}

resource "aws_autoscaling_group" "pubAsgProd" {
  availability_zones        = ["eu-west-1a", "eu-west-1b"]
  name                      = "asg-${aws_launch_configuration.asgconf.name}"
  max_size                  = "${var.asgmax}"
  min_size                  = "${var.asgmin}"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.asgconf.id}"
  load_balancers = ["${aws_elb.pubElbProd.id}"]
  vpc_zone_identifier = ["${data.terraform_remote_state.vpc.subnet_ids}"]

  lifecycle {
   create_before_destroy = true
  }

  tag {
    key                 = "name"
    value               = "public-asg-prod"
    propagate_at_launch = true 
  }
}

resource "aws_launch_configuration" "asgconf" {
  name_prefix   = "web_config"
  image_id      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.webserverInit.rendered}" 
  security_groups = ["${aws_security_group.allowHttpSsh.id}"]
  key_name        = "lab02keypair"

  lifecycle {
   create_before_destroy = true
  }
}

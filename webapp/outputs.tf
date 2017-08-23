output "webserver_ip" {
  value = ["${aws_instance.webserver1.*.public_ip}"]
}

output "elb_ip" {
  value = "${aws_elb.pubElbProd.dns_name}"
}

output "elb_dns_name" {
  value = "${aws_elb.pubElbProd.dns_name}"
}

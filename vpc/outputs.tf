output "vpc_id" {
  value = "${aws_vpc.vpcProd.id}"
}

output "subnet_ids" {
  value = ["${aws_subnet.vpcProdSubnet1a.id}", "${aws_subnet.vpcProdSubnet1b.id}"]
}

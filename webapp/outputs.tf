output "webserver_ip" {
  value = "${aws_instance.webserver1.public_ip}"
}

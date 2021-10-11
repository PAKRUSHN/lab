output "pwnbox_ip" {
  value = aws_instance.pakrushn_node[0].public_dns
}


# -- network?outputs.tf --

output "vpc_id" {
  value = aws_vpc.pakrushn_vpc.id
}
output "public_sg" {
  value = aws_security_group.pakrushn_sg["public"].id
}
output "public_subnets" {
  value = aws_subnet.pakrushn_public_subnet.*.id
}
output "juiceshop_sg" {
  value = aws_security_group.pakrushn_sg["juiceshop"].id
}



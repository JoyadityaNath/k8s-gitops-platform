output "subnet_eks" {
  value = [for subnet in aws_subnet.private_subnets: subnet.id]
}
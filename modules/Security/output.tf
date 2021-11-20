output "ALB-sg" {
  value = aws_security_group.ACS["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.ACS["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.ACS["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.ACS["nginx-sg"].id
}


output "web-sg1" {
  value = aws_security_group.ACS["tooling"].id
}

output "web-sg2" {
  value = aws_security_group.ACS["wordpress"].id
}

output "datalayer-sg" {
  value = aws_security_group.ACS["datalayer-sg"].id
}
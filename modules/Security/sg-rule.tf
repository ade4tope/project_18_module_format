# security group for alb, to allow acess from any where on port 80 for http traffic
# resource "aws_security_group_rule" "inbound-alb-http" {
#   from_port         = 80
#   protocol          = "tcp"
#   to_port           = 80
#   type              = "ingress"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.ACS["ext-alb-sg"].id
# }
 

resource "aws_security_group_rule" "inbound-alb-https" {
  from_port         = 80
  protocol          = "tcp"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ACS["ext-alb-sg"].id
}

# security group rule for bastion to allow assh access fro your local machine
resource "aws_security_group_rule" "inbound-ssh-bastion" {
  from_port         = 22
  protocol          = "tcp"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ACS["bastion-sg"].id
}


# security group for nginx reverse proxy, to allow access only from the extaernal load balancer and bastion instance


resource "aws_security_group_rule" "allow_port80_from_ext_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["ext-alb-sg"].id
  security_group_id        = aws_security_group.ACS["nginx-sg"].id
}

resource "aws_security_group_rule" "inbound-nginx-http" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["ext-alb-sg"].id
  security_group_id        = aws_security_group.ACS["nginx-sg"].id
}


resource "aws_security_group_rule" "inbound-bastion-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["bastion-sg"].id
  security_group_id        = aws_security_group.ACS["nginx-sg"].id
}



# security group for ialb, to have acces only from nginx reverser proxy server


resource "aws_security_group_rule" "allow_nginx_ingress_port80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ACS["int-alb-sg"].id
}
resource "aws_security_group_rule" "allow_nginx_ingress_port443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ACS["int-alb-sg"].id
}



# security group for webservers, to have access only from the internal load balancer and bastion instance



resource "aws_security_group_rule" "allow_HTTP_from_internal_alb_to_tooling" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["int-alb-sg"].id
  security_group_id        = aws_security_group.ACS["tooling"].id
}

resource "aws_security_group_rule" "inbound-bastion-ssh-to-tooling" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["bastion-sg"].id
  security_group_id        = aws_security_group.ACS["tooling"].id
}

resource "aws_security_group_rule" "allow_HTTP_from_internal_alb_to_wordpress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["int-alb-sg"].id
  security_group_id        = aws_security_group.ACS["wordpress"].id
}

resource "aws_security_group_rule" "inbound-bastion-ssh-to-wordpress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["bastion-sg"].id
  security_group_id        = aws_security_group.ACS["wordpress"].id
}




# security group for datalayer to alow traffic from websever on nfs and mysql port and bastiopn host on mysql port

resource "aws_security_group_rule" "allow_from_tooling_web_to_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["tooling"].id
  security_group_id        = aws_security_group.ACS["datalayer-sg"].id
}

resource "aws_security_group_rule" "allow_from_wordpress_web_to_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["wordpress"].id
  security_group_id        = aws_security_group.ACS["datalayer-sg"].id
}


resource "aws_security_group_rule" "allow_from_tooling_web_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["tooling"].id
  security_group_id        = aws_security_group.ACS["datalayer-sg"].id
}
resource "aws_security_group_rule" "allow_from_wordpress_web_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ACS["wordpress"].id
  security_group_id        = aws_security_group.ACS["datalayer-sg"].id
}
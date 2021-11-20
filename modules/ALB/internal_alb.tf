
# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "internal-alb" {
  name     = "prj-15-internal-alb"
  internal = true

  security_groups = [var.private-sg]

  subnets = [var.private-sbn-1,
  var.private-sbn-2, ]

    tags = merge(
    var.tags,
    {
      Name = "ACS-int-alb"
    },
  )

  ip_address_type    = var.ip_address_type
  # load_balancer_type = var.load_balancer_type
}


# --- target group  for wordpress -------

resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name     = "prj-15-wordpress-tgt"
   port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  }




# --- target group for tooling -------

resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = 10
    path                = "/healthstatus"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "prj-15-tooling-tgt"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}


# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes


resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.internal-alb.arn
  port              = 80
  protocol          = "HTTP"
#   certificate_arn   = aws_acm_certificate_validation.ibk.certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}

# listener rule for tooling target

resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.ibk.monster"]
    }
  }
}
# listener rule for Wordpress target

resource "aws_lb_listener_rule" "wordpress-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }

  condition {
    host_header {
      values = ["wordpress.ibk.monster"]
    }
  }
}

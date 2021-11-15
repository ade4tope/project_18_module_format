# attaching autoscaling group of nginx to external load balancer
# resource "aws_autoscaling_attachment" "asg_attachment_nginx" {
#   autoscaling_group_name = aws_autoscaling_group.nginx-asg.id
#   alb_target_group_arn   = var.nginx-alb-tgt
# }


# attaching autoscaling group of  wordpress application to internal loadbalancer
# resource "aws_autoscaling_attachment" "asg_attachment_wordpress" {
#   autoscaling_group_name = aws_autoscaling_group.wordpress-asg.id
#   alb_target_group_arn   = var.wordpress-alb-tgt
# }

# attaching autoscaling group of  tooling application to internal loadbalancer
# resource "aws_autoscaling_attachment" "asg_attachment_tooling" {
#   autoscaling_group_name = aws_autoscaling_group.tooling-asg.id
#   alb_target_group_arn   = var.tooling-alb-tgt
# }
# launch template for bastion

resource "aws_launch_template" "bastion-launch-template" {


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami-bastion
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = var.bastion-sg
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }
  monitoring {
    enabled = true
  }
  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"


    tags = merge(
      var.tags,
      {
        Name = "bastion-launch-template"
      },
    )

  }

  user_data = filebase64("${path.module}/bastion.sh")
}


# launch template for nginx

resource "aws_launch_template" "nginx-launch-template" {

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami-nginx
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = var.nginx-sg
  instance_initiated_shutdown_behavior = "terminate"

  iam_instance_profile {
    name = var.instance_profile
  }

  key_name = var.keypair

  placement {
    availability_zone = "random_shuffle.az_list.result"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "nginx-launch-template"
      },
    )
  }

  user_data = filebase64("${path.module}/nginx.sh")
}
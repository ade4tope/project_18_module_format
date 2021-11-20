# launch template for wordpress

resource "aws_launch_template" "wordpress-launch-template" {

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami-web
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = var.web-sg2
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
        Name = "wordpress-launch-template"
      },
    )
  }

  user_data = filebase64("${path.module}/wordpress.sh")
}


# launch template for toooling
resource "aws_launch_template" "tooling-launch-template" {


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }

  image_id                             = var.ami-web
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = var.web-sg1
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

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"


    tags = merge(
      var.tags,
      {
        Name = "tooling-launch-template"
      },
    )
  }

  user_data = filebase64("${path.module}/tooling.sh")
}

##Launch template
resource "aws_launch_template" "default" {
  name                   = "${var.general_config["project"]}-${var.general_config["env"]}-eks-node-template"
  update_default_version = false

  #image_id = var.node_group_ec2_image_id
  key_name = var.key_pair_id

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.node_group_volume_size
      volume_type           = var.node_group_volume_type
      encrypted             = true
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.general_config["project"]}-${var.general_config["env"]}-eks-node-template"
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [
      var.internal_sg_id
    ]

    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [
      #image_id
    ]
  }

}
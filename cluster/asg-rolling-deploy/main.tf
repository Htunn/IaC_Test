resource "aws_autoscaling_group" "example" {
    # Explicitly depend on the launch configuration's name so each time
    # it's replaced, this ASG is also replaced
    name = "${var.cluster_name}-${aws_launch_configuration.example.name}"

    launch_configuration = aws_launch_configuration.example.name
    vpc_zone_identifier = var.subnet_ids

    # Configure integrations with a load balancer
    target_group_arns = var.target_group_arns
    health_check_type = var.health_check_type

    min_size = var.min_size
    max_size = var.max_size

    # Wait for at least this many instances to pass health checks before
    # considering the ASG deployment complete
    min_elb_capacity = var.min_size

    # (...)
}

resource "aws_launch_configuration" "example" {
    image_id = var.ami
    instance_type = var.instance_type
    security_groups = [aws_security_group.instance.id]
    user_data = var.user_data

    # Required when using a launch configuration with an autoscaling group

    lifecycle {
        create_before_destroy = true
    }
}
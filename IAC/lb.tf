resource "aws_lb" "quest-elb" {

  name = "quest-lb"
  load_balancer_type = "network"
  internal = false
  subnets = [aws_subnet.quest2a.id , aws_subnet.quest2b.id ]
  depends_on = [
   aws_internet_gateway.gw,
   aws_subnet.quest2a,
   aws_subnet.quest2b 
  ]
  
   tags = {
    Environment = "quest"
  }

  
}

resource "aws_lb_target_group" "quest" {
  name     = "quest"
  port     = 3000 
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.quest.id
  health_check {
    interval = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
  depends_on = [
    aws_lb.quest-elb,
    aws_vpc.quest
  ]

}


resource "aws_lb_target_group_attachment" "quest-service-lb-attachment" {
  target_group_arn = aws_lb_target_group.quest.arn
  target_id        = data.aws_network_interface.cluster_interface.private_ip
  port             = 3000
depends_on = [
   aws_lb_target_group.quest,
   aws_ecs_service.quest-ecs-service
  ]
}

resource "aws_lb_listener" "quest-listener" {
  load_balancer_arn = aws_lb.quest-elb.arn
  port              = "3000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
  depends_on = [
   aws_lb_target_group.quest
  ]

}

resource "aws_lb_listener" "quest-listener-ssl" {
  load_balancer_arn = aws_lb.quest-elb.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.quest.arn
  }
  depends_on = [
   aws_lb_target_group.quest
  ]

}


output "URL" {
  value = "https://${aws_lb.quest-elb.dns_name}" 
  
}








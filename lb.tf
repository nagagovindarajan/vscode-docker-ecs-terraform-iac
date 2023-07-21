resource "aws_alb" "vscode-alb" {
  name               = "vscode-alb"
  internal           = false
  load_balancer_type = "application"

  subnets         = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  security_groups = [aws_security_group.lb-sg.id]

  tags = {
    Name = "vscode-alb"
  }
}

resource "aws_alb_listener" "vscode-alb-listener" {
  load_balancer_arn = aws_alb.vscode-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type          = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "vscode_https_listener" {
  load_balancer_arn = aws_alb.vscode-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.app_certificate.arn
  default_action {   
        target_group_arn = "${aws_alb_target_group.vscode-target-group.arn}"
        type = "forward"   
  } 
}

resource "aws_alb_target_group" "vscode-target-group" {
  name        = "vscode-target-group"
  port        = 8443
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    interval            = 60
    path                = "/"
    matcher             = "302"
  }
}
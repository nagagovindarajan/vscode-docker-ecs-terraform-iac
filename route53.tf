resource "aws_route53_zone" "vscode-cloud" {
  name = "apps.vscode.cloud"
}

resource "aws_route53_record" "vscode-record" {
  zone_id = aws_route53_zone.vscode-cloud.zone_id
  name    = "code.apps.vscode.cloud"
  type    = "A"
  alias {
    name                   = aws_alb.vscode-alb.dns_name
    zone_id                = aws_alb.vscode-alb.zone_id
    evaluate_target_health = true
  }
}

output "ns-servers" {
  value = aws_route53_zone.vscode-cloud.name_servers
}

resource "aws_acm_certificate" "app_certificate" {
  domain_name       = "*.apps.vscode.cloud"
  validation_method = "DNS"

  tags = {
    Name = "vscode-cloud-certificate"
  }
}

resource "aws_route53_record" "certificate_verification" {
  zone_id = aws_route53_zone.vscode-cloud.zone_id
  name    = tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.app_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 300

  # Ensure the record is associated with the certificate's validation domain
  allow_overwrite = true
}
output "conduktor_address" {
  description = "The URL of the Conduktor console. This will be the Application Load Balancer's DNS name."
  value       = aws_lb.conduktor_load_balancer.dns_name
}
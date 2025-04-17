output "eip" {
  description = "Elastic IP"
  value       = aws_eip.eip.public_ip
}


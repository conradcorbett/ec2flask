output "output" {
  value = <<README

flaskappvm: ssh -i ~/keys/awskey.pem ec2-user@${module.ec2vm.public_ip}

README
}

output "environment" {
    value = var.environment
}
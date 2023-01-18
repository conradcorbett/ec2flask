output "output" {
  value = <<README

flaskappvm: ssh -i ~/keys/awskey.pem ec2-user@${module.ec2vm.public_ip}
website: http://${module.ec2vm.public_ip}:5000

README
}

output "environment" {
    value = var.environment
}
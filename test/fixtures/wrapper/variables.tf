variable "instances_ami" {
  description = "The Amazon Machine Image (AMI) to use for the AWS EC2 instances of the module"
  type = "string"
}

variable "subnet_availability_zone" {
  description = "The isolated, regional location in which to place the subnet of the module"
  type = "string"
}

variable "access_key" {
  description = "AWS access key"
}
variable "secret_key" {
  description = "AWS secret key"
}
variable "region" {
  description = "AWS region"
}

output "reachable_other_host_ip_address" {
  description = "This output is used as an attribute in the reachable_other_host control"

  value = "${module.extensive_kitchen_terraform.reachable_other_host_ip_address}"
}

output "static_terraform_output" {
  description = "This output is used as an attribute in the inspec_attributes control"
  value       = "static terraform output"
}

output "terraform_state" {
  description = "This output is used as an attribute in the state_file control"

  value = "${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate"
}

output "remote_group_public_dns" {
  description = "This output is used to obtain targets for InSpec"

  value = ["${module.extensive_kitchen_terraform.remote_group_public_dns}"]
}

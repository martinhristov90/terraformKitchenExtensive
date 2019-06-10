## This repository is created with learning purposes for Terraform, focusing how to use KitchenCI extensive testing alongside Terraform.

## Purpose :

- It provides a simple example of how to use KitchenCI extensive testing to verify the provisioned with Terraform infrastructure.

## How to install terraform : 

- The information about installing terraform can be found on the HashiCorp website 
[here](https://learn.hashicorp.com/terraform/getting-started/install.html)

## How to setup KitchenCI and RBENV (MacOS Mojave 10.14.5) :

## Setup KitchenCI:

- For using [KitchenCI](https://kitchen.ci/), ruby environment needs to be set up first.
- In a directory of your choice, clone the github repository :
    ```
    git clone https://github.com/martinhristov90/terraformKitchenExtensive.git
    ```
- Change into the directory :
    ```
    cd terraformKitchenExtensive
    ```
- Run `brew install ruby`
- After previous command finish, run `gem install rbenv`, this would give you ability to choose particular version of Ruby. This is a prerequisite.
- Next, [Bundler](https://bundler.io) needs to be installed, run `gem install bundler`, this would provide the dependencies that KitchenCI needs. It is going to install the Gems defined in the `Gemfile`
- Run the following two commands, to setup Ruby environment for the local directory.
    ```bash
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    ```
- Reload your BASH interpreter or apply the changes to the profile :
    ```shell
    source ~/.bash_profile 
    ```
- Verify rbenv is installed properly with :
    ```shell
    type rbenv   # → "rbenv is a function"
    ```
- To install the particular version that we need, run the following command in the project directory:
    ```shell
    rbenv install 2.5.3
    ```
- Set local version to be used with command :
    ```shell
    rbenv local 2.5.3
    ```
- Previous step is going to create a file named .ruby-version, with the following content `2.5.3`
- Install the needed Gems for KitchenCI using Bundle with command :
    ```shell
    bundle install
    ```
- Now you should have KitchenCI installed and running, verify with `bundle exec kitchen list`, the output should look like :
    ```
    Instance                Driver     Provisioner  Verifier   Transport  Last Action    Last Error
    extensive-suite-centos  Terraform  Terraform    Terraform  Ssh        <Not Created>  <None>
    extensive-suite-ubuntu  Terraform  Terraform    Terraform  Ssh        <Not Created>  <None>
    ```

## How to use it :

- Make sure that you are in the project's directory.

- Edit a filed named `env.tfvars` in `test/fixtures/wrapper` with the following content that fits for you:
    ```
    access_key = "YOUR_ACCESS_KEY"
    secret_key = "YOUR_SECRET_KEY"
    region = "YOUR_REGION"
    ```
- Create SSH key pair executing following commands in the project's root directory :
    ```
    cd test/assets/
    ssh-keygen -b 1024 -C "Kitchen-Terraform AWS provider tutorial" -f key_pair -N "" -t rsa
    ```

- Now, `bundle exec kitchen converge` should be used to provision the infrastructure that is going to be tested, the output should look like :
    ```
    --- SNIP ---
    Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

       Outputs:

       reachable_other_host_ip_address = 52.23.193.166

       remote_group_public_dns = [
           ec2-54-210-225-69.compute-1.amazonaws.com,
           ec2-52-206-1-188.compute-1.amazonaws.com
       ]
       static_terraform_output = static terraform output
       terraform_state = /Users/martinhristov/Tasks/TerraformLearn/terraformKitchenExtensive/test/fixtures/wrapper/terraform.tfstate.d/kitchen-terraform-extensive-suite-centos/terraform.tfstate
       Finished converging <extensive-suite-centos> (1m7.24s).
    --- SNIP ---
        Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

       Outputs:

       reachable_other_host_ip_address = 3.84.253.251

       remote_group_public_dns = [
           ec2-54-86-114-207.compute-1.amazonaws.com,
           ec2-3-88-165-183.compute-1.amazonaws.com
       ]
       static_terraform_output = static terraform output
    --- SNIP ---
    ```
- Now, the testing of the AWS instances is going to be performed to verify if they pass Inspec tests. Run `bundle exec kitchen verify` The output should look like :
    ```
    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  local://

      ✔  state_file: 0.11.13
         ✔  0.11.13 should match /\d+\.\d+\.\d+/
      ✔  inspec_attributes: static terraform output
         ✔  static terraform output should eq "static terraform output"
         ✔  static terraform output should eq "static terraform output"


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 3 successful, 0 failures, 0 skipped
    remote: Verifying host ec2-54-210-225-69.compute-1.amazonaws.com

    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  ssh://centos@ec2-54-210-225-69.compute-1.amazonaws.com:22

      ✔  operating_system: centos
         ✔  centos should eq "centos"
      ✔  reachable_other_host: Host 52.23.193.166

         ✔  Host 52.23.193.166
          should be reachable


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 2 successful, 0 failures, 0 skipped
    remote: Verifying host ec2-52-206-1-188.compute-1.amazonaws.com

    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  ssh://centos@ec2-52-206-1-188.compute-1.amazonaws.com:22

      ✔  operating_system: centos
         ✔  centos should eq "centos"
      ✔  reachable_other_host: Host 52.23.193.166

         ✔  Host 52.23.193.166
          should be reachable


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 2 successful, 0 failures, 0 skipped
           Finished verifying <extensive-suite-centos> (0m41.99s).
    -----> Setting up <extensive-suite-ubuntu>...
           Finished setting up <extensive-suite-ubuntu> (0m0.00s).
    -----> Verifying <extensive-suite-ubuntu>...
    $$$$$$ Running command `terraform workspace select kitchen-terraform-extensive-suite-ubuntu` in directory /Users/martinhristov/Tasks/TerraformLearn/terraformKitchenExtensive/test/fixtures/    wrapper
           Switched to workspace "kitchen-terraform-extensive-suite-ubuntu".
    $$$$$$ Running command `terraform output -json` in directory /Users/martinhristov/Tasks/TerraformLearn/terraformKitchenExtensive/test/fixtures/wrapper
    local: Verifying

    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  local://

      ✔  state_file: 0.11.13
         ✔  0.11.13 should match /\d+\.\d+\.\d+/
      ✔  inspec_attributes: static terraform output
         ✔  static terraform output should eq "static terraform output"
         ✔  static terraform output should eq "static terraform output"


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 3 successful, 0 failures, 0 skipped
    remote: Verifying host ec2-54-86-114-207.compute-1.amazonaws.com

    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  ssh://ubuntu@ec2-54-86-114-207.compute-1.amazonaws.com:22

      ✔  operating_system: ubuntu
         ✔  ubuntu should eq "ubuntu"
      ✔  reachable_other_host: Host 3.84.253.251

         ✔  Host 3.84.253.251
          should be reachable


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 2 successful, 0 failures, 0 skipped
    remote: Verifying host ec2-3-88-165-183.compute-1.amazonaws.com

    Profile: Extensive Kitchen-Terraform (extensive_suite)
    Version: 0.1.0
    Target:  ssh://ubuntu@ec2-3-88-165-183.compute-1.amazonaws.com:22

      ✔  operating_system: ubuntu
         ✔  ubuntu should eq "ubuntu"
      ✔  reachable_other_host: Host 3.84.253.251

         ✔  Host 3.84.253.251
          should be reachable


    Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped
    Test Summary: 2 successful, 0 failures, 0 skipped
           Finished verifying <extensive-suite-ubuntu> (0m16.58s).
    -----> Kitchen is finished. (1m2.06s)
    ```
- To destroy the `Kitchen` instances, execute `bundle exec kitchen destroy`.



require "awspec"

reachable_other_host_id =
  # The Terraform configuration under test must define the equivalently named
  # output
  attribute(
    "reachable_other_host_id",
    description: "The ID of the AWS EC2 instance which should be reachable"
  )

control "reachable_other_host" do
  desc "Verifies that the other host is reachable from the current host"

 describe host("#{reachable_other_host_id}", port: 22, protocol: 'tcp') do
    it { should be_reachable }
  end
end
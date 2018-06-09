#! /usr/bin/env bash

mkdir -p /vagrant/test/integration/extensive_suite/controls
touch /vagrant/test/integration/extensive_suite/inspec.yml
touch /vagrant/test/integration/extensive_suite/controls/inspec_attributes.rb
touch /vagrant/test/integration/extensive_suite/controls/operating_system.rb
touch /vagrant/test/integration/extensive_suite/controls/reachable_other_host.rb
touch /vagrant/test/integration/extensive_suite/controls/state_file.rb
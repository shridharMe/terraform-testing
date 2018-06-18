#! /usr/bin/env bash

echo updating package information
yum update -y >/dev/null 2>&1

echo installing development/networking tools and EPEL repos
yum install -y net-tools build-essential epel-release  >/dev/null 2>&1
yum install -y rubygems

 
echo installing Ruby 2.4.4 via RVM

if su - vagrant -c ' gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'; then
   echo "key download successfuly"
else 
     echo "key download successfuly in 2nd attempt"
    su - vagrant -c  'curl -sSL https://rvm.io/mpapis.asc | gpg2 --import'
fi 



su - vagrant -c 'curl -sSL https://get.rvm.io | bash -s stable'  # >/dev/null 2>&1
su - vagrant -c 'rvm rvmrc warning ignore allGemfiles'  #>/dev/null 2>&1
su - vagrant -c 'source $HOME/.rvm/scripts/rvm'  >> ~/.bash_profile
su - vagrant -c 'rvm install "ruby-2.4.4"'


echo "installing bundler"
su - vagrant -c 'gem install bundler'  #>/dev/null 2>&1

su - vagrant -c 'rvm use  2.4.4 --default'     
su - vagrant -c 'gem install kitchen-terraform --version 3.3.1'
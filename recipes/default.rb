#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

isapache2 = true

if File.exist?('/etc/init.d/apache2')
  isapache2 = false
end

bash 'Installing apache2' do
	code <<-EOH
      set -e
      sudo apt-get update
      sudo apt-get upgrade -y
      sudo apt-get install -y apache2
      EOH
    only_if { isapache2 == true }
end


isjava = true

if File.exist?('/usr/bin/java')
  isjava = false
end

bash 'Installing OpenJDK 7' do
	code <<-EOH
      set -e
      sudo apt-get update
      sudo apt-get install -y openjdk-7-jre
      sudo apt-get install -y openjdk-7-jdk
      EOH
    only_if { isjava == true }
end


isjenkin = true

if File.exist?('/etc/init.d/jenkins')
  isjenkin = false
end

bash 'Installing jenkins' do
	code <<-EOH
      set -e
      sudo wget -q -O - http://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
      sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
      sudo apt-get update
      sudo apt-get install -y jenkins
      EOH
    only_if { isjenkin == true }
end

service "jenkins" do
  supports :status => true, :reload => true, :restart => true
  action [:enable, :start]
end

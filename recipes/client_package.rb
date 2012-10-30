#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: nagios
# Recipe:: client_package
#
# Copyright 2011, Opscode, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node['platform']
when "smartos"
  %w{
    nagios-nrpe
    nagios-plugins
  }.each do |pkg|
    package pkg
  end
  
  # need to copy over all plugins from /opt/local/libexec on smartos
  # cp /opt/local/libexec/nagios/* /opt/local/lib/nagios/plugins/  
  execute "copy nrpe checks from libexec" do
    command "cp /opt/local/libexec/nagios/* /opt/local/lib/nagios/plugins/"
    notifies :restart, resources(:service => node['nagios']['nrpe']['service_name'])
    not_if {File.exists?("/opt/local/lib/nagios/plugins/check_nrpe")}
  end

else
  %w{
    nagios-nrpe-server
    nagios-plugins
    nagios-plugins-basic
    nagios-plugins-standard
  }.each do |pkg|
    package pkg
  end
end



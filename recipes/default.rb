#
# Cookbook Name:: ihs_main
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
im_zip_dir = node[:iim][:zip_path]
ihs_zip_dir = node[:ihs][:zip_path]
im_zip_file = node[:iim][:zip_file]
ihs_zip_file = node[:ihs][:zip_file]
im_s3_url = node[:iim][:s3_url]
ihs_s3_url = node[:ihs][:s3_url]

package "unzip"

[im_zip_dir, ihs_zip_dir].each do |dirname|
  directory dirname do
    mode '0755'
    recursive true
  end
end

remote_file im_zip_file do
  source im_s3_url
  mode '0755'
  action :create
end

#remote_file ihs_zip_file do
#  source ihs_s3_url
#  mode '0755'
#  action :create
#end

execute "unpack #{ihs_zip_file}" do
  cwd ihs_zip_dir
  command "unzip #{ihs_zip_file}"
  not_if { ::File.directory? ("#{ihs_zip_dir}/IHS") }
end

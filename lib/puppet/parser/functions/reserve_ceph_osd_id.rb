
module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
      	require 'open3'
        stdin, stdout, stderr = Open3.popen3('ls /')
        return stdout
      end
    end

module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
        return '2'
      end
    end

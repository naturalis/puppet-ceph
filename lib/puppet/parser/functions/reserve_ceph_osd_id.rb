module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
        val = system 'cat /tmp/test.file'
        return '7'
      end
    end

module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
        system '/usr/bin/ceph osd create --keyring /tmp/monitor.keyring'
      end
    end

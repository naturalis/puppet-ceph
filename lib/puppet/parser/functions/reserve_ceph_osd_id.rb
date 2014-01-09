module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
      	keyringfile = args[0]
        #system '/usr/bin/ceph osd create --keyring /tmp/monitor.keyring'
        return '5 #{keyringfile}'
      end
    end

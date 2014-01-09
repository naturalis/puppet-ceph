module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
      	#keyringfile = args[0]
        #system '/usr/bin/ceph osd create --keyring /tmp/monitor.keyring'
        #system 'cat /tmp/test.file'
        system '/bin/echo "4"'
        #return keyringfile
      end
    end

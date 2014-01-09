
module Puppet::Parser::Functions
      newfunction(:reserve_ceph_osd_id, :type => :rvalue) do |args|
      	#require 'open3'
        #stdin, stdout, stderr = Open3.popen3('cat',@options['/tmp/test.file'])
        #return stdout
        #out = IO.popen(["cat","/tmp/test.file"]).read
        #return out
        file = File.open("/tmp/test.file","rb")
        contents = file.read
        return contents
      end
    end

# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   Summarise what the function does here
#
Puppet::Functions.create_function(:'reserve_ceph_osd_id') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
      	#require 'open3'
        #stdin, stdout, stderr = Open3.popen3('cat',@options['/tmp/test.file'])
        #return stdout
        #out = IO.popen(["cat","/tmp/test.file"]).read
        #return out
        file = File.open("/tmp/test.file","r")
        contents = file.read
        return contents
      
  end
end

define ceph::osd::prepare (
	$disk  		= $title,
)
{
  
  exec { "${fqdn}-${disk}-generate-osd-id-fact":
    command => "/bin/ls -l /etc/facter/facts.d | /usr/bin/wc -l > /etc/facter/facts.d/${fqdn}-${disk}-osd.txt",
    require => File["${fqdn}-factor-sub-dir"],
    unless  => "/usr/bin/test -f /etc/facter/facts.d/${fqdn}-${disk}-osd.txt",
  }

}
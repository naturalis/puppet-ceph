define ceph::osd::prepare (
	$disk  		= $title,
)
{
  
  exec { "${fqdn}-${disk}-generate-osd-id-fact":
    command => "/usr/bin/python generate_ceph_osd_id_fact.py ${disk}",
    require => File["${fqdn}-osd-generate-script"],
    unless  => "/bin/grep ${disk} /etc/facter/facts.d/ceph-osd-id-array.txt",
  }
}
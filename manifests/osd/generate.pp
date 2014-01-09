define ceph::osd::generate (
	$disk  		= $title,
)
{
  
  $osd_id = reserve_ceph_osd_id()

  notify {"osdnumber-${osd_id}-${disk}":
    message => $osd_id,
    require => File["${fqdn}-osd-temp-keyring"],
  }

}


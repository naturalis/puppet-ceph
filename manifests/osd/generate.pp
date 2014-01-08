define ceph::osd::generate (
    $osd_id     = reserve_ceph_osd_id(),
	$disk  		= $title,
)
{

  notify {"osdnumber-${osd_id}-${disk}":
    message => $osd_id,
    require => File["${fqdn}-osd-temp-keyring"]
  }

}


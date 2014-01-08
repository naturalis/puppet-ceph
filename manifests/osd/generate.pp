define ceph::osd::generate (
    $osd_id,
	$disk  		= $tile
)
{

  notify {"osdnumber-${osd_id}-${disk}":
    message => $osd_id,
    require => File["${fqdn}-osd-temp-keyring"]
  }

}


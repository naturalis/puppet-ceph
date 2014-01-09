define ceph::osd::generate (
	$disk  		= $title,
	$id,
)
{
  
  $osd_id = reserve_ceph_osd_id()
  
  notify {"test-${disk}":
    message => 'shit',
  }

  notify {"test2-${disk}":
    message => $id,
  }

  notify {"osdnumber-${osd_id}-${disk}":
    message => $osd_id,
    require => File["${fqdn}-osd-temp-keyring"],
  }

}


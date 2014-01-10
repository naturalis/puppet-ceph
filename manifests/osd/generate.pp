define ceph::osd::generate (
	$disk_id 		= $title,
)
{
  $split = split($disk_id,'-')
  $disk = $split[0]
  $id = $split[1]

  notify{"disk-{$disk}":}
  notify{"id-{$disk}":}
  

}


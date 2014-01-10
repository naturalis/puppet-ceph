define ceph::osd::generate (
	$disk-id 		= $title,
)
{
  
  $disk = split($disk-id,'-')[0]
  $id = split($disk-id,'-')[1]

  notify{$disk:}
  notify{$id:}
  

}


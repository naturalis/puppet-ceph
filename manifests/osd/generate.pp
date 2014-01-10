define ceph::osd::generate (
	$disk_id 		= $title,
)
{
  
  $disk = split($disk_id,'-')[0]
  $id = split($disk_id,'-')[1]

  notify{$disk:}
  notify{$id:}
  

}


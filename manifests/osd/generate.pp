define ceph::osd::generate (
	$disk_id 		= $title,
)
{
  $split = split($disk_id,'-')
  $disk = $split[0]
  $id = $split[1]

  
  @@ini_setting { "ceph-config-${fqdn}-osd-{$disk}-{$id}-mount":
      path    => '/etc/ceph/ceph.conf',
      section => "osd",
      setting => "osd mount options" ,
      value   => "rw,noatime,inode64",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  @@ini_setting { "ceph-config-${fqdn}-osd-{$disk}-{$id}-fs":
      path    => '/etc/ceph/ceph.conf',
      section => "osd",
      setting => "osd mkfs type" ,
      value   => "xfs",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  @@ini_setting { "ceph-config-${fqdn}-osd-{$disk}-{$id}-host":
      path    => '/etc/ceph/ceph.conf',
      section => "osd.${id}",
      setting => "host" ,
      value   => "${hostname}",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }
  
  @@ini_setting { "ceph-config-${fqdn}-osd-{$disk}-{$id}-dev":
      path    => '/etc/ceph/ceph.conf',
      section => "osd.${id}",
      setting => "devs" ,
      value   => "/dev/${disk}",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  Ini_setting <<| tag == "cephconf-${fsid}" |>>
}


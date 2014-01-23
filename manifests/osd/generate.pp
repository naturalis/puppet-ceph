define ceph::osd::generate (
	$disk_id 		= $title,
  $rack,
  $datacenter,
  $fsid,
)
{
  $split = split($disk_id,'-')
  $disk = $split[0]
  $id = $split[1]
  notify{$fsid:}

  #$rack = $ceph::osd::datacenter
  #$dc = $ceph::osd:room

  @@ini_setting { "ceph-config-${fqdn}-osd-${disk}-${id}-mount":
      path    => '/etc/ceph/ceph.conf',
      section => "osd",
      setting => "osd mount options" ,
      value   => "rw,noatime,inode64",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  @@ini_setting { "ceph-config-${fqdn}-osd-${disk}-${id}-fs":
      path    => '/etc/ceph/ceph.conf',
      section => "osd",
      setting => "osd mkfs type" ,
      value   => "xfs",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  @@ini_setting { "ceph-config-${fqdn}-osd-${disk}-${id}-host":
      path    => '/etc/ceph/ceph.conf',
      section => "osd.${id}",
      setting => "host" ,
      value   => "${hostname}",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }
  
  @@ini_setting { "ceph-config-${fqdn}-osd-${disk}-${id}-dev":
      path    => '/etc/ceph/ceph.conf',
      section => "osd.${id}",
      setting => "devs" ,
      value   => "/dev/${disk}",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  Ini_setting <<| tag == "cephconf-${fsid}" |>>

  file { "${fqdn}-${id}-osd-dir":
    path  	=> "/var/lib/ceph/osd/ceph-${id}",
    ensure 	=> "directory",
    require => File["${fqdn}-osd-base-dir"],
  }

  exec {"${disk}-${id}-part":
  	command => "/sbin/mkfs.xfs -f /dev/${disk}",
  	unless  => "/sbin/parted /dev/${disk} print | grep xfs",
  }

  exec {"${disk}-${id}-mount":
  	command 	=> "/bin/mount -o noatime,inode64 /dev/${disk} /var/lib/ceph/osd/ceph-${id}",
  	unless 	 	=> "/bin/mount | grep ${disk}",
  	require   => [Exec["${disk}-${id}-part"],File["${fqdn}-${id}-osd-dir"]]
  }

  exec {"${disk}-${id}-mkfs-run-1":
  	command 	=> "/usr/bin/ceph-osd -i ${id} --mkfs --mkkey",
  	unless 	 	=> "/usr/bin/test -f /var/lib/ceph/osd/ceph-${id}/keyring",
  	require   => Exec["${disk}-${id}-mount"],
    tries     => '2',
  }


  
  #exec {"${disk}-${id}-mkfs-run-2":
 # 	command 	=> "/usr/bin/ceph-osd -i ${id} --mkfs --mkkey",
 # 	unless 	 	=> "/usr/bin/test -f /var/lib/ceph/osd/ceph-${id}/keyring",
 # 	require     => Exec["${disk}-${id}-mkfs-run-1"]
 # }


  exec {"${disk}-${id}-crush-location":
    command   => "/usr/bin/ceph -k /tmp/monitor.keyring osd crush add osd.${id} 1.0 root=default datacenter=${datacenter} rack=${rack} host=${hostname}",
    unless    => "/usr/bin/ceph -k /tmp/monitor.keyring osd tree | /bin/grep osd.${id} | /bin/grep -P '${id}\t1'",
    require   => Exec["${disk}-${id}-mkfs-run-1"]
  }

  exec {"${disk}-${id}-keys":
  	command 	=> "/usr/bin/ceph -k /tmp/monitor.keyring auth add osd.${id} osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-${id}/keyring",
  	unless 	 	=> "/usr/bin/ceph auth get osd.${id}  -k /tmp/monitor.keyring | /bin/grep 'caps osd'",
  	require   =>[Exec["${disk}-${id}-mkfs-run-1"],Exec["${disk}-${id}-crush-location"]]
  }

  exec {"${disk}-${id}-umount":
  	command 	=> "/bin/umount /var/lib/ceph/osd/ceph-${id}",
  	unless 	 	=> "/bin/ps aux | /bin/grep 'ceph-osd -i ${id}' | /bin/grep -v grep",
  	require   => Exec["${disk}-${id}-keys"]
  }

  #service {"ceph-osd-${disk}-${id}":
  #  ensure  => 'running',
  #  enable  => 'true',
  #  start   => 'service ceph start osd',
  #  stop    => 'service ceph stop osd',
  #  restart => 'service ceph restart osd',
  #  require => Exec["${disk}-${id}-umount"]
  #} 

  exec {"ceph-service-osd-${disk}-${id}":
    command => "/usr/sbin/service ceph start osd.${id}",
    unless    => "/bin/ps aux | /bin/grep 'ceph-osd -i ${id}' | /bin/grep -v grep",
    require   => Exec["${disk}-${id}-umount"],
  }

}


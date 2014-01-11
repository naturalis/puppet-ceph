define ceph::osd::generate (
	$disk_id 		= $title,
)
{
  $split = split($disk_id,'-')
  $disk = $split[0]
  $id = $split[1]

  
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
  	command 	=> "/usr/bin/ceph-osd -i ${id} --mkfs --mkkey -k /var/lib/ceph/osd/ceph-${id}/keyring",
  	unless 	 	=> "/usr/bin/test -d /var/lib/ceph/osd/ceph-${id}/whoami",
  	require   => Exec["${disk}-${id}-mount"],
    tries     => '2',
  }


  #
  #exec {"${disk}-${id}-mkfs-run-2":
 # 	command 	=> "/usr/bin/ceph-osd -i ${id} --mkfs --mkkey",
 # 	unless 	 	=> "/usr/bin/test -d /var/lib/ceph/osd/ceph-${id}/whoami",
 # 	require     => Exec["${disk}-${id}-mkfs-run-1"]
 # }

  exec {"${disk}-${id}-keys":
  	command 	=> "/usr/bin/ceph -k /tmp/monitor.keyring auth add osd.${id} osd 'allow *' mon 'allow rwx' -i /var/lib/ceph/osd/ceph-${id}/keyring",
  	unless 	 	=> "/bin/grep 'allow *' /var/lib/ceph/osd/ceph-${id}/keyring",
  	require     => Exec["${disk}-${id}-mkfs-run-1"]
  }

  exec {"${disk}-${id}-umount":
  	command 	=> "/bin/umount /var/lib/ceph/osd/ceph-${id}",
  	unless 	 	=> "/usr/bin/test -d /var/lib/ceph/osd/ceph-${id}/keyring",
  	require   => Exec["${disk}-${id}-keys"]
  }

  service {"ceph-osd-${disk}-${id}":
    ensure  => 'running',
    enable  => 'true',
    start   => 'service ceph start osd',
    stop    => 'service ceph stop osd',
    restart => 'service ceph restart osd',
    require => Exec["${disk}-${id}-umount"]
  } 
}


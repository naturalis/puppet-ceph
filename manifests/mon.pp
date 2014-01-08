class ceph::mon (

	$monitorkey,
	$adminkey,
	$fsid,
	$auto_ceph_conf		= 'true',
	$manual_crushmap	= 'false',
	$monitor_port 		= '6789',

)
{
	# JOBS #
	# * send resource for ceph_conf
	# * collect resource for ceph_conf
	# * generate monitor
	# * start service
	# * clean up keyring

  @@ini_setting { "ceph-config-${fqdn}-mon-ip":
      path    => '/etc/ceph/ceph.conf',
      section => "mon.${hostname}",
      setting => "mon addr" ,
      value   => "${ipaddress}:${monitor_port}",
      ensure  => present,
      tag     => 'cephconf'
  }

  @@ini_setting { "ceph-config-${fqdn}-mon-host":
      path    => '/etc/ceph/ceph.conf',
      section => "mon.${hostname}",
      setting => "host" ,
      value   => "${hostname}",
      ensure  => present,
      tag     => 'cephconf'
  }

  Ini_setting <<| tag == 'cephconf' |>>

  file { "${fqdn}-temp-keyring":
     path    => '/etc/ceph/monitor.keyring',
     ensure  => 'file',
     content => template('ceph/monitor.keyring.erb'),
  }

  file { "${fqdn}-ceph-mon-directory":
    path   => "/var/lib/ceph/mon/ceph-${hostname}",
    ensure => "directory",
  }

  exec { "generate-monitor-${hostname}":
    command => "/usr/bin/ceph-mon -i ${hostname} --mkfs --fsid ${fsid} --keyring /etc/ceph/monitor.keyring",
    require => [File["${fqdn}-ceph-mon-directory"],
                File["${fqdn}-temp-keyring"],
                Ini_setting["ceph-config-${fqdn}-mon-host"],
                Ini_setting["ceph-config-${fqdn}-mon-ip"]]
  }
  
  service {"ceph-mon-service":
    ensure  => 'running',
    enable  => 'true',
    start   => 'service ceph start mon',
    stop    => 'service ceph stop mon',
    restart => 'service ceph restart mon',
    require => Exec["generate-monitor-${hostname}"]
  } 
}
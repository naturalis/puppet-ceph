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
      tag     => "cephconf-${fsid}"
  }

  @@ini_setting { "ceph-config-${fqdn}-mon-host":
      path    => '/etc/ceph/ceph.conf',
      section => "mon.${hostname}",
      setting => "host" ,
      value   => "${hostname}",
      ensure  => present,
      tag     => "cephconf-${fsid}"
  }

  Ini_setting <<| tag == "cephconf-${fsid}" |>>

  #file { "${fqdn}-temp-keyring":
  #   path    => '/etc/ceph/monitor.keyring',
  #   ensure  => 'file',
  #   content => template('ceph/monitor.keyring.erb'),
  #}

  
  
  exec { "generate-monitor-key": 
    command => "/usr/bin/ceph-authtool --create-keyring --add-key ${monitorkey}  -n mon. /etc/ceph/monitor.keyring",
  }

  exec { "generate-admin-key": 
    command => "/usr/bin/ceph-authtool /etc/ceph/monitor.keyring --add-key ${adminkey} -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'",
    require => Exec['generate-monitor-key']
  }

  file { "${fqdn}-ceph-mon-base-directory":
    path   => "/var/lib/ceph/mon",
    ensure => "directory",
  }

  file { "${fqdn}-ceph-mon-directory":
    path    => "/var/lib/ceph/mon/ceph-${hostname}",
    ensure  => "directory",
    require => File["${fqdn}-ceph-mon-base-directory"]
  }

  exec { "generate-monitor-${hostname}":
    command => "/usr/bin/ceph-mon -i ${hostname} --mkfs --fsid ${fsid} --keyring /etc/ceph/monitor.keyring",
    require => [File["${fqdn}-ceph-mon-directory"],
                Exec["generate-monitor-key"],
                Ini_setting["ceph-config-${fqdn}-mon-host"],
                Ini_setting["ceph-config-${fqdn}-mon-ip"]]
  }
  
  service {"ceph":
    ensure  => 'running',
    enable  => 'true',
    start   => 'service ceph start mon',
    stop    => 'service ceph stop mon',
    restart => 'service ceph restart mon',
    require => Exec["generate-monitor-${hostname}"]
  } 
}
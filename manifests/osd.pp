class ceph::osd (

	$monitorkey,
	$adminkey,
	$fsid,
	$auto_ceph_conf		= 'true',
	$manual_crushmap	= 'false',
	$crush_root			= 'default',
	$datacenter,
	$room,
	$row,
	$rack,
	$disks,

)
{

  file { "${fqdn}-osd-temp-keyring":
     path    => '/tmp/monitor.keyring',
     ensure  => 'file',
     content => template('ceph/monitor.keyring.erb'),
  }

  file { "${fqdn}-facter-base-dir":
    path   => "/etc/facter",
    ensure => "directory",
  }

  file { "${fqdn}-osd-base-dir":
    path   => "/var/lib/ceph/osd",
    ensure => "directory",
  }

  file { "${fqdn}-facter-sub-dir":
    path    => "/etc/facter/facts.d",
    ensure  => "directory",
    require => File["${fqdn}-facter-base-dir"]
  }

  file {"${fqdn}-osd-generate-script":
    path 	=> "/tmp/generate_ceph_osd_id_fact.py",
    ensure  => 'file',
    content => template('ceph/generate_ceph_osd_id_fact.py.erb'),
    require => File["${fqdn}-facter-sub-dir"]
  }

  

  ceph::osd::prepare{["sdc","sdd"] : }

  if ($ceph_osd_id_array) {
  	#notify {'sldkfjl': }

  	$ceph_osd_id = split($ceph_osd_id_array,',')
  	ceph::osd::generate{ $ceph_osd_id : }
  }

  #$osdnumber = reserve_ceph_osd_id()
  
  	# JOBS #
	# * calculate osd number
	# * send resource for ceph_conf
	# * collect resource for ceph_conf
	# * generate osd
	# * start service
	# * clean up keyring

}
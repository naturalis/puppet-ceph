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

  file { "${fqdn}-factor-base-dir":
    path   => "/etc/facter",
    ensure => "directory",
  }

  file { "${fqdn}-factor-sib-dir":
    path    => "/etc/facter/facts.d",
    ensure  => "directory",
    require => File["${fqdn}-factor-base-dir"]
  }

  Ini_setting <<| tag == "cephconf-${fsid}" |>>

  ceph::osd::prepare{["/dev/sdc","/dev/sdd"] : }

  #$osdnumber = reserve_ceph_osd_id()
  
  	# JOBS #
	# * calculate osd number
	# * send resource for ceph_conf
	# * collect resource for ceph_conf
	# * generate osd
	# * start service
	# * clean up keyring

}
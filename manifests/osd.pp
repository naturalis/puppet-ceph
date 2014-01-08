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

	$osdnumber = reserve_ceph_osd()
	notify { $osdnumber : }
	# JOBS #
	# * calculate osd number
	# * send resource for ceph_conf
	# * collect resource for ceph_conf
	# * generate osd
	# * start service
	# * clean up keyring

}
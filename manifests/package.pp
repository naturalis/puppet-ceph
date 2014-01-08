class ceph::package(
  $ceph_release = 'dumpling'
)
{

	# JOBS #
	# * install ceph packages
  package { 'wget':
    ensure => installed,
  }
  
  exec { 'add-ceph-repo-key':
  	command => "/usr/bin/wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -",
  	require => Package ['wget'],
  }
  
  exec { 'add-ceph-repo':
    command => "/bin/echo deb http://ceph.com/debian-${ceph_release}/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list",
    require => Exec['add-ceph-repo-key'],
  }

  package { 'ceph':
    ensure => installed,
    require => Exec['add-ceph-repo']
  }
  
}
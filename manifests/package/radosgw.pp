class ceph::package::radosgw(
  $ceph_release = 'emperor'
)
{

	# JOBS #
	# * install ceph packages
  package { 'wget':
    ensure => installed,
  }
  
  file{ '/etc/apt/sources.list.d/radosgw.list':
    ensure  => present,
    content => 'deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-precise-x86_64-basic/ref/master/ precise main
deb http://gitbuilder.ceph.com/apache2-deb-precise-x86_64-basic/ref/master/ precise main',
  }

  exec { 'update-apt-get':
    command => '/usr/bin/apt-get update',
    require => File['/etc/apt/sources.list.d/radosgw.list'],
  }
  
  package { 'radosgw' :
    ensure => installed,
    require => Exec['update-apt-get'],
  }
  
}
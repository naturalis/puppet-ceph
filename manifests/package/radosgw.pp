class ceph::package::radosgw(
  $ceph_release = 'emperor'
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
    unless   => "/usr/bin/apt-key list | grep Ceph"
  }
  

  file{ '/etc/apt/sources.list.d/radosgw.list':
    ensure  => present,
    content => 'deb http://gitbuilder.ceph.com/libapache-mod-fastcgi-deb-precise-x86_64-basic/ref/master/ precise main
deb http://gitbuilder.ceph.com/apache2-deb-precise-x86_64-basic/ref/master/ precise main',
    require => Exec['add-ceph-repo-key'],
  }

  exec { 'update-apt-get':
    command => '/usr/bin/apt-get update',
    require => File['/etc/apt/sources.list.d/radosgw.list'],
  }
  
  package { ['radosgw','apache2','libapache2-mod-fastcgi'] :
    ensure => installed,
    require => Exec['update-apt-get'],
  }


 
  
}
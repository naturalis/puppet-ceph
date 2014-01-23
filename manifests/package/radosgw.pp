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
  
  #exec { '/usr/bin/apt-get install -y -q --force-yes libapache2-mod-fastcgi':
  #  require => Exec['update-apt-get'],
  #}

  #exec { '/usr/bin/apt-get install -y -q --force-yes apache2':
  #  require => Exec['update-apt-get'],
  #}
  exec {'get-new-lib-curl':
    command => '/usr/bin/wget -q http://security.ubuntu.com/ubuntu/pool/main/c/curl/libcurl3_7.29.0-1ubuntu3.4_amd64.deb',
    cwd     => '/tmp',
    require => Package ['wget'],
  }

  exe
  force-apt-install { ['apache2','libapache2-mod-fastcgi']:
    require => Exec['update-apt-get'],
  }

  define force-apt-install( $package = $title, ) {
    exec { "/usr/bin/apt-get install -y -q --force-yes ${package}":
      unless =>  "/usr/bin/apt-get install -y -q --force-yes ${package} | /bin/grep newest",
    }
  } 
  
}
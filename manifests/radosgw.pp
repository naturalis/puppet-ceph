class ceph::radosgw (
  $fsid,
  $rados_server_webmaster_alias	= 'aut@naturalis.nl',
)
{
  
  $rados_server_name = $fqdn
  $rados_server_alias = $hostname

  file {'/etc/apache2/sites-available/radosgw.vhost':
   	ensure	=> present,
  	content	=> template('ceph/radosgw.vhost.erb'),
    owner	  => 'root',
    group 	=> 'www-data',
    mode    => '0660',
  }

  file {'/var/www/radosgw.fcgi':
  	ensure   => present,
  	content  => template('ceph/radosgw.fcgi.erb'),
  	owner    => 'root',
    group    => 'www-data',
  	mode     => '0770',
  }

  exec {'/usr/sbin/a2ensite radosgw.vhost':
    unless  => '/usr/bin/test -h /etc/apache2/sites-enabled/radosgw.vhost',
    require => File['/etc/apache2/sites-available/radosgw.vhost'],
    notify  => Service['apache2'],
  }

  exec {'/usr/sbin/a2dissite default':
    onlyif  => '/usr/bin/test -h /etc/apache2/sites-enabled/000-default',
    notify  => Service['apache2'],
  }
 
  exec {'/usr/sbin/a2enmod rewrite':
    unless => '/usr/bin/test -h /etc/apache2/mods-enabled/rewrite.load',
    notify => Service['apache2'],
  }

  exec {'/usr/sbin/a2enmod fastcgi':
    unless => '/usr/bin/test -h /etc/apache2/mods-enabled/fastcgi.load',
    notify => Service['apache2']
  }

  service {'apache2': 
    ensure => 'running',
    enable => true,
  }

  file {['/var/lib/ceph','/var/lib/ceph/radosgw',"/var/lib/ceph/ceph-radosgw.${hostname}"]:
    ensure   => directory,
    owner    => 'root',
    group    => 'root',
    mode     => '0770',
  }

  file {"/var/lib/ceph/ceph-radosgw.${hostname}/done":
    ensure   => present,
    content  => '',
    owner    => 'root',
    group    => 'root',
    mode     => '0660',
    require  => File["/var/lib/ceph/ceph-radosgw.${hostname}"],
  }
 
  file {"/etc/ceph":
    ensure  => directory,
  }
  Ini_setting <<| tag == "cephconf-${fsid}" |>> {
    require => File['/etc/ceph']
  } 


  

}
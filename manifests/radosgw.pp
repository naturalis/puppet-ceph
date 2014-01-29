class ceph::radosgw (
  
  $rados_server_webmaster_alias	= 'aut@naturalis.nl',
)
{
  
  $rados_server_name = $fqdn
  $rados_server_alias = $fqdn

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
  	owner    => 'root',:
    group    => 'www-data',
  	mode     => '0770',
  }
}
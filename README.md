puppet-ceph
===========

 TODO
* Finish Rados Gateway
* More parameters
* Implement manual ceph.conf injection

This ceph puppet module installs ceph monitors and osd hosts. 
On the monitor and osd make sure the Ceph::Package is installed first.
The ceph.conf is distributed by exported resources. 
Required parameters are osd host and monitor are:
* fsid => generate with monmaptool
* monitorkey => generate with ceph auth
* adminkey   => generate with ceph auth

Additional required parameter for osd host is
* disks => this and comma seperated string with your disk devices for ceph osds.
  do not use /dev/sdd, just sdd,sde,sdf
* datacenter
* rack

First deploy 3 monitors 
Then deploy and osd and run puppet twice. First run is to reserve the osd spot.
Second run is for creating the osd's and start the services. 

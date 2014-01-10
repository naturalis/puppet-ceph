#!/usr/bin/python

import os.path
import sys
import subprocess

fact_file = "/etc/facter/facts.d/ceph-osd-id-array.txt"


osd_id = subprocess.Popen(["wc", "-l","/tmp/test"],stdout=subprocess.PIPE).communicate()[0]
osd_id = osd_id.split('\n')[0].split(' ')[0]
print osd_id

if not os.path.isfile(fact_file):
	myfile = open(fact_file,'wb')
	myfile.write('ceph-osd-id-array='+sys.argv[1] + '-' + osd_id)
	myfile.close()
else:
	myfile = open(fact_file,'r')
	current = myfile.read()
	myfile = open(fact_file,'wb')
	new = current + ',' + sys.argv[1] + '-' + osd_id
	myfile.write(new.trim())
	myfile.close()


#!/usr/bin/python
# -*- coding: iso-8859-1 -*-

import os.path
import sys
import subprocess
import errno
import string

if not os.path.isfile('scripts/perms.map'):
	print 'Could not locate scripts/file.perms or scripts/dir.perms'
	print 'This script is intended to be run from the root directory of an eclair-rootfs'
	print 'checkout. Please ensure the checkout is complete and run this script from there.'
	sys.exit(1)

filePerms = open('scripts/perms.map', 'r')

for inLine in filePerms:
	lsFields = inLine.split()
	if len(lsFields) > 1:
		newMode = string.atoi(lsFields[0], 8)
		newUID = int(lsFields[1])
		newGID = int(lsFields[2])
		targetFile = '.' + '.'.join(inLine.split('.')[1:]).rstrip('\n')
		try:
			os.chown(targetFile, newUID, newGID)
		except Exception as e:
			print 'FAILED: chown %d:%d %s -> %s' % (newUID, newGID, targetFile, str(e))
		
		try:
			os.chmod(targetFile, newMode)
		except Exception as e:
			print 'FAILED: chmod %s %s -> %s' % (newMode, targetFile, str(e))

filePerms.close()

sys.exit(0)

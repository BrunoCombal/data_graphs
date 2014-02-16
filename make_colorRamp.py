#!/usr/bin/env python

# \author Bruno Combal
# \date February 2014

# \brief Computes an interpolated color ramp

import sys

# __________
def textUsage():
	tt='SYNOPSIS:\n\tmake_colorRamp.py -ramp textfile [-color "rgb"|"hexa"]'
	return tt
# __________
def exitMessage(msg, exitCode=1):
	print msg
	print
	print textUsage()
	
	sys.exit(exitCode)

# __________
def getColorCoding(desc):
	if desc=='rgb':
		return 'rgb'
	elif desc=='hex' or desc=='hexa' or desc=='hexadecimal':
		return 'hexa'
	else:
		exitMessage('Unknown color coding {0}. Exit 10.'.format(desc), 10)
		
# __________
# \brief input: txtfile describing the color ramp
# \output list of RGB codes 
# the code guess the color coding
def do_colorRamp(txtFile):

	# read textfile and store values in structure [{"RGB":rgb, "N":n}]
	# rule: if 3 values: RGB, if 1 values: if starts with #: color, else number
	# check integrity: codes breaks if error
	# interpolate 
	# spit out

	continue

# __________
if __name__=="__main__":

	colorDescr=None
	colorCoding='hexa'
	
	ii = 1
	while ii < len(sys.argv):
		arg=sys.argv[ii].lower()
		if arg == '-ramp':
			ii = ii + 1
			colorDescr = sys.argv[ii]
		elif arg == '-color':
			ii = ii + 1
			colorCoding = getColorCoding(sys.argv[ii])
		ii = ii + 1
		
		
	if colorDescr is None:
		exitMessage('Missing a text file describing the color ramp. Use option -ramp. Exit 1', 1)

	if not os.path.exists(colorDescr):
		exitMessage('Ramp text file {0} not found. Exit 2.'.format(colorDescr), 2)
		
	do_colorRamp(colorDescr)
	
# end of file


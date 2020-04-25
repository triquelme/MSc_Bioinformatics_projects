import re

class Localisation(dict):

	def __init__(self, language):
		temp = {}

		f = open('localisation/'+language+'.txt', 'r')
		for line in f:
			line = line.rstrip('\r\n')
			regex = re.search('(.+):.+"(.+)"', line)
			temp[ regex.group(1) ] = regex.group(2)
		f.close

		dict.__init__(self, temp)

	

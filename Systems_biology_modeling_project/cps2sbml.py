def getFlux(flux):

	fFile = open(flux, "r")
	lines = fFile.readlines()
	
	tab = {}

	for i in range(len(lines)):
		if("Reaction" in lines[i]):
			while("Jacobian" not in lines[i+2]):
				i += 1
				reac = lines[i].split("\t")
				tab[reac[0]] = reac[1]
	
	return tab
		
	
def getMetabolCompart(cps):
	
	copaFile = open(cps, "r")
	lines = copaFile.readlines()
	
	i = 0


	tab = {}
	tab2 = {}
	
	for i in range(len(lines)):
		if("Metabolite key" in lines[i]):
			metab = lines[i].split("\"")
			tab[metab[1]] = metab[3], metab[7], metab[5]
		if("Compartment key" in lines[i]):
			compart = lines[i].split("\"")
			tab2[compart[1]] = compart[3]
			
	copaFile.close()

	for key, value in tab.items():
		for key2, value2 in tab2.items():
			if(value[1] == key2):
				tab[key] = value[0], value2, value[2]

	return tab

def getReactions(cps, metabolites):
	
	copaFile = open(cps, "r")
	lines = copaFile.readlines()

	i = 0

	reaction = ""
	nameR = ""

	tab = {}
	reactionFound = False

	for i in range(len(lines)):

		if("<Reaction key" in lines[i]):

			reactionN = lines[i].split("\"")
			nameR = reactionN[3]

			reactionFound = True

			subs = []
			prods = []

			subCount = 0
			prodCount = 0

			while(reactionFound):

				if("<Substrate metabolite" in lines[i]):
					
					substrat = lines[i].split("\"")
					substrat[1] = convertName(substrat[1], metabolites)

					if(int(substrat[3])>1):
						tmp = substrat[3] + "*" + substrat[1]
						subs.append(tmp)
					else:
						tmp = substrat[1]
						subs.append(tmp)
				
				if("<Product metabolite" in lines[i]):
					
					produit = lines[i].split("\"")
					produit[1] = convertName(produit[1], metabolites)

					if(int(produit[3])>1):
						tmp = produit[3] + "*" + produit[1]
						prods.append(tmp)
					else:
						tmp = produit[1]
						prods.append(tmp)
					
				if("</ListOfProducts>" in lines[i]):

					reactionFound = False					
					reaction = ""

					if(len(subs) == 1):
						subs[0] = subs[0].replace("FIXED#", "")
						reaction = reaction + subs[0] + "="
					else:
						for i in range(len(subs)):
							if("FIXED#" not in subs[i]):					
								if(i != len(subs) and subCount != 0):
									reaction = reaction + "+"
								reaction = reaction + subs[i]
								subCount += 1

								

						reaction = reaction + "="

					if(len(prods) == 1):
						prods[0] = prods[0].replace("FIXED#", "")
						reaction = reaction + prods[0]

					else:
						for i in range(len(prods)):
							if("FIXED#" not in prods[i]):					
								if(i != len(prods) and prodCount != 0):
									reaction = reaction + "+"
								reaction = reaction + prods[i]
								prodCount += 1
					tab[nameR] = reaction
					reaction = ""
					
				i += 1			

	return tab

def convertName(nom, metabs):
	
	for k,v in metabs.items():
		if(k == nom):
			if(v[2] != "fixed"):
				nom = v[0]
			else:
				nom = "FIXED#" + v[0]

	return nom
			
def writeTab(metabs, reactions, flux, output):
	tab=open(output, "w")
	writeHeader(tab,output)
	writeRows(reactions, flux, tab)
	print output, "created successfully."
	tab.close()

def writeHeader(tab, output):
	output = output.replace(".xml", "")
	tab.write("source	target	enzyme	flux_value \n")

def writeRows(reactions, flux, tab):
	for k, v in reactions.items():
		reaction = v.split("=")
		subs = reaction[0].split("+")
		prods = reaction[1].split("+")
		for i in range(len(subs)):
			stock = []
			stock = subs[i].split("*")

			for i in range(len(prods)):
				stockp = prods[i].split("*")
				
				if(len(stock)>1) and len(stockp)>1:
					tab.write(stock[1]+"	"+stockp[1]+"	"+k+"	"+flux[k]+"\n")
				elif len(stock)==1 and len(stockp)>1:
					tab.write(stock[0]+"	"+stockp[1]+"	"+k+"	"+flux[k]+"\n")
				elif len(stock)>1 and len(stockp)==1:
					tab.write(stock[1]+"	"+stockp[0]+"	"+k+"	"+flux[k]+"\n")
				else:
					tab.write(stock[0]+"	"+stockp[0]+"	"+k+"	"+flux[k]+"\n")

		



def writeSBML(metabs, reactions, flux, output):

	sbml = open(output, "w")
	writeStart(sbml, output)
	writeSpecies(metabs, sbml)
	writeReactions(reactions, flux, sbml)
	
	print output, "created successfully."
	sbml.close()
		

def writeStart(sbml, output):
	output = output.replace(".xml", "")
	sbml.write("""<sbml xmlns="http://www.sbml.org/sbml/level2" level="2" version="1">
<model id="xml" name=\"""" + output + """\">

<listOfSpecies>

""")

def writeSpecies(metabs, sbml):
	for k, v in metabs.items():
		sbml.write("""	<species id=\""""+ v[0] +"""\" name=\""""+ v[0] +"""\" compartment=\"""" + v[1] + """\"/>\n""")

	sbml.write("""
</listOfSpecies>

<listOfReactions>
""")

def writeReactions(reactions, flux, sbml):

	for k, v in reactions.items():
		if(flux != None):
			sbml.write("""
	<reaction id=\""""+ k +"""\" name=\"""" + k +  """\" value=\"""" + flux[k] + """\">
		<listOfReactants>\n""")
		else:
			sbml.write("""
	<reaction id=\""""+ k +"""\">
		<listOfReactants>\n""")
		reaction = v.split("=")
		subs = reaction[0].split("+")
		prods = reaction[1].split("+")
		
		for i in range(len(subs)):
			stock = []
			stock = subs[i].split("*")
			if(len(stock)>1):
				sbml.write("""			<speciesReference species=\""""+ stock[1] +"""\" stoichiometry=\""""+ stock[0] +"""\"/>\n""")
			else:
				sbml.write("""			<speciesReference species=\""""+ subs[i] +"""\" stoichiometry="1"/>\n""")

		sbml.write("""		</listOfReactants>
		<listOfProducts>\n""")

		for i in range(len(prods)):
			stock = []
			stock = prods[i].split("*")
			if(len(stock)>1):
				sbml.write("""			<speciesReference species=\""""+ stock[1] +"""\" stoichiometry=\""""+ stock[0] +"""\"/>\n""")
			else:
				sbml.write("""			<speciesReference species=\""""+ prods[i] +"""\" stoichiometry="1"/>\n""")

		sbml.write("""		</listOfProducts>
	</reaction>\n""")

	sbml.write("""
</listOfReactions>
</model>
</sbml>""")           
		

if __name__=="__main__":

	import sys,os
	
	try:

		if(len(sys.argv) == 4):
			listeM = getMetabolCompart(sys.argv[1])
			listeR = getReactions(sys.argv[1], listeM)
			listeF = getFlux(sys.argv[2])
			#writeSBML(listeM, listeR, listeF, sys.argv[3])
			writeTab(listeM, listeR, listeF, sys.argv[3])
		else:
			print """
	Error.
	Use: cps2sbmlfixed.py [copasi.cps] [flux.txt] output.xml
	"""

	except IOError as e:
		print "Error while parsing:"
		print e
		print """
Use: cps2sbmlfixed.py [copasi.cps] [flux.txt] output.xml
"""
		
	       

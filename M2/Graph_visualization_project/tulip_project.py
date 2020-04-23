# Powered by Python 2.7

# To cancel the modifications performed by the script
# on the current graph, click on the undo button.

# Some useful keyboards shortcuts : 
#   * Ctrl + D : comment selected lines.
#   * Ctrl + Shift + D  : uncomment selected lines.
#   * Ctrl + I : indent selected lines.
#   * Ctrl + Shift + I  : unindent selected lines.
#   * Ctrl + Return  : run script.
#   * Ctrl + F  : find selected text.
#   * Ctrl + R  : replace selected text.
#   * Ctrl + Space  : show auto-completion dialog.

from tulip import *
import copy

# the updateVisualization(centerViews = True) function can be called
# during script execution to update the opened views

# the pauseScript() function can be called to pause the script execution.
# To resume the script execution, you will have to click on the "Run script " button.

# the runGraphScript(scriptFile, graph) function can be called to launch another edited script on a tlp.Graph object.
# The scriptFile parameter defines the script name to call (in the form [a-zA-Z0-9_]+.py)

# the main(graph) function must be defined 
# to run the script on the current graph

def divide_by_pathway(graph, Pathways):
	dico_pathways = {}
	for n in graph.getNodes():
		for pathway in Pathways[n]:
			if pathway not in dico_pathways.keys():
				dico_pathways[pathway] = [n]
			else:
				dico_pathways[pathway].append(n)
	for pathway in dico_pathways.keys():
		subgraph = graph.inducedSubGraph(dico_pathways[pathway])
		subgraph.setName(pathway)
	
#PARTIE 2
#detecte les cycles sans prendre en compte l'orientation des aretes
def is_cycle(node, visited, cycle_tmp, cycles, graph):
	visited[node] = 1
	neighbours = set(graph.getOutNodes(node))
	for neighbour in neighbours:
		if visited[neighbour] == 0:
			cycle2 = copy.deepcopy(cycle_tmp)
			cycle2.append(neighbour)
			cycles = is_cycle(neighbour, visited, cycle2, cycles, graph)
		elif neighbour == cycle_tmp[0] and len(cycle_tmp) > 2:
			print "found cycle", cycle_tmp
			cycles.append(cycle_tmp)	
	return cycles
	
def find_cycle(graph):
	nodes = set(graph.getNodes())
	visited = graph.getIntegerProperty("visited")
	cycle = []
	visited.setAllNodeValue(0)
	for node in nodes:
		cycles = is_cycle(node, visited, [node], [], graph)	
		for cycle_tmp in cycles:
			if len(cycle)< len(cycle_tmp):
				cycle = cycle_tmp
	return cycle
			
def find_cycle_subgraphs(graph):
	subgraphs = set(graph.getSubGraphs())
	nb = 0
	for subgraph in subgraphs:
		cycle = find_cycle(subgraph)
		if cycle != []:
			subgraph.inducedSubGraph(cycle)
			nb += 1
	print "cyle trouve ", nb

#detecte les cycles en prenant en compte l'orientation des aretes
def is_cycleV2(node, visited, reaction, reversible, cycle_tmp, cycles, graph):
	visited[node] = 1
	if reaction[node] == True and reversible[node] == True:
		neighbours = set(graph.getInOutNodes(node))
	else:
		neighbours = set(graph.getOutNodes(node))
	for neighbour in neighbours:
		if visited[neighbour] == 0:
			cycle2 = copy.deepcopy(cycle_tmp)
			cycle2.append(neighbour)
			cycles = is_cycleV2(neighbour, visited, reaction, reversible, cycle2, cycles, graph)
		elif neighbour == cycle_tmp[0] and len(cycle_tmp) > 2:
			print " found cycle ", cycle_tmp
			cycles.append(cycle_tmp)	
	return cycles

def find_cycleV2(graph):
	nodes = set(graph.getNodes())
	visited = graph.getIntegerProperty("visited")
	reaction =graph.getBooleanProperty("reaction")
	reversible =graph.getBooleanProperty("reversible")
	cycles = []
	visited.setAllNodeValue(0)
	for node in nodes:
		cycles = is_cycleV2(node, visited, reaction, reversible, [node], cycles, graph)
	return cycles
			
def find_cycle_subgraphsV2(graph):
	subgraphs = set(graph.getSubGraphs())
	nb = 0
	for subgraph in subgraphs:
		cycles = find_cycleV2(subgraph)
		if cycles != []:
			for i in range(len(cycles)):
				sub_subgraph = subgraph.inducedSubGraph(cycles[i])
				sub_subgraph.setName("Cycle " + str(i))
				nb += 1
	print "cyle trouve ", nb


#PARTIE 3
def is_cycleV3(node, visited, reaction, reversible, cycle_tmp, cycles, graph):
	visited[node] = 1
	if reaction[node] == True and reversible[node] == True:
		neighbours = set(graph.getInOutNodes(node))
	else:
		neighbours = set(graph.getOutNodes(node))
	for neighbour in neighbours:
		if visited[neighbour] == 0:
			cycle2 = copy.deepcopy(cycle_tmp)
			cycle2.append(neighbour)
			cycles = is_cycleV3(neighbour, visited, reaction, reversible, cycle2, cycles, graph)
		elif neighbour == cycle_tmp[0] and len(cycle_tmp) > 2:
			print " found cycle ", cycle_tmp
			cycles.append(cycle_tmp)	
	return cycles

def find_cycleV3(graph):
	nodes = set(graph.getNodes())
	visited = graph.getIntegerProperty("visited")
	cycle = []
	visited.setAllNodeValue(0)
	for node in nodes:
		cycles = is_cycle(node, visited, [node], [], graph)	
		for cycle_tmp in cycles:
			if len(cycle)< len(cycle_tmp):
				cycle = cycle_tmp
	return cycle
			
def find_cycle_subgraphsV3(graph, viewLayout):
	subgraphs = set(graph.getSubGraphs())
	nb = 0
	quotientGraph = tlp.newGraph()
	#metanodes = []
	for subgraph in subgraphs:
		cycle = find_cycleV3(subgraph)
		if cycle != []:
			sub_subgraph = graph.inducedSubGraph(cycle)
			sub_subgraph.setName("Cycle")
			sub_subgraph.applyLayoutAlgorithm("Circular (OGDF)", viewLayout)
			nb += 1
			#subgraph.createMetaNode(cycle)
			metanode = subgraph.createMetaNode(sub_subgraph)
			print subgraph
			subgraph.openMetaNode(metanode)
			#quotientGraph.openMetaNode(metanode)
		#metanodes = metanodes + graph.createMetaNodes(subgraph.getSubGraphs(), quotientGraph)
	#tlpgui.createView("Node Link Diagram view", quotientGraph)
	#tlpgui.createNodeLinkDiagramView(quotientGraph)
	"""	
	for metanode in metanodes:
		quotientGraph.openMetaNode(metanode) 
	"""	
	print "cyle trouve ", nb

#PARTIE 4

def divide_by_pathwayV2(graph, Pathways):
	# construit une liste avec tous les pathways	
	list_pathways = []
	for n in graph.getNodes():
		for pathway in Pathways[n]:
			if pathway not in list_pathways:
				list_pathways.append(pathway)
	
	#reunit toutes les pathways dont les noeuds sont en commun
	list_names = []
	list_nodes = []
	for pathway in list_pathways:
		names = [pathway]
		nodes = []
		for name in names:
			for n in graph.getNodes():
				if name in Pathways[n]:
					for path in Pathways[n]:
						if path not in names:
							names.append(path)
							list_pathways.remove(path)
					nodes.append(n)
		list_names.append(names)
		list_nodes.append(nodes)
	
	#fait les sous graphes
	for i in range(len(list_names)):
		key = ""
		for name in list_names[i]:
			key += name
			key += " & "
		key = key[:len(key)-3]
		subgraph = graph.inducedSubGraph(list_nodes[i])
		subgraph.setName(key)	
	
	#fait les sous-sous graphes
	for subgraph in graph.getSubGraphs():
		pathways = subgraph.getName()
		pathways = pathways.split(" & ")
		if len(pathways) > 1:
			dico = {}
			for pathway in pathways:
				dico[pathway] = []
			for n in subgraph.getNodes():
				for pathway in Pathways[n]:
					dico[pathway].append(n)
			for pathway in dico.keys():
				sub_subgraph = subgraph.inducedSubGraph(dico[pathway])
				sub_subgraph.setName(pathway)

def createMetaNode(graph):
	for subgraph in graph.getSubGraphs():
		for subsubgraph in subgraph.getSubGraphs():
			subgraph.createMetaNode(set(subsubgraph.getNodes()))
		#graph.createMetaNode(set(subgraph.getNodes()))

def main(graph): 
	Pathways = graph.getStringVectorProperty("Pathways")
	ecNumber = graph.getStringProperty("ecNumber")
	listOfProducts = graph.getIntegerVectorProperty("listOfProducts")
	listOfReactants = graph.getIntegerVectorProperty("listOfReactants")
	name = graph.getStringProperty("name")
	reaction = graph.getBooleanProperty("reaction")
	reversible = graph.getBooleanProperty("reversible")
	viewBorderColor = graph.getColorProperty("viewBorderColor")
	viewBorderWidth = graph.getDoubleProperty("viewBorderWidth")
	viewColor = graph.getColorProperty("viewColor")
	viewFont = graph.getStringProperty("viewFont")
	viewFontAwesomeIcon = graph.getStringProperty("viewFontAwesomeIcon")
	viewFontSize = graph.getIntegerProperty("viewFontSize")
	viewLabel = graph.getStringProperty("viewLabel")
	viewLabelBorderColor = graph.getColorProperty("viewLabelBorderColor")
	viewLabelBorderWidth = graph.getDoubleProperty("viewLabelBorderWidth")
	viewLabelColor = graph.getColorProperty("viewLabelColor")
	viewLabelPosition = graph.getIntegerProperty("viewLabelPosition")
	viewLayout = graph.getLayoutProperty("viewLayout")
	viewMetaGraph = graph.getGraphProperty("viewMetaGraph")
	viewMetric = graph.getDoubleProperty("viewMetric")
	viewRotation = graph.getDoubleProperty("viewRotation")
	viewSelection = graph.getBooleanProperty("viewSelection")
	viewShape = graph.getIntegerProperty("viewShape")
	viewSize = graph.getSizeProperty("viewSize")
	viewSrcAnchorShape = graph.getIntegerProperty("viewSrcAnchorShape")
	viewSrcAnchorSize = graph.getSizeProperty("viewSrcAnchorSize")
	viewTexture = graph.getStringProperty("viewTexture")
	viewTgtAnchorShape = graph.getIntegerProperty("viewTgtAnchorShape")
	viewTgtAnchorSize = graph.getSizeProperty("viewTgtAnchorSize")

	for n in graph.getNodes():
		viewLabel[n] = ecNumber[n]
		viewSize[n] = tlp.Size(10,10,1)
		if reaction[n] == True:
			viewSize[n] = tlp.Size(len(ecNumber[n])*5,len(ecNumber[n]),1)
			if ecNumber[n] == "NA":
				viewColor[n] = tlp.Color(153,204,255)
			else:
				viewColor[n] = tlp.Color(204,255,229)		
		else:
			viewShape[n] = tlp.NodeShape.Circle
			viewColor[n] = tlp.Color(255,102,102)

	
	divide_by_pathway(graph, Pathways)
	#createMetaNode(graph)
	#find_cycle_subgraphsV2(graph)
	#find_cycle_subgraphsV3(graph, viewLayout)
	
	quotientGraph = tlp.newGraph()
	copy = tlp.newGraph()
	#graph.createMetaNodes(graph.getSubGraphs(), quotientGraph)
	for subgraph in set(graph.getSubGraphs()):
		tlp.copyToGraph(copy, subgraph)
		quotientGraph.createMetaNode(copy)
	tlpgui.createView("Node Link Diagram view", quotientGraph)

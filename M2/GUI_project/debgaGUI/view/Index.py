import gtk
import os
from localisation import config

class Index(gtk.HBox):

	def __init__(self):

		super(Index, self).__init__()

		lInput = gtk.Label( config.LOC["index_linput"])
		bInput = gtk.FileChooserButton( config.LOC["index_binput"] )
		bInput.set_current_folder('.')
		bInput.set_width_chars(50)

		lOutput = gtk.Label( config.LOC["index_loutput"])
		bOutput = gtk.FileChooserButton( config.LOC["index_boutput"] )
		bOutput.set_current_folder('.')
		bOutput.set_width_chars(50)
		bOutput.set_action(gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER)

		lSpace = gtk.Label( config.LOC["index_lSpace"])

		image_arrow = gtk.Image()
		image_arrow.set_from_stock(gtk.STOCK_GO_FORWARD, 2)
		bArrow = gtk.Button()
		bArrow.set_image(image_arrow)

		image_load = gtk.Image()
		image_load.set_from_stock(gtk.STOCK_NO, 2)
		bRed = gtk.Button()
		bRed.set_image(image_load)

		separator = gtk.VSeparator()

		# Option variables
		lOption = gtk.Label( config.LOC["index_lOption"] )
		lLength = gtk.Label( config.LOC["index_lLength"] )
		eLength = gtk.Entry()
		separator_option = gtk.HSeparator()
		bRun = gtk.Button( config.LOC["index_bRun"] )
		bRun.connect_object("clicked", self.launch_index, bInput, bOutput, eLength)


		#Build the boxes
		process = gtk.VBox(False, 0)
		process.add(bArrow)
		process.add(bRed)
		run = gtk.HBox(False, 0)
		run.add(bRun)
		run.add(process)

		main = gtk.VBox(False, 0)
		main.add(lInput)
		main.add(bInput)
		main.add(lOutput)
		main.add(bOutput)
		main.add(lSpace)
		main.add(run)

		option = gtk.VBox(False, 0)
		option.add(lOption)
		option.add(separator_option)
		option.add(lLength)
		option.add(eLength)

		#Add boxes to the Index box
		self.pack_start(main, True, True, 10)
		self.add(separator)
		self.pack_start(option, True, True, 10)

	def launch_index(self, fasta, index, option):
	        
		fasta_file = fasta.get_filename()
		index_name = index.get_filename()
		option_length = option.get_text()

		
		if (option_length != None):
			os.system("./deBGA-master/deBGA index -k "+option_length+" "+fasta_file+" "+index_name)
		else:
			os.system("./deBGA-master/deBGA index -k "+str(22)+" "+fasta_file+" "+index_name)


	#./deBGA index hepatitis.fasta hepatitis
	#./deBGA index -k 25 hepatitis.fasta hepatitis

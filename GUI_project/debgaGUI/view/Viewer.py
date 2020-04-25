import gtk
import os
from localisation import config

class Viewer(gtk.VBox):

	def __init__(self):
		super(Viewer, self).__init__()
		
		self.filechooserbutton = gtk.FileChooserButton( config.LOC["viewer_fcbBAM"] )
		self.filechooserbutton.set_current_folder('.')
		self.filechooserbutton.set_width_chars(50) 
		
		self.bRun = gtk.Button( config.LOC["viewer_bRun"] )      
		self.bRun.connect_object("clicked", self.launch_pybamview, self.filechooserbutton)
		
		self.pack_start(self.filechooserbutton, True, True, 10)
		self.pack_start(self.bRun, True, True, 10)
			
	def launch_pybamview(self, obj):
	
		filename = obj.get_filename()
		
		if (filename != None):
			os.system("samtools index "+filename)
			os.system("pybamview --bam "+filename+" &")

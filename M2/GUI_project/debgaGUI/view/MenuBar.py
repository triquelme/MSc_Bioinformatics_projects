import gtk
from localisation import config

class MenuBar(gtk.Toolbar):

	def __init__(self):
		super(MenuBar, self).__init__()

		self.set_style(gtk.TOOLBAR_ICONS)
		self.set_orientation(gtk.ORIENTATION_HORIZONTAL)
      
		#First button : Open file   
		bOpen = gtk.ToolButton(gtk.STOCK_OPEN)
		bOpen.set_tooltip_text( config.LOC["menubar_bOpen"] )
        
		#Second button : Help
		bHelp = gtk.ToolButton(gtk.STOCK_HELP)
		bHelp.set_tooltip_text( config.LOC["menubar_bHelp"] )
        
		#Insert into toolbar  
		self.insert(bOpen, 0)
		self.insert(bHelp, 1)

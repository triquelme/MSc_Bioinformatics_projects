import gtk
from MenuBar import MenuBar
from Tools import Tools
from localisation import config

class Interface(gtk.VBox):

	def __init__(self):
		super(Interface, self).__init__(False, 5)
		
		self.pack_start(MenuBar(), False, False, 0)
		self.pack_start(Tools(), False, False, 0)

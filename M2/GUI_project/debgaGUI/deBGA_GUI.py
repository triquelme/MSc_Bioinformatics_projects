import gtk
from view import Interface
from model import Model
from localisation import config

class deBGA_GUI(gtk.Window):

    def __init__(self):
        super(deBGA_GUI, self).__init__()

        config.init()
        
        self.set_title( config.LOC["title"] )
        self.set_default_size(500, 500)
        self.set_position(gtk.WIN_POS_CENTER)

        self.add( Interface() )
        self.connect("destroy", gtk.main_quit)
        self.show_all()
        placeholder=["index","file"]
        self.model = Model(placeholder)
     

deBGA_GUI()
gtk.main()

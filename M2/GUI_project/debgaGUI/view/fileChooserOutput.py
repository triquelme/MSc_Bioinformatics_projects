#!/usr/bin/env python
# coding: utf8

   
import pygtk
pygtk.require('2.0')
   
import gtk
   
dialogue = gtk.FileChooserDialog("choose output folder...",
                                  None,
                                  gtk.FILE_CHOOSER_ACTION_CREATE_FOLDER,
                                  (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                                   gtk.STOCK_OPEN, gtk.RESPONSE_OK))
dialogue.set_default_response(gtk.RESPONSE_OK)
   
   
reponse = dialogue.run()
if reponse == gtk.RESPONSE_OK:
    print dialogue.get_filename(), 'choisi'
elif reponse == gtk.RESPONSE_CANCEL:
    print 'On ferme, pas de fichier sélectionné'
dialogue.destroy()


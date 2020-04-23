#!/usr/bin/env python
# coding: utf8

   
import pygtk
pygtk.require('2.0')
   
import gtk

dialogue = gtk.FileChooserDialog("choose FASTA input...",
                                  None,
                                  gtk.FILE_CHOOSER_ACTION_OPEN,
                                  (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                                   gtk.STOCK_OPEN, gtk.RESPONSE_OK))
dialogue.set_default_response(gtk.RESPONSE_OK)
   
filtre = gtk.FileFilter()
filtre.set_name("All files")
filtre.add_pattern("*")
dialogue.add_filter(filtre)
   
filtre = gtk.FileFilter()
filtre.set_name("FASTA")
filtre.add_pattern("*.fasta")
dialogue.add_filter(filtre)
   
reponse = dialogue.run()
if reponse == gtk.RESPONSE_OK:
    print dialogue.get_filename(), 'choisi'
elif reponse == gtk.RESPONSE_CANCEL:
    print 'On ferme, pas de fichier sélectionné'
dialogue.destroy()


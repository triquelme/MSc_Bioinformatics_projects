import gtk
import os
from localisation import config

class Alignment(gtk.HBox):

	def __init__(self):
		super(Alignment, self).__init__()

                #Main variables

                lInput_index = gtk.Label( config.LOC["align_lInput_index"] )
                bInput_index =  gtk.FileChooserButton( config.LOC["align_input_index"] )
                bInput_index.set_current_folder('.')
                bInput_index.set_width_chars(50)
                bInput_index.set_action(gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER)

                lInput_fastq = gtk.Label( config.LOC["align_lInput_fastq"] )
                bInput_fastq = gtk.FileChooserButton( config.LOC["align_input_fastq"] )
                bInput_fastq.set_current_folder('.')
                bInput_fastq.set_width_chars(50)

                lOutput_sam = gtk.Label( config.LOC["align_output_sam"] )
                eOutput_sam = gtk.Entry()
               
                
		
		bRun_align = gtk.Button( config.LOC["align_bRun"] )
                bRun_align.connect_object("clicked", self.launch_align, bInput_index, bInput_fastq, eOutput_sam)


                image_arrow = gtk.Image()
                image_arrow.set_from_stock(gtk.STOCK_GO_FORWARD, 2)
                bArrow = gtk.Button()
                bArrow.set_image(image_arrow)

                image_load = gtk.Image()
                image_load.set_from_stock(gtk.STOCK_HOME, 2)
                bRed = gtk.Button()
                bRed.set_image(image_load)

                
                separator = gtk.VSeparator()

                
                # Option variables
                lOption = gtk.Label( config.LOC["align_lOption"] )
             
                
                separator_option = gtk.HSeparator()

                #Scrolled_window variables
                lOption1 = gtk.Label( config.LOC["align_lOption1"] )
                eOption1 = gtk.Entry()
                lOption2 = gtk.Label( config.LOC["align_lOption2"] )
                eOption2 = gtk.Entry()
		lOption3 = gtk.Label( config.LOC["align_lOption3"] )
                eOption3 = gtk.Entry()
		lOption4 = gtk.Label( config.LOC["align_lOption4"] )
                eOption4 = gtk.Entry()
		lOption5 = gtk.Label( config.LOC["align_lOption5"] )
                eOption5 = gtk.Entry()
		lOption6 = gtk.Label( config.LOC["align_lOption6"] )
                eOption6 = gtk.Entry()
		lOption7 = gtk.Label( config.LOC["align_lOption7"] )
                eOption7 = gtk.Entry()
		lOption8 = gtk.Label( config.LOC["align_lOption8"] )
                eOption8 = gtk.Entry()
                #Scale label and buiding
                lScale = gtk.Label( config.LOC["align_Scale"])

                Scale = gtk.HScale(None)
     
                
                #Build the boxes
                process = gtk.VBox(False, 0)
                process.add(bArrow)
                process.add(bRed)

                run = gtk.HBox(False, 0)
                run.add(bRun_align)
                run.add(process)

               
                


                main = gtk.VBox(False, 0)
                main.add(lInput_index)
                main.add(bInput_index)
                main.add(lInput_fastq)
                main.add(bInput_fastq)
                main.add(lOutput_sam)
                main.add(eOutput_sam)   
                main.add(run)

                scroll = gtk.VBox(False, 0)
                scroll.add(lOption1)
                scroll.add(eOption1)
                scroll.add(lOption2)
                scroll.add(eOption2)
		scroll.add(lOption3)
                scroll.add(eOption3)
		scroll.add(lOption4)
                scroll.add(eOption4)
		scroll.add(lOption5)
                scroll.add(eOption5)
		scroll.add(lOption6)
                scroll.add(eOption6)
		scroll.add(lOption7)
                scroll.add(eOption7)
		scroll.add(lOption8)
                scroll.add(eOption8)
                scroll.add(lScale)
                scroll.add(Scale)

                scrolled_window = gtk.ScrolledWindow(None, None)
                scrolled_window.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_ALWAYS)
                scrolled_window.add_with_viewport(scroll)


                option = gtk.VBox(False, 0)
                option.add(lOption)
                option.add(separator_option)
                option.add(scrolled_window)
                
                
                #Add boxes to the Index box
                self.pack_start(main, True, True, 10)
                self.add(separator)
                self.pack_start(option, True, True, 10)

                #deBGA aln Index_Dir Fastq_File Sam_file

        def launch_align(self, index, fastq, sam):
                        
                index_name = index.get_filename()
                fastq_file = fastq.get_filename()
                sam_name = sam.get_text()

                
                
                if (index_name != None):
                        os.system("./deBGA-master/deBGA aln "+index_name+" "+fastq_file+" "+fastq_file+" "+sam_name)

                return 0

                #./deBGA aln ../blblbl ../../SRR2940646_2.fastq ../../SRR2940646_2.fastq m.sam
 

                        
             

from subprocess import call

class Model():
    def __init__(self,cmd): #cmd = array of string
        self.command = "./deBGA"
        self.arrayArg=[]

    def addArg(self,arg):
        if not( arg in self.arryArg):
            self.arrayArg.append(arg)
    
    def rmvArg(self,arg):
        try:
            self.arrayArg.remove(arg)
        except ValueError:
            pass


    def launch(self):
        if not (self.launched()):
            for i in self.arrayArg:
                self.command=self.command+ " " +i
            call(self.command, True)
            if self.launched():
                #Signaler la vue que c'est lance
                pass
                self.command="./deGBA" #clear attribute "command" for launching another run
            else:
                #Signaler que ce n'est pas lance
                pass


    def launched(self): #test if command already launched, return true if running
        launch=call("ps aux |grep -v grep |grep "+self.command, True)#launch contains return code
        if launch ==0:
            return True
        return False

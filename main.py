import kivy
kivy.require('1.9.1')

from kivy.app import App
from mainscreen import MainScreen

class PMEASGui(App):
    def build(self):
        return MainScreen()

if __name__ == '__main__':
    PMEASGui().run()


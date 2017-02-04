import kivy
kivy.require('1.9.1')

from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout

class MainScreen(BoxLayout):
    def __init__(self, **kwargs):
        super(MainScreen, self).__init__(**kwargs)

        setBtn = Button(text="Hello")
        setBtn.bind(on_press=self.setEffect)
        self.add_widget(setBtn)

    def setEffect(self, obj):
        print("Button works!")

class PMEASGui(App):
    def build(self):
        return MainScreen()

if __name__ == '__main__':
    PMEASGui().run()


import kivy
kivy.require('1.9.1')

from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.lang import Builder


# This is basically our version of CSS, all of the color changes the property modifications, like
# height and width, go in here.

Builder.load_string( """

<EffectsParameterColumn@BoxLayout>:

    orientation: 'vertical'

    canvas.before:
        Color:
            rgb:  1, 1, 1, 1
        Rectangle:
            size: self.size
            pos: self.pos

<EffectsColumn@BoxLayout>:

    orientation: 'vertical'
    size: 150, 0
    size_hint: None, 1
    canvas.before:
        Color:
            rgb:  0, 0, 0, 1
        Rectangle:
            size: self.size
            pos: self.pos

""")


class EffectsParameterColumn(BoxLayout):
    def __init__(self, **kwargs):
        super(EffectsParameterColumn, self).__init__(**kwargs)


class EffectsColumn(BoxLayout):
    def __init__(self, **kwargs):
        super(EffectsColumn, self).__init__(**kwargs)

        # Construct all of the effects buttons
        self.distortion_button = Button(text='Distortion')
        self.delay_button = Button(text='Delay')
        self.reverb_button = Button(text="Reverb")
        self.chorus_buton = Button(text="Chorus")
        self.frequency_shift_button = Button(text="Frequency Shift")
        self.harmonizer_button = Button(text="Harmonizer")

        # Bind all of the event handlers
        self.distortion_button.bind(on_press=self.distortion_clicked)
        self.delay_button.bind(on_press=self.delay_clicked)
        self.reverb_button.bind(on_press=self.reverb_clicked)
        self.chorus_buton.bind(on_press=self.chorus_clicked)
        self.frequency_shift_button.bind(on_press=self.frequency_shift_clicked)
        self.harmonizer_button.bind(on_press=self.harmonizer_clicked)

        # Add the widgets to the column layout
        self.add_widget(self.distortion_button)
        self.add_widget(self.delay_button)
        self.add_widget(self.reverb_button)
        self.add_widget(self.chorus_buton)
        self.add_widget(self.frequency_shift_button)
        self.add_widget(self.harmonizer_button)

    #
    # Event Handler Methods
    #
    def distortion_clicked(self, obj):
        print("enable Distortion!!!")

    def delay_clicked(self, obj):
        print("enable Delay!!!")

    def reverb_clicked(self, obj):
        print("enable Reverb!!!")

    def chorus_clicked(self, obj):
        print("enable Chorus!!!")

    def frequency_shift_clicked(self, obj):
        print("enable Frequency Shift!!!")

    def harmonizer_clicked(self, obj):
        print("enable Harmonizer!!!")



class MainScreen(BoxLayout):

    def __init__(self, **kwargs):
        super(MainScreen, self).__init__(**kwargs)

        self.effects_column = EffectsColumn()
        self.effects_parameter_column = EffectsParameterColumn()

        self.add_widget( self.effects_column )
        self.add_widget( self.effects_parameter_column)

class PMEASGui(App):

    def build(self):
        self.title = "Portable Multi-Effects Audio Software"
        self.root = MainScreen()
        return self.root

if __name__ == '__main__':
    PMEASGui().run()


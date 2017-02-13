import kivy
kivy.require('1.9.1')

from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.slider import  Slider
from kivy.lang import Builder
from kivy.uix.gridlayout import GridLayout
from kivy.uix.relativelayout import RelativeLayout

from kivy.uix.scrollview import ScrollView
from kivy.core.window import Window


# This is basically our version of CSS, all of the color changes the property modifications, like
# height and width, go in here.

Builder.load_string( """
<MainScreen@BoxLayout>:
    canvas.before:
        Color:
            rgba: .8, .8, .8, 1
        Rectangle:
            pos: self.pos
            size: self.size


<EffectsParameterColumn@GridLayout>:
    
    orientation: 'vertical'
    padding: 10
    spacing: 20
    cols: 1

    size: 500, 500

    size_hint: None, None

    pos_hint: {'center_x': .5, 'center_y': .5 }

    #row_force_default: True
    #row_default_height: '75dp'

    canvas.before:
        Color:
            rgba:  0, 0, 0, 0
        Rectangle:
            size: self.size
            pos: self.pos
	

<EffectsColumn@BoxLayout>:

    orientation: 'vertical'
    size: 150, 0
    size_hint: None, 1
    canvas.before:
        Color:
            rgba:  0, 0, 0, 1
        Rectangle:
            size: self.size
            pos: self.pos



<EffectParameterBox@BoxLayout>:
 
    orientation: 'vertical'

    canvas.before:
        Color:
            rgba:  .6, .6, .6, 1
        Rectangle:
            size: self.size
            pos: self.pos


""")


class EffectParameterBox(BoxLayout):
    def __init__(self, **kwargs):
        super(EffectParameterBox, self).__init__(**kwargs)

        name_label = Label( text=kwargs.get( "text", "" ) )

        level_slider = Slider( min=0, max=100, value=50, orientation="horizontal") 

        column_layout = BoxLayout(orientation="vertical")
	
        column_layout.add_widget( name_label )
        column_layout.add_widget( level_slider )

        self.add_widget( column_layout )


class EffectsParameterColumn(GridLayout):
    def __init__(self, **kwargs):
        super(EffectsParameterColumn, self).__init__(**kwargs)

        labels = [ "Effect Level", "Distortion", "Feedback" ]
        for i in labels:
            c = EffectParameterBox( text=i )
            self.add_widget( c )



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

        relative_layout = RelativeLayout()

        relative_layout.add_widget( self.effects_parameter_column )

        self.add_widget( self.effects_column )
        self.add_widget( relative_layout )

class PMEASGui(App):

    def build(self):
        self.title = "Portable Multi-Effects Audio Software"
        self.root = MainScreen()
        return self.root

if __name__ == '__main__':
    PMEASGui().run()


"""
import kivy
kivy.require('1.0.8')

from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.scrollview import ScrollView
from kivy.uix.gridlayout import GridLayout


class ScrollViewApp(App):

    def build(self):

        # create a default grid layout with custom width/height
        layout = GridLayout(cols=1, padding=10, spacing=10,
                size_hint=(None, None), width=500)

        # when we add children to the grid layout, its size doesn't change at
        # all. we need to ensure that the height will be the minimum required
        # to contain all the childs. (otherwise, we'll child outside the
        # bounding box of the childs)
        layout.bind(minimum_height=layout.setter('height'))

        # add button into that grid
        for i in range(30):
            btn = Button(text=str(i), size=(480, 40),
                         size_hint=(None, None))
            layout.add_widget(btn)

        # create a scroll view, with a size < size of the grid
        root = ScrollView(size_hint=(None, None), size=(500, 320),
                pos_hint={'center_x': .5, 'center_y': .5}, do_scroll_x=False)
        root.add_widget(layout)

        return root


if __name__ == '__main__':

    ScrollViewApp().run()
"""


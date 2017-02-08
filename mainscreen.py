import os
import kivy

from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout

class MainScreen(BoxLayout):
    """
    Class used as a test to implement the backend.
    Currently assumes BOTH pmeas-frontend and pmeas-backend are in the SAME
    directory.
    """
    
    def __init__(self, **kwargs):
        """
        Constructor for the MainScreen class.
        Creates button widget that, when clicked, will create and save a config.txt
        file in the pmeas-backend directory.
        """
        super(MainScreen, self).__init__(**kwargs)

        setBtn = Button(text="Save")
        setBtn.bind(on_press=self.setEffect)
        self.add_widget(setBtn)

    def setEffect(self, obj):
        """
        Creates a configuration file with the selected effects.
        Currently set to a preconfigured value for testing purposes.
        """
        print("Set Effect Button Clicked")

        # Automatically remake the config directory in the backend if it was deleted.
        if not os.path.exists("../pmeas-backend/config/"):
            os.makedirs("../pmeas-backend/config/")

        # Open the file and write the sample JSON.
        config_file = open("../pmeas-backend/config/effects.txt", "wb")
        config_file.write(b"{\"effect\":\"delay\",\"delay\":0.25,\"feedback\":0,\"maxdelay\":1,\"mul\":1,\"add\":0}")
        config_file.close()

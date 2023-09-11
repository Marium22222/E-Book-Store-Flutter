Download the zip of this repository.
Extract the zip after downloading.

Download visual studio code from (https://code.visualstudio.com )   

OR

Download android studio IDE from (https://developer.android.com/studio)

Download flutter sdk on your computer, version of flutter sdk should be(sdk: '>=3.0.5 <4.0.0') from (https://docs.flutter.dev/get-started/install)

Find Your Flutter SDK Path:
Open System Environment Variables:
On Windows:
Right-click on "This PC" or "My Computer" and select "Properties."
Click on "Advanced system settings" on the left.
In the "System Properties" window, click the "Environment Variables" button.
Under "System variables," locate the "Path" variable and select "Edit."
Click "New" and add the path to your Flutter SDK directory (e.g., C:\flutter\bin).
Click "OK" on all open windows to save your changes.
Open the folder extracted from zip in android studio IDE  clicking file->open->location of the folder in the IDE after opening it.
OR
Open the folder extracted from zip in visual studio code IDE  clicking file->open folder->location of the folder in the IDE after opening it.
Go to pubspec.yaml file after opening the folder in one of the IDEs and run flutter pub get in the terminal.
This application uses flutter sdk version (sdk: '>=3.0.5 <4.0.0)' so make sure to upgrade the version of flutter sdk before running pub get in pubspec.yaml.
Download Emulator:
1. Android Emulator:
To set up an Android emulator for Flutter development, you'll need to use the Android Virtual Device (AVD) Manager, which is part of Android Studio:
Download and Install Android Studio:
Download Android Studio from the official website
Open AVD Manager:
Click on "Configure" in the Android Studio welcome screen.
Select "AVD Manager" from the dropdown menu.
Create an Android Virtual Device (AVD):
In the AVD Manager, click the "Create Virtual Device" button.
Follow the wizard to select a device definition, system image (usually you'll want a recent one with Google Play), and configure other settings.
Once created, select your AVD and click the "Play" button to start the emulator.
Use the Emulator with VS Code:
Open your Flutter project in VS Code.
Use the Flutter extension to select the Android emulator as the target device (open the command palette with Ctrl + Shift + P, type "Flutter: Select a Device," and choose your emulator).
Now, you can run your Flutter app, and it will launch on the Android emulator you've set up.

OR 

2.Setup a physical device:
Enable Developer Mode on Your Device:
For Android, you need to enable Developer Options and USB Debugging. Here's how:
Go to your device's "Settings."
Scroll down and find "About Phone" or "About Device."
Look for "Build Number" and tap it repeatedly (usually about 7 times) until you see a message saying you're now a developer.
Now, go back to the main "Settings" screen and scroll down to find "Developer Options" or "System" and then "Developer options."
Enable "USB Debugging."
Connect Your Device:
Use a USB cable to connect your physical device to your development machine. Make sure the device is unlocked and connected as a media device (MTP) or for file transfer.

After all these steps run the application on your android mobile phone or emulator that supports android projects.




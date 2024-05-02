# Asthsist+

![Image for Asthsist+](doc/images/asthsist+.png)

## Build status
| Platform | Status |
|----------|--------|
|Android|:heavy_check_mark:|
|iOS|:x:|

## About
Asthsist+ is a mobile application for assisting asthma management, enabling patients to self-monitor and manage their asthma symptoms effectively on a daily basis. This comprehensive solution aims to equip patients with the tools needed to manage their asthma and enhance their quality of life. 

 This project is a part of the senior project submitted in partial fullfillment of the Requirement for THE DEGREE OF BACHELOR OF SCIENCE (INFORMATION AND COMMUNICATION TECHNOLOGY) Faculty of Information and Communication Technology, Mahidol University 2023

### Features :stethoscope:
- Environmental trigger monitoring :cloud:
- Asthma activity and medication tracking :pill:
- Integration with wearable devices via Google Fit :watch:
- Asthma control test :memo:
- Peak flow zone prediction using machine learning :gear:

### Application

This application is built using Flutter, a UI toolkit from Google that allows the creation of natively compiled applications for mobile, web, and desktop from a single codebase. The application uses Firebase for backend services like authentication, database, and storage.

### Machine Learning

The machine learning part of this project is implemented using Python in a Google Colab notebook. Google Colab is a cloud-based Python development environment that provides GPU acceleration for free.


The trained model is then exported and integrated into the Flutter application for inference.

Please refer to the 'Running the project' section for instructions on how to set up and run the Flutter application and the Google Colab notebook.


## Running the project
### Requirements :syringe:

#### For the Flutter Project :iphone:

To run this Flutter project, you will need the following:

1. **Flutter SDK**: Make sure you have Flutter installed on your machine. To check if it's installed and set up correctly, run `flutter doctor` in your terminal/command prompt. If Flutter is not installed, you can download it from the Flutter website.

2. **Dart SDK**: Dart is the programming language used in Flutter. The Dart SDK is bundled with Flutter; it is not necessary to install Dart separately.

3. **Android Studio/IntelliJ/VsCode**: These are the recommended IDEs for Flutter development. They have plugins for Flutter and Dart which make development easier. You can download them from their respective websites.

4. **A device/emulator**: You will need a device running Android or iOS for app testing. If you don't have a device, you can use an emulator on your development machine.

5. **Firebase**: This project uses Firebase. Make sure you have set up a Firebase project and added the configuration files to your project. Follow the instructions in the Firebase documentation to set this up.

6. **Git**: Git is a version control system that helps manage and track changes to your code. If you're downloading this project from GitHub, you'll need Git installed on your machine.

#### For the Google Colab Python Notebook :notebook:

To run the Python notebook in Google Colab, you will need the following:

1. **Google Account**: You will need a Google account to access Google Colab.

2. **Python**: Basic knowledge of Python is required to understand and run the notebook.
   

Please ensure that you have all these requirements met before trying to run this Flutter project and the Google Colab Python notebook.

 This project is a part of a senior project submitted in partial fullfillment of the Requirement forTHE DEGREE OF BACHELOR OF SCIENCE(INFORMATION AND COMMUNICATION TECHNOLOGY) Faculty of Information and Communication Technology, Mahidol University 2023

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

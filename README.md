# Portable Modulation Audio System - *Frontend*
![Logo](/qml/images/logo.png "Logo")

[![Build Status](https://travis-ci.org/pmeas/pmeas-frontend.svg?branch=dev)](https://travis-ci.org/pmeas/pmeas-frontend)

## Description
This is the companion application to the [PMEAS backend application](https://github.com/pmeas/pmeas-backend). This serves as a reference GUI for controlling and setting the audio effects, input, and output devices that are used by a backend audio modulator using the [Pyo](http://ajaxsoundstudio.com/software/pyo/) libraries.

## Necessary Dependencies
* [Qt 5.8](https://www.qt.io/qt5-8/)
* C++14 compliant compiler
* UDP broadcasting network access ( Wifi, LAN, etc. )

## Usage

This guide assumes that the user is using the [ Qt Creator IDE ](https://www.qt.io/ide/), as well having the [backend](https://github.com/pmeas/pmeas-backend) device already installed and running.

1. Download this project repository.
2. Download and install all of the **Necessary Dependencies**.
3. Open up the Qt Creator program from your system application menu; start menu on windows, linux application menu, etc.
4. Click on the `File->Open` toolbar menu, and locate your downloaded project repository folder.
5. Open the `pmeas-frontend.pro` file.
6. Click on the bottom left run button, it is a [ green play button ](https://prognotes.net/wp-content/uploads/2016/11/qt-creator-build-run.jpg).
7. The frontend should compiler and run.
8. Wait for the application to launch.

## Common Issues
* This application establishes a UDP connection to the backend device, through a UDP broadcast. If the frontend fails to connect to the backend device, make sure the network access provides support for UDP broadcasting.

## Screenshots
![Mainview](/screenies/mainview.png "Main View Screenshot")


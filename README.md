ReadMe - Ubuntu Calculator App
===========================
Ubuntu Calculator App is the official calculator app for Ubuntu Touch. We follow an open
source model where the code is available to anyone to branch and hack on. The
ubuntu calculator app follows a test driven development (TDD) where tests are
written in parallel to feature implementation to help spot regressions easier.

Dependencies
============
**DEPENDENCIES ARE NEEDED TO BE INSTALLED TO BUILD AND RUN THE APP**.

A complete list of dependencies for the project can be found in ubuntu-calculator-app/debian/control

The following essential packages are also required to develop this app:
* [ubuntu-sdk](http://developer.ubuntu.com/start)
* intltool   - run  `sudo apt-get install intltool

Calculation engine
==================

Current calculation engine is math.js version 1.1.0. 
You could download latest version from webpage:
    http://mathjs.org

The engine was sligtly modified to properly work with Ubuntu-Calculator-App.

Profiling calculator
====================

To successfuly run profiler on your device, you must modify ubuntu-calculator-app.apparmor file,
and add "networking" policy group:

 "policy_groups": [
    "networking"
 ],

The bug was already submitted at:
https://bugs.launchpad.net/ubuntu-sdk-ide/+bug/1520551

Next you will need follow instruction:

 1. Connect your device to PC and make sure it is unlocked, and Developer Mode is enable
 2. Run Ubuntu SDK IDE
 3. Open Calculator project and generate Unix Makefiles for Arm.
 4. Select Analyze > QML Profiler 
 5. Select the Start button to start Calculator from the QML Profiler.
 6. After reproduce issue you must press Stop button.

More information about profiling is available at:
http://doc.qt.io/qtcreator/creator-qml-performance-monitor.html

Useful Links
============
Here are some useful links with regards to the Calculator App development.

* [Home Page](https://developer.ubuntu.com/en/community/core-apps/calculator/)
* [Calculator App Wiki](https://wiki.ubuntu.com/Touch/CoreApps/Calculator)
* [Designs](https://developer.ubuntu.com/en/community/core-apps/calculator/#design)
* [Project page](https://launchpad.net/ubuntu-calculator-app) 

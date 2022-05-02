# SleepWarden
![Logo](images/SleepWarden.jpg "Logo")

Run custom code when the system sleeps or wakes on MacOS.

## Description:

SleepWarden catches MacOS sleep events, to allow you to run custom code when the system sleeps or wakes.

SleepWarden consists of the following components:

	SleepWarden             - The main binary that catches the sleep and wake events
	SleepWarden-IdleSleep   - Called when the system is about to sleep due to idleness
	SleepWarden-WillSleep   - Called when the system has started to sleep
	SleepWarden-WillWake    - Called when the system has started the wake up process
	SleepWarden-HasWoken    - Called when the system has finished waking up
 
SleepWarden-IdleSleep, SleepWarden-WillSleep, SleepWarden-WillWake and SleepWarden-HasWoken are bash scripts.

The example scripts simply write to a log file in /tmp. You should customise the scripts to your own needs.


## How to install:

Open the Terminal app, and download the latest [SleepWarden.pkg](https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden.pkg) installer to your desktop by typing the following command. 

	curl -k --silent --retry 3 --retry-max-time 6 --fail https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden.pkg --output ~/Desktop/SleepWarden.pkg

To install, double-click the downloaded package.

The installer will install the following files and directories:

	/Library/LaunchDaemons/com.github.execriez.sleepwarden.plist
	/usr/SleepWarden/
	/usr/SleepWarden/bin/
	/usr/SleepWarden/bin/SleepWarden
	/usr/SleepWarden/bin/SleepWarden-IdleSleep
	/usr/SleepWarden/bin/SleepWarden-WillSleep
	/usr/SleepWarden/bin/SleepWarden-WillWake
	/usr/SleepWarden/bin/SleepWarden-HasWoken

There's no need to reboot.

After installation, your computer will write to the log file /tmp/SleepWarden.log whenever there is a sleep event. 

If the installer fails you should check the installation logs.

## Modifying the example scripts:

After installation, four simple example scripts can be found in the following location:

	/usr/SleepWarden/bin/SleepWarden-IdleSleep
	/usr/SleepWarden/bin/SleepWarden-WillSleep
	/usr/SleepWarden/bin/SleepWarden-WillWake
	/usr/SleepWarden/bin/SleepWarden-HasWoken

These scripts simply write to the log file /tmp/SleepWarden.log whenever there is a sleep event. Modify the scripts to your own needs.


You should note that there is at most a 60 second delay between an **IdleSleep** event and the system actually going to sleep.

Also, there is at most a 30 second delay between a **WillSleep** event and the system going to sleep.

You should aim at having all your scripts complete within the appropriate timeframes.

**SleepWarden-IdleSleep**

This script is called when the system is about to sleep due to idleness. 

If the IdleSleep script takes longer than 60 seconds, a system sleep will occur mid-script, and the script will complete after the system next wakes!

After the script completes, a system **WillSleep** event occurs which causes the "SleepWarden-WillSleep" script to run.

	#!/bin/bash
	#
	# Idle sleep is about to kick in. 
	# The system will wait at most 60 seconds then go to sleep.
	#
	# Called as root like this:
	#   SleepWarden-IdleSleep
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') IdleSleep - system is about to go to sleep due to idleness" >> /tmp/SleepWarden.log

**SleepWarden-WillSleep**

This script is called when you select "Sleep" from the Apple menu, and immediately after an **IdleSleep** event completes.

The system will go to sleep 30 seconds after the **WillSleep** event, or 60 seconds after the **IdleSleep** event; whichever comes first.

Some services may not work after a WillSleep event.

	#!/bin/bash
	#
	# System sleep is about to kick in. 
	# The system will wait at most 30 seconds then go to sleep.
	#
	# Called as root like this:
	#   SleepWarden-WillSleep
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') WillSleep - system is about to go to sleep" >> /tmp/SleepWarden.log

**SleepWarden-WillWake**

This script is called when the system has started the wake up process.

	#!/bin/bash
	#
	# The system has started the wake up process
	#
	# Called as root like this:
	#   SleepWarden-WillWake
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') WillWake - system is about to wake from sleep" >> /tmp/SleepWarden.log

**SleepWarden-HasWoken**

This script is called when the system has finished waking up.

	#!/bin/bash
	#
	# The system has finished waking up
	#
	# Called as root like this:
	#   SleepWarden-HasWoken
	
	# Do Something
	echo "$(date '+%d %b %Y %H:%M:%S %Z') HasWoken - system has just woken from sleep" >> /tmp/SleepWarden.log


## How to uninstall:

Open the Terminal app, and download the latest [SleepWarden-Uninstaller.pkg](https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden-Uninstaller.pkg) uninstaller to your desktop by typing the following command. 

	curl -k --silent --retry 3 --retry-max-time 6 --fail https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden-Uninstaller.pkg --output ~/Desktop/SleepWarden-Uninstaller.pkg


To uninstall, double-click the downloaded package.

The uninstaller will remove the following files and directories:

	/Library/LaunchDaemons/com.github.execriez.sleepwarden.plist
	/usr/SleepWarden/

After the uninstall everything goes back to normal, and sleep events will not be tracked.

There's no need to reboot.

## Logs:

The example scripts write to the following log file:

	/tmp/SleepWarden.log

The installer writes to the following log file:

	/Library/Logs/com.github.execriez.sleepwarden.log
  
You should check this log if there are issues when installing.

## History:

1.0.7 - 02 May 2022

* Compiled as a fat binary to support both Apple Silicon and Intel Chipsets. This version requires MacOS 10.9 or later.

* The example scripts now just write to a log file. Previously they made use of the "say" command.

* The package creation and installation code has been aligned with other "Warden" projects.

1.0.6 - 03 OCT 2018

* Events no longer wait for earlier events to finish before running. Events can now be running simultaneously.

* The example scripts have been simplified, and the readme has been improved.

1.0.5 - 29 SEP 2018

* The example scripts have been simplified, and the readme has been improved.

1.0.4 - 11 OCT 2017

* Fixed a few typos in the readme.

1.0.4 - 10 OCT 2017

* First public release.

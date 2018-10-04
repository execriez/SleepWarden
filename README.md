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

These example scripts use the "say" command to speak whenever the system sleeps or wakes. You should customise the scripts to your own needs.


## How to install:

Download the SleepWarden installation package here [SleepWarden.pkg](https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden.pkg)

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

After installation, your computer will speak whenever there is a sleep event.

If the installer fails you should check the installation logs.

## Modifying the example scripts:

After installation, four simple example scripts can be found in the following location:

	/usr/SleepWarden/bin/SleepWarden-IdleSleep
	/usr/SleepWarden/bin/SleepWarden-WillSleep
	/usr/SleepWarden/bin/SleepWarden-WillWake
	/usr/SleepWarden/bin/SleepWarden-HasWoken

These simple scripts use the "say" command to speak whenever the system sleeps or wakes. Modify the scripts to alter this default behaviour.

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

	# Do something
	say "Idle Sleep"

**SleepWarden-WillSleep**

This script is called when you select "Sleep" from the Apple menu, and immediately after an **IdleSleep** event completes.

The system will go to sleep 30 seconds after the **WillSleep** event, or 60 seconds after the **IdleSleep** event; whichever comes first.

Some services don't work after a WillSleep event, so you may notice that you never get to hear the "say" command below.

	#!/bin/bash
	#
	# System sleep is about to kick in. 
	# The system will wait at most 30 seconds then go to sleep.
	#
	# Called as root like this:
	#   SleepWarden-WillSleep

	# Do something
	say "Will Sleep"

**SleepWarden-WillWake**

This script is called when the system has started the wake up process.

	#!/bin/bash
	#
	# The system has started the wake up process
	#
	# Called as root like this:
	#   SleepWarden-WillWake

	# Do something
	say "Will Wake"

**SleepWarden-HasWoken**

This script is called when the system has finished waking up.

	#!/bin/bash
	#
	# The system has finished waking up
	#
	# Called as root like this:
	#   SleepWarden-HasWoken

	# Do something
	say "Has Woken"


## How to uninstall:

Download the SleepWarden uninstaller package here [SleepWarden-Uninstaller.pkg](https://raw.githubusercontent.com/execriez/SleepWarden/master/SupportFiles/SleepWarden-Uninstaller.pkg)

The uninstaller will remove the following files and directories:

	/Library/LaunchDaemons/com.github.execriez.sleepwarden.plist
	/usr/SleepWarden/

After the uninstall everything goes back to normal, and sleep events will not be tracked.

There's no need to reboot.

## Logs:

The SleepWarden binary writes to the following log file:

	/var/log/systemlog
  
The following is an example of a typical system log file entry:

	Sep 29 14:28:55 mymac-01 SleepWarden[69960]: SystemIdleSleep
	Sep 29 14:28:56 mymac-01 SleepWarden[69960]: SystemWillSleep
	Sep 29 14:31:21 mymac-01 SleepWarden[69960]: SystemWillWake
	Sep 29 14:31:26 mymac-01 SleepWarden[69960]: SystemHasWoken

The installer writes to the following log file:

	/Library/Logs/com.github.execriez.sleepwarden.log
  
You should check this log if there are issues when installing.

## History:

1.0.6 - 03 OCT 2018

* Network events no longer wait for earlier events to finish before running. Events can now be running simultaneously.

* The example scripts have been simplified, and the readme has been improved.

1.0.5 - 29 SEP 2018

* The example scripts have been simplified, and the readme has been improved.

1.0.4 - 11 OCT 2017

* Fixed a few typos in the readme.

1.0.4 - 10 OCT 2017

* First public release.

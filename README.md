# SleepWarden
![Logo](images/SleepWarden.jpg "Logo")

Run custom code when a MacOS system sleeps or wakes.

## Description:

SleepWarden catches MacOS sleep and wake events, to allow you to run custom code.

It consists of the following components:

	SleepWarden             - The main binary that catches the sleep and wake events
	SleepWarden-IdleSleep   - Called when the system is about to sleep due to idleness
	SleepWarden-WillSleep   - Called when the system has started to sleep
	SleepWarden-WillWake    - Called when the system has started the wake up process
	SleepWarden-HasWoken    - Called when the system has finished waking up

The IdleSleep, WillSleep, WillWake and HasWoken example code are bash scripts.

The example scripts simply use the "say" command to let you know when sleep and wake events are occuring. You should customise these scripts to your own needs.

You should note that there is a 30 second delay between the very first sleep event (idle sleep, or sleep) and the system actually going to sleep - so you should aim at having all your scripts complete within this timeframe.

### SleepWarden-IdleSleep:

When an idle sleep event occurs, the 'SleepWarden-IdleSleep' script runs.

During this script, all resources are still online as sleep has not actually started.

You should note that the 'SleepWarden-IdleSleep' script is not called if you select 'Sleep' from the Apple menu.

### SleepWarden-WillSleep:

The 'SleepWarden-WillSleep' script runs at a sleep event, or immediately after the 'SleepWarden-IdleSleep' script finishes. 

A sleep event might be selecting 'sleep' from the apple menu, or closing a laptop lid.

During this script, resources may have already been taken offline. For example, sound will almost definately be offline - so you will not hear any output from the example 'say' command.

### SleepWarden-WillWake:

The 'SleepWarden-WillWake' script runs when the system is first waking up. Some resources such as networking may not be available during this event.
 
### SleepWarden-HasWoken:

The 'SleepWarden-HasWoken' script runs when the system has finished waking up. All resources should be available during this event.
 
## How to install:

Download the SleepWarden zip archive from <https://github.com/execriez/SleepWarden>, then unzip the archive on a Mac workstation.

Ideally, to install - you should double-click the following installer package which can be found in the "SupportFiles" directory.

	SleepWarden.pkg
	
If the installer package isn't available, you can run the command-line installer which can be found in the "util" directory:

	sudo Install

The installer will install the following files and directories:

	/Library/LaunchDaemons/com.github.execriez.sleepwarden.plist
	/usr/SleepWarden/

There's no need to reboot.

After installation, your computer will speak whenever a sleep event occurs.

You can alter the example shell scripts to alter this behavior, these can be found in the following location:

	/usr/SleepWarden/bin/SleepWarden-IdleSleep
	/usr/SleepWarden/bin/SleepWarden-WillSleep
	/usr/SleepWarden/bin/SleepWarden-WillWake
	/usr/SleepWarden/bin/SleepWarden-HasWoken

If the installer fails you should check the logs.

## Logs:

Logs are written to the following file:

	/Library/Logs/com.github.execriez.sleepwarden.log

## How to uninstall:

To uninstall you should double-click the following uninstaller package which can be found in the "SupportFiles" directory.

	SleepWarden-Uninstaller.pkg
	
If the uninstaller package isn't available, you can uninstall from a shell by typing the following:

	sudo /usr/local/SleepWarden/util/Uninstall

The uninstaller will uninstall the following files and directories:

	/Library/LaunchDaemons/com.github.execriez.sleepwarden.plist
	/usr/SleepWarden/

There's no need to reboot.

After the uninstall everything goes back to normal, and primary network status changes will not be tracked.

## History:

1.0.4 - 10 OCT 2017

* First public release.

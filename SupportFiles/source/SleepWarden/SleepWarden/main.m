//
//  main.m
//  SleepWarden
//
//  Created by local on 28/09/2017.
//  Copyright © 2017 Mark Swift. All rights reserved.
//
//  Mostly lifted from:
//    Technical Q&A QA1340
//    Registering and unregistering for sleep and wake notifications
//    https://developer.apple.com/library/content/qa/qa1340/_index.html

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#include <mach/mach_port.h>
#include <mach/mach_interface.h>
#include <mach/mach_init.h>

#include <IOKit/pwr_mgt/IOPMLib.h>
#include <IOKit/IOMessage.h>

#import <Foundation/Foundation.h>

@interface NSString (ShellExecution)
- (NSString*)runAsCommand;
@end

@implementation NSString (ShellExecution)

- (NSString*)runAsCommand {
    NSPipe* pipe = [NSPipe pipe];
    
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];
    
    NSFileHandle* file = [pipe fileHandleForReading];
    [task launch];
    
    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
}

@end

io_connect_t  root_port; // a reference to the Root Power Domain IOService

void
MySleepCallBack( void * refCon, io_service_t service, natural_t messageType, void * messageArgument )
{

    NSString        * exepath = [[NSBundle mainBundle] executablePath];

    switch ( messageType )
    {
            
        case kIOMessageCanSystemSleep:
            /* Idle sleep is about to kick in. This message will not be sent for forced sleep.
             Applications have a chance to prevent sleep by calling IOCancelPowerChange.
             Most applications should not prevent idle sleep.
             
             Power Management waits up to 30 seconds for you to either allow or deny idle
             sleep. If you don't acknowledge this power change by calling either
             IOAllowPowerChange or IOCancelPowerChange, the system will wait 30
             seconds then go to sleep.
             */
            
            [[NSString stringWithFormat:@"%@-IdleSleep", exepath ] runAsCommand];
            NSLog(@"SystemIdleSleep");

            //Uncomment to cancel idle sleep
            //IOCancelPowerChange( root_port, (long)messageArgument );
            // we will allow idle sleep
            IOAllowPowerChange( root_port, (long)messageArgument );
            break;
            
        case kIOMessageSystemWillSleep:
            /* The system WILL go to sleep. If you do not call IOAllowPowerChange or
             IOCancelPowerChange to acknowledge this message, sleep will be
             delayed by 30 seconds.
             
             NOTE: If you call IOCancelPowerChange to deny sleep it returns
             kIOReturnSuccess, however the system WILL still go to sleep.
             */
            
            [[NSString stringWithFormat:@"%@-WillSleep", exepath ] runAsCommand];
            NSLog(@"SystemWillSleep");

            IOAllowPowerChange( root_port, (long)messageArgument );
            break;
            
        case kIOMessageSystemWillPowerOn:
            //System has started the wake up process...
            
            [[NSString stringWithFormat:@"%@-WillWake", exepath ] runAsCommand];
            NSLog(@"SystemWillWake");
            break;
            
        case kIOMessageSystemHasPoweredOn:
            //System has finished waking up...
 
            [[NSString stringWithFormat:@"%@-HasWoken", exepath ] runAsCommand];
            NSLog(@"SystemHasWoken");
            break;
            
        default:
            NSLog(@"Unknown message type: old %08lx", (long unsigned int)messageType);
            
            break;
            
    }
}


int main( int argc, char **argv )
{
    // notification port allocated by IORegisterForSystemPower
    IONotificationPortRef  notifyPortRef;
    
    // notifier object, used to deregister later
    io_object_t            notifierObject;
    // this parameter is passed to the callback
    void*                  refCon;
    
    // register to receive system sleep notifications
    
    root_port = IORegisterForSystemPower( refCon, &notifyPortRef, MySleepCallBack, &notifierObject );
    if ( root_port == 0 )
    {
        NSLog(@"IORegisterForSystemPower failed\n");

        printf("IORegisterForSystemPower failed\n");
        return 1;
    }
    
    // add the notification port to the application runloop
    CFRunLoopAddSource( CFRunLoopGetCurrent(),
                       IONotificationPortGetRunLoopSource(notifyPortRef), kCFRunLoopCommonModes );
    
    /* Start the run loop to receive sleep notifications. Don't call CFRunLoopRun if this code
     is running on the main thread of a Cocoa or Carbon application. Cocoa and Carbon
     manage the main thread's run loop for you as part of their event handling
     mechanisms.
     */
    CFRunLoopRun();
    
    //Not reached, CFRunLoopRun doesn't return in this case.
    return (0);
}
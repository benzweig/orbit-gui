//
//  PanelImageView.m
//  Popup
//
//  Created by Katherine Fang on 2/28/15.
//
//

#import "PanelButton.h"
NSString *runCommand(NSString *commandToRun);

@implementation PanelButton
// Monkey patch from http://stackoverflow.com/a/12310154
NSString *runCommand(NSString *commandToRun)
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    NSLog(@"run command: %@", commandToRun);
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *output;
    output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    return output;
}

int serviceNumber = 0;

-(void)mouseEntered:(NSEvent *)theEvent {
    
    NSLog(@"Mouse entered %@", self.identifier);
    //runCommand(@"mkdir ~/MyProject");
    
    if ([self.identifier isEqual: @"_NS:34"]) {
        serviceNumber = 1;
         NSLog(@"Value of serviceNumber = %d", serviceNumber);
    }
    if ([self.identifier isEqual: @"_NS:28"]) {
        serviceNumber = 2;
         NSLog(@"Value of serviceNumber = %d", serviceNumber);
    }
    if ([self.identifier isEqual: @"_NS:13"]) {
        serviceNumber = 3;
         NSLog(@"Value of serviceNumber = %d", serviceNumber);
    }
}

-(void)mouseDown:(NSEvent *)theEvent{
    if (serviceNumber == 1) {
        runCommand(@"orbit create-project My-Node.js-Project && cd ~/My-Node.js-Project && orbit create-service node && open ~/My-Node.js-Project");
    }
    if (serviceNumber == 2) {
        runCommand(@"mkdir ~/My-iOS-Project");
    }
    if (serviceNumber == 3) {
        runCommand(@"mkdir ~/My-Rails-Project");
    }
}

-(void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"Mouse exited");
    serviceNumber = 0;
    NSLog(@"Value of serviceNumber = %d", serviceNumber);
    
}

-(void)updateTrackingAreas
{
    if(self.trackingArea != nil) {
        [self removeTrackingArea:self.trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    self.trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

@end

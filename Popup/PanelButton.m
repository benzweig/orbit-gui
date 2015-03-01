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

-(void)mouseEntered:(NSEvent *)theEvent {
    
    NSLog(@"Mouse entered %@", self.identifier);
    //runCommand(@"orbit");
}

-(void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@"Mouse exited");
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

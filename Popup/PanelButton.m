//
//  PanelImageView.m
//  Popup
//
//  Created by Katherine Fang on 2/28/15.
//
//

#import "PanelButton.h"
#import "ApplicationDelegate.h"
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
    
    if ([self.identifier isEqual: @"_NS:36"]) {
        serviceNumber = 1;
        NSLog(@"Value of serviceNumber = %d", serviceNumber);
        
    }
    if ([self.identifier isEqual: @"_NS:29"]) {
        serviceNumber = 2;
         NSLog(@"Value of serviceNumber = %d", serviceNumber);
    }
    if ([self.identifier isEqual: @"_NS:13"]) {
        serviceNumber = 3;
         NSLog(@"Value of serviceNumber = %d", serviceNumber);
    }
}



-(void)mouseDown:(NSEvent *)theEvent{
   ApplicationDelegate *appDelegate = (ApplicationDelegate *)[[NSApplication sharedApplication] delegate];
    [appDelegate.menubarController.statusItemView mouseDown:nil];
    if (serviceNumber == 1) {
        runCommand(@"rm -rf ~/launchhack1/ && cd ~ && orbit create-project launchhack1 && cd launchhack1 && orbit create-service node && open . && orbit daemon");
    }
    if (serviceNumber == 2) {
        runCommand(@"rm -rf ~/launchhack2/ && cd ~ && orbit create-project launchhack2 && cd launchhack2 && orbit create-service node && open . && orbit daemon");
    }
    if (serviceNumber == 3) {
        runCommand(@"rm -rf ~/yelp-for-yelp-reviews/ && cd ~ && orbit create-project yelp-for-yelp-reviews && cd yelp-for-yelp-reviews && open .");
        runCommand(@"/usr/local/bin/launch-terminal.sh");

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            runCommand(@"cd ~/yelp-for-yelp-reviews && orbit daemon");
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            runCommand(@"cd ~/yelp-for-yelp-reviews && orbit create-service rails && orbit run rails rails new . && orbit run rails rails server -b 0.0.0.0");
        });
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

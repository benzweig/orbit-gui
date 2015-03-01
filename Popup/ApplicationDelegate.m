#import "ApplicationDelegate.h"

@implementation ApplicationDelegate

@synthesize panelController = _panelController;
@synthesize menubarController = _menubarController;

#pragma mark -

- (void)dealloc
{
    [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
}

#pragma mark -

void *kContextActivePanel = &kContextActivePanel;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kContextActivePanel) {
        self.menubarController.hasActiveIcon = self.panelController.hasActivePanel;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    // Install icon into the menu bar
    self.menubarController = [[MenubarController alloc] init];
    
    //This is the only way to be compatible to all ~30 menu styles (e.g. dark mode) available in Yosemite
    
    // register with an array of types you'd like to accept
    
    [self.menubarController.statusItemView.window registerForDraggedTypes:@[NSFilenamesPboardType]];
    self.menubarController.statusItemView.window.delegate = self;
    
    // TODO: Run the orbit daemon with the entire menubar application, not per applicatino
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Explicitly remove the icon from the menu bar
    self.menubarController = nil;
    return NSTerminateNow;
}

#pragma mark - Actions

- (IBAction)togglePanel:(id)sender
{
    self.menubarController.hasActiveIcon = !self.menubarController.hasActiveIcon;
    self.panelController.hasActivePanel = self.menubarController.hasActiveIcon;
}

#pragma mark - Public accessors

- (PanelController *)panelController
{
    if (_panelController == nil) {
        _panelController = [[PanelController alloc] initWithDelegate:self];
        [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
    }
    return _panelController;
}

#pragma mark - PanelControllerDelegate

- (StatusItemView *)statusItemViewForPanelController:(PanelController *)controller
{
    return self.menubarController.statusItemView;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    
    
    [self.menubarController.statusItemView mouseDown:nil];
    
    
    NSLog(@"dfdfdfs");
    //Get the files from the drop
    NSArray * files = [[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType];
    
    for(id file in files){
        
        NSLog(@"String1 -- '%@'", [NSString stringWithFormat:@"%@", file]); // works
        
        
    }
    
    return YES;
    //[NSApp sendAction:self.action to:self.target from:self];
    return NSDragOperationCopy;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender{
    [self.menubarController.statusItemView mouseDown:nil];
}

@end

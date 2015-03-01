#import "MenubarController.h"
#import "PanelController.h"

@interface ApplicationDelegate : NSObject <NSApplicationDelegate, PanelControllerDelegate,NSWindowDelegate>

@property (nonatomic, strong) MenubarController *menubarController;
@property (nonatomic, strong, readonly) PanelController *panelController;
@property(readonly, strong, atomic) NSStatusBarButton *button;

- (IBAction)togglePanel:(id)sender;



@end

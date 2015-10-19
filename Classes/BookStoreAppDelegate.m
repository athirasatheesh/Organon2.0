//
//  BookStoreAppDelegate.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "BookStoreAppDelegate.h"


@implementation BookStoreAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	tabBarController.selectedIndex = 0;
	[window makeKeyAndVisible];
}



// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	//viewController.view.backgroundColor = [UIColor redColor];
}
// Optional UITabBarControllerDelegate method
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
//	return NO;
//}
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}



- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end


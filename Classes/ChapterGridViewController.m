//
//  ChapterGridViewController.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChapterGridViewController.h"
#import "OrgChapterView.h"
#import "Common.h"

@implementation ChapterGridViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor =  [UIColor colorWithPatternImage: [UIImage imageNamed: @"JMSBBackGrnd.png"]];
	[self.navigationController.navigationBar setTintColor:navigationBarColor];
	for (int i = 0; i< 6;i++)
	{
		NSString * title = [NSString stringWithFormat:@"%d",i];
		OrgChapterView * imgV =  [[OrgChapterView alloc] initWithFrame:CGRectMake((i*25)+3,0,40,40) andTitle:title];
		//imgV.image = [UIImage imageNamed:@"email_icon.png"];
		imgV.backgroundColor = [UIColor clearColor];
		[self.view addSubview:imgV];
		[imgV release];
	}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}
	
- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
	[super touchesEnded:touches withEvent:event];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

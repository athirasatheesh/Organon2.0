//
//  OrgReadChapterViewController.m
//  BookStore
//
//  Created by Rahul on 25/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OrgReadChapterViewController.h"
#import "Common.h"
#import "JMSBDBMgrWrapper.h"

@implementation OrgReadChapterViewController
@synthesize webView,chaptersArray;

- (id)init
{
	if (self = [super init])
	{

	}
	return self;
}

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Custom initialization
	
		
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[self handleGoto];
	return YES;
}

- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered 
{
	int textLimit = 3;
	if(![textEntered isEqualToString:@""])
	{
		char alpha = [textEntered characterAtIndex:0];
		if (alpha<=47 || alpha>=58)
			return NO;	
	}
	return !([textField.text length]>=textLimit && [textEntered length] > range.length);
	
	return YES;	
}
- (void)viewWillAppear:(BOOL)animated
{
	if (bInitSuccess)
	{
		return;
	}
	if (chapter == nil)
	{

		if ( dispMode == MODE_INTRO)
		{
			chapter = @"1-151";
			[self hideControls];
		}
		else
		{
			chapter = @"1-294";
		}
	}
	else
	{
		[self hideControls];
	}

	bExactMatch = NO;
	currentChapIndex = 1;
	maxChapIndex  = 1;
	minChapIndex = 1;
	//dispMode = MODE_NONE;
	[self doInit];
	if (dispMode == MODE_INTRO && bRangeMode && searchString == nil)
	{
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
		NSString *appValue = (NSString *)CFPreferencesCopyAppValue(CFSTR("INTROPOINT"), kCFPreferencesCurrentApplication);					
		currentChapIndex = [appValue intValue];
	}
	if (dispMode == MODE_NONE && searchString == nil && [chapter isEqualToString:@"1-294"])// full mode
	{
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
		NSString *appValue = (NSString *)CFPreferencesCopyAppValue(CFSTR("FULLPOINT"), kCFPreferencesCurrentApplication);					
		currentChapIndex = [appValue intValue];
	}
	currentChapIndex =  currentChapIndex == 0 ? 1: currentChapIndex;

	[self populateReading];
	bInitSuccess = YES;

}
- (void)hideControls
{
	gotoLabel.hidden = YES;
	gototxtField.hidden = YES;
	switchtoChapter.hidden = YES;
	
}
- (void)doInit
{
	if (chapter && [chapter rangeOfString:@"-"].length > 0)
	{
		chaptersArray = [[NSArray alloc] initWithArray:[chapter componentsSeparatedByString:@"-"]];
		bRangeMode = YES;
		maxChapIndex = [[chaptersArray objectAtIndex:1]integerValue];
		minChapIndex = [[chaptersArray objectAtIndex:0]integerValue];
		currentChapIndex = minChapIndex;
	}
	if(!bRangeMode)
	{
		[right setEnabled:NO];
		[left setEnabled:NO];
	}
}
- (void)populateReading
{
	if (dispMode == MODE_INTRO && bRangeMode)
	{
		NSString *appValue = [NSString stringWithFormat:@"%d",currentChapIndex];
		CFPreferencesSetAppValue(CFSTR("INTROPOINT"), appValue,  kCFPreferencesCurrentApplication);					
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
	}
	if (dispMode == MODE_NONE && searchString == nil && [chapter isEqualToString:@"1-294"])// full mode
	{
		NSString *appValue = [NSString stringWithFormat:@"%d",currentChapIndex];
		CFPreferencesSetAppValue(CFSTR("FULLPOINT"), appValue,  kCFPreferencesCurrentApplication);					
		CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	if(currentChapIndex <= minChapIndex)
	{
		[left setEnabled:NO];
	}
	else
	{
		[left setEnabled:YES];
	}

	if (currentChapIndex >= maxChapIndex)
	{
		[right setEnabled:NO];
	}
	else
	{
		[right setEnabled: YES];
	}
	
	[self copyhtmlFromResourceToDocumentsDirectory]; 
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:HTML_FILE];
	if (htmlString)
	{
		[htmlString release];
	}
	htmlString = [[NSMutableString alloc]initWithContentsOfFile:filepath];

	NSString *currentChapter = nil;

	if ( dispMode != MODE_SUMMARY )
	{
		if (bRangeMode)
		{
			currentChapter = [[NSString alloc] initWithFormat:@"%d",currentChapIndex];
		}
		else
		{
			currentChapter =  [[NSString alloc] initWithString:chapter];
		}
	}
	else
	{
		currentChapter =  [[NSString alloc] initWithString:chapter];
		[right setEnabled:NO];
		[left setEnabled:NO];
	}
	
	if ( dispMode != MODE_INTRO && currentChapter)
	{
		titleLabel.text = currentChapter;
	}
		
	if ( dispMode != MODE_INTRO )
	{
		//[htmlString appendFormat:@"document.write( %@ %@ %@",@"\"<h4>" ,TAG_TITLE,@"</h4>\");\n"];
	}

	[htmlString appendFormat:@"document.write( %@ %@ %@",@"\"<p>" ,TAG_READING,@"</p>\");\n"];
	
	if (currentChapter)
	{
		//[htmlString replaceOccurrencesOfString:TAG_TITLE withString:currentChapter options:0 range:NSMakeRange(0, [htmlString length])];
	}

	NSArray *readingArray;
	if ( dispMode == MODE_SUMMARY )
	{
		readingArray = [[JMSBDBMgrWrapper sharedWrapper] findSummaryDetailsByChapter:currentChapter];
		if ([readingArray count] > 0)
		{
			NSString *paraReading = [[readingArray objectAtIndex:0]objectForKey:K_SUMMARY];
			paraReading = [paraReading stringByReplacingOccurrencesOfString:@"\n" withString:@"</p> <p> "];
			[htmlString replaceOccurrencesOfString:TAG_READING withString:paraReading options:0 range:NSMakeRange(0, [htmlString length])];
		}	
	}
	else if ( dispMode == MODE_INTRO)/// if introduction
	{
		readingArray = [[JMSBDBMgrWrapper sharedWrapper] findIntroduction:currentChapter];
		if ([readingArray count] > 0)
		{
			NSString *paraReading = [[readingArray objectAtIndex:0]objectForKey:K_PARA];
			paraReading = [paraReading stringByReplacingOccurrencesOfString:@"\n" withString:@"</p> <p> "];
			[htmlString replaceOccurrencesOfString:TAG_READING withString:paraReading options:0 range:NSMakeRange(0, [htmlString length])];
		}	
	}
	else
	{
		/// if normal cases
		readingArray = [[JMSBDBMgrWrapper sharedWrapper] findChapterDetails:currentChapter];
		if ([readingArray count] > 0)
		{
			NSString *chapterReading = [[readingArray objectAtIndex:0]objectForKey:K_READING];
			chapterReading = [chapterReading stringByReplacingOccurrencesOfString:@"\n" withString:@"</p> <p> "];
			[htmlString replaceOccurrencesOfString:TAG_READING withString:chapterReading options:0 range:NSMakeRange(0, [htmlString length])];
		}
	}


	[htmlString appendFormat:@"</script>\n</body>\n</html>"];
	[self setHighLighting];

	[webView loadHTMLString:htmlString baseURL:nil];
	[currentChapter release];
	[pool release];
}

- (id)initWithChapter:(NSString *)chapterString andSearchString:(NSString *)theSearchString andExactMatch:(BOOL) theExactMatch 
						andMode:(DISPLAY_MODE ) theMode andNibName:(NSString *)nibNameOrNil 
{
	if (self = [super initWithNibName:nibNameOrNil  bundle:nil]) 
	{
		// Custom initialization
		chapter = chapterString;
		searchString = theSearchString;
		bExactMatch = theExactMatch;
		currentChapIndex = 0;
		[self doInit];
		dispMode = theMode;
		
	}
	return self;
}
//NSString *tmpChapter;		
//		NSEnumerator *nse = [chaptersArray objectEnumerator];
//		
//		while(tmpChapter = [nse nextObject]) {
//			NSLog(@"%@", tmpChapter);
//		}
//		
-(IBAction) gotoNext:(id) sender
{
	currentChapIndex++;
	if (currentChapIndex <= maxChapIndex)
	{
		[self populateReading];
	}
	else
	{
		currentChapIndex--;
	}
}
-(IBAction) gotoPrev:(id) sender
{
	currentChapIndex--;
	if(currentChapIndex>=minChapIndex)
	{
		[self populateReading];
	}
	else
	{
		currentChapIndex++;
	}
}
- (void)handleGoto
{
	if (![gototxtField.text isEqualToString:@""])
	{
		if ([gototxtField.text intValue] > 294 ||
			[gototxtField.text intValue] < 1 )
		{
			UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"iOrganon" 
																message:@"Please enter a value 1-294" 
															   delegate:nil 
													  cancelButtonTitle:nil 
													  otherButtonTitles:@"OK", nil]; 
			[baseAlert show];
			[gototxtField resignFirstResponder];
			return;
		}
		currentChapIndex = [gototxtField.text intValue];
		[gototxtField resignFirstResponder];
		[self populateReading];
	}
}
-(IBAction) switchto:(id) sender
{
	//[self handleGoto];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor =  [UIColor colorWithPatternImage: [UIImage imageNamed: @"JMSBBackGrnd.png"]];
	[webView setBackgroundColor:[UIColor clearColor]];
	[self.navigationController.navigationBar setTintColor:navigationBarColor];
	if (self.navigationController.navigationBar.tag == 1)
	{
		dispMode = MODE_INTRO;
	}
	left.backgroundColor = [UIColor clearColor];
	right.backgroundColor = [UIColor clearColor];
	
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		
		CGRect leftFrame = left.frame;
		leftFrame.origin.x = 700;
		left.frame = leftFrame;
		
		
		CGRect rightFrame = right.frame;
		rightFrame.origin.x = 746;
		right.frame = rightFrame;
		
		
		CGRect titleFrame = titleLabel.frame;
		titleFrame.origin.x = 364;
		titleLabel.frame = titleFrame;
		
		
	} 
	

}
- (void)setHighLighting
{
	if (htmlString && searchString)
	{
		NSString *localString = nil;
		NSString *newString = nil;
		if (bExactMatch)
		{
			// put one space
			localString = [NSString stringWithFormat:@" %@ ",searchString];
			newString = [NSString stringWithFormat:@" %@ ",[searchString stringByReplacingCharactersInRange:NSMakeRange(0,1) 
																								 withString:[[searchString substringToIndex:1] capitalizedString]]];
		}
		else
		{
			localString = [NSString stringWithString:searchString];
			// if found the search string
			newString = [NSString stringWithString:[searchString stringByReplacingCharactersInRange:NSMakeRange(0,1) 
																						 withString:[[searchString substringToIndex:1] capitalizedString]]];
		}
		
		//		NSLog(@"the search string exact searchstring ----> <%@>",localString);
		if ([htmlString rangeOfString:localString].length > 0)
		{
			NSString *replaceText = [[NSString alloc]initWithFormat:@"<font size = 3 face = Verdana color = red bgcolor= green>%@</font>",localString];
			[htmlString replaceOccurrencesOfString:localString withString:replaceText options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
			[replaceText release];
		}
		// first capital case for search string
		//		NSLog(@"the search string exact newstring ----> <%@>",newString);
		if ([htmlString rangeOfString:newString].length > 0)
		{
			NSString *replaceText = [[NSString alloc]initWithFormat:@"<font size = 3 face = Verdana color = red bgcolor= green>%@</font>",newString];
			[htmlString replaceOccurrencesOfString:newString withString:replaceText options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
			[replaceText release];
		}
	}
	if (htmlString )
	{
		if ([htmlString rangeOfString:@"5th Edition"].length > 0 || [htmlString rangeOfString:@"6th Edition"].length > 0)
		{
			NSString *replaceText = [[NSString alloc]initWithFormat:@"<font> <b> %@ </b></font>",@"5th Edition"];
			
			[htmlString replaceOccurrencesOfString:@"5th Edition" withString:replaceText options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
			
			[replaceText release];
			
			replaceText = [[NSString alloc]initWithFormat:@"<font> <b> %@ </b></font>",@"6th Edition"];
			
			[htmlString replaceOccurrencesOfString:@"6th Edition" withString:replaceText options:NSLiteralSearch range:NSMakeRange(0, [htmlString length])];
			
			[replaceText release];
		}
	}
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

-(BOOL)copyhtmlFromResourceToDocumentsDirectory{
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filepath = [documentsDirectory stringByAppendingPathComponent:HTML_FILE];
	
	success = [fileManager fileExistsAtPath:filepath];
	
	if (success) 
	{
		success =  [fileManager removeItemAtPath:filepath error:&error];
	}	
	NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:HTML_FILE];
	
	success = [fileManager copyItemAtPath:defaultPath toPath:filepath error:&error];
	return success;
}

- (void)dealloc {
	if (htmlString)
	{
		[htmlString release];
	}
	if (chaptersArray)
	{
		[chaptersArray release];
	}
	[webView release];
    [super dealloc];
}


@end

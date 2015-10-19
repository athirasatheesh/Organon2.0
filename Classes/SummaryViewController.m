//
//  FirstViewController.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SummaryViewController.h"
#import "JMSBDBMgrWrapper.h"
#import "OrgReadChapterViewController.h"
#import "Common.h"


@implementation SummaryViewController
@synthesize summaryDataList;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
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

- (void)populateSummaryList
{

	NSArray *summaryTemp;
	summaryTemp = [[JMSBDBMgrWrapper sharedWrapper] findAllSummaries];
	if ([summaryTemp count] > 0)
	{
		for (int index = 0; index < [summaryTemp count]; index++) 
		{
			NSMutableDictionary *summaryDict =  [[NSMutableDictionary alloc]init];
			NSString *chapters = [[summaryTemp objectAtIndex:index]objectForKey:K_CHAPTERS];
			[summaryDict setObject:chapters forKey:K_CHAPTERS];
			NSString *summary = [[summaryTemp objectAtIndex:index]objectForKey:K_SUMMARY];
			[summaryDict setObject:summary forKey:K_SUMMARY];
			NSString *chapId = [[summaryTemp objectAtIndex:index]objectForKey:K_ID];
			[summaryDict setObject:chapId forKey:K_ID];
			[summaryDataList addObject:summaryDict];
			[summaryDict release];
		}
	}
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mytableView.backgroundColor = [UIColor clearColor];
	mytableView.delegate = self;
	mytableView.dataSource = self;
	self.view.backgroundColor =  [UIColor colorWithPatternImage: [UIImage imageNamed: @"JMSBBackGrnd.png"]];
	[self.navigationController.navigationBar setTintColor:navigationBarColor];
	if(!summaryDataList)
	{
		summaryDataList = [[NSMutableArray alloc]init];
	}
	[self populateSummaryList];
}

#pragma mark Table View datasource methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *CellIdentifier = @"TableCell";
	
	SummaryCell *textCell = (SummaryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(textCell == nil) 
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		{
			[[NSBundle mainBundle] loadNibNamed:@"SummaryCell-iPad" owner:self options:nil];
		} 
		else 
		{
			[[NSBundle mainBundle] loadNibNamed:@"SummaryCell" owner:self options:nil];
		}
		textCell = tblCell;
	}

	NSDictionary * summarydetails = [summaryDataList objectAtIndex:indexPath.row];

	textCell.summarylabel.text = [summarydetails objectForKey:K_SUMMARY];
	textCell.chapterlabel.text = [summarydetails objectForKey:K_CHAPTERS];
	if ([textCell.summarylabel.text length] > 50)
	{
		CGRect newFrame = textCell.summarylabel.frame;
		newFrame.size.height = [self calculateHeight:textCell.summarylabel];
		textCell.summarylabel.frame = newFrame;
		newFrame = textCell.frame;
		newFrame.size.height = [self calculateHeight:textCell.summarylabel];
		textCell.frame  = newFrame;
	}
	textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	textCell.selectionStyle = UITableViewCellSelectionStyleGray;
	return textCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [summaryDataList count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	DISPLAY_MODE currentMode = MODE_NONE;
	NSDictionary * summarydetails = [summaryDataList objectAtIndex:indexPath.row];
	
	NSString * niBNameToLoad = @""; 
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		niBNameToLoad = @"OrgReadChapterViewController-iPad";
	} 
	else 
	{
		niBNameToLoad = @"OrgReadChapterViewController";
	}

	OrgReadChapterViewController * viewController = [[OrgReadChapterViewController alloc]initWithChapter:[summarydetails objectForKey:K_CHAPTERS] 
													andSearchString:nil andExactMatch:NO andMode:currentMode andNibName:niBNameToLoad];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	[mytableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) calculateHeight:(UILabel*) theLabel
{
	CGSize maximumLabelSize;
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		maximumLabelSize = CGSizeMake(658,9999);
	} 
	else 
	{
		maximumLabelSize = CGSizeMake(213,9999);
	}
	
	
	
	
	CGSize expectedLabelSize = [theLabel.text sizeWithFont:theLabel.font 
								constrainedToSize:maximumLabelSize 
								lineBreakMode:theLabel.lineBreakMode];	
	return expectedLabelSize.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	SummaryCell *textCell = (SummaryCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	return [self calculateHeight:textCell.summarylabel] + 40;
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
	[summaryDataList release];
    [super dealloc];
}

@end

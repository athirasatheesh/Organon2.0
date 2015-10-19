//
//  OrgSearchViewController.m
//  BookStore
//
//  Created by Rahul on 28/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OrgSearchViewController.h"
#import "Common.h"
#import "JMSBDBMgrWrapper.h"
#import "OrgReadChapterViewController.h"

@implementation OrgSearchViewController
@synthesize searchDataList,searchSummaryDataList,searchIntroDataList;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization

    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.view.backgroundColor =  [UIColor colorWithPatternImage: [UIImage imageNamed: @"JMSBBackGrnd.png"]];
	[self.navigationController.navigationBar setTintColor:navigationBarColor];
	mySearchBar.tintColor = navigationBarColor;
	[mytableView setBackgroundColor:[UIColor clearColor]];
	nSectionCount = 0;
	
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		
		CGRect introFrame = IncludeIntroSwitch.frame;
		introFrame.origin.x = 674;
		IncludeIntroSwitch.frame = introFrame;
	
		CGRect matchFrame = matchSwitch.frame;
		matchFrame.origin.x = 674;
		matchSwitch.frame = matchFrame;

		CGRect introLblFrame = introLabel.frame;
		introLblFrame.origin.x = 614;
		introLabel.frame = introLblFrame;
			
	} 

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)thesearchText 
{ 
	//
	if ([thesearchText length] == 0) [searchBar resignFirstResponder]; 
} 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{ 
	nSectionCount = 0;
	searchText =  [searchBar.text retain];
	[self PerformSearch:searchText];
	[mytableView reloadData];
	[searchBar resignFirstResponder]; 
} 

- (void) PerformSearch:(NSString *)theSearchText
{
	if(!searchDataList)
	{
		searchDataList = [[NSMutableArray alloc]init];
	}
	[searchDataList removeAllObjects];
	
	if(!searchSummaryDataList)
	{
		searchSummaryDataList = [[NSMutableArray alloc]init];
	}
	[searchSummaryDataList removeAllObjects];
	
	if(!searchIntroDataList)
	{
		searchIntroDataList = [[NSMutableArray alloc]init];
	}
	[searchIntroDataList removeAllObjects];
	
	NSArray *array;
	array = [[JMSBDBMgrWrapper sharedWrapper] searchChaptersforMatch:theSearchText forExactMatch:matchSwitch.on];
	if ([array count] > 0)
	{
		nSectionCount++;
		for (int index = 0 ; index <[array count]; index++ )
		{
			NSMutableDictionary *summaryDict =  [[NSMutableDictionary alloc]init];
			NSString *chapter = [[array objectAtIndex:index]objectForKey:K_CHAPTER];
			[summaryDict setObject:chapter forKey:K_CHAPTER];

			
			NSString *chapterReading = [[array objectAtIndex:index]objectForKey:K_READING];
			[summaryDict setObject:chapterReading forKey:K_READING];
			if (chapterReading)
			{
				[searchDataList addObject:summaryDict];
				[summaryDict release];
			}
		}
		
	}
	if (IncludeSummarySwitch.on)
	{
		NSArray *summaryarray;
		summaryarray = [[JMSBDBMgrWrapper sharedWrapper] searchSummaryforMatch:theSearchText forExactMatch:matchSwitch.on];
		if ([summaryarray count] > 0)
		{
			nSectionCount++;
			for (int index = 0 ; index <[summaryarray count]; index++ )
			{
				NSMutableDictionary *summaryDict =  [[NSMutableDictionary alloc]init];
				NSString *chapter = [[summaryarray objectAtIndex:index]objectForKey:K_CHAPTERS];
				[summaryDict setObject:chapter forKey:K_CHAPTER];
				
				
				NSString *chapterReading = [[summaryarray objectAtIndex:index]objectForKey:K_SUMMARY];
				[summaryDict setObject:chapterReading forKey:K_READING];
				if (chapterReading)
				{
					[searchSummaryDataList addObject:summaryDict];
					[summaryDict release];
				}
			}
			
		}
	}	
	if (IncludeIntroSwitch.on)
	{
		NSArray *introArray;
		introArray = [[JMSBDBMgrWrapper sharedWrapper] searcIntroforMatch:theSearchText forExactMatch:matchSwitch.on];
		if ([introArray count] > 0)
		{
			nSectionCount++;
			for (int index = 0 ; index <[introArray count]; index++ )
			{
				NSMutableDictionary *summaryDict =  [[NSMutableDictionary alloc]init];
				NSString *chapter = [NSString stringWithFormat:@"%d", [[[introArray objectAtIndex:index]objectForKey:K_ID] intValue]];
				//NSString *chapter = [NSString stringWithString:@"X"];
				[summaryDict setObject:chapter forKey:K_CHAPTER];
				
				
				NSString *chapterReading = [[introArray objectAtIndex:index]objectForKey:K_PARA];
				[summaryDict setObject:chapterReading forKey:K_READING];
				if (chapterReading)
				{
					[searchIntroDataList addObject:summaryDict];
					[summaryDict release];
				}
			}
			
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
	
	NSDictionary * summarydetails = nil;
	switch (indexPath.section)
	{
		case 0:summarydetails = [searchDataList objectAtIndex:indexPath.row];break;
		case 1:summarydetails = [searchSummaryDataList objectAtIndex:indexPath.row];break;
		case 2:summarydetails = [searchIntroDataList objectAtIndex:indexPath.row];;break;
		default:break;
	}
	if (indexPath.section == 2)
	{
		textCell.chapterlabel.text  = [NSString stringWithString:@"X"];
	}
	else
	{
		textCell.chapterlabel.text = [summarydetails objectForKey:K_CHAPTER];
	}
	textCell.summarylabel.text = [summarydetails objectForKey:K_READING];
	textCell.summarylabel.lineBreakMode = UILineBreakModeTailTruncation;
	textCell.summarylabel.numberOfLines = 0;

	//newFrame.size.height += 90;
//	newFrame.origin.y -= 0;
	
	
	textCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	textCell.selectionStyle = UITableViewCellSelectionStyleGray;
	return textCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:return [searchDataList count];break;
		case 1:return [searchSummaryDataList count];break;
		case 2:return [searchIntroDataList count];break;
		default:break;
	}
	return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch (section)
	{
		case 0:if ([searchDataList count] > 0)return @"Chapters";break;
		case 1:if ([searchSummaryDataList count] > 0)return @"Summary";break;
		case 2:if ([searchIntroDataList count] > 0)return @"Introduction";break;
		default:break;
	}
	return @"";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSDictionary * summarydetails = nil;
	DISPLAY_MODE currentMode = MODE_NONE;
	switch (indexPath.section)
	{
		case 0:summarydetails = [searchDataList objectAtIndex:indexPath.row];break;
		case 1:summarydetails = [searchSummaryDataList objectAtIndex:indexPath.row]; currentMode = MODE_SUMMARY; break;
		case 2:summarydetails = [searchIntroDataList objectAtIndex:indexPath.row];currentMode = MODE_INTRO; break;
		default:break;
	}
	
	
	NSString * chapter = [summarydetails objectForKey:K_CHAPTER];
	
	
	NSString * niBNameToLoad = @""; 
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		niBNameToLoad = @"OrgReadChapterViewController-iPad";
	} 
	else 
	{
		niBNameToLoad = @"OrgReadChapterViewController";
	}

	
	
	OrgReadChapterViewController * viewController = [[OrgReadChapterViewController alloc]initWithChapter: chapter 
																						 andSearchString:searchText andExactMatch:NO andMode:currentMode andNibName:niBNameToLoad];
	[self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	[mytableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 50;
}

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
	[searchDataList release];
	[searchSummaryDataList release];
	[searchIntroDataList release];
	searchDataList = nil;
	[searchText release];
	searchText = nil;
    [super dealloc];
}


@end

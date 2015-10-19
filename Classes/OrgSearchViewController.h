//
//  OrgSearchViewController.h
//  BookStore
//
//  Created by Rahul on 28/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryCell.h"

@interface OrgSearchViewController : UIViewController {
	IBOutlet UITableView *mytableView;
	IBOutlet SummaryCell *tblCell;
	NSMutableArray * searchDataList;
	IBOutlet UISwitch *matchSwitch;
	NSString *searchText;
	IBOutlet UISearchBar *mySearchBar;
	IBOutlet UISwitch *IncludeSummarySwitch;
	IBOutlet UISwitch *IncludeIntroSwitch;
	
	IBOutlet UILabel *introLabel;
	
	NSMutableArray * searchSummaryDataList;
	NSMutableArray * searchIntroDataList;
	NSInteger nSectionCount;
}
@property (nonatomic, retain)NSMutableArray *searchDataList;
@property (nonatomic, retain)NSMutableArray *searchSummaryDataList;
@property (nonatomic, retain)NSMutableArray *searchIntroDataList;
- (void) PerformSearch:(NSString *)theSearchText;
@end

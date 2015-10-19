//
//  FirstViewController.h
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SummaryCell.h"

@interface SummaryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *mytableView;
	IBOutlet SummaryCell *tblCell;
	NSMutableArray * summaryDataList;
}
@property (nonatomic, retain)NSMutableArray *summaryDataList;
- (CGFloat) calculateHeight:(UILabel*) theLabel;
- (void)populateSummaryList;
@end

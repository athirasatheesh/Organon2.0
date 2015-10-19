//
//  SummaryCell.h
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SummaryCell : UITableViewCell {
	IBOutlet UILabel *chapterlabel;
	IBOutlet UILabel *summarylabel;
}
@property (nonatomic, retain) IBOutlet UILabel *chapterlabel;
@property (nonatomic, retain) IBOutlet UILabel *summarylabel;
@end

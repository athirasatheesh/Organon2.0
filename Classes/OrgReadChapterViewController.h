//
//  OrgReadChapterViewController.h
//  BookStore
//
//  Created by Rahul on 25/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface OrgReadChapterViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSMutableString *htmlString;
	NSString *searchString;
	BOOL bExactMatch;
	NSString *chapter;
	NSArray *chaptersArray;
	BOOL bRangeMode;
	NSInteger currentChapIndex;
	NSInteger maxChapIndex;
	NSInteger minChapIndex;
	IBOutlet UIButton *left;
	IBOutlet UIButton *right;
	IBOutlet UILabel *gotoLabel;
	IBOutlet UITextField *gototxtField;
	IBOutlet UIButton *switchtoChapter;
	BOOL bInitSuccess;
	DISPLAY_MODE dispMode;
	IBOutlet UILabel *titleLabel;
}
-(IBAction) gotoNext:(id) sender;
-(IBAction) gotoPrev:(id) sender;
-(IBAction) switchto:(id) sender;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSArray *chaptersArray;
-(BOOL)copyhtmlFromResourceToDocumentsDirectory;
- (void)setHighLighting;
- (id)initWithChapter:(NSString *)chapterString andSearchString:(NSString *)theSearchString 
		andExactMatch:(BOOL) theExactMatch  andMode:(DISPLAY_MODE ) theMode andNibName:(NSString *)nibNameOrNil ;
- (void)populateReading;
- (void)doInit;
- (void)hideControls;
- (void)handleGoto;
@end

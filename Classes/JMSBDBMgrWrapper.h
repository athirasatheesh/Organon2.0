//
//  JMSBDBMgrWrapper.h
//  JMSB
//
//  Created by ZCO Engineering Dept on 22/10/09.
//  Copyright 2009 ZCO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManager.h"

@interface JMSBDBMgrWrapper : NSObject {
	DataBaseManager *databaseManager;
	NSMutableString *myQuery;
}
+ (JMSBDBMgrWrapper*)sharedWrapper;
- (void)initDBMgr;
- (NSArray*) findAllSummaries;
- (NSArray*) findSummaryDetails:(NSInteger) theID;
- (NSArray*) findChapterDetails:(NSString*) theChapter;
- (NSArray*) searchChaptersforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch;
- (NSArray*) searchSummaryforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch;
- (NSArray*) searcIntroforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch;
- (NSArray*) findSummaryDetailsByChapter:(NSString*) theID;
- (NSArray*) findIntroduction:(NSString*) theID;
@end

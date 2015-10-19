//
//  JMSBDBMgrWrapper.m
//  JMSB
//
//  Created by ZCO Engineering Dept on 22/10/09.
//  Copyright 2009 ZCO. All rights reserved.
//

#import "JMSBDBMgrWrapper.h"


#define kMedicalDatabaseName @"Organon.sqlite"

@interface JMSBDBMgrWrapper(PRIVATE)
- (void)appendQueryString:(NSString *)fieldName forValue:(NSString *)theValue;
@end
static JMSBDBMgrWrapper *sharedGlobalWrapper = nil;

@implementation JMSBDBMgrWrapper

-(id)init
{
	if(self = [super init])
	{
		[self initDBMgr];
	}
	return self;
}
//	Function	:   initDBMgr
//	Purpose		:	Opens JMSB DB sqlite 
//	Parameter	:	nil
//	Return      :	nil
- (void)initDBMgr
{
	NSString *theDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kMedicalDatabaseName];
	
	if(!databaseManager){
		// Opens connection to the specified sqlite database
		databaseManager = [[DataBaseManager alloc]initDBWithFileName:theDatabasePath];
	}
}
//	Function	:   sharedWrapper
//	Purpose		:	return shared wrapper instance
//	Parameter	:	nil
//	Return      :	sharedWrapper
+ (JMSBDBMgrWrapper*)sharedWrapper
{
	@synchronized(self) {
        if (sharedGlobalWrapper == nil) {
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedGlobalWrapper;
	
}
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedGlobalWrapper == nil) {
            sharedGlobalWrapper = [super allocWithZone:zone];
            return sharedGlobalWrapper;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
	if(databaseManager)
	{
		[databaseManager close];
		[databaseManager  release];
		databaseManager = nil;
	}
}

- (id)autorelease
{
    return self;
}

//	Function	:   findAllSummaries
//	Purpose		:	find all sessions from sessions table
//	Parameter	:	nil
//	Return      :	array of sessions
- (NSArray*) findAllSummaries //Chapters,Summary
{
	NSArray *summaryArray;
	summaryArray = [databaseManager executeQuery:@"SELECT *  FROM tblSummaries order by Id"];
	return [summaryArray autorelease];
}

//	Function	:   findSummaryDetails
//	Purpose		:	find all summary info from summaries table
//	Parameter	:	nil
//	Return      :	array of summary
- (NSArray*) findSummaryDetails:(NSInteger) theID
{
	NSArray *summaryArray;
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM tblSummaries WHERE Id = %d ",theID];
	summaryArray = [databaseManager executeQuery:query];
	return [summaryArray autorelease];
}

//	Function	:   findChapterDetails
//	Purpose		:	find all chapter info from chapter table
//	Parameter	:	nil
//	Return      :	array of summary
- (NSArray*) findChapterDetails:(NSString*) theChapter
{
	NSArray *chapterArray;
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM  tblChapters WHERE Chapter = \'%@\'",theChapter];
	chapterArray = [databaseManager executeQuery:query];
	return [chapterArray autorelease];
}
//	Function	:   findSummaryDetailsByChapter
//	Purpose		:	find summary details
//	Parameter	:	nil
//	Return      :	array of summparasary
- (NSArray*) findSummaryDetailsByChapter:(NSString*) theID
{
	NSArray *paraArray;
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM  tblSummaries where Chapters =\'%@\'",theID];
	paraArray = [databaseManager executeQuery:query];
	return [paraArray autorelease];
}

//	Function	:   findIntroduction
//	Purpose		:	find all intro paras
//	Parameter	:	nil
//	Return      :	array of summparasary
- (NSArray*) findIntroduction:(NSString*) theID
{
	NSArray *paraArray;
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM  tblIntroduction where Id = %@",theID];
	paraArray = [databaseManager executeQuery:query];
	return [paraArray autorelease];
}
//	Function	:   searchChaptersforMatch
//	Purpose		:	search matching records
//	Parameter	:	nil
//	Return      :	array of matching records
- (NSArray*) searchChaptersforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch
{
	myQuery =[[NSMutableString alloc] initWithString:@""];
	NSString * newString = @"";
	if (bExactSearch)
	{
		newString = [NSString stringWithFormat:@" %@ ",theMatchString];
	}
	else
	{
		newString = [NSString stringWithFormat:@"%@",theMatchString];
	}
	
	newString = [newString lowercaseString];
	
	NSArray *classArray;

	[myQuery appendFormat:@"Select * from tblChapters where ",newString];
	NSString *keyStr = [NSString stringWithFormat:@"lower(%@)",@"Reading"];
	[self appendQueryString:keyStr forValue:newString];
	classArray = [databaseManager executeQuery:myQuery];
	[myQuery release];
	return [classArray autorelease];
}


//	Function	:   searchSummaryforMatch
//	Purpose		:	search matching records
//	Parameter	:	nil
//	Return      :	array of matching records
- (NSArray*) searchSummaryforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch
{
	myQuery =[[NSMutableString alloc] initWithString:@""];
	NSString * newString = @"";
	if (bExactSearch)
	{
		newString = [NSString stringWithFormat:@" %@ ",theMatchString];
	}
	else
	{
		newString = [NSString stringWithFormat:@"%@",theMatchString];
	}
	
	newString = [newString lowercaseString];
	
	NSArray *classArray;
	
	[myQuery appendFormat:@"Select * from tblSummaries where ",newString];
	NSString *keyStr = [NSString stringWithFormat:@"lower(%@)",@"Summary"];
	[self appendQueryString:keyStr forValue:newString];
	classArray = [databaseManager executeQuery:myQuery];
	[myQuery release];
	return [classArray autorelease];
}


//	Function	:   searcIntroforMatch
//	Purpose		:	search matching records
//	Parameter	:	nil
//	Return      :	array of matching records
- (NSArray*) searcIntroforMatch:(NSString*) theMatchString forExactMatch: (BOOL) bExactSearch
{
	myQuery =[[NSMutableString alloc] initWithString:@""];
	NSString * newString = @"";
	if (bExactSearch)
	{
		newString = [NSString stringWithFormat:@" %@ ",theMatchString];
	}
	else
	{
		newString = [NSString stringWithFormat:@"%@",theMatchString];
	}
	
	newString = [newString lowercaseString];
	
	NSArray *classArray;
	
	[myQuery appendFormat:@"Select * from tblIntroduction where ",newString];
	NSString *keyStr = [NSString stringWithFormat:@"lower(%@)",@"Para"];
	[self appendQueryString:keyStr forValue:newString];
	classArray = [databaseManager executeQuery:myQuery];
	[myQuery release];
	return [classArray autorelease];
}
//	Function	:   appendQueryString
//	Purpose		:	append like and ' etc
//	Parameter	:	nil
//	Return      :	nil
- (void)appendQueryString:(NSString *)fieldName forValue:(NSString *)theValue
{
	[myQuery appendFormat:@"%@ like ",fieldName];
	NSString *temp = @"'%";
	[myQuery appendString:temp];
	[myQuery appendFormat:@"%@",theValue];	
	[myQuery appendString:@"%'"];
}

@end

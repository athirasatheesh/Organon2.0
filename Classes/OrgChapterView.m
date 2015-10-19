//
//  OrgChapterView.m
//  BookStore
//
//  Created by Rahul on 22/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OrgChapterView.h"
#import "OrgImageView.h"

@implementation OrgChapterView


- (id)initWithFrame:(CGRect)frame andTitle:(NSString*) theTitle
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		OrgImageView *imgV = [[OrgImageView alloc]initWithFrame:frame];
		
		[imgV  setSkinImage:[UIImage imageNamed: @"email_icon.png"]];
		[self addSubview:imgV];
		[imgV release];
		
		CGRect myrect = frame;
		myrect.origin.x += 10;
		myrect.origin.y += 5;
		myrect.size.width -=10;
		myrect.size.height -=5;
		
		UILabel *label =  [[UILabel alloc]initWithFrame:myrect];
		label.text = theTitle;
		label.backgroundColor = [UIColor clearColor];
		label.textColor =  [UIColor redColor];
		[self addSubview:label];
		[label release];
	}
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{	
	[super touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end

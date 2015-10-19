/*
 *  Common.h
 *  BookStore
 *
 *  Created by Rahul on 27/01/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#define HTML_FILE @"Message.htm"
#define TAG_TITLE @"<TITLE>"
#define TAG_READING @"<READING>"


#define K_ID @"Id"
#define K_CHAPTERS @"Chapters"
#define K_SUMMARY @"Summary"

#define K_CHAPTER @"Chapter"
#define K_READING @"Reading"

#define K_PARA @"Para"

#define navigationBarColor [UIColor colorWithRed:0.58375 green:0.46375 blue:0.3109375 alpha:0]
//0.58375 -> 148.8562
//0.46375 -> 118.2562
//0.3109375 -> 79.2890
typedef enum displaymode
{
	MODE_NONE,
	MODE_SUMMARY,
	MODE_INTRO
}
DISPLAY_MODE;
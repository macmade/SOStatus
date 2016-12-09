/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * Distributed under the Boost Software License, Version 1.0.
 * 
 * Boost Software License - Version 1.0 - August 17th, 2003
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ...
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/* ... */
#define SO_API_KEY                  @"DST0JdR3pUi0R2OWJWfwdQ"

/* ... */
#define SO_URL_API                  @"http://api.stackoverflow.com/1.1"

/* Get the users identified by a set of ids */
#define SO_URL_API_USERS            @"/users/%@"

/* Get the answers posted by the users identified by a set of ids */
#define SO_URL_API_USERS_ANSWERS    @"/users/%@/answers"

/* Get the comments posted by the users identified by a set of ids */
#define SO_URL_API_USERS_COMMENTS   @"/users/%@/comments"

/* Get the questions favorited by users identified by a set of ids */
#define SO_URL_API_USERS_FAVORITES  @"/users/%@/favorites"

/* Get the comments that mention one of the users identified by a set of ids */
#define SO_URL_API_USERS_MENTIONS   @"/users/%@/mentioned"

/* Get the questions asked by the users identified by a set of ids */
#define SO_URL_API_USERS_QUESTIONS  @"/users/%@/questions"

/* Get a subset of the reputation changes experienced by the users identified by a set of ids */
#define SO_URL_API_USERS_REPUTATION @"/users/%@/reputation"

/* Get a subset of the actions of that have been taken by the users identified by a set of ids */
#define SO_URL_API_USERS_TIMELINE   @"/users/%@/timeline"

/* ... */
#define SO_URL_ANSWER               @"http://stackoverflow.com/a/%lu"

/* ... */
#define SO_URL_QUESTION             @"http://stackoverflow.com/q/%lu"

typedef enum
{
    SOPostTypeUnknown  = 0x00,
    SOPostTypeAnswer   = 0x01,
    SOPostTypeQuestion = 0x02,
}
SOPostType;

@interface SOItem: NSObject
{
@protected
    
    NSUInteger _itemID;
    NSString * _title;
    NSURL    * _url;
    
@private
    
    id _SOItem_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( atomic, readonly ) NSUInteger itemID;
@property( atomic, readonly ) NSString * title;
@property( atomic, readonly ) NSURL    * url;

@end
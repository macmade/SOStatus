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

#import "SOItem.h"

@class StackOverflowUser;
@class NetworkReachability;

@interface SOUser: SOItem
{
@protected
    
    NSInteger  _totalReputation;
    NSUInteger _goldBadges;
    NSUInteger _silverBadges;
    NSUInteger _bronzeBadges;
    NSUInteger _questionCount;
    NSUInteger _answerCount;
    NSUInteger _viewCount;
    NSUInteger _upVoteCount;
    NSUInteger _downVoteCount;
    NSUInteger _acceptRate;
    NSString * _username;
    NSArray  * _answers;
    NSArray  * _questions;
    NSArray  * _comments;
    NSArray  * _favorites;
    NSArray  * _mentions;
    NSArray  * _reputation;
    NSArray  * _timeline;
    
@private
    
    id _SOUser_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property ( atomic, readonly ) NSString     * username;
@property ( atomic, readonly ) NSString     * reputationString;
@property ( atomic, readonly ) NSInteger      totalReputation;
@property ( atomic, readonly ) NSUInteger     goldBadges;
@property ( atomic, readonly ) NSUInteger     silverBadges;
@property ( atomic, readonly ) NSUInteger     bronzeBadges;
@property ( atomic, readonly ) NSUInteger     questionCount;
@property ( atomic, readonly ) NSUInteger     answerCount;
@property ( atomic, readonly ) NSUInteger     viewCount;
@property ( atomic, readonly ) NSUInteger     upVoteCount;
@property ( atomic, readonly ) NSUInteger     downVoteCount;
@property ( atomic, readonly ) NSUInteger     acceptRate;
@property ( atomic, readonly ) NSArray      * answers;
@property ( atomic, readonly ) NSArray      * questions;
@property ( atomic, readonly ) NSArray      * comments;
@property ( atomic, readonly ) NSArray      * favorites;
@property ( atomic, readonly ) NSArray      * mentions;
@property ( atomic, readonly ) NSArray      * reputation;
@property ( atomic, readonly ) NSArray      * timeline;

- ( id )initWithUserID: ( NSUInteger )userID;
- ( BOOL )refresh;

@end

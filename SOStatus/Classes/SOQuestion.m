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
 * @file        ...
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "SOQuestion.h"
#import "SOUser.h"

@implementation SOQuestion

@synthesize upVotes     = _upVotes;
@synthesize downVotes   = _downVotes;
@synthesize score       = _score;
@synthesize views       = _views;

+ ( NSArray * )questionsFromJSONDictionary: ( NSDictionary * )json
{
    NSMutableArray * ret;
    NSDictionary   * dict;
    SOQuestion     * obj;
    
    ret = [ NSMutableArray arrayWithCapacity: json.count ];
    
    for( dict in [ json objectForKey: @"questions" ] )
    {
        obj = [ SOQuestion questionFromJSONDictionary: dict ];
        
        if( obj != nil )
        {
            [ ret addObject: obj ];
        }
    }
    
    return ret;
}


+ ( SOQuestion * )questionFromJSONDictionary: ( NSDictionary * )dict
{
    SOQuestion * obj;
    
    obj = [ [ SOQuestion alloc ] initWithJSONDictionary: dict ];
    
    return [ obj autorelease ];
}

- ( id )initWithJSONDictionary: ( NSDictionary * )dict
{
    if( ( self = [ super init ] ) )
    {
        ( void )dict;
        
        if( dict == nil )
        {
            [ self release ];
            
            return nil;
        }
        
        _itemID     = [ [ dict objectForKey: @"question_id" ] unsignedIntegerValue ];
        _title      = [ [ dict objectForKey: @"title" ] copy ];
        _url        = [ [ NSURL URLWithString: [ NSString stringWithFormat: SO_URL_QUESTION, _itemID ] ] retain ];
        _upVotes    = [ [ dict objectForKey: @"up_vote_count" ] unsignedIntegerValue ];
        _downVotes  = [ [ dict objectForKey: @"up_vote_count" ] unsignedIntegerValue ];
        _score      = [ [ dict objectForKey: @"score" ] integerValue ];
        _views      = [ [ dict objectForKey: @"view_count" ] unsignedIntegerValue ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ _title    release ];
    [ _url      release ];
    
    [ super dealloc ];
}

@end

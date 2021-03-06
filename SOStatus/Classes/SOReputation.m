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

#import "SOReputation.h"

@implementation SOReputation

@synthesize score    = _score;
@synthesize postType = _postType;

+ ( NSArray * )reputationsFromJSONDictionary: ( NSDictionary * )json
{
    NSMutableArray * ret;
    NSDictionary   * dict;
    SOReputation   * obj;
    
    ret = [ NSMutableArray arrayWithCapacity: json.count ];
    
    for( dict in [ json objectForKey: @"rep_changes" ] )
    {
        obj = [ SOReputation reputationFromJSONDictionary: dict ];
        
        if( obj != nil )
        {
            [ ret addObject: obj ];
        }
    }
    
    return ret;
}


+ ( SOReputation * )reputationFromJSONDictionary: ( NSDictionary * )dict
{
    SOReputation * obj;
    
    obj = [ [ SOReputation alloc ] initWithJSONDictionary: dict ];
    
    return [ obj autorelease ];
}

- ( id )initWithJSONDictionary: ( NSDictionary * )dict
{
    NSNumber * positive;
    NSNumber * negative;
    
    if( ( self = [ super init ] ) )
    {
        ( void )dict;
        
        if( dict == nil )
        {
            [ self release ];
            
            return nil;
        }
        
        _itemID = [ [ dict objectForKey: @"post_id" ] unsignedIntegerValue ];
        _title  = [ [ dict objectForKey: @"title" ] copy ];
        
        if( [ [ dict objectForKey: @"post_type" ] isEqualToString: @"question" ] )
        {
            _postType = SOPostTypeQuestion;
            _url      = [ [ NSURL URLWithString: [ NSString stringWithFormat: SO_URL_QUESTION, _itemID ] ] retain ];
        }
        else if( [ [ dict objectForKey: @"post_type" ] isEqualToString: @"answer" ] )
        {
            _postType = SOPostTypeAnswer;
            _url      = [ [ NSURL URLWithString: [ NSString stringWithFormat: SO_URL_ANSWER, _itemID ] ] retain ];
        }
        
        positive = [ dict objectForKey: @"positive_rep" ];
        negative = [ dict objectForKey: @"negative_rep" ];
        _score   = [ positive integerValue ] - [ negative integerValue ];
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

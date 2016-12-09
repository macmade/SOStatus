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

#import "ApplicationDelegate.h"
#import "PreferencesController.h"
#import "AboutController.h"
#import "SOItem.h"
#import "SOUser.h"
#import "SOQuestion.h"
#import "SOAnswer.h"
#import "SOComment.h"
#import "SOMention.h"
#import "SOFavorite.h"
#import "SOReputation.h"
#import "SOTimeline.h"

#define GREEN   [ NSColor colorWithDeviceRed: ( CGFloat )0.00 green: ( CGFloat )0.65 blue: ( CGFloat )0.00 alpha: ( CGFloat )1 ]
#define RED     [ NSColor colorWithDeviceRed: ( CGFloat )0.75 green: ( CGFloat )0.00 blue: ( CGFloat )0.00 alpha: ( CGFloat )1 ]
#define GRAY    [ NSColor colorWithDeviceRed: ( CGFloat )0.50 green: ( CGFloat )0.50 blue: ( CGFloat )0.50 alpha: ( CGFloat )1 ]

@interface ApplicationDelegate( NSMenuDelegate ) < NSMenuDelegate >

@end

@implementation ApplicationDelegate( NSMenuDelegate )

- ( void )menuWillOpen: ( NSMenu * )menu
{
    ( void )menu;
    
    [ _statusItem setImage: [ NSImage imageNamed: @"MenuItem-Off.tif" ] ];
}

@end

@interface ApplicationDelegate( Private )

- ( void )preferencesChanged;
- ( void )createUser;
- ( void )updateUser;
- ( void )updateMenu;
- ( void )menuItemSelected: ( NSMenuItem * )menuItem;

@end

@implementation ApplicationDelegate( Private )

- ( void )preferencesChanged
{
    [ self createUser ];
}

- ( void )menuItemSelected: ( NSMenuItem * )menuItem
{
    SOItem * item;
    
    ( void )menuItem;
    
    item = ( SOItem * )( menuItem.representedObject );
    
    [ [ NSWorkspace sharedWorkspace ] openURL: item.url ];
}

- ( void )createUser
{
    [ _user  release ];
    [ _timer invalidate ];
    
    _timer = nil;
    _user  = [ [ SOUser alloc ] initWithUserID: [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"User" ] unsignedIntegerValue ] ];
    
    if( _user == nil )
    {
        return;
    }
    
    [ self updateUser ];;
    
    _timer = [ NSTimer scheduledTimerWithTimeInterval: 60 target: self selector: @selector( updateUser ) userInfo: nil repeats: YES ];
}

- ( void )updateUser
{
    NSInteger reputation;
    
    if( [ _user refresh ] == NO )
    {
        return;
    }
    
    reputation = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"Reputation" ] integerValue ];
    
    if( reputation != _user.totalReputation )
    {
        [ _statusItem setImage: [ NSImage imageNamed: @"MenuItem-Act.tif" ] ];
    }
    
    [ [ NSUserDefaults standardUserDefaults ] setObject: [ NSNumber numberWithInteger: _user.totalReputation ] forKey: @"Reputation" ];
    [ [ NSUserDefaults standardUserDefaults ] synchronize ];
    [ self updateMenu ];
}

- ( void )updateMenu
{
    NSMenu * menu;
    
    menu = _statusItem.menu;
    
    if( _hasMenuItems == YES )
    {
        [ menu removeItemAtIndex: 10 ];
        [ menu removeItemAtIndex:  9 ];
        [ menu removeItemAtIndex:  8 ];
        [ menu removeItemAtIndex:  7 ];
        [ menu removeItemAtIndex:  6 ];
        [ menu removeItemAtIndex:  5 ];
        [ menu removeItemAtIndex:  4 ];
        [ menu removeItemAtIndex:  3 ];
        [ menu removeItemAtIndex:  2 ];
    }
    
    _usernameItem   = [ [ NSMenuItem alloc ] initWithTitle: @""                                         action: NULL keyEquivalent: @"" ];
    _questionsItem  = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Questions",    nil )   action: NULL keyEquivalent: @"" ];
    _answersItem    = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Answers",      nil )   action: NULL keyEquivalent: @"" ];
    _commentsItem   = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Comments",     nil )   action: NULL keyEquivalent: @"" ];
    _mentionsItem   = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Mentions",     nil )   action: NULL keyEquivalent: @"" ];
    _favoritesItem  = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Favorites",    nil )   action: NULL keyEquivalent: @"" ];
    _reputationItem = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Reputation",   nil )   action: NULL keyEquivalent: @"" ];
    
    _userBadgesGoldItem     = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userBadgesSilverItem   = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userBadgesBronzeItem   = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userQuestionCount      = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userAnswerCount        = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userViewCount          = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userUpVoteCount        = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userDownVoteCount      = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    _userAcceptRate         = [ [ NSMenuItem alloc ] initWithTitle: @"" action: NULL keyEquivalent: @"" ];
    
    _userMenu       = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _questionsMenu  = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _answersMenu    = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _commentsMenu   = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _mentionsMenu   = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _favoritesMenu  = [ [ NSMenu alloc ] initWithTitle: @"" ];
    _reputationMenu = [ [ NSMenu alloc ] initWithTitle: @"" ];
    
    [ _userMenu insertItem: _userViewCount                atIndex:  0 ];
    [ _userMenu insertItem: _userAcceptRate               atIndex:  1 ];
    [ _userMenu insertItem: [ NSMenuItem separatorItem ]  atIndex:  2 ];
    [ _userMenu insertItem: _userQuestionCount            atIndex:  3 ];
    [ _userMenu insertItem: _userAnswerCount              atIndex:  4 ];
    [ _userMenu insertItem: [ NSMenuItem separatorItem ]  atIndex:  5 ];
    [ _userMenu insertItem: _userUpVoteCount              atIndex:  6 ];
    [ _userMenu insertItem: _userDownVoteCount            atIndex:  7 ];
    [ _userMenu insertItem: [ NSMenuItem separatorItem ]  atIndex:  8 ];
    [ _userMenu insertItem: _userBadgesGoldItem           atIndex:  9 ];
    [ _userMenu insertItem: _userBadgesSilverItem         atIndex: 10 ];
    [ _userMenu insertItem: _userBadgesBronzeItem         atIndex: 11 ];
    
    [ _usernameItem     setSubmenu: _userMenu ];
    [ _questionsItem    setSubmenu: _questionsMenu ];
    [ _answersItem      setSubmenu: _answersMenu ];
    [ _commentsItem     setSubmenu: _commentsMenu ];
    [ _mentionsItem     setSubmenu: _mentionsMenu ];
    [ _favoritesItem    setSubmenu: _favoritesMenu ];
    [ _reputationItem   setSubmenu: _reputationMenu ];
    
    [ _statusItem           setTitle: [ NSString stringWithFormat: @"%@", _user.reputationString ] ];
    [ _usernameItem         setTitle: _user.username ];
    [ _userBadgesGoldItem   setTitle: [ NSLocalizedString( @"GoldBadges", nil )     stringByAppendingFormat: @"%lu",    _user.goldBadges ] ];
    [ _userBadgesSilverItem setTitle: [ NSLocalizedString( @"SilverBadges", nil )   stringByAppendingFormat: @"%lu",    _user.silverBadges ] ];
    [ _userBadgesBronzeItem setTitle: [ NSLocalizedString( @"BronzeBadges", nil )   stringByAppendingFormat: @"%lu",    _user.bronzeBadges ] ];
    [ _userQuestionCount    setTitle: [ NSLocalizedString( @"QuestionCount", nil )  stringByAppendingFormat: @"%lu",    _user.questionCount ] ];
    [ _userAnswerCount      setTitle: [ NSLocalizedString( @"AnswerCount", nil )    stringByAppendingFormat: @"%lu",    _user.answerCount ] ];
    [ _userViewCount        setTitle: [ NSLocalizedString( @"ViewCount", nil )      stringByAppendingFormat: @"%lu",    _user.viewCount ] ];
    [ _userUpVoteCount      setTitle: [ NSLocalizedString( @"UpVoteCount", nil )    stringByAppendingFormat: @"%lu",    _user.upVoteCount ] ];
    [ _userDownVoteCount    setTitle: [ NSLocalizedString( @"DownVoteCount", nil )  stringByAppendingFormat: @"%lu",    _user.downVoteCount ] ];
    [ _userAcceptRate       setTitle: [ NSLocalizedString( @"AcceptRate", nil )     stringByAppendingFormat: @"%lu%%",  _user.acceptRate ] ];
    
    {
        NSUInteger                  i;
        SOAnswer                  * answer;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.answers.count; i++ )
        {
            answer                 = [ _user.answers objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = answer;
            
            string = [ NSString stringWithFormat: @"%li - %@", answer.score, answer.title ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @" - " ];
            
            if( answer.score > 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GREEN forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else if( answer.score == 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GRAY forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: RED forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            
            [ item setAttributedTitle: title ];
            [ _answersMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    {
        NSUInteger                  i;
        SOQuestion                * question;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.questions.count; i++ )
        {
            question               = [ _user.questions objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = question;
            
            string = [ NSString stringWithFormat: @"%li - %@", question.score, question.title ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @" - " ];
            
            if( question.score > 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GREEN forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else if( question.score == 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GRAY forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: RED forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            
            [ item setAttributedTitle: title ];
            [ _questionsMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    {
        NSUInteger                  i;
        SOComment                 * comment;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.comments.count; i++ )
        {
            comment                = [ _user.comments objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = comment;
            
            string = ( comment.title.length > 50 ) ? [ [ comment.title substringToIndex: 50 ] stringByAppendingString: @" [...]" ] : comment.title;
            string = [ NSString stringWithFormat: @"%li - %@", comment.score, string ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @" - " ];
            
            if( comment.score > 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GREEN forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else if( comment.score == 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GRAY forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: RED forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            
            [ item setAttributedTitle: title ];
            [ _commentsMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    {
        NSUInteger                  i;
        SOMention                 * mention;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.mentions.count; i++ )
        {
            mention                = [ _user.mentions objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = mention;
            
            string = ( mention.title.length > 75 ) ? [ [ mention.title substringToIndex: 75 ] stringByAppendingString: @" [...]" ] : mention.title;
            string = [ NSString stringWithFormat: @"%@: %@", mention.author, string ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @": " ];
            
            [ title setAttributes: [ NSDictionary dictionaryWithObject: GRAY forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            [ item setAttributedTitle: title ];
            [ _mentionsMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    {
        NSUInteger                  i;
        SOReputation              * rep;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.reputation.count; i++ )
        {
            rep                    = [ _user.reputation objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = rep;
            
            string = [ NSString stringWithFormat: @"%+li - %@", rep.score, rep.title ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @" - " ];
            
            if( rep.score > 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GREEN forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: RED forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            
            [ item setAttributedTitle: title ];
            [ _reputationMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    {
        NSUInteger                  i;
        SOQuestion                * favorite;
        NSMenuItem                * item;
        NSString                  * string;
        NSMutableAttributedString * title;
        NSRange                     range;
        
        for( i = 0; i < _user.favorites.count; i++ )
        {
            favorite               = [ _user.favorites objectAtIndex: i ];
            item                   = [ [ NSMenuItem alloc ] init ];
            item.action            = @selector( menuItemSelected: );
            item.target            = self;
            item.representedObject = favorite;
            
            string = [ NSString stringWithFormat: @"%li - %@", favorite.score, favorite.title ];
            title  = [ [ NSMutableAttributedString alloc ] initWithString: string ];
            range  = [ string rangeOfString: @" - " ];
            
            if( favorite.score > 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GREEN forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else if( favorite.score == 0 )
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: GRAY forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            else
            {
                [ title setAttributes: [ NSDictionary dictionaryWithObject: RED forKey: NSForegroundColorAttributeName ] range: NSMakeRange( 0, range.location ) ];
            }
            
            [ item setAttributedTitle: title ];
            [ _favoritesMenu addItem: item ];
            [ item  release ];
            [ title release ];
        }
    }
    
    [ menu insertItem: _usernameItem                atIndex:  2 ];
    [ menu insertItem: [ NSMenuItem separatorItem ] atIndex:  3 ];
    [ menu insertItem: _questionsItem               atIndex:  4 ];
    [ menu insertItem: _answersItem                 atIndex:  5 ];
    [ menu insertItem: _commentsItem                atIndex:  6 ];
    [ menu insertItem: _mentionsItem                atIndex:  7 ];
    [ menu insertItem: _favoritesItem               atIndex:  8 ];
    [ menu insertItem: _reputationItem              atIndex:  9 ];
    [ menu insertItem: [ NSMenuItem separatorItem ] atIndex: 10 ];
    
    _hasMenuItems = YES;
}

@end

@implementation ApplicationDelegate

@synthesize statusMenu = _statusMenu;

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    NSUserDefaults * defaults;
    NSImage        * statusIcon;
    NSImage        * statusIconAlt;
    
    ( void )notification;
    
    defaults   = [ NSUserDefaults standardUserDefaults ];
    
    [ defaults registerDefaults: [ NSDictionary dictionaryWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"Defaults" ofType: @"plist" ] ] ];
    
    statusIcon     = [ [ NSImage alloc ] initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"MenuItem-Off" ofType: @"tif" ] ];
    statusIconAlt  = [ [ NSImage alloc ] initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"MenuItem-On" ofType: @"tif" ] ];
    _statusItem    = [ [ [ NSStatusBar systemStatusBar ] statusItemWithLength: NSSquareStatusItemLength  ] retain ];
    
    [ _statusMenu setDelegate: self ];
    [ _statusItem setImage: statusIcon ];
    [ _statusItem setAlternateImage: statusIconAlt ];
    [ _statusItem setTitle: @"..." ];
    [ _statusItem setLength: 80 ];
    [ _statusItem setMenu: _statusMenu ];
    [ _statusItem setHighlightMode: YES ];
    
    [ statusIcon release ];
    [ statusIconAlt release ];
    
    [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( preferencesChanged ) name: PreferencesChangedNotification object: nil ];
    
    if
    (
             [ defaults objectForKey: @"User" ]                        == nil
        || [ [ defaults objectForKey: @"User" ] unsignedIntegerValue ] == 0
    )
    {
        [ self openPreferences: nil ];
    }
    else
    {
        [ self createUser ];
    }
}

- ( void )applicationWillTerminate: ( NSNotification * )notification
{
    ( void )notification;
    
    [ _preferencesController    release ];
    [ _aboutController          release ];
    [ _statusMenu               release ];
    [ _user                     release ];
    [ _usernameItem             release ];
    [ _timer                    invalidate ];
}

- ( IBAction )openPreferences:( id )sender
{
    if( _preferencesController == nil )
    {
        _preferencesController = [ PreferencesController new ];
    }
    
    [ NSApp activateIgnoringOtherApps: YES ];
    [ _preferencesController.window center ];
    [ _preferencesController.window makeKeyAndOrderFront: sender ];
    [ NSApp activateIgnoringOtherApps: YES ];
    [ _preferencesController showWindow: sender ];
}

- ( IBAction )openAboutWindow:( id )sender
{
    if( _aboutController == nil )
    {
        _aboutController = [ AboutController new ];
    }
    
    [ NSApp activateIgnoringOtherApps: YES ];
    [ _aboutController.window center ];
    [ _aboutController.window makeKeyAndOrderFront: sender ];
    [ NSApp activateIgnoringOtherApps: YES ];
    [ _aboutController showWindow: sender ];
}

- ( IBAction )quit:( id )sender
{
    [ NSApp terminate: sender ];
}

@end
//
//  SRValidator.h
//  ShortcutRecorder
//
//  Copyright 2006-2012 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      David Dauer
//      Jesper
//      Jamie Kirkpatrick
//      Andy Kim
//      Marat Ibadinov

#import "SRValidator.h"
#import "SRCommon.h"
#import "SRShortcut.h"
#import "SRGlobalHotkeySupport.h"

@implementation SRValidator

//---------------------------------------------------------- 
// iinitWithDelegate:
//---------------------------------------------------------- 
- (id) initWithDelegate:(id)theDelegate;
{
    self = [super init];
    if ( !self )
        return nil;
    
    [self setDelegate:theDelegate];
    
    return self;
}

#define NO_GLOBAL

//---------------------------------------------------------- 
// isKeyCode:andFlagsTaken:error:
//---------------------------------------------------------- 
- (BOOL)isReservedShortcut:(SRShortcut *)shortcut reason:(NSError **)reason;
{
    // if we have a delegate, it goes first...
	if ( delegate )
	{
		NSString *delegateReason = nil;
		if ([delegate shortcutValidator:self isReservedShortcut:shortcut reason:&delegateReason])
		{
            if (reason)
            {
                NSString *description = [NSString stringWithFormat: 
                                         SRLoc(@"The key combination %@ can't be used!"), 
                                         [shortcut string]];
                NSString *recoverySuggestion = [NSString stringWithFormat: 
                                                SRLoc(@"The key combination \"%@\" can't be used because %@."), 
                                                [shortcut string],
                                                (delegateReason && [delegateReason length]) ? delegateReason : @"it's already used"];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
										  description, NSLocalizedDescriptionKey,
										  recoverySuggestion, NSLocalizedRecoverySuggestionErrorKey,
										  [NSArray arrayWithObject:@"OK"], NSLocalizedRecoveryOptionsErrorKey, // Is this needed? Shouldn't it show 'OK' by default? -AK
										  nil];
                *reason = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
            }
			return YES;
		}
	}
    
    if ([SRGlobalHotkeySupport isReservedShortcut:shortcut reason:reason]) {
        return YES;
    }
    
	// Check menus too
    return [self isReservedShortcut:shortcut inMenu:[NSApp mainMenu] reason:reason];
}

//---------------------------------------------------------- 
// isKeyCode:andFlags:takenInMenu:error:
//---------------------------------------------------------- 
- (BOOL)isReservedShortcut:(SRShortcut *)shortcut inMenu:(NSMenu *)menu reason:(NSError **)reason;
{
    NSArray *menuItemsArray = [menu itemArray];
	NSEnumerator *menuItemsEnumerator = [menuItemsArray objectEnumerator];
	NSMenuItem *menuItem;
	NSUInteger menuItemModifierFlags;
	NSString *menuItemKeyEquivalent;
	
	BOOL menuItemCommandMod = NO, menuItemOptionMod = NO, menuItemShiftMod = NO, menuItemCtrlMod = NO;
	BOOL localCommandMod = NO, localOptionMod = NO, localShiftMod = NO, localCtrlMod = NO;
	
    NSUInteger flags = [shortcut modifiers];
	// Prepare local carbon comparison flags
	if ( flags & NSCommandKeyMask )       localCommandMod = YES;
	if ( flags & NSAlternateKeyMask )    localOptionMod = YES;
	if ( flags & NSShiftKeyMask )     localShiftMod = YES;
	if ( flags & NSControlKeyMask )   localCtrlMod = YES;
	
	while (( menuItem = [menuItemsEnumerator nextObject] ))
	{
        // rescurse into all submenus...
		if ([menuItem hasSubmenu])
		{
			if ([self isReservedShortcut:shortcut inMenu:[menuItem submenu] reason:reason]) 
			{
				return YES;
			}
		}
        
        if (!(menuItemKeyEquivalent = [menuItem keyEquivalent]) || ![menuItemKeyEquivalent length]) {
            continue;
        }
		
        menuItemCommandMod = NO;
        menuItemOptionMod = NO;
        menuItemShiftMod = NO;
        menuItemCtrlMod = NO;
        
        menuItemModifierFlags = [menuItem keyEquivalentModifierMask];
        
        if ( menuItemModifierFlags & NSCommandKeyMask )     menuItemCommandMod = YES;
        if ( menuItemModifierFlags & NSAlternateKeyMask )   menuItemOptionMod = YES;
        if ( menuItemModifierFlags & NSShiftKeyMask )       menuItemShiftMod = YES;
        if ( menuItemModifierFlags & NSControlKeyMask )     menuItemCtrlMod = YES;
        
        /* Compare translated keyCode and modifier flags */
        if ( ([menuItemKeyEquivalent isEqualToString:[shortcut string]]) 
            && ( menuItemCommandMod == localCommandMod ) 
            && ( menuItemOptionMod == localOptionMod ) 
            && ( menuItemShiftMod == localShiftMod ) 
            && ( menuItemCtrlMod == localCtrlMod ) )
        {
            if (reason)
            {
                NSString *description = [NSString stringWithFormat: 
                                         SRLoc(@"The key combination %@ can't be used!"),
                                         [shortcut string]];
                NSString *recoverySuggestion = [NSString stringWithFormat: 
                                                SRLoc(@"The key combination \"%@\" can't be used because it's already used by the menu item \"%@\"."), 
                                                [shortcut string],
                                                [menuItem title]];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                          description, NSLocalizedDescriptionKey,
                                          recoverySuggestion, NSLocalizedRecoverySuggestionErrorKey,
                                          [NSArray arrayWithObject:@"OK"], NSLocalizedRecoveryOptionsErrorKey,
                                          nil];
                *reason = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
            }
            return YES;
        }
	}
	return NO;    
}

#pragma mark -
#pragma mark accessors

//---------------------------------------------------------- 
//  delegate 
//---------------------------------------------------------- 
- (id) delegate
{
    return delegate; 
}

- (void) setDelegate: (id) theDelegate
{
    delegate = theDelegate; // Standard delegate pattern does not retain the delegate
}

@end

#pragma mark -
#pragma mark default delegate implementation

@implementation NSObject( SRValidation )

//---------------------------------------------------------- 
// shortcutValidator:isKeyCode:andFlagsTaken:reason:
//---------------------------------------------------------- 
- (BOOL) shortcutValidator:(SRValidator *)validator isReservedShortcut:(SRShortcut *)shortcut reason:(NSString **)reason
{
    return NO;
}

@end

//
//  SRGlobalHotkeySupport.m
//  ShortcutRecorder
//
//  Copyright 2006-2012 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      Marat Ibadinov

#import "SRGlobalHotkeySupport.h"
#import "SRCommon.h"
#import "SRShortcut.h"
#import <TargetConditionals.h>

#if TARGET_OS_MAC

#import <Carbon/Carbon.h>

static void *previousHotKeyMode;

@implementation SRGlobalHotkeySupport

+ (void) disableGlobalHotKeys
{
    previousHotKeyMode = PushSymbolicHotKeyMode(kHIHotKeyModeAllDisabled);
}

+ (void) enableGlobalHotKeys
{
    PopSymbolicHotKeyMode(previousHotKeyMode);
}

+ (BOOL) isReservedShortcut:(SRShortcut *)shortcut reason:(NSError **)reason;
{
	CFArrayRef tempArray = NULL;
	OSStatus err = noErr;
    
	/* get global hot keys... */
	err = CopySymbolicHotKeys( &tempArray );
    
	if ( err != noErr ) return YES;
    
	/* Not copying the array like this results in a leak on according to the Leaks Instrument */
	NSArray *globalHotKeys = [NSArray arrayWithArray:(NSArray *)tempArray];
    
	if ( tempArray ) CFRelease(tempArray);
	
	NSEnumerator *globalHotKeysEnumerator = [globalHotKeys objectEnumerator];
	NSDictionary *globalHotKeyInfoDictionary;
	int32_t globalHotKeyFlags;
	NSInteger globalHotKeyCharCode;
	BOOL globalCommandMod = NO, globalOptionMod = NO, globalShiftMod = NO, globalCtrlMod = NO;
	BOOL localCommandMod = NO, localOptionMod = NO, localShiftMod = NO, localCtrlMod = NO;
	
    unichar keyCode  = [shortcut keyCode];
    NSUInteger flags = [shortcut modifiers];
	/* Prepare local carbon comparison flags */
	if ( flags & NSCommandKeyMask )       localCommandMod = YES;
	if ( flags & NSAlternateKeyMask )    localOptionMod = YES;
	if ( flags & NSShiftKeyMask )     localShiftMod = YES;
	if ( flags & NSControlKeyMask )   localCtrlMod = YES;
    
	while (( globalHotKeyInfoDictionary = [globalHotKeysEnumerator nextObject] ))
	{
		/* Only check if global hotkey is enabled */
		if ( (CFBooleanRef)[globalHotKeyInfoDictionary objectForKey:(NSString *)kHISymbolicHotKeyEnabled] != kCFBooleanTrue )
        {
            continue;
        }
		
        globalCommandMod    = NO;
        globalOptionMod     = NO;
        globalShiftMod      = NO;
        globalCtrlMod       = NO;
        
        globalHotKeyCharCode = [(NSNumber *)[globalHotKeyInfoDictionary objectForKey:(NSString *)kHISymbolicHotKeyCode] shortValue];
        
        CFNumberGetValue((CFNumberRef)[globalHotKeyInfoDictionary objectForKey: (NSString *)kHISymbolicHotKeyModifiers],kCFNumberSInt32Type,&globalHotKeyFlags);
        
        if (globalHotKeyFlags & NSCommandKeyMask)   globalCommandMod = YES;
        if (globalHotKeyFlags & NSAlternateKeyMask) globalOptionMod = YES;
        if (globalHotKeyFlags & NSShiftKeyMask)     globalShiftMod = YES;
        if (globalHotKeyFlags & NSControlKeyMask)   globalCtrlMod = YES;
        
        /* compare unichar value and modifier flags */
		if ( (globalHotKeyCharCode == keyCode) 
            && (globalCommandMod == localCommandMod) 
            && (globalOptionMod == localOptionMod) 
            && (globalShiftMod == localShiftMod) 
            && (globalCtrlMod == localCtrlMod) )
        {
            if (reason)
            {
                NSString *description = [NSString stringWithFormat: 
                                         SRLoc(@"The key combination %@ can't be used!"),
                                         [shortcut string]];
                NSString *recoverySuggestion = [NSString stringWithFormat: 
                                                SRLoc(@"The key combination \"%@\" can't be used because it's already used by a system-wide keyboard shortcut. (If you really want to use this key combination, most shortcuts can be changed in the Keyboard & Mouse panel in System Preferences.)"), 
                                                [shortcut string]];
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

@end

#else /* TARGET_OS_MAC */

@implementation SRGlobalHotkeySupport

+ (void) disableGlobalHotKeys
{
}

+ (void) enableGlobalHotKeys
{
}

+ (BOOL) isReservedShortcut:(SRShortcut *)shortcut reason:(NSError **)reason;
{
    return NO;
}

@end

#endif /* TARGET_OS_MAC */
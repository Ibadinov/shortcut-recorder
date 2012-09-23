//
//  SRGlobalHotkeySupport.h
//  ShortcutRecorder
//
//  Copyright 2006-2012 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      Marat Ibadinov

#import "SRShortcut.h"
#import <Foundation/Foundation.h>

@interface SRGlobalHotkeySupport : NSObject {
}

+ (void) disableGlobalHotKeys;
+ (void) enableGlobalHotKeys;

+ (BOOL) isReservedShortcut:(SRShortcut *)shortcut reason:(NSError **)reason;

@end
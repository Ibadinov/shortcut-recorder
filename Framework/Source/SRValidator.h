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
//      Marat Ibadinov

#import "SRShortcut.h"
#import <Cocoa/Cocoa.h>

@interface SRValidator : NSObject {
    id delegate;
}

- (id) initWithDelegate:(id)theDelegate;

- (BOOL)isReservedShortcut:(SRShortcut *)shortcut reason:(NSError **)reason;
- (BOOL)isReservedShortcut:(SRShortcut *)shortcut inMenu:(NSMenu *)menu reason:(NSError **)reason;

- (id) delegate;
- (void) setDelegate: (id) theDelegate;

@end

#pragma mark -

@interface NSObject (SRValidation)

- (BOOL) shortcutValidator:(SRValidator *)validator isReservedShortcut:(SRShortcut *)shortcut reason:(NSString **)reason;

@end
//
//  SRRecorderControl.h
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

#import <Cocoa/Cocoa.h>

#import "SRRecorderCell.h"

@interface SRRecorderControl : NSControl
{
	IBOutlet id delegate;
}

#pragma mark *** Aesthetics ***
- (BOOL)animates;
- (void)setAnimates:(BOOL)an;
- (SRRecorderStyle)style;
- (void)setStyle:(SRRecorderStyle)nStyle;

#pragma mark *** Delegate ***
- (id)delegate;
- (void)setDelegate:(id)aDelegate;

#pragma mark *** Key Combination Control ***

- (NSUInteger)allowedFlags;
- (void)setAllowedFlags:(NSUInteger)flags;

- (BOOL)allowsKeyOnly;
- (void)setAllowsKeyOnly:(BOOL)nAllowsKeyOnly escapeKeysRecord:(BOOL)nEscapeKeysRecord;
- (BOOL)escapeKeysRecord;

- (BOOL)canCaptureGlobalHotKeys;
- (void)setCanCaptureGlobalHotKeys:(BOOL)inState;

- (NSUInteger)requiredFlags;
- (void)setRequiredFlags:(NSUInteger)flags;

- (SRShortcut *)shortcut;
- (void)setShortcut:(SRShortcut *)aShortcut;

#pragma mark *** Autosave Control ***

- (NSString *)autosaveName;
- (void)setAutosaveName:(NSString *)aName;

#pragma mark *** Binding Methods ***

- (NSDictionary *)objectValue;
- (void)setObjectValue:(NSDictionary *)shortcut;

@end

// Delegate Methods
@interface NSObject (SRRecorderDelegate)

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isReservedShortcut:(SRShortcut *)shortcut reason:(NSString **)reason;
- (void)shortcutRecorder:(SRRecorderControl *)aRecorder shortcutDidChange:(SRShortcut *)newShortcut;

@end

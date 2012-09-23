//
//  SRRecorderCell.h
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

#import "SRCommon.h"
#import "SRShortcut.h"

#import <Cocoa/Cocoa.h>

#define SRMinWidth 50
#define SRMaxHeight 22

#define SRTransitionFPS 30.0f
#define SRTransitionDuration 0.35f
#define SRTransitionFrames (SRTransitionFPS*SRTransitionDuration)
#define SRAnimationAxisIsY YES
#define ShortcutRecorderNewStyleDrawing

NS_INLINE NSRect SRAnimationOffsetRect(NSRect X, NSRect Y)	{
    return SRAnimationAxisIsY ? NSOffsetRect(X, 0.0f, -NSHeight(Y)) : NSOffsetRect(X, NSWidth(Y), 0.0f);
}

@class SRRecorderControl, SRValidator;

typedef enum __SRRecorderStyle {
    SRGradientBorderStyle = 0,
    SRGreyStyle = 1
} SRRecorderStyle;

@interface SRRecorderCell : NSActionCell <NSCoding>
{	
	NSGradient          *recordingGradient;
	NSString            *autosaveName;
	
	BOOL                isRecording;
	BOOL                mouseInsideTrackingArea;
	BOOL                mouseDown;
	
	SRRecorderStyle		style;
	
	BOOL				isAnimating;
	CGFloat				transitionProgress;
	BOOL				isAnimatingNow;
	BOOL				isAnimatingTowardsRecording;
	BOOL				comboJustChanged;
	
	NSTrackingRectTag   removeTrackingRectTag;
	NSTrackingRectTag   snapbackTrackingRectTag;
	
	SRShortcut          *shortcut;
	
	NSUInteger          allowedFlags;
	NSUInteger          requiredFlags;
	NSUInteger          recordingFlags;
	
	BOOL				allowsKeyOnly;
	BOOL				escapeKeysRecord;
	
	NSSet               *cancelCharacterSet;
	
    SRValidator         *validator;
    
	IBOutlet id         delegate;
	BOOL				globalHotKeys;
	void				*hotKeyModeToken;
}

- (void)resetTrackingRects;

#pragma mark *** Aesthetics ***

+ (BOOL)styleSupportsAnimation:(SRRecorderStyle)style;

- (BOOL)animates;
- (void)setAnimates:(BOOL)an;
- (SRRecorderStyle)style;
- (void)setStyle:(SRRecorderStyle)nStyle;

#pragma mark *** Delegate ***

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

#pragma mark *** Responder Control ***

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

#pragma mark *** Key Combination Control ***

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
- (void)flagsChanged:(NSEvent *)theEvent;

- (NSUInteger)allowedFlags;
- (void)setAllowedFlags:(NSUInteger)flags;

- (NSUInteger)requiredFlags;
- (void)setRequiredFlags:(NSUInteger)flags;

- (BOOL)allowsKeyOnly;
- (void)setAllowsKeyOnly:(BOOL)nAllowsKeyOnly;
- (void)setAllowsKeyOnly:(BOOL)nAllowsKeyOnly escapeKeysRecord:(BOOL)nEscapeKeysRecord;
- (BOOL)escapeKeysRecord;
- (void)setEscapeKeysRecord:(BOOL)nEscapeKeysRecord;

- (BOOL)canCaptureGlobalHotKeys;
- (void)setCanCaptureGlobalHotKeys:(BOOL)inState;

- (SRShortcut *)shortcut;
- (void)setShortcut:(SRShortcut *)shortcut;

#pragma mark *** Autosave Control ***

- (NSString *)autosaveName;
- (void)setAutosaveName:(NSString *)aName;

@end

/* Delegate Methods */
@interface NSObject (SRRecorderCellDelegate)

- (BOOL)shortcutRecorderCell:(SRRecorderCell *)aRecorderCell isReservedShortcut:(SRShortcut *)shortcut reason:(NSString **)reason;
- (void)shortcutRecorderCell:(SRRecorderCell *)aRecorderCell shortcutDidChange:(SRShortcut *)newShortcut;

@end

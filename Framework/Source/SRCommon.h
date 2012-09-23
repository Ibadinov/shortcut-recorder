//
//  SRCommon.h
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

#pragma mark Dummy class 

@interface SRDummyClass : NSObject {
} 
@end

#pragma mark Shared Image Provider

@interface SRSharedImageProvider : NSObject

+ (NSImage *)supportingImageWithName:(NSString *)name;

@end

#pragma mark Additions

@interface NSAlert(SRAdditions)

+ (NSAlert *) alertWithNonRecoverableError:(NSError *)error;

@end

# pragma mark Enumerations

/*
 * Default filter values
 */
typedef enum __SRFilters {
    ShortcutRecorderEmptyFlags = 0,
    ShortcutRecorderAllFlags   = NSCommandKeyMask | NSAlternateKeyMask | NSControlKeyMask | NSShiftKeyMask | NSFunctionKeyMask
} SRFilters;

/*
 * These keys will cancel the recoding mode if not pressed with any modifier
 */
typedef enum __SRCancelKeyCodes {
    ShortcutRecorderEscapeKey       = 53,
    ShortcutRecorderBackspaceKey    = 51,
    ShortcutRecorderDeleteKey       = 117
} SRCancelKeyCodes;

#pragma mark Helpers

/* 
 * Localization helpers, for use in any bundle
 */

NS_INLINE NSString * SRLocalizedString(NSString *key, NSString *comment) 
{
    return NSLocalizedStringFromTableInBundle(key, @"ShortcutRecorder", [NSBundle bundleForClass: [SRDummyClass class]], comment);
}

NS_INLINE NSString * SRLoc(NSString *key) 
{
    return SRLocalizedString(key, nil);
}

/*
 * Image macros, for use in any bundle
 */

NS_INLINE NSImage * SRResIndImage(NSString *name) {
    return [SRSharedImageProvider supportingImageWithName:name];
}

NS_INLINE NSImage * SRImage(NSString *name) {
    return SRResIndImage(name);
}

#pragma mark Converting between Cocoa and Carbon modifier flags

NSUInteger SRCarbonToCocoaFlags(NSUInteger carbonFlags);
NSUInteger SRCocoaToCarbonFlags(NSUInteger cocoaFlags);

#pragma mark Animation pace function

CGFloat SRAnimationEaseInOut(CGFloat t);

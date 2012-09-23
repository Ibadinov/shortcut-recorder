//
//  SRShortcut.h
//  ShortcutRecorder
//
//  Copyright 2006-2012 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      Marat Ibadinov

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>

@interface SRShortcut : NSObject <NSCoding, NSCopying> {
    unichar character;
    NSUInteger modifiers;
    unichar keyCode;
}

+(void) initialize;

-(id) init;
-(id) initWithEvent:(NSEvent *) event;
-(id) initWithCoder:(NSCoder *) decoder;
-(id) initWithCharacter:(unichar) character modifierFlags:(NSUInteger) modifiers keyCode:(unichar) keyCode;

+(id) shortcut;
+(id) shortcutWithEvent:(NSEvent *) event;
+(id) shortcutWithCharacter:(unichar) character modifierFlags:(NSUInteger) modifiers keyCode:(unichar) keyCode;

-(void) encodeWithCoder:(NSCoder *) encoder;

-(BOOL) isEmpty;
-(BOOL) isEqualToShortcut:(SRShortcut *)shortcut;

-(unichar) character;
-(unichar) keyCode;
-(NSUInteger) modifiers;

#if TARGET_OS_MAC
-(NSUInteger) carbonModifiers; /* For use with PTHotKey, requires Carbon */
#endif

-(NSString *)string;

@end

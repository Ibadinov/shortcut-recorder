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

#import "SRShortcut.h"

#if TARGET_OS_MAC
#   import <Carbon/Carbon.h>
#endif

static const NSMutableDictionary *functionKeySymbols;
static const NSMutableDictionary *modifierSymbols;
static const NSMutableDictionary *keyCodeSymbols;

static void pushModifierSymbol(NSUInteger modifier, unichar symbol)
{
    [modifierSymbols setObject:[NSString stringWithCharacters:&symbol length:1] forKey:[NSNumber numberWithUnsignedInteger:modifier]];
}

static void pushModifierString(NSUInteger modifier, NSString *string)
{
    [modifierSymbols setObject:string forKey:[NSNumber numberWithUnsignedInteger:modifier]];
}

static void pushFunctionKeySymbol(NSUInteger code, unichar symbol)
{
    [functionKeySymbols setObject:[NSString stringWithCharacters:&symbol length:1] forKey:[NSNumber numberWithUnsignedInteger:code]];
}

static void pushFunctionKeyString(NSUInteger code, NSString *string)
{
    [functionKeySymbols setObject:string forKey:[NSNumber numberWithUnsignedInteger:code]];
}

static void pushKeyCodeSymbol(NSUInteger keyCode, unichar symbol) {
    [keyCodeSymbols setObject:[NSString stringWithCharacters:&symbol length:1] forKey:[NSNumber numberWithUnsignedInteger:keyCode]];
}

@implementation SRShortcut

+(void) initialize
{
    functionKeySymbols = [NSMutableDictionary new];
    modifierSymbols    = [NSMutableDictionary new];
    keyCodeSymbols     = [NSMutableDictionary new];
    
    pushModifierSymbol(NSControlKeyMask,    0x2303);
    pushModifierSymbol(NSAlternateKeyMask,  0x2325);
    pushModifierSymbol(NSShiftKeyMask,      0x21E7);
    pushModifierSymbol(NSCommandKeyMask,    0x2318);
    pushModifierSymbol(NSNumericPadKeyMask, 0x2327);
    pushModifierSymbol(NSAlphaShiftKeyMask, 0x21EA);
    pushModifierString(NSHelpKeyMask,       @"HelpKey"); /* What is it? O_o */
    /* Do we need to add NSFunctionKeyMask? */
    
    pushFunctionKeySymbol(NSUpArrowFunctionKey,     0x2191);
    pushFunctionKeySymbol(NSDownArrowFunctionKey,   0x2193);
    pushFunctionKeySymbol(NSLeftArrowFunctionKey,   0x2190);
    pushFunctionKeySymbol(NSRightArrowFunctionKey,  0x2192);
        
    pushFunctionKeyString(NSF1FunctionKey,  @"F1");
    pushFunctionKeyString(NSF2FunctionKey,  @"F2");
    pushFunctionKeyString(NSF3FunctionKey,  @"F3");
    pushFunctionKeyString(NSF4FunctionKey,  @"F4");
    pushFunctionKeyString(NSF5FunctionKey,  @"F5");
    pushFunctionKeyString(NSF6FunctionKey,  @"F6");
    pushFunctionKeyString(NSF7FunctionKey,  @"F7");
    pushFunctionKeyString(NSF8FunctionKey,  @"F8");
    pushFunctionKeyString(NSF9FunctionKey,  @"F9");
    pushFunctionKeyString(NSF10FunctionKey, @"F10");
    pushFunctionKeyString(NSF11FunctionKey, @"F11");
    pushFunctionKeyString(NSF12FunctionKey, @"F12");
    pushFunctionKeyString(NSF13FunctionKey, @"F13");
    pushFunctionKeyString(NSF14FunctionKey, @"F14");
    pushFunctionKeyString(NSF15FunctionKey, @"F15");
    pushFunctionKeyString(NSF16FunctionKey, @"F16");
    pushFunctionKeyString(NSF17FunctionKey, @"F17");
    pushFunctionKeyString(NSF18FunctionKey, @"F18");
    pushFunctionKeyString(NSF19FunctionKey, @"F19");
    pushFunctionKeyString(NSF20FunctionKey, @"F20");
    pushFunctionKeyString(NSF21FunctionKey, @"F21");
    pushFunctionKeyString(NSF22FunctionKey, @"F22");
    pushFunctionKeyString(NSF23FunctionKey, @"F23");
    pushFunctionKeyString(NSF24FunctionKey, @"F24");
    pushFunctionKeyString(NSF25FunctionKey, @"F25");
    pushFunctionKeyString(NSF26FunctionKey, @"F26");
    pushFunctionKeyString(NSF27FunctionKey, @"F27");
    pushFunctionKeyString(NSF28FunctionKey, @"F28");
    pushFunctionKeyString(NSF29FunctionKey, @"F29");
    pushFunctionKeyString(NSF30FunctionKey, @"F30");
    pushFunctionKeyString(NSF31FunctionKey, @"F31");
    pushFunctionKeyString(NSF32FunctionKey, @"F32");
    pushFunctionKeyString(NSF33FunctionKey, @"F33");
    pushFunctionKeyString(NSF34FunctionKey, @"F34");
    pushFunctionKeyString(NSF35FunctionKey, @"F35");
    
    pushFunctionKeySymbol(NSDeleteFunctionKey,          0x2326);
    pushFunctionKeySymbol(NSHomeFunctionKey,            0x2196);
    pushFunctionKeySymbol(NSEndFunctionKey,             0x2198);
    pushFunctionKeySymbol(NSPageUpFunctionKey,          0x21DE);
    pushFunctionKeySymbol(NSPageDownFunctionKey,        0x21DF);
    pushFunctionKeyString(NSBeginFunctionKey,           @"Begin");
    pushFunctionKeyString(NSInsertFunctionKey,          @"Insert");
    pushFunctionKeyString(NSPrintScreenFunctionKey,     @"PrintScreen");
    pushFunctionKeyString(NSScrollLockFunctionKey,      @"ScrollLock");
    pushFunctionKeyString(NSPauseFunctionKey,           @"Pause");
    pushFunctionKeyString(NSSysReqFunctionKey,          @"SysReq");
    pushFunctionKeyString(NSBreakFunctionKey,           @"Break");
    pushFunctionKeyString(NSResetFunctionKey,           @"Reset");
    pushFunctionKeyString(NSStopFunctionKey,            @"Stop");
    pushFunctionKeyString(NSMenuFunctionKey,            @"Menu");
    pushFunctionKeyString(NSUserFunctionKey,            @"User");
    pushFunctionKeyString(NSSystemFunctionKey,          @"System");
    pushFunctionKeyString(NSPrintFunctionKey,           @"Print");
    pushFunctionKeyString(NSClearLineFunctionKey,       @"ClearLine");
    pushFunctionKeyString(NSClearDisplayFunctionKey,    @"ClearDisplay");
    pushFunctionKeyString(NSInsertLineFunctionKey,      @"InsertLine");
    pushFunctionKeyString(NSDeleteLineFunctionKey,      @"DeleteLine");
    pushFunctionKeyString(NSInsertCharFunctionKey,      @"InsertChar");
    pushFunctionKeyString(NSDeleteCharFunctionKey,      @"DeleteChar");
    pushFunctionKeyString(NSPrevFunctionKey,            @"Prev");
    pushFunctionKeyString(NSNextFunctionKey,            @"Next");
    pushFunctionKeyString(NSSelectFunctionKey,          @"Select");
    pushFunctionKeyString(NSExecuteFunctionKey,         @"Execute");
    pushFunctionKeyString(NSUndoFunctionKey,            @"Undo");
    pushFunctionKeyString(NSRedoFunctionKey,            @"Redo");
    pushFunctionKeyString(NSFindFunctionKey,            @"Find");
    pushFunctionKeyString(NSHelpFunctionKey,            @"Help");
    pushFunctionKeyString(NSModeSwitchFunctionKey,      @"ModeSwitch");
    
    /* 
     * Special characters by name.  Useful if you want, for example,
     * to associate some special action to C-Tab or similar evils.  
     */
    pushFunctionKeySymbol(NSDeleteCharacter,            0x232B);
    pushFunctionKeySymbol(NSBackTabCharacter,           0x21E4);
    pushFunctionKeySymbol(NSTabCharacter,               0x21E5);
    pushFunctionKeySymbol(NSEnterCharacter,             0x2324);
    pushFunctionKeySymbol(NSCarriageReturnCharacter,    0x21A9);
    pushFunctionKeyString(NSFormFeedCharacter,          @"FormFeed");
    
    /* Missing keys: eject, escape etc. are accessible only via keyCodes */
    pushKeyCodeSymbol(53, 0x238B); /* escape */
}

-(id) init
{
    if (self = [super init]) 
    {
        character = 0;
        modifiers = 0;
        keyCode   = 0;
    }
    return self;
}

-(id) initWithEvent:(NSEvent *) event 
{
    if (self = [super init])
    {
        modifiers = [event modifierFlags];
        character = [[[event charactersIgnoringModifiers] uppercaseString] characterAtIndex:0]; /* Uniformly treat symbols as upper-case */
        keyCode   = [event keyCode];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *) decoder
{
	if (!(self = [super init]))
    {
        return self;
    }
    
	if ([decoder allowsKeyedCoding]) {
        character = [[decoder decodeObjectForKey:@"shortcutCharacter"] unsignedIntegerValue];
        modifiers = [[decoder decodeObjectForKey:@"shortcutModifiers"] unsignedIntegerValue];
        keyCode   = [[decoder decodeObjectForKey:@"shortcutKeyCode"]   unsignedIntegerValue];
	}
    else 
    {
        character = [[decoder decodeObject] unsignedIntegerValue];
		modifiers = [[decoder decodeObject] unsignedIntegerValue];
        keyCode   = [[decoder decodeObject] unsignedIntegerValue];
	}
    
	return self;
}

- (void) encodeWithCoder:(NSCoder *) encoder
{
	if ([encoder allowsKeyedCoding]) {
        [encoder encodeObject:[NSNumber numberWithUnsignedInteger:character] forKey:@"shortcutCharacter"];
		[encoder encodeObject:[NSNumber numberWithUnsignedInteger:modifiers] forKey:@"shortcutModifiers"];
        [encoder encodeObject:[NSNumber numberWithUnsignedInteger:keyCode]   forKey:@"shortcutKeyCode"];
    } else {
        [encoder encodeObject:[NSNumber numberWithUnsignedInteger:character]];
		[encoder encodeObject:[NSNumber numberWithUnsignedInteger:modifiers]];
        [encoder encodeObject:[NSNumber numberWithUnsignedInteger:keyCode]];
	}
}

-(id) initWithCharacter:(unichar) aCharacter modifierFlags:(NSUInteger) aModifiers keyCode:(unichar)aKeyCode
{
    if (self = [super init])
    {
        character = aCharacter;
        modifiers = aModifiers;
        keyCode   = aKeyCode;
    }
    return self;
}

-(id) copyWithZone:(NSZone *) zone
{
    SRShortcut *copy = [[SRShortcut allocWithZone: zone] initWithCharacter:character modifierFlags:modifiers keyCode:keyCode];
    return copy;
}

+(id) shortcut
{
    return [[[self alloc] init] autorelease];
}

+(id) shortcutWithEvent:(NSEvent *) event
{
    return [[[self alloc] initWithEvent:event] autorelease];
}

+(id) shortcutWithCharacter:(unichar)character modifierFlags:(NSUInteger)modifiers keyCode:(unichar)keyCode
{
    return [[[self alloc] initWithCharacter:character modifierFlags:modifiers keyCode:keyCode] autorelease];
}

-(BOOL) isEmpty
{
    return !character;
}

-(BOOL) isEqualToShortcut:(SRShortcut *)shortcut
{
    return keyCode == [shortcut keyCode] && modifiers == [shortcut modifiers];
}

-(unichar) character
{
    return character;
}

-(unichar) keyCode
{
    return keyCode;
}

-(NSUInteger) modifiers
{
    return modifiers;
}

-(NSUInteger) carbonModifiers {
#if TARGET_OS_MAC
    NSUInteger carbonModifiers = 0;
    
    if (modifiers & NSCommandKeyMask)   carbonModifiers |= cmdKey;
    if (modifiers & NSAlternateKeyMask) carbonModifiers |= optionKey;
    if (modifiers & NSControlKeyMask)   carbonModifiers |= controlKey;
    if (modifiers & NSShiftKeyMask)     carbonModifiers |= shiftKey;
    if (modifiers & NSFunctionKeyMask)  carbonModifiers |= NSFunctionKeyMask;
    
    return carbonModifiers;
#else
    return 0;
#endif
}

-(NSString *)string
{
    NSString *description = [NSString string];
    
    NSEnumerator *enumerator = [modifierSymbols keyEnumerator]; /* enumerator emits keys in reverse addition order */
    id modifierMask;
    while (modifierMask = [enumerator nextObject]) {
        if (modifiers & [modifierMask unsignedIntegerValue]) {
            description = [[modifierSymbols objectForKey:modifierMask] stringByAppendingString:description];
        }
    }
    
    NSString *name = [functionKeySymbols objectForKey:[NSNumber numberWithUnsignedInteger:(NSUInteger)character]];
    name = name ? name : [keyCodeSymbols objectForKey:[NSNumber numberWithUnsignedInteger:(NSUInteger)keyCode]];
    if (name) 
    {
        description = [description stringByAppendingString:name];
    }
    else
    {
        NSString *name = [NSString stringWithCharacters: &character length: 1];
        description = [description stringByAppendingString:name];
    }

    return description;
}

@end
//
//  SRCommon.m
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

#import "SRCommon.h"

//#define SRCommon_PotentiallyUsefulDebugInfo
//#define SRCommon_WriteDebugImagery

#ifdef	SRCommon_PotentiallyUsefulDebugInfo
#   warning 64BIT: Check formatting arguments
#   define PUDNSLog(X,...)	NSLog(X,##__VA_ARGS__)
#else
#   define PUDNSLog(X,...)	{ ; }
#endif

#pragma mark dummy class 

@implementation SRDummyClass @end

#pragma mark -

#pragma mark Animation Easing

#define CG_M_PI (CGFloat)M_PI
#define CG_M_PI_2 (CGFloat)M_PI_2

#ifdef __LP64__
#define CGSin(x) sin(x)
#else
#define CGSin(x) sinf(x)
#endif

// From: http://developer.apple.com/samplecode/AnimatedSlider/ as "easeFunction"
CGFloat SRAnimationEaseInOut(CGFloat t) {
	// This function implements a sinusoidal ease-in/ease-out for t = 0 to 1.0.  T is scaled to represent the interval of one full period of the sine function, and transposed to lie above the X axis.
	CGFloat x = (CGSin((t * CG_M_PI) - CG_M_PI_2) + 1.0f ) / 2.0f;
	//	NSLog(@"SRAnimationEaseInOut: %f. a: %f, b: %f, c: %f, d: %f, e: %f", t, (t * M_PI), ((t * M_PI) - M_PI_2), sin((t * M_PI) - M_PI_2), (sin((t * M_PI) - M_PI_2) + 1.0), x);
	return x;
} 

#pragma mark additions

@implementation NSAlert( SRAdditions )

//---------------------------------------------------------- 
// + alertWithNonRecoverableError:
//---------------------------------------------------------- 
+ (NSAlert *) alertWithNonRecoverableError:(NSError *)error;
{
	NSString *reason = [error localizedRecoverySuggestion];
	return [self alertWithMessageText:[error localizedDescription]
						defaultButton:[[error localizedRecoveryOptions] objectAtIndex:0U]
					  alternateButton:nil
						  otherButton:nil
			informativeTextWithFormat:(reason ? reason : @"")];
}

@end

static NSMutableDictionary *SRSharedImageCache = nil;

@interface SRSharedImageProvider (Private)

+ (NSValue *)_sizeSRSnapback;
+ (NSValue *)_sizeSRRemoveShortcut;
+ (NSValue *)_sizeSRRemoveShortcutRollover;
+ (NSValue *)_sizeSRRemoveShortcutPressed;

+ (void)_drawSRSnapback:(id)anNSCustomImageRep;
+ (void)_drawSRRemoveShortcut:(id)anNSCustomImageRep;
+ (void)_drawSRRemoveShortcutRollover:(id)anNSCustomImageRep;
+ (void)_drawSRRemoveShortcutPressed:(id)anNSCustomImageRep;
+ (void)_drawARemoveShortcutBoxUsingRep:(id)anNSCustomImageRep opacity:(CGFloat)opacity;

@end

@implementation SRSharedImageProvider

+ (NSImage *)supportingImageWithName:(NSString *)name {
    // NSLog(@"supportingImageWithName: %@", name);
	if (nil == SRSharedImageCache) {
		SRSharedImageCache = [[NSMutableDictionary dictionary] retain];
        // NSLog(@"inited cache");
	}
	NSImage *cachedImage = nil;
	if (nil != (cachedImage = [SRSharedImageCache objectForKey:name])) {
        //		NSLog(@"returned cached image: %@", cachedImage);
		return cachedImage;
	}
	
    // NSLog(@"constructing image");
	NSSize size;
	NSValue *sizeValue = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"_size%@", name])];
	size = [sizeValue sizeValue];
    // NSLog(@"size: %@", NSStringFromSize(size));
	
	NSCustomImageRep *customImageRep = [[NSCustomImageRep alloc] initWithDrawSelector:NSSelectorFromString([NSString stringWithFormat:@"_draw%@:", name]) delegate:self];
	[customImageRep setSize:size];
    // NSLog(@"created customImageRep: %@", customImageRep);
	NSImage *returnImage = [[NSImage alloc] initWithSize:size];
	[returnImage addRepresentation:customImageRep];
	[customImageRep release];
	[returnImage setScalesWhenResized:YES];
	[SRSharedImageCache setObject:returnImage forKey:name];
	
#ifdef SRCommon_WriteDebugImagery
	
	NSData *tiff = [returnImage TIFFRepresentation];
	[tiff writeToURL:[NSURL fileURLWithPath:[[NSString stringWithFormat:@"~/Desktop/m_%@.tiff", name] stringByExpandingTildeInPath]] atomically:YES];
    
	NSSize sizeQDRPL = NSMakeSize(size.width*4.0,size.height*4.0);
	
    //	sizeQDRPL = NSMakeSize(70.0,70.0);
	NSCustomImageRep *customImageRepQDRPL = [[NSCustomImageRep alloc] initWithDrawSelector:NSSelectorFromString([NSString stringWithFormat:@"_draw%@:", name]) delegate:self];
	[customImageRepQDRPL setSize:sizeQDRPL];
    //	NSLog(@"created customImageRepQDRPL: %@", customImageRepQDRPL);
	NSImage *returnImageQDRPL = [[NSImage alloc] initWithSize:sizeQDRPL];
	[returnImageQDRPL addRepresentation:customImageRepQDRPL];
	[customImageRepQDRPL release];
	[returnImageQDRPL setScalesWhenResized:YES];
	[returnImageQDRPL setFlipped:YES];
	NSData *tiffQDRPL = [returnImageQDRPL TIFFRepresentation];
	[tiffQDRPL writeToURL:[NSURL fileURLWithPath:[[NSString stringWithFormat:@"~/Desktop/m_QDRPL_%@.tiff", name] stringByExpandingTildeInPath]] atomically:YES];
	
#endif
	
    //	NSLog(@"returned image: %@", returnImage);
	return [returnImage autorelease];
}

@end

@implementation SRSharedImageProvider (Private)

#define MakeRelativePoint(x,y)	NSMakePoint(x*hScale, y*vScale)

+ (NSValue *)_sizeSRSnapback {
	return [NSValue valueWithSize:NSMakeSize(14.0f,14.0f)];
}

+ (void)_drawSRSnapback:(id)anNSCustomImageRep {
    // NSLog(@"drawSRSnapback using: %@", anNSCustomImageRep);
	
	NSCustomImageRep *rep = anNSCustomImageRep;
	NSSize size = [rep size];
	[[NSColor whiteColor] setFill];
	CGFloat hScale = (size.width/1.0f);
	CGFloat vScale = (size.height/1.0f);
	
	NSBezierPath *bp = [[NSBezierPath alloc] init];
	[bp setLineWidth:hScale];
	
	[bp moveToPoint:MakeRelativePoint(0.0489685f, 0.6181513f)];
	[bp lineToPoint:MakeRelativePoint(0.4085750f, 0.9469318f)];
	[bp lineToPoint:MakeRelativePoint(0.4085750f, 0.7226146f)];
	[bp curveToPoint:MakeRelativePoint(0.8508247f, 0.4836237f) controlPoint1:MakeRelativePoint(0.4085750f, 0.7226146f) controlPoint2:MakeRelativePoint(0.8371143f, 0.7491841f)];
	[bp curveToPoint:MakeRelativePoint(0.5507195f, 0.0530682f) controlPoint1:MakeRelativePoint(0.8677834f, 0.1545071f) controlPoint2:MakeRelativePoint(0.5507195f, 0.0530682f)];
	[bp curveToPoint:MakeRelativePoint(0.7421721f, 0.3391942f) controlPoint1:MakeRelativePoint(0.5507195f, 0.0530682f) controlPoint2:MakeRelativePoint(0.7458685f, 0.1913146f)];
	[bp curveToPoint:MakeRelativePoint(0.4085750f, 0.5154130f) controlPoint1:MakeRelativePoint(0.7383412f, 0.4930328f) controlPoint2:MakeRelativePoint(0.4085750f, 0.5154130f)];
	[bp lineToPoint:MakeRelativePoint(0.4085750f, 0.2654000f)];
	
	NSAffineTransform *flip = [[NSAffineTransform alloc] init];
    // [flip translateXBy:0.95f yBy:-1.0f];
	[flip scaleXBy:0.9f yBy:1.0f];
	[flip translateXBy:0.5f yBy:-0.5f];
	
	[bp transformUsingAffineTransform:flip];
	
	NSShadow *sh = [[NSShadow alloc] init];
	[sh setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.45f]];
	[sh setShadowBlurRadius:1.0f];
	[sh setShadowOffset:NSMakeSize(0.0f,-1.0f)];
	[sh set];
	
	[bp fill];
	
	[bp release];
	[flip release];
	[sh release];
}

+ (NSValue *)_sizeSRRemoveShortcut 
{
	return [NSValue valueWithSize:NSMakeSize(14.0f,14.0f)];
}

+ (NSValue *)_sizeSRRemoveShortcutRollover 
{ 
    return [self _sizeSRRemoveShortcut]; 
}

+ (NSValue *)_sizeSRRemoveShortcutPressed
{ 
    return [self _sizeSRRemoveShortcut]; 
}

+ (void)_drawARemoveShortcutBoxUsingRep:(id)anNSCustomImageRep opacity:(CGFloat)opacity {
	
    // NSLog(@"drawARemoveShortcutBoxUsingRep: %@ opacity: %f", anNSCustomImageRep, opacity);
	
	NSCustomImageRep *rep = anNSCustomImageRep;
	NSSize size = [rep size];
	[[NSColor colorWithCalibratedWhite:0.0f alpha:1.0f-opacity] setFill];
	CGFloat hScale = (size.width/14.0f);
	CGFloat vScale = (size.height/14.0f);
	
	[[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(0.0f,0.0f,size.width,size.height)] fill];
	
	[[NSColor whiteColor] setStroke];
	
	NSBezierPath *cross = [[NSBezierPath alloc] init];
	[cross setLineWidth:hScale*1.2f];
	
	[cross moveToPoint:MakeRelativePoint(4.0f,4.0f)];
	[cross lineToPoint:MakeRelativePoint(10.0f,10.0f)];
	[cross moveToPoint:MakeRelativePoint(10.0f,4.0f)];
	[cross lineToPoint:MakeRelativePoint(4.0f,10.0f)];
    
	[cross stroke];
	[cross release];
}

+ (void)_drawSRRemoveShortcut:(id)anNSCustomImageRep {
    // NSLog(@"drawSRRemoveShortcut using: %@", anNSCustomImageRep);
	[self _drawARemoveShortcutBoxUsingRep:anNSCustomImageRep opacity:0.75f];
}

+ (void)_drawSRRemoveShortcutRollover:(id)anNSCustomImageRep {
    // NSLog(@"drawSRRemoveShortcutRollover using: %@", anNSCustomImageRep);
	[self _drawARemoveShortcutBoxUsingRep:anNSCustomImageRep opacity:0.65f];	
}

+ (void)_drawSRRemoveShortcutPressed:(id)anNSCustomImageRep {
    // NSLog(@"drawSRRemoveShortcutPressed using: %@", anNSCustomImageRep);
	[self _drawARemoveShortcutBoxUsingRep:anNSCustomImageRep opacity:0.55f];
}

@end

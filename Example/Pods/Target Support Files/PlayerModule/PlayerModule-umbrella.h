#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GRAudioDownLoader.h"
#import "GRRemoteAudioFile.h"
#import "GRRemotePlayer.h"
#import "GRRemoteResourceDelegate.h"
#import "NSURL+GR.h"

FOUNDATION_EXPORT double PlayerModuleVersionNumber;
FOUNDATION_EXPORT const unsigned char PlayerModuleVersionString[];


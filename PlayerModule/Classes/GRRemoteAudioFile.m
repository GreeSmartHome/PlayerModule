//
//  GRRemoteAudioFile.m
//  PlayerModule_Example
//
//  Created by 冉东军 on 2020/3/15.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import "GRRemoteAudioFile.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTmpPath NSTemporaryDirectory()

@implementation GRRemoteAudioFile


// 下载完成 -> cache + 文件名称
+ (NSString *)cacheFilePath:(NSURL *)url {
    return [kCachePath stringByAppendingPathComponent:url.lastPathComponent];
}


+ (long long)cacheFileSize:(NSURL *)url {
    
    // 1.2 计算文件路径对应的文件大小
    if (![self cacheFileExists:url]) {
        return 0;
    }
    // 1.1 获取文件路径
    NSString *path = [self cacheFilePath:url];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
   return  [fileInfoDic[NSFileSize] longLongValue];
}

// 下载中 -> tmp + 文件名称
+ (BOOL)cacheFileExists:(NSURL *)url {
    
    NSString *path = [self cacheFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}




+ (NSString *)tmpFilePath:(NSURL *)url {
    return [kTmpPath stringByAppendingPathComponent:url.lastPathComponent];
}

+ (long long)tmpFileSize:(NSURL *)url {
    // 1.2 计算文件路径对应的文件大小
    if (![self tmpFileExists:url]) {
        return 0;
    }
    // 1.1 获取文件路径
    NSString *path = [self tmpFilePath:url];
    NSDictionary *fileInfoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return  [fileInfoDic[NSFileSize] longLongValue];
}


+ (BOOL)tmpFileExists:(NSURL *)url {
    NSString *path = [self tmpFilePath:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)clearTmpFile:(NSURL *)url {
    NSString *tmpPath = [self tmpFilePath:url];
    BOOL isDirectory = YES;
    BOOL isEx = [[NSFileManager defaultManager] fileExistsAtPath:tmpPath isDirectory:&isDirectory];
    if (isEx && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
    }
    
}




+ (NSString *)contentType:(NSURL *)url {
    
    NSString *path = [self cacheFilePath:url];
    NSString *fileExtension = path.pathExtension;
    
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    
    return contentType;
    
}


+ (void)moveTmpPathToCachePath:(NSURL *)url {
 
    NSString *tmpPath = [self tmpFilePath:url];
    NSString *cachePath = [self cacheFilePath:url];
    [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:cachePath error:nil];
    
    
    
}

@end

//
//  GRAudioDownLoader.h
//  PlayerModule_Example
//
//  Created by 冉东军 on 2020/3/15.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GRAudioDownLoaderDelegate <NSObject>

- (void)downLoading;

@end
@interface GRAudioDownLoader : NSObject

@property (nonatomic, weak) id<GRAudioDownLoaderDelegate> delegate;

@property (nonatomic, assign) long long totalSize;
@property (nonatomic, assign) long long loadedSize;
@property (nonatomic, assign) long long offset;
@property (nonatomic, strong) NSString *mimeType;


- (void)downLoadWithURL:(NSURL *)url offset:(long long)offset;
@end

NS_ASSUME_NONNULL_END

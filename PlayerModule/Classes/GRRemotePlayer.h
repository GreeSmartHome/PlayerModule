//
//  GRRemotePlayer.h
//  PlayerModule_Example
//
//  Created by 东哥 on 12/3/2020.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
* 播放器的状态
* 因为UI界面需要加载状态显示, 所以需要提供加载状态
- RemotePlayerStateUnKnown: 未知(比如都没有开始播放音乐)
- RemotePlayerStateLoading: 正在加载()
- RemotePlayerStatePlaying: 正在播放
- RemotePlayerStateStopped: 停止
- RemotePlayerStatePause:   暂停
- RemotePlayerStateFailed:  失败(比如没有网络缓存失败, 地址找不到)
- RemotePlayerStateComplete:  一首播放完成
*/
typedef NS_ENUM(NSUInteger, RemotePlayerState) {
    RemotePlayerStateUnKnown = 0,
    RemotePlayerStateLoading = 1,
    RemotePlayerStatePlaying = 2,
    RemotePlayerStateStopped = 3,
    RemotePlayerStatePause = 4,
    RemotePlayerStateFailed = 5,
    RemotePlayerStateComplete = 6,
};
/**状态*/
typedef void(^RemotePlayerStateBlock)(RemotePlayerState state);

@interface GRRemotePlayer : NSObject

/** 单例对象 */
+ (instancetype)shareInstance;

/**
 开始播放远程音频
 @param url url地址
 @param isCache 是否需要缓存
 */
- (void)palyWithURL:(NSURL *)url isCache:(BOOL)isCache;

/**暂停播放*/
- (void)pause;

/**继续播放*/
- (void)resume;

/**停止播放*/
- (void)stop;

/**
播放指定的进度

@param progress 进度信息
*/
- (void)seekWithProgress:(float)progress;

/**
快进/快退

@param timeDiffer 跳跃的时间段
*/
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;

/**倍速*/
- (void)setRate:(float)rate;

/**静音*/
- (void)setMuted:(BOOL)muted;

/**调整音量*/
- (void)setVolume:(float)volume;

#pragma mark - 数据提供 ，主动拉取
//播放进度
@property (nonatomic ,copy)RemotePlayerStateBlock playerStateBlock;

/** 播放状态 */
@property (nonatomic ,assign ,readonly) RemotePlayerState state;

/** 是否静音, 可以反向设置数据 */
@property (nonatomic, assign) BOOL muted;
/** 音量大小 */
@property (nonatomic, assign) float volume;
/** 当前播放速率 */
@property (nonatomic, assign) float rate;

/** 总时长 */
@property (nonatomic, assign, readonly) NSTimeInterval totalTime;
/** 总时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *totalTimeFormat;
/** 已经播放时长 */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;
/** 已经播放时长(格式化后的) */
@property (nonatomic, copy, readonly) NSString *currentTimeFormat;
/** 播放进度 */
@property (nonatomic, assign, readonly) float progress;
/** 当前播放的url地址 */
@property (nonatomic, strong, readonly) NSURL *url;
/** 加载进度 */
@property (nonatomic, assign, readonly) float loadDataProgress;

@end

NS_ASSUME_NONNULL_END

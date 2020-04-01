//
//  GRRemotePlayer.m
//  PlayerModule_Example
//
//  Created by 东哥 on 12/3/2020.
//  Copyright © 2020 18578216982@163.com. All rights reserved.
//

#import "GRRemotePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "GRRemoteResourceDelegate.h"
#import "NSURL+GR.h"

@interface GRRemotePlayer ()
{
    // 标识用户是否进行了手动暂停
    BOOL _isUserPause;
}

/**
 音频播放器
 */
@property (nonatomic ,strong)AVPlayer *player;

/**
 资源加载代理
 */
@property (nonatomic, strong) GRRemoteResourceDelegate *resourceLoaderDelegate;

@end

@implementation GRRemotePlayer

/**
 单例初始化
*/
static GRRemotePlayer *_remotePlayer;
+(instancetype)shareInstance {
    
    if (!_remotePlayer) {
        _remotePlayer = [[GRRemotePlayer alloc]init];
    }
    return _remotePlayer;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_remotePlayer) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _remotePlayer = [super allocWithZone:zone];
        });
    }
    return _remotePlayer;
}

/**
 根据Url地址播放远程音频资源

 @param url url地址资源
 @param isCache 是否需要缓存
 */
- (void)palyWithURL:(NSURL *)url isCache:(BOOL)isCache {
    
    NSURL *currentURL = [(AVURLAsset *)self.player.currentItem.asset URL];
    if ([currentURL isEqual:url]) {
        NSLog(@"当前播放任务已经存在");
        [self resume];
        return;
    }
    
    // 如果资源加载比较慢, 有可能, 会造成调用了play方法, 但是当前并没有播放音频
    if (self.player.currentItem) {
        [self removeObserver];
    }
    
    _url = url;
    if (isCache) {
        url = [url streamingURL];
    }
    
    //1.资源请求
    AVURLAsset *avset = [AVURLAsset assetWithURL:url];
    
    // 关于网络音频的请求, 是通过这个对象, 调用代理的相关方法, 进行加载的
    // 拦截加载的请求, 只需要, 重新修改它的代理方法就可以
    self.resourceLoaderDelegate = [GRRemoteResourceDelegate new];
    [avset.resourceLoader setDelegate:self.resourceLoaderDelegate queue:dispatch_get_main_queue()];
    
    // 2. 资源的组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:avset];
    //监听状态
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //播放被打断
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playInterupt) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    //播放视频时候，忽略设备静音按钮
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // 3. 资源的播放
    self.player = [AVPlayer playerWithPlayerItem:item];
    
}

/**暂停播放*/
- (void)pause {
    
    [self.player pause];
    _isUserPause = YES;
    if (self.player) {
        self.state = RemotePlayerStatePause;
    }
}

/**继续播放*/
- (void)resume {
    [self.player play];
    _isUserPause = NO;
    // 就是代表,当前播放器存在, 并且, 数据组织者里面的数据准备, 已经足够播放了
    if (self.player && self.player.currentItem.playbackLikelyToKeepUp) {
        self.state = RemotePlayerStatePlaying;
    }
    
}

/**停止播放*/
- (void)stop {
    [self.player pause];
    self.player = nil;
    if (self.player) {
        self.state = RemotePlayerStateStopped;
    }
}

/**
指定进度播放

@param progress 进度
*/
- (void)seekWithProgress:(float)progress {
    if (progress < 0 || progress>1) {
        return;
    }
    
    // 1. 当前音频资源的总时长
    CMTime totalTime = self.player.currentItem.duration;
    
    // 2. 当前音频, 已经播放的时长
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    NSTimeInterval playTimeSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(playTimeSec, 1);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间点的音频资源");
        }else {
            NSLog(@"取消加载这个时间点的音频资源");
        }
    }];
    
}

/**快进 指定时间差播放*/
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    
    // 1. 当前音频资源的总时长
     NSTimeInterval totalTimeSec = [self totalTime];
    // 2. 当前音频, 已经播放的时长
    NSTimeInterval playTimeSec = [self currentTime];
    playTimeSec += timeDiffer;
    
    [self seekWithProgress:playTimeSec / totalTimeSec];
    
}

/**
 获取速率

 @return 速率
 */
- (float)rate {
    return self.player.rate;
}

/**
 设置静音

 @param muted 静音
 */
- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}
/**
 是否静音

 @return 是否静音
 */
- (BOOL)muted {
    return self.player.muted;
}

/**
 当前音频资源播放时长

 @return 播放时长
 */
- (NSTimeInterval)currentTime {
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    if (isnan(playTimeSec)) {
        return 0;
    }
    return playTimeSec;
}
/**
 当前音频资源播放时长(格式化后)

 @return 播放时长
 */
- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.currentTime / 60, (int)self.currentTime % 60];
}
/**
 当前音频资源总时长

 @return 总时长
 */
-(NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    if (isnan(totalTimeSec)) {
        return 0;
    }
    return totalTimeSec;
}
/**
 当前音频资源总时长(格式化后)

 @return 总时长 01:02
 */
- (NSString *)totalTimeFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.totalTime / 60, (int)self.totalTime % 60];
}



/**调整音量*/
- (void)setVolume:(float)volume {
    
    if (volume < 0 || volume > 1) {
        return;
    }
    if (volume > 0) {
        [self setMuted:NO];
    }
    
    self.player.volume = volume;
}
/**
 当前播放进度

 @return 播放进度
 */
- (float)progress {
    if (self.totalTime == 0) {
        return 0;
    }
    return self.currentTime / self.totalTime;
}



/**
 资源加载进度

 @return 加载进度
 */
- (float)loadDataProgress {
    
    if (self.totalTime == 0) {
        return 0;
    }
    
    CMTimeRange timeRange = [[self.player.currentItem loadedTimeRanges].lastObject CMTimeRangeValue];
    
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    
    return loadTimeSec / self.totalTime;

}
/**
 播放完成
 */
- (void)playEnd {
    NSLog(@"播放完成");
    self.state = RemotePlayerStateComplete;
}

/**
 被打断
 */
- (void)playInterupt {
    // 来电话, 资源加载跟不上
    NSLog(@"播放被打断");
    self.state = RemotePlayerStatePause;
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {//开始才会进入
            NSLog(@"资源准备好了, 这时候播放就没有问题");
            [self resume];
            
        }else {
            NSLog(@"状态未知");
            self.state = RemotePlayerStateFailed;
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {//后面加载资源都进这里
       BOOL ptk = [change[NSKeyValueChangeNewKey] boolValue];
        if (ptk) {
             NSLog(@"当前的资源, 准备的已经足够播放了");
            // 用户的手动暂停的优先级最高
            if (!_isUserPause) {
                [self resume];
            }else {

            }
            
        }else{
            NSLog(@"资源还不够, 正在加载过程当中");
            self.state = RemotePlayerStateLoading;
        }
    }
}

/**
 移除监听者, 通知
 */
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setState:(RemotePlayerState)state {
    _state = state;
    
    if (self.playerStateBlock) {
        self.playerStateBlock(state);
    }
    
}



@end

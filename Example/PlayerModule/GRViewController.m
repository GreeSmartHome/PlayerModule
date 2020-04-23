//
//  GRViewController.m
//  PlayerModule
//
//  Created by 18578216982@163.com on 03/12/2020.
//  Copyright (c) 2020 18578216982@163.com. All rights reserved.
//

#import "GRViewController.h"
#import "GRRemotePlayer.h"

@interface GRViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *loadPV;

@property (nonatomic, weak) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UISlider *playSlider;

@property (weak, nonatomic) IBOutlet UIButton *mutedBtn;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@end

@implementation GRViewController

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self timer];
    
    //告诉系统，接收远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //
    [[GRRemotePlayer shareInstance] playBackAudioWithImage:@"pushu" propertyTitle:@"甜蜜蜜" propertyArtist:@"哈哈"];
    
    [[GRRemotePlayer shareInstance] setPlayerStateBlock:^(RemotePlayerState state) {
        NSLog(@"状态%lu",(unsigned long)state);
    }];
}

//响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {

    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"播放暂停");
                [[GRRemotePlayer shareInstance] pause];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"切换");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"播放下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首");
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"开始播放");
                [[GRRemotePlayer shareInstance] resume];
                break;
            default:
                break;
        }
    }
}

- (void)update {
    
//    NSLog(@"--%zd", [XMGRemotePlayer shareInstance].state);
    // 68
    // 01:08
    // 设计数据模型的
    // 弱业务逻辑存放位置的问题
    self.playTimeLabel.text =  [GRRemotePlayer shareInstance].currentTimeFormat;
    self.totalTimeLabel.text = [GRRemotePlayer shareInstance].totalTimeFormat;
    
    self.playSlider.value = [GRRemotePlayer shareInstance].progress;
//    NSLog(@"进度===%f",[GRRemotePlayer shareInstance].progress);
    
    self.volumeSlider.value = [GRRemotePlayer shareInstance].volume;
    
    self.loadPV.progress = [GRRemotePlayer shareInstance].loadDataProgress;
    
    self.mutedBtn.selected = [GRRemotePlayer shareInstance].muted;

}


- (IBAction)play:(id)sender {
    
    NSString *url =  @"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a";
    
    [[GRRemotePlayer shareInstance] playWithURL:url isCache:NO];
    
}
- (IBAction)pause:(id)sender {
   
    [[GRRemotePlayer shareInstance] pause];
}

- (IBAction)resume:(id)sender {
    [[GRRemotePlayer shareInstance] resume];
}
- (IBAction)kuaijin:(id)sender {
   
    [[GRRemotePlayer shareInstance] seekWithTimeDiffer:15];
}
- (IBAction)progress:(UISlider *)sender {
    [[GRRemotePlayer shareInstance] seekWithProgress:sender.value];
}
- (IBAction)rate:(id)sender {
   
    [[GRRemotePlayer shareInstance] setRate:2];
}
- (IBAction)muted:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[GRRemotePlayer shareInstance] setMuted:sender.selected];
}
- (IBAction)volume:(UISlider *)sender {
    [[GRRemotePlayer shareInstance] setVolume:sender.value];
}


@end

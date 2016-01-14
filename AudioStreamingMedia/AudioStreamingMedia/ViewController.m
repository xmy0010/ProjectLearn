//
//  ViewController.m
//  AudioStreamingMedia
//
//  Created by T_yun on 16/1/13.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "ViewController.h"
#import "UrlSourceApi.h"
#import <FSAudioController.h>
#import <FSPlaylistItem.h>
#import <CSNotificationView.h>
#import <MarqueeLabel.h>
#import "MBProgressHUDManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
/**进度条*/
@property (weak, nonatomic) IBOutlet UISlider *progressSolider;

/**歌曲名称lable*/
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleLB;

/**音频播放控制器*/
@property (nonatomic, strong) FSAudioController *audioControl;

/**播放列表*/
@property (nonatomic, strong) NSMutableArray *playlist;

/**是否进入暂停状态*/
@property (nonatomic, assign) BOOL isPause;

/**播放进度定时器*/
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) MBProgressHUDManager *manager;

@end

@implementation ViewController

- (MBProgressHUDManager *)manager {

    if (_manager == nil) {
        _manager = [[MBProgressHUDManager alloc] initWithView:self.view];

    }
    
    return _manager;
}


- (NSTimer *)timer {

    if (_timer == nil) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
        
        //暂停定时器
        [_timer setFireDate:[NSDate distantFuture]];
        
        //将定时器加入runloop
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

- (FSAudioController *)audioControl {

    if (_audioControl == nil) {
        
        _audioControl = [[FSAudioController alloc] init];
        //设置播放器的播放列表
        [_audioControl playFromPlaylist:self.playlist];
        
        //预加载后面的歌曲
        _audioControl.preloadNextPlaylistItemAutomatically = YES;
        
        
        __weak typeof(self)weakSelf = self;
        _audioControl.onStateChange = ^(FSAudioStreamState state) {
        
            NSString *massage = nil;
            switch (state) {
                case kFsAudioStreamRetrievingURL: {
                    
                    massage = @"重新连接url";
                }
                    break;
                case kFsAudioStreamStopped: {
                    
                    massage = @"播放停止";
                }
                    break;
                case kFsAudioStreamBuffering: {
                    
                    massage = @"正在缓冲";
                    [weakSelf.manager showIndeterminateWithMessage:massage];
                }
                    break;
                case kFsAudioStreamPlaying: {
                    
                    massage = @"正在播放";
                }
                    break;
                case kFsAudioStreamPaused: {
                    
                    massage = @"暂停播放";
                }
                    break;
                case kFsAudioStreamSeeking: {
                    
                    massage = @"正在找寻节点";
                }
                    break;
                case kFSAudioStreamEndOfFile: {
                    
                    massage = @"已到文件结尾";
                    [weakSelf.manager hide];
                    
                }
                    break;
                case kFsAudioStreamFailed: {
                    
                    massage = @"播放失败";
                    [weakSelf.manager showErrorWithMessage:massage duration:1.];
                }
                    break;
                case kFsAudioStreamRetryingStarted: {
                    
                    massage = @"尝试重新连接";
                    [weakSelf.manager showIndeterminateWithMessage:massage];
                }
                    break;
                case kFsAudioStreamRetryingSucceeded: {
                    
                    massage = @"重新连接成功";
                    [weakSelf.manager showSuccessWithMessage:massage];
                }
                    break;
                case kFsAudioStreamRetryingFailed: {
                    
                    massage = @"重新连接失败";
                    [weakSelf.manager showErrorWithMessage:massage duration:1.];
                }
                    break;
                case kFsAudioStreamPlaybackCompleted: {
                    
                    massage = @"播放完毕";
                    [weakSelf.manager showMessage:massage duration:1.];
                }
                    break;
                case kFsAudioStreamUnknownState: {
                    
                    massage = @"未知错误";
                    [weakSelf.manager showErrorWithMessage:massage duration:1.];
                }
                    break;
            }
            NSLog(@"%@", massage);
        };
    }
    
    return _audioControl;
}

- (NSMutableArray *)playlist {

    if (_playlist == nil) {
        _playlist = @[].mutableCopy;
        NSArray *nameArr = @[@"Fools Garden - Lemon Tree",
                             @"John Denver - Take Me Home Country Roads",
                             @"Maroon 5 - Sugar",
                             @"WANDS - 世界が终わるまでは…",
                             @"BAAD - 君が好きだと叫びたい"];
        
        NSArray *urlArr = @[url0,
                            url1,
                            url2,
                            url3,
                            url4];
        
        for (int index = 0; index < nameArr.count; index++) {
            //创建playlistItem
            FSPlaylistItem *item = [[FSPlaylistItem alloc] init];
            item.title = nameArr[index];
            item.url = [NSURL URLWithString:urlArr[index]];
            
            [_playlist addObject:item];
        }
    }
    
    return _playlist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSLog(@"%@", NSHomeDirectory());
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 播放器控制
- (IBAction)playButtonPressed:(UIButton *)sender {
    //如果正在播放 就暂停 否则继续播放
    if ([self.audioControl isPlaying]) {
        
        [self.audioControl pause];
        self.isPause = YES;
        sender.selected = NO;
        
        [self.timer setFireDate:[NSDate distantFuture]];
    } else {
    
        //如果已经进入暂停状态 需要再次调用暂停来重新播放
        if(self.isPause == YES) {
            
            [self.audioControl pause];
        } else {
            
            [self.audioControl play];
        }
        
        [self.timer setFireDate:[NSDate distantPast]];
        sender.selected = YES;
    }
    FSPlaylistItem *item = [self.audioControl currentPlaylistItem];
    self.titleLB.text = item.title;
    
}
- (IBAction)nextButtonPressed:(UIButton *)sender {
    
    [self.progressView setProgress:0 animated:YES];
    
    //如果有下一首就播放 否则就播放第一首
    if ([self.audioControl hasNextItem]) {
        
        [self.audioControl playNextItem];
        [self playButtonPressed:self.playButton];
    } else {
    
        if ([self.audioControl countOfItems] > 0) {
            
             [self.audioControl playItemAtIndex:0];
            [self playButtonPressed:self.playButton];
        } else {
        
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前播放列表为空"];
            return;
        }
    }
    
}
- (IBAction)previouButtonPressed:(UIButton *)sender {
    
    if ([self.audioControl hasPreviousItem]) {
        
        [self.audioControl playPreviousItem];
        [self playButtonPressed:self.playButton];
    } else {
    
        if ([self.audioControl countOfItems] > 0) {
            
            [self.audioControl playItemAtIndex: [self.audioControl countOfItems] - 1];
            [self playButtonPressed:self.playButton];
        } else {
            
            [CSNotificationView showInViewController:self style:CSNotificationViewStyleError message:@"当前播放列表为空"];
            return;
        }
    }
    
}
- (IBAction)progressSliderValueChanged:(UISlider *)sender {
    
    FSStreamPosition pos = {};
    pos.position = sender.value;
    
    
    [self.audioControl.activeStream seekToPosition:pos];
    
}

#define mark 定时器回调
- (void)updateProgress {

    FSStreamPosition streamPosition = self.audioControl.activeStream.currentTimePlayed;
    
    CGFloat positon = streamPosition.position;
    self.progressSolider.value = positon;
    
    UInt64 totalLength =  self.audioControl.activeStream.contentLength;
    UInt64 preBuffered = self.audioControl.activeStream.prebufferedByteCount;
    
    CGFloat v = preBuffered / (CGFloat)totalLength;
    [self.progressView setProgress:v animated:YES];
    
}

@end

//
//  PlayViewController.m
//  VideoDemo
//
//  Created by T_yun on 16/1/14.
//  Copyright © 2016年 T_yun. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoModel.h"
#import <ASValueTrackingSlider.h>
#import <SVProgressHUD.h>
#import <ASProgressPopUpView.h>

@interface PlayViewController () <ASProgressPopUpViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet ASProgressPopUpView *bufferProgress;


@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *layer;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation PlayViewController

//1.是否支持旋转
- (BOOL)shouldAutorotate {

    return YES;
}

//2.支持哪些旋转方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {

//    UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
//    UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
//    UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
//    UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
//    UIInterfaceOrientationMaskLandscape = (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
//    UIInterfaceOrientationMaskAll = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
//    UIInterfaceOrientationMaskAllButUpsideDown = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
    
    
    return UIInterfaceOrientationMaskAll;
}

//3.优先选择哪个方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationLandscapeRight;
}

//监控每一帧的变化
- (CADisplayLink *)displayLink {

    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress:)];
    }
    
    return _displayLink;
}

- (AVPlayer *)avPlayer {

    if (_avPlayer == nil) {
        
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.model.playUrl]];
        _avPlayer = [AVPlayer playerWithPlayerItem:playItem];
        //与timer一样要加入到runloop
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_avPlayer.currentItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStalled:) name:AVPlayerItemPlaybackStalledNotification object:_avPlayer.currentItem];
        
        //监听播放对象的缓冲改变
        [self addObserverToPlayerItem:playItem];
        
    }
    
    return _avPlayer;
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)item {

    [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverFromPlayItem:(AVPlayerItem *)item {

    [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.bufferProgress.dataSource = self;
     self.titleLB.text = self.model.title;
    //初始化播放器页面
    [self setupPlayerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupPlayerView {

    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    //设置Slider的显示
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterPercentStyle];
    
    
    self.progressSlider.numberFormatter = formatter;
    
    
}

- (void)viewWillLayoutSubviews {
    
    self.layer.frame = self.view.bounds;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <ASProgressPopUpViewDataSource
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress {


    NSString *str = nil;
    if (progress > 0 && progress < 0.1) {
        str = @"开始缓存";
    } else if (progress > 0.4 && progress < 0.5) {
        str = @"快到一半了";
    } else if (progress > 0.9) {
        str = @"即将缓存完成";
        if (progress >= 1) {
            str = @"完成缓存";
            
            [progressView hidePopUpViewAnimated:YES];
        }
    }
    
    return str;
}

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)playButtonPressed:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.avPlayer play];
    } else {
        
        //让定时器失效
//        [self.displayLink invalidate];
//        self.displayLink = nil;
        [self.avPlayer pause];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.maskView.hidden) {
        
        self.maskView.hidden = NO;
        self.maskView.alpha = 0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.maskView.alpha = 0.6;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.maskView.alpha = 0;
        } completion:^(BOOL finished) {
            
            self.maskView.hidden = YES;
        }];
    }
}

/**更新播放进度*/
//static int i = 0;
- (void)updateProgress:(CADisplayLink *)sender {
    
//    NSLog(@"%d", i++);
    //获取当前播放的视频的长度（时间）
   CMTime duration = self.avPlayer.currentItem.duration;
    CGFloat durationTime = CMTimeGetSeconds(duration);
    
    //获取当前播放的长度
    CMTime current = self.avPlayer.currentItem.currentTime;
    CGFloat currentTime = CMTimeGetSeconds(current);
    
    CGFloat value = currentTime / durationTime;
    self.progressSlider.value = value;

    
}
/**跳转进度*/
- (IBAction)progressSliderValueChanged:(UISlider *)sender {
    
    if (self.avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        
        CGFloat value = sender.value;
        
        //获取当前播放的视频的长度（时间）
        CMTime duration = self.avPlayer.currentItem.duration;
        CGFloat durationTime = CMTimeGetSeconds(duration);
        
        int64_t seekingTime = value * durationTime;
        
        [self.avPlayer pause];
        self.playButton.selected = NO;
        [self.avPlayer seekToTime:CMTimeMake(seekingTime, 1.0) completionHandler:^(BOOL finished) {
            
            if (finished) {
                [self.avPlayer play];
                self.playButton.selected = YES;
            }
        }];

    } else {
        
        return;
    }
}

#pragma mark 

- (void)playbackFinished:(NSNotification *)notif {

    NSLog(@"播放完毕");
    
}

- (void)playbackStalled:(NSNotification *)notif {

    [SVProgressHUD showErrorWithStatus:@"缓冲中..."];
    NSLog(@"播放阻塞");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    //更新缓存progress的值
    //1.获取一共缓存了多少  range  0-2, 2-4,6-10,16....是一个range 记录当前缓存从哪儿开始和经历了多少
    AVPlayerItem *item = (AVPlayerItem *)object;
    NSArray *arr = item.loadedTimeRanges;
    
    NSValue *value = arr.lastObject;
    CMTimeRange range = [value CMTimeRangeValue];
    
    //1.1获取最近的一次缓存的开始位置 和缓存的长度
    NSTimeInterval bufferBegin = CMTimeGetSeconds(range.start);
    NSTimeInterval bufferLength = CMTimeGetSeconds(range.duration);
    
    //1.2所有缓存的总长度
    CGFloat totalBuffer = bufferBegin + bufferLength;
    
    //2.取得当前播放对象的总长度
    CGFloat totalDuring = CMTimeGetSeconds(item.duration);
    CGFloat progress = totalBuffer / totalDuring;
    
    //3.设置缓存进度条的显示
    [self.bufferProgress setProgress:progress animated:YES];
}

-(void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //移除对item的观察对象
    [self removeObserverFromPlayItem:self.avPlayer.currentItem];
}

@end

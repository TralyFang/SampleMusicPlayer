//
//  ViewController.m
//  MusicPlay
//
//  Created by FangZhongli on 15/11/3.
//  Copyright © 2015年 XiangDaoNet. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CommentScrollView.h"


@interface ViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *_player;
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UILabel *_startTime;
    __weak IBOutlet UILabel *_endTime;
    __weak IBOutlet UISlider *_progress;
    __weak IBOutlet UISlider *_volumeSlider;
    __weak IBOutlet UISwitch *_playerSwitch;
    NSArray *_comments;
    NSTimer *_timer;

    __weak IBOutlet CommentScrollView *_commentView;
}
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong) AVPlayer *playerItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *musicUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"马頔 - 南山南" ofType:@"mp3"] isDirectory:YES];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    _player.delegate = self;
    [_player play];
    _player.numberOfLoops = -1;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updatePlayerProgress) userInfo:nil repeats:YES];
    
    _volumeSlider.value = _player.volume;
    [self prepareBackgroundPlaying];
    
   // http://7s1s0t.com2.z0.glb.qiniucdn.com/3645709.mp3
    
//    [self playInternetMusicWithURL:nil];
    
    [self scrollViewComments];
    
}

- (void)scrollViewComments {
    
    _comments = @[@"==",@"====",@"1234567",@"8900!@#$%^",@"&*()!@#$%^&*()1234567",@"890",@"=====",@"=",@"222",@"22",@"2222=q",@"azws",@"xedc",@"333",@"=qazqazqaz",@"444=123",@"4qazwsx"];

    _commentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:.2];
    _commentView.comments = _comments;
}

- (void)viewDidLayoutSubviews {
    CGRect frame = _commentView.frame;
    frame.size.height = 66;
    _commentView.frame = frame;
}


//希望给其一个url 其就可以播放，这属于播放网络音乐 名字怎么起呢？
- (void)playInternetMusicWithURL:(NSString *)url
{
    self.playerItem = [[AVPlayer alloc] init];
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://7s1s0t.com2.z0.glb.qiniucdn.com/3645709.mp3"]];
    //切换当前音乐
    [self.playerItem replaceCurrentItemWithPlayerItem:item];
    
    //这样需要加载才会播放  这里有一个更好的方法 看看你能不能看懂 kov 监听 status 新值 这个属性是什么意思 AVPlayerStatus 枚举 代表播放器的状态，
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}
//观察者执行事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"---play---%ld",(long)self.playerItem.status);
    if ([keyPath isEqualToString:@"status"]) {
        if (self.playerItem.status == AVPlayerStatusReadyToPlay) {
            [self.playerItem play];
            
        }
    }
}

- (void)prepareBackgroundPlaying {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)updatePlayerProgress{
    _progress.value = _player.currentTime/_player.duration;
    _startTime.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)_player.currentTime/60,(long)_player.currentTime%60];
    _endTime.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)_player.duration/60,(long)_player.duration%60];
    if (_player.playing) {
        _playerSwitch.on = YES;
    }
}

/*
 以順序來說, 正常 slider 收到 event 的分別為
 
 1. TouchDown
 
 2. ValueChange
 
 3. TouchUpInside or Touch UpOutside or TouchCancel
 
 所以你可以在 3 的部分 implement 你想要的事情.
 */
- (IBAction)touchDown:(UISlider *)sender {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (IBAction)currentProgress:(UISlider *)sender {

    long current = sender.value*_player.duration;
    _startTime.text = [NSString stringWithFormat:@"%.2ld:%.2ld",current/60,current%60];
    
}

- (IBAction)TouchEnd:(UISlider *)sender {
    [_player setCurrentTime:sender.value*_player.duration];
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updatePlayerProgress) userInfo:nil repeats:YES];
    }
}

- (IBAction)playerOrpause:(UISwitch *)sender {
    sender.on?[_player play]:[_player pause];
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updatePlayerProgress) userInfo:nil repeats:YES];
    }
}
- (IBAction)secondMut:(UISlider *)sender {
    _player.volume = sender.value;
}


#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _playerSwitch.on = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

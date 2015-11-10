//
//  BannerTip.m
//  MusicPlay
//
//  Created by FangZhongli on 15/11/4.
//  Copyright © 2015年 XiangDaoNet. All rights reserved.
//

#import "BannerTip.h"

@interface BannerTip ()
{
    NSTimer *_timer;
}
@end
IB_DESIGNABLE
@implementation BannerTip

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)setCornerRadius:(float)speed {
    self.layer.cornerRadius = speed;
}

- (void)setTipStr:(NSString *)tipStr {
    _tipStr = [tipStr copy];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    lab.text = _tipStr;
    [lab sizeToFit];
    [self addSubview:lab];
    self.tipLab = lab;
}

- (void)setTipLab:(UILabel *)tipLab {
    _tipLab = tipLab;
    if (tipLab.frame.size.width>self.frame.size.width) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:.08 target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
        _tipLab.frame = CGRectMake(0, 0, tipLab.frame.size.width, self.frame.size.height);
    }
}

- (void)scrollBanner{
    if (_tipLab.frame.origin.x<=-_tipLab.frame.size.width) {
        CGRect frame = _tipLab.frame;
        frame.origin.x = self.frame.size.width;
        _tipLab.frame = frame;
    }
    
    [UIView animateWithDuration:.16 animations:^{
        CGRect frame = _tipLab.frame;
        frame.origin.x -= 5;
        _tipLab.frame = frame;
    }];
    
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

@end

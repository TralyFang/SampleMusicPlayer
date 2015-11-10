//
//  CommentScrollView.m
//  MusicPlay
//
//  Created by FangZhongli on 15/11/5.
//  Copyright © 2015年 XiangDaoNet. All rights reserved.
//

#import "CommentScrollView.h"

@interface MyLableTimer : UILabel
@property (nonatomic, strong)NSTimer *timer;
@end
@implementation MyLableTimer

@end

@interface CommentScrollView ()
{
    NSInteger _index;// 所在行
    float _speed;// 速率
    NSMutableSet *_reusableComments;// 重用队列
}
@end

@implementation CommentScrollView

- (void)setComments:(NSArray *)comments {
    _comments = comments;
    if (!_reusableComments) {
        _reusableComments = [NSMutableSet set];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringComment) name:@"bringCommentScrollNotification" object:nil];
    [self bringComment];
}

- (MyLableTimer *)dequeueReusableComment {
    MyLableTimer *lable = [_reusableComments anyObject];
    if (lable) {
        [_reusableComments removeObject:lable];
    }
    return lable;
}


- (void)bringComment {
    
    MyLableTimer *commLab = [self dequeueReusableComment];
    if (commLab==nil) {
        commLab = [[MyLableTimer alloc] init];
        commLab.textColor = [UIColor redColor];
        commLab.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.5];
        commLab.layer.cornerRadius = 5;
        commLab.clipsToBounds = YES;
        [self addSubview:commLab];
    }
    commLab.text = [_comments objectAtIndex:arc4random()%_comments.count];
    commLab.frame = CGRectMake(self.frame.size.width, _index*(20+3), 0, 20);
    [commLab sizeToFit];
    
    // 三种不同速度
    NSArray *speedSet = @[@(.1),@(.11),@(.09)];
    
    _speed = [[speedSet objectAtIndex:arc4random()%3] floatValue];
    // 移动
    commLab.timer = [NSTimer scheduledTimerWithTimeInterval:_speed target:self selector:@selector(scrollComment:) userInfo:commLab repeats:YES];
    
}

- (void)scrollComment:(NSTimer *)timer {
    MyLableTimer *commLab = (MyLableTimer *)timer.userInfo;
    // 跑出频幕就回收，关闭定时器
    if (commLab.frame.origin.x<=-commLab.frame.size.width) {
        [_reusableComments addObject:commLab];
        [timer invalidate];
        timer = nil;
        return;
    }
    float minWidth = self.frame.size.width-commLab.frame.size.width;
    // 全部出现后，就出下一个，当前定时器就不用了。
    if (commLab.frame.origin.x<=minWidth && timer==commLab.timer) {
        commLab.timer = nil;
        _index++;
        if (_index>=3) {
            _index=0;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bringCommentScrollNotification" object:nil];
        
    }
    // 为了流畅，这里添加了动画
    [UIView animateWithDuration:_speed*2 animations:^{
        CGRect frame = commLab.frame;
        frame.origin.x-=10;
        commLab.frame = frame;
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

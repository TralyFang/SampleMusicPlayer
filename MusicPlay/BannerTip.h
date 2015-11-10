//
//  BannerTip.h
//  MusicPlay
//
//  Created by FangZhongli on 15/11/4.
//  Copyright © 2015年 XiangDaoNet. All rights reserved.
//

/// http://segmentfault.com/a/1190000003703119 在OC和Swift中使用IBDesignable/IBInspectable
#import <UIKit/UIKit.h>

@interface BannerTip : UIView

@property (nonatomic, strong)UILabel *tipLab;
@property (nonatomic, copy)IBInspectable NSString *tipStr;
@property (nonatomic)IBInspectable float cornerRadius;
@end

//
//  GLOutLineLabel.h
//  GLAnimation
//
//  Created by 王凡 on 2017/4/28.
//  Copyright © 2017年 czk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface outLineLabel : UILabel

/** 描多粗的边*/

@property (nonatomic, assign) NSInteger outLineWidth;

/** 外轮颜色*/

@property (nonatomic, strong) UIColor *outLinetextColor;

/** 里面字体默认颜色*/

@property (nonatomic, strong) UIColor *labelTextColor;

@end

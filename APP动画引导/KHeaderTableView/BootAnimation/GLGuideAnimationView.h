//
//  GLGuideAnimationView.h
//  GLAnimation
//
//  Created by 王凡 on 2017/4/21.
//  Copyright © 2017年 czk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface GLGuideAnimationView : UIView
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UIImageView *bgV;
@property (weak, nonatomic) IBOutlet UIImageView *starV;
@property (weak, nonatomic) IBOutlet UIImageView *lightV;
@property (weak, nonatomic) IBOutlet UIImageView *gashaponV;
@property (weak, nonatomic) IBOutlet UIImageView *planet_3;
@property (weak, nonatomic) IBOutlet UIImageView *planet_2;
@property (weak, nonatomic) IBOutlet UIImageView *planet_1;
@property (nonatomic,assign) BOOL isFirst;


+ (void)animationView;
+ (CGFloat)scaleByWidth:(CGFloat)num;
+ (CGFloat)scaleByHeight:(CGFloat)num;
/**
 *  开始重力感应
 */
-(void)startAnimate;

/**
 *  停止重力感应
 */
-(void)stopAnimate;
@end

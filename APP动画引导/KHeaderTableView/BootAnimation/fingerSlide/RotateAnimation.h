//
//  RotateAnimation.h
//  Layer
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义三个圆
enum
{
    firstArc = 1,
};

@class RotateAnimation;

@protocol RotateAnimationDelegate <NSObject>

-(void)RotateOpenAppWithAnimation:(RotateAnimation *)rotateView;

@end

@interface RotateAnimation : UIView<CAAnimationDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *circleView1;
    
}
@property (nonatomic,strong)UIImageView *slideLineImgV;
//由于此动画是圆形, 传入的frame需要设置成正方形
@property (nonatomic,assign)id <RotateAnimationDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void)setRotateAnimationBackgroundColor:(UIColor *)aColor;
-(void)createAnimation:(float)startAngle andEndAngle:(float)endAngle andType:(int)type;
-(void)TransformSlideline;

@end

//
//  RotateAnimation.m
//  Layer
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "RotateAnimation.h"
#import "UIView+Extension.h"

@interface RotateAnimation ()

@property (nonatomic,assign)BOOL clouse;

@end

@implementation RotateAnimation
- (void)dealloc
{
    NSLog(@"释放");
}
//创建环绕动画, 传入三个属性分别是 : 运动开始的角度(右侧90度为0), 运动结束的角度, 以及传入的是第几个物体
-(void)createAnimation:(float)startAngle andEndAngle:(float)endAngle andType:(int)type
{
    //创建运转动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 0.8;
    pathAnimation.repeatCount = 1;
    //设置运转动画的路径
    pathAnimation.delegate = self;
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, SCREEN_WIDTH/2, 210, 120, startAngle, endAngle, 0);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    circleView1 = [[UIImageView alloc] init];
    [self addSubview:circleView1];
    circleView1.alpha = 1;
    UIImage *fingerImg = [UIImage imageNamed:@"slide_finger"];
    circleView1.frame = CGRectMake(SCREEN_WIDTH/2 - 40 - fingerImg.size.width/3, self.height - fingerImg.size.height/3 , fingerImg.size.width/3, fingerImg.size.height/3);
    circleView1.image = fingerImg;
    //设置运转的动画
    [circleView1.layer addAnimation:pathAnimation forKey:@"moveTheCircleOne"];
//    [UIView animateWithDuration:0.3 animations:^{
//        circleView1.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ( [circleView1.layer animationForKey:@"moveTheCircleOne"]  == anim && !self.clouse){
        
        [UIView animateWithDuration:0.3 delay:0.8 options:(UIViewAnimationOptionCurveLinear) animations:^{
            circleView1.alpha = 0;
//            self.slideLineImgV.alpha = 0;
        } completion:^(BOOL finished) {
            [circleView1.layer removeAllAnimations];
            [circleView1 removeFromSuperview];
            [self createAnimation: M_PI   andEndAngle:2 * M_PI - 0.3 andType: 1];
            [self transformAnm:self.slideLineImgV];
        }];
        
        [UIView animateWithDuration:0.5 delay:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
            self.slideLineImgV.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else{
        [circleView1.layer removeFromSuperlayer];
    }
    
}

//创建圆形路径  320,460
-(void)crearArcBackground
{
    CAShapeLayer *solidLine =  [CAShapeLayer layer];
    CGMutablePathRef solidPath =  CGPathCreateMutable();
    solidLine.lineWidth = 2.0f ;
    solidLine.strokeColor = [UIColor orangeColor].CGColor;
    solidLine.fillColor = [UIColor clearColor].CGColor;
    
    CGPathAddEllipseInRect(solidPath, nil, CGRectMake(50.0f,  300.0f, 200.0f, 200.0f));
    solidLine.path = solidPath;
    CGPathRelease(solidPath);
    [self.layer addSublayer:solidLine];

    UIImage *knobImg = [UIImage imageNamed:@"knob_1"];
    UIImageView *knobImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - knobImg.size.width/6, self.height - knobImg.size.height/6 + 20, knobImg.size.width/3, knobImg.size.height/3)];
    knobImgV.image = knobImg;
    [self addSubview:knobImgV];
    
    UIImage *swImg = [UIImage imageNamed:@"knob_2"];
    UIImageView *swImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - swImg.size.width/6, self.height - swImg.size.height/6 + 20, swImg.size.width/3, swImg.size.height/3)];
    swImgV.image = swImg;
    swImgV.tag = 2001;
    swImgV.userInteractionEnabled = YES;
    [self addSubview:swImgV];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlePan:)];
    recognizer.delegate = self;
    
    [swImgV addGestureRecognizer:recognizer];
    
   

}
-(void)TransformSlideline{
    UIImage *slideLineImg = [UIImage imageNamed:@"slide_line"];
    UIImageView *slideLineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - slideLineImg.size.width/3 - 5, self.height - slideLineImg.size.height/6 - 3 , slideLineImg.size.width/3, slideLineImg.size.height/3)];
    slideLineImgV.centerX = self.centerX - 7;
    slideLineImgV.image = slideLineImg;
    [self addSubview:slideLineImgV];
    self.slideLineImgV = slideLineImgV;
    CGAffineTransform transform= CGAffineTransformMakeRotation(-M_PI);
    slideLineImgV.transform = transform;//旋转
    [self transformAnm:slideLineImgV];
}

-(void)transformAnm:(UIImageView *)slideLineImgV{
    self.slideLineImgV.alpha = 1;
    CGFloat duration = 1.6;
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.fillMode = kCAFillModeForwards;
    anima.removedOnCompletion = NO;
    anima.toValue = [NSNumber numberWithFloat:M_PI*1];
    anima.duration = duration;
    [slideLineImgV.layer addAnimation:anima forKey:@"rotateAnimation"];

    
}
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    UIImageView *swImgV = [self viewWithTag:2001];
    
    CGPoint translation = [recognizer locationInView:self];
    
    if (CGRectContainsPoint(swImgV.frame, translation)) {
        CGFloat abs = translation.x - swImgV.x;
        CGAffineTransform transform =CGAffineTransformMakeRotation((abs/swImgV.width) * M_PI/2);
        [swImgV setTransform:transform];
    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
 
        CGFloat abs = translation.x - swImgV.x;
        if (abs/swImgV.width > 0.8) {
            CGAffineTransform transform =CGAffineTransformMakeRotation((1) * M_PI/2);
            [swImgV setTransform:transform];
            if (self.delegate &&[self.delegate respondsToSelector:@selector(RotateOpenAppWithAnimation:)]) {
                [self.delegate RotateOpenAppWithAnimation:self];
            }
            [UIView animateWithDuration:0.3 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                self.clouse = YES;
                
                [self removeFromSuperview];
            }];
        }else{
            CGAffineTransform transform =CGAffineTransformMakeRotation((0) * M_PI/2);
            [swImgV setTransform:transform];
        }
    }
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self crearArcBackground];
//        [self createAnimation: M_PI   andEndAngle:2 * M_PI - 0.3 andType: 1];
    }
    return self;
}

-(void)setRotateAnimationBackgroundColor:(UIColor *)aColor
{
    self.backgroundColor = aColor;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

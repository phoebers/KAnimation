//
//  GLGuideAnimationView.m
//  GLAnimation
//
//  Created by 王凡 on 2017/4/21.
//  Copyright © 2017年 czk. All rights reserved.
//

#import "GLGuideAnimationView.h"
#import "GLGravityManager.h"
#import "GLiCarouselScroView.h"
#import "YYImage.h"
#import "PQ_TimerManager.h"
#define TEXT_ONE @"咕噜咕噜～\n初次见面，我是您的小精灵咕噜球，从今天开始为您服务！"
#define TEXT_TWO @"为了了解您，\n咕噜球有两个小问题\n咕噜~请问您常玩的游戏类型是？"
#define TEXT_THREE @"谢谢回答 咕噜~ 好感动 \n咕噜~那么您喜欢的游戏题材呢？"
#import "PQ_TimerManager.h"

@interface GLGuideAnimationView ()<GLiCarouselScroViewDelegate,CAAnimationDelegate>

@property (weak, nonatomic  ) IBOutlet UIImageView *dialogbox;
@property (weak, nonatomic  ) IBOutlet UIView *textBgView;
@property (weak,   nonatomic) IBOutlet UILabel *textLabel;


@property (weak, nonatomic ) IBOutlet UIImageView *shineView;

@property (weak, nonatomic ) IBOutlet UIView *baffleView;
@property (weak, nonatomic ) IBOutlet UIImageView *scrBallImageView;

@property (strong, nonatomic) UIImageView *textGulu;
@property (nonatomic, strong) UIView *guluBgV;
@property (nonatomic, assign) CGSize cardSize;
@property (strong,nonatomic)  UIImageView *centerballImgView;
@property (strong,nonatomic)  UIImageView *openballImgView;
//@property (nonatomic,strong)  NSTimer *timer;
//@property (nonatomic,strong)  NSTimer *timer1;
@property (nonatomic,strong) PQ_TimerManager *timer;
@property (nonatomic,strong) PQ_TimerManager *timer1;
@property (nonatomic,strong)  NSArray *arr;
@property (nonatomic,strong)  UIImageView *FlipImgV;
@property (nonatomic,strong)  UIImageView *FlipImgV2;
@property (nonatomic,strong)  UIButton *removeBtn;
@end

@implementation GLGuideAnimationView
- (void)dealloc
{
    [self.timer pq_close];
    [self.timer1 pq_close];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    [self updataFrame];
    
    [self lightVChangeAlpha];
    //
    [self anmGashaponVShow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showText:TEXT_ONE];
    });
    
    self.removeBtn = [UIButton  buttonWithType:(UIButtonTypeCustom)];
    self.removeBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 20, 45, 30);
    [self addSubview:self.removeBtn];
    self.removeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.removeBtn setTitleColor:[PQ_TimerManager colorWithHexString:@"D8D8D8"] forState:(UIControlStateNormal)];
    [self.removeBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
    [self.removeBtn addTarget:self action:@selector(removeView) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)removeView{
    
    NSUserDefaults *defous = [NSUserDefaults standardUserDefaults];
    [defous removeObjectForKey:@"CarouselSecond"];
    [defous removeObjectForKey:@"CarouselFirst"];
    [defous synchronize];
    [self.FlipImgV2 removeFromSuperview];
    [self.guluBgV removeFromSuperview];
    [self.timer pq_close];
    [self.timer1 pq_close];
    self.FlipImgV = nil;
    [self stopAnimate];
    [self.centerballImgView.layer removeAnimationForKey:@"ballAnimation"];
    [self.scrBallImageView.layer removeAnimationForKey:@"positionAnimation"];
    [self.gashaponV.layer removeAnimationForKey:@"shakeAnimation"];
    [self removeFromSuperview];
    
}
-(void)updataFrame{
    
    self.botView.frame = self.frame;
    
    self.bgV.frame     = CGRectMake(0, 0, SCREEN_WIDTH + 50, self.height);
    
    self.starV.frame   = CGRectMake(0, 0, SCREEN_WIDTH + 55, self.height);
    
    self.lightV.frame  = CGRectMake(0, SCREEN_HEIGHT - [GLGuideAnimationView scaleByHeight:self.lightV.size.height], SCREEN_WIDTH + 50, [GLGuideAnimationView scaleByHeight:self.lightV.size.height]);
    
    self.gashaponV.width  = [GLGuideAnimationView scaleByWidth:_gashaponV.image.size.width];
    
    self.gashaponV.height = [GLGuideAnimationView scaleByHeight:_gashaponV.image.size.height];
    
    self.gashaponV.y = [GLGuideAnimationView scaleByHeight:240];
    
    self.planet_1.width = [GLGuideAnimationView scaleByWidth:94];
    
    self.planet_1.height = [GLGuideAnimationView scaleByWidth:94];
    
    self.planet_3.y  = CGRectGetMaxY(self.gashaponV.frame) - self.planet_3.image.size.height;
    
    self.planet_2.x  = SCREEN_WIDTH - self.planet_2.image.size.width - 10;
    
    self.textBgView.frame = CGRectMake(SCREEN_WIDTH/2 - self.dialogbox.image.size.width/2, [GLGuideAnimationView scaleByHeight:80], self.dialogbox.image.size.width, self.dialogbox.image.size.height);
    
    self.dialogbox.frame = CGRectMake(60, self.dialogbox.image.size.height, 0, 0);
    
    self.baffleView.frame = CGRectMake(SCREEN_WIDTH - [GLGuideAnimationView scaleByWidth:225], SCREEN_HEIGHT - [GLGuideAnimationView scaleByHeight:164], [GLGuideAnimationView scaleByWidth:225], [GLGuideAnimationView scaleByHeight:164]);
    
    self.scrBallImageView.width = [GLGuideAnimationView scaleByWidth:60];
    
    self.scrBallImageView.height = [GLGuideAnimationView scaleByWidth:60];

    if (SCREEN_WIDTH == 320) {
        self.textLabel.font = [UIFont systemFontOfSize:14 weight:2];
        self.textLabel.x -= 5;
    }else if (SCREEN_WIDTH == 375){
        self.textLabel.font = [UIFont systemFontOfSize:15 weight:2];
        self.textLabel.x -= 5;
    }
}
-(void)anmGashaponVShow{
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i <= 3; i++) {
        
        NSString *fileName = [NSString stringWithFormat:@"gashapon_normal_%d",i];
        
        UIImage *image = [YYImage imageNamed:fileName];
        
        [images addObject:image];
    }
    //设置动画的
    self.gashaponV.animationImages = images;
    
    self.gashaponV.animationRepeatCount = 0;
    
    self.gashaponV.animationDuration = 0.5;
    
    BOOL __block isdouble = NO;

    WS(weakSelf);
    self.timer = [PQ_TimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:0 repeatInterval:4.0 update:^(NSInteger i) {
        
        if (isdouble == NO) {
            
            weakSelf.gashaponV.animationDuration = 0.5;
            [weakSelf.gashaponV startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.gashaponV stopAnimating];
                isdouble = YES;
            });
            
        }else{
            
            weakSelf.gashaponV.animationDuration = 0.4;
            [weakSelf.gashaponV startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.gashaponV stopAnimating];
                isdouble = NO;
            });
        }

        
    } lastblock:^{
        
    }];
    
}
-(void)createGuluImgWithSting:(NSString *)str{
    
    if (!self.guluBgV) {
        UIImage *guluImg = [YYImage imageNamed:@"text_gulu"];
        self.guluBgV = [[UIView alloc] initWithFrame:CGRectMake(0, [GLGuideAnimationView scaleByHeight:self.dialogbox.image.size.height - 85] , [GLGuideAnimationView scaleByWidth:self.dialogbox.image.size.width] - [GLGuideAnimationView scaleByWidth:5], guluImg.size.height)];
        self.guluBgV.backgroundColor = [UIColor clearColor];
        self.guluBgV.clipsToBounds = YES;
        [self.dialogbox addSubview:self.guluBgV];
        
        self.textGulu = [[UIImageView alloc] initWithFrame:CGRectMake(self.guluBgV.width, 0, [GLGuideAnimationView scaleByHeight:guluImg.size.width], [GLGuideAnimationView scaleByHeight:guluImg.size.height])];
        self.textGulu.image = guluImg;
        [self.guluBgV addSubview:self.textGulu];
        
    }
    if ([str isEqualToString:TEXT_ONE]) {
        CGFloat x = 60;
        if (SCREEN_WIDTH == 375) {
            x = 50;
        }else if (SCREEN_WIDTH == 320){
            x = 35;
        }
        UIImage *FlipImg = [YYImage imageNamed:@"GLFlip2"];
        UIImage *FlipImg2 = [YYImage imageNamed:@"GLFlip1"];
        
        self.FlipImgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.guluBgV.width - [GLGuideAnimationView scaleByWidth:FlipImg.size.width] - 5 - x, self.textGulu.height - [GLGuideAnimationView scaleByHeight:FlipImg2.size.height] - [GLGuideAnimationView scaleByHeight:10], [GLGuideAnimationView scaleByWidth:FlipImg2.size.width], [GLGuideAnimationView scaleByHeight:FlipImg2.size.height])];
        self.FlipImgV2.alpha = 0;
        self.FlipImgV2.image = FlipImg2;
        [self.guluBgV addSubview:self.FlipImgV2];
        
        self.FlipImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.FlipImgV2.x,self.FlipImgV2.y - [GLGuideAnimationView scaleByHeight:FlipImg.size.height] - 5, [GLGuideAnimationView scaleByWidth:FlipImg.size.width], [GLGuideAnimationView scaleByHeight:FlipImg.size.height])];
        self.FlipImgV.image = FlipImg;
        self.FlipImgV.alpha = 0;
        [self.guluBgV addSubview:self.FlipImgV];
        [self flipImageScrol:YES];
        
    }
}
-(void)flipImageScrol:(BOOL)bl{
    
    if (self.FlipImgV) {
        [UIView animateWithDuration:0.3 animations:^{
            if (bl == YES) {
                self.FlipImgV.y = self.FlipImgV2.y - self.FlipImgV.height;
            }else{
                self.FlipImgV.y = self.FlipImgV2.y - self.FlipImgV.height - 5;
            }
        } completion:^(BOOL finished) {
            [self flipImageScrol:!bl];
        }];
    }
    
}
//提示框出现
-(void)showText:(NSString *)string{
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.dialogbox.frame = CGRectMake(0,0,[GLGuideAnimationView scaleByWidth:self.dialogbox.image.size.width], [GLGuideAnimationView scaleByHeight:self.dialogbox.image.size.height]);
        if (SCREEN_WIDTH == 320) {
            self.textBgView.x = 10;

        }else{
            self.textBgView.centerX = self.centerX;
        }
    } completion:^(BOOL finished) {
        [self createGuluImgWithSting:string];
        [self showTextGuluWithString:string];
        
    }];
    
}
//咕噜球滚动
-(void)showTextGuluWithString:(NSString *)string{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.FlipImgV.alpha = 1;
        self.FlipImgV2.alpha = 1;
        if (SCREEN_WIDTH == 375) {
            self.textGulu.x -= 50;
        }else if (SCREEN_WIDTH == 320){
            self.textGulu.x -= 35;
        }else{
            self.textGulu.x -= 60;
        }
    }completion:^(BOOL finished) {
        
        [self showTypewriterAnmTxt:string];
        
    }];
    
}
-(void)hiddenTextGuluWithText:(NSString *)txt{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.FlipImgV.alpha = 0;
        self.FlipImgV2.alpha = 0;
        if (SCREEN_WIDTH == 375) {
            self.textGulu.x += 50;
        }else if (SCREEN_WIDTH == 320){
            self.textGulu.x += 35;
        }else{
            self.textGulu.x += 60;
        }
    }completion:^(BOOL finished) {
        [self.FlipImgV2 removeFromSuperview];
        [self.FlipImgV removeFromSuperview];
        self.FlipImgV = nil;
        self.textLabel.attributedText = nil;
        [UIView animateWithDuration:0.3 animations:^{
            if (SCREEN_WIDTH == 320) {
                self.textBgView.frame = CGRectMake(10, [GLGuideAnimationView scaleByHeight:80], self.dialogbox.image.size.width, self.dialogbox.image.size.height);
            }else{
                self.textBgView.frame = CGRectMake(SCREEN_WIDTH/2 - self.dialogbox.image.size.width/2, [GLGuideAnimationView scaleByHeight:80], self.dialogbox.image.size.width, self.dialogbox.image.size.height);
            }
            self.dialogbox.frame = CGRectMake(60, self.dialogbox.image.size.height, 0, 0);
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showText:txt];
    });
}
//打字机效果
-(void)showTypewriterAnmTxt:(NSString *)txt{
    
    //    咕噜咕噜～～～初次见面，我是您的小宠物咕噜球，为了更好地为您服务，请告诉我吧——
    if (SCREEN_WIDTH == 320) {
        self.textLabel.width = [GLGuideAnimationView scaleByWidth:self.dialogbox.width] ;
        self.textLabel.centerY = [GLGuideAnimationView scaleByHeight:self.dialogbox.centerY] - [GLGuideAnimationView scaleByHeight:0] ;
        
    }else{
        self.textLabel.width = [GLGuideAnimationView scaleByWidth:self.dialogbox.width] - [GLGuideAnimationView scaleByWidth:60];
        self.textLabel.centerY = [GLGuideAnimationView scaleByHeight:self.dialogbox.centerY] - [GLGuideAnimationView scaleByHeight:15] ;
    }
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:txt];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0,[attributedString length])];
    if (SCREEN_WIDTH == 320) {
        self.textLabel.font = [UIFont systemFontOfSize:14 weight:2];
    }else{
        self.textLabel.font = [UIFont systemFontOfSize:16 weight:2];
    }

    WS(weakSelf);
    [PQ_TimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:attributedString.length repeatInterval:0.05 update:^(NSInteger i) {

        if (attributedString.length > i) {
            i ++;
            [attributedString addAttribute:NSForegroundColorAttributeName value:[PQ_TimerManager colorWithHexString:@"3b163e"] range:NSMakeRange(0,i)];
            weakSelf.textLabel.attributedText = attributedString;
        }
 
    } lastblock:^{
        if ([txt isEqualToString:TEXT_ONE]) {
            UIButton *btn = [UIButton  buttonWithType:(UIButtonTypeCustom)];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = weakSelf.bounds;
            [weakSelf addSubview:btn];
            [btn addTarget:weakSelf action:@selector(nextTxt:) forControlEvents:(UIControlEventTouchUpInside)];
            [weakSelf bringSubviewToFront:weakSelf.removeBtn];
        }else{
            if ([txt isEqualToString:TEXT_TWO]) {
                [weakSelf createIcarouselView:YES];
                
            }else{
                [weakSelf createIcarouselView:NO];
                
            }
        }

    }];
    
}
-(void)nextTxt:(UIButton *)btn{
    
    [self hiddenTextGuluWithText:TEXT_TWO];
    [btn removeFromSuperview];
    
}

-(void)createIcarouselView:(BOOL)isfirst{
    
    GLiCarouselScroView *scro = [[[NSBundle mainBundle] loadNibNamed:@"GLiCarouselScroView" owner:nil options:nil] firstObject];
    scro.delegate = self;
    scro.isFirst = isfirst;
    scro.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    scro.frame = self.bounds;
    [self addSubview:scro];
    scro.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        scro.alpha = 1;
    }];
    [self bringSubviewToFront:self.removeBtn];
    
}
-(void)GLiCarouselScroView:(GLiCarouselScroView *)csV nextBtnClick:(UIButton *)nextBtn
{
    
    [self hiddenTextGuluWithText:TEXT_THREE];
    
}
-(void)GLiCarouselFirstClickBtnWithScroView:(GLiCarouselScroView *)csV{
    [self.timer pq_close];
    self.shineView.hidden = NO;
    self.shineView.frame = CGRectMake(0, 0, [GLGuideAnimationView scaleByWidth:self.shineView.image.size.width], [GLGuideAnimationView scaleByHeight:self.shineView.image.size.height]);
    self.shineView.center = self.gashaponV.center;
    self.baffleView.hidden = NO;
    self.baffleView.clipsToBounds = YES;
    self.baffleView.layer.cornerRadius = 40;
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:M_PI*1];
    anima.repeatCount = MAXFLOAT;
    anima.duration = 2;
    [self.shineView.layer addAnimation:anima forKey:@"rotateAnimation"];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (int i = 1; i <= 8; i++) {
        
        NSString *fileName = [NSString stringWithFormat:@"gashapon_ compose_%d",i];
        
        UIImage *image = [YYImage imageNamed:fileName];
        
        [images addObject:image];
    }
    //设置动画的
    self.gashaponV.animationImages = images;
    
    self.gashaponV.animationRepeatCount = 0;
    
    self.gashaponV.animationDuration = 0.5;
    
    [self.gashaponV startAnimating];
    
}
//小球滚动
-(void)GLiCarouselOpenAppWithScroView:(GLiCarouselScroView *)csV{
    //    [self.gashaponV stopAnimating];
    //    [self.gashaponV performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.gashaponV.animationDuration];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.textGulu.x += 70;
        
    }completion:^(BOOL finished) {
        self.textLabel.attributedText = nil;
        [UIView animateWithDuration:0.3 animations:^{
            
            if (SCREEN_WIDTH == 320) {
                self.textBgView.frame = CGRectMake(10, [GLGuideAnimationView scaleByHeight:80], self.dialogbox.image.size.width, self.dialogbox.image.size.height);
            }else{
                self.textBgView.frame = CGRectMake(SCREEN_WIDTH/2 - self.dialogbox.image.size.width/2, [GLGuideAnimationView scaleByHeight:80], self.dialogbox.image.size.width, self.dialogbox.image.size.height);
            }
            self.dialogbox.frame = CGRectMake(60, self.dialogbox.image.size.height, 0, 0);
        } completion:^(BOOL finished) {
            
            CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
            NSValue *value1 = [NSNumber numberWithFloat:-M_PI/180*3];
            NSValue *value2 = [NSNumber numberWithFloat:M_PI/180*3];
            NSValue *value3 = [NSNumber numberWithFloat:-M_PI/180*3];
            anima2.values = @[value1,value2,value3];
            anima2.duration = 0.2;
            anima2.repeatCount = 3;
            anima2.delegate =self;
            anima2.removedOnCompletion = NO;
            [_gashaponV.layer addAnimation:anima2 forKey:@"shakeAnimation"];
            
            
            [self gashAndBallAnimation];
            
            
        }];
        
    }];
    
}
-(void)gashAndBallAnimation{
    
    NSMutableArray *ballArr = [NSMutableArray array];
    for (int i = 1; i < 21; i++) {
        [ballArr addObject:[YYImage imageNamed:[NSString stringWithFormat:@"ball_%d",i]]];
    }
    
    self.scrBallImageView.animationImages = ballArr;
    self.scrBallImageView.animationDuration = 0.8;
    self.scrBallImageView.animationRepeatCount = 0;
}
-(void)scroolViewBall{
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(-77, -20)];
    CGFloat y = 70;
    //    if (self.width == 375) {
    //        y = 100;
    //    }
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(_baffleView.width - y, _baffleView.height - y)];
    anima.fillMode = kCAFillModeForwards;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    anima.removedOnCompletion = NO;
    anima.duration = 0.8;
    anima.delegate = self;
    [self.scrBallImageView.layer addAnimation:anima forKey:@"positionAnimation"];
    [self.scrBallImageView startAnimating];
}


-(void)lightVChangeAlpha{
    WS(weakSelf);
  self.timer1 = [PQ_TimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:0 repeatInterval:2 update:^(NSInteger i){
      [UIView animateWithDuration:2 animations:^{
          if (weakSelf.lightV.alpha == 1) {
              weakSelf.lightV.alpha = .3;
              weakSelf.gashaponV.y += 10;
          }else{
              weakSelf.lightV.alpha = 1;
              weakSelf.gashaponV.y -= 10;
          }
      }];
    } lastblock:^{
        
    }];
    
//    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
//
//    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if ( [self.scrBallImageView.layer animationForKey:@"positionAnimation"] == anim ) {
        [self.scrBallImageView stopAnimating];
        [self createGLLuminescenceBall];
        
    }else if( [self.centerballImgView.layer animationForKey:@"ballAnimation"] == anim){
        [self.centerballImgView stopAnimating];
        [self createOpenBall];
        [self.centerballImgView removeFromSuperview];
    }else if ([self.gashaponV.layer animationForKey:@"shakeAnimation"] == anim){
        [self scroolViewBall];
        //        [self.gashaponV.layer removeFromSuperlayer];
    }
    
}
-(void)createGLLuminescenceBall{
    
    UIImage *ballImg = [YYImage imageNamed:@"GLLuminescenceBall"];
    CGFloat y = 17;
    if (SCREEN_WIDTH == 320) {
        y = 7;
    }
    UIImageView *ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_baffleView.width - 60, y,[GLGuideAnimationView scaleByWidth:ballImg.size.width],[GLGuideAnimationView scaleByHeight:ballImg.size.height])];
    ballImageView.image = ballImg;
    ballImageView.hidden = YES;
    [self.baffleView addSubview:ballImageView];
//    __block int i = 0;
//    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        if (i == 5) {
//            [timer invalidate];
//            [ballImageView removeFromSuperview];
//            [self createBallImg];
//            [self.scrBallImageView removeFromSuperview];
//        }
//        ballImageView.hidden = !ballImageView.hidden;
//        i++;
//    }];
    WS(weakSelf);
    [PQ_TimerManager pq_createTimerWithType:PQ_TIMERTYPE_CREATE_OPEN updateInterval:5 repeatInterval:0.1 update:^(NSInteger i){
        if (i == 5) {
//            [timer invalidate];
            [ballImageView removeFromSuperview];
            [weakSelf createBallImg];
            [weakSelf.scrBallImageView removeFromSuperview];
        }
        ballImageView.hidden = !ballImageView.hidden;
//        i++;
    }lastblock:^{
        
    }];
}
-(void)createBallImg{
    
    CGFloat x = _baffleView.x + _baffleView.width - 100;
    CGFloat y = _baffleView.y + _baffleView.height - 130;
    //    if (self.width == 375) {
    //        x = _baffleView.x + _baffleView.width - 130;
    //        y = _baffleView.y + _baffleView.height - 160;
    //    }
    
    self.centerballImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x,y, [GLGuideAnimationView scaleByWidth:60], [GLGuideAnimationView scaleByWidth:60])];
    
    [self addSubview:self.centerballImgView];
    
    NSMutableArray *ballArr = [NSMutableArray array];
    for (int i = 21; i <= 59; i++) {
        [ballArr addObject:[YYImage imageNamed:[NSString stringWithFormat:@"ball_%d",i]]];
    }
    
    self.centerballImgView.image = [YYImage imageNamed:@"ball_59"];
    self.centerballImgView.animationImages = ballArr;
    self.centerballImgView.animationDuration = 1;
    self.centerballImgView.animationRepeatCount = 1;
    [self.centerballImgView startAnimating];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"position"];
    anima.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.centerballImgView.center.x, self.centerballImgView.center.y)];
    anima.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y)];
    anima.fillMode = kCAFillModeForwards;
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    anima.removedOnCompletion = NO;
    anima.duration = 1;
    anima.delegate = self;
    [self.centerballImgView.layer addAnimation:anima forKey:@"ballAnimation"];
    
    CABasicAnimation *bigAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bigAnimation.duration=1;
    bigAnimation.fromValue=[NSNumber numberWithFloat:1.0f];

        bigAnimation.toValue=[NSNumber numberWithFloat:1.4f];
    bigAnimation.removedOnCompletion=NO;//动画 完成后自动回放
    bigAnimation.fillMode = kCAFillModeForwards;
    
    [self.centerballImgView.layer addAnimation:bigAnimation forKey:@"ballAnimation2"];
    
}
-(void)createOpenBall{
    
    
    self.openballImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 180)];
    self.openballImgView.center = self.center;
    self.openballImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.openballImgView];
//    if ([Utils isLogin]) {
//        [GLNOT postNotificationName:@"GLGuideAnmFristRemoveNot" object:nil];
//    }
    NSMutableArray *ballArr = [NSMutableArray array];
    for (int i = 60; i <= 99; i++) {
        [ballArr addObject:[YYImage imageNamed:[NSString stringWithFormat:@"ball_%d",i]]];
    }
    self.openballImgView.animationImages = ballArr;
    self.openballImgView.animationDuration = 1.5;
    self.openballImgView.animationRepeatCount = 1;
    [self.openballImgView startAnimating];
    
    CABasicAnimation *bigAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bigAnimation.duration = 0.001;
    bigAnimation.fromValue=[NSNumber numberWithFloat:1.0f];
    bigAnimation.toValue=[NSNumber numberWithFloat:1.4f];
    bigAnimation.removedOnCompletion=NO;//动画 完成后自动回放
    bigAnimation.fillMode = kCAFillModeForwards;
    [self.openballImgView.layer addAnimation:bigAnimation forKey:@"ballAnimation2"];
    UIView *vc = [[UIView alloc] initWithFrame:self.bounds];
    vc.backgroundColor = [UIColor whiteColor];
    vc.alpha = 0;
    [self addSubview:vc];
    [UIView animateWithDuration:1.5 animations:^{
        vc.alpha = 1;
    } completion:^(BOOL finished) {
        [self.timer pq_close];
        [self.timer1 pq_close];
        [self stopAnimate];
        [self.centerballImgView.layer removeAnimationForKey:@"ballAnimation"];
        [self.scrBallImageView.layer removeAnimationForKey:@"positionAnimation"];
        [self.gashaponV.layer removeAnimationForKey:@"shakeAnimation"];
//        if (self.isFirst) {
//            [GLNOT postNotificationName:@"GLGuideAnmFristRemoveNot" object:nil];
//        }
        [self removeFromSuperview];
    }];
    
    
}


-(void)startAnimate
{
    
    [GLGravityManager sharedGravity].timeInterval = 0.05;
    __weak typeof(self) weakSelf = self;
    [[GLGravityManager sharedGravity]startDeviceMotionUpdatesBlock:^(float x, float y, float z) {
        
        [weakSelf changeFrameWithView:weakSelf.bgV width:SCREEN_WIDTH + 50 y:y];
        [weakSelf changeFrameWithView:weakSelf.starV width:SCREEN_WIDTH + 55 y:y];
        [weakSelf changeFrameWithView:weakSelf.lightV width:SCREEN_WIDTH + 50 y:y];
        
    }];
    
    
    [[GLGravityManager sharedGravity]startAccelerometerUpdatesBlock:^(float x, float y, float z) {
        
        if (x > 0) {
            
            CGRect frame = weakSelf.planet_1.frame;
            frame.origin.x = (x*30) + 30;
            if (x >= 0 && x <= 40) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.planet_1.frame = frame;
                }];
            }
            
            CGRect planet_2Frame = weakSelf.planet_2.frame;
            planet_2Frame.origin.x = SCREEN_WIDTH - 50 + (x*30);
            if (x*30 <= 15) {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    weakSelf.planet_2.frame = planet_2Frame;
                }];
            }
            CGRect planet_3Frame = weakSelf.planet_3.frame;
            planet_3Frame.origin.x = 35 + (x*30);
            if (x*30 <= 20) {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    weakSelf.planet_3.frame = planet_3Frame;
                }];
            }
            
        }
        else{
            
            CGRect frame = weakSelf.planet_1.frame;
            frame.origin.x = (x*60) + 30;
            if (frame.origin.x >= 0  ) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.planet_1.frame = frame;
                }];
            }
            CGRect planet_2Frame = weakSelf.planet_2.frame;
            planet_2Frame.origin.x = SCREEN_WIDTH - 50 + (x*30);
            if ((x*30) >= -15) {
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.planet_2.frame = planet_2Frame;
                }];
            }
            CGRect planet_3Frame = weakSelf.planet_3.frame;
            planet_3Frame.origin.x = 35 + (x*30);
            if (x*30 >= -20) {
                [UIView animateWithDuration:0.25 animations:^{
                    
                    weakSelf.planet_3.frame = planet_3Frame;
                }];
            }
        }
        
        
    }];
    
}

-(void)changeFrameWithView:(UIImageView *)view width:(CGFloat)width y:(CGFloat)y {
    
    float scrollSpeed = (width - self.frame.size.width)/2/50;
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
        if (view.frame.origin.x <=0 && view.frame.origin.x >= self.frame.size.width - width)
        {
            float invertedYRotationRate = y * 1.0;
            
            float interpretedXOffset = view.frame.origin.x + invertedYRotationRate * (width/[UIScreen mainScreen].bounds.size.width) * scrollSpeed + width/2;
            
            view.center = CGPointMake(interpretedXOffset, view.center.y);
            
        }
        
        if (view.frame.origin.x >0)
        {
            view.frame = CGRectMake(0, view.frame.origin.y, width, view.frame.size.height);
            
        }
        if (view.frame.origin.x < self.frame.size.width - width)
        {
            view.frame = CGRectMake(self.frame.size.width - width, view.frame.origin.y, width, view.frame.size.height);
            
        }
        
    } completion:nil];
    
    
}


-(void)stopAnimate
{
    [[GLGravityManager sharedGravity] stop];
}
+ (CGFloat)scaleByWidth:(CGFloat)num {
    CGFloat numF = num;
    if (SCREEN_WIDTH == 320) {
        numF = kSCREEN_WIDTH4S_SCALE * num;
    }else if (SCREEN_WIDTH == 414) {
        numF = kSCREEN_WIDTH6P_SCALE * num;
    }else if (SCREEN_WIDTH == 375){
        numF = kSCREEN_WIDTH6S_SCALE * num;
    }
    return numF;
}
+ (CGFloat)scaleByHeight:(CGFloat)num {
    CGFloat numF = num;
    if (SCREEN_HEIGHT == 480) {
        numF = kSCREEN_HEIGHT4S_SCALE * num;
    }else if (SCREEN_HEIGHT == 568) {
        numF = kSCREEN_HEIGHT5S_SCALE * num;
    }else if (SCREEN_HEIGHT == 667) {
        numF = kSCREEN_HEIGHT6S_SCALE * num;
    }
    return numF;
}




@end

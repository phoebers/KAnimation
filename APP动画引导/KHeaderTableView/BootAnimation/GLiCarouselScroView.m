//
//  GLiCarouselScroView.m
//  GLAnimation
//
//  Created by 王凡 on 2017/4/28.
//  Copyright © 2017年 czk. All rights reserved.
//

#import "GLiCarouselScroView.h"
#import "iCarousel.h"
#import "GLSlideLoopView.h"
#import "GLOutLineLabel.h"
#import "GLGuideAnimationView.h"
#import "RotateAnimation.h"
#import "PQ_TimerManager.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface GLiCarouselScroView ()<GLSlideLoopViewDelegate,CAAnimationDelegate,RotateAnimationDelegate>

@property (nonatomic, assign) CGSize cardSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextBtnHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelY;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,strong)NSMutableArray *arr2;
@property (nonatomic,strong)NSMutableArray *indexArr;

@property (weak, nonatomic) IBOutlet outLineLabel *detileLabel;
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (nonatomic,strong)GLSlideLoopView *slideV;
@property (nonatomic,assign)BOOL isClick;
@end

@implementation GLiCarouselScroView
- (void)dealloc
{
    NSLog(@"释放");
}
-(NSMutableArray *)indexArr{
    if (!_indexArr) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}
/* */
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    UIImage *img = [YYImage imageNamed:@"动作"];
    
    self.cardSize = CGSizeMake([GLGuideAnimationView scaleByWidth:img.size.width] ,[GLGuideAnimationView scaleByHeight:img.size.height]);
    
    
//    YTKKeyValueStore *store = [[GLSQLManager sharedInstance] getSqlLite];
//    NSDictionary *preference = [store getObjectById:@"CONFIGGAMEPREFERENCE" fromTable:CONFIGTAB];
//    self.arr = [NSMutableArray arrayWithArray:preference[@"tags"]];
//    self.arr2 = [NSMutableArray arrayWithArray:preference[@"themes"]];
    self.arr = [NSMutableArray arrayWithObjects:@"MMO",@"MOBA",@"休闲放置",@"体育",@"其他",@"养成",@"冒险",@"动作",@"卡牌",@"即时战略",@"塔防",@"射击",@"工具",@"文字",@"格斗",@"棋牌",@"益智",@"竞速",@"经营策略",@"角色扮演",@"音乐", nil];
    self.arr2 = [NSMutableArray arrayWithObjects:@"主机改编",@"乱斗",@"侦探",@"偶像企划",@"动漫改编",@"动物",@"历史",@"历史改编",@"古风",@"商业",@"小说改编",@"影视改编",@"恋爱",@"恐怖",@"战争",@"拟人",@"机器人",@"架空",@"校园",@"武侠",@"漫画改编",@"神话",@"科幻",@"端游改编",@"美少女",@"美少年",@"运动",@"魔幻" ,nil];

    self.bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];

    self.slideV = [[GLSlideLoopView alloc] initWithFrame:CGRectMake(0,[GLGuideAnimationView scaleByHeight:310], SCREEN_WIDTH, self.cardSize.height + 100)];
    
    self.titleLabelY.constant = [GLGuideAnimationView scaleByHeight:250];
    
    self.nextBtnY.constant = [GLGuideAnimationView scaleByHeight:60];
    
    self.nextBtnWidth.constant = [GLGuideAnimationView scaleByHeight:self.nextBtn.imageView.image.size.width];

    self.nextBtnHeight.constant = [GLGuideAnimationView scaleByHeight:self.nextBtn.imageView.image.size.height];

    self.slideV.cardSize = self.cardSize;
    
    if (self.isFirst) {
      self.slideV.arr = self.arr;
    }else{
        self.slideV.arr = self.arr2;
    }
    
    self.slideV.delegate = self;
    
    [self.bgV addSubview:self.slideV];
    
    [self.slideV.carousel reloadData];
    
    self.detileLabel.outLineWidth = 3;
    
    self.detileLabel.outLinetextColor = [UIColor whiteColor];
    
    self.detileLabel.labelTextColor =  [PQ_TimerManager colorWithHexString:@"ff83a9"];
    
    
}
-(void)setIsFirst:(BOOL)isFirst{
    _isFirst = isFirst;
    if (_isFirst) {
        self.nextBtn.hidden = NO;
    }else{
        self.nextBtn.hidden = YES;
        RotateAnimation *rview = [[RotateAnimation alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200)];
        rview.delegate = self;
        rview.userInteractionEnabled = NO;
        rview.tag = 51;
        [rview setRotateAnimationBackgroundColor:[UIColor clearColor]];
        [self addSubview:rview];
    }
}
-(void)RotateOpenAppWithAnimation:(RotateAnimation *)rotateView{
    
    
    NSUserDefaults *defous = [NSUserDefaults standardUserDefaults];
    [defous setObject:self.indexArr forKey:@"CarouselSecond"];
    [defous synchronize];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(GLiCarouselOpenAppWithScroView:)]) {
        [_delegate GLiCarouselOpenAppWithScroView:self];
    }
    
    
}
- (IBAction)nextBtnClick:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(GLiCarouselScroView:nextBtnClick:)]) {
        [_delegate GLiCarouselScroView:self nextBtnClick:sender];
    }
    NSUserDefaults *defous = [NSUserDefaults standardUserDefaults];
    [defous setObject:self.indexArr forKey:@"CarouselFirst"];
    [defous synchronize];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)carousel:(iCarousel *)carousel didIndex:(NSInteger)index goldImg:(NSString *)glidImg img:(UIImage *)img{
    if (!self.isClick) {
        if (_isFirst) {
            self.nextBtn.userInteractionEnabled = YES;
            [self.nextBtn setImage:[YYImage imageNamed:@"bg_button_2"] forState:(UIControlStateNormal)];
        }else{
            RotateAnimation *rview = (RotateAnimation *)[self viewWithTag:51];
            rview.userInteractionEnabled = YES;
            [rview TransformSlideline];
            [rview createAnimation: M_PI   andEndAngle:2 * M_PI - 0.3 andType: 1];
            if (_delegate && [_delegate respondsToSelector:@selector(GLiCarouselFirstClickBtnWithScroView:)]) {
                [_delegate GLiCarouselFirstClickBtnWithScroView:self ];
            }
        }

    }

    [self.indexArr addObject:glidImg];
    self.isClick = YES;
    UIImageView *goldImg = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - img.size.width /2, self.slideV.y - 10, img.size.width, img.size.height)];
    goldImg.image = img;
    goldImg.tag = 300;
    goldImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:goldImg];
    
    [self transFromWithRepeatCount:10 img:glidImg duration:0.4];
    [self addStarImage];

}
-(void)addStarImage{
    
    UIImage *starImg = [YYImage imageNamed:@"effect_1"];
    UIImageView *starImgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - starImg.size.width /2, self.slideV.y - starImg.size.height + 15, starImg.size.width, starImg.size.height)];
    [self addSubview:starImgV];
    starImgV.animationDuration = .3;
    NSMutableArray *starArr = [NSMutableArray array];
    for (int i = 1 ; i < 23; i++) {
        [starArr addObject:[YYImage imageNamed:[NSString stringWithFormat:@"effect_%d",i]]];
    }
    starImgV.animationImages = starArr;
    starImgV.animationRepeatCount = 0;
    [starImgV setAnimationDuration:0.5];
    [starImgV startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [starImgV removeFromSuperview];
    });
    
}
-(void)transFromWithRepeatCount:(NSInteger)repeatCount img:(NSString *)img duration:(CGFloat)duration{
    
   
    UIImageView *kpView = [self viewWithTag:300];
    [self enlarge:kpView];
    
    [UIView animateWithDuration:0.4 delay:0.5 options:(UIViewAnimationOptionOverrideInheritedDuration) animations:^{
        kpView.y = [GLGuideAnimationView scaleByHeight:510];

    } completion:^(BOOL finished) {
        
        [kpView removeFromSuperview];

    }];

    
    NSString *filePath1 = @"Gold1";
    NSString *filePath2 = @"Gold2";
    NSString *filePath3 = @"Gold3";
    NSString *filePath4 = @"Gold4";
    NSString *filePath5 = @"Gold1";
    NSString *filePath6 = @"Gold2";
    NSString *filePath7 = @"Gold3";
    NSString *filePath8 = @"Gold4";
    kpView.animationImages = [NSArray arrayWithObjects:
                              [YYImage imageNamed:filePath1],
                              [YYImage imageNamed:filePath2],
                              [YYImage imageNamed:filePath3],
                              [YYImage imageNamed:filePath4],
                              [YYImage imageNamed:filePath5],
                              [YYImage imageNamed:filePath6],
                              [YYImage imageNamed:filePath7],
                              [YYImage imageNamed:filePath8],
                              nil];
    kpView.animationRepeatCount = 0;
    [kpView setAnimationDuration:0.4];
    [kpView startAnimating];
}
-(void)enlarge:(UIView *)kpView{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    scaleAnimation.autoreverses = NO;
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *yscaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yscaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    yscaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    yscaleAnimation.autoreverses = NO;
    yscaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5;
    animationGroup.delegate = self;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = NO;
    //        animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation,yscaleAnimation,nil]];
    [kpView.layer addAnimation:animationGroup forKey:@"animationTwoGroup"];
    
    
}
-(void)narrow:(UIView *)kpView{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.3];
    scaleAnimation.autoreverses = NO;
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *yscaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    yscaleAnimation.fromValue = [NSNumber numberWithFloat:1];
    yscaleAnimation.toValue = [NSNumber numberWithFloat:0.3];
    yscaleAnimation.autoreverses = NO;
    yscaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 0.5;
    animationGroup.autoreverses = NO;   //是否重播，原动画的倒播
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = NO;
    //        animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    [animationGroup setAnimations:[NSArray arrayWithObjects:scaleAnimation,yscaleAnimation,nil]];
    animationGroup.delegate = self;
    [kpView.layer addAnimation:animationGroup forKey:@"animationTwoG"];

    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    UIImageView *kpView = [self viewWithTag:300];
    if ( [kpView.layer animationForKey:@"animationTwoGroup"]  == anim){
        
            [self narrow:kpView];
        
    }else if ( [kpView.layer animationForKey:@"animationTwoG"]  == anim){
        
        
        [kpView.layer removeAnimationForKey:@"animationTwoG"];
    }

}


@end

//
//  GLiCarouselScroView.h
//  GLAnimation
//
//  Created by 王凡 on 2017/4/28.
//  Copyright © 2017年 czk. All rights reserved.
//

#import <UIKit/UIKit.h>



@class GLiCarouselScroView;
@protocol GLiCarouselScroViewDelegate <NSObject>

-(void)GLiCarouselScroView:(GLiCarouselScroView *)csV nextBtnClick:(UIButton *)nextBtn;

-(void)GLiCarouselOpenAppWithScroView:(GLiCarouselScroView *)csV;

-(void)GLiCarouselFirstClickBtnWithScroView:(GLiCarouselScroView *)csV;
@end

@interface GLiCarouselScroView : UIView

@property (nonatomic,weak)id <GLiCarouselScroViewDelegate> delegate;
@property (nonatomic,assign)BOOL isFirst;

@end

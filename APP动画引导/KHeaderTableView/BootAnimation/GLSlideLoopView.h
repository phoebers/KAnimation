//
//  GLSlideLoopView.h
//  DemoTaskTray
//
//  Created by 王凡 on 2017/4/26.
//  Copyright © 2017年 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@protocol GLSlideLoopViewDelegate <NSObject>

- (void)carousel:(iCarousel *)carousel didIndex:(NSInteger)index goldImg:(NSString *)glidImg img:(UIImage*)img;

@end


@interface GLSlideLoopView : UIView<
iCarouselDelegate,
iCarouselDataSource
>

@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic, assign) CGSize cardSize;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic,weak)id <GLSlideLoopViewDelegate> delegate;


@end

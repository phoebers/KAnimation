//
//  GLSlideLoopView.m
//  DemoTaskTray
//
//  Created by 王凡 on 2017/4/26.
//  Copyright © 2017年 LJC. All rights reserved.
//

#import "GLSlideLoopView.h"
#import "GLOutLineLabel.h"
#import <YYImage/YYImage.h>

@interface GLSlideLoopView ()

@property (nonatomic,assign)BOOL isScroll;
@property (nonatomic,assign)NSInteger index;
@end

@implementation GLSlideLoopView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)dealloc
{
    NSLog(@"---");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.carousel = [[iCarousel alloc] initWithFrame:self.bounds];
        [self addSubview:self.carousel];
        self.carousel.delegate = self;
        self.carousel.dataSource = self;
        self.carousel.type = 1;
        self.carousel.bounceDistance = 1.0f;
        self.carousel.viewpointOffset = CGSizeMake(0, 45);
        self.carousel.perspective = -2.0/100;
        
    }
    return self;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.arr.count;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return self.cardSize.width + 10;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
            
            //可以打开这里看一下效果
        case iCarouselOptionWrap:
        {
            return YES;
        }
        case iCarouselOptionCount:
        {
            return 18 * M_PI;
        }
            //        case iCarouselOptionRadius:
            //        {
            //            return 128 * M_PI;
            //        }
        default:
            break;
    }
    
    return value;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *cardView = view;
    
    if ( !cardView )
    {
        cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height + 30)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.cardSize.width, self.cardSize.height)];
        [cardView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.tag = [@"image" hash];
        
        outLineLabel *lb = [[outLineLabel alloc] initWithFrame:CGRectMake(0, self.cardSize.height + 10, self.cardSize.width, 20)];
        lb.tag = [@"label" hash];
        lb.textColor = [UIColor whiteColor];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.outLinetextColor = [UIColor blackColor];
        lb.outLineWidth = 3;
        lb.labelTextColor =  [UIColor whiteColor];
        lb.font = [UIFont systemFontOfSize:15];
        if (self.frame.size.width == 320) {
            lb.font = [UIFont systemFontOfSize:13];
        }
        [cardView addSubview:lb];
        if (index == self.arr.count - 2) {
            lb.hidden = YES;
        }
        if (index == 2) {
            lb.hidden = YES;
        }
    }
    
    
    UIImageView *imageView = (UIImageView*)[cardView viewWithTag:[@"image" hash]];
    UIImage *img = [YYImage imageNamed:self.arr[index]];
    imageView.image = img;
    if (!img && img == nil) {
        imageView.image = [YYImage imageNamed:@"Gold1"];
    }
    [imageView.image setAccessibilityIdentifier:self.arr[index]];
    UILabel *lb = (UILabel*)[cardView viewWithTag:[@"label" hash]];
    lb.text = self.arr[index];
    
    
    
    
    return cardView;
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    //    NSLog(@"6");
    if (self.isScroll) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(carousel:didIndex:goldImg:img:)]) {
            UIImageView *imageView = (UIImageView*)[carousel viewWithTag:[@"image" hash]];
            [self.delegate carousel:carousel didIndex:self.index goldImg:self.arr[self.index] img:imageView.image];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [carousel setUserInteractionEnabled:YES];
            
        });
        [self.arr removeObjectAtIndex:self.index];
        
        [carousel removeItemAtIndex:self.index animated:YES];
        if (self.arr.count < 5) {
            [self hiddenAllLabel:carousel];
        }else{
            
            [self carouselCurrentItemIndexDidChange:carousel];
            
        }
        //        [carousel reloadData];
        self.isScroll = NO;
    }
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index{
    return YES;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    
    if (!self.isScroll) {
        self.isScroll = YES;
    }
    [carousel setUserInteractionEnabled:NO];
    self.index = index;
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
    if (self.arr.count >= 5) {
        [self hiddenBothSidesLabels:carousel];
    }
    
}

-(void)hiddenAllLabel:(iCarousel *)carousel{
    
    
    for (UIView *cardV in carousel.visibleItemViews) {
        for (UIView *v in cardV.subviews) {
            if ( [v isKindOfClass:[UILabel class]] ) {
                v.hidden = NO;
            }else{
                v.alpha = 1;
            }
        }
    }
    
    
}

-(void)hiddenBothSidesLabels:(iCarousel *)carousel{
    
    NSInteger i = carousel.currentItemIndex;
    NSInteger x = i - 2;
    NSInteger y = i + 2;
    NSInteger x1 = i - 1;
    NSInteger y1 = i + 1;
    NSInteger j = 0;
    if (x < 0) {
        x = self.arr.count + (i - 2);
    }
    if (y > self.arr.count -1) {
        y = i + 2 - self.arr.count ;
    }
    if (x1 < 0) {
        x1 = self.arr.count + (i - 1);
    }
    if (y1 > self.arr.count -1) {
        y1 = i + 1 - self.arr.count ;
    }
    for (UIView *cardV in carousel.visibleItemViews) {
        for (UIView *v in cardV.subviews) {
            if ( [v isKindOfClass:[UILabel class]] ) {
                UILabel *label = (UILabel *)v;
                if ([label.text isEqualToString:self.arr[x1]] || [label.text isEqualToString:self.arr[y1]] || [label.text isEqualToString:self.arr[i]]) {
                    label.hidden = NO;
                }else{
                    label.hidden = YES;
                }
            }
            else{
                UIImageView *imgV = (UIImageView *)v;
                if ([[imgV.image accessibilityIdentifier] isEqualToString:self.arr[x]] || [[imgV.image accessibilityIdentifier] isEqualToString:self.arr[y]]) {
                    v.alpha  = 0.7;
                }else if ([[imgV.image accessibilityIdentifier] isEqualToString:self.arr[x1]] || [[imgV.image accessibilityIdentifier] isEqualToString:self.arr[y1]] || [[imgV.image accessibilityIdentifier] isEqualToString:self.arr[i]]){
                    v.alpha  = 1;
                }else{
                    v.alpha = 0;
                }
            }
        }
        j ++;
    }
}
@end

//
//  PQ_TimerManager.m
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/30.
//  Copyright © 2016年 PL. All rights reserved.
//

#import "PQ_TimerManager.h"

@interface PQ_TimerManager ()

@property (nonatomic,assign) NSTimeInterval repeatTime;
@property (nonatomic,assign) NSInteger timeInterval;
@property (nonatomic,assign) NSTimeInterval timeSumInterval;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) TimerUpdateBlock updateBlock;
@property (nonatomic,copy) TimerLastBlock   lastBlock;

@property (nonatomic,assign) BOOL isStart;
@end

@implementation PQ_TimerManager



+ (instancetype)pq_createTimerWithType:(PQ_TimerType)type updateInterval:(NSTimeInterval)interval repeatInterval:(NSTimeInterval)repeatInterval update:(TimerUpdateBlock)block lastblock:(TimerLastBlock)lastblock{
    PQ_TimerManager * timerManager = [[self alloc]init];
    //多少秒更新一次
    timerManager.timeSumInterval = interval;
    //多少秒执行一次
    timerManager.repeatTime = repeatInterval;
    //保存block
    timerManager.updateBlock = block;
    
    timerManager.lastBlock = lastblock;
    //判断类型
    if(type == PQ_TIMERTYPE_CREATE_OPEN){
        [timerManager pq_open];
    }
    return timerManager;
}
/**
 *  打开
 */
- (void)pq_open{
    //开启之前先关闭定时器
    [self pq_close];
    //把计数器归零
    self.timeInterval = 0;
    //创建timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.repeatTime target:self selector:@selector(pq_timeUpdate) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.isStart = YES;
}
//更新时间
- (void)pq_timeUpdate{
    //如果不是开始 直接返回 并且归零计数器
    if (!self.isStart) {
        return;
    }
    self.updateBlock(self.timeInterval);
    
    if (self.timeInterval == self.timeSumInterval && self.timeInterval != 0) {
        if (self.lastBlock) {
            self.lastBlock();
        }
        [self pq_close];
        
    }
    self.timeInterval ++;
}

/**
 *  关闭
 */
- (void)pq_close{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.timer = nil;
}
/**
 *  把时间设置为零
 */
- (void)pq_updateTimeIntervalToZero{
    self.timeInterval = 0;
}
/**
 *  更新现在的时间
 *
 *  @param interval
 */
- (void)pq_updateTimeInterval:(NSTimeInterval)interval{
    self.timeInterval = interval;
}

/**
 *  开机计数
 */
- (void)pq_start{
    self.isStart = YES;
}
/**
 *  暂停计数
 */
- (void)pq_pause{
    self.isStart = NO;
}
/**
 *  开始计时器
 */
- (void)pq_distantPast{
    [self.timer setFireDate:[NSDate distantPast]];
}
/**
 *  暂停计时器
 */
- (void)pq_distantFuture{
    [self.timer setFireDate:[NSDate distantFuture]];
}
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}
@end

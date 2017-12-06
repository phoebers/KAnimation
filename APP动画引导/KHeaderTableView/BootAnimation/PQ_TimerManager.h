//
//  PQ_TimerManager.h
//  PGQLZKugouDemo
//
//  Created by ios on 16/7/30.
//  Copyright © 2016年 PL. All rights reserved.
//[PQ_TimerManager pq_createTimerWithType:(PQ_TIMERTYPE_CREATE_OPEN) updateInterval:30 repeatInterval:2 update:^(NSInteger i) {   //每次执行的方法
//    //PQ_TIMERTYPE_CREATE_OPEN 是否立刻开始执行
//    //updateInterval 执行的次数 传0一直执行 （例如传 30  运行30次之后定时器停止）
//    //repeatInterval 没多少秒执行
//} lastblock:^{
//    //最后一次执行
//}];
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import <YYImage/YYImage.h>
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
//宽比例
#define kSCREEN_WIDTH4S_SCALE (320.0/414.0)
#define kSCREEN_WIDTH5S_SCALE (320.0/414.0)
#define kSCREEN_WIDTH6S_SCALE (375.0/414.0)
#define kSCREEN_WIDTH6P_SCALE (414.0/414.0)
#define SCREEN_WIDTH_SCALE [UIScreen mainScreen].bounds.size.width / 375
#define SCREEN_WIDTH_6S(A) SCREEN_WIDTH_SCALE * A

//高比例
#define kSCREEN_HEIGHT4S_SCALE (480.0/736.0)
#define kSCREEN_HEIGHT5S_SCALE (568.0/736.0)
#define kSCREEN_HEIGHT6S_SCALE (667.0/736.0)
#define kSCREEN_HEIGHT6P_SCALE (736.0/736.0)
#define SCREEN_HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height / 667
#define SCREEN_HEIGHT_6S(A) SCREEN_HEIGHT_SCALE * A


typedef enum : NSUInteger {
    PQ_TIMERTYPE_CREATE = 0,
    PQ_TIMERTYPE_CREATE_OPEN,
}PQ_TimerType;

typedef void(^TimerUpdateBlock)(NSInteger);
typedef void(^TimerLastBlock)();

@interface PQ_TimerManager : NSObject
/**
 *  快速创建一个定时器，用type区分要不要一开始就执行
 *
 *  @param type
 *  @param interval
 *  @param repeatInterval
 *  @param block
 *
 *  @return 
 */
+ (instancetype)pq_createTimerWithType:(PQ_TimerType)type updateInterval:(NSTimeInterval)interval repeatInterval:(NSTimeInterval)repeatInterval update:(TimerUpdateBlock)block lastblock:(TimerLastBlock)lastblock;
/**
 *  打开
 */
- (void)pq_open;
/**
 *  关闭
 */
- (void)pq_close;
/**
 *  把时间设置为零
 */
- (void)pq_updateTimeIntervalToZero;
/**
 *  更新现在的时间
 *
 *  @param interval
 */
- (void)pq_updateTimeInterval:(NSTimeInterval)interval;
/**
 *  开机计时
 */
- (void)pq_start;
/**
 *  暂停计时
 */
- (void)pq_pause;
/**
 *  开始计时器
 */
- (void)pq_distantPast;
/**
 *  暂停计时器
 */
- (void)pq_distantFuture;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
@end

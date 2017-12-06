//
//  GLGravityManager.h
//  GLAnimation
//
//  Created by 王凡 on 2017/4/21.
//  Copyright © 2017年 czk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface GLGravityManager : NSObject
@property(nonatomic,strong)CMMotionManager *manager;

/**
 *  时间间隔
 */
@property (nonatomic,assign) float timeInterval;

/**
 *  单例创建方法
 *
 *  @return 单例
 */
+ (GLGravityManager *)sharedGravity;

/**
 *  开始重力加速度
 *
 *  @param completeBlock 重力加速度block，返回xyz
 */
-(void)startAccelerometerUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  开始重力感应
 *
 *  @param completeBlock 重力感应block，返回xyz
 */
-(void)startGyroUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  开始陀螺仪
 *
 *  @param completeBlock 陀螺仪block，返回xyz
 */
-(void)startDeviceMotionUpdatesBlock:(void(^)(float x,float y,float z))completeBlock;

/**
 *  停止
 */
-(void)stop;

@end

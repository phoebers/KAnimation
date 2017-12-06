//
//  GLGravityManager.m
//  GLAnimation
//
//  Created by 王凡 on 2017/4/21.
//  Copyright © 2017年 czk. All rights reserved.
//

#import "GLGravityManager.h"

@implementation GLGravityManager
{
    NSOperationQueue *_queue;
    void(^_completeBlockGyro)(float x,float y,float z);
    void(^_completeBlockAccelerometer)(float x,float y,float z);
    void(^_completeBlockDeviceMotion)(float x,float y,float z);
    void(^_startDeviceBlock)(float x,float y,float z);

}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self configGravity];
    }
    return self;
}

-(void)configGravity
{
    _manager = [[CMMotionManager alloc] init];
    //添加一个队列线程
    _queue = [[NSOperationQueue alloc] init];
}

-(void)startGyroUpdatesBlock:(void(^)(float x,float y,float z))completeBlock
{
    //重力感应
    if (_manager.gyroAvailable)
    {
        //更新速度
        _manager.gyroUpdateInterval = _timeInterval;
        //block
        [_manager startGyroUpdatesToQueue:_queue withHandler:^(CMGyroData *gyroData, NSError *error)
         {
             if (error)
             {
                 //停止重力感应更新
                 [_manager stopGyroUpdates];
                 NSLog(@"%@",[NSString stringWithFormat:@"gryerror:%@",error]);
             }
             else
             {
                 _completeBlockGyro = completeBlock;
                 //回主线程
                 [self performSelectorOnMainThread:@selector(gyroUpdate:) withObject:gyroData waitUntilDone:NO];
             }
         }];
    }
    else
    {
        NSLog(@"设备没有重力感应");
    }
}

-(void)startAccelerometerUpdatesBlock:(void(^)(float x,float y,float z))completeBlock
{
    //加速度
    if (_manager.accelerometerAvailable)
    {
        //更新速度
        _manager.accelerometerUpdateInterval = _timeInterval;
        //block
        [_manager startAccelerometerUpdatesToQueue:_queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             _completeBlockAccelerometer = completeBlock;
             if (error)
             {
                 [_manager stopAccelerometerUpdates];
                 NSLog(@"%@",error.localizedDescription);
             }
             else
             {
                 [self performSelectorOnMainThread:@selector(accelerometerUpdate:) withObject:accelerometerData waitUntilDone:NO];
             }
         }];
    }
    else
    {
        NSLog(@"设备没有加速器");
    }
}

-(void)startDeviceMotionUpdatesBlock:(void(^)(float x,float y,float z))completeBlock
{
    //判断有无陀螺仪
    if (_manager.deviceMotionAvailable)
    {
        //更新
        _manager.deviceMotionUpdateInterval = _timeInterval;
        //block
        [_manager startDeviceMotionUpdatesToQueue:_queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            _completeBlockDeviceMotion = completeBlock;
            if (error)
            {
                [_manager stopAccelerometerUpdates];
                NSLog(@"%@",error.localizedDescription);
            }
            else
            {
                [self performSelectorOnMainThread:@selector(deviceMotionUpdate:) withObject:motion waitUntilDone:NO];
            }
        }];
    }
    else
    {
        NSLog(@"设备没有陀螺仪");
    }
}
-(void)startDeviceBlock:(void(^)(float x,float y,float z))completeBlock
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    if (self.manager.accelerometerAvailable) {
        //设置加速度更新频率为0.1s
        [self.manager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
//            NSString *labletext;
            //如果发生错误 error不为空
            if (error) {
                //停止获取加速度
                [self.manager stopAccelerometerUpdates];
//                labletext = [NSString stringWithFormat:@"获取加速度错误: %@",error];
            }else{
                //分别获获取在xyz轴上的加速度
//                labletext = [NSString stringWithFormat:@"加速度为 \n ------ \n x轴:%.2f\n y轴:%.2f\n z轴:%.2f\n",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
            }
 
        }];
    }else{
        NSLog(@"该设备不支持加速度");
    }
}
-(void)gyroUpdate:(CMGyroData *)gyroData;
{
    //分量
    _completeBlockGyro(gyroData.rotationRate.x,gyroData.rotationRate.y,gyroData.rotationRate.z);
}

-(void)accelerometerUpdate:(CMAccelerometerData *)accelerometerData;
{
    //重力加速度三维分量
    _completeBlockAccelerometer(accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
}

-(void)deviceMotionUpdate:(CMDeviceMotion *)motionData
{
    //陀螺仪
    _completeBlockDeviceMotion(motionData.rotationRate.x,motionData.rotationRate.y,motionData.rotationRate.z);
}

-(void)stop
{
    [_manager stopAccelerometerUpdates];
    [_manager stopGyroUpdates];
    [_manager stopDeviceMotionUpdates];
}


+ (GLGravityManager *)sharedGravity
{
    static GLGravityManager *gravity = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        gravity = [[self alloc] init];
    });
    return gravity;
}

@end

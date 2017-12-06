//
//  ViewController.m
//  KHeaderTableView
//
//  Created by 凡 on 2017/11/21.
//  Copyright © 2017年 fan. All rights reserved.
//

#import "ViewController.h"
#import "GLGuideAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)buttonClick:(id)sender {
    [self jumpGuideAnm];
}

-(void)jumpGuideAnm{
    GLGuideAnimationView *guideAnmView =  [[[NSBundle mainBundle] loadNibNamed:@"GLGuideAnimationView" owner:nil options:nil] firstObject];
    
    guideAnmView.frame = self.view.bounds;
    
    guideAnmView.isFirst = YES;
    
    [self.view addSubview:guideAnmView];
    
    [guideAnmView startAnimate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

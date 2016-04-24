//
//  FinishViewController.m
//  ZTStickerPasterDemo
//
//  Created by ZT on 16/4/24.
//  Copyright © 2016年 ZT. All rights reserved.
//

#import "FinishViewController.h"

@interface FinishViewController ()

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *finishImageView = [[UIImageView alloc]initWithImage:self.finishImage];
    finishImageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:finishImageView];
}



@end

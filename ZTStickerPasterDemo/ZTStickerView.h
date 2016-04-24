//
//  ZTStickerView.h
//  ZTStickerPasterDemo
//
//  Created by ZT on 16/4/24.
//  Copyright © 2016年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTStickerView ;

@protocol ZTStickerViewDelegate <NSObject>
- (void)makeStickerBecomeFirstRespond:(NSInteger)stickerID ;
- (void)removeSticker:(NSInteger)stickerID ;
@end

@interface ZTStickerView : UIView

@property (nonatomic,strong) UIImage *stickerImg ;
@property (nonatomic,strong) UIImageView *imgContentView ;
@property (nonatomic,assign) NSInteger stickerID ;
@property (nonatomic,assign) BOOL isOnFirst ;
@property (nonatomic,weak) id <ZTStickerViewDelegate> delegate ;

- (instancetype)initWithBgView:(UIView *)bgView StickerID:(NSInteger)stickerID Img:(UIImage *)img ;

-(UIImage *)getChangedImage;

@end

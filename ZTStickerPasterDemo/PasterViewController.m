//
//  PasterViewController.m
//  ZTStickerPaster
//
//  Created by ZT on 16/4/24.
//  Copyright © 2016年 ZT. All rights reserved.
//

#import "PasterViewController.h"
#import "ZTStickerView.h"
#import "FinishViewController.h"

@interface PasterViewController()<ZTStickerViewDelegate>

@property(nonatomic,strong)UIImageView *originImageView;
@property (nonatomic,strong) NSMutableArray *stickerArray;
@property (nonatomic,assign) NSInteger newStickerID ;

@end

@implementation PasterViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.title = @"ZTStickerPaster";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.originImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ORIGIN_IMG"]];
    self.originImageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width);
    self.originImageView.userInteractionEnabled = YES;
    self.originImageView.clipsToBounds = YES;
    [self.view addSubview:self.originImageView];
    
    CGFloat btnWidth = (self.view.frame.size.width-5*5)/4;
    CGFloat btnOriginY = self.originImageView.frame.origin.y+self.originImageView.frame.size.height+(self.view.frame.size.height-self.originImageView.frame.origin.y-self.originImageView.frame.size.height-btnWidth)/2;
    
    for (int i = 0; i<4; i++) {
        UIButton *pasterBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        pasterBtn.frame = CGRectMake(5+i*(btnWidth+5), btnOriginY, btnWidth, btnWidth);
        [pasterBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"PASTER_%d",i]] forState:UIControlStateNormal];
        [pasterBtn addTarget:self action:@selector(addSticker:) forControlEvents:UIControlEventTouchUpInside];
        pasterBtn.tag = 1000+i;
        [self.view addSubview:pasterBtn];
    }
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pasterDone:)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    
    self.stickerArray = [@[]mutableCopy];
}

-(NSInteger)newStickerID
{
    _newStickerID++ ;
    
    return _newStickerID ;
}

#pragma mark - 添加贴纸
-(void)addSticker:(UIButton *)sender{
    
    ZTStickerView *stickerView = [[ZTStickerView alloc] initWithBgView:self.originImageView StickerID:self.newStickerID Img:[UIImage imageNamed:[NSString stringWithFormat:@"PASTER_%ld",sender.tag-1000]]] ;
    stickerView.delegate = self ;
    [_stickerArray addObject:stickerView] ;
    [self makeStickerBecomeFirstRespond:stickerView.stickerID];
}

#pragma mark - ZTStickerViewDelegate
- (void)makeStickerBecomeFirstRespond:(NSInteger)stickerID ;
{
    ZTStickerView *firstSticker;
    
    for (int i=0; i<_stickerArray.count; i++) {
        ZTStickerView *stickerView = _stickerArray[i];
        stickerView.isOnFirst = NO;
        if (stickerView.stickerID == stickerID)
        {
            stickerView.isOnFirst = YES ;
            [self.originImageView bringSubviewToFront:stickerView];
            firstSticker = stickerView;
        }
    }
    [_stickerArray removeObject:firstSticker];
    [_stickerArray addObject:firstSticker];
}

- (void)removeSticker:(NSInteger)stickerID
{
    for (ZTStickerView *stickerView in _stickerArray) {
        
        if (stickerView.stickerID == stickerID) {
            [_stickerArray removeObject:stickerView];
            break;
        }
    }
}

#pragma mark - 合成图片
- (UIImage *)pasteStickers:(UIImage*)originImage
{
    UIGraphicsBeginImageContextWithOptions(originImage.size, NO, 0);
    [originImage drawInRect:CGRectMake(0, 0, originImage.size.width, originImage.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (ZTStickerView *stickerView in _stickerArray) {
        
        CGRect rect=[stickerView convertRect:stickerView.imgContentView.frame toView:self.originImageView];
        
        CGSize originalSize = originImage.size;
        CGSize newSize = self.originImageView.frame.size;
        CGFloat ratio =originalSize.width/newSize.width;//图片的显示尺寸和绘制到图形上下文中的实际尺寸的比例
        
        rect.origin.x =rect.origin.x*ratio;
        rect.origin.y =rect.origin.y*ratio;
        rect.size.width = rect.size.width*ratio;
        rect.size.height = rect.size.height*ratio;
        
        CGContextSaveGState(context);
        [[stickerView getChangedImage] drawInRect:rect];
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    
    return image ;
}

-(void)pasterDone:(UIBarButtonItem*)sender{
    
    FinishViewController *finishVC = [[FinishViewController alloc]init];
    finishVC.finishImage = [self pasteStickers:self.originImageView.image];
    [self.navigationController pushViewController:finishVC animated:YES];
}

@end

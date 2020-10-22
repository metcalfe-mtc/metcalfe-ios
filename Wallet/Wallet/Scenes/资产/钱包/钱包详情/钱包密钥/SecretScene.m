//
//  SecretScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "SecretScene.h"
#import <Photos/Photos.h>
@interface SecretScene ()
@property (weak, nonatomic) IBOutlet UIImageView *secretImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *walletSecret;
@property (weak, nonatomic) IBOutlet UIButton *fuzhuButton;
@property (weak, nonatomic) IBOutlet UIView *addressImageView;

@end

@implementation SecretScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"密钥_title", LOCALIZABE, nil)];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:GetStringWithKeyFromTable(@"备份_item", LOCALIZABE, nil) style:UIBarButtonItemStylePlain target:self action:@selector(backUpAction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    self.secretImageView.image = [self codeImageWithString:self.secret size:WIDTH-20/375*103];
    self.walletSecret.text = self.secret;
    [self.saveButton setTitle:GetStringWithKeyFromTable(@"保存至相册_button", LOCALIZABE, nil) forState:UIControlStateNormal];
    [self.fuzhuButton setTitle:GetStringWithKeyFromTable(@"复制密钥_button", LOCALIZABE, nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

-(void)backUpAction{
    
}

//保存至相册
- (IBAction)saveToAlbumAction:(id)sender {
    UIImage * image = [self captureImageFromView:self.addressImageView];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //保存之后需要做的事情
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showString:GetStringWithKeyFromTable(@"密钥已保存至相册_message", LOCALIZABE, nil) delay:1.5];
            });
            
        }
    }];
}

//复制地址
- (IBAction)fuzhiAdressAction:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    board.string = self.walletSecret.text;
    [self showString:GetStringWithKeyFromTable(@"密钥已复制_message", LOCALIZABE, nil) delay:1.5];
}

//截图功能
-(UIImage *)captureImageFromView:(UIView *)view
{
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    UIGraphicsBeginImageContextWithOptions(screenRect.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

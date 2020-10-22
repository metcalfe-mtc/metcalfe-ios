//
//  QRScanningScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/18.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "QRScanningScene.h"
#import "QiCodePreviewView.h"
#import "QiCodeManager.h"
#import "Masonry.h"
@interface QRScanningScene ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) QiCodePreviewView *previewView;
@property (nonatomic, strong) QiCodeManager *codeManager;
@end

@implementation QRScanningScene

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)configUI{
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"扫一扫_扫一扫", LOCALIZABE, nil)];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithTitle:GetStringWithKeyFromTable(@"相册_扫一扫", LOCALIZABE, nil) style:UIBarButtonItemStylePlain target:self action:@selector(photo:)];
    self.navigationItem.rightBarButtonItem = photoItem;
    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    _previewView = [[QiCodePreviewView alloc] initWithFrame:self.view.bounds];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_previewView];
    
    __weak typeof(self) weakSelf = self;
    _codeManager = [[QiCodeManager alloc] initWithPreviewView:_previewView completion:^{
        [weakSelf startScanning];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self startScanning];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_codeManager stopScanning];
}
- (void)startScanning {
    
    __weak typeof(self) weakSelf = self;
    
    [_codeManager startScanningWithCallback:^(NSString * _Nonnull code) {
        if([code containsString:@":"]){
            NSArray *codeArr = [code componentsSeparatedByString:@":"];
            code = codeArr[1];
        }
        //GCD延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.blockQRResult) {
                weakSelf.blockQRResult(code);
            }
        });
        [self.navigationController popViewControllerAnimated:YES];
    } autoStop:YES];
}

#pragma mark - Action functions

- (void)photo:(id)sender {
    [_codeManager presentPhotoLibraryWithRooter:self callback:^(NSString * _Nonnull code) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.blockQRResult) {
            self.blockQRResult(code);
        }
    }];
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

//
//  BaseViewController.m
//  SDChainWallet
//
//  Created by 钱伟成 on 2018/3/15.
//  Copyright © 2018年 HengWei. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"
@interface BaseViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)WKWebView *wkView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置应用的背景色
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
//     不允许 viewController 自动调整，我们自己布局；如果设置为YES，视图会自动下移 64 像素
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    // 自定义后退按钮
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Do any additional setup after loading the view.
}

- (void)setTitleViewWithWhiteTitle:(NSString *)title {
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)setTitleViewWithBlackTitle:(NSString *)title {
    UILabel * label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    label.text = title;
    [label sizeToFit];
    self.navigationItem.titleView = label;
}

- (void)showString:(NSString *_Nullable)str delay:(NSTimeInterval)time{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.detailsLabel.text = [str isEqual:[NSNull null]]?@"":str;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabel.textColor = [UIColor blackColor];
    [self.hud showAnimated:YES];
    [self.view addSubview:self.hud];
    [self.hud hideAnimated:NO afterDelay:time];
}

- (void)showProgressHUDWithString:(NSString *)str{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.detailsLabel.text = str;
    self.hud.detailsLabel.textColor = [UIColor blackColor];
    [self.hud showAnimated:YES];
    [self.view addSubview:self.hud];
}

- (void)showProgressChangeHUDWithString:(NSString *_Nullable)str{
    if(self.hud){
        self.hud.detailsLabel.text = str;
    }
}

- (void)hideProgressHUDString{
    [self.hud hideAnimated:YES];
    [self.hud removeFromSuperview];
}

- (void)generateAddressAction{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}

- (void)generateMasterKeyWithSecretAction:(NSString *)secret{
    self.secret = secret;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}

- (void)generateSecretWithMasterKeyAction:(NSString *_Nullable)masterKey{
    self.masterKey = masterKey;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}

- (void)generateAddressWithSecretAction:(NSString *)secret{
    self.secret = secret;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}

- (void)signActionWithTxjson:(id)txJSON withSecret:(NSString *)secret{
    self.secret = secret;
    self.txJSON = txJSON;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}
- (void)validAddress:(NSString *)address;
{
    self.validAddress = address;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *apphtml = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.wkView loadHTMLString:apphtml baseURL:url];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
{
    
    ///oc  调  js
    
    if (self.generateAddress) {
        NSString *jsString = [NSString stringWithFormat:@"generateAddress()"];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            self.generateAddress(response);
        }];
    }
    
    if (self.generateAddressWithSecret) {
        
        NSString *jsString = [NSString stringWithFormat:@"generateAddressBySecret('%@')",self.secret];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            
            self.generateAddressWithSecret(response);
            
        }];
    }
    
    if(self.generateMasterKeyWithSecret){
        NSString *jsString = [NSString stringWithFormat:@"getMasterKeyBySecret('%@')",self.secret];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            
            self.generateMasterKeyWithSecret(response);
            
        }];
    }
    
    if(self.generateSecretWithMasterKey){
        NSString *jsString = [NSString stringWithFormat:@"getSecretByMasterKey('%@')",self.masterKey];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            
            self.generateSecretWithMasterKey(response);
            
        }];
    }
    
    if (self.signWithTxjsonAndSecret) {
        
        NSString *jsString = [NSString stringWithFormat:@"sign('%@','%@')",self.txJSON,self.secret];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            
            self.signWithTxjsonAndSecret(response);
            
        }];
    }
    
    if (self.isValidAddress) {
        
        NSString *jsString = [NSString stringWithFormat:@"validAddress('%@')",self.validAddress];
        [webView evaluateJavaScript:jsString completionHandler:^(id response, NSError * _Nullable error) {
            self.isValidAddress([response boolValue]);
        }];
        
    }
}
- (WKWebView *)wkView
{
    if (_wkView == nil) {
        _wkView = [[WKWebView alloc] init];
        _wkView.navigationDelegate = self;
        _wkView.UIDelegate = self;
    }
    return _wkView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

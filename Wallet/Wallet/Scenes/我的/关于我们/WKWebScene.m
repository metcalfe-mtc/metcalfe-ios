//
//  WKWebScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/26.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "WKWebScene.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
@interface WKWebScene ()<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,strong)WKWebView *webview;
@property (nonatomic,strong)UIProgressView *progressView;

@end

@implementation WKWebScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webview];
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
    [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    [self.webview addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    // Do any additional setup after loading the view.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _webview) {
        NSLog(@"网页加载进度 = %f",_webview.estimatedProgress);
        self.progressView.progress = _webview.estimatedProgress;
        if (_webview.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }
    else if ([keyPath isEqualToString:@"title"]){//网页title
        if (object == _webview)
        {
            [self setTitleViewWithWhiteTitle:_webview.title];
        }else{
            [super observeValueForKeyPath:keyPath
                                 ofObject:object
                                   change:change
                                  context:context];
        }
    }
    else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}
- (void)dealloc{
    [self.webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webview removeObserver:self forKeyPath:@"title"];
}

- (WKWebView *)webview
{
    if (_webview == nil) {
        _webview = [[WKWebView alloc] init];
    }
    return _webview;
}
- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.tintColor = THEME_COLOR_BULE;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
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

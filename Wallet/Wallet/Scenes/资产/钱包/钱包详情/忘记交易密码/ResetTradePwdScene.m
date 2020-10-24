//
//  ResetTradePwdScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/14.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "ResetTradePwdScene.h"
#import "Masonry.h"
#import "UIButton+EnlargeTouchArea.h"
#import "RequestManager.h"
#import "NSString+COD.h"
#import "QRScanningScene.h"
#import "NSString+AES.h"

@interface ResetTradePwdScene ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *keytext;
@property (nonatomic,strong)UITextField *tradepwd;
@property (nonatomic,strong)UITextField *checkpwd;
@property (nonatomic,strong)UIView *line1;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UIButton *keytextButton;
@property (nonatomic,strong)UIButton *tradepwdButton;
@property (nonatomic,strong)UIButton *checkpwdButton;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UILabel *tipsLabel;
@end

@implementation ResetTradePwdScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"重设交易密码_message", LOCALIZABE, nil)];
    self.view.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.keytext];
    [self.backgroundView addSubview:self.tradepwd];
    [self.backgroundView addSubview:self.checkpwd];
    [self.backgroundView addSubview:self.line1];
    [self.backgroundView addSubview:self.line2];
    [self.backgroundView addSubview:self.keytextButton];
    [self.backgroundView addSubview:self.tradepwdButton];
    [self.backgroundView addSubview:self.checkpwdButton];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.confirmButton];
    
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width*165/375.0);
    }];
    
    [self.keytext mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView).offset(45);
        make.right.equalTo(self.backgroundView).offset(-70);
        make.top.equalTo(self.backgroundView);
        make.height.equalTo(self.backgroundView.mas_height).multipliedBy(1/3.0);
    }];
    [self.tradepwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.keytext);
        make.top.equalTo(self.keytext.mas_bottom);
        make.height.equalTo(self.keytext);
    }];
    [self.checkpwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tradepwd);
        make.top.equalTo(self.tradepwd.mas_bottom);
        make.height.equalTo(self.tradepwd);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.keytext);
        make.right.equalTo(self.backgroundView).offset(-45);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.keytext.mas_bottom).offset(1);
        
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.line1);
        make.top.equalTo(self.tradepwd.mas_bottom).offset(1);
    }];
    
    [self.keytextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line1);
        make.centerY.equalTo(self.keytext);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    [self.tradepwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.tradepwd);
        make.width.height.equalTo(self.keytextButton);
    }];
    [self.checkpwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradepwdButton);
        make.centerY.equalTo(self.checkpwd);
        make.width.height.equalTo(self.tradepwdButton);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.top.equalTo(self.backgroundView.mas_bottom).offset(23);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(38);
        make.height.mas_equalTo(40);
    }];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gusture];
}
-(void)hideKeyBoard{
    [self.keytext resignFirstResponder];
    [self.tradepwd resignFirstResponder];
    [self.checkpwd resignFirstResponder];
}

- (void)textFieldTextDidChange:(NSNotification *)noty
{
    if (self.keytext.text.length>0 && self.tradepwd.text.length>=8 && self.tradepwd.text.length<=16 && self.checkpwd.text.length>0) {
        
        self.confirmButton.backgroundColor = CLICKABLE_COLOR;
        self.confirmButton.enabled = YES;
        
    }else
    {
        self.confirmButton.backgroundColor = UNCLICK_COLOR;
        self.confirmButton.enabled = NO;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if(textField == self.keytext){
        NSString *regex = @"[\u4e00-\u9fa5]{0,}$"; // 中文
        // 2、拼接谓词
        NSPredicate *predicateRe1 = [NSPredicate predicateWithFormat:@"self matches %@", regex];
        // 3、匹配字符串
        return ![predicateRe1 evaluateWithObject:string];
    }else{
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PWDSTRENGTH] invertedSet];
        NSString *text = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:text];
    }
    return YES;
    
}
- (void)onPrginalpwd:(UIButton *)button
{
   // button.selected = !button.selected;
    QRScanningScene *vc = [[QRScanningScene alloc] init];
    
    vc.blockQRResult = ^(NSString * secret) {
        
        self.keytext.text = secret;
        if (self.keytext.text.length>0 && self.tradepwd.text.length>=6 && self.tradepwd.text.length<=16 && self.checkpwd.text.length>0) {
            
            self.confirmButton.backgroundColor = CLICKABLE_COLOR;
            self.confirmButton.enabled = YES;
            
        }else
        {
            self.confirmButton.backgroundColor = UNCLICK_COLOR;
            self.confirmButton.enabled = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)ontradepwd:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.tradepwd.secureTextEntry = NO;
    }else
    {
        self.tradepwd.secureTextEntry = YES;
    }
    
}
- (void)onCheckowd:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        
        self.checkpwd.secureTextEntry = NO;
    }else
    {
        self.checkpwd.secureTextEntry = YES;
    }
}
- (void)onConfirm
{
    
    
    [self hideKeyBoard];
    __weak typeof(self)weakself= self;
    self.generateAddressWithSecret = ^(id  _Nullable responseObject) {
//        NSDictionary *dict = responseObject;
        if(![responseObject isKindOfClass:[NSDictionary class]] && ![responseObject isKindOfClass:[NSMutableDictionary class]]){
            NSString *title = GetStringWithKeyFromTable(@"无效密钥_message", LOCALIZABE, nil);
            [weakself hideProgressHUDString];
            [weakself showString:title delay:1.5];
        }else{
            [weakself hideProgressHUDString];
            if (![weakself.tradepwd.text isEqualToString:weakself.checkpwd.text]) {
                [weakself showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
                return;
            }
            NSDictionary *wallet = responseObject;
            if([wallet[@"address"] isEqualToString:weakself.model.account]){
                NSString *secretKey = [weakself.keytext.text AES128EncryptWithkey:weakself.tradepwd.text];
                if(weakself.resetBlock){
                    weakself.resetBlock(secretKey);
                }
                    [weakself.navigationController popViewControllerAnimated:YES];

            }else{
                NSString *title = GetStringWithKeyFromTable(@"无效密钥_message", LOCALIZABE, nil);
                [weakself hideProgressHUDString];
                [weakself showString:title delay:1.5];
            }
            
            
        }
    };
    [self generateAddressWithSecretAction:self.keytext.text];

}

- (UITextField *)keytext
{
    if (_keytext == nil) {
        _keytext = [[UITextField alloc] init];
        _keytext.placeholder = GetStringWithKeyFromTable(@"输入密钥_message", LOCALIZABE, nil);
        _keytext.font = [UIFont systemFontOfSize:14];
        _keytext.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _keytext;
}
- (UITextField *)tradepwd
{
    if (_tradepwd == nil) {
        _tradepwd = [[UITextField alloc] init];
        _tradepwd.placeholder = GetStringWithKeyFromTable(@"输入8~16位新密码_message", LOCALIZABE, nil);
        _tradepwd.font = [UIFont systemFontOfSize:14];
        _tradepwd.secureTextEntry = YES;
        _tradepwd.delegate = self;
        _tradepwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _tradepwd;
}
- (UITextField *)checkpwd
{
    if (_checkpwd == nil) {
        _checkpwd = [[UITextField alloc] init];
        _checkpwd.placeholder = GetStringWithKeyFromTable(@"再次确认新密码_message", LOCALIZABE, nil);
        _checkpwd.font = [UIFont systemFontOfSize:14];
        _checkpwd.secureTextEntry = YES;
        _checkpwd.delegate = self;
        _checkpwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _checkpwd;
}
- (UIView *)line1
{
    if (_line1 == nil) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = RGB(230, 230, 230);
    }
    return _line1;
}
- (UIView *)line2
{
    if (_line2 == nil) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = RGB(230, 230, 230);
    }
    return _line2;
}
- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _backgroundView;
}
- (UIButton *)keytextButton
{
    if (_keytextButton == nil) {
        _keytextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_keytextButton setImage:[UIImage imageNamed:@"ic_scan_grey"] forState:UIControlStateNormal];
        [_keytextButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_keytextButton addTarget:self action:@selector(onPrginalpwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keytextButton;
}
- (UIButton *)tradepwdButton
{
    if (_tradepwdButton == nil) {
        _tradepwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tradepwdButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_tradepwdButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:UIControlStateSelected];
        [_tradepwdButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_tradepwdButton addTarget:self action:@selector(ontradepwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradepwdButton;
}
- (UIButton *)checkpwdButton
{
    if (_checkpwdButton == nil) {
        _checkpwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkpwdButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_checkpwdButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:UIControlStateSelected];
        [_checkpwdButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_checkpwdButton addTarget:self action:@selector(onCheckowd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkpwdButton;
}
- (UILabel *)tipsLabel
{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = GetStringWithKeyFromTable(@"支持8~16位_text", LOCALIZABE, nil);
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = RGB(140, 140, 140);
        _tipsLabel.font = [UIFont systemFontOfSize:11];
    }
    return _tipsLabel;
}
- (UIButton *)confirmButton
{
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = UNCLICK_COLOR;
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmButton setTitle:GetStringWithKeyFromTable(@"保存_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        _confirmButton.enabled = NO;
        [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end


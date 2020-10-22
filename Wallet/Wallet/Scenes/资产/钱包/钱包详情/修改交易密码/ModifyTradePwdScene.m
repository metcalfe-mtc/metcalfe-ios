//
//  ModifyTradePwdScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/14.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "ModifyTradePwdScene.h"
#import "Masonry.h"
#import "UIButton+EnlargeTouchArea.h"
#import "RequestManager.h"
#import "NSString+AES.h"
#import "NSString+COD.h"

@interface ModifyTradePwdScene ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *orginalpwd;
@property (nonatomic,strong)UITextField *tradepwd;
@property (nonatomic,strong)UITextField *checkpwd;
@property (nonatomic,strong)UIView *line1;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UIButton *orginalpwdButton;
@property (nonatomic,strong)UIButton *tradepwdButton;
@property (nonatomic,strong)UIButton *checkpwdButton;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UILabel *tipsLabel;
@end

@implementation ModifyTradePwdScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView{
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"修改交易密码_title", LOCALIZABE, nil)];
    self.view.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.orginalpwd];
    [self.backgroundView addSubview:self.tradepwd];
    [self.backgroundView addSubview:self.checkpwd];
    [self.backgroundView addSubview:self.line1];
    [self.backgroundView addSubview:self.line2];
    [self.backgroundView addSubview:self.orginalpwdButton];
    [self.backgroundView addSubview:self.tradepwdButton];
    [self.backgroundView addSubview:self.checkpwdButton];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.confirmButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(16);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width*165/375.0);
    }];
    
    [self.orginalpwd mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView).offset(45);
        make.right.equalTo(self.backgroundView).offset(-80);
        make.top.equalTo(self.backgroundView);
        make.height.equalTo(self.backgroundView.mas_height).multipliedBy(1/3.0);
    }];
    [self.tradepwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orginalpwd);
        make.top.equalTo(self.orginalpwd.mas_bottom);
        make.height.equalTo(self.orginalpwd);
    }];
    [self.checkpwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tradepwd);
        make.top.equalTo(self.tradepwd.mas_bottom);
        make.height.equalTo(self.tradepwd);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.orginalpwd);
        make.right.equalTo(self.backgroundView).offset(-45);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.orginalpwd.mas_bottom).offset(1);
        
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.line1);
        make.top.equalTo(self.tradepwd.mas_bottom).offset(1);
    }];
    
    [self.orginalpwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line1);
        make.centerY.equalTo(self.orginalpwd);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    [self.tradepwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.tradepwd);
        make.width.height.equalTo(self.orginalpwdButton);
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
    [self.orginalpwd resignFirstResponder];
    [self.tradepwd resignFirstResponder];
    [self.checkpwd resignFirstResponder];
}

- (void)textFieldTextDidChange:(NSNotification *)noty
{
    if (self.orginalpwd.text.length>0 && self.tradepwd.text.length>=8&&self.tradepwd.text.length<=16 && self.checkpwd.text.length>0) {
        
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
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PWDSTRENGTH] invertedSet];
        NSString *text = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:text];
}
- (void)onPrginalpwd:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.orginalpwd.secureTextEntry = NO;
    }else
    {
        self.orginalpwd.secureTextEntry = YES;

    }
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
    if (![self.model.secret AES128DecryptWithkey:self.orginalpwd.text]) {
        //        int a = arc4random() % 100000;
        //        uploadSecret = [NSString stringWithFormat:@"%06d", a];
        [self showString:GetStringWithKeyFromTable(@"原交易密码错误_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if (![self.tradepwd.text isEqualToString:self.checkpwd.text]) {
        
        [self showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    NSString *uploadSecret = [[self.model.secret AES128DecryptWithkey:self.orginalpwd.text] AES128EncryptWithkey:self.tradepwd.text];
    if(self.modifyblock){
        self.modifyblock(uploadSecret);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UITextField *)orginalpwd
{
    if (_orginalpwd == nil) {
        _orginalpwd = [[UITextField alloc] init];
        _orginalpwd.placeholder = GetStringWithKeyFromTable(@"输入原密码_placeHolder", LOCALIZABE, nil);
        _orginalpwd.secureTextEntry = YES;
        _orginalpwd.font = [UIFont systemFontOfSize:14];
        _orginalpwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _orginalpwd;
}
- (UITextField *)tradepwd
{
    if (_tradepwd == nil) {
        _tradepwd = [[UITextField alloc] init];
        _tradepwd.placeholder = GetStringWithKeyFromTable(@"输入8~16位新密码_message", LOCALIZABE, nil);
        _tradepwd.secureTextEntry = YES;
        _tradepwd.font = [UIFont systemFontOfSize:14];
        _tradepwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _tradepwd.delegate = self;
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
        _checkpwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _checkpwd.delegate = self;
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
- (UIButton *)orginalpwdButton
{
    if (_orginalpwdButton == nil) {
        _orginalpwdButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_orginalpwdButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_orginalpwdButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:UIControlStateSelected];
        [_orginalpwdButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_orginalpwdButton addTarget:self action:@selector(onPrginalpwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orginalpwdButton;
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
        _confirmButton.enabled = NO;
        [_confirmButton setTitle:GetStringWithKeyFromTable(@"保存_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end


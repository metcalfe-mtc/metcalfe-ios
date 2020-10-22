//
//  CreateWalletScene.m
//  Wallet
//
//  Created by zzp-Mac on 2019/3/7.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "CreateWalletScene.h"
#import "Masonry.h"
#import "UIImage+EasyExtend.h"
#import "RequestManager.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "WordsBriefScene.h"
#import "BaseNavigationController.h"
#import "TabbarController.h"

@interface CreateWalletScene ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *walletName;
@property (nonatomic,strong)UITextField *tradepwd;
@property (nonatomic,strong)UITextField *checkpwd;
@property (nonatomic,strong)UIView *line1;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UIButton *walletNameButton;
@property (nonatomic,strong)UIButton *tradepwdButton;
@property (nonatomic,strong)UIButton *checkpwdButton;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UIView *backgroundView;
@property (nonatomic,strong)UILabel *tipsLabel;

@property (nonatomic,strong)NSString *secretString;
@property (nonatomic,strong)NSString *accountString;
@end

@implementation CreateWalletScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"创建钱包_title", LOCALIZABE, nil)];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)hideKeyBoard{
    [self.walletName resignFirstResponder];
    [self.tradepwd resignFirstResponder];
    [self.checkpwd resignFirstResponder];
}

- (void)configUI
{
    self.view.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.walletName];
    [self.backgroundView addSubview:self.tradepwd];
    [self.backgroundView addSubview:self.checkpwd];
    [self.backgroundView addSubview:self.line1];
    [self.backgroundView addSubview:self.line2];
    [self.backgroundView addSubview:self.walletNameButton];
    self.walletNameButton.hidden = YES;
    [self.backgroundView addSubview:self.tradepwdButton];
    [self.backgroundView addSubview:self.checkpwdButton];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.confirmButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditing:) name:UITextFieldTextDidChangeNotification object:nil];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gusture];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_topMargin).offset(10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.width*145/375.0);
    }];
    
    [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backgroundView).offset(15);
        make.right.equalTo(self.backgroundView).offset(-50);
        make.top.equalTo(self.backgroundView);
        make.height.equalTo(self.backgroundView.mas_height).multipliedBy(1/3.0);
    }];
    [self.tradepwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.walletName);
        make.top.equalTo(self.walletName.mas_bottom);
        make.height.equalTo(self.walletName);
    }];
    [self.checkpwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tradepwd);
        make.top.equalTo(self.tradepwd.mas_bottom);
        make.height.equalTo(self.tradepwd);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.walletName);
        make.right.equalTo(self.backgroundView).offset(-15);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.walletName.mas_bottom).offset(1);
        
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.line1);
        make.top.equalTo(self.tradepwd.mas_bottom).offset(1);
    }];
    
    [self.walletNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line1);
        make.centerY.equalTo(self.walletName);
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(16);
    }];
    [self.tradepwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line2);
        make.centerY.equalTo(self.tradepwd);
        make.width.height.equalTo(self.walletNameButton);
    }];
    [self.checkpwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tradepwdButton);
        make.centerY.equalTo(self.checkpwd);
        make.width.height.equalTo(self.tradepwdButton);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.backgroundView.mas_bottom).offset(23);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(45);
        make.right.equalTo(self.view).offset(-45);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(38);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)onPrginalpwd:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)ontradepwd:(UIButton *)button{
    button.selected = !button.selected;
    
    if (button.selected) {
       
        self.tradepwd.secureTextEntry = NO;
    }else
    {
        self.tradepwd.secureTextEntry = YES;

    }
}

- (void)onCheckowd:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        
        self.checkpwd.secureTextEntry = NO;
    }else
    {
        self.checkpwd.secureTextEntry = YES;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == self.walletName){
        if(self.walletName.text.length > 15){
            [self showString:GetStringWithKeyFromTable(@"钱包名称不能超过15位_message", LOCALIZABE, nil) delay:1.5];
        }
    }
}

-(void)checkConfirmButtonEnable{
    if (self.walletName.text.length > 0 && self.tradepwd.text.length >= 8 && self.tradepwd.text.length <= 16 && self.checkpwd.text.length >= 8 && self.checkpwd.text.length <= 16) {
        self.confirmButton.backgroundColor = CLICKABLE_COLOR;
        self.confirmButton.enabled = YES;
    }else{
        self.confirmButton.enabled = NO;
        self.confirmButton.backgroundColor = UNCLICK_COLOR;
    }
}

- (void)textFieldEditing:(NSNotification *)info{
    [self checkConfirmButtonEnable];
   
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField != self.walletName) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PWDSTRENGTH] invertedSet];
        NSString *text = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:text];
    }
    
    return YES;

}
- (void)onConfirm{
    self.confirmButton.enabled = NO;
    [self hideKeyBoard];
    if(self.walletName.text.length == 0){
        [self showString:GetStringWithKeyFromTable(@"输入钱包名称_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.walletName.text.length > 15){
        [self showString:GetStringWithKeyFromTable(@"钱包名称不能超过15位_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.tradepwd.text.length == 0){
        [self showString:GetStringWithKeyFromTable(@"交易密码不能为空_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.tradepwd.text.length < 8){
        [self showString:GetStringWithKeyFromTable(@"密码长度至少六位_brief", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.checkpwd.text.length == 0){
        [self showString:GetStringWithKeyFromTable(@"确认交易密码_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if (![self.tradepwd.text isEqualToString:self.checkpwd.text]) {
        [self showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    [self createAction];
}

-(void)createAction{
    __weak CreateWalletScene *weakSelf = self;
    [self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
    self.generateAddress = ^(id  _Nullable responseObject) {
        [weakSelf hideProgressHUDString];
        weakSelf.secretString = responseObject[@"secret"];
        weakSelf.accountString = responseObject[@"address"];
        NSString *secretKey = [weakSelf.secretString AES128EncryptWithkey:weakSelf.tradepwd.text];
        LocalWallet *model = [[LocalWallet alloc] init];
        [model configureWithAccount:weakSelf.accountString name:weakSelf.walletName.text secret:secretKey];
        WordsBriefScene *scene = [[WordsBriefScene alloc] init];
        scene.wallet = model;
        scene.uselessStr = weakSelf.secretString;
        [weakSelf.navigationController pushViewController:scene animated:YES];
    };
    [self generateAddressAction];


//    TabbarController * tabBarController = [[TabbarController alloc] init];
//    [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UITextField *)walletName{
    if (_walletName == nil) {
        _walletName = [[UITextField alloc] init];
        _walletName.placeholder = GetStringWithKeyFromTable(@"输入钱包名称_placeHolder", LOCALIZABE, nil);
        _walletName.font = [UIFont systemFontOfSize:14];
        _walletName.delegate = self;
        _walletName.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _walletName;
}
- (UITextField *)tradepwd{
    if (_tradepwd == nil) {
        _tradepwd = [[UITextField alloc] init];
        _tradepwd.placeholder = GetStringWithKeyFromTable(@"输入交易密码_placeHolder", LOCALIZABE, nil);
        _tradepwd.font = [UIFont systemFontOfSize:14];
        _tradepwd.secureTextEntry = YES;
        _tradepwd.delegate = self;
        _tradepwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _tradepwd;
}
- (UITextField *)checkpwd{
    if (_checkpwd == nil) {
        _checkpwd = [[UITextField alloc] init];
        _checkpwd.placeholder = GetStringWithKeyFromTable(@"确认交易密码_placeHolder", LOCALIZABE, nil);
        _checkpwd.secureTextEntry = YES;
        _checkpwd.font = [UIFont systemFontOfSize:14];
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
        _backgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundView;
}
- (UIButton *)walletNameButton
{
    if (_walletNameButton == nil) {
        _walletNameButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_walletNameButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_walletNameButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:UIControlStateSelected];
        [_walletNameButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
        [_walletNameButton addTarget:self action:@selector(onPrginalpwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _walletNameButton;
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
        _tipsLabel.text = GetStringWithKeyFromTable(@"支持8~16位_brief", LOCALIZABE, nil);
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
        _confirmButton.enabled = NO;
        _confirmButton.layer.cornerRadius = 20;
        [_confirmButton setTitle:GetStringWithKeyFromTable(@"确定_button", LOCALIZABE, nil) forState:UIControlStateNormal];
//        _confirmButton.timeInterval = 5;
        [_confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end

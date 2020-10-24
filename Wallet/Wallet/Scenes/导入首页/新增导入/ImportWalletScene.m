//
//  ImportWalletScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/7.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "ImportWalletScene.h"
#import "Masonry.h"
#import "UIImage+EasyExtend.h"
#import "NSString+AES.h"
#import "RequestManager.h"
#import "NSString+COD.h"
#import "QRScanningScene.h"
#import "NSString+format.h"

@interface ImportWalletScene ()<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *tipsLabel;
@property (nonatomic,strong)UILabel *tittleLabel;
@property (nonatomic,strong)UIView *backView1;
@property (nonatomic,strong)UITextField *secretTextField;
@property (nonatomic,strong)UIView *line1;
@property (nonatomic,strong)UIButton *QRButton;
@property (nonatomic,strong)UIView *backView2;
@property (nonatomic,strong)UITextField *tradePwdTextField;
@property (nonatomic,strong)UIButton *tradePwdButton;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UITextField *checkPwdTextField;
@property (nonatomic,strong)UIButton *checkPwdButton;
@property (nonatomic,strong)UIView *line3;
@property (nonatomic,strong)UIButton *comfirButton;
@property (nonatomic,strong)UILabel *tipsLabel2;
@property (nonatomic,strong)NSString *accountString;
@end

@implementation ImportWalletScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)hideKeyBoard{
    [self.secretTextField resignFirstResponder];
    [self.tradePwdTextField resignFirstResponder];
    [self.checkPwdTextField resignFirstResponder];
}

- (void)setupView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    self.view.backgroundColor = RGB(243, 243, 243);
    [self.view addSubview:self.backView1];
    [self.backView1 addSubview:self.secretTextField];
    [self.backView1 addSubview:self.QRButton];
    [self.backView1 addSubview:self.line1];
    [self.backView1 addSubview:self.self.tipsLabel];
    
    [self.view addSubview:self.backView2];
    [self.backView2 addSubview:self.tittleLabel];
    [self.backView2 addSubview:self.tradePwdTextField];
    [self.backView2 addSubview:self.tradePwdButton];
    [self.backView2 addSubview:self.line2];
    [self.backView2 addSubview:self.checkPwdTextField];
    [self.backView2 addSubview:self.checkPwdButton];
    [self.backView2 addSubview:self.line3];
    [self.backView2 addSubview:self.tipsLabel2];
    [self.view addSubview:self.comfirButton];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gusture];

    [self.backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(74);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView2).offset(15);
        make.right.equalTo(self.backView2).offset(-15);
        make.height.mas_equalTo(0.8);
        make.top.equalTo(self.backView1.mas_top).offset(45);
    }];
    [self.secretTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.line1);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(40);
    }];
    [self.QRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView1).offset(-17);
        make.centerY.equalTo(self.secretTextField.mas_centerY);
        make.height.with.mas_equalTo(22);
    }];

    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1).offset(5);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.backView1);
        make.top.equalTo(self.backView1.mas_bottom).offset(15);
        make.height.mas_equalTo(170);
    }];
    [self.tittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.backView2.mas_top).offset(15);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView2).offset(15);
        make.right.equalTo(self.backView2).offset(-15);
        make.height.mas_equalTo(0.8);
        make.top.mas_equalTo(75);
    }];
    [self.tradePwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.secretTextField);
        make.bottom.equalTo(self.line2.mas_top);
        make.height.mas_equalTo(40);
    }];
    [self.tradePwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.with.equalTo(self.QRButton);
        make.centerY.equalTo(self.tradePwdTextField);
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView2).offset(15);
        make.right.equalTo(self.backView2).offset(-15);
        make.height.mas_equalTo(0.8);
        make.top.equalTo(self.line2.mas_bottom).offset(58);
    }];
    [self.checkPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.tradePwdTextField);
        make.bottom.equalTo(self.line3.mas_top);
    }];
    [self.checkPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.with.height.equalTo(self.tradePwdButton);
        make.centerY.equalTo(self.checkPwdTextField);
    }];
    [self.tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tipsLabel);
        make.top.equalTo(self.line3.mas_bottom).offset(5);
    }];
    [self.comfirButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView2.mas_bottom).offset(25);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(40);
    }];
}
- (void)textFieldChange:(NSNotification *)noty
{
    if (self.secretTextField.text.length>0 && self.tradePwdTextField.text.length>0 && self.checkPwdTextField.text.length>0)  {
        self.comfirButton.backgroundColor = CLICKABLE_COLOR;
        self.comfirButton.enabled = YES;
    }else
    {
        self.comfirButton.backgroundColor = UNCLICK_COLOR;
        self.comfirButton.enabled = NO;
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
//    if (textField != self.nameTextField) {

        if(textField == self.secretTextField){

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
//    }
    return YES;

}
- (void)onConfirm{
    [self hideKeyBoard];
    if (![self.tradePwdTextField.text isEqualToString:self.checkPwdTextField.text]) {
        [self showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.tradePwdTextField.text.length <8){
        [self showString:GetStringWithKeyFromTable(@"密码长度至少6位_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    __weak ImportWalletScene *weakSelf = self;
    [self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
    self.generateAddressWithSecret = ^(id  _Nullable responseObject) {
        if(![responseObject isKindOfClass:[NSDictionary class]]){
            NSString *title = GetStringWithKeyFromTable(@"无效密钥_message", LOCALIZABE, nil);
            [weakSelf hideProgressHUDString];
            [weakSelf showString:title delay:1.5];
        }else{
            if (![weakSelf.tradePwdTextField.text isEqualToString:weakSelf.checkPwdTextField.text]) {
                [weakSelf hideProgressHUDString];
                [weakSelf showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
                return;
            }
            [weakSelf hideProgressHUDString];
            weakSelf.accountString = responseObject[@"address"];
            NSString *secretKey = [weakSelf.secretTextField.text AES128EncryptWithkey:weakSelf.tradePwdTextField.text];
            [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
            NSArray *currentList = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@' ",weakSelf.accountString]];
            if(currentList.count > 0){
                [weakSelf showString:GetStringWithKeyFromTable(@"钱包地址已存在_message", LOCALIZABE, nil) delay:1.5];
                [UserManager setDefaultWalletWithWallet:currentList[0]];
            }else{
                LocalWallet *model = [[LocalWallet alloc] init];
                [model configureWithAccount:weakSelf.accountString name:[NSString stringWithFormat:@"%@ %ld",GetStringWithKeyFromTable(@"新钱包_text", LOCALIZABE, nil),[LocalWallet findAll].count+1] secret:secretKey];
                [UserManager setDefaultWalletWithWallet:model];
            }
            if(weakSelf.secretImportSuccessBlock){
                weakSelf.secretImportSuccessBlock();
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
            return;
        }
    };
    NSString *secret = [NSString removeSpaceAndNewline:self.secretTextField.text];
    [self generateAddressWithSecretAction:secret];
}


- (void)onTradeButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.tradePwdTextField.secureTextEntry = NO;
    }else{
        self.tradePwdTextField.secureTextEntry = YES;
    }
}

- (void)onCheckButton:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.checkPwdTextField.secureTextEntry = NO;
    }else{
        self.checkPwdTextField.secureTextEntry = YES;
    }
}

- (void)onQRButton{
    QRScanningScene *vc = [[QRScanningScene alloc] init];
    vc.blockQRResult = ^(NSString * _Nonnull result) {
        self.secretTextField.text = result;
        if (self.secretTextField.text.length>0 && self.tradePwdTextField.text.length>0 && self.checkPwdTextField.text.length>0)  {
            self.comfirButton.backgroundColor = THEME_COLOR_BULE;
            self.comfirButton.enabled = YES;
        }else{
            self.comfirButton.backgroundColor = UNCLICK_COLOR;
            self.comfirButton.enabled = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (UILabel *)tipsLabel{
    if (_tipsLabel == nil) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont systemFontOfSize:10];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.textColor = RGB(89, 89, 89);
        _tipsLabel.text = GetStringWithKeyFromTable(@"仅可使用智能流量链生态的密钥_brief", LOCALIZABE, nil);
    }
    return _tipsLabel;
}

- (UIView *)backView1{
    if (_backView1 == nil) {
        _backView1 = [[UIView alloc] init];
        _backView1.backgroundColor = [UIColor whiteColor];
    }
    return _backView1;
}

- (UITextField *)secretTextField
{
    if (_secretTextField == nil) {
        _secretTextField = [[UITextField alloc] init];
        _secretTextField.delegate = self;
        _secretTextField.font = [UIFont systemFontOfSize:14];
        _secretTextField.placeholder = GetStringWithKeyFromTable(@"输入密钥_placeHolder", LOCALIZABE, nil);
        _secretTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _secretTextField;
}
- (UIButton *)QRButton
{
    if (_QRButton == nil) {
        _QRButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_QRButton setImage:[UIImage imageNamed:@"ic_scan_grey"] forState:UIControlStateNormal];
        [_QRButton addTarget:self action:@selector(onQRButton) forControlEvents:UIControlEventTouchUpInside];
        [_QRButton setEnlargeEdgeWithTop:17 right:17 bottom:17 left:17];
    }
    return _QRButton;
}
- (UILabel *)tittleLabel
{
    if (_tittleLabel == nil) {
        _tittleLabel = [[UILabel alloc] init];
        _tittleLabel.font = [UIFont systemFontOfSize:15];
        _tittleLabel.textColor =RGB(89, 89, 89);
        _tittleLabel.text = GetStringWithKeyFromTable(@"设置交易密码_title", LOCALIZABE, nil);
    }
    return _tittleLabel;
}


- (UIView *)backView2
{
    if (_backView2 == nil) {
        _backView2 = [[UIView alloc] init];
        _backView2.backgroundColor = [UIColor whiteColor];
    }
    return _backView2;
}
- (UITextField *)tradePwdTextField
{
    if (_tradePwdTextField == nil) {
        _tradePwdTextField = [[UITextField alloc] init];
        _tradePwdTextField.font = [UIFont systemFontOfSize:14];
        _tradePwdTextField.placeholder = GetStringWithKeyFromTable(@"输入交易密码_placeHolder", LOCALIZABE, nil);
        _tradePwdTextField.secureTextEntry = YES;
        _tradePwdTextField.delegate = self;
        _tradePwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _tradePwdTextField;
}
- (UIButton *)tradePwdButton{
    if (_tradePwdButton== nil) {
        _tradePwdButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_tradePwdButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_tradePwdButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:(UIControlStateSelected)];
        [_tradePwdButton setEnlargeEdgeWithTop:17 right:17 bottom:17 left:17];
        [_tradePwdButton addTarget:self action:@selector(onTradeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradePwdButton;
}
- (UIView *)line1{
    if (_line1 == nil) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = LINE_COLOR;
    }
    return _line1;
}
- (UIView *)line2{
    if (_line2 == nil) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = LINE_COLOR;
    }
    return _line2;
}
- (UIView *)line3{
    if (_line3 == nil) {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = LINE_COLOR;
    }
    return _line3;
}
- (UITextField *)checkPwdTextField{
    if (_checkPwdTextField == nil) {
        _checkPwdTextField = [[UITextField alloc] init];
        _checkPwdTextField.font = [UIFont systemFontOfSize:14];
        _checkPwdTextField.placeholder = GetStringWithKeyFromTable(@"确认交易密码_placeHolder", LOCALIZABE, nil);
        _checkPwdTextField.secureTextEntry = YES;
        _checkPwdTextField.delegate = self;
        _checkPwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _checkPwdTextField;
}
- (UIButton *)checkPwdButton{
    if (_checkPwdButton== nil) {
        _checkPwdButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_checkPwdButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_checkPwdButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:(UIControlStateSelected)];
        [_checkPwdButton setEnlargeEdgeWithTop:17 right:17 bottom:17 left:17];
        [_checkPwdButton addTarget:self action:@selector(onCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkPwdButton;
}
- (UILabel *)tipsLabel2{
    if (_tipsLabel2 == nil) {
        _tipsLabel2 = [[UILabel alloc] init];
        _tipsLabel2.font = [UIFont systemFontOfSize:10];
        _tipsLabel2.textColor = RGB(89, 89, 89);;
        _tipsLabel2.numberOfLines = 0;
        _tipsLabel2.textAlignment = NSTextAlignmentCenter;
        _tipsLabel2.text = GetStringWithKeyFromTable(@"支持8~16位_brief", LOCALIZABE, nil);
    }
    return _tipsLabel2;
}
- (UIButton *)comfirButton{
    if (_comfirButton == nil) {
        _comfirButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _comfirButton.backgroundColor = UNCLICK_COLOR;
        [_comfirButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _comfirButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_comfirButton setTitle:GetStringWithKeyFromTable(@"确定_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        _comfirButton.layer.masksToBounds = YES;
        _comfirButton.enabled = NO;
        _comfirButton.layer.cornerRadius = 20;
//        _comfirButton.timeInterval = 5;
        [_comfirButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirButton;
}
@end

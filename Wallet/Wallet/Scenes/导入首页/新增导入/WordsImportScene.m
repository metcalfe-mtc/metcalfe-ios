//
//  WordsImportScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/16.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "WordsImportScene.h"
#import "Masonry.h"
#import "UIImage+EasyExtend.h"
#import "NSString+AES.h"
#import "RequestManager.h"
#import "NSString+COD.h"
#import "UITextView+PlaceHolder.h"
@interface WordsImportScene ()<UITextFieldDelegate>
@property (nonatomic,strong)UIView *backView1;
@property (nonatomic,strong)UITextView *wordsTextView;
@property (nonatomic,strong)UIView *backView2;
@property (nonatomic,strong)UILabel *tittleLabel;
@property (nonatomic,strong)UITextField *tradePwdTextField;
@property (nonatomic,strong)UIButton *tradePwdButton;
@property (nonatomic,strong)UIView *line2;
@property (nonatomic,strong)UITextField *checkPwdTextField;
@property (nonatomic,strong)UIButton *checkPwdButton;
@property (nonatomic,strong)UIView *line3;
@property (nonatomic,strong)UIButton *comfirButton;
@property (nonatomic,strong)UILabel *tipsLabel2;
@property (nonatomic,assign)BOOL getSecret;
@end

@implementation WordsImportScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)hideKeyBoard{
    [self.wordsTextView resignFirstResponder];
    [self.tradePwdTextField resignFirstResponder];
    [self.checkPwdTextField resignFirstResponder];
}

- (void)setupView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.backView1];
    [self.backView1 addSubview:self.wordsTextView];
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
        make.height.mas_equalTo(131);
    }];
    [self.wordsTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(5);
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.bottom.mas_equalTo(-5);
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
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-56);
        make.bottom.equalTo(self.line2.mas_top);
        make.height.mas_equalTo(40);
    }];
    [self.tradePwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView2).offset(-17);
        make.height.with.mas_equalTo(22);
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
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.line3.mas_bottom).offset(5);
    }];
    [self.comfirButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView2.mas_bottom).offset(25);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)textFieldChange:(NSNotification *)noty{
    if (self.wordsTextView.text.length>0 && self.tradePwdTextField.text.length>0 && self.checkPwdTextField.text.length>0) {
        self.comfirButton.backgroundColor = CLICKABLE_COLOR;
        self.comfirButton.enabled = YES;
    }else{
        self.comfirButton.backgroundColor = UNCLICK_COLOR;
        self.comfirButton.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    //    if (textField != self.nameTextField) {
    if(textField == self.tradePwdTextField || textField == self.checkPwdTextField){
        NSString *regex = @"[\u4e00-\u9fa5]{0,}$"; // 中文
        // 2、拼接谓词
        NSPredicate *predicateRe1 = [NSPredicate predicateWithFormat:@"self matches %@", regex];
        // 3、匹配字符串
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:PWDSTRENGTH] invertedSet];
        NSString *text = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:text] && ![predicateRe1 evaluateWithObject:string];
    }
    //    }
    return YES;
}

- (void)onConfirm{
    [self hideKeyBoard];
    self.getSecret = YES;
    if (![self.tradePwdTextField.text isEqualToString:self.checkPwdTextField.text]) {
        [self showString:GetStringWithKeyFromTable(@"交易密码不一致_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if(self.tradePwdTextField.text.length <8){
        [self showString:GetStringWithKeyFromTable(@"密码长度至少6位_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    NSString *str = self.wordsTextView.text;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    __weak WordsImportScene *weakSelf = self;
    [self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
    weakSelf.generateAddressWithSecret = ^(id  _Nullable responseObject) {
        [weakSelf hideProgressHUDString];
        NSString *addressStr = responseObject[@"address"];
        NSString *secretStr = responseObject[@"secret"];
        if(addressStr){
            NSString *secretKey = [secretStr AES128EncryptWithkey:weakSelf.tradePwdTextField.text];
            [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
            NSArray *currentList = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@' ",addressStr]];
            if(currentList.count > 0){
                [weakSelf showString:GetStringWithKeyFromTable(@"钱包地址已存在_message", LOCALIZABE, nil) delay:1.5];
                [UserManager setDefaultWalletWithWallet:currentList[0]];
            }else{
                LocalWallet *model = [[LocalWallet alloc] init];
                [model configureWithAccount:addressStr name:[NSString stringWithFormat:@"%@ %ld",GetStringWithKeyFromTable(@"新钱包_text", LOCALIZABE, nil),[LocalWallet findAll].count+1] secret:secretKey];
                [UserManager setDefaultWalletWithWallet:model];
            }
            if(weakSelf.wordsImportSuccessBlock){
                weakSelf.wordsImportSuccessBlock();
                [weakSelf.navigationController popViewControllerAnimated:NO];
            }
            return;
        }
    };
    
    self.generateSecretWithMasterKey = ^(id  _Nullable responseObject) {
        if([responseObject isKindOfClass:[NSString class]] && ![responseObject isEqual:[NSNull null]]){
            NSString *secretStr = responseObject;
            if(secretStr && secretStr.length > 0 && weakSelf.getSecret){
                [weakSelf generateAddressWithSecretAction:secretStr];
                weakSelf.getSecret = NO;
            }
        }else{
            [weakSelf hideProgressHUDString];
            [weakSelf showString:GetStringWithKeyFromTable(@"助记词无效_message", LOCALIZABE, nil) delay:1.5];
            return;
        }
    };
    [self generateSecretWithMasterKeyAction:str];
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

-(UITextView *)wordsTextView{
    if(!_wordsTextView){
        _wordsTextView = [[UITextView alloc] init];
        _wordsTextView.font = [UIFont systemFontOfSize:14];
        [_wordsTextView setPlaceholder:GetStringWithKeyFromTable(@"请输入助记词_placeHolder", LOCALIZABE, nil) placeholdColor:RGB(220, 220, 220)];
    }
    return _wordsTextView;
}

- (UIView *)backView1{
    if (_backView1 == nil) {
        _backView1 = [[UIView alloc] init];
        _backView1.backgroundColor = [UIColor whiteColor];
    }
    return _backView1;
}

- (UIView *)backView2{
    if (_backView2 == nil) {
        _backView2 = [[UIView alloc] init];
        _backView2.backgroundColor = [UIColor whiteColor];
    }
    return _backView2;
}

- (UILabel *)tittleLabel{
    if (_tittleLabel == nil) {
        _tittleLabel = [[UILabel alloc] init];
        _tittleLabel.font = [UIFont systemFontOfSize:15];
        _tittleLabel.textColor =RGB(89, 89, 89);
        _tittleLabel.text = GetStringWithKeyFromTable(@"设置交易密码_title", LOCALIZABE, nil);
    }
    return _tittleLabel;
}

- (UITextField *)tradePwdTextField{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

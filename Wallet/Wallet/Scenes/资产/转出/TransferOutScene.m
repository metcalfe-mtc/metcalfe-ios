//
//  TransferOutScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/18.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "TransferOutScene.h"
#import "QRScanningScene.h"
#import "Masonry.h"
#import "NSString+format.h"
#import "UIImage+EasyExtend.h"
#import "NSString+TEDecimalNumber.h"
#import "NSString+format.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "PaymentSecretManager.h"
#import "TransferDetailScene.h"
#import "BaseNavigationController.h"
@interface TransferOutScene ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *line1;
@property(nonatomic,strong) UIView *line2;
@property(nonatomic,strong) UIView *line3;
@property(nonatomic,strong) UILabel *title1;
@property(nonatomic,strong) UILabel *title2;
@property(nonatomic,strong) UILabel *title3;
@property(nonatomic,strong) UITextField *receiveTextField;
@property(nonatomic,strong) UITextField *amountTextField;
@property(nonatomic,strong) UITextField *memoTextField;
@property(nonatomic,strong) UIButton *QRButton;
@property(nonatomic,strong) UIButton *allButton;
@property(nonatomic,strong) UILabel *feeLabel;
@property(nonatomic,strong) UIButton *transferButton;

@end

@implementation TransferOutScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:[NSString stringWithFormat:@"%@ %@",GetStringWithKeyFromTable(@"转出_button", LOCALIZABE, nil),self.balance.currency]];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self.view addSubview:self.line1];
    [self.view addSubview:self.line2];
    [self.view addSubview:self.line3];
    [self.view addSubview:self.title1];
    [self.view addSubview:self.title2];
    [self.view addSubview:self.title3];
    [self.view addSubview:self.receiveTextField];
    [self.view addSubview:self.amountTextField];
    [self.view addSubview:self.memoTextField];
    [self.view addSubview:self.QRButton];
    [self.view addSubview:self.allButton];
    [self.view addSubview:self.feeLabel];
    [self.view addSubview:self.transferButton];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(85);
        make.height.mas_equalTo(0.8);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.line1.mas_bottom).offset(85);
        make.height.mas_equalTo(0.8);
    }];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.line2.mas_bottom).offset(85);
        make.height.mas_equalTo(0.8);
    }];
    [self.title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.line1.mas_top).offset(-40);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(25);
    }];
    [self.title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.line2.mas_top).offset(-40);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(25);
    }];
    [self.title3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.equalTo(self.line3.mas_top).offset(-40);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(25);
    }];
    [self.receiveTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.mas_left).offset(-2);
        make.bottom.equalTo(self.line1.mas_bottom);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(40);
    }];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2.mas_left).offset(-2);
        make.bottom.equalTo(self.line2.mas_bottom);
        make.right.mas_equalTo(-56);
        make.height.mas_equalTo(40);
    }];
    [self.memoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3.mas_left).offset(-2);
        make.bottom.equalTo(self.line3.mas_bottom);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
    }];
    [self.QRButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-17);
        make.centerY.equalTo(self.receiveTextField.mas_centerY);
        make.height.with.mas_equalTo(22);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-13);
        make.centerY.equalTo(self.amountTextField.mas_centerY);
        make.height.with.mas_equalTo(22);
    }];
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.equalTo(self.line2.mas_bottom).offset(3);
        make.left.mas_equalTo(15);
    }];
    [self.transferButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-45);
        make.top.equalTo(self.line3.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(45);
    }];
    
    self.amountTextField.placeholder = [NSString stringWithFormat:@"%@ %@",GetStringWithKeyFromTable(@"可转出_placeHolder", LOCALIZABE, nil),self.availableValue];
    UITapGestureRecognizer *gusture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gusture];
}



#pragma mark - action

-(void)hideKeyBoard{
    [self.receiveTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.memoTextField resignFirstResponder];
}


-(NSString *)getBalanceAvailable{
    NSString *available = @"0";
    NSArray *balancArr = SYSTEM_GET_(BALANCES);
    for(int i = 0; i < balancArr.count; i++){
        BalanceModel *balance = balancArr[i];
        if([balance.currency isEqualToString:self.balance.currency]){
            available = balance.balance;
            if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
                available = [available calculateBySubtracting:SYSTEM_GET_(FREEZE)];
            }
        }
    }
    return available;
}

- (void)QRButtonAction{
    QRScanningScene *vc = [[QRScanningScene alloc] init];
    __weak TransferOutScene *weakSelf = self;
    vc.blockQRResult = ^(NSString * _Nonnull result) {
        weakSelf.receiveTextField.text = result;
        if (weakSelf.receiveTextField.text.length>0 && self.amountTextField.text.length>0)  {
            weakSelf.transferButton.backgroundColor = CLICKABLE_COLOR;
            weakSelf.transferButton.enabled = YES;
        }else{
            weakSelf.transferButton.backgroundColor = UNCLICK_COLOR;
            weakSelf.transferButton.enabled = NO;
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)allButtonAction{
    self.amountTextField.text = self.availableValue;
    if (self.receiveTextField.text.length>0 && self.amountTextField.text.length>0)  {
        self.transferButton.backgroundColor = CLICKABLE_COLOR;
        self.transferButton.enabled = YES;
    }else{
        self.transferButton.backgroundColor = UNCLICK_COLOR;
        self.transferButton.enabled = NO;
    }
}

-(void)transferButtonAction{
    if(self.receiveTextField.text.length == 0){
        [self showString:GetStringWithKeyFromTable(@"收款地址不能为空_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    LocalWallet * wallet = [UserManager sharedInstance].wallet;
    if([self.receiveTextField.text isEqualToString:wallet.account]){
        [self showString:GetStringWithKeyFromTable(@"无法给自己当前账户转账_message", LOCALIZABE, nil) delay:1.5];
        return;
    }


    if(self.amountTextField.text.length == 0 || [self.amountTextField.text calculateIsEqual:@"0"]){
        [self showString:GetStringWithKeyFromTable(@"转出金额不能为空_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if([self.amountTextField.text calculateIsLessThan:@"0"]){
        [self showString:GetStringWithKeyFromTable(@"输入金额不合法_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
    if([self.amountTextField.text calculateIsGreaterThan:self.availableValue]){
        [self showString:GetStringWithKeyFromTable(@"余额不足_message", LOCALIZABE, nil) delay:1.5];
        return;
    }
//                if([weakSelf.amountTextField.text calculateIsGreaterThan:[weakSelf getBalanceAvailable]]){
//                    [weakSelf showString:GetStringWithKeyFromTable(@"余额不足_message", LOCALIZABE, nil) delay:1.5];
//                    return;
//                }
    
        __weak TransferOutScene *weakSelf = self;
        self.isValidAddress = ^(BOOL isValid) {
            if(isValid){
                [weakSelf popPaymentAction];
                weakSelf.isValidAddress = nil;
            }else{
                [weakSelf showString:GetStringWithKeyFromTable(@"无效地址_message", LOCALIZABE, nil) delay:1.5];
                weakSelf.isValidAddress = nil;
                return;
            }
            
        };


    [self validAddress:[NSString removeSpaceAndNewline:self.receiveTextField.text]];
}

-(void)popPaymentAction{
    //支付密码
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    PaymentSecretManager *payment = [PaymentSecretManager shareInstance];
    __weak TransferOutScene *weakSelf = self;
    payment.PaymemtSecretCurrectBlock = ^(NSString *secret) {
        //转账

        [weakSelf transferActionWithSecret:secret];
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    };
    [payment presentSecretSceneWithSecretkey:[UserManager sharedInstance].wallet.secret];
}



-(void)transferActionWithSecret:(NSString *)secret{
    [RequestManager getAssetsBaseValueWithProgress:NO account:[UserManager sharedInstance].wallet.account ledgerInddex:@"current" withFee:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        __weak TransferOutScene *weakSelf = self;
        [self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
        self.signWithTxjsonAndSecret = ^(id  _Nullable response) {
            [weakSelf hideProgressHUDString];
            if([response isKindOfClass:[NSDictionary class]]){
                [weakSelf showProgressHUDWithString:GetStringWithKeyFromTable(@"正在提交中_message", LOCALIZABE, nil)];
                [RequestManager transcationSubmitWithProgress:NO hash:response[@"hash"] txBlob:response[@"txBlob"] success:^(id  _Nonnull result) {
                    [weakSelf hideProgressHUDString];
                    if(result[@"data"][@"engineResult"] && [result[@"data"][@"engineResult"] isEqualToString:@"tesSUCCESS"]){
                        TransferDetailScene *scene = [[TransferDetailScene alloc] init];
                        scene.HashStr = result[@"data"][@"hash"];
                        [(BaseNavigationController *)weakSelf.navigationController replaceViewController:scene animated:YES];
                    }else{
//                        [weakSelf showString:result[@"data"][@"engineResultMessage"] delay:1.5];
                        TransferDetailScene *scene = [[TransferDetailScene alloc] init];
                        scene.HashStr = result[@"data"][@"hash"];
                        [(BaseNavigationController *)weakSelf.navigationController replaceViewController:scene animated:YES];
                    }
                    
                    
                    
                } warn:^(NSString * _Nonnull content) {
                    [weakSelf hideProgressHUDString];
                } error:^(NSString * _Nonnull content) {
                    [weakSelf hideProgressHUDString];
                } failure:^(NSError * _Nonnull error) {
                    [weakSelf hideProgressHUDString];
                }];
            }
        };
        NSMutableDictionary *txDict = [[NSMutableDictionary alloc] init];
        txDict[@"TransactionType"] = @"Payment";
        txDict[@"Account"] = responseObject[@"account"];
        txDict[@"Destination"] = [NSString removeSpaceAndNewline:self.receiveTextField.text];
        if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
            txDict[@"Amount"] = [self.amountTextField.text calculateByMultiplying:@"1000000"];
        }else{
            NSMutableDictionary *amountDict = [[NSMutableDictionary alloc] init];
            amountDict[@"currency"] = self.balance.currency;
            amountDict[@"value"] = self.amountTextField.text;
            amountDict[@"issuer"] = self.balance.account;
            txDict[@"Amount"] = amountDict;
        }
        NSMutableDictionary *memo1 = [[NSMutableDictionary alloc] init];
        memo1[@"MemoType"] = @"54455854";
        memo1[@"MemoData"] = [self hexStringFromString:self.memoTextField.text].uppercaseString;
        NSDictionary *memo = @{@"Memo":memo1};
        txDict[@"Memos"] = @[memo];
        txDict[@"Fee"] = responseObject[@"baseFee"];
        txDict[@"Flags"] = @"2147483648";
        txDict[@"Sequence"] = responseObject[@"sequence"];
        [self signActionWithTxjson:[NSString convertToJsonData:txDict] withSecret:secret];
    } warn:^(NSString * _Nonnull content) {
        
    } error:^(NSString * _Nonnull content) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

- (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (void)textFieldChange:(NSNotification *)noty
{
    if (self.receiveTextField.text.length>0 && self.amountTextField.text.length>0)  {
        self.transferButton.backgroundColor = CLICKABLE_COLOR;
        self.transferButton.enabled = YES;
    }else{
        self.transferButton.backgroundColor = UNCLICK_COLOR;
        self.transferButton.enabled = NO;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        // 当前输入的字符是'.'
        if ([string isEqualToString:@"."]) {
            
            // 已输入的字符串中已经包含了'.'或者""
            if ([textField.text rangeOfString:@"."].location != NSNotFound || [textField.text isEqualToString:@""]) {
                
                return NO;
            } else {
                
                return YES;
            }
        } else {// 当前输入的不是'.'
            
            // 第一个字符是0时, 第二个不能再输入0
            if (textField.text.length == 1) {
                
                unichar str = [textField.text characterAtIndex:0];
                if (str == '0' && [string isEqualToString:@"0"]) {
                    
                    return NO;
                }
                
                if (str != '0' && str != '1') {// 1xx或0xx
                    
                    return YES;
                } else {
                    
                    if (str == '1') {
                        
                        return YES;
                    } else {
                        
                        if ([string isEqualToString:@""]) {
                            
                            return YES;
                        } else {
                            
                            return NO;
                        }
                    }
                    
                    
                }
            }
            
            // 已输入的字符串中包含'.'
            if ([textField.text rangeOfString:@"."].location != NSNotFound) {
                
                NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
                [str insertString:string atIndex:range.location];
                
                if (str.length >= [str rangeOfString:@"."].location + 8) {
                    
                    return NO;
                }
                NSLog(@"str.length = %ld, str = %@, string.location = %ld", str.length, string, range.location);
            } else {
                if (textField.text.length > 9) {
                    return range.location < 10;
                }
            }
            
        }
    
    return YES;
}


#pragma mark - getter
-(UIView *)line1{
    if(!_line1){
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = LINE_COLOR;
    }
    return _line1;
}

-(UIView *)line2{
    if(!_line2){
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = LINE_COLOR;
    }
    return _line2;
}

-(UIView *)line3{
    if(!_line3){
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = LINE_COLOR;
    }
    return _line3;
}

-(UILabel *)title1{
    if(!_title1){
        _title1 = [[UILabel alloc] init];
        _title1.text = GetStringWithKeyFromTable(@"收款方_title", LOCALIZABE, nil);
        _title1.font = [UIFont systemFontOfSize:16];
        _title1.textColor = RGB(51, 51, 51);
    }
    return _title1;
}

-(UILabel *)title2{
    if(!_title2){
        _title2 = [[UILabel alloc] init];
        _title2.text = GetStringWithKeyFromTable(@"转出金额_title", LOCALIZABE, nil);
        _title2.font = [UIFont systemFontOfSize:16];
        _title2.textColor = RGB(51, 51, 51);
    }
    return _title2;
}

-(UILabel *)title3{
    if(!_title3){
        _title3 = [[UILabel alloc] init];
        _title3.text = GetStringWithKeyFromTable(@"备注_title", LOCALIZABE, nil);
        _title3.font = [UIFont systemFontOfSize:16];
        _title3.textColor = RGB(51, 51, 51);
    }
    return _title3;
}

-(UILabel *)feeLabel{
    if(!_feeLabel){
        _feeLabel = [[UILabel alloc] init];
        _feeLabel.text = GetStringWithKeyFromTable(@"手续费_text", LOCALIZABE, nil);
        _feeLabel.font = [UIFont systemFontOfSize:11];
        _feeLabel.textAlignment = NSTextAlignmentRight;
        _feeLabel.text = [NSString stringWithFormat:@"%@: %@%@",GetStringWithKeyFromTable(@"手续费_text", LOCALIZABE, nil),[@"100" calculateByDividing:@"1000000"],DEFAULTCURRENCY];
        _feeLabel.textColor = RGB(152, 152, 152);
    }
    return _feeLabel;
}

-(UITextField *)receiveTextField{
    if(!_receiveTextField){
        _receiveTextField = [[UITextField alloc] init];
        _receiveTextField.font = [UIFont systemFontOfSize:15];
        _receiveTextField.placeholder = GetStringWithKeyFromTable(@"收款方_title", LOCALIZABE, nil);
    }
    return _receiveTextField;
}

-(UITextField *)amountTextField{
    if(!_amountTextField){
        _amountTextField = [[UITextField alloc] init];
        _amountTextField.font = [UIFont systemFontOfSize:15];
        _amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTextField.delegate = self;
    }
    return _amountTextField;
}

-(UITextField *)memoTextField{
    if(!_memoTextField){
        _memoTextField = [[UITextField alloc] init];
        _memoTextField.font = [UIFont systemFontOfSize:15];
        _memoTextField.placeholder = GetStringWithKeyFromTable(@"备注(选填)_placeHolder", LOCALIZABE, nil);
    }
    return _memoTextField;
}

-(UIButton *)QRButton{
    if (!_QRButton) {
        _QRButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_QRButton setImage:[UIImage imageNamed:@"ic_scan_grey"] forState:UIControlStateNormal];
        [_QRButton addTarget:self action:@selector(QRButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_QRButton setEnlargeEdgeWithTop:17 right:17 bottom:17 left:17];
    }
    return _QRButton;
}


-(UIButton *)allButton{
    if (!_allButton) {
        _allButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_allButton setTitle:GetStringWithKeyFromTable(@"全部_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        [_allButton setTitleColor:RGB(52, 52, 52) forState:UIControlStateNormal];
        _allButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_allButton addTarget:self action:@selector(allButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_allButton setEnlargeEdgeWithTop:17 right:17 bottom:17 left:17];
    }
    return _allButton;
}

- (UIButton *)transferButton{
    if (_transferButton == nil) {
        _transferButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _transferButton.backgroundColor = UNCLICK_COLOR;
        [_transferButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _transferButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_transferButton setTitle:GetStringWithKeyFromTable(@"提交_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        _transferButton.layer.masksToBounds = YES;
        _transferButton.enabled = NO;
        _transferButton.layer.cornerRadius = 20;
        //        _transferButton.timeInterval = 5;
        [_transferButton addTarget:self action:@selector(transferButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferButton;
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

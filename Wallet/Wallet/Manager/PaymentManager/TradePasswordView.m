//
//  TradePasswordView.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/20.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "TradePasswordView.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
@interface TradePasswordView ()<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat keyBoardHeight;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic,strong) UILabel * briefLabel;

@property (nonatomic,strong) UILabel * warningLabel;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic, strong) UIButton *eyeButton;

@property (nonatomic,strong) UIButton *forgetButton;

@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) NSString *secretkey;

@end


@implementation TradePasswordView

-(instancetype)initWithFrame:(CGRect)frame secretkey:(nonnull NSString *)secretkey{
    if(self){
        self = [super initWithFrame:frame];
        // 添加通知监听见键盘弹出/退出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
        [self addSubview:self.backGroundView];
        [self addSubview:self.contentView];
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, WIDTH, 0.6)];
        lineView1.backgroundColor = RGB(236, 236, 236);
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 119.2, WIDTH-30, 0.8)];
        lineView2.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:lineView1];
        [self.contentView addSubview:lineView2];
        [self.contentView addSubview:self.inputView];
        [self.contentView addSubview:self.briefLabel];
        [self.contentView addSubview:self.forgetButton];
        [self.contentView addSubview:self.warningLabel];
        [self.contentView addSubview:self.pwdTextField];
        [self.contentView addSubview:self.eyeButton];
        [self.contentView addSubview:self.confirmButton];
        [self.pwdTextField becomeFirstResponder];
        self.secretkey = secretkey;
    }
    return self;
}

// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender{
    // 通过通知对象获取键盘frame: [value CGRectValue]
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // <注意>具有约束的控件通过改变约束值进行frame的改变处理
    if([sender.name isEqualToString:UIKeyboardWillShowNotification]){
        CGFloat keyBoardHeight = [value CGRectValue].size.height;
        self.contentView.frame = CGRectMake(0, HEIGHT-keyBoardHeight-225, WIDTH, 225);
    }else{
        self.contentView.frame = CGRectMake(0, HEIGHT-225, WIDTH, 225);
    }
}

-(void)showPaymentSecretInputView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroundView.alpha = 0.5;
    }];
    
}

-(void)cancleInputAction{
    if(self.cancleInputBlock){
        self.cancleInputBlock();
    }
    [self hidePaymentSecretInputView];
}

-(void)hidePaymentSecretInputView{
    [self  removeFromSuperview];
    
}

//密码密文/明文
- (void)passwordSecretAction{
    if(self.pwdTextField.secureTextEntry == YES){
        self.pwdTextField.secureTextEntry = NO;
        [self.eyeButton setImage:[UIImage imageNamed:@"ic_visible_passwords"] forState:UIControlStateNormal];
    }else{
        self.pwdTextField.secureTextEntry = YES;
        [self.eyeButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
    }
}

#pragma mark - delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if (self.pwdTextField.text.length >16) {
        self.pwdTextField.text = [textField.text substringToIndex:16];
        return NO;
    }
    return YES;
}

#pragma mark - action
-(void)confirmAction{
    if(self.pwdTextField.text.length >=8 && self.pwdTextField.text.length<=16){
      NSString *secretStr = [self.secretkey AES128DecryptWithkey:self.pwdTextField.text];
        secretStr = [secretStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(secretStr && secretStr.length > 0){
            if(self.inputCompleteBlock){
                self.inputCompleteBlock(secretStr);
            }
        }else{
            self.warningLabel.hidden = NO;
        }
    }else{
        self.warningLabel.hidden = NO;
    }
}

-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleInputAction)];
        [_backGroundView addGestureRecognizer:gesture];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-225, WIDTH, 225)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 2;
    }
    return _contentView;
}


- (UITextField *)pwdTextField {
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 80, WIDTH-60, 39.2)];
        _pwdTextField.placeholder = GetStringWithKeyFromTable(@"输入交易密码_placeHolder", LOCALIZABE, nil);
        _pwdTextField.delegate = self;
        _pwdTextField.secureTextEntry = YES;
        _pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _pwdTextField;
}

-(UILabel *)briefLabel{
    if(!_briefLabel){
        _briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 45)];
        _briefLabel.textColor = [UIColor blackColor];
        _briefLabel.font = [UIFont systemFontOfSize:18];
        _briefLabel.textAlignment = NSTextAlignmentCenter;
        NSString *keyong = GetStringWithKeyFromTable(@"交易密码_title", LOCALIZABE, nil);
        _briefLabel.text = keyong;
    }
    return _briefLabel;
}

-(UILabel *)warningLabel{
    if(!_warningLabel){
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.pwdTextField.frame)+3, WIDTH-30, 20)];
        _warningLabel.font = [UIFont systemFontOfSize:14];
        _warningLabel.textColor = RGB(255, 0, 0);
        _warningLabel.textAlignment = NSTextAlignmentLeft;
        _warningLabel.hidden = YES;
        NSString *keyong = GetStringWithKeyFromTable(@"密码错误_message", LOCALIZABE, nil);
        _warningLabel.text = keyong;
        
    }
    return _warningLabel;
}

-(UIButton *)eyeButton{
    if(!_eyeButton){
        _eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdTextField.frame), CGRectGetMidY(self.pwdTextField.frame)-22.5, 45, 45)];
        [_eyeButton setImage:[UIImage imageNamed:@"ic_invisible_passwords"] forState:UIControlStateNormal];
        [_eyeButton addTarget:self action:@selector(passwordSecretAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(45, 155, WIDTH-90, 40)];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:GetStringWithKeyFromTable(@"确定_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        _confirmButton.backgroundColor = CLICKABLE_COLOR;
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

-(void)cancleAction{
    [self hidePaymentSecretInputView];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

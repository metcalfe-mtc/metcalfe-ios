//
//  TranscationConfirmView.m
//  BVCPay
//
//  Created by 钱伟成 on 2019/9/16.
//  Copyright © 2019 MTC联盟. All rights reserved.
//

#import "TranscationConfirmView.h"

@interface TranscationConfirmView ()<UITextFieldDelegate>

@property (nonatomic, assign) CGFloat keyBoardHeight;

@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) UILabel * briefLabel;

@property (nonatomic,strong) UILabel * briefLabel1;

@property (nonatomic,strong) UILabel * warningLabel;

@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic,strong) UIView *contentView;

//@property (nonatomic, strong) UIButton *eyeButton;

@property (nonatomic,strong) UIButton *forgetButton;

@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) UIView *inputView;

@end

@implementation TranscationConfirmView

-(instancetype)initWithFrame:(CGRect)frame amount:(NSString *)amount currency:(NSString *)currency inc:(NSString *)inc type:(nonnull NSString *)type{
    if(self){
        self = [super initWithFrame:frame];
        UIColor *transcationColor = [type isEqualToString:GetStringWithKeyFromTable(@"买入_button", LOCALIZABE, nil)]?TRANSCATION_BLUECOLOR:TRANSCATION_REDCOLOR;
        // 添加通知监听见键盘弹出/退出
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];
        [self addSubview:self.backGroundView];
        [self addSubview:self.contentView];
        self.inputView = [[UIView alloc] initWithFrame:CGRectMake(15, 100, WIDTH-30, 40)];
        self.inputView.layer.borderColor = RGB(236, 236, 236).CGColor;
        self.inputView.layer.borderWidth = 0.8;
        self.inputView.layer.cornerRadius = 5;
        self.inputView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.inputView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.briefLabel];
        [self.contentView addSubview:self.briefLabel1];
//        [self.contentView addSubview:self.forgetButton];
        [self.contentView addSubview:self.warningLabel];
        [self.inputView addSubview:self.pwdTextField];
        //        [self.contentView addSubview:self.eyeButton];
        [self.contentView addSubview:self.confirmButton];
        [self.pwdTextField becomeFirstResponder];
        NSString *buyStr = [NSString stringWithFormat:@"%@ %@ %@",type,amount,currency];
        NSString *freezeStr = [NSString stringWithFormat:@"%@ %@ BVC",GetStringWithKeyFromTable(@"系统将会冻结_brief", LOCALIZABE, nil),inc];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:buyStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:transcationColor range:NSMakeRange(0, type.length)];
        self.briefLabel.attributedText = attStr;
        
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:freezeStr];
        [attStr1 addAttribute:NSForegroundColorAttributeName value:TRANSCATION_REDCOLOR range:NSMakeRange(freezeStr.length-5, 5)];
        self.briefLabel1.attributedText = attStr1;
        
        
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
        self.contentView.frame = CGRectMake(0, HEIGHT-keyBoardHeight-265, WIDTH, 265);
    }else{
        self.contentView.frame = CGRectMake(0, HEIGHT-265, WIDTH, 265);
    }
}

-(void)showPaymentSecretInputView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroundView.alpha = 0.5;
    }];
}

-(void)hidePaymentSecretInputView{
    [self  removeFromSuperview];
    
}
#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    else if (self.pwdTextField.text.length >12) {
        self.pwdTextField.text = [textField.text substringToIndex:12];
        return NO;
    }
    return YES;
}

#pragma mark - action

-(void)forgetButtonAction{
    if(self.forgetBlock){
        self.forgetBlock();
    }
}

-(void)confirmAction{
    if(self.pwdTextField.text.length >=6 && self.pwdTextField.text.length<=12){
        if(self.inputCompleteBlock){
            self.inputCompleteBlock(self.pwdTextField.text);
            [self hidePaymentSecretInputView];
        }
    }else{
        self.warningLabel.hidden = NO;
    }
}

-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePaymentSecretInputView)];
        [_backGroundView addGestureRecognizer:gesture];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-265, WIDTH, 265)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 2;
    }
    return _contentView;
}


- (UITextField *)pwdTextField {
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(5, 0, WIDTH-40, 40)];
        _pwdTextField.placeholder = GetStringWithKeyFromTable(@"请输入交易密码_message", LOCALIZABE, nil);
        _pwdTextField.delegate = self;
        _pwdTextField.secureTextEntry = YES;
    }
    return _pwdTextField;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, WIDTH, 25)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        NSString *keyong = GetStringWithKeyFromTable(@"交易密码_title", LOCALIZABE, nil);
        _titleLabel.text = keyong;
    }
    return _titleLabel;
}

-(UILabel *)briefLabel{
    if(!_briefLabel){
        _briefLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+18, WIDTH-20, 23)];
        _briefLabel.textColor = RGB(40, 40, 40);
        _briefLabel.font = [UIFont systemFontOfSize:16];
        _briefLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _briefLabel;
}

-(UILabel *)briefLabel1{
    if(!_briefLabel1){
        _briefLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.briefLabel.frame), WIDTH-20, 20)];
        _briefLabel1.textColor = RGB(102, 102, 102);
        _briefLabel1.font = [UIFont systemFontOfSize:12];
        _briefLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _briefLabel1;
}


-(UILabel *)warningLabel{
    if(!_warningLabel){
        _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.inputView.frame)+3, WIDTH-30, 20)];
        _warningLabel.font = [UIFont systemFontOfSize:14];
        _warningLabel.textColor = THEME_COLOR_BULE;
        _warningLabel.textAlignment = NSTextAlignmentLeft;
        _warningLabel.hidden = YES;
        NSString *keyong = GetStringWithKeyFromTable(@"密码长度至少8位_message", LOCALIZABE, nil);
        _warningLabel.text = keyong;
        
    }
    return _warningLabel;
}

//-(UIButton *)eyeButton{
//    if(!_eyeButton){
//        _eyeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pwdTextField.frame), CGRectGetMidY(self.pwdTextField.frame)-22.5, 45, 45)];
//        [_eyeButton setImage:[UIImage imageNamed:@"ic_invisible"] forState:UIControlStateNormal];
//        [_eyeButton addTarget:self action:@selector(passwordSecretAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _eyeButton;
//}

//-(UIButton *)forgetButton{
//    if(!_forgetButton){
//        _forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-85, 0, 80, 45)];
//        [_forgetButton setTitleColor:TEXT_COLOR1 forState:UIControlStateNormal];
//        [_forgetButton setTitle:GetStringWithKeyFromTable(@"忘记密码_button", LOCALIZABE, nil) forState:UIControlStateNormal];
//        [_forgetButton addTarget:self action:@selector(forgetButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _forgetButton;
//}

-(UIButton *)confirmButton{
    if(!_confirmButton){
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.inputView.frame)+42, WIDTH-30, 45)];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:GetStringWithKeyFromTable(@"确定_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        _confirmButton.backgroundColor = THEME_COLOR_BULE;
        [_confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.cornerRadius = 8;
        _confirmButton.layer.masksToBounds = YES;
    }
    return _confirmButton;
}

-(void)cancleAction{
    [self hidePaymentSecretInputView];
}

@end


//
//  AddWalletSelectView.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/7.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "AddWalletSelectView.h"

@interface AddWalletSelectView ()
@property (nonatomic, strong) UIView *backGroundView;

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic, strong) UIButton *createButton;

@property (nonatomic,strong) UIButton *leadInButton;

@property (nonatomic,strong) UIButton *cancleButton;
@end

@implementation AddWalletSelectView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        [self addSubview:self.backGroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.createButton];
        [self.contentView addSubview:self.leadInButton];
        [self.contentView addSubview:self.cancleButton];
    }
    return self;
}

-(void)showAddWalletSelectView{
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication  sharedApplication].keyWindow addSubview:self];
        self.backGroundView.alpha = 0.5;
    }];
}

-(void)hideAddWalletSelectView{
    [self  removeFromSuperview];
}

-(void)createAction{
    if(self.createWalletBlock){
        self.createWalletBlock(@"");
        [self hideAddWalletSelectView];
    }
}

-(void)leadInAction{
    if(self.leadInWalletBlock){
        self.leadInWalletBlock(@"");
        [self hideAddWalletSelectView];
    }
}

-(void)cancleAction{
    [self hideAddWalletSelectView];
}

-(UIView *)backGroundView{
    if(!_backGroundView){
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _backGroundView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAddWalletSelectView)];
        [_backGroundView addGestureRecognizer:gesture];
        _backGroundView.alpha = 0;
    }
    return _backGroundView;
}

-(UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT-kWidth(346), WIDTH, kWidth(346))];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 2;
    }
    return _contentView;
}

-(UIButton *)createButton{
    if(!_createButton){
        _createButton = [[UIButton alloc] initWithFrame:CGRectMake(36, kWidth(27), WIDTH-72, kWidth(69))];
   
        _createButton.layer.cornerRadius = 20;
        _createButton.layer.masksToBounds = NO;
        _createButton.layer.shadowColor = RGBA(2, 0, 0, 0.29).CGColor;
        _createButton.layer.shadowOffset = CGSizeMake(0,3);
        _createButton.layer.shadowOpacity = 1;
        _createButton.layer.shadowRadius = 4;
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,WIDTH-72,kWidth(69));
        gl.cornerRadius = 20;
        gl.masksToBounds = NO;
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 0);
        gl.colors = @[(__bridge id)RGB(126, 208, 255).CGColor,(__bridge id)RGB(75, 142, 255).CGColor];
        gl.locations = @[@(0.0),@(0.6)];
        [_createButton.layer addSublayer:gl];
        NSString *title = [NSString stringWithFormat:@"  %@",GetStringWithKeyFromTable(@"创建钱包_key00072", LOCALIZABE, nil)];
        [_createButton setTitle:title forState:UIControlStateNormal];
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createButton setImage:[UIImage imageNamed:@"wallet_create"] forState:UIControlStateNormal];
        [_createButton setImage:[UIImage imageNamed:@"wallet_create"] forState:UIControlStateHighlighted];
        _createButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_createButton bringSubviewToFront:_createButton.imageView];
        [_createButton addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createButton;
}

-(UIButton *)leadInButton{
    if(!_leadInButton){
        _leadInButton = [[UIButton alloc] initWithFrame:CGRectMake(36, CGRectGetMaxY(self.createButton.frame)+kWidth(20), WIDTH-72, kWidth(69))];
        _leadInButton.layer.cornerRadius = 20;
        _leadInButton.layer.masksToBounds = NO;
        _leadInButton.layer.shadowColor = RGBA(2, 0, 0, 0.29).CGColor;
        _leadInButton.layer.shadowOffset = CGSizeMake(0,3);
        _leadInButton.layer.shadowOpacity = 1;
        _leadInButton.layer.shadowRadius = 4;
        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.frame = CGRectMake(0,0,WIDTH-72,kWidth(69));
        gl.cornerRadius = 20;
        gl.masksToBounds = NO;
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 0);
        gl.colors = @[(__bridge id)RGB(184, 109, 248).CGColor,(__bridge id)RGB(147, 100, 255).CGColor];
        gl.locations = @[@(0.0),@(0.6)];
        [_leadInButton.layer addSublayer:gl];
        NSString *title = [NSString stringWithFormat:@"  %@",GetStringWithKeyFromTable(@"导入钱包_key00073", LOCALIZABE, nil)];
        [_leadInButton setTitle:title forState:UIControlStateNormal];
        _leadInButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leadInButton setImage:[UIImage imageNamed:@"wallet_leadin"] forState:UIControlStateNormal];
        [_leadInButton setImage:[UIImage imageNamed:@"wallet_leadin"] forState:UIControlStateHighlighted];
        [_leadInButton bringSubviewToFront:_leadInButton.imageView];
        [_leadInButton addTarget:self action:@selector(leadInAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leadInButton;
}

-(UIButton *)cancleButton{
    if(!_cancleButton){
        _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(36, kWidth(266), WIDTH-72, kWidth(40))];
        _cancleButton.backgroundColor = RGB(95, 155, 255);
        _cancleButton.layer.cornerRadius = 20;
        _cancleButton.layer.masksToBounds = YES;
        [_cancleButton setTitle:GetStringWithKeyFromTable(@"取消_key00049", LOCALIZABE, nil) forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancleButton addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

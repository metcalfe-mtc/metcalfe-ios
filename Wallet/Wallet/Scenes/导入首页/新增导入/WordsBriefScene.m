//
//  WordsBriefScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/9.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "WordsBriefScene.h"
#import "Masonry.h"
#import "WordBackUpScene.h"
@interface WordsBriefScene ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *titleLabel1;
@property(nonatomic,strong)UIView *backView1;
@property(nonatomic,strong)UIImageView *iconImageView1;
@property(nonatomic,strong)UIView *iconBackView1;
@property(nonatomic,strong)UILabel *brief1;
@property(nonatomic,strong)UIView *backView2;
@property(nonatomic,strong)UIImageView *iconImageView2;
@property(nonatomic,strong)UIView *iconBackView2;
@property(nonatomic,strong)UILabel *brief2;
@property(nonatomic,strong)UIView *backView3;
@property(nonatomic,strong)UIImageView *iconImageView3;
@property(nonatomic,strong)UIView *iconBackView3;
@property(nonatomic,strong)UILabel *brief3;
@property(nonatomic,strong)UIButton *nextStepButton;
@end

@implementation WordsBriefScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"备份助记词_title", LOCALIZABE, nil)];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.titleLabel1];
    [self.view addSubview:self.backView1];
    [self.backView1 addSubview:self.iconBackView1];
    [self.iconBackView1 addSubview:self.iconImageView1];
    [self.backView1 addSubview:self.brief1];
    [self.view addSubview:self.backView2];
    [self.backView2 addSubview:self.iconBackView2];
    [self.iconBackView2 addSubview:self.iconImageView2];
    [self.backView2 addSubview:self.brief2];
    [self.view addSubview:self.backView3];
    [self.backView3 addSubview:self.iconBackView3];
    [self.iconBackView3 addSubview:self.iconImageView3];
    [self.backView3 addSubview:self.brief3];
    [self.view addSubview:self.nextStepButton];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [self.titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    [self.backView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
        make.top.equalTo(self.titleLabel1.mas_bottom).offset(20);
    }];
    [self.iconBackView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.backView1.mas_centerY);
    }];
    [self.iconImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(self.iconBackView1.mas_centerY);
        make.centerX.equalTo(self.iconBackView1.mas_centerX);
    }];
    [self.brief1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBackView1.mas_right).offset(12.5);
        make.right.mas_equalTo(10);
        make.centerY.equalTo(self.backView1.mas_centerY);
    }];
    [self.backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
        make.top.equalTo(self.backView1.mas_bottom).offset(10);
    }];
    [self.iconBackView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.backView2.mas_centerY);
    }];
    [self.iconImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(self.iconBackView2.mas_centerY);
        make.centerX.equalTo(self.iconBackView2.mas_centerX);
    }];
    [self.brief2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBackView2.mas_right).offset(12.5);
        make.right.mas_equalTo(10);
        make.centerY.equalTo(self.backView2.mas_centerY);
    }];
    [self.backView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(55);
        make.top.equalTo(self.backView2.mas_bottom).offset(10);
    }];
    [self.iconBackView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.equalTo(self.backView3.mas_centerY);
    }];
    [self.iconImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(18);
        make.centerY.equalTo(self.iconBackView3.mas_centerY);
        make.centerX.equalTo(self.iconBackView3.mas_centerX);
    }];
    [self.brief3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconBackView3.mas_right).offset(12.5);
        make.right.mas_equalTo(10);
        make.centerY.equalTo(self.backView3.mas_centerY);
    }];
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.top.equalTo(self.backView3.mas_bottom).offset(25);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - getter
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = RGB(255, 0, 0);
        _titleLabel.text = GetStringWithKeyFromTable(@"备份提示_label", LOCALIZABE, nil);
    }
    return _titleLabel;
}

-(UILabel *)titleLabel1{
    if(!_titleLabel1){
        _titleLabel1 = [[UILabel alloc] init];
        _titleLabel1.font = [UIFont systemFontOfSize:12];
        _titleLabel1.textColor = RGB(152, 152, 152);
        _titleLabel1.text = GetStringWithKeyFromTable(@"掌握助记词_label", LOCALIZABE, nil);
    }
    return _titleLabel1;
}

-(UIView *)backView1{
    if(!_backView1){
        _backView1 = [[UIView alloc] init];
        _backView1.backgroundColor = RGB(247, 247, 251);
        _backView1.layer.cornerRadius = 5;
        _backView1.layer.masksToBounds = YES;
    }
    return _backView1;
}

-(UIImageView *)iconImageView1{
    if(!_iconImageView1){
        _iconImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_backUp001"]];
    }
    return _iconImageView1;
}

-(UIView *)iconBackView1{
    if(!_iconBackView1){
        _iconBackView1 = [[UIView alloc] init];
        _iconBackView1.backgroundColor = RGB(240, 241, 245);;
    }
    return _iconBackView1;
}

-(UILabel *)brief1{
    if(!_brief1){
        _brief1 = [[UILabel alloc] init];
        _brief1.font = [UIFont systemFontOfSize:12];
        _brief1.textColor = RGB(29, 30, 44);
        _brief1.numberOfLines = 0;
        _brief1.text = GetStringWithKeyFromTable(@"正确抄写助记词_label", LOCALIZABE, nil);
    }
    return _brief1;
}

-(UIView *)backView2{
    if(!_backView2){
        _backView2 = [[UIView alloc] init];
        _backView2.backgroundColor = RGB(247, 247, 251);
        _backView2.layer.cornerRadius = 5;
        _backView2.layer.masksToBounds = YES;
    }
    return _backView2;
}

-(UIImageView *)iconImageView2{
    if(!_iconImageView2){
        _iconImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_backUp002"]];
    }
    return _iconImageView2;
}

-(UIView *)iconBackView2{
    if(!_iconBackView2){
        _iconBackView2 = [[UIView alloc] init];
        _iconBackView2.backgroundColor = RGB(240, 241, 245);
    }
    return _iconBackView2;
}

-(UILabel *)brief2{
    if(!_brief2){
        _brief2 = [[UILabel alloc] init];
        _brief2.font = [UIFont systemFontOfSize:12];
        _brief2.textColor = RGB(29, 30, 44);
        _brief2.numberOfLines = 0;
        _brief2.text = GetStringWithKeyFromTable(@"离线保管_label", LOCALIZABE, nil);
    }
    return _brief2;
}

-(UIView *)backView3{
    if(!_backView3){
        _backView3 = [[UIView alloc] init];
        _backView3.backgroundColor = RGB(247, 247, 251);
        _backView3.layer.cornerRadius = 5;
        _backView3.layer.masksToBounds = YES;
    }
    return _backView3;
}

-(UIImageView *)iconImageView3{
    if(!_iconImageView3){
        _iconImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_backUp003"]];
    }
    return _iconImageView3;
}

-(UIView *)iconBackView3{
    if(!_iconBackView3){
        _iconBackView3 = [[UIView alloc] init];
        _iconBackView3.backgroundColor = RGB(240, 241, 245);;
    }
    return _iconBackView3;
}

-(UILabel *)brief3{
    if(!_brief3){
        _brief3 = [[UILabel alloc] init];
        _brief3.font = [UIFont systemFontOfSize:12];
        _brief3.textColor = RGB(29, 30, 44);
        _brief3.numberOfLines = 0;
        _brief3.text = GetStringWithKeyFromTable(@"切勿截屏保存_label", LOCALIZABE, nil);
    }
    return _brief3;
}

-(UIButton *)nextStepButton{
    if(!_nextStepButton){
        _nextStepButton = [[UIButton alloc] init];
        _nextStepButton.backgroundColor = RGB(247, 156, 56);
        _nextStepButton.layer.cornerRadius = 20;
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_nextStepButton setTitle:GetStringWithKeyFromTable(@"下一步_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}

-(void)nextStepAction{
    WordBackUpScene *scene = [[WordBackUpScene alloc] init];
    scene.wallet = self.wallet;
    scene.words = self.uselessStr;
    [self.navigationController pushViewController:scene animated:YES];
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

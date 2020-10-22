//
//  ModifyWalletNameScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "ModifyWalletNameScene.h"
#import "Masonry.h"
@interface ModifyWalletNameScene ()

@property(nonatomic,strong) UIButton *saveButton;
@property(nonatomic,strong) UITextField *inputNameTextField;

@end

@implementation ModifyWalletNameScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"修改钱包名称_title", LOCALIZABE, nil)];
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.view addSubview:line];
    [self.view addSubview:self.inputNameTextField];
    [self.view addSubview:self.saveButton];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(0.7);
        make.top.mas_equalTo(75);
    }];
    [self.inputNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.bottom.equalTo(line.mas_top).offset(3);
        make.height.mas_equalTo(45);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(line);
        make.top.equalTo(line.mas_bottom).offset(30);
        make.height.mas_equalTo(40);
    }];
    
    // Do any additional setup after loading the view.
}

-(void)saveWalletNameAction{
    if(self.inputNameTextField.text.length > 15){
        return;
    }
    if(self.inputNameTextField.text.length == 0){
        return;
    }
    self.wallet.name = self.inputNameTextField.text;

    if(self.modifyNameBlock){
        self.modifyNameBlock(self.wallet);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
-(UIButton *)saveButton{
    if(!_saveButton){
        _saveButton = [[UIButton alloc] init];
        _saveButton.layer.cornerRadius = 20;
        _saveButton.layer.masksToBounds = YES;
        _saveButton.backgroundColor = CLICKABLE_COLOR;
        [_saveButton setTitle:GetStringWithKeyFromTable(@"保存_button", LOCALIZABE, nil) forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveWalletNameAction) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
}

-(UITextField *)inputNameTextField{
    if(!_inputNameTextField){
        _inputNameTextField = [[UITextField alloc] init];
        _inputNameTextField.placeholder = GetStringWithKeyFromTable(@"输入钱包名_placeHolder", LOCALIZABE, nil);
        _inputNameTextField.text = self.wallet.name;
    }
    return _inputNameTextField;
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

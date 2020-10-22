//
//  WalletDetailScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/14.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "WalletDetailScene.h"
#import "WalletDetailCell.h"
#import "UIImage+EasyExtend.h"
#import "UIButton+EnlargeTouchArea.h"
#import "PaymentSecretManager.h"
#import "WalletAddressScene.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "SecretScene.h"
#import "ModifyTradePwdScene.h"
#import "ResetTradePwdScene.h"
#import "ModifyWalletNameScene.h"
#import "WordsBriefScene.h"
#import "WordBackUpScene.h"
@interface WalletDetailScene ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@property (weak, nonatomic) IBOutlet UILabel *checkSecretTitle;
@property (weak, nonatomic) IBOutlet UILabel *modifyTradePasswordTitle;
@property (weak, nonatomic) IBOutlet UILabel *resetTradePasswordTitle;
@property (weak, nonatomic) IBOutlet UILabel *exportMnemonicTitle;


@property (weak, nonatomic) IBOutlet UIButton *deleteWalletButton;
@property (nonatomic, assign) BOOL isCurrentWallet;


@end

@implementation WalletDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"钱包_button", LOCALIZABE, nil)];
    if([[UserManager sharedInstance].wallet.account isEqualToString:self.wallet.account]){
        self.deleteWalletButton.hidden = YES;
    }
    [self setupView];
}

- (void)setupView{
    LocalWallet *currentWallet = [UserManager sharedInstance].wallet;
    self.isCurrentWallet = [currentWallet.account isEqualToString:self.wallet.account];
    [self.modifyButton setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    self.addressLabel.text = self.wallet.account;
    self.addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.nameLabel.text = self.wallet.name;
    self.checkSecretTitle.text = GetStringWithKeyFromTable(@"查看密钥_cell", LOCALIZABE, nil);
    self.modifyTradePasswordTitle.text = GetStringWithKeyFromTable(@"修改交易密码_cell", LOCALIZABE, nil);
    self.resetTradePasswordTitle.text = GetStringWithKeyFromTable(@"忘记交易密码_cell", LOCALIZABE, nil);
    self.exportMnemonicTitle.text = GetStringWithKeyFromTable(@"导出助记词_cell", LOCALIZABE, nil);
    [self.deleteWalletButton setTitle:GetStringWithKeyFromTable(@"删除钱包_button", LOCALIZABE, nil) forState:UIControlStateNormal];
    self.deleteWalletButton.layer.cornerRadius = 5;
    self.deleteWalletButton.layer.masksToBounds = YES;
}

//查看密钥
- (IBAction)checkSecretAction:(id)sender {
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak WalletDetailScene *weakSelf = self;
    manager.PaymemtSecretCurrectBlock = ^(NSString *secret) {
        SecretScene *scene = [[SecretScene alloc] init];
        scene.secret = secret;
        [weakSelf.navigationController pushViewController:scene animated:YES];
        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    };
    
    [manager presentSecretSceneWithSecretkey:self.wallet.secret];
}

//修改交易密码
- (IBAction)modifyTradePasswordAction:(id)sender {
    ModifyTradePwdScene *scene = [[ModifyTradePwdScene alloc] init];
    scene.model = self.wallet;
    scene.modifyblock = ^(NSString * _Nonnull secretkey) {
        if(self.isCurrentWallet){
            [UserManager sharedInstance].wallet.secret = secretkey;
        }
        self.wallet.secret = secretkey;
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
        [self.wallet update];
    };
    [self.navigationController pushViewController:scene animated:YES];
}

//忘记交易密码
- (IBAction)resetTradePasswordAction:(id)sender {
    ResetTradePwdScene *scene = [[ResetTradePwdScene alloc] init];
    scene.model = self.wallet;
    scene.resetBlock = ^(NSString * _Nonnull secretkey) {
        if(self.isCurrentWallet){
            [UserManager sharedInstance].wallet.secret = secretkey;
        }
        self.wallet.secret = secretkey;
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
        [self.wallet update];
    };
    [self.navigationController pushViewController:scene animated:YES];
}

//导出助记词.
- (IBAction)exportMnemonicAction:(id)sender {
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //支付密码
    PaymentSecretManager *manager = [PaymentSecretManager shareInstance];
    __weak WalletDetailScene *weakSelf = self;

    manager.PaymemtSecretCurrectBlock = ^(NSString *secretStr) {

            WordsBriefScene *scene = [[WordsBriefScene alloc] init];
            scene.wallet = weakSelf.wallet;
            scene.uselessStr = secretStr;
            [weakSelf.navigationController pushViewController:scene animated:YES];

        [IQKeyboardManager sharedManager].enable = YES;
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    };
    [manager presentSecretSceneWithSecretkey:self.wallet.secret];

}

//修改钱包名称
- (IBAction)onModify:(id)sender {
    ModifyWalletNameScene *scene = [[ModifyWalletNameScene alloc] init];
    scene.wallet = self.wallet;
    __weak WalletDetailScene *weakSelf = self;
    scene.modifyNameBlock = ^(LocalWallet * _Nonnull wallet) {
        if(self.isCurrentWallet){
            [UserManager sharedInstance].wallet.name = wallet.name;
        }
        weakSelf.wallet = wallet;
        [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
        [weakSelf.wallet update];
        weakSelf.addressLabel.text = wallet.account;
        weakSelf.nameLabel.text = wallet.name;
    };
    [self.navigationController pushViewController:scene animated:YES];
}

- (IBAction)onAddress:(id)sender {
    WalletAddressScene *scene = [[WalletAddressScene alloc] init];
    LocalWallet * wallet = [UserManager sharedInstance].wallet;
    scene.account = wallet.account;
    [self.navigationController pushViewController:scene animated:YES];
}

- (IBAction)deleteWalletAction:(id)sender {
    //支付密码
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    PaymentSecretManager *payment = [PaymentSecretManager shareInstance];
    __weak WalletDetailScene *weakSelf = self;
    payment.PaymemtSecretCurrectBlock = ^(NSString *secretStr) {
        //转账
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:GetStringWithKeyFromTable(@"是否删除该钱包_title", LOCALIZABE, nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"确定_button", LOCALIZABE, nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
            [weakSelf.wallet deleteObject];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"取消_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:confirmAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    };
    
    [payment presentSecretSceneWithSecretkey:weakSelf.wallet.secret];
    
}

@end

//
//  AddAssetsScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/13.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AddAssetsScene.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "PaymentSecretManager.h"
@interface AddAssetsScene ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *assetCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *issuerCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation AddAssetsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"添加_title", LOCALIZABE, nil)];
    self.assetCodeTextField.placeholder = GetStringWithKeyFromTable(@"资产代码_placeHolder", LOCALIZABE, nil);
    self.issuerCodeTextField.placeholder = GetStringWithKeyFromTable(@"发行商代码_placeHolder", LOCALIZABE, nil);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)saveButtonAction:(id)sender {
    [self saveActionWithPasword:@""];
}

-(void)saveActionWithPasword:(NSString *)password{
    [RequestManager getAssetsBaseValueWithProgress:NO account:self.issuerCodeTextField.text ledgerInddex:@"current" withFee:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *sequence = responseObject[@"sequence"];
        long flags = (long)responseObject[@"flags"];
        if((flags & 0x00800000) > 0){
            [RequestManager trustSetWithCurrency:self.assetCodeTextField.text fee:@"100" issuer:self.issuerCodeTextField.text sequence:sequence value:responseObject[@"value"] progress:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull response) {
                
                NSMutableDictionary *txDict = [[NSMutableDictionary alloc] init];
                txDict[@"TransactionType"] = @"TrustSet";
                txDict[@"Account"] = [UserManager sharedInstance].wallet.account;
                NSMutableDictionary *limitAmount = [[NSMutableDictionary alloc] init];
                limitAmount[@"issuer"] = response[@"LimitAmount"][@"issuer"];
                limitAmount[@"value"] = response[@"LimitAmount"][@"value"];
                limitAmount[@"currency"] = self.assetCodeTextField.text;
                txDict[@"LimitAmount"] = limitAmount;
                txDict[@"Fee"] = @"100";
                txDict[@"Flags"] = @"131072";
                txDict[@"Sequence"] = response[@"Sequence"];
                __weak AddAssetsScene *weakSelf = self;
                self.signWithTxjsonAndSecret = ^(id  _Nullable result) {
                    if([result isKindOfClass:[NSDictionary class]]){
                        [RequestManager transcationSubmitWithProgress:NO hash:result[@"hash"] txBlob:result[@"txBlob"] success:^(id  _Nonnull result) {
                            SYSTEM_SET_(@"1", NEEDRefreshCredit);
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        } warn:^(NSString * _Nonnull content) {
                            
                        } error:^(NSString * _Nonnull content) {
                            
                        } failure:^(NSError * _Nonnull error) {
                            
                        }];
                    }
                };
                NSString *secret = [[UserManager sharedInstance].wallet.secret AES128DecryptWithkey:password];
                [weakSelf signActionWithTxjson:[NSObject convertToJsonData:txDict] withSecret:secret];
            } warn:^(NSString * _Nonnull content) {
                
            } error:^(NSString * _Nonnull content) {
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
            }];
        }else{
            [self showString:GetStringWithKeyFromTable(@"无效发行商地址", LOCALIZABE, nil) delay:1.5];
        }
        
    } warn:^(NSString * _Nonnull content) {
        [self showString:content delay:1.5];
    } error:^(NSString * _Nonnull content) {
        [self showString:content delay:1.5];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
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

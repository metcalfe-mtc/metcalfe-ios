//
//  AccountMainScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/3.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AccountMainScene.h"
#import "CreateWalletScene.h"
#import "ImportMainScene.h"
#import "TabbarController.h"
#import "RequestManager.h"

@interface AccountMainScene ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *importButton;

@end

@implementation AccountMainScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self requestVersion];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.navigationController.delegate = self;
    self.createButton.layer.cornerRadius = 20;
    self.createButton.layer.masksToBounds = YES;
    self.importButton.layer.cornerRadius = 20;
    self.importButton.layer.masksToBounds = YES;
}

-(void)requestVersion{
    [RequestManager getVersionWithProgress:NO success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        if (![dic isKindOfClass:[NSNull class]]) {
            SYSTEM_SET_(dic[@"code"], VERSION);
            BOOL needupdate = [dic[@"upgrade"] boolValue];
            if(needupdate){
                BOOL forceUpdate = dic[@"force"];
                
                NSString *titleString = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"更新_massage", LOCALIZABE, nil),dic[@"version"]];
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:titleString
                                                                               message:dic[@"desc"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"现在升级_massage", LOCALIZABE, nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"url"]] options:@{} completionHandler:^(BOOL success) {
                                                                          }];
                                                                      }];
                
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"不,谢谢_massage", LOCALIZABE, nil) style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction * action) {
                                                                         //响应事件
                                                                         SYSTEM_SET_(@"1", KEEPNEW);
                                                                     }];
                [alert addAction:defaultAction];
                if(forceUpdate){
                    [alert addAction:cancelAction];
                }else{
                    SYSTEM_SET_(nil, KEEPNEW);
                }
                if(!SYSTEM_GET_(KEEPNEW)){
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }else{
                SYSTEM_SET_(nil, VERSION);
            }
        }
    } warn:^(NSString * _Nonnull content) {
        SYSTEM_SET_(nil, VERSION);
    } error:^(NSString * _Nonnull content) {
        SYSTEM_SET_(nil, VERSION);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        SYSTEM_SET_(nil, VERSION);
    }];
}

#pragma mark - action

- (IBAction)createClickAction:(id)sender {
    CreateWalletScene *scene = [[CreateWalletScene alloc] init];
    scene.createWalletSuccessBlock = ^{
        TabbarController * tabBarController = [[TabbarController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
    };
    [self.navigationController pushViewController:scene animated:YES];
}

- (IBAction)importClickAction:(id)sender {
    ImportMainScene *scene = [[ImportMainScene alloc] init];
    scene.importWalletSuccessBlock = ^{
        TabbarController * tabBarController = [[TabbarController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
    };
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isLoginType = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isLoginType animated:YES];
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

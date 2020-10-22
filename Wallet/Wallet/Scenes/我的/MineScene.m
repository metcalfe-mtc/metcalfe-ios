//
//  MineScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/4.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "MineScene.h"
#import "MineCell.h"
#import "WalletListManagerScene.h"
#import "AboutUsScene.h"
#import "WKWebScene.h"
#import "NSString+TEDecimalNumber.h"
#import "RequestManager.h"

@interface MineScene ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *needUpDate;
@property (nonatomic, strong) NSString *updateUrl;

@end

@implementation MineScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needUpDate = @"";
    [self setupView];
    [self requestVersion];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView{
    self.navigationController.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
}

-(void)requestVersion{
    [RequestManager getVersionWithProgress:NO success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *dic = responseObject;
        if (![dic isKindOfClass:[NSNull class]]) {
            SYSTEM_SET_(dic[@"code"], VERSION);
            self.needUpDate = [dic[@"upgrade"] boolValue]?@"1":@"0";
            self.updateUrl = dic[@"url"];
            [self.tableView reloadData];
        }
    } warn:^(NSString * _Nonnull content) {
        
    } error:^(NSString * _Nonnull content) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

//选择语言
- (void)selectLanguage{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *simple = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"中文_actionTitle", LOCALIZABE, nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[LanguageManager sharedInstance] changeNowLanguageWithLanguage:CNS];
    }];
    UIAlertAction *english = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"English_actionTitle", LOCALIZABE, nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [[LanguageManager sharedInstance] changeNowLanguageWithLanguage:EN];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"取消_actionTitle", LOCALIZABE, nil) style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [simple setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
    [english setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
    [cancel setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
    [alertVC addAction:simple];
    [alertVC addAction:english];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        cell.iconImage.image = [UIImage imageNamed:@"ic_qianbaoguanli"];
        cell.upDateButton.hidden = YES;
        cell.versionLabel.hidden = YES;
        cell.title.text = GetStringWithKeyFromTable(@"钱包管理_cell", LOCALIZABE, nil);
    }else if(indexPath.row == 1){
        cell.iconImage.image = [UIImage imageNamed:@"ic_fuwuxieyi"];
        cell.upDateButton.hidden = YES;
        cell.versionLabel.hidden = YES;
        cell.title.text = GetStringWithKeyFromTable(@"服务条款_cell", LOCALIZABE, nil);
    }else if(indexPath.row == 2){
        cell.iconImage.image = [UIImage imageNamed:@"ic_changjianwenti"];
        cell.upDateButton.hidden = YES;
        cell.versionLabel.hidden = YES;
        cell.title.text = GetStringWithKeyFromTable(@"常见问题_cell", LOCALIZABE, nil);
    }
    else if(indexPath.row == 3){
        cell.iconImage.image = [UIImage imageNamed:@"ic_guanyuwomen"];
        cell.upDateButton.hidden = YES;
        cell.versionLabel.hidden = YES;
        cell.title.text = GetStringWithKeyFromTable(@"关于我们_cell", LOCALIZABE, nil);
    }else if(indexPath.row == 4){
        cell.iconImage.image = [UIImage imageNamed:@"ic_xuanzeyuyan"];
        cell.upDateButton.hidden = YES;
        cell.versionLabel.hidden = YES;
        cell.title.text = GetStringWithKeyFromTable(@"语言选择_cell", LOCALIZABE, nil);
    }else if(indexPath.row == 5){
        cell.iconImage.image = [UIImage imageNamed:@"ic_banbenxinxi"];
        cell.arrowView.hidden = YES;
        if([self.needUpDate isEqualToString:@"1"]){
            cell.upDateButton.hidden = NO;
            cell.versionLabel.hidden = YES;
        }else if([self.needUpDate isEqualToString:@"0"]){
            cell.upDateButton.hidden = YES;
            cell.versionLabel.hidden = NO;
        }else{
            cell.upDateButton.hidden = YES;
            cell.versionLabel.hidden = YES;
        }
        
        cell.title.text = GetStringWithKeyFromTable(@"版本信息_cell", LOCALIZABE, nil);
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        WalletListManagerScene *scene = [[WalletListManagerScene alloc] init];
        scene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scene animated:YES];
    }else if(indexPath.row == 1){
        WKWebScene *scene = [[WKWebScene alloc] init];
        scene.hidesBottomBarWhenPushed = YES;
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_serviceAgreement?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];
        [self.navigationController pushViewController:scene animated:YES];
        
    }else if(indexPath.row == 2){
        WKWebScene *scene = [[WKWebScene alloc] init];
        scene.hidesBottomBarWhenPushed = YES;
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_faq?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];
        [self.navigationController pushViewController:scene animated:YES];
    }else if(indexPath.row == 3){
        WKWebScene *scene = [[WKWebScene alloc] init];
        scene.hidesBottomBarWhenPushed = YES;
        scene.url = [NSString stringWithFormat:@"%@api/custom/basic/redirect_aboutUs?lang=%@",BASE_URL_NORMAL,[NSString getCurrentLanguage]];        [self.navigationController pushViewController:scene animated:YES];
    }else if(indexPath.row == 4){
        [self selectLanguage];
    }
    else if(indexPath.row == 5){
        if([self.needUpDate isEqualToString:@"1"]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrl] options:@{} completionHandler:^(BOOL success) {
            }];
        }
    }
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

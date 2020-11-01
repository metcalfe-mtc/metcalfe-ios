//
//  AssetsScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/3.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AssetsScene.h"
#import "AssetsCell.h"
#import "AssetsFirstCell.h"
#import "AssetsLastCell.h"
#import "AddAssetsListScene.h"
#import "WalletListScene.h"
#import "RequestManager.h"
#import "WalletAddressScene.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "BalanceModel.h"
#import "AssetsDetailScene.h"
#import "MJRefresh.h"
#import "NSString+TEDecimalNumber.h"

@interface AssetsScene ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSString *marker;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (weak, nonatomic) IBOutlet UILabel *walletAddress;
@property (nonatomic,strong) NSMutableArray *balanceArr;
@property(nonatomic,strong) NSString *sequence;
@property(nonatomic,strong) NSString *freeze;

@end

@implementation AssetsScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"资产_title", LOCALIZABE, nil)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navigation_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setupView];
    [self requestList];
    [self requestVersion];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    LocalWallet * wallet = [UserManager sharedInstance].wallet;
    self.walletName.text = wallet.name;
    self.walletAddress.text = wallet.account;
//    self.walletAddress.lineBreakMode = NSLineBreakByTruncatingMiddle;
    if(SYSTEM_GET_(NEEDRefreshCredit) || SYSTEM_GET_(NEEDRefreshBalance)){
        [self requestList];
    }
}

-(void)rightItemAction{
    WalletListScene *scene = [[WalletListScene alloc] init];
    __weak AssetsScene *weakSelf = self;
    scene.walletSelectBlock = ^(LocalWallet * _Nonnull wallet) {
        [weakSelf.balanceArr removeAllObjects];
        [weakSelf.tableView reloadData];
        weakSelf.walletName.text = wallet.name;
        weakSelf.walletAddress.text = wallet.account;
//        weakSelf.walletAddress.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [weakSelf requestList];
    };
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)setupView{
    [self.tableView registerNib:[UINib nibWithNibName:@"AssetsCell" bundle:nil] forCellReuseIdentifier:@"AssetsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AssetsFirstCell" bundle:nil] forCellReuseIdentifier:@"AssetsFirstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AssetsLastCell" bundle:nil] forCellReuseIdentifier:@"AssetsLastCell"];
    LocalWallet *wallet = [UserManager sharedInstance].wallet;
    self.walletName.text = wallet.name;
    self.walletAddress.text = wallet.account;
    self.walletAddress.lineBreakMode = NSLineBreakByTruncatingMiddle;
    __weak AssetsScene *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestList];
    }];
}

- (IBAction)walletAddressAction:(id)sender {
    WalletAddressScene *scene = [[WalletAddressScene alloc] init];
    LocalWallet * wallet = [UserManager sharedInstance].wallet;
    scene.account = wallet.account;
    scene.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scene animated:YES];
}

#pragma mark - request
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


-(void)requestList{
    SYSTEM_SET_(nil, NEEDRefreshCredit);
    SYSTEM_SET_(nil, NEEDRefreshBalance);
    LocalWallet*wallet = [UserManager sharedInstance].wallet;
    [RequestManager getAssetsBaseValueWithProgress:NO account:wallet.account ledgerInddex:@"current" withFee:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.balanceArr removeAllObjects];
        BalanceModel *balance = [[BalanceModel alloc] init];
        self.sequence = responseObject[@"sequence"];
        [balance modelWithAccount:responseObject[@"account"] currency:DEFAULTCURRENCY balance:responseObject[@"balance"] baseFee:responseObject[@"baseFee"] ledgerIndex:responseObject[@"ledgerIndex"] sequence:responseObject[@"sequence"] decimals:[responseObject[@"decimals"] longValue]];
        [self.balanceArr addObject:balance];
        [RequestManager getAssetsSecValueWithProgress:NO account:wallet.account ledgerInddex:@"current" limit:@(10) marker:self.marker success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull response) {
            NSArray *lines = response[@"lines"];
            if(lines.count){
                for(int i = 0; i < lines.count; i++){
                    NSDictionary *line = lines[i];
                    BalanceModel *balance = [[BalanceModel alloc] init];
                    [balance modelWithAccount:line[@"account"] currency:line[@"currency"] balance:line[@"balance"] baseFee:@"0" ledgerIndex:@"0" sequence:line[@"sequence"] decimals:[line[@"decimalsLimit"] longValue]];
                    [self.balanceArr addObject:balance];
                }
            }
            NSString *countStr = [NSString stringWithFormat:@"%ld",self.balanceArr.count-1];
            NSString *reserveBase = responseObject[@"reserveBase"];
            NSString *reserveInc = responseObject[@"reserveInc"];
            self.freeze = [reserveBase calculateByAdding:[reserveInc calculateByMultiplying:countStr]];
            self.freeze = [self.freeze calculateByDividing:@"1000000"];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        } warn:^(NSString * _Nonnull content) {
            [self.tableView.mj_header endRefreshing];
        } error:^(NSString * _Nonnull content) {
            [self.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.tableView.mj_header endRefreshing];
        }];
    } warn:^(NSString * _Nonnull content) {
        [self.tableView.mj_header endRefreshing];
    } error:^(NSString * _Nonnull content) {
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableView Delegate && DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.balanceArr.count > 0?self.balanceArr.count+2:3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSInteger balanceAccount = self.balanceArr.count > 0?self.balanceArr.count:1;
    if(indexPath.row == 0){
        AssetsFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsFirstCell" forIndexPath:indexPath];
        //添加资产
        cell.creditBlock = ^{
            if(self.balanceArr.count > 0){
                AddAssetsListScene *scene = [[AddAssetsListScene alloc] init];
                scene.sequence = self.sequence;
                scene.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:scene animated:YES];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:GetStringWithKeyFromTable(@"未激活_alertTitle", LOCALIZABE, nil) message:GetStringWithKeyFromTable(@"激活需_alertMessage", LOCALIZABE, nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"关闭_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:action];
                [action setValue:RGB(231, 88, 84) forKey:@"titleTextColor"];
                [self presentViewController:alert animated:YES completion:nil];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == balanceAccount +1){
        AssetsLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsLastCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if(self.balanceArr.count == 0){
            AssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsCell" forIndexPath:indexPath];
            cell.balance.text = @"0";
            cell.currency.text = DEFAULTCURRENCY;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            BalanceModel *balance = self.balanceArr[indexPath.row-1];
            AssetsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetsCell" forIndexPath:indexPath];
            cell.balance.text = balance.balance;
            cell.currency.text = balance.currency;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger balanceCount = self.balanceArr.count > 0?self.balanceArr.count:1;
    if(indexPath.row == 0){
        return 45;
    }else if (indexPath.row == balanceCount +1){
        return 25;
    }else{
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.balanceArr.count == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:GetStringWithKeyFromTable(@"未激活_alertTitle", LOCALIZABE, nil) message:GetStringWithKeyFromTable(@"激活需_alertMessage", LOCALIZABE, nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"关闭_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [action setValue:RGB(231, 88, 84) forKey:@"titleTextColor"];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(indexPath.row != 0 && indexPath.row != self.balanceArr.count+1){
        AssetsDetailScene *scene = [[AssetsDetailScene alloc] init];
        if(indexPath.row == 1){
            scene.freezeStr = self.freeze;
        }
        scene.balance = self.balanceArr[indexPath.row-1];
        scene.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scene animated:scene];
    }
}
#pragma mark - DZNEmptyDataSetDelegate && DZNEmptyDataSetSource

//-------DZNEmptyDataSetDelegate----//////
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"img_no_data"];
//}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;{
    NSMutableAttributedString *tittle = [[NSMutableAttributedString alloc] initWithString:GetStringWithKeyFromTable(@"暂无资产_text",LOCALIZABE,nil)];
    [tittle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, tittle.length)];
    return tittle;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -60;
//}

#pragma mark - getter
-(NSMutableArray *)balanceArr{
    if(!_balanceArr){
        _balanceArr = [NSMutableArray array];
    }
    return _balanceArr;
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

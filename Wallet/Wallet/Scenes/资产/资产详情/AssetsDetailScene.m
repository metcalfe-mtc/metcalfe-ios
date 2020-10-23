//
//  AssetsDetailScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/15.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AssetsDetailScene.h"
#import "TransferOutScene.h"
#import "RequestManager.h"
#import "TranscationRecordCell.h"
#import "TranscationFirstCell.h"
#import "TranscationLastCell.h"
#import "TransferDetailScene.h"
#import "NSString+TEDecimalNumber.h"
#import "MJRefresh.h"
@interface AssetsDetailScene ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *availableTitle;
@property (weak, nonatomic) IBOutlet UILabel *balanceAmount;
@property (weak, nonatomic) IBOutlet UILabel *freeze;

@property (weak, nonatomic) IBOutlet UIButton *transferOutButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic ,assign) NSInteger currentPage;
@property(nonatomic ,strong) NSString *marker;
@property(nonatomic ,assign) NSInteger markerCount;
@property(nonatomic ,strong) NSArray *transactions;

@property(nonatomic,strong) NSString *sequence;

@end

@implementation AssetsDetailScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self setTitleViewWithWhiteTitle:self.balance.currency];
    self.availableTitle.text = GetStringWithKeyFromTable(@"可用_text", LOCALIZABE, nil);
    if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
        [self setupDateWithBalance:[self.balance.balance calculateBySubtracting:self.freezeStr] freeze:self.freezeStr];
    }else{
        [self setupDateWithBalance:self.balance.balance freeze:self.freezeStr];
    }
    self.currentPage = 1;
    self.markerCount = 3;
    [self.tableView registerNib:[UINib nibWithNibName:@"TranscationRecordCell" bundle:nil] forCellReuseIdentifier:@"TranscationRecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TranscationFirstCell" bundle:nil] forCellReuseIdentifier:@"TranscationFirstCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TranscationLastCell" bundle:nil] forCellReuseIdentifier:@"TranscationLastCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        [self requestListWithProgress:NO];
        [self requestBalancesList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currentPage = self.currentPage + 1;
        [self requestListWithProgress:NO];
    }];
    [self.transferOutButton setTitle:GetStringWithKeyFromTable(@"转出_button", LOCALIZABE, nil) forState:UIControlStateNormal];
    [self requestListWithProgress:YES];
    [self requestBalancesList];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupDateWithBalance:(NSString *)balance freeze:(NSString *)freeze{
    if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
        NSString *textStr = balance;
        self.freeze.text = [NSString stringWithFormat:@"%@ %@",GetStringWithKeyFromTable(@"冻结_text", LOCALIZABE, nil),freeze];
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        self.balanceAmount.attributedText = attribtStr;
    }else{
        NSString *textStr = balance;
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        self.balanceAmount.attributedText = attribtStr;
        self.freeze.text = @"";
    }
}

-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)requestListWithProgress:(BOOL)progress{
    LocalWallet *wallet = [UserManager sharedInstance].wallet;
    [RequestManager getTranscationRecordsWithProgress:YES account:wallet.account forward:NO ledgerIndexMax:@(-1) ledgerIndexMin:@(-1) limit:@(50) marker:self.marker success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSArray * allRecords = responseObject[@"transactions"];

        NSMutableArray *records = [NSMutableArray array];
        [allRecords enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            if([obj[@"transactionType"] isEqualToString:@"Payment"]){
                if([self.balance.currency isEqualToString:DEFAULTCURRENCY] && !obj[@"amount"][@"currency"]){
                        [records addObject:dict];
                }else{
                    if(obj[@"amount"][@"currency"] && [obj[@"amount"][@"currency"] isEqualToString:self.balance.currency]){
                        [records addObject:dict];
                    }
                }
            }
        }];
        self.transactions = records;
        if(self.transactions.count> 10*self.currentPage){
            [self endRefresh];
            self.transactions = [self.transactions subarrayWithRange:NSMakeRange(0, 10*self.currentPage)];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    } warn:^(NSString * _Nonnull content) {
        
    } error:^(NSString * _Nonnull content) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}

-(void)requestBalancesList{
    LocalWallet*wallet = [UserManager sharedInstance].wallet;
    [RequestManager getAssetsBaseValueWithProgress:NO account:wallet.account ledgerInddex:@"current" withFee:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSMutableArray *balanceArr = [NSMutableArray array];
        BalanceModel *balance = [[BalanceModel alloc] init];
        self.sequence = responseObject[@"sequence"];
        [balance modelWithAccount:responseObject[@"account"] currency:DEFAULTCURRENCY balance:responseObject[@"balance"] baseFee:responseObject[@"baseFee"] ledgerIndex:responseObject[@"ledgerIndex"] sequence:responseObject[@"sequence"]];
        [balanceArr addObject:balance];
        [RequestManager getAssetsSecValueWithProgress:NO account:wallet.account ledgerInddex:@"current" limit:@(10) marker:self.marker success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull response) {
            NSArray *lines = response[@"lines"];
            if(lines.count){
                for(int i = 0; i < lines.count; i++){
                    NSDictionary *line = lines[i];
                    BalanceModel *balance = [[BalanceModel alloc] init];
                    [balance modelWithAccount:line[@"account"] currency:line[@"currency"] balance:line[@"balance"] baseFee:@"0" ledgerIndex:@"0" sequence:line[@"sequence"]];
                    [balanceArr addObject:balance];
                }
            }
            NSString *countStr = [NSString stringWithFormat:@"%ld",balanceArr.count-1];
            NSString *reserveBase = responseObject[@"reserveBase"];
            NSString *reserveInc = responseObject[@"reserveInc"];
            self.freezeStr = [reserveBase calculateByAdding:[reserveInc calculateByMultiplying:countStr]];
            self.freezeStr = [self.freezeStr calculateByDividing:@"1000000"];
            [self setupDateWithBalance:[self getBalanceAvailableWithArr:balanceArr] freeze:self.freezeStr];
        } warn:^(NSString * _Nonnull content) {

        } error:^(NSString * _Nonnull content) {

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

        }];
    } warn:^(NSString * _Nonnull content) {

    } error:^(NSString * _Nonnull content) {

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

    }];
}

-(NSString *)getBalanceAvailableWithArr:(NSArray *)arr{
    NSString *available = @"0";
    for(int i = 0; i < arr.count; i++){
        BalanceModel *balance = arr[i];
        if([balance.currency isEqualToString:self.balance.currency]){
            available = balance.balance;
            if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
                if(balance.balance < 0){
                    available = @"0";
                }else if(available < self.freezeStr){
                    self.freezeStr = available;
                }
                available = [available calculateBySubtracting:self.freezeStr];
                
            }
        }
    }
    return available;
}


- (IBAction)transferOutAction:(id)sender {
    TransferOutScene *scene = [[TransferOutScene alloc] init];
    scene.balance = self.balance;
    scene.availableValue = self.balanceAmount.text;
    [self.navigationController pushViewController:scene animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.transactions.count>0){
        return self.transactions.count+2;
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        TranscationFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TranscationFirstCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.row == self.transactions.count + 1){
        TranscationLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TranscationLastCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSDictionary *dict = self.transactions[indexPath.row-1];
        TranscationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TranscationRecordCell" forIndexPath:indexPath];
        if([dict[@"account"] isEqualToString:[UserManager sharedInstance].wallet.account]){
            cell.transferType.text = GetStringWithKeyFromTable(@"转出_status", LOCALIZABE, nil);
            cell.transferType.textColor = RGB(0, 78, 254);
            if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
                cell.amount.text = [NSString stringWithFormat:@"- %@",[dict[@"amount"][@"value"] calculateByDividing:@"1000000"]];
            }else{
                cell.amount.text = [NSString stringWithFormat:@"- %@",dict[@"amount"][@"value"]];
            }
        }else{
            if([self.balance.currency isEqualToString:DEFAULTCURRENCY]){
                cell.amount.text = [NSString stringWithFormat:@"+ %@",[dict[@"amount"][@"value"] calculateByDividing:@"1000000"]];
            }else{
                cell.amount.text = [NSString stringWithFormat:@"+ %@",dict[@"amount"][@"value"]];
            }
            cell.transferType.text = GetStringWithKeyFromTable(@"转入_status", LOCALIZABE, nil);
            cell.transferType.textColor = RGB(255, 0, 0);
        }
        cell.status.text = [dict[@"transactionResult"] isEqualToString:@"tesSUCCESS"]?GetStringWithKeyFromTable(@"成功_status", LOCALIZABE, nil):GetStringWithKeyFromTable(@"失败_status", LOCALIZABE, nil);
        cell.time.text = [NSObject timeWithSecondStr:dict[@"date"] withFormatStyle:@"yyyy-MM-dd HH:mm:ss"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 49;
    }
    if(indexPath.row == self.transactions.count+1){
        return 25;
    }else{
        return 68;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row != 0 && indexPath.row != self.transactions.count+1){
        NSDictionary *dict = self.transactions[indexPath.row-1];
        TransferDetailScene *scene = [[TransferDetailScene alloc] init];
        scene.HashStr = dict[@"hash"];
        [self.navigationController pushViewController:scene animated:YES];
    }
}

#pragma mark - DZNEmptyDataSetDelegate && DZNEmptyDataSetSource

//-------DZNEmptyDataSetDelegate----//////
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return [UIImage imageNamed:@"img_no_data"];
//}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView;
{
    NSMutableAttributedString *tittle = [[NSMutableAttributedString alloc] initWithString:GetStringWithKeyFromTable(@"暂无交易记录_title",LOCALIZABE,nil)];
    [tittle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, tittle.length)];
    return tittle;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -60;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AddAssetsListScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/14.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AddAssetsListScene.h"
#import "AddAssetsScene.h"
#import "Masonry.h"
#import "AddAssetsListCell.h"
#import "RequestManager.h"
#import "BalanceModel.h"
#import "CreditModel.h"
#import "NSString+AES.h"
#import "NSString+COD.h"
#import "PaymentSecretManager.h"
#import "NSString+TEDecimalNumber.h"
#import "UIImageView+WebCache.h"
@interface AddAssetsListScene ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIView *headView;
@property(nonatomic,strong) UILabel *notice;
@property(nonatomic,strong) UILabel *noticeDetail;
@property(nonatomic,strong) NSArray *creditList;
@property(nonatomic,strong) NSMutableArray *currencyList;
@property(nonatomic,assign) CGFloat noticeHeight;
@property(nonatomic,strong) NSString *secretKey;
@property(nonatomic,strong) NSString *marker;
@end

@implementation AddAssetsListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"添加资产_title", LOCALIZABE, nil)];
    [self setupNavi];
    [self setupView];
    [self requestTokenList];
    // Do any additional setup after loading the view.
}

-(void)dealloc{
    
}

-(void)setupNavi{
//    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_addAssets"] style:UIBarButtonItemStylePlain target:self action:@selector(addAssetsAction)];
//    self.navigationItem.rightBarButtonItem = addItem;
}

-(void)addAssetsAction{
    AddAssetsScene *scene = [[AddAssetsScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

-(void)setupView{
    self.noticeHeight = 35 + [self getHeightByWidth:WIDTH-20 title:GetStringWithKeyFromTable(@"须知详情_text", LOCALIZABE, nil) font:[UIFont systemFontOfSize:12]];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.secretKey = [UserManager sharedInstance].wallet.secret;
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return ceil(height);
}

-(void)requestTokenList{
    LocalWallet*wallet = [UserManager sharedInstance].wallet;
    [RequestManager getAssetsSecValueWithProgress:NO account:wallet.account ledgerInddex:@"current" limit:@(10) marker:self.marker success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull response) {
        NSArray *lines = response[@"lines"];
        NSMutableArray *arrLines = [NSMutableArray array];
        self.currencyList = [NSMutableArray array];
        for(int i = 0; i < lines.count; i++){
            NSDictionary *line = lines[i];
            CreditModel *model = [[CreditModel alloc] init];
            [model setupWithIssuer:line[@"account"] currency:line[@"currency"] value:line[@"balance"]];
            model.credited = @"1";
            [arrLines addObject:model];
            [self.currencyList addObject:model.currency];
        }
        self.creditList = arrLines;

        [RequestManager getCreditTokenListWithProgress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSArray *tokens = responseObject;
            if(tokens.count > 0){
                NSMutableArray *arr = [NSMutableArray arrayWithArray:self.creditList];
                for(int i = 0; i < tokens.count; i++){
                    CreditModel *model = [[CreditModel alloc] init];
                    NSDictionary *tdict = tokens[i];
                    [model setupTokenWithDict:tokens[i]];
                    model.currency = tdict[@"currency"];
                    model.imgUrl = tdict[@"imgUrl"];
                    model.issuer = tdict[@"issuer"];
                    model.value = tdict[@"value"];
                    if([self.currencyList containsObject:model.currency]){
                        for(int j = 0; j<self.currencyList.count; j++){
                            NSString *currency = self.currencyList[j];
                            if([currency isEqualToString:model.currency]){
                                CreditModel *md = arr[j];
                                md.imgUrl = model.imgUrl;
                                arr[j] = md;
                            }
                        }
                    }else{
                        [arr addObject:model];
                    }
                }
                self.creditList = arr;
            }
            [self.tableView reloadData];
        } warn:^(NSString * _Nonnull content) {
            [self.tableView reloadData];
        } error:^(NSString * _Nonnull content) {
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            [self.tableView reloadData];
        }];
        
        
    } warn:^(NSString * _Nonnull content) {
        [self.tableView reloadData];
    } error:^(NSString * _Nonnull content) {
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [self.tableView reloadData];
    }];
    

}

-(void)requestCreditWithModel:(CreditModel *)model withType:(BOOL)type secret:(NSString *)secret{
    LocalWallet *wallet = [UserManager sharedInstance].wallet;
    [RequestManager getAssetsBaseValueWithProgress:NO account:wallet.account ledgerInddex:@"current" withFee:YES success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *sequence = responseObject[@"sequence"];
        [RequestManager trustSetWithCurrency:model.currency fee:@"100" issuer:model.issuer sequence:sequence value:model.value progress:NO success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull response) {

            NSMutableDictionary *txDict = [[NSMutableDictionary alloc] init];
            txDict[@"TransactionType"] = @"TrustSet";
            txDict[@"Account"] = [UserManager sharedInstance].wallet.account;
            NSMutableDictionary *limitAmount = [[NSMutableDictionary alloc] init];
            limitAmount[@"issuer"] = response[@"LimitAmount"][@"issuer"];
            limitAmount[@"value"] = type?response[@"LimitAmount"][@"value"]:@"0";
            limitAmount[@"currency"] = model.currency;
            txDict[@"LimitAmount"] = limitAmount;
            txDict[@"Fee"] = @"100";
            txDict[@"Flags"] = @"131072";
            txDict[@"Sequence"] = response[@"Sequence"];
            __weak AddAssetsListScene *weakSelf = self;
            [self showProgressHUDWithString:GetStringWithKeyFromTable(@"正在生成中_message", LOCALIZABE, nil)];
            self.signWithTxjsonAndSecret = ^(id  _Nullable result) {
                [weakSelf hideProgressHUDString];
                if([result isKindOfClass:[NSDictionary class]]){
                    [weakSelf showProgressHUDWithString:GetStringWithKeyFromTable(@"正在提交中_message", LOCALIZABE, nil)];
                    [RequestManager transcationSubmitWithProgress:NO hash:result[@"hash"] txBlob:result[@"txBlob"] success:^(id  _Nonnull result) {
                        [weakSelf hideProgressHUDString];
                        NSString *engineResult = result[@"data"][@"engineResult"];
                        if([engineResult isEqualToString:@"tesSUCCESS"]){
                            SYSTEM_SET_(@"1", NEEDRefreshCredit);
                            [weakSelf showString:GetStringWithKeyFromTable(@"成功_status", LOCALIZABE, nil) delay:1.5];
                        }else{
                            [weakSelf showString:[NSString stringWithFormat:@"%@",result[@"data"][@"engineResultMessage"]] delay:1.5];
                        }
                        [weakSelf requestTokenList];
                    } warn:^(NSString * _Nonnull content) {
                        [weakSelf hideProgressHUDString];
                    } error:^(NSString * _Nonnull content) {
                        [weakSelf hideProgressHUDString];
                    } failure:^(NSError * _Nonnull error) {
                        [weakSelf hideProgressHUDString];
                        [weakSelf showString:GetStringWithKeyFromTable(@"失败_status", LOCALIZABE, nil) delay:1.5];
                    }];
                }
            };
            [weakSelf signActionWithTxjson:[NSObject convertToJsonData:txDict] withSecret:secret];
        } warn:^(NSString * _Nonnull content) {

        } error:^(NSString * _Nonnull content) {

        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {

        }];
    } warn:^(NSString * _Nonnull content) {
        
    } error:^(NSString * _Nonnull content) {
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
    }];
}


-(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

#pragma mark - UITableView DataSource && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.creditList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreditModel *model = self.creditList[indexPath.section];
    AddAssetsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddAssetsListCell" forIndexPath:indexPath];
    cell.switchButton.tag = indexPath.section;
    cell.trustStatus = model.credited;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"ic_default"]];
    cell.currency.text = [NSString stringWithFormat:@"%@",model.currency];
    cell.account.text = model.issuer;
    if(model.credited){
        [cell.switchButton setImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
    }else{
        [cell.switchButton setImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
    }
    __weak AddAssetsListCell *weakCell = cell;
    __weak AddAssetsListScene *weakSelf = self;
    cell.trusted = ^(BOOL trust,NSInteger idx) {
        if([model.value calculateIsGreaterThan:@"0"] && !trust){
            [self showString:GetStringWithKeyFromTable(@"资产大于0，无法取消授信_massage", LOCALIZABE, nil) delay:1.5];
            return ;
        }else{
            //支付密码
            [IQKeyboardManager sharedManager].enable = NO;
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
            PaymentSecretManager *payment = [PaymentSecretManager shareInstance];
            payment.PaymemtSecretCurrectBlock = ^(NSString *secretStr) {
                //转账
                [weakSelf requestCreditWithModel:weakSelf.creditList[idx] withType:trust secret:secretStr];
                [IQKeyboardManager sharedManager].enable = YES;
                [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
                if(model.credited){
                    [weakCell.switchButton setImage:[UIImage imageNamed:@"ic_switch_off"] forState:UIControlStateNormal];
                }else{
                    [weakCell.switchButton setImage:[UIImage imageNamed:@"ic_switch_on"] forState:UIControlStateNormal];
                }
            };
            payment.PaymemtSecretCancleBlock = ^{

            };
            [payment presentSecretSceneWithSecretkey:weakSelf.secretKey];
        }
        
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark - getter
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, CGRectGetHeight(self.view.frame)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 10;
        _tableView.estimatedSectionFooterHeight = 0.001;
        [self.headView addSubview:self.notice];
        [self.headView addSubview:self.noticeDetail];
        _tableView.tableHeaderView = self.headView;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.001)];
        [_tableView registerNib:[UINib nibWithNibName:@"AddAssetsListCell" bundle:nil] forCellReuseIdentifier:@"AddAssetsListCell"];
    }
    return _tableView;
}

-(UIView *)headView{
    if(!_headView){
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.noticeHeight)];
        _headView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _headView;
}

-(UILabel *)notice{
    if(!_notice){
        _notice = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH-30, 25)];
        _notice.text = GetStringWithKeyFromTable(@"须知_text", LOCALIZABE, nil);
        _notice.font = [UIFont systemFontOfSize:15];
        _notice.textAlignment = NSTextAlignmentLeft;
        _notice.textColor = RGB(255, 0, 0);
    }
    return _notice;
}

-(UILabel *)noticeDetail{
    if(!_noticeDetail){
        _noticeDetail = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, WIDTH-20, self.noticeHeight-35)];
        _noticeDetail.text = GetStringWithKeyFromTable(@"须知详情_text", LOCALIZABE, nil);
        _noticeDetail.font = [UIFont systemFontOfSize:12];
        _noticeDetail.textAlignment = NSTextAlignmentLeft;
        _noticeDetail.textColor = RGB(152, 152, 152);
        _noticeDetail.numberOfLines = 0;
    }
    return _noticeDetail;
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

//
//  WalletListScene.m
//  SDWallet
//
//  Created by zzp-Mac on 2019/3/11.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "WalletListScene.h"
#import "Masonry.h"
#import "UIImage+EasyExtend.h"
#import "AssetWalletListCell.h"
#import "WalletDetailScene.h"
#import "MJRefresh.h"
#import "AddWalletSelectView.h"
#import "CreateWalletScene.h"
#import "ImportWalletScene.h"
#import "WalletListManagerScene.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "RequestManager.h"

@interface WalletListScene ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    UIButton *addButton;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)NSArray *walletsList;

@end

@implementation WalletListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getLocalWalletList];
}

- (void)configUI
{
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"钱包列表_title", LOCALIZABE, nil)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GetStringWithKeyFromTable(@"管理_rightItem", LOCALIZABE, nil) style: UIBarButtonItemStylePlain target:self action:@selector(managerWalletAction)];
//    NSDictionary * dict = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    self.view.backgroundColor = RGB(246, 246, 246);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    self.footView.frame = CGRectMake(0, 0, WIDTH, 0.001);

    self.tableView.tableFooterView = self.footView;
}

#pragma mark - action

-(void)managerWalletAction{
    WalletListManagerScene *scene = [[WalletListManagerScene alloc] init];
    [self.navigationController pushViewController:scene animated:YES];
}

//获取本地钱包列表
-(void)getLocalWalletList{
    [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
    self.walletsList = [LocalWallet findAll];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.walletsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalWallet *model = self.walletsList[indexPath.section];
    AssetWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetWalletListCell"];
    [cell setupCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocalWallet *currentWallet = [UserManager sharedInstance].wallet;
    LocalWallet *selectWallet = self.walletsList[indexPath.section];
    if([selectWallet.account isEqualToString:currentWallet.account]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [UserManager setDefaultWalletWithWallet:selectWallet];
        if(self.walletSelectBlock){
            self.walletSelectBlock(selectWallet);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }


}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    UIImage *image =[UIImage imageNamed:@"img_no_data"];
    return image;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = GetStringWithKeyFromTable(@"暂无相关数据_key00318", LOCALIZABE, nil);
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0f],
                                 NSForegroundColorAttributeName: RGB(115, 134, 153)};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -60;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = kWidth(10);
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        [_tableView registerNib:[UINib nibWithNibName:@"AssetWalletListCell" bundle:nil] forCellReuseIdentifier:@"AssetWalletListCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.0001)];
        headView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = headView;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        }];
    }
    
    return _tableView;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = BACKGROUNDCOLOR;
    }
    return _footView;
}
@end

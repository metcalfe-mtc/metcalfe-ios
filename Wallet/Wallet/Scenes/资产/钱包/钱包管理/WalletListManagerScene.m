//
//  WalletListManagerScene.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/25.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "WalletListManagerScene.h"
#import "UIImage+EasyExtend.h"
#import "RequestManager.h"
#import "MJRefresh.h"
#import "WalletModel.h"
#import "AddWalletSelectView.h"
#import "CreateWalletScene.h"
#import "ImportWalletScene.h"
#import "AssetWalletListCell.h"
#import "WalletListAdditionCell.h"
#import "WalletDetailScene.h"
#import "Masonry.h"
#import "ImportMainScene.h"
#import "CreateWalletScene.h"
@interface WalletListManagerScene ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *addButton;
@property (nonatomic,strong) NSArray *walletsList;
@property (nonatomic,assign) BOOL selected;
@end

@implementation WalletListManagerScene

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selected = NO;
    [self setupView];
    [self setupNavi];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getLocalWalletList];
}

-(void)setupView{
    [self.tableView registerNib:[UINib nibWithNibName:@"AssetWalletListCell" bundle:nil] forCellReuseIdentifier:@"AssetWalletListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletListAdditionCell" bundle:nil] forCellReuseIdentifier:@"WalletListAdditionCell"];
    self.view.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.backgroundColor = RGB(246, 246, 246);
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    self.footView = [[UIView alloc] init];
    self.tableView.tableFooterView = self.footView;
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.001);
    }];
}

-(void)setupNavi{
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"钱包管理_title", LOCALIZABE, nil)];
}


#pragma mark - action

//获取本地钱包列表
-(void)getLocalWalletList{
    [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
    self.walletsList = [LocalWallet findAll];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate && DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.walletsList.count + 1;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = RGB(246, 246, 246);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.walletsList.count == indexPath.section){
        WalletListAdditionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletListAdditionCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LocalWallet *model = self.walletsList[indexPath.section];
        AssetWalletListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetWalletListCell" forIndexPath:indexPath];
        [cell setupCellWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:1.5f];
    if(indexPath.section == self.walletsList.count){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *createAction = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"创建钱包_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CreateWalletScene *scene = [[CreateWalletScene alloc] init];
            scene.createWalletSuccessBlock = ^{
                [self getLocalWalletList];
            };
            [self.navigationController pushViewController:scene animated:YES];
        }];
        UIAlertAction *importAction = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"导入钱包_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ImportMainScene *scene = [[ImportMainScene alloc] init];
            scene.importWalletSuccessBlock = ^{
                [self getLocalWalletList];
            };
            [self.navigationController pushViewController:scene animated:YES];
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:GetStringWithKeyFromTable(@"取消_alertAction", LOCALIZABE, nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [createAction setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
        [importAction setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
        [cancleAction setValue:RGB(40, 40, 40) forKey:@"titleTextColor"];
        [alert addAction:createAction];
        [alert addAction:importAction];
        [alert addAction:cancleAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        LocalWallet *model = self.walletsList[indexPath.section];
        WalletDetailScene *scene = [[WalletDetailScene alloc] init];
        scene.wallet = model;
        [self.navigationController pushViewController:scene animated:YES];
    }

}



-(void)repeatDelay{
    self.selected = NO;
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

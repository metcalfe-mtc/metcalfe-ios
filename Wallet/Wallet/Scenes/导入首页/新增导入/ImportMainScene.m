//
//  ImportMainScene.m
//  Wallet
//
//  Created by 钱伟成 on 2019/9/6.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "ImportMainScene.h"
#import "TYTabPagerBar.h"
#import "TYPagerController.h"
#import "ImportWalletScene.h"
#import "WordsImportScene.h"
#import "TabbarController.h"
@interface ImportMainScene ()<TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate>
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic, strong) ImportWalletScene *mailScene;
@property (nonatomic, strong) WordsImportScene *mobileScene;

@property (nonatomic, strong) NSArray *datas;
@end

@implementation ImportMainScene

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleViewWithWhiteTitle:GetStringWithKeyFromTable(@"导入钱包_alertAction", LOCALIZABE, nil)];
    self.datas = @[GetStringWithKeyFromTable(@"助记词_title", LOCALIZABE, nil),GetStringWithKeyFromTable(@"密钥_title", LOCALIZABE, nil)];
    [self addTabPageBar];
    [self addPagerController];
    
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _tabBar.frame = CGRectMake(0, 0, WIDTH, 44);
    _pagerController.view.frame = CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-44);
}

- (void)addTabPageBar{
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.autoScrollItemToCenter = YES;
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.cellWidth = WIDTH/2;
    tabBar.layout.selectedTextFont = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    tabBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    tabBar.layout.selectedTextColor = RGB(247, 156, 56);
    tabBar.layout.normalTextColor = RGB(102, 102, 102);
    tabBar.layout.progressColor = RGB(247, 156, 56);
    tabBar.dataSource = self;
    tabBar.delegate = self;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:tabBar];
    _tabBar = tabBar;
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 1;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return _datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _datas[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return 2;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    if (index == 0) {
        WordsImportScene *scene = [[WordsImportScene alloc]init];
        scene.wordsImportSuccessBlock = ^{
            if(self.importWalletSuccessBlock){
                self.importWalletSuccessBlock();
                TabbarController * tabBarController = [[TabbarController alloc] init];
                [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
            }
        };
        return scene;
    }else{
        ImportWalletScene *scene = [[ImportWalletScene alloc]init];
        scene.secretImportSuccessBlock = ^{
            if(self.importWalletSuccessBlock){
                self.importWalletSuccessBlock();
                TabbarController * tabBarController = [[TabbarController alloc] init];
                [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
            }
        };
        return scene;
    }
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
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

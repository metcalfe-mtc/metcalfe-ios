//
//  TabbarController.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/4.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "TabbarController.h"
#import "BaseNavigationController.h"
#import "AssetsScene.h"
#import "MineScene.h"

@interface TabbarController ()<UINavigationControllerDelegate, UITabBarControllerDelegate>
@property (nonatomic, strong) BaseNavigationController * assetsNavi;                           // 资产
@property (nonatomic, strong) BaseNavigationController * mineNavi;                             // 我的

@property(nonatomic,assign) AssetsSceneType type;

@end

@implementation TabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
    // Do any additional setup after loading the view.
}

#pragma mark - Setup


- (void)setupTabBar{
    self.delegate = self;
    self.tabBar.tintColor = THEME_COLOR_BULE;
    self.tabBar.translucent = NO;
    [self setViewControllers:@[self.assetsNavi,
                               self.mineNavi]];
}

#pragma mark - tabbar delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}

#pragma mark - Getter
//资产
- (BaseNavigationController *)assetsNavi{
    if (!_assetsNavi) {
        AssetsScene * scene = [[AssetsScene alloc] init];
        _assetsNavi = [[BaseNavigationController alloc] initWithRootViewController:scene];
        _assetsNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,0);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:RGB(152, 152, 152)};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:THEME_COLOR_BULE};
        [_assetsNavi.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_assetsNavi.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = GetStringWithKeyFromTable(@"资产_tab", LOCALIZABE, nil);
        _assetsNavi.tabBarItem.title = title;
        _assetsNavi.tabBarItem.image = [[UIImage imageNamed:@"ic_assets_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _assetsNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_assets"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _assetsNavi;
}

//我的
- (BaseNavigationController *)mineNavi{
    if (!_mineNavi) {
        MineScene * scene = [[MineScene alloc] init];
        _mineNavi = [[BaseNavigationController alloc] initWithRootViewController:scene];
        _mineNavi.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
        NSDictionary * normalDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:RGB(152, 152, 152)};
        NSDictionary * selectDict = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                      NSForegroundColorAttributeName:THEME_COLOR_BULE};
        [_mineNavi.tabBarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
        [_mineNavi.tabBarItem setTitleTextAttributes:selectDict forState:UIControlStateSelected];
        NSString *title = GetStringWithKeyFromTable(@"我的_tab", LOCALIZABE, nil);
        _mineNavi.tabBarItem.title = title;
        _mineNavi.tabBarItem.image = [[UIImage imageNamed:@"ic_profile_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _mineNavi.tabBarItem.selectedImage = [[UIImage imageNamed:@"ic_profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _mineNavi;
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

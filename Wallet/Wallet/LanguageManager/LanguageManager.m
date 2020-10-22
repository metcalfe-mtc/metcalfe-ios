//
//  LanguageManager.m
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/5.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import "LanguageManager.h"
#import "AppDelegate.h"
#import "TabbarController.h"

@interface LanguageManager ()
@property(nonatomic,strong)NSBundle *bundle;
@end

@implementation LanguageManager
static LanguageManager *manager;

+(id)sharedInstance
{
    if (!manager)
    {
        manager = [[LanguageManager alloc]init];
    }
    
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initLanguage];
    }
    
    return self;
}

-(void)initLanguage
{
    NSString *path;
    //默认是系统语言
    NSString *language = SYSTEM_GET_(SET_LANGUAGE)? SYSTEM_GET_(SET_LANGUAGE): [NSObject getCurrentLanguage];
    
    //更改之前语言
    path = [[NSBundle mainBundle]pathForResource:language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table
{
    if (self.bundle)
    {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    
    return NSLocalizedStringFromTable(key, table, @"");
}

- (void)changeNowLanguageWithLanguage:(NSString *)language
{
    
    [self setNewLanguage:language];
}

-(void)setNewLanguage:(NSString *)language
{
    
    //找到需要改成的语言路径
    if ([language isEqualToString:EN] || [language isEqualToString:CNS] || [language isEqualToString:CNT])
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    
    NSLog(@"%@", language);
    SYSTEM_SET_(language, SET_LANGUAGE);
    [self resetRootViewController];
}

//重新设置
-(void)resetRootViewController
{
    TabbarController * tabBarController = [[TabbarController alloc] init];
    [[UIApplication sharedApplication] keyWindow].rootViewController = tabBarController;
}

@end

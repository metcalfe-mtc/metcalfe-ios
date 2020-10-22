//
//  LanguageManager.h
//  SDWallet
//
//  Created by 钱伟成 on 2019/3/5.
//  Copyright © 2019年 MTCChain. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,languageType) {
    languageCn,
    languageZhHant,
    languageZhHans,
    languageFa
};



NS_ASSUME_NONNULL_BEGIN

@interface LanguageManager : NSObject

#define GetStringWithKeyFromTable(key, tbl,commen) [[LanguageManager sharedInstance] getStringForKey:key withTable:tbl]

@property(nonatomic, assign)languageType type;

+(id)sharedInstance;

/**
 *  返回table中指定的key的值
 *
 *  @param key   key
 *  @param table table
 *
 *  @return 返回table中指定的key的值
 */
-(NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
 *  改变当前语言
 */
-(void)changeNowLanguageWithLanguage:(NSString *)language;

/**
 *  设置新的语言
 *
 *  @param language 新语言
 */
-(void)setNewLanguage:(NSString*)language;

@end

NS_ASSUME_NONNULL_END

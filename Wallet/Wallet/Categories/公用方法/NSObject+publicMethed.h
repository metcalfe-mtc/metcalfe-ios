//
//  NSObject+publicMethed.h
//  Exchange
//
//  Created by 钱伟成 on 2018/8/8.
//  Copyright © 2018年 thanosx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (publicMethed)

//获取当前语言环境
+(NSString *)getCurrentLanguage;

+ (UIImage *)getImageWithBase64StringWithString:(NSString *)string;

+(NSString *)getCurrentTimeTemp;

//返回二维码
+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size;

+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size centerImage:(UIImage *)centerImage;

//时间戳转换成时间

+(NSString *)timeWithSecondStr:(NSString *)second;

+(NSString *)timeWithSecondStr:(NSString *)second withFormatStyle:(NSString *)format;


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

//计时按钮
+ (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendCodeBtn;

//保存到相册
+ (void)loadImageFinished:(UIImage *)image baocunSuccess:(void(^)(void))baocunSuccess;


//登录前清除缓存
+ (void)clearDataBeginLogin;

//字典转json
+(NSString *)convertToJsonData:(NSDictionary *)dict;

//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)getIssuerWithCurrency:(NSString *)currency;

+ (BOOL)iphoneIsXScreen;


//参数签名
+(NSDictionary *)dictionaryWithAnotherParamsdic:(NSMutableDictionary *)dic;


//
+(NSString *)stringWithOrignal:(NSString *)orginal withMaxdigits:(int)digiti;

//isempty
+(BOOL)isEmptyString:(NSString *)orignal;

//保留num位有效数字
+(NSString *)saveNumAfterDotWithNum:(NSInteger)num string:(NSString *)string;

//保留num位有效数字（舍）
+(NSString *)saveNumGiveUpAfterDotWithNum:(NSInteger)num string:(NSString *)string;

//截取小数位后四位（舍）
+(NSString *)keepUpAfterDotWithNum:(NSInteger)num string:(NSString *)string;



@end

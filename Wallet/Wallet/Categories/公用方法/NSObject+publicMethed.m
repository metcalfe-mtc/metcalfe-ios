//
//  NSObject+publicMethed.m
//  Exchange
//
//  Created by 钱伟成 on 2018/8/8.
//  Copyright © 2018年 thanosx. All rights reserved.
//

#import "NSObject+publicMethed.h"
#import "BaseNavigationController.h"
#import <Photos/Photos.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#define SHA256KEY @"DD98103F53971CCEA5017F38082AA9D9"

@implementation NSObject (publicMethed)

//获取当前语言环境
+(NSString *)getCurrentLanguage{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    if(SYSTEM_GET_(SET_LANGUAGE)){
        NSString *languageStr = SYSTEM_GET_(SET_LANGUAGE);
        if([languageStr containsString:@"zh-Hant"]){
            return @"zh_tw";
        }else if([languageStr containsString:@"en"]){
            return @"en";
        }else if([languageStr containsString:@"zh-Hans"]){
            return @"zh";
        }
        else {
            return @"en";       //zh-Hans-CN
        }
    }
    else if([preferredLang containsString:@"zh-Hant"]){
        return @"zh_tw";
    }else if([preferredLang containsString:@"en"]){
        return @"en";
    }else if([preferredLang containsString:@"zh-Hans"]){
        return @"zh";
    }
    else {
        return @"en";       //zh-Hans-CN
    }
}

+ (UIImage *)getImageWithBase64StringWithString:(NSString *)string{
    
    NSString *encodedImageStr = string;
    
    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *decodedImage = [UIImage imageWithData:decodedImgData];
    return  decodedImage;
}

+(NSString *)getCurrentTimeTemp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    ;
    return timeString;
}

+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    return [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:170];
}

+ (UIImage *)codeImageWithString:(NSString *)string size:(CGFloat)size centerImage:(UIImage *)centerImage{
    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = string;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    // 6. 将CIImage转换成UIImage，并显示于imageView上 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:size];
    
    // 5.开启图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size,NO,[[UIScreen mainScreen] scale]);
    // 6.画二维码的图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 7.画程序员的图片
    UIImage *meImage = centerImage;
    CGFloat meImageW = image.size.width*68/236.0;
    CGFloat meImageH = image.size.width*68/236.0;
    CGFloat meImageX = (image.size.width - meImageW) * 0.5;
    CGFloat meImageY = (image.size.height - meImageH) * 0.5;
    [meImage drawInRect:CGRectMake(meImageX, meImageY, meImageW, meImageH)];
    // 8.获取图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 9.关闭图形上下文
    UIGraphicsEndImageContext();
    // 10.给imageView赋值
    return finalImage;
}

+(NSString *)timeWithSecondStr:(NSString *)second{
    
    NSTimeInterval interval    = [second doubleValue];
    if(second.length>12){
        interval = interval/1000;
    }
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

+(NSString *)timeWithSecondStr:(NSString *)second withFormatStyle:(NSString *)format;{
    NSTimeInterval interval = [second doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
+ (void)startTime:(NSInteger)time sendAuthCodeBtn:(UIButton *)sendAuthCodeBtn {
    if (time > 59 || time < 1) {
        time = 59;
    }
    __block NSInteger timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示
                [sendAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                NSString *title = @"获取验证码_key00014";
                [sendAuthCodeBtn setTitle:title forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:title forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = YES;
            });
        } else {
            NSInteger seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [sendAuthCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                // iOS 7
                [sendAuthCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateDisabled];
                sendAuthCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (void)loadImageFinished:(UIImage *)image baocunSuccess:(void(^)(void))baocunSuccess
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                imageAsset = obj;
                *stop = YES;
            }];
            if (imageAsset)
            {
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                NSLog(@"imageData = %@", imageData);
                                                                if(baocunSuccess){
                                                                    baocunSuccess();
                                                                }
                                                            }];
            }
        }
    }];
}
+(NSString *)convertToJsonData:(NSDictionary *)dict

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

//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (BOOL)iphoneIsXScreen{
    
    if (@available(iOS 11.0, *)) {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if(a > 0){
            return YES;
        }else{
            return NO;
        }
    } else {
        return NO;
    }
}

+(NSString *)stringWithOrignal:(NSString *)orginal withMaxdigits:(int)digiti
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    formatter.roundingMode = kCFNumberFormatterRoundDown;
    formatter.maximumFractionDigits  = digiti;
    NSNumber *temp = [formatter numberFromString:orginal];
    return [formatter stringFromNumber:temp];
}

+(BOOL)isEmptyString:(NSString *)orignal;
{
    if ([orignal isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if ([orignal isEqual:[NSNull null]]) {
        
        return YES;
    }
    if ([orignal isEqualToString:@""]) {
        
        return YES;
    }
    if (orignal == nil) {
        
        return YES;
    }
    if (orignal.length == 0) {
        
        return YES;
    }
    return NO;
}
+(NSDictionary *)dictionaryWithAnotherParamsdic:(NSMutableDictionary *)dic;
{
    
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    tempDic = dic;
    [tempDic setValue:[self dateTransformToTimeSp] forKey:@"timestamp"];
    [tempDic setValue:@"123" forKey:@"nonceStr"];
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    tempStr = [NSMutableString stringWithFormat:@"%@",[self sortedDictionary:tempDic]];
    NSString *nonceStr = [self hmacSHA256WithSecret:SHA256KEY content:tempStr];
//        NSString *nonceStr = [self hmacSHA256WithSecret:@"sign" content:@"name=张三李四wangwu&age=22"];

    [tempDic setValue:[self randomStringWithLength:30 String:nonceStr] forKey:@"nonceStr"];
    
    
    
    tempStr = [NSMutableString stringWithFormat:@"%@",[self sortedDictionary:tempDic]];
    
    NSString *nonceStr2 = [self hmacSHA256WithSecret:SHA256KEY content:tempStr];

    [tempDic setValue:nonceStr2 forKey:@"sign"];

    return tempDic;
}
- (NSString *)dateTransformToTimeSp
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;//客户端当前13位毫秒级时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%llu",recordTime];//时间戳转字符串(13位毫秒级时间戳字符串)
    return timeSp;
}
/**
 对字典(Key-Value)排序 区分大小写
 @param dict 要排序的字典
 */
- (NSString *)sortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    
    //序列化器对数组进行排序的block 返回值为排序后的数组
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id _Nonnull obj2) {
        //排序操作
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    //排序后的以key=value拼接的数组
    NSMutableArray *valueArray = [NSMutableArray array];
    for(NSString *sortSring in afterSortKeyArray){
        NSString *signSring = [NSString stringWithFormat:@"%@=%@",sortSring,[dict objectForKey:sortSring]];
        [valueArray addObject:signSring];
    }
    //[valueArray addObject:[NSString stringWithFormat:@"%@=%@",@"key",SHA256KEY]];
    
    // 就是用“,”把每个排序后拼接的数组，用字符串拼接起来
    NSString *string = [valueArray componentsJoinedByString:@"&"];
    return string;
}
- (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content
{
    const char *cKey  = [secret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [content cStringUsingEncoding:NSUTF8StringEncoding];// 有可能有中文 所以用NSUTF8StringEncoding -> NSASCIIStringEncoding
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}
-(NSString *)randomStringWithLength:(NSInteger)len String:(NSString *)letters {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

//保留num位有效数字
+(NSString *)saveNumAfterDotWithNum:(NSInteger)num string:(NSString *)string{
    NSNumberFormatter *format= [[NSNumberFormatter alloc] init];
    format.maximumFractionDigits = num;
    format.numberStyle = kCFNumberFormatterDecimalStyle;
    NSNumber *number = [format numberFromString:string];
    NSString *resultStr = [format stringFromNumber:number];
    return [resultStr stringByReplacingOccurrencesOfString:@"," withString:@""];
}

//保留num位有效数字（舍）
+(NSString *)saveNumGiveUpAfterDotWithNum:(NSInteger)num string:(NSString *)string{
    NSNumberFormatter *format= [[NSNumberFormatter alloc] init];
    format.maximumFractionDigits = num;
    format.numberStyle = kCFNumberFormatterDecimalStyle;
    format.roundingMode = kCFNumberFormatterRoundDown;
    NSNumber *number = [format numberFromString:string];
    NSString *resultStr = [format stringFromNumber:number];
    return [resultStr stringByReplacingOccurrencesOfString:@"," withString:@""];
}

//截取小数位后四位（舍）
+(NSString *)keepUpAfterDotWithNum:(NSInteger)num string:(NSString *)string{
    if([string containsString:@"."]){
        NSArray *stringArr = [string componentsSeparatedByString:@"."];
        NSString *numString = stringArr[0];
        NSString *dotString = stringArr[1];
        if(dotString.length > num){
            dotString = [dotString substringToIndex:num];
            stringArr = @[numString,dotString];
        }
        return [stringArr componentsJoinedByString:@"."];
    }
    return string;
}


@end

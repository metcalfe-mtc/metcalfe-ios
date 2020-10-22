//
//  NSString+COD.m
//  CutOrder
//
//  Created by yhw on 14-10-13.
//  Copyright (c) 2014年 YuQian. All rights reserved.
//

#import "NSString+COD.h"
#import <CommonCrypto/CommonDigest.h>

static NSString *const kSPECIAL_CHARACTER = @"!*'();:@&=+$,/?%#[]";
@implementation NSString (COD)

- (NSString *)cod_md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);// This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
+ (NSString*)cod_getMD5WithData:(NSData *)data{
    const char* cStr = (const char *)[data bytes];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);// This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
    
}


- (NSString *)cod_urlEncoded {
	if (![self length])
		return @"";

	CFStringRef static const charsToEscape = CFSTR(".:/");
	CFStringRef escapedString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
	                                                                    (__bridge CFStringRef)self,
	                                                                    NULL,
	                                                                    charsToEscape,
	                                                                    kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)escapedString;
}

- (NSString *)cod_urlDecoded {
	if (![self length])
		return @"";

	CFStringRef unescapedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
	                                                                                      (__bridge CFStringRef)self,
	                                                                                      CFSTR(""),
	                                                                                      kCFStringEncodingUTF8);
	return (__bridge_transfer NSString *)unescapedString;
}

- (BOOL)cod_isChinaMobile {
    NSString *regex = @"^1[0-9][0-9]\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)cod_isVerificationCode {
    NSString *regex = @"^[0-9]{6}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (NSInteger)cod_wordCount {
    NSUInteger i, n = [self length], l = 0,a = 0,b = 0;
    unichar c;
    for(i = 0;i < n;i++){
        c = [self characterAtIndex:i];
        if(isblank(c)) {
            b++;
        } else if(isascii(c)){
            a++;
        } else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(NSUInteger)ceilf((float)(a+b)/2.0);
}


- (NSString *)MD5Encode {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString *string = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                        ];
    return [string lowercaseString];
}

@end

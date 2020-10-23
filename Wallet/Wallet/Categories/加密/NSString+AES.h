//
//  NSString+AES.h
//  
//
//  Created by Bear on 16/11/26.
//  Copyright © 2016年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

///**< 加密方法 */
//- (NSString*)aci_encryptWithAES;
//
///**< 解密方法 */
//- (NSString*)aci_decryptWithAES;
//
///**< 自带Key加密方法 */
//- (NSString*)aci_encryptWithAESWithKey:(NSString *)key;
//
///**< 自带Key解密方法 */
//- (NSString*)aci_decryptWithAESWithKey:(NSString *)key;


-(NSString *)AES128EncryptWithkey:(NSString *)key;

-(NSString *)AES128DecryptWithkey:(NSString *)key;

@end

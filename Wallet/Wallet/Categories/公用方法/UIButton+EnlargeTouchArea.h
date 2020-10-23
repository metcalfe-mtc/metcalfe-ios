//
//  UIButton+EnlargeTouchArea.h
//  BtnClickDemo
//
//  Created by apple on 2018/6/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left; 
@end

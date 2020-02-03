//
//  UIView+Categories.h
//  TestRefresh
//
//  Created by 颜欢 on 2020/2/1.
//  Copyright © 2020 颜欢. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Categories)


/// 设置View任意角的圆角
/// @param corners 角
/// @param radius 圆角半径
-(void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius;



/// 设置View任意角的圆角和边框
/// @param corners 角
/// @param radius 圆半径
/// @param borderColor 边框颜色
/// @param borderWidth 边框宽
-(void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;


@end

NS_ASSUME_NONNULL_END

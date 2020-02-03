//
//  UIView+Categories.m
//  TestRefresh
//
//  Created by 颜欢 on 2020/2/1.
//  Copyright © 2020 颜欢. All rights reserved.
//

#import "UIView+Categories.h"




@implementation UIView (Categories)

- (void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    
   
     UIBezierPath *round = [UIBezierPath bezierPathWithRoundedRect:self.frame byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = self.bounds;
    shape.path = round.CGPath;
   
    
    
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.strokeColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:shape];
    self.layer.mask = shape;
   
    
}

- (void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
      UIBezierPath *round = [UIBezierPath bezierPathWithRoundedRect:self.frame byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.frame = self.bounds;
        shape.path = round.CGPath;
       
        
        
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.strokeColor = borderColor.CGColor;
         shape.lineWidth = borderWidth;
        [self.layer addSublayer:shape];
        self.layer.mask = shape;
       
}

@end


//
//  UIColor+Hex.h
//  ZmeetDemo
//
//  Created by bingo on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor(Hex)

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alphaValue;

@end

NS_ASSUME_NONNULL_END

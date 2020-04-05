//
//  UIColor+HexString.m
//  RSSchool_T3
//
//  Created by Фёдор Морев on 4/5/20.
//  Copyright © 2020 Alexander Shalamov. All rights reserved.
//

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]

#import "UIColor+HexString.h"

@implementation UIColor(HexString)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return UIColorFromRGB(rgbValue);
}

+ (NSString*)getHexFromR:(int)r G:(int)g B:(int)b {
    NSString* hexString = [NSString stringWithFormat:@"0x%02lX%02lX%02lX", lroundf(r), lroundf(g), lroundf(b)];
    return hexString;
}


@end

//
//  UIColor+HexString.h
//  RSSchool_T3
//
//  Created by Фёдор Морев on 4/5/20.
//  Copyright © 2020 Alexander Shalamov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(HexString)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (NSString*)getHexFromR:(int)r G:(int)g B:(int)b;
@end

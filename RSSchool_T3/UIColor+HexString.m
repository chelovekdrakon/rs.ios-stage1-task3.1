//
//  UIColor+HexString.m
//  RSSchool_T3
//
//  Created by Фёдор Морев on 4/5/20.
//  Copyright © 2020 Alexander Shalamov. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor(HexString)

+ (NSString*)getHexFromR:(int)r G:(int)g B:(int)b {
    NSString* hexString = [NSString stringWithFormat:@"0x%02lX%02lX%02lX", lroundf(r), lroundf(g), lroundf(b)];
    return hexString;
}


@end

#import "PolynomialConverter.h"

@implementation PolynomialConverter

- (NSString*)convertToStringFrom:(NSArray <NSNumber*>*)numbers {
    int arraySize = (int)numbers.count;
    
    if (numbers.count == 0) {
        return nil;
    }
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (int i = (arraySize - 1); i >= 0; i--) {
        NSNumber *number = numbers[i];
        int coef = (arraySize - 1) - i;
        NSString *stringNumber = [self conertNumberToString:number withCoef:coef];
        
        if (stringNumber != nil) {
            [resultArray addObject:stringNumber];
            
            BOOL isLastOne = (i == 0);
            if (!isLastOne) {
                NSString *sign = [NSString stringWithFormat:@"%@", number.intValue > 0 ? @"+" : @"-"];
                [resultArray addObject:sign];
            }
        }
    }
    
    NSArray *reversedArray = [[resultArray reverseObjectEnumerator] allObjects];
    NSString *result = [reversedArray componentsJoinedByString:@" "];
    
    return result;
}

- (NSString *)conertNumberToString:(NSNumber *)number withCoef:(int)coef {
    if ([number isEqualToNumber:@(0)]) {
        return nil;
    }
    
    int absValue = abs(number.intValue);
    
    if (coef == 0) {
        return [NSString stringWithFormat:@"%@", @(absValue)];
    } if (coef == 1) {
        if (absValue > 1) {
            return [NSString stringWithFormat:@"%@x", @(absValue)];
        } else {
            return [NSString stringWithFormat:@"x"];
        }
    } else {
        if (absValue > 1) {
            return [NSString stringWithFormat:@"%@x^%@", @(absValue), @(coef)];
        } else {
            return [NSString stringWithFormat:@"x^%@", @(coef)];
        }
    }
}

@end

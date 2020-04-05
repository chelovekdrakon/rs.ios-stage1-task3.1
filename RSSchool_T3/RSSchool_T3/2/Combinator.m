#import "Combinator.h"

// m - number of posters to design
// n - total number of available colors
// return x - number of colors for each poster so that each poster has a unique combination of colors and the number of combinations is exactly the same as the number of posters

@implementation Combinator
- (NSNumber*)chechChooseFromArray:(NSArray <NSNumber*>*)array {
    int m = array[0].intValue;
    int n = array[1].intValue;
    
    if (m < 1 || n < 0) {
        return nil;
    }
    
    NSUInteger k = 0;
    NSUInteger tmp = 0;
    
    BOOL isRandom = NO;
    
    while(tmp < m) {
        k++;
        NSUInteger next = [self getMfromN:n andK:k];
        
        if (next < tmp) {
            isRandom = YES;
            break;
        } else {
            tmp = next;
        }
    }
    
    return isRandom ? nil : @(k);
}

- (NSUInteger)getMfromN:(NSUInteger)n andK:(NSUInteger)k {
    NSUInteger dividend = [self factorial:n];
    NSUInteger divider = [self factorial:k] * [self factorial:(n - k)];
    return dividend / divider;
}

- (NSUInteger)factorial:(NSUInteger)n {
    NSUInteger res = 1;
    
    for (int i = 1; i <= n; i++) {
        res *= i;
    }
    
    return res;
}

@end

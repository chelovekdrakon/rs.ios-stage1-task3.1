#import "ViewController.h"

const CGFloat PADDING_TOP = 100;
const CGFloat PADDING_LEFT = 16;
const CGFloat PADDING_RIGHT = 32;

CGFloat RESULT_LABEL_WIDTH = 100;
CGFloat RESULT_CONTAINER_HEIGHT = 50;

CGFloat INPUT_LABEL_WIDTH = 65;
CGFloat INPUT_CONTAINER_HEIGHT = 50;

@interface ViewController()

@property(nonatomic, assign) CGSize screenSize;
@property(nonatomic, retain) UILabel *resultLabel;
@property(nonatomic, retain) UILabel *resultView;

@end


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                 blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                alpha:1.0]


@implementation ViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.accessibilityIdentifier = @"mainView";
    
    self.screenSize = [UIScreen mainScreen].bounds.size;
    
    UIView *resultView = [self getResultView];
    resultView.frame = CGRectMake(PADDING_LEFT,
                                  PADDING_TOP,
                                  resultView.bounds.size.width,
                                  resultView.bounds.size.height);
    [self.view addSubview:resultView];
    
    UIView *colorsInput = [self getColorsInput];
    colorsInput.frame = CGRectMake(0,
                                   PADDING_TOP + resultView.bounds.size.height + 30,
                                   colorsInput.bounds.size.width,
                                   colorsInput.bounds.size.height);
    [self.view addSubview:colorsInput];
}

- (UIView *)getResultView {
    NSString *defaultHex = @"6x646464";
    
    CGFloat viewWidth = self.screenSize.width - (PADDING_LEFT + PADDING_RIGHT);
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, RESULT_CONTAINER_HEIGHT)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               RESULT_LABEL_WIDTH,
                                                               INPUT_CONTAINER_HEIGHT)];
    label.accessibilityIdentifier = @"Color";
    label.text = defaultHex;

    UIColor *color = [self colorFromHexString:defaultHex];
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(RESULT_LABEL_WIDTH,
                                                                 0,
                                                                 viewWidth - RESULT_LABEL_WIDTH,
                                                                 RESULT_CONTAINER_HEIGHT)];
    colorView.backgroundColor = color;
    colorView.accessibilityIdentifier = @"viewResultColor";
    
    [container addSubview:label];
    [container addSubview:colorView];
    
    return container;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return UIColorFromRGB(rgbValue);
}

- (UIView *)getColorsInput {
    NSArray *colors = @[@"Red", @"Green", @"Blue"];
    CGFloat step = 80;
    
    CGFloat containerHeight = (INPUT_CONTAINER_HEIGHT + step) * colors.count;
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenSize.width, containerHeight)];
    
    for (int i = 0; i < colors.count; i++) {
        NSString *colorName = colors[i];
        
        UIView *view = [self getRowWithName:colorName];
        view.frame = CGRectMake(PADDING_LEFT, i * step, view.bounds.size.width, view.bounds.size.height);
        
        [container addSubview:view];
    }
    
    return container;
}

- (UIView *)getRowWithName:(NSString *)name {
    CGFloat viewWidth = self.screenSize.width - (PADDING_LEFT + PADDING_RIGHT);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, INPUT_CONTAINER_HEIGHT)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, INPUT_LABEL_WIDTH, INPUT_CONTAINER_HEIGHT)];
    label.text = [name uppercaseString];
    label.accessibilityIdentifier = [NSString stringWithFormat:@"label%@", name];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(INPUT_LABEL_WIDTH,
                                                                           0,
                                                                           (viewWidth - INPUT_LABEL_WIDTH),
                                                                           INPUT_CONTAINER_HEIGHT)];
    textField.accessibilityHint = @"0..255";
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.cornerRadius = 5;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, INPUT_CONTAINER_HEIGHT)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @"0..255";
    textField.accessibilityIdentifier = [NSString stringWithFormat:@"textField%@", name];
    
    [view addSubview:label];
    [view addSubview:textField];
    
    return view;
}



@end

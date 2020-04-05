#import "ViewController.h"

#import "UIColor+HexString.h"

const CGFloat PADDING_TOP = 64;
const CGFloat PADDING_LEFT = 16;
const CGFloat PADDING_RIGHT = 32;

CGFloat RESULT_LABEL_WIDTH = 100;
CGFloat RESULT_CONTAINER_HEIGHT = 50;

CGFloat INPUT_LABEL_WIDTH = 65;
CGFloat INPUT_CONTAINER_HEIGHT = 50;

@interface ViewController()

@property(nonatomic, assign) CGSize screenSize;
@property(nonatomic, weak) UILabel *resultLabel;
@property(nonatomic, weak) UIView *resultView;
// R --> G --> B text fields should be added one by one
@property(nonatomic, strong) NSMutableArray *RGBFields;

@end


@implementation ViewController

# pragma mark - Lifecycle hooks

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.RGBFields = [NSMutableArray array];
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
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.frame = CGRectMake(0, 0, 100, 100);
    actionButton.center = CGPointMake(self.screenSize.width / 2, colorsInput.bounds.origin.x + colorsInput.bounds.size.height + 30);
    [actionButton setTitle:@"Process" forState:UIControlStateNormal];
    [actionButton addTarget:self
                     action:@selector(onButtonPress)
           forControlEvents:UIControlEventTouchUpInside];
    actionButton.accessibilityIdentifier = @"buttonProcess";
    
    [self.view addSubview:actionButton];
}

- (void)handleError {
    self.resultLabel.text = @"Error";
    self.resultLabel.textColor = [UIColor redColor];
    self.resultView.backgroundColor = [UIColor whiteColor];
}

- (void)onButtonPress {
    UITextField *redField = self.RGBFields[0];
    UITextField *greenField = self.RGBFields[1];
    UITextField *blueField = self.RGBFields[2];
    
    // Validate Text
    
    if ((redField.text.length == 0) || (greenField.text.length == 0) || (blueField.text.length == 0)) {
        [self handleError];
        return;
    }
    
    NSCharacterSet *numericCharactersSet = [NSCharacterSet decimalDigitCharacterSet];
    
    NSString *concatStrings = [NSString stringWithFormat:@"%@%@%@", redField.text, greenField.text, blueField.text];
    NSRange rangeOfNonNumeric = [concatStrings rangeOfCharacterFromSet:numericCharactersSet.invertedSet options:kNilOptions];
    if (rangeOfNonNumeric.location != NSNotFound) {
        [self handleError];
        return;
    }
    
    // Validate Numbers
    
    int redValue = [redField.text intValue];
    int greenValue = [greenField.text intValue];
    int blueValue = [blueField.text intValue];
    
    BOOL isRedValueNotOk = redValue < 0 || redValue > 255;
    BOOL isGreenValueNotOk = greenValue < 0 || redValue > 255;
    BOOL isBlueValueNotOk = blueValue < 0 || redValue > 255;
    
    if (isRedValueNotOk || isGreenValueNotOk || isBlueValueNotOk) {
        [self handleError];
        return;
    }
    
    // Apply processing
    
    self.resultView.backgroundColor = [UIColor colorWithRed:redValue / 255.0
                                                      green: greenValue / 255.0
                                                       blue: blueValue / 255.0
                                                      alpha:1.00];
    
    self.resultLabel.text = [UIColor getHexFromR:redValue G:greenValue B:blueValue];

    redField.text = @"";
    greenField.text = @"";
    blueField.text = @"";
}

# pragma mark - UI rendering

- (UIView *)getResultView {
    CGFloat viewWidth = self.screenSize.width - (PADDING_LEFT + PADDING_RIGHT);
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, RESULT_CONTAINER_HEIGHT)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               RESULT_LABEL_WIDTH,
                                                               INPUT_CONTAINER_HEIGHT)];
    label.accessibilityIdentifier = @"labelResultColor";
    label.text = @"Color";

    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(RESULT_LABEL_WIDTH,
                                                                 0,
                                                                 viewWidth - RESULT_LABEL_WIDTH,
                                                                 RESULT_CONTAINER_HEIGHT)];
    colorView.accessibilityIdentifier = @"viewResultColor";
    
    [container addSubview:label];
    [container addSubview:colorView];
    
    self.resultLabel = label;
    self.resultView = colorView;
    
    return container;
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
    textField.layer.borderWidth = 1;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.cornerRadius = 5;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, INPUT_CONTAINER_HEIGHT)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder = @"0..255";
    textField.accessibilityIdentifier = [NSString stringWithFormat:@"textField%@", name];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    
    [view addSubview:label];
    [view addSubview:textField];
    
    [self.RGBFields addObject:textField];
    
    return view;
}

# pragma mark - TextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)TextField {
    if (![self.resultLabel.text isEqual:@"Color"]) {
        self.resultLabel.text = @"Color";
        self.resultLabel.textColor = [UIColor blackColor];
        self.resultView.backgroundColor = [UIColor whiteColor];
    }
}

@end

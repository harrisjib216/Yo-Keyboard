//
//  KeyboardViewController.m
//  YoKey
//
//  Created by development on 1/30/22.
//

#import "KeyboardViewController.h"
#import "KeyboardKey.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

@synthesize showCapitalLetters;
@synthesize showEmojiKeyboard;
@synthesize currentLanguage;
@synthesize currentMessage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 11 -         414w x 243h
    // 12 mini -    360w x 224h
    // 13 pro max - 428w x 243
    
    // add each key to the view ✅
    // style each key ✅
    // define cusom actions ✅
    // make emoji slider
    // draw custom features
    [self setCurrentLanguage: @"en"];
    [self setCurrentMessage: @""];
    [self renderDefaultKeyboard];
}

//
- (void)renderDefaultKeyboard {
    // rows of keys
    NSArray *row1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"😀"];
    NSArray *row2 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"⬆️"];
    NSArray *row3 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"j", @"k", @"l", @"↩️"];
    NSArray *row4 = @[@"-", @"?", @"x", @"c", @"v", @"b", @"n", @"m", @".", @",", @"⬅️"];
    NSArray *row5 = @[@"space", @"🇺🇸", @"🇲🇽", @"🇷🇺", @"🇯🇵"];

    [self addRowOfKeys: row1 rowLevel: 0];
    [self addRowOfKeys: row2 rowLevel: 1];
    [self addRowOfKeys: row3 rowLevel: 2];
    [self addRowOfKeys: row4 rowLevel: 3];
    [self addRowOfKeys: row5 rowLevel: 4];
}

// inserts the key, styles it, add the onPress handlers
- (void) addRowOfKeys:(NSArray *)row rowLevel:(int)level {
    // convert into properties
    const int keyMargin = 7;
    const float keyWidth = ([_keyboardContainer bounds].size.width - (10 * (keyMargin / 2))) / 11;
    float keyHeight = ([_keyboardContainer bounds].size.height - 7) / 5;
    
    float xPosition = 0;
    float yPosition = level * (keyHeight + 5);
    KeyboardKey *tempKey;
    
    if (level == 4) {
        xPosition = (keyWidth + keyMargin) * 2;
        keyHeight = ([_keyboardContainer bounds].size.height - 7) / 7;
    }

    for (NSString *key in row) {
        // shape and color
        tempKey = [KeyboardKey buttonWithType: UIButtonTypeCustom];
        [tempKey setTitle: key forState: UIControlStateNormal];
        [tempKey setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [tempKey setBackgroundColor: [UIColor systemGray5Color]];
        [tempKey layer].cornerRadius = 5;
        
        // shadow
        [tempKey layer].shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
        [tempKey layer].shadowOffset = CGSizeMake(0, 2.0f);
        [tempKey layer].shadowOpacity = 1.0f;
        [tempKey layer].shadowRadius = 0.0f;
        [tempKey layer].masksToBounds = NO;
        [tempKey layer].cornerRadius = 4.0f;

        // position
        if ([key isEqual: @"space"]) {
            tempKey.frame = CGRectMake(xPosition, yPosition, 100.0, keyHeight);
            xPosition += 100.0 + keyMargin;
        } else {
            tempKey.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
            xPosition += keyWidth + keyMargin;
        }
        
        // add event handler
        [tempKey setLabel: key];
        [tempKey addTarget: self action: @selector(onKeyPress:) forControlEvents: UIControlEventTouchDown];
        
        // append to the container
        [_keyboardContainer addSubview: tempKey];
    }
}

- (void) onKeyPress: (KeyboardKey *) sender {
    const NSDictionary *languageKeys = @{
        @"🇺🇸": @"en",
        @"🇲🇽": @"es",
        @"🇷🇺": @"ru",
        @"🇯🇵": @"ja",
    };
    
    NSString *newLanguage = [languageKeys objectForKey: sender.label];
    if (newLanguage != nil && newLanguage != self.currentLanguage) {
        // translate text
        [self translateText: newLanguage];
        [self setCurrentLanguage: newLanguage];
    }
    else if ([sender.label isEqual: @"😀"]) {
        // todo: build and open emoji keyboard
    }
    else if ([sender.label isEqual: @"⬆️"]) {
        // shift key: toggle capitalization of each letter
        if (self.showCapitalLetters) {
            [self lowercaseTheKeyboard];
        } else {
            [self capitializeTheKeyboard];
        }
    }
    else if ([sender.label isEqual: @"↩️"]) {
        // add a newline for the enter/return key
        [self.textDocumentProxy insertText: @"\n"];
    }
    else if ([sender.label isEqual: @"⬅️"]) {
        // delete text
        [self.textDocumentProxy deleteBackward];
    }
    else if ([sender.label isEqual: @"space"]) {
        [self setCurrentMessage: [NSString stringWithFormat: @"%@ ", currentMessage]];
        [self.textDocumentProxy insertText: @" "];
    }
    else {
        // regular key, add this character
        [self setCurrentMessage: [NSString stringWithFormat: @"%@%@", currentMessage, sender.label]];
        [self.textDocumentProxy insertText: sender.label];
        [self lowercaseTheKeyboard];
    }
}

// capitalize the keyboard
- (void)capitializeTheKeyboard {
    [self setShowCapitalLetters: true];

    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    for (KeyboardKey *key in _keyboardContainer.subviews) {
        if ([key.label rangeOfCharacterFromSet: notDigits].location != NSNotFound) {
            [key setTitle: [key.label uppercaseString] forState: UIControlStateNormal];
            [key setLabel: [key.label uppercaseString]];
        }
    }
}

// lowercase the keyboard
- (void)lowercaseTheKeyboard {
    [self setShowCapitalLetters: false];

    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    for (KeyboardKey *key in _keyboardContainer.subviews) {
        if ([key.label rangeOfCharacterFromSet: notDigits].location != NSNotFound) {
            [key setTitle: [key.label lowercaseString] forState: UIControlStateNormal];
            [key setLabel: [key.label lowercaseString]];
        }
    }
}

// ping the translate API
- (void)translateText: (NSString *) destination {
    NSMutableDictionary *post = [[NSMutableDictionary alloc]init];
    [post setValue:self.currentMessage forKey:@"text"];
    [post setValue:self.currentLanguage forKey:@"from"];
    [post setValue:destination forKey:@"to"];

    NSArray* notifications = [NSArray arrayWithObjects:post, nil];
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notifications options:kNilOptions error:&writeError];
    NSString *postLength = [NSString stringWithFormat:@"%d",[jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];

    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3000/translate"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length" ];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
        
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [theConnection start];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
    if ([response statusCode] >= 200 && [response statusCode] < 300) {
        NSData *responseData = [[NSData alloc]initWithData:urlData];
        
        NSMutableDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        for (int i = 0; i < [self.currentMessage length]; i++) {
            [self.textDocumentProxy deleteBackward];
        }
        
        NSLog(@"res: %@", jsonObject[@"res"]);
        [self setCurrentMessage: jsonObject[@"res"]];
        [self.textDocumentProxy insertText: self.currentMessage];
    } else {
       NSLog(@"Failed");
   }
}


// override functions
- (void)viewWillLayoutSubviews {
    self.nextKeyboardButton.hidden = !self.needsInputModeSwitchKey;
    [super viewWillLayoutSubviews];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    // Add custom view sizing constraints here
}

@end

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 11 -         414w x 243h
    // 12 mini -    360w x 224h
    // 13 pro max - 428w x 243
    
    // add each key to the view ✅
    // style each key ✅
    // define cusom actions
    // make emoji slider
    // draw custom features
    [self renderDefaultKeyboard];
}

//
- (void)renderDefaultKeyboard {
    // rows of keys
    NSArray *row1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"😀"];
    NSArray *row2 = @[@"q", @"w", @"e", @"r", @"t", @"y", @"u", @"i", @"o", @"p", @"⬆️"];
    NSArray *row3 = @[@"a", @"s", @"d", @"f", @"g", @"h", @"j", @"j", @"k", @"l", @"↩️"];
    NSArray *row4 = @[@"-", @"?", @"x", @"c", @"v", @"b", @"n", @"m", @".", @",", @"⬅️"];

    [self addRowOfKeys: row1 rowLevel: 0];
    [self addRowOfKeys: row2 rowLevel: 1];
    [self addRowOfKeys: row3 rowLevel: 2];
    [self addRowOfKeys: row4 rowLevel: 3];
}

// inserts the key, styles it, add the onPress handlers
- (void) addRowOfKeys:(NSArray *)row rowLevel:(int)level {
    // convert into properties
    const int keyMargin = 7;
    const float keyWidth = ([_keyboardContainer bounds].size.width - (10 * (keyMargin / 2))) / 11;
    const float keyHeight = ([_keyboardContainer bounds].size.height - 7) / 5;
    
    float xPosition = 0;
    float yPosition = level * (keyHeight + 7);
    KeyboardKey *tempKey;

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
        tempKey.frame = CGRectMake(xPosition, yPosition, keyWidth, keyHeight);
        
        // add event handler
        [tempKey setLabel: key];
        [tempKey addTarget: self action: @selector(onKeyPress:) forControlEvents: UIControlEventTouchDown];
        
        // append to the container
        [_keyboardContainer addSubview: tempKey];
        xPosition += keyWidth + keyMargin;
    }
}

- (void) onKeyPress: (KeyboardKey *) sender {
    if ([sender.label isEqual: @"😀"]) {
        // open emoji keyboard
        
    }
    else if ([sender.label isEqual: @"⬆️"]) {
        // shift key, capitalize each letter
        [self setShowCapitalLetters: !self.showCapitalLetters];
        
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        for (KeyboardKey *key in _keyboardContainer.subviews) {
            if ([key.label rangeOfCharacterFromSet: notDigits].location != NSNotFound) {
                if (self.showCapitalLetters) {
                    [key setTitle: [key.label uppercaseString] forState: UIControlStateNormal];
                    [key setLabel: [key.label uppercaseString]];
                } else {
                    [key setTitle: [key.label lowercaseString] forState: UIControlStateNormal];
                    [key setLabel: [key.label lowercaseString]];
                }
            }
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
    else {
        // regular key, add this character
        [self.textDocumentProxy insertText: sender.label];
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

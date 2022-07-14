//
//  KeyboardViewController.h
//  YoKey
//
//  Created by development on 1/30/22.
//

#import <UIKit/UIKit.h>

@interface KeyboardViewController : UIInputViewController
//{
//    BOOL showEmojiKeyboard;
//    BOOL showCapitalLetters;
//}

@property (weak, nonatomic) IBOutlet UIView *keyboardContainer;

@property (nonatomic, readwrite) BOOL showCapitalLetters;
@property (nonatomic, readwrite) BOOL showEmojiKeyboard;
@property (nonatomic, readwrite) NSString *currentLanguage;
@property (nonatomic, readwrite) NSString *currentMessage;

@end

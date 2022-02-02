//
//  KeyboardKey.h
//  YoKey
//
//  Created by development on 2/1/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyboardKey : UIButton {
    NSString *label;
}

@property (nonatomic, readwrite, retain) NSString *label;

@end

NS_ASSUME_NONNULL_END

//
//  ZYEditTextView.h
//
//  Created by zxq on 16/5/3.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEditTextViewFontThin UIFontWeightRegular
#define kEditTextViewFontBold UIFontWeightBlack

@class ZYEditTextView;

typedef void(^EditTextViewTapActionBlock)(ZYEditTextView*);
typedef void(^EditTextViewDeleteActionBlock)(ZYEditTextView*);

typedef NS_ENUM(NSInteger, ZYEditTextViewState){
    kZYEditTextViewStateNormal,        //正常状态，只显示边框，可移动，不可旋转缩放。
    kZYEditTextViewStateEdit,          //编辑状态，只显示边框，不可旋转缩放移动。
    kZYEditTextViewStateSelected,      //选中状态，可移动旋转缩放
    kZYEditTextViewStateDisable        //只显示文字。不可移动旋转缩放。
};

@interface ZYEditTextView : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, assign) CGFloat fontWeight;

@property (nonatomic, copy) EditTextViewTapActionBlock tapActionBlock;
@property (nonatomic, copy) EditTextViewDeleteActionBlock deleteActionBlock;

@property (nonatomic) ZYEditTextViewState state;

- (void)isShowHelpToolButton:(BOOL)isShow;

- (void)updateTextLableString:(NSString*)text;

- (void)updateTextColor:(UIColor*)color;

@end

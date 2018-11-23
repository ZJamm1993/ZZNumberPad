//
//  ZZNumberPad.m
//  ZZNumberPad
//
//  Created by dabby on 2018/11/23.
//  Copyright © 2018 Jam. All rights reserved.
//

#import "ZZNumberPad.h"

@interface UIResponder (ZZNumberPadFindFirstResponder)

+ (id)zzFindFirstResponder;

@end

@implementation UIResponder (ZZNumberPadFindFirstResponder)

__weak id zzFirstResponder = nil;

+ (id)zzFindFirstResponder {
    zzFirstResponder = nil;
    [UIApplication.sharedApplication sendAction:@selector(zzImFirstResponder:) to:nil from:nil forEvent:nil];
    return zzFirstResponder;
}

- (void)zzImFirstResponder:(id)sender {
    zzFirstResponder = self;
}

@end

@interface ZZNumberPad ()

@property (nonatomic, weak) id<UIKeyInput> textInput;
@property (nonatomic, strong) UIView *rightActionView;
@property (nonatomic, strong) UIView *leftActionView;

@end

@implementation ZZNumberPad

#pragma mark - frames

+ (CGFloat)insetBottomForX {
    return 25;
}

+ (BOOL)hasSafeAreaInsetBottom {
    if (@available(iOS 11, *)) {
        UIEdgeInsets inset = UIApplication.sharedApplication.keyWindow.safeAreaInsets;
        if (inset.bottom > 0) {
            return YES;
        }
    }
    return NO;
}

+ (CGRect)defaultFrame {
    CGRect rect = CGRectMake(0, 0, 100, 216);
    if (self.hasSafeAreaInsetBottom){
        rect.size.height += self.insetBottomForX;
    }
    return rect;
}

#pragma mark - inits

+ (instancetype)defaultNumberPad {
    ZZNumberPad *pad = [self.alloc initWithFrame:self.defaultFrame];
    [pad configDefault];
    return pad;
}

- (void)configDefault {
    UIColor *bgColor = UIColor.lightGrayColor;
    self.backgroundColor = bgColor;
    
    NSString *leftTitle = @"*";
    NSString *rightTitle = @"<-";
    NSArray *buttonTitles = @[@"1", @"2", @"3",
                              @"4", @"5", @"6",
                              @"7", @"8", @"9",
                              leftTitle, @"0", rightTitle];
    NSInteger count = buttonTitles.count;
    
    // i nits
    for (NSInteger i = 0; i < count; i++) {
        NSString *title = buttonTitles[i];
        UIButton *button = UIButton.alloc.init;
        button.userInteractionEnabled = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:28];
        button.backgroundColor = UIColor.whiteColor;
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        if ([title isEqualToString:leftTitle]) {
            self.leftActionView = button;
        } else if ([title isEqualToString:rightTitle]) {
            self.rightActionView = button;
        }
        [button setTitle:title forState:UIControlStateNormal];
        [self addSubview:button];
    }
}

#pragma mark - layouts

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger row = 4;
    NSInteger col = 3;
    
    CGFloat margin = 1/(UIScreen.mainScreen.scale);
    CGFloat buttonWidth = (self.frame.size.width - (col - 1) * margin) / col;
    
    CGFloat viewHeight = self.frame.size.height;
    if (self.class.hasSafeAreaInsetBottom) {
        viewHeight -= self.class.insetBottomForX;
    }
    CGFloat buttonHeight = (viewHeight - row * margin) / row;
    
    NSArray *allButtons = self.subviews;
    NSInteger count = allButtons.count;
    for (NSInteger i = 0; i < count; i++) {
        CGFloat x = (margin + buttonWidth) * (i % col);
        CGFloat y = (margin + buttonHeight) * (i / col) + margin;
        UIButton *button = allButtons[i];
        button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    }
}

#pragma mark - getter

- (id)textInput {
    if (_textInput == nil) {
        _textInput = UIResponder.zzFindFirstResponder;
    }
    return _textInput;
}

#pragma mark - actions

- (void)buttonClick:(UIButton *)button {
    if ([self.textInput conformsToProtocol:@protocol(UITextInput)]) {
        if (button == self.rightActionView) {
            [self.textInput deleteBackward];
        } else {
            NSString *currentTitle = button.currentTitle;
            [self.textInput insertText:currentTitle];
        }
    }
}

#pragma mark - highlighted

- (void)highlightButtonWithTouch:(UITouch *)touch {
    CGPoint pointOfTouch = [touch locationInView:self];
    for (UIButton *but in self.subviews) {
        BOOL shouldHighlight = CGRectContainsPoint(but.frame, pointOfTouch);
        but.backgroundColor = shouldHighlight ? UIColor.lightGrayColor : UIColor.whiteColor;
    }
}

- (void)disHighlightAllButton {
    for (UIButton *but in self.subviews) {
        but.backgroundColor = UIColor.whiteColor;
    }
}

#pragma mark - touched

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self highlightButtonWithTouch:touches.anyObject];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self disHighlightAllButton];
    CGPoint pointOfTouch = [touches.anyObject locationInView:self];
    for (UIButton *but in self.subviews) {
        if(CGRectContainsPoint(but.frame, pointOfTouch)) {
            [self buttonClick:but];
            return;
        };
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self highlightButtonWithTouch:touches.anyObject];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self disHighlightAllButton];
}

@end

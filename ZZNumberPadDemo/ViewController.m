//
//  ViewController.m
//  ZZNumberPad
//
//  Created by dabby on 2018/11/23.
//  Copyright © 2018 Jam. All rights reserved.
//

#import "ViewController.h"
#import "ZZNumberPad.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.inputView = [ZZNumberPad defaultNumberPad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

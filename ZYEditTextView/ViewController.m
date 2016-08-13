//
//  ViewController.m
//  ZYEditTextView
//
//  Created by zxq on 16/8/13.
//  Copyright © 2016年 zxq. All rights reserved.
//

#import "ViewController.h"
#import "ZYEditTextView.h"

@interface ViewController ()

@property (nonatomic, strong) ZYEditTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView = [[ZYEditTextView alloc] init];
    
    _textView.center = self.view.center;
    _textView.bounds = CGRectMake(0, 0, 200, 80);
    
    [self.view addSubview:_textView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

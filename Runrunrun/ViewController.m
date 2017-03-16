//
//  ViewController.m
//  Runrunrun
//
//  Created by renren on 17/3/8.
//  Copyright © 2017年 com.testss. All rights reserved.
//

#import "ViewController.h"
#import "RunSubClass.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

+ (void)load {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        Method originalM = class_getInstanceMethod([self class], @selector(originalMethod));
        Method swizzilingM = class_getInstanceMethod([self class], @selector(hook_originalMethod));
        
        BOOL success = class_addMethod([ViewController class], @selector(originalMethod), method_getImplementation(swizzilingM), method_getTypeEncoding(swizzilingM));
        if (success) {
            class_replaceMethod([ViewController class], @selector(hook_originalMethod), method_getImplementation(originalM), method_getTypeEncoding(originalM));
        } else {
            method_exchangeImplementations(originalM, swizzilingM);
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self originalMethod];
}


- (void)originalMethod {
    NSLog(@"haha , i'm the original method");
}

- (void)hook_originalMethod {
    [self hook_originalMethod];
    NSLog(@"haha , i'm the original method hook");
}


- (void)demoForRunSubClass {
    //
    // dynamic method resolution
    //
    RunSubClass *subClass = [[RunSubClass alloc] init];
    
    // no error at compile time
    [subClass performSelector:@selector(test)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

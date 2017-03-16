//
//  RunSubClass.m
//  Runrunrun
//
//  Created by renren on 17/3/8.
//  Copyright © 2017年 com.testss. All rights reserved.
//

#import "RunSubClass.h"
#import <objc/runtime.h>

@implementation RunSubClass


// 1.收到一个没有的方法，会先走这里
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
//    if (sel == @selector(test) || [NSStringFromSelector(sel) isEqualToString:@"test"]) {
//        class_addMethod([RunSubClass class], sel, (IMP)testResolveMethodMethod, "v@:");
//    }
    
    return [super resolveInstanceMethod:sel];
}


// 2.第二次机会处理未知的消息，需不需要转发给别人
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    return nil;
}


// 3.最后一次机会,如果第二次那里返回nil，会走这里
// 找到返回方法签名，找不到返回nil，流程结束
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"methodSignatureForSelector");

    if ([NSStringFromSelector(aSelector) isEqualToString:@"test"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

// 4. 返回方法签名会走到这一步，
// 改变调用对象等
// 当我们实现了此方法后，-doesNotRecognizeSelector:不会再被调用
// 但是如果不处理，调用父类的方法，走到NSOject，
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation");
    // 我们还可以改变方法选择器
    [anInvocation setSelector:@selector(finalMethod)];
    // 改变方法选择器后，还需要指定是哪个对象的方法
    [anInvocation invokeWithTarget:self];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"can not recognize the selector");
}

- (void)finalMethod {
    NSLog(@"all unkown methods come here");
}

void testResolveMethodMethod(id self, SEL _cmd) {
    NSLog(@" just for testing ");
}

@end

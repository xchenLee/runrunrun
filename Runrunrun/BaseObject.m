//
//  BaseObject.m
//  Runrunrun
//
//  Created by renren on 17/3/13.
//  Copyright © 2017年 com.testss. All rights reserved.
//

#import "BaseObject.h"
#import <objc/runtime.h>

@implementation BaseObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (NSInteger i = 0; i < count; i ++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKeyPath:key];
        }
        free(ivars);
    }
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i ++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [self valueForKeyPath:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

@end

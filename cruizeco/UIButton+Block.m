//
//  UIButton+Block.m
//  2H
//
//  Created by Kishor Kundan on 12/22/14.
//  Copyright (c) 2014 One Platinum. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>


@implementation UIButton (Block)

static char overviewKey;

@dynamic actions;

- (void) setAction:(NSString*)action withBlock:(void(^)())block {
    
    if ([self actions] == nil) {
        [self setActions:[[NSMutableDictionary alloc] init]];
    }
    
    [[self actions] setObject:[block copy] forKey:action];
    
    if ([kUIButtonBlockTouchUpInside isEqualToString:action]) {
        [self addTarget:self action:@selector(doTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setActions:(NSMutableDictionary*)actions {
    objc_setAssociatedObject (self, &overviewKey,actions,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)actions {
    return objc_getAssociatedObject(self, &overviewKey);
}

- (void)doTouchUpInside:(id)sender {
    void(^block)();
    block = [[self actions] objectForKey:kUIButtonBlockTouchUpInside];
    block(sender);
}
@end

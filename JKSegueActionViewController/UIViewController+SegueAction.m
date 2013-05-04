//
//  UIViewController+SegueAction.m
//  JKSegueActionViewController
//
//  Created by Joseph Kain on 5/4/13.
//  Copyright (c) 2013 Joseph Kain.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

#import "UIViewController+SegueAction.h"
#import <objc/message.h>

static char *JKSegueActionMapKey = "JKSegueActionMapKey";


@implementation UIViewController (SegueAction)

- (NSMutableDictionary *) map {
    NSMutableDictionary *map = objc_getAssociatedObject(self, &JKSegueActionMapKey);
    if (!map) {
        map = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &JKSegueActionMapKey, map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return map;
}

- (BOOL)hasBlockForSegue:(UIStoryboardSegue *)segue {
    NSMutableDictionary *map = [self map];
    
    return map[segue.identifier] != nil;
}

- (void)performBlockForSegue:(UIStoryboardSegue *)segue withSender:(id)sender {
    NSMutableDictionary *map = [self map];

    JKSegueActionBlock block = (JKSegueActionBlock)map[segue.identifier];
    block(sender);
}

-(void)invokeSelectorForSegue:(UIStoryboardSegue *)segue withSender:(id)sender {
    SEL selector = NSSelectorFromString(segue.identifier);
    
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:segue withObject:sender];
#pragma clang diagnostic pop
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([self hasBlockForSegue:segue]) {
        [self performBlockForSegue:segue withSender:sender];
    } else {
        [self invokeSelectorForSegue:segue withSender:sender];
    }
}

- (void) setActionForSegueWithIdentifier:(NSString *)identifier toBlock:(JKSegueActionBlock) block {
    NSMutableDictionary *map = [self map];

    map[identifier] = block;
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender withBlock:(JKSegueActionBlock) block
{
    NSMutableDictionary *map = [self map];

    JKSegueActionBlock savedBlock = map[identifier];
    
    // This isn't threadsafe but then again UIKit should only be used from the main thread so this is OK?
    map[identifier] = block;
    [self performSegueWithIdentifier:identifier sender:sender];
    
    if (savedBlock) {
        map[identifier] = savedBlock;
    } else {
        [map removeObjectForKey:identifier];
    }
}
@end

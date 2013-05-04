//
//  JKSegueActionViewController.m
//  JKSegueActionViewController
//
//  Created by Joseph Kain on 5/3/13.
//
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

#import "JKSegueActionViewController.h"


@interface JKSegueActionViewController () {
    NSMutableDictionary *segueToBlockMap;
}
@end

@implementation JKSegueActionViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        segueToBlockMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)hasBlockForSegue:(UIStoryboardSegue *)segue {
    return segueToBlockMap[segue.identifier] != nil;
}

- (void)performBlockForSegue:(UIStoryboardSegue *)segue withSender:(id)sender {
    JKSegueActionBlock block = (JKSegueActionBlock)segueToBlockMap[segue.identifier];
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
    segueToBlockMap[identifier] = block;
}

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender withBlock:(JKSegueActionBlock) block
{
    JKSegueActionBlock savedBlock = segueToBlockMap[identifier];

    // This isn't threadsafe but then again UIKit should only be used from the main thread so this is OK?
    segueToBlockMap[identifier] = block;
    [self performSegueWithIdentifier:identifier sender:sender];
    
    if (savedBlock) {
        segueToBlockMap[identifier] = savedBlock;
    } else {
        [segueToBlockMap removeObjectForKey:identifier];
    }
}

@end

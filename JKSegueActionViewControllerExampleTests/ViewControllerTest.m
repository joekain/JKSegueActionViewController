//
//  JKSegueActionViewController - ViewControllerTest.m
//
//  Created by Joseph Kain on 5/3/13.
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

#import <SenTestingKit/SenTestingKit.h>
#import "ViewController.h"

@interface ViewControllerTest : SenTestCase
@end

@implementation ViewControllerTest
{
    ViewController *sut;
}

- (void)setUp
{
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    sut = [storyboard instantiateInitialViewController];
}

- (void)testSegueShouldInvokeAction
{
    [sut performSegueWithIdentifier:@"actionWithSegue:sender:" sender:self];
    STAssertEqualObjects(sut.state, @"Action", @"Segue named \"actionWithSegue:sender:\" should set state \"Action\"");
}

- (void)testSegueShouldInvokeSecondAction
{
    [sut performSegueWithIdentifier:@"secondActionWithSegue:sender:" sender:self];
    STAssertEqualObjects(sut.state, @"Second", @"Segue named \"secondActionWithSegue:sender:\" set state \"Second\"");
}

- (void)testViewControllerShouldSetActionForSegue
{
    __block BOOL blockInvoked = NO;
    __weak id weakSelf = self;

    [sut setActionForSegueWithIdentifier:@"segueWithBlock" toBlock:^(id sender) {
        if (sender == weakSelf) {
            blockInvoked = YES;
        }
    }];
    
    [sut performSegueWithIdentifier:@"segueWithBlock" sender:self];
    STAssertEquals(blockInvoked, YES, @"Block must be invoked for segue");
}

- (void)testPerformSegueWithBlockShouldInvokeBlock
{
    __block BOOL blockInvoked = NO;
    __weak id weakSelf = self;
    
    [sut performSegueWithIdentifier:@"segueWithBlockOnPerform" sender:self withBlock:^(id sender) {
        if (sender == weakSelf) {
            blockInvoked = YES;
        }
    }];
    STAssertEquals(blockInvoked, YES, @"Block must be invoked for performSegueWithIdentifier:sender:withBlock:");
}

- (void)testPerformSegueWithBlockShouldSetBlockTransiently
{
    __block BOOL blockInvoked = NO;
    __weak id weakSelf = self;

    [sut setActionForSegueWithIdentifier:@"segueWithBlockOnPerform" toBlock:^(id sender) {
        if (sender == weakSelf) {
            blockInvoked = YES;
        }
    }];

    [sut performSegueWithIdentifier:@"segueWithBlockOnPerform" sender:self withBlock:^(id sender) {
        // Do nothing
    }];

    [sut performSegueWithIdentifier:@"segueWithBlockOnPerform" sender:self];
    STAssertEquals(blockInvoked, YES, @"Block must be invoked for performSegueWithIdentifier:sender:withBlock:");
}

- (void)testSegueWithoutActionShouldRaiseException
{
    STAssertNoThrow([sut performSegueWithIdentifier:@"segueWithoutAction" sender:self],
                    @"No exception for \"segueWithoutAction\"");
}

@end

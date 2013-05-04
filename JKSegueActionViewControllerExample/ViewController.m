//
//  ViewController.m
//  JKSegueActionViewControllerExample
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

#import "ViewController.h"

@implementation ViewController

#pragma mark - Named action for Segue with sender

// This is an example that uses the default Segue Action.  The segue has an identifier named
// actionWithSegue:sender: and will invoke the method actionWithSegue:sender: in preparation.
// This makes it simple to attach segue actions in Interface Builder by naming the segue
// identifier and action with the same name.

- (void)actionWithSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"Action for actionWithSegue:sender:");
    self.state = @"Action";
}

- (IBAction)onButtonActionExample:(id)sender {
    [self performSegueWithIdentifier:@"actionWithSegue:sender:" sender:self];
}



#pragma mark - Named action for Segue without sender

// This is the same as the previous example but the action omits the sender: argument.  This is
// a convinient shorthand if the sender isn't needed in the action.

- (void)secondActionWithSegue:(UIStoryboardSegue *)segue {
    NSLog(@"Action for secondActionWithSegue:");
    self.state = @"Second";
}

- (IBAction)onButtonSecondActionExample:(id)sender {
    [self performSegueWithIdentifier:@"secondActionWithSegue:" sender:self];
}



#pragma mark - Pre-set block action

// This example shows how to set a block to be used for a specific segue.  The block is retained
// and used on each perfomance of the segue.  The block can be set at any time (i.e. in viewDidLoad)

- (IBAction)onButtonBlockExample:(id)sender {
    [self setActionForSegueWithIdentifier:@"segueWithBlock" toBlock:^(id theSender) {
        NSLog(@"Block for segueWithBlock");
    }];
    
    [self performSegueWithIdentifier:@"segueWithBlock" sender:self];
}



#pragma mark - Immediate block action

// This example is my preferred style.  It demonstrates a block to be used as a segue action
// coupled with a call to perform the segue.  This keeps the code to prepare and initiate the
// segue local and makes the whole segue easier to understand.

- (IBAction)onButtonBlockOnPerformExample:(id)sender {
    [self performSegueWithIdentifier:@"segueWithBlockOnPerform" sender:self withBlock:^(id theSender) {
        NSLog(@"Block for segueWithBlockOnPerform");
    }];
}



#pragma mark - Normal prepareForSegue:sender:

// This example shows that the normal prepareForSegue:sender: method can still be used.  Just
// make sure to call [super prepareForSegue:segue sender:sender].

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"segueWithoutAction"]) {
        NSLog(@"prepareForSegue:sender: for segueWithoutAction");
        self.state = @"Manual";
    }
}

- (IBAction)onButtonWithActionExample:(id)sender {
    [self performSegueWithIdentifier:@"segueWithoutAction" sender:self];
}



#pragma mark - Unwind action (Unrelated to Segue Actions)
- (IBAction)done:(UIStoryboardSegue *)segue {

}
@end

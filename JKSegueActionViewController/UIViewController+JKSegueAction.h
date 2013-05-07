//
//  UIViewController+JKSegueAction.h
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
#import <UIKit/UIKit.h>

typedef void (^JKSegueActionBlock)(UIStoryboardSegue *, id);

/** The JKSegueAction category provides additional functionality to the UIViewController class that
 can ease the task of preparing for segues.
*/
@interface UIViewController (JKSegueAction)


/** Sets a block to be used as the prepare action for a segue.

 You can call this method to set a block that will be invoked to prepare the named segue when
 it is triggered.

 @param identifier The string that identifies the segue inside the storyboard file.
 @param block A block called when the segue is triggered that can pass relevant data to the
        new view controller.  The segue object passed to the block includes references to both view
        controllers involved in the segue.
*/
- (void) setActionForSegueWithIdentifier:(NSString *)identifier toBlock:(JKSegueActionBlock) block;


/** Initiates the segue with the sepecified identify from the view controller's storyboard file.

 You can call this method to trigger and prepare a segue programmatiically.

 The view controller that receives this message must have been loaded from a storyboard. If the
 view controller does not have an associated storyboard, perhaps because you allocated and
 initialized it yourself, this method throws an exception.

 @param identifier The string that identifies the segue inside the storyboard file.
 @param sender The object that you want to use to initiate the segue.  This object is made available
        for informational purposes in block
 @param block A block called when the segue is triggered that can pass relevant data to the
        new view controller.  The segue object passed to the block includes references to both view
        controllers involved in the segue.
 */

- (void) performSegueWithIdentifier:(NSString *)identifier sender:(id)sender withBlock:(JKSegueActionBlock) block;
@end

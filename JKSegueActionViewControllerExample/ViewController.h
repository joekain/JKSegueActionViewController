//
//  ViewController.h
//  JKSegueActionViewControllerExample
//
//  Created by Joseph Kain on 5/3/13.
//  Copyright (c) 2013 Joseph Kain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSegueActionViewController.h"

@interface ViewController : JKSegueActionViewController

// test point
@property (strong, nonatomic) NSString* state;
- (IBAction)done:(UIStoryboardSegue *)segue;
@end

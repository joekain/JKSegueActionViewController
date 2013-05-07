# JKSegueActionViewController

## Installation
### CocoaPods

Add pod 'JKSegueActionViewController' to your Podfile.

## Using JKSegueActionViewController

Without JKSegueActionViewController you end up having to write something like this:

```objective-c
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifer isEqualToString:@"MySegue1"]) {
		MyCustomViewController *vc = segue.destinationViewController;
		vc.delegate = self;
	} else if ([segue.identifer isEqualToString:@"MySegue2"]) {
		MyOtherCustomViewController *vc = segue.destinationViewController;
		vc.someProperty = [self computeSomeValue];
	} else if ([segue.identifer isEqualToString:@"MySegue3"]) {
		MyCustomTableViewController *vc = segue.destinationViewController;
		vc.delegate = self;
		vc.dataSource = [self dataSourceForObject:someObject];
	}
}
```

JKSegueActionViewController is for developers that find -[UIViewController prepareSegue:sender:]
a poor tool for code organization.  JKSegueActionViewController provides a cleaner design that
can be used to implement easier to follow code.

### Segue Actions from Interface Builder

First use Interface Builder to set the identifier of your segue to the method with your preparation
code.

![Segue in interface builder](http://www.antipodalapps.com/wp-content/uploads/2013/05/Screen-Shot-2013-05-07-at-12.34.27-AM.png)

Then implement a method with the same signature used in the segue identifier:

```objective-c
-(void) segueToMySceneAction:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the destination view controller
    MyOtherCustomViewController *vc = segue.destinationViewController;
    vc.someProperty = [self computeSomeValue];
}
```

JKSegueActionViewController will automatically invoke your method when the segue is triggered.

### Segue Blocks

JKSegueActionViewController adds a method to UIViewController to manually perform a segue
using a block for preparation.  It allows you to write code that keeps your perform and
prepare code together to make it easier to find, read, and understand.

```objective-c
[self performSegueWithIdentifier:@"MySegue1" sender:self withBlock:^(UIStoryboardSegue *segue, id sender) {
    // Prepare the destination view controller
    MyCustomViewController *vc = segue.destinationViewController;
    vc.delegate = self;
}];
```

## Full API

### Named segue action

Write a segue action method and give the segue the method name as its identifier.
JKSegueActionViewController will invoke your action automatically.

```objective-c
-(void) segueToMySceneAction:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the destination view controller
    MyOtherCustomViewController *vc = segue.destinationViewController;
    vc.someProperty = [self computeSomeValue];
}
```

### Named segue action without a sender

Just like the named segue action above but omit the sender argument.

```objective-c
-(void) segueToMySceneAction:(UIStoryboardSegue *)segue {
    // Prepare the destination view controller
    MyOtherCustomViewController *vc = segue.destinationViewController;
    vc.someProperty = [self computeSomeValue];
}
```

### performSegueWithIdentifier: sender: withBlock:

When performing a segue manually, use this method instead of the
traditional performSegueWithIdentifier:sender.  Pass a block to prepare for your segue.

```objective-c
[self performSegueWithIdentifier:@"MySegue2" sender:self withBlock:^(UIStoryboardSegue *segue, id sender) {
    // Prepare the destination view controller
    MyCustomViewController *vc = segue.destinationViewController;
    vc.delegate = self;
}];
```

### setActionForSegueWithIdentifier: toBlock:

When you have a segue that you will perform manually you can use this method to setup a block
to use everytime the segue is performed.

```objective-c
- (void) viewDidLoad {
    [super viewDidLoad]
 
    [self setActionForSegueWithIdentifier:@"MySegue3" toBlock:^(id theSender) {
        // Prepare the destination view controller
        MyCustomTableViewController *vc = segue.destinationViewController;
 
        vc.delegate = self;
        vc.dataSource = [self dataSourceForObject:someObject];
    }];
}
 
- (void) someOtherMethod {
    // This will perform the segue and then invoke the action block registered in -viewDidLoad
    [self performSegueWithIdentifier:@"MySegue3" sender:self];
}
```

### prepareForSegue:sender:

If you find that you want or need to use the traditional prepareForSegue:sender: you still can.  Just
implement your own copy of prepareForSegue:sender: in all its string matching glory.  Just make sure
to call [super prepareForSegue:sender:] otherwise you'll break JKSegueActionViewController's logic.

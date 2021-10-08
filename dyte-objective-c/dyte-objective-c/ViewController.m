//
//  ViewController.m
//  dyte-objective-c
//
//  Created by Rohit Bhatia on 7/22/21.
//

#import "ViewController.h"
@import DyteSdk;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)joinMeeting:(UIButton *)sender {
    DyteMeetingConfig *meetingConfig = [[DyteMeetingConfig alloc] init];
      meetingConfig.roomName = @"hazel-mile";
      meetingConfig.width = self.view.frame.size.width;
      meetingConfig.height = self.view.frame.size.height;
      DyteMeetingView *dyteView = [[DyteMeetingView alloc] initWithFrame:CGRectMake(0.0, 0.0, meetingConfig.width, meetingConfig.height)];
      dyteView.delegate = self;
      dyteView.tag = 100;
      [self.view addSubview:dyteView];
      [dyteView join:meetingConfig];
}

- (void)meetingEnded {
  dispatch_async(dispatch_get_main_queue(), ^{
    for (UIView *view in [self.view subviews])
    {
      if (view.tag == 100) {
        [view removeFromSuperview];
      }
    }
  });
}



@end

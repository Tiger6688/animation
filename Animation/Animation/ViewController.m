//
//  ViewController.m
//  Animation
//
//  Created by DoLH on 5/20/14.
//  Copyright (c) 2014 Ominext. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"

@interface ViewController (){
    IBOutlet UIView *thirdView;
    
    IBOutlet UIView *aView;
    IBOutlet UIView *anotherView;
    
    UIView *primaryView;
    UIView *secondaryView;
    BOOL displayingPrimary;
    
    IBOutlet UIView *backingView;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    primaryView = [[UIView alloc] initWithFrame:CGRectMake(177, 231, 38, 32)];
    primaryView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:primaryView];
    
    secondaryView = [[UIView alloc] initWithFrame:CGRectMake(245, 231, 38, 32)];
    secondaryView.backgroundColor = [UIColor redColor];
    // add
    [self.view addSubview:secondaryView];
    
    
//    [self.view insertSubview:primaryView aboveSubview:anotherView];
//    [self.view insertSubview:secondaryView belowSubview:anotherView];
//    [self.view insertSubview:thirdView atIndex:2];
//    [anotherView superview];
//    [self.view subviews];
//    [anotherView removeFromSuperview];
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
//    [anotherView setContentMode:UIViewContentModeScaleAspectFill];
//    [anotherView setContentStretch:CGRectMake(0, 0, 30, 30)];
//    UIImage *image;
//    CGFloat top,left, bottom, right;
//    [[UIImage imageNamed:@"icon.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)];
//    anotherView.center = self.view.center;
//    anotherView.clipsToBounds = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHideView:(id)sender
{
    // Fade out the view right away
    [UIView animateWithDuration:1.0
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         thirdView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:1.0
                                               delay: 1.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              thirdView.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
}

- (IBAction)showHideViewOption:(id)sender
{
    [UIView beginAnimations:@"ShowHideView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showHideDidStop:finished:context:)];
    
    // Make the animatable changes.
    thirdView.alpha = 0.0;
    
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
}

// Called at the end of the preceding animation.
- (void)showHideDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:@"ShowHideView2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.0];
    
    thirdView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (IBAction) nestingAnimation:(id)sender{
    [UIView animateWithDuration:1.0
                          delay: 1.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         aView.alpha = 0.0;
                         
                         // Create a nested animation that has a different
                         // duration, timing curve, and configuration.
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options: UIViewAnimationOptionOverrideInheritedCurve |
                          UIViewAnimationOptionCurveLinear |
                          UIViewAnimationOptionOverrideInheritedDuration |
                          UIViewAnimationOptionRepeat |
                          UIViewAnimationOptionAutoreverse
                                          animations:^{
                                              [UIView setAnimationRepeatCount:2.5];
                                              anotherView.alpha = 0.0;
                                          }
                                          completion:nil];
                         
                     }
                     completion:nil];

}

- (IBAction)toggleMainViews:(id)sender {
    [UIView transitionFromView:(displayingPrimary ? primaryView : secondaryView)
                        toView:(displayingPrimary ? secondaryView : primaryView)
                      duration:1.0
                       options:(displayingPrimary ? UIViewAnimationOptionTransitionFlipFromRight :
                                UIViewAnimationOptionTransitionFlipFromLeft)
                    completion:^(BOOL finished) {
                        if (finished) {
                            displayingPrimary = !displayingPrimary;
//                            NSLog(@"pri x %f, y %f, w %f, h %f",primaryView.frame.origin.x, primaryView.frame.origin.y, primaryView.frame.size.width, primaryView.frame.size.height);
                        }
                    }];
}

- (IBAction)mixView:(id)sender {
[UIView animateWithDuration:1.0
                      delay:0.0
                    options: UIViewAnimationOptionCurveLinear
                 animations:^{
                     // Animate the first half of the view rotation.
                     CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-180));
                     backingView.transform = xform;
                     
                     // Rotate the embedded CALayer in the opposite direction.
                     CABasicAnimation*    layerAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
                     layerAnimation.duration = 2.0;
                     layerAnimation.beginTime = 0; //CACurrentMediaTime() + 1;
                     layerAnimation.valueFunction = [CAValueFunction functionWithName:kCAValueFunctionRotateZ];
                     layerAnimation.timingFunction = [CAMediaTimingFunction
                                                      functionWithName:kCAMediaTimingFunctionLinear];
                     layerAnimation.fromValue = [NSNumber numberWithFloat:0.0];
                     layerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(360.0)];
                     layerAnimation.byValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180.0)];
                     [self.view.layer addAnimation:layerAnimation forKey:@"layerAnimation"];
                 }
                 completion:^(BOOL finished){
                     // Now do the second half of the view rotation.
                     [UIView animateWithDuration:1.0
                                           delay: 0.0
                                         options: UIViewAnimationOptionCurveLinear
                                      animations:^{
                                          CGAffineTransform  xform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-359));
                                          backingView.transform = xform;
                                      }
                                      completion:^(BOOL finished){
                                          backingView.transform = CGAffineTransformIdentity;
                                      }];
                 }];
}

- (IBAction)pushViewAnimation:(id)sender{
    
    NewViewController *newVC = [[NewViewController alloc] initWithNibName:@"NewViewController" bundle:nil];
//    [UIView  beginAnimations: @"Showinfo"context: nil];
//    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.75];
//    [self.navigationController pushViewController: newVC animated:NO];
////    [self presentViewController:newVC animated:YES completion:nil];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
//    [UIView commitAnimations];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromTop;//kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [[self navigationController] popViewControllerAnimated:NO];
    [self.navigationController pushViewController: newVC animated:NO];
}

@end

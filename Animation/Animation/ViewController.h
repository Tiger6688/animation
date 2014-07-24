//
//  ViewController.h
//  Animation
//
//  Created by DoLH on 5/20/14.
//  Copyright (c) 2014 Ominext. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController : UIViewController{
    
}

- (IBAction) nestingAnimation:(id)sender;

@end

//
//  LaneDetectorBridge.h
//  jLaneDetection
//
//  Created by Jo Hyuk Jun on 01/10/2019.
//  Copyright © 2019 Jo Hyuk Jun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LaneDetectorBridge : NSObject
    
- (UIImage *) detectLaneIn: (UIImage *) image;

- (NSArray<NSValue *> *) detectLanePoint: (UIImage *) image;
    
@end



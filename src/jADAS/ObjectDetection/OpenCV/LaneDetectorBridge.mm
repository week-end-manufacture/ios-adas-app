//
//  LangeDetectorBridge.m
//  jLaneDetection
//
//  Created by Jo Hyuk Jun on 01/10/2019.
//  Copyright © 2019 Jo Hyuk Jun. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Foundation/Foundation.h>
#import "LaneDetectorBridge.h"
#include "LaneDetector.hpp"

@implementation LaneDetectorBridge
    
- (UIImage *) detectLaneIn: (UIImage *) image {
    
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, CV_RGBA2RGB);
    
    // Run lane detection
    LaneDetector laneDetector;
    cv::Mat imageWithLaneDetected = laneDetector.detect_lane(convertedColorSpaceImage);
    
    // convert mat to uiimage and return it to the caller
    return MatToUIImage(imageWithLaneDetected);
}

- (NSArray<NSValue *> *) detectLanePoint: (UIImage *) image {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, CV_RGBA2RGB);
    
    // Run lane detection
    LaneDetector laneDetector;
    vector<cv::Point> lanePoint = laneDetector.detect_point(convertedColorSpaceImage);
    CGPoint res[5];
    res[0] = CGPointMake(lanePoint[0].x, lanePoint[0].y);
    res[1] = CGPointMake(lanePoint[1].x, lanePoint[1].y);
    res[2] = CGPointMake(lanePoint[2].x, lanePoint[2].y);
    res[3] = CGPointMake(lanePoint[3].x, lanePoint[3].y);
    
    return @[
    [NSValue valueWithCGPoint:CGPointMake(lanePoint[0].x, lanePoint[0].y)],
    [NSValue valueWithCGPoint:CGPointMake(lanePoint[1].x, lanePoint[1].y)],
    [NSValue valueWithCGPoint:CGPointMake(lanePoint[2].x, lanePoint[2].y)],
    [NSValue valueWithCGPoint:CGPointMake(lanePoint[3].x, lanePoint[3].y)],
    ];
}
    
@end

//
//  ITSlideTransition.m
//  ITTransitionView-Demo
//
//  Created by Ilija Tovilo on 20/01/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

#import "ITSlideTransition.h"
#import <QuartzCore/QuartzCore.h>

@implementation ITSlideTransition

- (void)prepareForUsage {
    const CGFloat viewWidth = self.transitionViewBounds.size.width;
    const CGFloat viewHeight = self.transitionViewBounds.size.height;
    const CGFloat scaleFactor = 0.7f;
    
    CATransform3D inTranslationTransform;
    CATransform3D outTranslationTransform;
    switch (self.orientation) {
        case ITTransitionOrientationRightToLeft:
        {
            inTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, viewWidth, 0, 0);
            outTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, -viewWidth, 0, 0);
        }
            break;
        case ITTransitionOrientationLeftToRight:
        {
            inTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, -viewWidth, 0, 0);
            outTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, viewWidth, 0, 0);
        }
            break;
        case ITTransitionOrientationTopToBottom:
        {
            inTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -viewHeight, 0);
            outTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, viewHeight, 0);
        }
            break;
        case ITTransitionOrientationBottomToTop:
        {
            inTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, viewHeight, 0);
            outTranslationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -viewHeight, 0);
        }
            break;
        default:
            NSAssert(FALSE, @"Unhandled ADTransitionOrientation");
            break;
    }
    
    CATransform3D inScaleDownTransform = CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1.0f);
    CATransform3D inTranslationScaleTransform = CATransform3DScale(inTranslationTransform, scaleFactor, scaleFactor, 1.0f  );
    CAKeyframeAnimation * inKeyFrameTransformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    inKeyFrameTransformAnimation.values = @[[NSValue valueWithCATransform3D:inTranslationTransform],
                                            [NSValue valueWithCATransform3D:inTranslationScaleTransform],
                                            [NSValue valueWithCATransform3D:inScaleDownTransform],
                                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    CAKeyframeAnimation * inKeyFrameOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    inKeyFrameOpacityAnimation.values = @[@0.0f,
                                          @0.0f,
                                          @0.5f,
                                          @1.0f];
    
    CABasicAnimation * inZPositionAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    inZPositionAnimation.fromValue = @-0.001;
    inZPositionAnimation.toValue = @-0.001;
    
    CAAnimationGroup * inAnimation = [CAAnimationGroup animation];
    inAnimation.animations = @[inKeyFrameTransformAnimation, inKeyFrameOpacityAnimation, inZPositionAnimation];
    inAnimation.duration = self.duration;
    
    CATransform3D outScaleDownTransform = CATransform3DScale(CATransform3DIdentity, scaleFactor, scaleFactor, 1.0f);
    CATransform3D outTranslationScaleTransform = CATransform3DScale(outTranslationTransform, scaleFactor, scaleFactor, 1.0f  );
    
    CAKeyframeAnimation * outKeyFrameTransformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    outKeyFrameTransformAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity],
                                             [NSValue valueWithCATransform3D:outScaleDownTransform],
                                             [NSValue valueWithCATransform3D:outTranslationScaleTransform],
                                             [NSValue valueWithCATransform3D:outTranslationTransform]];
    
    CAKeyframeAnimation * outKeyFrameOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    outKeyFrameOpacityAnimation.values = @[@1.0f,
                                           @0.5f,
                                           @0.0f,
                                           @0.0f];
    
    CABasicAnimation * outZPositionAnimation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
    outZPositionAnimation.fromValue = @-0.001;
    outZPositionAnimation.toValue = @-0.001;
    
    CAAnimationGroup * outAnimation = [CAAnimationGroup animation];
    outAnimation.animations = @[outKeyFrameTransformAnimation, outKeyFrameOpacityAnimation, outZPositionAnimation];
    outAnimation.duration = self.duration;
    
    self.inAnimation = inAnimation;
    self.outAnimation = outAnimation;
}

@end

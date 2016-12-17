//
//  UIImageView+GIF.h
//  JSONForcast
//
//  Created by Yazhong Luo on 12/16/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(GIF)

-(void)showGifImageWithData:(NSData *)data;
-(void)showGifImageWithData:(NSData *)data WithDuration:(NSTimeInterval)setduration;

@end
